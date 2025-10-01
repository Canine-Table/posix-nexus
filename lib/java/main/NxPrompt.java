import java.util.Scanner;
import java.util.HashMap;

public class NxPrompt {
	public static void prompt(HashMap<String, Runnable>[] opts) {
		for (HashMap<String, Runnable> opts : opt)
			NxPrintf.pretty(">L%_u>A%", "s");
	}

	public static void main(String [] args) {
		new HashMap<String, Runnable>[] sel = new HashMap[64];
		sel.put("emit", () -> System.out.println("Inline emit"));
		NxPrompt.prompt(sel);
		//NxPrintf.pretty("_b>S%>A%>W%", "Enter", " Base", ": ");
		//Scanner scan = new Scanner(System.in);
		//scan.nextInt();

	//	nxPrompt.scan.nextInt();

		//nxPrompt.prompt("option 1", "two", "three");
		//int wage = scnr.nextInt();
		//System.out.printf("Salary is %s\n", wage * 40 * 52);
	}
}

