package com.bryanklumpp.core;

import java.io.File;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;

import bec.desktop.LinuxSpecifics;
import bec.desktop.OSSpecifics;
import bec.desktop.WindowsSpecifics;

/**
 * @author Bryan Klumpp
 * 
 * Gateway to information about the runtime environment, especially OS/platform-dependent items
 *
 */
public class ContextEnvironment {
	public static final PrintWriter SYSTEM_OUT_PRINTWRITER = new PrintWriter(System.out, true); // PrintWriter does implement AutoCloseable, so I thought about trying to close this resource on JVM exit, but that could just cause bugs, and I'm not sure it's hurting anything as-is

	public static final Path USER_HOME = Paths.get(System.getProperty("user.home"));
	public static final Path JAVA_EXE = Paths.get(System.getProperty("java.home") + "/bin/java.exe");
	public static final Path JAVAW_EXE = Paths.get(System.getProperty("java.home") + "/bin/javaw.exe");

	public static final String CLASSPATH = System.getProperty("java.class.path");
	
	
	private static final OSSpecifics OS = buildOSSpecifics();

	public static OSSpecifics getOSSpecifics() {
		return OS;
	}
	public static OSSpecifics buildOSSpecifics() {
		OSSpecifics OS;
		if (new File("c:\\Windows").exists()) {
			OS = new WindowsSpecifics();
		} else {
			OS = new LinuxSpecifics();
		}
		return OS;
	}

	

}
