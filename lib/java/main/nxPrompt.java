import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;

public class nxPrompt {
	public static int prompt(String ... opts) {
		int cnt = 0;
		for (String opt : opts)
			System.out.printf("%d)\t%s\n", ++cnt, opt);
		System.out.printf("%d)\t%s\n", ++cnt, "quit");
		//while (

			//s.nextLine();

		return cnt;
	}

	public static void main(String [] args) {

		Scanner scan = new Scanner(System.in);
		scan.nextInt();
	//	nxPrompt.scan.nextInt();

		//nxPrompt.prompt("option 1", "two", "three");
		//int wage = scnr.nextInt();
		//System.out.printf("Salary is %s\n", wage * 40 * 52);
	}
}

