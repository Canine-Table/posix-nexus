
export class nxBit32
{
	static on(b, s) {
		return b | (1 << s);
	}

	static off(b, s) {
		return b & ~(1 << s);
	}

	static flip(b, s) {
		return b ^ (1 << s);
	}

	static abs(b) {
		return (b ^ (b >> 31)) - (b >> 31);
	}

	static log2(b) {
		let a = 0;
		while ((b >>= 1) ^ 0)
			a++;
		return a;
	}

	static is(b, s) {
		return b & (1 << s);
	}

	static diverge(b, s) {
		return b ^ b >> s;
	}

	static cascade(b, s) {
		return b | b >> s;
	}

	static alignDown(x, y) {
		return x - (x & (y - 1));
	}

	static bump(b) {
		b--;
		b |= b >> 1;
		b |= b >> 2;
		b |= b >> 4;
		b |= b >> 8;
		b |= b >> 16;
		return b + 1;
	}

	static range(n, s, e) {
		return (n - s) >>> 0 < (e - s) >>> 0;
	}

	static ceil(b) {
		return -((-b) >> 0);
	}

	static floor(b) {
		return -b >> 0;
	}

	static mod(b, s) {
		return b & (s - 1);
	}

	static modNext(b, s) {
		return this.mod(b, this.bump(s));
	}

	static parity(b) {
		b ^= b >> 16;
		b ^= b >> 8;
		b ^= b >> 4;
		b ^= b >> 2;
		b ^= b >> 1;
		return (b & 1) ^ 0;
	}

	static count(b) {
		let c = 0;
		while (b ^ 0) {
			b = b & (b - 1);
			c++;
		}
		return c;
	}

	static isEven(b) {
		return !((b & 1) ^ 0);
	}

	static isOdd(b) {
		return b & 1;
	}

	static toBinary(i) {
		return i.toString(2).padStart(32, '0');
	}
}

