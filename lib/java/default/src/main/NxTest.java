package main;
import main.io.NxPrintf;
import main.io.NxRead;
//import main.std.NxBits;
import java.util.Scanner;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.File;

import java.io.IOException;
import java.nio.file.Files;
import java.util.stream.Stream;

import java.util.ArrayList;
import java.util.List;

public class NxTest {

	public static Path[] pathSeparator(String ... paths) {
		String rpl = System.getProperty("file.separator");
		String fnd = rpl == "\\\\" ? "/" : "\\\\";
		int idx = 0;
		Path currentPath;
		for (String path : paths) {
			if ((currentPath = Paths.get(path.replaceAll(fnd, rpl)).getParent()) != null)
				paths[idx++] = currentPath.toAbsolutePath().toString();
		}
		if (idx >= -1) {
			Path[] exists = new Path[idx];
			while (--idx >= 0) {
				exists[idx] = Paths.get(paths[idx]);
			}
			return exists;
		}
		return null;
	}

	public static void findDirectory(Path parentDir, String dirName) {

		List<Path> matchingPaths = new ArrayList<>();

		try (Stream<Path> paths = Files.walk(parentDir)) {
			paths.filter(Files::isDirectory) // Filter to keep only directories
			.filter(path -> path.getFileName().toString().equals(dirName)) // Match directory name
			.forEach(matchingPaths::add);
		} catch (IOException e) {
			System.err.println("Error while searching for directories: " + e.getMessage());
		}
		for (Path p : matchingPaths)
			System.out.println(p);
		//return Paths.get(matchingPaths);
	}

	public static void main(String[] args) {
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


		System.out.println(findDirectory(pathSeparator(System.getProperty("user.dir"))[0], "bin"));

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
	}
}

