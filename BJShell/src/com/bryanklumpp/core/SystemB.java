package com.bryanklumpp.core;

import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Locale;

import com.bryanklumpp.file.FileUtil;

/**
 * @author Bryan Klumpp
 * 
 *         Gateway to information and utilities regarding the runtime
 *         environment, including OS/platform-dependent items
 *
 */
public class SystemB {
	
	private static final OSSpecifics OS = buildOSSpecifics();
	private static final PrintStream defaultSysOut = System.out;
	public static final PrintWriter DEFAULT_SYSTEM_OUT_PRINTWRITER = new PrintWriter(defaultSysOut, true); // PrintWriter does implement AutoCloseable, so the fully scrupulous thing to do would be try to enforce closure this resource on JVM exit using finalize() or other means, but it doesn't seem to be hurting anything as-is
	private static final PrintStream defaultSysErr = System.err;
	private static final List<PrintWriter> extraDefaultWriters = CollectionsB.newList(); // similarly, as noted above, technically should maybe deal with cleaning these up, but pretty low priority
	static { teeSysoutAndSyserrWithExtraWriters(); }
	
	public static final Path USER_HOME = Paths.get(System.getProperty("user.home"));
	public static final Path JAVA_EXE = Paths.get(System.getProperty("java.home") + "/bin/java.exe");
	public static final Path JAVAW_EXE = Paths.get(System.getProperty("java.home") + "/bin/javaw.exe");

	public static final String CLASSPATH = System.getProperty("java.class.path");
	
	public static List<PrintWriter> getExtraDefaultWriters() {
		return extraDefaultWriters;
	}
	

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
	/**
	 * Has not been tested with spaces and other special characters in workspace
	 * path. Might work, but those are generally best to avoid anyway.
	 * 
	 * @return
	 */
	public static Path getWorkspacePath() {
		String resourcePath = FileUtil.forwardSlashFilePath(FileUtil.locateCompiledClassFile(SystemB.class));
		Path wsPath = Paths.get(resourcePath.replaceAll("/[^/]*/target/.*$", ""));
		return wsPath;
	}

	/**
	 * In general this project tries to avoid System.out. If some slip through,
	 * though, this method provides a way to redirect them to a GUI window as well
	 * as the normal console.  Use with caution if multiple GUI windows are running
	 * in a JVM, these "orphan" statements may actually get printed to unintended
	 * GUI windows because there is no way to pick just one.
	 */
	private static void teeSysoutAndSyserrWithExtraWriters() {
		System.setOut(buildTeeWriterAndPrintStream(defaultSysOut));
		System.setErr(buildTeeWriterAndPrintStream(defaultSysErr));
	}

	private static PrintStream buildTeeWriterAndPrintStream(PrintStream oldSysPrintStream) {
		return new PrintStream(FileUtil.nullOutputStream()) {
			@Override
			public void write(byte[] buf) throws IOException {
				super.write(buf);
			}

			@Override
			public PrintStream printf(String format, Object... args) {
				return super.printf(format, args);
			}

			@Override
			public PrintStream printf(Locale l, String format, Object... args) {
				return super.printf(l, format, args);
			}

			@Override
			public PrintStream format(String format, Object... args) {
				return super.format(format, args);
			}

			@Override
			public PrintStream format(Locale l, String format, Object... args) {
				return super.format(l, format, args);
			}

			@Override
			public PrintStream append(CharSequence csq) {
				return super.append(csq);
			}

			@Override
			public PrintStream append(CharSequence csq, int start, int end) {
				return super.append(csq, start, end);
			}

			@Override
			public PrintStream append(char c) {
				return super.append(c);
			}

			@Override
			public void print(boolean b) {
				oldSysPrintStream.print(b);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(b);
				}
			}

			@Override
			public void print(char c) {
				oldSysPrintStream.print(c);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(c);
				}
			}

			@Override
			public void print(int i) {
				oldSysPrintStream.print(i);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(i);
				}
			}

			@Override
			public void print(long l) {
				oldSysPrintStream.print(l);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(l);
				}
			}

			@Override
			public void print(float f) {
				oldSysPrintStream.print(f);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(f);
				}
			}

			@Override
			public void print(double d) {
				oldSysPrintStream.print(d);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(d);
				}
			}

			@Override
			public void print(char[] s) {
				oldSysPrintStream.print(s);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(s);
				}
			}

			@Override
			public void print(String s) {
				oldSysPrintStream.print(s);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(s);
				}
			}

			@Override
			public void print(Object obj) {
				oldSysPrintStream.print(obj);
				for (PrintWriter w : extraDefaultWriters) {
					w.print(obj);
				}
			}

			@Override
			public void println() {
				oldSysPrintStream.println();
				for (PrintWriter w : extraDefaultWriters) {
					w.println();
				}
			}

			@Override
			public void println(boolean x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(char x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(int x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(long x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(float x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(double x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(char[] x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(String x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void println(Object x) {
				oldSysPrintStream.println(x);
				for (PrintWriter w : extraDefaultWriters) {
					w.println(x);
				}
			}

			@Override
			public void flush() {
				oldSysPrintStream.flush();
				for (PrintWriter w : extraDefaultWriters) {
					w.flush();
				}
			}

			@Override
			public void close() {
				oldSysPrintStream.close();
				for (PrintWriter w : extraDefaultWriters) {
					w.close();
				}
			}

			/**
			 * Not quite sure if this is the right way to handle this with the extra
			 * multiple PrintWriters, but it returns true if anything had a problem
			 */
			@Override
			public boolean checkError() {
				for (PrintWriter pw : extraDefaultWriters) {
					if (pw.checkError()) {
						return true;
					}
				}
				return oldSysPrintStream.checkError();
			}

			@Override
			public void write(int b) {
				oldSysPrintStream.write(b);
				for (PrintWriter w : extraDefaultWriters) {
					w.println("binary data written to System.out");
				}
			}

			@Override
			public void write(byte[] buf, int off, int len) {
				oldSysPrintStream.write(buf, off, len);
				for (PrintWriter w : extraDefaultWriters) {
					w.println("binary data written to System.out");
				}
			}
		};
	}

}
