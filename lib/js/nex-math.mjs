
export class nxMath
{
	static gcd(x, y) {
		if (x == y)
			return x;
		let n;
		while (x > 0 && y > 0) {
			n = x;
			x = y % x;
			y = n;
		}
		return n;
	}

	static lcd(x, y) {
		return x * y / nxMath.gcd(x, y);
	}
}

