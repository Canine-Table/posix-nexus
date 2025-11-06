package main.io;
import java.util.Arrays;

public class NxPrintf
{
	private static int colorMap(char sty, char aply) {
		int c = 0;
		if (aply == '<')
			c = 10;
		aply = Character.toLowerCase(sty);
		if (aply == 'c')
			return c + 39;
		if (aply == 'r')
			return c + 38;
		if (sty != aply)
			c += 60;
		switch (aply) {
			case 'b':
				return c + 30;
			case 'e':
				return c + 31;
			case 's':
				return c + 32;
			case 'w':
				return c + 33;
			case 'i':
				return c + 34;
			case 'd':
				return c + 35;
			case 'a':
				return c + 36;
			case 'l':
				return c + 37;
			default:
				return 0;
		}
	}

	private static int styleMap(char sty) {
		int c = 0;
		if (sty == 'o') // overline
			return 53;
		if (sty == 'O') // not overline
			return 55;

		c = Character.toLowerCase(sty);
		if (sty != (char)c) {
			sty = (char)c;
			c = 20;
		} else {
			c = 0;
		}

		switch (sty) {
			case 'b':
				return c + 1;
			case 'd':
				return c + 2;
			case 'i':
				return c + 3;
			case 'u':
				return c + 4;
			case 'f':
				return c + 5;
			case 'r':
				return c + 7;
			case 'h':
				return c + 8;
			case 's':
				return c + 9;
			default:
				return 0;
		}
	}

	private static char symbolMap(char sym) {
		switch (sym) {
			case 'b':
				return '#';
			case 'B':
				return '|';
			case 'e':
				return 'x';
			case 'E':
				return 'X';
			case 's':
				return 'v';
			case 'S':
				return 'V';
			case 'w':
				return '!';
			case 'W':
				return '?';
			case 'd':
				return '*';
			case 'D':
				return '>';
			case 'i':
				return 'i';
			case 'I':
				return '.';
			case 'l':
				return '%';
			case 'L':
				return '$';
			case 'a':
				return '@';
			case 'A':
				return '&';
			default:
				return '\0';
		}
	}

	private static String label(char sym, char ste) {
	    return (sym == '\0' || ste == '\0') ? "" : "[" + sym + "]: ";
	}

	private static String applied(boolean ap, boolean b) {
		return b ? ap ? "m" : "" : ap ? ";" :  "\u001b[";
	}

	public static void pretty(String... args) {
		int i = 1;
		while (i + 1 < args.length) {
			String[] lst = Arrays.copyOfRange(args, i, args.length);
			String[] call = new String[lst.length + 1];
			call[0] = args[0];
			System.arraycopy(lst, 0, call, 1, lst.length);
			i += format(call) - 1;
		}
	}

	public static int format(String... args) {
		if (args.length < 1)
		    throw new IllegalArgumentException("Printing the void is not supported");
		if (args.length < 2)
		    throw new IllegalArgumentException("You supplied the formatting, where are the fields? char[] needs at least 2 indexes");
		int i = 1, j = 2;
		char[] fmt = (">\0" + args[0]).toCharArray();
		boolean applied = false;
		do {
			switch (fmt[j]) {
				case '<': case '>': case '_': case '\0':
					fmt[0] = fmt[j];
					break;
				case '^':
					fmt[1] = symbolMap(fmt[++j]);
					break;
				case '%':
					if (i >= args.length) {
						System.out.print("\u001b[0m");
						return i;
					}
					System.out.printf("%s%s%s", applied(applied, true), label(fmt[1], fmt[0]), args[i++]);
					applied = false;
					break;
				default:
					switch (fmt[0]) {
						case '<': case '>': case '_':
							System.out.printf("%s%s", applied(applied, false), fmt[0] == '_' ? styleMap(fmt[j]) : colorMap(fmt[j], fmt[0]));
							applied = true;
							break;
						default:
							System.out.printf("%s%s", applied(applied, true),  fmt[j]);
							applied = false;
					}
			}
		} while (++j < fmt.length || i < args.length);
		System.out.print("\u001b[0m");
		return i;
	}
}
