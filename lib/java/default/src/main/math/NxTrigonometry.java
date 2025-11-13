package main.math;
import main.math.NxGeometry;
import main.io.NxPrintf;

public class NxTrigonometry extends NxGeometry {

	public static double csc(double x) {
	    return 1.0 / Math.sin(x);
	}

	public static double cot(double x) {
	    return 1.0 / Math.tan(x);
	}

	public static double sec(double x) {
	    return 1.0 / Math.cos(x);
	}
/*
	public static boolean[] possible(double a, double b, double c) {
		int i = 3, j = 0;
		if (approxEqual(a)) {
			i = NxBits.on(i, 4);
			j = NxBits.on(1);
		}
		if (approxEqual(b)) {
			i = NxBits.on(4);
			i = 1;
			j = NxBits.on(2);
			j++;
		}
		if (approxEqual(c)) {
			i = 2;
			j = NxBits.on(3);
			j++;
		}
		return j > 1 ? -1 : i;
	}

	public double[] angleSumRule(double a, double b, double c, double abc[]) {
		int i = possible(a, b, c);
		if (i < 0) {
			abc[0] = -1;
		} else {
			abc = size(abc, 5, 16);
			abc[0] = 0;
			abc[1] = a;
			abc[2] = b;
			abc[3] = c;
			abc[4] = i;
			if (i < 3) {
				abc[i] = 180.0 - abc[(i + 1) % 3] - abc[(i + 2) % 3];
				if (approxEqual(abc[i]))
					abc[0] = -1;
			}
		}
		return abc;
	}


	public static double pythagorean(double a, double b, double c, double abc[]) {
		abc = size(abc, 4, 16);
		abc[3] = 0;
		int i = 0;
		return Math.sqrt(x*x + y*y);
	}


	//////////////////////////////////////////////////////////////////////////////////////////////
	public static double[] resize(double a, double b, double c, double abc[], int sz, int nsz) {
		abc = size(abc, sz, nsz);
		abc[0] = a;
		abc[1] = b;
		abc[2] = c;
		/*
		if (approxEqual(c)) {
			switch (Character.toLowerCase(typ)) {
				case 'd' case '∘':
					abc[2] = 
					break;
				default:

					abc[2] = pythagorean(a, b);
			}
		}
		return abc;
	}

	public static double[] resize(double a, double b, double c, double abc[], int sz) {
		return resize(a, b, c, abc, sz, 16);
	}

	public static double[] resize(double a, double b, double c) {
		return resize(a, b, c, new double[16], 16);
	}

	public static double[] resize(double a, double b, double c, int sz) {
		return resize(a, b, c, new double[sz], sz);
	}

	public static double[] resize(int nsz, double a, double b, double c, double abc[]) {
		return resize(a, b, c, abc, 9, nsz);
	}

	public static double[] resize(double a, double b, double c, double abc[]) {
		return resize(a, b, c, abc, 9, 16);
	}

	//////////////////////////////////////////////////////////////////////////////////////////////

	public static double[] sohcahtoa(double a, double b, double c, double abc[]) {
		abc = resize(a, b, c, abc);
		abc[3] = b / c; // opp / hyp
		abc[4] = a / c; // adj / hyp
		abc[5] = b / a; // opp / adj
		abc[6] = rad2Deg(Math.asin(abc[3]));
		abc[7] = rad2Deg(Math.acos(abc[4]));
		abc[8] = rad2Deg(Math.atan(abc[5]));
		return abc;
	}

	public static double[] heronsFormula(double a, double b, double c, double abc[]) {
		abc = resize(a, b, c, abc, 8);
		abc[3] = (a + b + c) / 2;
		abc[4] = abc[3] - a;
		abc[5] = abc[3] - b;
		abc[6] = abc[3] - c;
		abc[7] = Math.sqrt(abc[3] * abc[4] * abc[5] * abc[6]);
		return abc;
	}

	public static double[]	hoshacaot(double a, double b, double c, double abc[]) {
		abc = resize(a, b, c, abc);
		abc[3] = abc[2] / abc[1]; // hyp / opp
		abc[4] = abc[2] / abc[0]; // hyp / adj
		abc[5] = abc[0] / abc[1]; // adj / opp
		abc[6]	= rad2Deg(Math.asin(1 / abc[3]));
		abc[7]	= rad2Deg(Math.acos(1 / abc[4]));
		abc[8]	= rad2Deg(Math.atan(1 / abc[5]));
		return abc;
	}

	public static double[] solveLawOfCosinesSSS(double a, double b, double c, double abc[]) {
		//return (a*a + b*b - c*c) / (2 * a * b);
		return abc;
	}

	public static double[] solveLawOfSinesSSA(double a, double b, double c, double abc[]) {
		return a * (Math.sin(b) / Math.sin(c));
	}

	public static double[] lawOfSinesSSA(double a, double b, double c) {
		return a * (Math.sin(b) / Math.sin(c));
	}
	*/

	/*















	public static boolean sohcahtoa(double a, double b) {
		return sohcahtoa(a, b, pythagorean(a, b));
	}




	public static boolean sohcahtoa(double a, double b, double c) {
		double soh = b / c; // opp / hyp
		double cah = a / c; // adj / hyp
		double toa = b / a; // opp / adj

		int failed = 0;

		a = rad2Deg(Math.asin(soh));
		b = rad2Deg(Math.acos(cah));
		c = rad2Deg(Math.atan(toa));
		if (failed > 0)
			return false;
		NxPrintf.format("I_bu\0Soa-Cah-Toa\n_U>D%\0\n>W%\0\n>S%\0\n\n",
			String.format("sin A (ratio): %s → angle A: %s∘", soh, a),
			String.format("cos A (ratio): %s → angle A: %s∘", cah, b),
			String.format("tan A (ratio): %s → angle A: %s∘", toa, c)
		);
		return true;
	}

	public static boolean hoshacaot(double a, double b) {
		return hoshacaot(a, b, pythagorean(a, b));
	}

	public static boolean hoshacaot(double a, double b, double c) {
		double hos = c / b; // hyp / opp
		double hac = c / a; // hyp / adj
		double aot = a / b; // adj / opp
		
		int failed = 0;

		a = rad2Deg(Math.asin(1 / hos));
		b = rad2Deg(Math.acos(1 / hac));
		c = rad2Deg(Math.atan(1 / aot));
		if (b == 0) {
			NxPrintf.format("E_bu^E\0Breach: Opposite side is zero → csc and cot undefined\n_U>e%\0\n",
				String.format("sec angle A (deg) = %.12f", b)
			);
			++failed;
		}
		if (a == 0) {
			NxPrintf.format("E_bu^E\0Breach: Adjacent side is zero → sec and cot undefined\n_U>e%\0\n",
				String.format("cot angle A (deg) = %.12f", a)
			);
			++failed;
		}
		if (hos < 1) {
			NxPrintf.format("E_bu^E\0Breach: csc A ratio % 1 → asin(1/hos) invalid\n_U>e%\0\n", "<",
				String.format("hos = %.11f", hos)
			);
			++failed;
		}
		if (aot == 0) {
			NxPrintf.format("E_bu^E\0Breach: cot A division by zero → atan(1/0) undefined\n_U>e%\0\n",
				String.format("aot = %.12f", aot)
			);
			++failed;
		}
		if (failed > 0)
			return false;
		NxPrintf.format("I_bu\0osH-haC-aoT\n_U>D%\0\n>W%\0\n>S%\0\n\n",
			// Math.asin(1 / hos) ⇔ Math.asin(b / c)
			String.format("csc A (ratio): %s → angle A: %s∘", hos, a),
			// Math.acos(1 / hac) ⇔ Math.acos(a / c)
			String.format("sec A (ratio): %s → angle A: %s∘", hac, b),
			// Math.atan(1 / aot) ⇔ Math.atan(b / a)
			String.format("cot A (ratio): %s → angle A: %s∘", aot, c)
		);
		return true;
	}

	public static double heronsFormula(double a, double b, double c) {
		double s = (a + b + c) / 2;
		a = s - a;
		b = s - b;
		c = s - c;
		a = Math.sqrt(s * a * b * c);

		NxPrintf.format("I_bu\0Heron's Formula\n_U>D%\0\n>W%\0\n\n",
			String.format("semi-perimeter: %.12f", s),
			String.format("area: %.12f", a)
		);
		return a;
	}

	public static double solveLawOfSinesSSA(double a, double b, double c) {
		return a * (Math.sin(b) / Math.sin(c));
	}

	public static double lawOfSinesSSA(double a, double b, double c) {
		return a * (Math.sin(b) / Math.sin(c));
	}

	public static double solveLawOfCosinesSSS(double a, double b, double c) {
		return (a*a + b*b - c*c) / (2 * a * b);
	}


	public static double angleSumRule(double a, double b) {
		double c = 180.0 - a - b;
		if (c < ϵ) {
			NxPrintf.format("E_bu^E\0Breach: angle sum exceeds 180° → triangle containment broken\n_U>e%\0\n",
				String.format("A = %.12f°, B = %.12f°, computed C = %.12f°", a, b, c)
			);
			return -1.0;
		}

		NxPrintf.format("I_bu\0Angle Sum Rule\n_U>D%\0\n>W%\0\n\n",
			String.format("∠ 𝐴 = %.12f°", a),
			String.format("∠ 𝐵 = %.12f°", b),
			String.format("∠ 𝐶 = %.12f°", c)
		);
		return a;
	}



	public static double[] lawOfCosines(double a, double b, double c) {
		double[] angles = new double[3];
		angles[0] = rad2Deg(Math.acos(solveLawOfCosinesSSS(b, c, a)));
		angles[1] = rad2Deg(Math.acos(solveLawOfCosinesSSS(c, a, b)));
		angles[2] = rad2Deg(Math.acos(solveLawOfCosinesSSS(a, b, c)));
		NxPrintf.format("I_bu\0Law of Cosines (SSS)\n_U>D%\0\n>W%\0\n>S%\0\n\n",
			String.format("∠ 𝐴: %.12f∘", angles[0]),
			String.format("∠ 𝐵: %.12f∘", angles[1]),
			String.format("∠ 𝐶: %.12f∘", angles[2])
		);
		return angles;
	}
	*/
}

///inverseTrig(


/*
if (!approxEqual(rad2Deg(Math.asin(b / c)), rad2Deg(Math.acos(a / c)))) {
    log("Containment breach: sin/cos angle mismatch");
}
if (!approxEqual(rad2Deg(Math.asin(b / c)), rad2Deg(Math.asin(1 / (c / b))))) {
    log("Containment breach: reciprocal sin/csc mismatch");
}
*/

/*
define nx_solved_shoahatao(a, b, c) {
	auto x, y, z
	if (nx_abs(c) == 0)
		c = r_nx_pth(a, b) # pythagorean
	x = c / b # hyp / opp
	y = c / a # hyp / adj
	z = a / b # adj / opp
	print "csc A (ratio): ", x, " → angle A (deg): ", nx_rad2deg(r_nx_ts_asin(1 / x)), "\n"
	print "sec A (ratio): ", y, " → angle A (deg): ", nx_rad2deg(r_nx_ts_acos(1 / y)), "\n"
	print "cot A (ratio): ", z, " → angle A (deg): ", nx_rad2deg(r_nx_ts_atan(1 / z)), "\n"
}
	public static final double π = Math.PI;
	public static final double τ = 2 * Math.PI;
	public static final double ϵ = Math.ulp(1.0);
	public static final double  = c_pi / 2;
	public static final double π_4 = π / 4;
*/

