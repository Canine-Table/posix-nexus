import java.util.Scanner;

public class hello {
	public static void main(String [] args) {
		Scanner scnr = new Scanner(System.in);
		int wage = scnr.nextInt();
		System.out.printf("Salary is %s\n", wage * 40 * 52);
	}
}

