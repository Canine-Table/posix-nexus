package main.std;

public class NxBits
{
	private static final int[] INT_32 = { 1, 2, 4, 8, 16 };
	private static final long[] INT_64 = { 1, 2, 4, 8, 16, 32 };

	private int[] buffer;
	private int index = 0;
	private int size = 1;

	public static int signed(int b) {
		return Math.abs(b) == 0 ? 0 : b < 0 ? -1 : 1;
	}

	public static long signed(long b) {
		return Math.abs(b) == 0 ? 0L : b < 0 ? -1L : 1L;
	}

	public static int target(int b) {
		return (b = Math.abs(b)) == 0 ? 0 : 1 + ((b - 1) & 31);
	}
	
	public static long target(long b) {
		return (b = Math.abs(b)) == 0 ? 0 : 1L + ((b - 1L) & 63L);
	}

	public static boolean even(int b) {
		return (Math.abs(b) & 1) == 0;
	}

	public static boolean even(long b) {
		return (Math.abs(b) & 1L) == 0;
	}


	public static boolean odd(int b) {
		return (Math.abs(b) & 1) == 1;
	}

	public static boolean odd(long b) {
		return (Math.abs(b) & 1L) == 1;
	}


	public static boolean is(int b, int s) {
		return (Math.abs(b) & (1 << target(s))) != 0;
	}

	public static boolean is(long b, long s) {
		return (Math.abs(b) & (1L << target(s))) != 0;
	}


	public static int on(int b, int s) {
		return signed(b) * (Math.abs(b) | (1 << target(s)));
	}

	public static long on(long b, long s) {
		return signed(b) * (Math.abs(b) | (1L << target(s)));
	}


	public static int off(int b, int s) {
		return signed(b) * (Math.abs(b) & ~(1 << target(s)));
	}

	public static long off(long b, long s) {
		return signed(b) * (Math.abs(b) & ~(1L << target(s)));
	}


	public static int flip(int b, int s) {
		return signed(b) * (Math.abs(b) ^ (1 << target(s)));
	}

	public static long flip(long b, long s) {
		return signed(b) * (Math.abs(b) ^ (1L << target(s)));
	}


	public static int diverge(int b, int s) {
		int c = signed(b);
		b = Math.abs(b);
		return c * (b ^ (b >> target(s)));
	}

	public static long diverge(long b, long s) {
		long c = signed(b);
		b = Math.abs(b);
		return c * (b ^ (b >> target(s)));
	}


	public static int cascade(int b, int s) {
		int c = signed(b);
		b = Math.abs(b);
		return c * (b | (b >> target(s)));
	}

	public static long cascade(long b, long s) {
		long c = signed(b);
		b = Math.abs(b);
		return c * (b | (b >> target(s)));
	}


	public static int count(int b) {
		int s = 0;
		while (b != 0) {
			b &= b - 1;
			s++;
		}
		return s;
	}

	public static int count(long b) {
		int s = 0;
		while (b != 0L) {
			b &= b - 1L;
			s++;
		}
		return s;
	}


	public static int leading(int b) {
		return zeros(b, 31, -1);
	}

	public static int leading(long b) {
		return zeros(b, 63, -1);
	}


	public static int trailing(int b) {
		return zeros(b, 0, 1);
	}

	public static int trailing(long b) {
		return zeros(b, 0, 1);
	}


	public static int zeros(int b, int i, int s) {
		if ((b = Math.abs(b)) == 0)
			return 32;
		int l = 0;
		while (((b >> i) & 1) == 0) {
			l++;
			i += s;
		}
		return l;
	}

	public static int zeros(long b, int i, int s) {
		if ((b = Math.abs(b)) == 0)
			return 64;
		int l = 0;
		while (((b >> i) & 1L) == 0) {
			l++;
			i += s;
		}
		return l;
	}


	public static int modNext(int b, int s) {
		return (b = Math.abs(b)) == 0 ? 0 : 1 + ((b - 1) & (next(s) - 1));
	}

	public static long modNext(long b, long s) {
		return (b = Math.abs(b)) == 0 ? 0 : 1 + ((b - 1) & (next(s) - 1));
	}


	public static int left(int b, int s) {
		b = Math.abs(b);
		s = target(s);
		return (b << (32 - s)) | (b >> s);
	}

	public static long left(long b, long s) {
		b = Math.abs(b);
		s = target(s);
		return (b << (64 - s)) | (b >> s);
	}


	public static int right(int b, int s) {
		b = Math.abs(b);
		s = target(s);
		return (b >> (32 - s)) | (b << s);
	}

	public static long right(long b, long s) {
		b = Math.abs(b);
		s = target(s);
		return (b >> (64 - s)) | (b << s);
	}


	public static boolean parity(int b) {
		b = Math.abs(b);
		for (int i = INT_32.length - 1; i >= 0; --i)
			b = diverge(b, INT_32[i]);
		return even(b);
	}

	public static boolean parity(long b) {
		b = Math.abs(b);
		for (int i = INT_64.length - 1; i >= 0; --i)
			b = diverge(b, INT_64[i]);
		return even(b);
	}


	public static int next(int b) {
		if ((b = Math.abs(b) - 1) < 1)
			return 1;
		for (int i = 0; i < INT_32.length; ++i)
			b = cascade(b, INT_32[i]);
		return b + 1;
	}

	public static long next(long b) {
		if ((b = Math.abs(b) - 1) < 1)
			return 1L;
		for (int i = 0; i < INT_64.length; ++i)
			b = cascade(b, INT_64[i]);
		return b + 1L;
	}


	public static String toBinary(int b) {
		return String.format("%32s", Integer.toBinaryString(b)).replace(' ', '0');
	}

	public static String toBinary(long b) {
		return String.format("%64s", Long.toBinaryString(b)).replace(' ', '0');
	}

	////////////////////////////////////////////////////////////////////////////////////////////

	public static class Chain32 {
		public int bits;

		public Chain32() {
			bits = 0;
		}

		public Chain32(int b) {
			bits = b;
		}

		public Chain32 count() {
			int s = 0;
			while (bits != 0) {
				bits &= bits - 1;
				s++;
			}
			bits = s;
			return this;
		}

		public Chain32 on(int s) {
			bits = NxBits.on(bits, s);
			return this;
		}

		public Chain32 off(int s) {
			bits = NxBits.off(bits, s);
			return this;
		}

		public Chain32 flip(int s) {
			bits = NxBits.flip(bits, s);
			return this;
		}

		public Chain32 next() {
			bits = NxBits.next(bits);
			return this;
		}

		public Chain32 modNext(int s) {
			bits = NxBits.modNext(bits, s);
			return this;
		}

		public Chain32 right(int s) {
			bits = NxBits.right(bits, s);
			return this;
		}

		public Chain32 left(int s) {
			bits = NxBits.left(bits, s);
			return this;
		}

		public Chain32 diverge(int s) {
			bits = NxBits.diverge(bits, s);
			return this;
		}

		public Chain32 cascade(int s) {
			bits = NxBits.cascade(bits, s);
			return this;
		}

		public Chain32 trailing() {
			bits = NxBits.trailing(bits);
			return this;
		}

		public Chain32 leading() {
			 bits = NxBits.leading(bits);
			 return this;
		}

		public	Chain32 toBinary(int b) {
			System.out.printf("%d%-25s\n", bits, NxBits.toBinary(bits));
			return this;
		}

		public boolean even() {
			return NxBits.even(bits);
		}

		public boolean odd() {
			return NxBits.odd(bits);
		}

		public boolean is(int s) {
			return NxBits.is(bits, s);
		}

		public boolean parity() {
			return NxBits.parity(bits);
		}

		public int value() {
			return bits;
		}
	}

	public static Chain32 chain32() {
		return new Chain32();
	}

	public static Chain32 chain32(int b) {
		return new Chain32(b);
	}
}

