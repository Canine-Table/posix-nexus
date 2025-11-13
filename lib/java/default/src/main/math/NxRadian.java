package main.math;

public class NxRadian extends NxGeometry
{
	public static double quadrantFoldSine(double x) {
		double r = 1;
		x = mod2π(x);
		if (x > π) {
			x = x - π;
			r = -1;
		}
		if (x > π_2)
			x = π - x;
		return x * r;
	}

	public static double quadrantFoldCosecant(double x) {
		return quadrantFoldSine(x);
	}

	public static double quadrantFoldTangent(double x) {
		x = mod2π(x);
		if (x > π)
			x = x - τ;
		if (x > π_2)
			x = π - x;
		if (x < -π_2)
			x = -π - x;
		return x;
	}

	public static double quadrantFoldCotangent(double x) {
		return quadrantFoldTangent(x);
	}

	public static double quadrantFoldCosine(double x) {
		x = mod2π(x);
		if (x > π)
			x = τ - x;
		if (x > π_2)
			x = π - x;
		return x;
	}

	public static double quadrantFoldSecant(double x) {
		return quadrantFoldCosine(x);
	}
}

