package main.io;

import java.util.Scanner;
import main.std.NxType;
import main.io.NxPrintf;

interface Self<T> {
	T self();
}

abstract class NxReadBase<T extends NxReadBase<T>> implements Self<T> {
	protected int attempts = 0;
	protected int count = 0;
	protected Scanner scan;
	protected String prompt = "Enter a value";
	protected String error = "Invalid input, please try again.";

	public T attempts(int t) {
		NxType.isPositive(t);
		this.attempts = t;
		return self();
	}

	public T count(int i) {
		NxType.isPositive(i);
		this.count = i;
		return self();
	}

	public T prompt(String s) {
		NxType.isNull(s);
		this.prompt = s.trim();
		return self();
	}

	public T error(String s) {
		NxType.isNull(s);
		this.error = s.trim();
		return self();
	}
}

public class NxRead extends NxReadBase<NxRead>
{
	private Class<?> cast;
	private Object value;

	@Override
	public NxRead self() {
		return this;
	}

	public static class Build extends NxReadBase<Build> {

		public Build(Scanner scan) {
			this.scan = scan;
		}

		public Build() {
			this.scan = new Scanner(System.in);
		}

		public Build self() {
			return this;
		}

		public NxRead end() {
			return new NxRead(attempts, count, scan, prompt, error);
		}
	}

	private NxRead(int a, int c, Scanner s, String p, String e) {
		this.attempts = a;
		this.count = c;
		this.scan = s;
		this.prompt = p;
		this.error = e;
	}

	private static <T> T tryCast(Class<T> cast, String inpt, int len) {
		inpt = len == 0 ? inpt : inpt.substring(0, Math.min(len, inpt.length()));
		Object res = inpt;

		if (cast == Integer.class) {
			res = Integer.parseInt(inpt);
		} else if (cast == Double.class) {
			res = Double.parseDouble(inpt);
		} else if (cast == Float.class) {
			res = Float.parseFloat(inpt);
		} else if (cast == Long.class) {
			res = Long.parseLong(inpt);
		} else if (cast == Short.class) {
			res = Short.parseShort(inpt);
		} else if (cast == Byte.class) {
			res = Byte.parseByte(inpt);
		} else if (cast == Boolean.class) {
			res = Boolean.parseBoolean(inpt);
		} else if (cast == Character.class) {
			if (inpt.length() != 1) throw new IllegalArgumentException("Expected single character");
			res = inpt.charAt(0);
		} else if (cast == String.class) {
			res = inpt;
		} else {
			throw new IllegalArgumentException("Unsupported cast type: " + cast.getSimpleName());
		}
		return cast.cast(res);
	}

	private <T> NxRead readInput(Class<T> cast) {
		boolean pass = false;
		int attempt = 0;
		String inpt;
		Object res = null;
		do {
			try {
				NxPrintf.format("_b^i_u>I%^0>L\0: \n", this.prompt == null ? "Enter a value" : this.prompt);
				inpt = this.scan.nextLine();
				res = tryCast(cast, inpt, this.count);
				pass = true;
			} catch(Exception e) {
				NxPrintf.format("_b^E_u>D%_n^0>L\0: \n", this.error == null ? e.getMessage() : this.error);
				res = null;
				attempt++;
			}
		} while (res == null || ! pass && (this.attempts == 1 || attempt < this.attempts));
		this.cast = cast;
		this.value = cast.cast(res);
		return this;
	}

	public NxRead nextLine() {
		return this.readInput(String.class);
	}

	public NxRead nextDouble() {
		return this.readInput(Double.class);
	}

	public NxRead nextInt() {
		return this.readInput(Integer.class);
	}

	public void close() {
		this.scan.close();
	}

	public int attempts() {
		return this.attempts;
	}

	public int count() {
		return this.count;
	}

	public String prompt() {
		return this.prompt;
	}

	public String error() {
		return this.error;
	}

	public Scanner scan() {
		return this.scan;
	}

	public NxRead clone() {
		return new NxRead(this.attempts, this.count, this.scan, this.prompt, this.error);
	}

	public <T> T getValue(Class<T> type) {
		if (!type.isAssignableFrom(this.cast) && !this.cast.isAssignableFrom(type)) {
			throw new IllegalStateException("Type mismatch: " + this.cast.getSimpleName() + " cannot be cast to " + type.getSimpleName());
		}
		return (T) type.cast(this.value);
	}

	public String getCast() {
		return this.cast == null ? "null" : this.cast.getSimpleName();
	}
}
