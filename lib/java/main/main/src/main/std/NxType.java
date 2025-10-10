package main.std;

public class NxType
{
	private static void negative(String type) {
		throw new IllegalArgumentException("Size of type " + type +" must be non-negative!");
	}

	public static void isPositive(char i) {
		if (i < 0)
			negative("char");
	}
	
	public static void isPositive(int i) {
		if (i < 0)
			negative("int");
	}

	public static void isPositive(long i) {
		if (i < 0)
			negative("long");
	}

	public static void isPositive(float i) {
		if (i < 0.0)
			negative("float");
	}

	public static void isPositive(double i) {
		if (i < 0.0)
			negative("double");
	}

	public static void isPositive(Number i) {
		if (i.doubleValue() < 0.0)
			negative(i.getClass().getSimpleName());
	}

	public static void isNull(String s) {
		if (s == null || s.trim().isEmpty())
			throw new IllegalArgumentException("Input must not be null or blank");
	}

	public static boolean isEven(int i) {
		return (i & 1) == 0;
	}

	public static boolean isEven(long i) {
		return (i & 1) == 0;
	}
}

