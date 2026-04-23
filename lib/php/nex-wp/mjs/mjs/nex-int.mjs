
export function nxInt()
{

}

nxInt.toBigInt = n => {
	if (typeof n === "bigint")
		return n;
	if (typeof n === "number")
		return BigInt(n);
	if (typeof n === "string")
		return BigInt(n.trim());
	throw new TypeError("Unsupported type for bigint conversion");
}


const MR_TABLE = [
		[2047n,			[2n]],
		[1373653n,			[2n,3n]],
		[9080191n,			[31n,73n]],
		[25326001n,			[2n,3n,5n]],
		[3215031751n,		[2n,3n,5n,7n]],
		[4759123141n,		[2n,7n,61n]],
		[1122004669633n,		[2n,13n,23n,1662803n]],
		[2152302898747n,		[2n,3n,5n,7n,11n]],
		[3474749660383n,		[2n,3n,5n,7n,11n,13n]],
		[341550071728321n,		[2n,3n,5n,7n,11n,13n,17n]],
		[3825123056546413051n,	[2n,3n,5n,7n,13n,17n,19n,23n]],
		[318665857834031151167461n, [2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n]],
		[3317044064679887385961981n,[2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n,41n,43n,47n,53n]]
];

const MR64 = [
		2n, 325n, 9375n, 28178n, 450775n, 9780504n, 1795265022n
];

nxInt.getWitnesses = n => {
	if (n < (1n << 64n))
		return MR64;
	let lo = 0, hi = MR_TABLE.length - 1;
	while (lo < hi) {
		const mid = (lo + hi) >> 1;
		if (n < MR_TABLE[mid][0]) hi = mid;
		else lo = mid + 1;
	}
	return MR_TABLE[lo][1];
}

// --- small primes & quick filters ------------------------------------------

nxInt.smallPrimeCheck = n => {
	if (n < 2n) return false;
	for (const p of SMALL_PRIMES) {
		if (n === p)
			return true;
		if (n % p === 0n)
			return false;
	}
	return null;
}

// --- modular arithmetic -----------------------------------------------------

nxInt.modPow = (base, exp, mod) => {
	base %= mod;
	let result = 1n;
	while (exp > 0n) {
		if (exp & 1n)
			result = (result * base) % mod;
		base = (base * base) % mod;
		exp >>= 1n;
	}
	return result;
}

nxInt.decomposeNMinus1(n) {
	// n - 1 = d * 2^s, with d odd
	let d = n - 1n;
	let s = 0n;
	while ((d & 1n) === 0n) {
		d >>= 1n;
		s++;
	}
	return { d, s };
}

// --- deterministic bases ----------------------------------------------------

// Deterministic for all 64-bit integers: 0 < n < 2^64
// (Jaeschke + later refinements)
const MR_BASES_64 = [
	2n, 325n, 9375n, 28178n, 450775n, 9780504n, 1795265022n
];

// Extended table (deterministic up to large proven bounds)
const MR_TABLE = [
    [2047n,                     [2n]],
    [1373653n,                  [2n,3n]],
    [9080191n,                  [31n,73n]],
    [25326001n,                 [2n,3n,5n]],
    [3215031751n,               [2n,3n,5n,7n]],
    [4759123141n,               [2n,7n,61n]],
    [1122004669633n,            [2n,13n,23n,1662803n]],
    [2152302898747n,            [2n,3n,5n,7n,11n]],
    [3474749660383n,            [2n,3n,5n,7n,11n,13n]],
    [341550071728321n,          [2n,3n,5n,7n,11n,13n,17n]],
    [3825123056546413051n,      [2n,3n,5n,7n,13n,17n,19n,23n]],
    [318665857834031151167461n, [2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n]],
    [3317044064679887385961981n,[2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n,41n,43n,47n,53n]]
];

nxInt.getDeterministicBases(n) {
	// Fast path: full 64-bit range
	if (n < (1n << 64n))
		return MR_BASES_64;
	// Otherwise, use the extended table (up to its proven bound)
	for (const [bound, bases] of MR_TABLE)
		if (n < bound)
			return bases;
	// Beyond last bound: we’ll treat MR as probabilistic (caller can add random bases)
	return MR_TABLE[MR_TABLE.length - 1][1];
}

// --- core Miller–Rabin step -----------------------------------------------

nxInt.millerRabinWithBases(n, bases) {
	const { d, s } = nxInt.decomposeNMinus1(n);
	for (const a0 of bases) {
		const a = a0 % n;
		if (a === 0n)
			continue;
		let x = modPow(a, d, n);
		if (x === 1n || x === n - 1n)
			continue;
		let composite = true;
		for (let r = 1n; r < s; r++) {
			x = (x * x) % n;
			if (x === n - 1n) {
				composite = false;
				break;
			}
		}
		if (composite)
			return false;
	}
	return true;
}

// --- public API -------------------------------------------------------------

// Deterministic for n < 2^64, deterministic up to MR_TABLE’s bound,
// probabilistic (but very strong) beyond that if extraBases > 0.
nxInt.isPrime(n, extraBases = 0) {
	n = nxInt.toBigInt(n);

	// trivial & small primes
	const small = nxInt.smallPrimeCheck(n);
	if (small !== null)
		return small;

	// even numbers
	if ((n & 1n) === 0n)
		return false;

	// deterministic bases for the range
	const bases = [...nxInt.getDeterministicBases(n)];

	// optional extra random bases for huge n
	for (let i = 0; i < extraBases; i++) {
		// random base in [2, n-2]
		const a = 2n + (BigInt(Math.floor(Math.random() * 1e9)) % (n - 3n));
		bases.push(a);
	}

	return nxInt.millerRabinWithBases(n, bases);
}

// A lighter “probable prime” wrapper if you want explicitly probabilistic behavior
nxInt.isProbablePrime = (n, rounds = 16) => {
	n = nxInt.toBigInt(n);
	const small = nxInt.smallPrimeCheck(n);
	if (small !== null)
		return small;
	if ((n & 1n) === 0n)
		return false;
	const { d, s } = decomposeNMinus1(n);

	for (let k = 0; k < rounds; k++) {
		const a = 2n + (BigInt(Math.floor(Math.random() * 1e9)) % (n - 3n));
		let x = nxInt.modPow(a, d, n);
		if (x === 1n || x === n - 1n)
			continue;
		let composite = true;
		for (let r = 1n; r < s; r++) {
			x = (x * x) % n;
			if (x === n - 1n) {
				composite = false;
				break;
			}
		}
		if (composite)
			return false;
	}
	return true;
}

