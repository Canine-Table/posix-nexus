package main.std;

import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Stream;

public class NxSystem
{
	public static final String OS = System.getProperty("os.name").toLowerCase();
	public static final String SEP = System.getProperty("file.separator");
	public static final String OSEP = SEP ==  "\\\\" ? "/" : "\\\\";

	public static String[] cmd(String c) {
		return OS.contains("win")
			? new String[]{"cmd", "/c", "where", c}
			: new String[]{"sh", "-c", "command -v " + c};
	}

	public static Path[] pathSeparator(String ... ps) {
		int i = 0;
		Path cp;
		for (String p : ps)
			if ((cp = Paths.get(p.replaceAll(SEP, OSEP)).getParent()) != null)
				ps[i++] = cp.toAbsolutePath().toString();
		Path[] es = new Path[i];
		while (--i >= 0)
			es[i] = Paths.get(ps[i]);
		return es;
	}

	public static Path[] findDirectory(Path pd, String d) {
		List<Path> m = new ArrayList<>();
		try (Stream<Path> ps = Files.walk(pd)) {
			ps.filter(Files::isDirectory) // Filter to keep only directories
			.filter(p -> p.getFileName().toString().equals(d)) // Match directory name
			.forEach(m::add);
		} catch (IOException e) {
			System.err.println("Error while searching for directories: " + e.getMessage());
		}
		return m.toArray(new Path[0]);
	}
}

