
export class nxBit32
{
	static on(b, s) {
		return b | (1 << --s);
	}

	static off(b, s) {
		return b & ~(1 << --s);
	}

	static flip(b, s) {
		return b ^ (1 << --s);
	}

	static is(b, s) {
		return (b & (1 << --s)) !== 0;
	}

	static diverge(b, s) {
		return b ^ b >> --s;
	}

	static cascade(b, s) {
		return b | b >> --s;
	}

	static next(b) {
		b--;
		if (b < 2)
			return 2;
		for (const n of [ 1, 2, 4, 8, 16 ])
			b = nxBit32.cascade(b, n);
		return b++;
	}

	static parity(b) {
		for (const n of [ 16, 8, 4, 3, 1 ])
			b = nxBit32.diverge(b, n);
		return (b & 1) === 0;
	}

	static count(b) {
		let c = 0;
		while (b !== 0) {
			b = b & (b - 1);
			c++;
		}
		return c;
	}

	static isEven(b) {
		return (b & 1) === 0;
	}

	static isOdd(b) {
		return (b & 1) === 1;
	}

	static toBinary(i) {
		return i.toString(2).padStart(32, '0');
	}
}

