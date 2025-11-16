package main.std;

import main.std.NxSystem;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class NxCmd
{
	public static String[] exec(String c) throws Exception {
		ProcessBuilder pb = new ProcessBuilder(NxSystem.cmd(c));
		List<String> ln = new ArrayList<>();
		Process p = pb.start();
		try (BufferedReader r = new BufferedReader(
			new InputStreamReader(p.getInputStream())
		)) {
			String l;
			while ((l = r.readLine()) != null)
				ln.add(l);
		}
		ln.add(String.valueOf(p.waitFor()));
		return ln.toArray(new String[0]);
	}
}



/*
interface Self<T> {
	T self();
}

abstract class NxTemplateBase<T extends NxTemplateBase<T>> implements Self<T> {
	protected String root = "";
	protected String src = "src";
	protected String bin = "bin";


	public T root(String s) {
		root = s;
		return self();
	}

	public T bin(String s) {
		bin = s;
		return self();
	}

	public T src(String s) {
		src = s;
		return self();
	}
}

interface Self<T> {
	T self();
}

abstract class NxTemplateBase<T extends NxTemplateBase<T>> implements Self<T> {
	protected String src = "src";
	protected String bin = "bin";
	protected List<File> files;
	protected List<String> names;
	protected JavaCompiler compiler;
	protected StandardJavaFileManager manager;

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


public class NxTemplate extends NxTemplateBase<NxTemplateBase>
{

	@Override
	public NxTemplate self() {
		return this;
	}

	public static class Build extends NxTemplateBase<Build> {
		private String src = "src";
		private String bin = "bin";
		private List<File> files;
		private List<String> names;
		private Iterable<? extends JavaFileObject> units;

		public Build() {
			this.files = new ArrayList<>();
			this.names = new ArrayList<>();
		}
		
		@Override
		public Build self() {
			return this;
		}

		public NxTemplate end() {
			return new NxTemplate(src, bin, files, names, compiler, manager, units);
		}
	}

		public NxTemplate(String s, String b, List<File> f, List<String> n, JavaCompiler c, StandardJavaFileManager m, Iterable<? extends JavaFileObject> u) {
			boolean status;
			for (File i : f)
				n.add(i.getPath());
			this.compiler = ToolProvider.getSystemJavaCompiler();
			this.manager = this.compiler.getStandardFileManager(null, null, null);
			this.manager.setLocation(StandardLocation.CLASS_OUTPUT, List.of(new File(b)));
			collectJavaFiles(new File(s), f);
			this.manager.getJavaFileObjectsFromStrings(n);
		}
}
*/
/*
public class NxTemplate {
   public static void main(String[] args) {
        String srcRoot = "src";      // Your source directory
        String outRoot = "bin";      // Output directory for .class files

        List<File> javaFiles = new ArrayList<>();
        collectJavaFiles(new File(srcRoot), javaFiles);

        List<String> fileNames = new ArrayList<>();
        for (File f : javaFiles) fileNames.add(f.getPath());

        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(null, null, null);

	try {
	    fileManager.setLocation(StandardLocation.CLASS_OUTPUT, List.of(new File(outRoot)));
	} catch (IOException e) {
	    System.err.println("Failed to set output location: " + e.getMessage());
	    return;
	}

        Iterable<? extends JavaFileObject> compilationUnits = fileManager.getJavaFileObjectsFromStrings(fileNames);

        boolean success = compiler.getTask(null, fileManager, null, null, null, compilationUnits).call();
        System.out.println(success ? "Compilation succeeded." : "Compilation failed.");

	/*URLClassLoader classLoader = new URLClassLoader(new URL[] { new File(outRoot).toURI().toURL() });
	Class<?> cls = classLoader.loadClass("NxTest");
	Method main = cls.getMethod("main", String[].class);
	main.invoke(null, (Object) new String[] {});*/
    }
/*
    static void collectJavaFiles(File dir, List<File> files) {
        for (File f : dir.listFiles()) {
            if (f.isDirectory()) collectJavaFiles(f, files);
            else if (f.getName().endsWith(".java")) files.add(f);
	}
    }
}

