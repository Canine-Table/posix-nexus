package main;
import main.beta.NxTest;

/*
//import main.io.NxPrintf;
//import main.io.NxRead;

//import main.math.NxTriangle;
//import main.math.NxTrigonometry;


import java.util.Scanner;
import main.std.NxBits;
import main.std.NxIEEE754;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.File;

import java.io.IOException;
import java.nio.file.Files;
import java.util.stream.Stream;

import java.util.ArrayList;
import java.util.List;
*/

public class NxMain {
	public static void main(String[] args) throws Exception  {
		//NxTest.bits(37).on(3).flip(7).off(7).cascade(4).toBinary();
		//NxTest.testCmdExec();

		//.toBinary();
		int i = 1020434;
		//System.out.printf("%d in binary is %s\n", i, ~i);
	}
}
		/*
		System.out.printf("%d in binary is %s\n", i, NxBits.toBinary(i));
		System.out.printf("%d in binary is %s\n", i, NxBits.leading(i));
		System.out.printf("%d in binary is %s\n", i, NxBits.trailing(i));

		i = 1;
		System.out.printf("%d in binary is %s\n", i, NxBits.toBinary(i));
		System.out.printf("%d in binary is %s\n", i, NxBits.leading(i));
		System.out.printf("%d in binary is %s\n", i, NxBits.trailing(i));

		i = 749932382;
		System.out.printf("%d in binary is %s\n", i, NxBits.toBinary(i));
		System.out.printf("%d in binary is %s\n", i, NxBits.leading(i));
		System.out.printf("%d in binary is %s\n", i, NxBits.trailing(i));
		*/
		//System.out.println("sign: " + NxIEEE754.rawBitsToFraction(i));
		//System.out.println("sign: " + NxIEEE754.sign(0));
		//System.out.println("exponent: " + NxIEEE754.exponent(i));
		//System.out.println("mantissa: " + NxIEEE754.mantissa(0));

		//NxIEEE754.chain(i).toBinary(); //.bits;

		//NxTrigonometry.sohcahtoa(3, 4);
	//	NxTrigonometry.hoshacaot(3, 5);

		//for (int i = 0; i <= 32; ++i) {
		//}

		//System.out.println(NxBits.parity(27));
	/*
		NxTriangle tri1 = new NxTriangle()
			.sideA(3)
			.sideB(4)
			.sideC(5);
		tri1
			.sohcahtoa()
			.hoshacaot()
			.heronsFormula()
			.lawOfCosines();
		System.out.printf("0 mod 3 = %d\n" +
				"1 mod 3 = %d\n" +
				"2 mod 3 = %d\n" +
				"3 mod 3 = %d\n" +
				"4 mod 3 = %d\n" +
				"5 mod 3 = %d\n",
				0%3,
				1%3,
				2%3,
				3%3,
				4%3,
				5%3);
	}



*/
/*        System,out.printf("Car's information:\n\tmodelYear: %d\n\tPurchase price; %d\nCurrent value %d",
            44,
            330,
            -4924);

*/
		//NxBits bt = new NxBits.Build().end();
		//System.out.println(bt.on(1).left(2).get());
		/*
		NxPrintf.format("E\n", "Hello was here once");
	String currentDir = System.getProperty("user.dir");
	File dir = new File(currentDir);

	// Navigating to the parent directory
	File parentDir = dir.getParentFile();

	if (parentDir != null) {
	    System.out.println("Parent Directory: " + parentDir.getAbsolutePath());
	} else {
	    System.out.println("This directory has no parent.");
	}
    }
*/

		//System.out.println(findDirectory(pathSeparator(System.getProperty("user.dir"))[0], "bin"));

		/*
		Scanner snr  = new Scanner(System.in);
		int x = 0, y = 0;
		boolean imDoneHere = false;
	    do {
		try {
		    System.out.printf("1 - %s\n2 - %s\n3 - %s\n4 - %s\n%s",
			"enter x",
			"enter y",
			"print x times y",
			"exit",
			"Please input an option (1-4) "
		    );
		    switch (snr.nextInt()) {
			case 1:
			    System.out.print("What will special x be today?: ");
			    x = snr.nextInt();
			    break;
			case 2:
			    System.out.print("What shall y be: ");
			    y = snr.nextInt();
			    break;
			case 3:
			    System.out.printf("%d * %d = %d\n", x, y, x*y);
			    break;
			case 4:
			    System.out.println("Bye :D");
			    imDoneHere = true;
			    break;
			default:
			    System.out.println("404! That is not in the Hardcoding!!");
			    break;
		    }
	    } catch (Exception e) {
		System.out.println("No! " + e.getMessage());
	    }
	} while (!imDoneHere);
	    snr.close();
		System.out.println("Hi".toLowerCase().equals("hi"));
		Scanner snr = new Scanner(System.in);
		int i = 10;
		while (true) {
			System.out.println(snr.nextInt());
			if (--i == 0)
				break;
		}
		snr.close();
				NxRead scr = new NxRead.Begin()
			.prompt("Enter a value ∈ ℤ")
			.error("We only accept values ∈ ℤ here")
		.end();



		int i = scr.nextInt(), j;
		boolean failed = false;
		do {
			if (failed)
				NxPrintf.format("L<E_bu^e^0%\0\n"," and First number should be less than second");
			j = scr.nextInt();
			failed = true;
		} while (i < j);
		Random rand = new Random();
		do {
			NxPrinf();
		}
		*/

