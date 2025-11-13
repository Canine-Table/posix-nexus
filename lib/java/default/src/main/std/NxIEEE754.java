package main.std;
import main.std.NxBits;

public class NxIEEE754 extends NxBits
{
	public static int sign(int b) {
		return b >>> 31;
	}

	public static int exponent(int b) {
		return (b >>> 23) & 0xFF;
	}

	public static int mantissa(int b) {
		return b & 0x7FFFFF;
	}

	public static double rawBitsToFraction(int b) {
	    return (b << 8); // Math.pow(2, 32);
	}

	/*


	public static int encode(int b) {
	    return sign(b) | exponent(b) | mantissa(b);
	}

	public static int encode(int s, int e, int m) {
	    return sign(s) | exponent(e) | mantissa(m);
	}

	public static double decode(int bits) {
		int sign = bits >>> 31;
		int exponent = (bits >>> 23) & 0xFF;
		int mantissa = bits & 0x7FFFFF;

		int bias = 127;
		int e = exponent - bias;

		double m = (exponent == 0) ? (mantissa / Math.pow(2, 23)) : (1 + mantissa / Math.pow(2, 23));
		double value = m * Math.pow(2, e);

		return (sign == 0) ? value : -value;
	}
*/

	public static class Chain {
		public int bits;

		public Chain() {
			bits = 0;
		}

		public Chain(int b) {
			bits = b;
		}

		public int value() {
			return bits;
		}
	}

	public static Chain chain(int b) {
		return new Chain(b);
	}

	public static Chain chain() {
		return new Chain();
	}

}

