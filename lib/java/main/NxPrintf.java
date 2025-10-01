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
				return '0';
		}
	}

	public static void pretty(String ... opts) {
		if (opts.length < 2)
			return;
		char[] stys = (">\0" + opts[0]).toCharArray();
		int[] stk = new int[64];
		int oidx = 1;
		for (int sidx = 1; sidx < stys.length; ++sidx) {
			switch (stys[sidx]) {
				case '<': case '>': case '_':
			    		stys[0] = stys[sidx];
					break;
				case '%':
					if (stk[0] > 0) {
						System.out.print("\u001b[");
						for (int i = 1; i < stk[0]; ++i)
							System.out.printf("%d;", stk[i]);
						System.out.printf("%dm", stk[stk[0]]);
						stk[0] = 0;
					}
					System.out.printf("%s%s", stys[1] == '\0' ? "" : "\n[" + stys[1] + "]: ", opts[oidx++]);
					if (oidx >= opts.length)
						break;
					break;
				case '^':
					stys[1] =  NxPrintf.symbolMap(stys[sidx]);
					break;
				default:
					switch (stys[0]) {
						case '<': case '>':
							stk[++stk[0]] = NxPrintf.colorMap(stys[sidx], stys[0]);
							break;
						case '_':
							stk[++stk[0]] = NxPrintf.styleMap(stys[sidx]);
							break;
					}
			}
		}
		System.out.print("\u001b[0m");
	}
}

