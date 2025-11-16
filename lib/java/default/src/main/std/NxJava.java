package main.std;

import javax.tools.JavaCompiler;
import javax.tools.ToolProvider;
import javax.tools.StandardJavaFileManager;
import javax.tools.StandardLocation;
import javax.tools.JavaFileObject;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import java.net.URL;
import java.net.URLClassLoader;
import java.lang.reflect.Method;

public class NxJava
{
	private String root = "";
	private String src = "src";
	private String bin = "bin";
	private int index ;
	private String error = "Compilation failed.";
	private String success = "Compilation succeeded.";
	private StandardJavaFileManager fileManager;
	private JavaCompiler compiler;
 	private File[] files = new File[3];

	
	public NxJava() {
		compiler = ToolProvider.getSystemJavaCompiler();
		fileManager = compiler.getStandardFileManager(null, null, null);
		String pd = System.getenv("NEXUS_LIB");
		String p = System.getenv("G_NEX_JAVA_PROJECT");
		files[0] = new File(pd + "/java/" + p);
		if (pd != null && p != null)
			root = files[0].isDirectory() ? files[0].getAbsolutePath() : "";
		else
			root = "";
		if (root == "") {
			files[0] = new File("");
			root = files[0].getAbsolutePath();
		}
		files[1] = NxSystem.findDirectory(root, src)[0];
		files[2] = NxSystem.findDirectory(root, bin)[0];
	}

	public NxJava error(String e) {
		error = e;
		return this;
	}

	public NxJava success(String s) {
		success = s;
		return this;
	}

	private static void collectJavaFiles(File dir, List<File> files) {
	for (File f : dir.listFiles()) {
	    if (f.isDirectory()) collectJavaFiles(f, files);
	    else if (f.getName().endsWith(".java")) files.add(f);
	}
    }

	/*
	public boolean compile() {
		boolean success = compiler.getTask(null, fileManager, null, null, null, compilationUnits).call();
	}
	*/
}
