package main.math;

public class NxGeometry {
	public static final double π = Math.PI;
	public static final double τ = 2 * Math.PI;
	public static final double ϵ = Math.ulp(1.0);
	public static final double π_2 = π / 2;
	public static final double π_4 = π / 4;

	public static double[] size(double[] arr, int sz) {
		if (arr.length < sz) {
			double[] expanded = new double[sz];
			System.arraycopy(arr, 0, expanded, 0, arr.length);
			arr = expanded;
		}
		return arr;
	}

	public static double[] size(double[] arr, int sz, int nsz) {
		if (arr.length < sz)
			return size(arr, nsz);
		return arr;
	}

	public static double rad2Deg(double r) {
		return r * 180 / π;
	}

	public static double deg2Rad(double d) {
		return d * π / 180;
	}

	public static double mod2π(double d) {
		d = d % τ;
		return d < 0 ? d + τ : d;
	}

	public static boolean approxEqual(double a) {
		return Math.abs(a) < ϵ;
	}
}

