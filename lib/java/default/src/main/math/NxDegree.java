package main.math;

public class NxDegree extends NxGeometry
{
	public static double quadrantFoldCosine(double x) {
		x = x % 360;
		if (x < 0)
			x += 360;
		if (x > 180)
			x = 360 - x;	 // reflect across 180°
		if (x > 90)
			x = 180 - x;	 // reflect across 90°
		return x;
	}

	public static double quadrantFoldSecant(double x) {
		return quadrantFoldCosine(x);
	}

	public static double quadrantFoldSine(double x) {
		x = x % 360;
		if (x < 0)
			x += 360;
		double s = 1;
		if (x > 180) {
			x = 360 - x; // reflect across 180°
			s = -1;
		}
		if (x > 90)
			x = 180 - x; // reflect across 90°
		return x * s;
	}

	public static double quadrantFoldCosecant(double x) {
		return quadrantFoldSine(x);
	}

	public static double quadrantFoldTangent(double x) {
		x = x % 360;
		if (x < 0)
			x += 360;
		if (x > 180)
			x -= 360; // fold into [−180°, 180°]
		if (x > 90)
			x = 180 - x; // fold into [−90°, 90°]
		if (x < -90)
			x = -180 - x; // symmetric reflection
		return x;
	}

	public static double quadrantFoldCotangent(double x) {
		return quadrantFoldTangent(x);
	}
}

