package main.beta;

import main.std.NxBits;
import main.std.NxSystem;
import main.std.NxCmd;
import main.std.NxJava;

public class NxTest
{
	public static NxBits.Chain32 bits() {
		return NxBits.chain32();
	}

	public static NxBits.Chain32 bits(int b) {
		return NxBits.chain32(b);
	}

	public static void testSystemCmd() {
		for (String l : NxSystem.cmd("java"))
			System.out.println(l);
	}

	public static void testCmdExec() throws Exception {
		for (String l : NxCmd.exec("java"))
			System.out.println(l);
	}

	/*public static void testJavaExec() {
		for (String l : NxCmd.exec("java"))
			System.out.println(l);
	}*/

}

