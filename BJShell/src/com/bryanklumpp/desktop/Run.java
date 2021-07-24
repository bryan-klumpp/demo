package com.bryanklumpp.desktop;

import static com.bryanklumpp.core.CollectionsB.addAll;
import static com.bryanklumpp.core.CollectionsB.newList;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.core.Mutable;
import com.bryanklumpp.core.RunResults;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.SystemB;
import com.bryanklumpp.core.ThreadUtil;

/**
 * @author Bryan Klumpp
 *
 * Helpers for executing processes outside of Java, wrapper for ProcessBuilder, etc.
 * 
 */
public class Run {
	public static final String CMD_EXE = "c:\\windows\\system32\\cmd.exe";
	public static final String EXPLORER_EXE = "c:\\windows\\explorer.exe";
	public static String POWERSHELL_EXE = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
	public static String MSEDGE_EXE = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"; 
	
	private static final class RunnablePipeToWriter implements Runnable {
		private Exception threadException;
		private final PrintWriter receiveOutputWriter;
		private final InputStream is;

		private RunnablePipeToWriter(PrintWriter receiveOutputWriter, InputStream is) {
			this.receiveOutputWriter = receiveOutputWriter;
			this.is = is;
		}

		/**
		 * NOTE: input stream will be closed afterward
		 */
		public void run() {
		    
			try (InputStreamReader in = new InputStreamReader(is);
				    BufferedReader br = new BufferedReader(in);) {
		        String nextLine = br.readLine();
		        while (nextLine != null) {
		            receiveOutputWriter.println(nextLine);
		            nextLine = br.readLine();
		        }
		    } catch (Exception t1) {
		        threadException = t1;		    }
		}
	}

	public static <T> void execExternalJava(Class<T> mainClass, PrintWriter receiveOutputWriter, Path workingDir, List<String> args) {
		List<String> exeParts = newList();
		addAll(exeParts, SystemB.JAVA_EXE.toString(), "-Dfile.encoding=Cp1252", "-classpath",
				SystemB.CLASSPATH, "-XX:+ShowCodeDetailsInExceptionMessages",
				"-XX:+HeapDumpOnOutOfMemoryError", "-enableassertions", mainClass.getName());
		addAll(exeParts, args);
		execProcessOSTextGuts(workingDir, receiveOutputWriter, exeParts);
	}

	public static RunResults execOSTextCollectOutput(String... parts) {
		return exeOSTextCollectOutput(SystemB.USER_HOME, Arrays.asList(parts));
	}
	 
	/**
	 * 
	 * For now this is dumping everything into normalOutput including errors, so
	 * errorOutput will be empty or null.
	 * 
	 * @param workingDirectory
	 * @param parts
	 * @return
	 */
	public static RunResults exeOSTextCollectOutput(Path workingDirectory, List<String> parts) {
		final RunResults results = new RunResults();
		try (  StringWriter sw = new StringWriter(); 
				PrintWriter pw = new PrintWriter(sw);) {
			execProcessOSTextGuts(workingDirectory, pw, parts);
			results.setNormalOutput(sw.toString());
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
		return results;
	}
	public static int execProcessOSText(PrintWriter receiveOutputWriter, Object... parts) {
		return execProcessOSTextGuts(null, receiveOutputWriter, StringUtil.listOfToString(parts));
	}
	/**
	 * @param workingDirectory - can be null and it will use the system directory
	 * @param receiveOutputWriter
	 * @param parts
	 * @return
	 */
	public static int execProcessOSTextGuts(Path workingDirectory, PrintWriter receiveOutputWriter, List<String> parts) {
		if (workingDirectory == null) {
			workingDirectory = SystemB.getOSSpecifics().getSystemDir();
		}
		final Mutable<Integer> retCode = new Mutable<Integer>(-2463);
		try {
			ProcessBuilder pb = new ProcessBuilder(CollectionsB.newList(CMD_EXE, "/c", parts));
			pb.directory(workingDirectory.toFile());
			Process p = pb.start();
			
			try (InputStream ise = p.getErrorStream(); final InputStream is = p.getInputStream();) {
				/*
				 * Right now it's sending the error input stream to the same output writer as
				 * the normal stream, so it would have worked to just call
				 * pb.redirectErrorStream(true), but the threading is the trickier part so just
				 * trying to work out any bugs with that because down the road I can see wanting
				 * to send the errors to a different output.
				 */
				RunnablePipeToWriter runnable = new RunnablePipeToWriter(receiveOutputWriter, is);
				RunnablePipeToWriter runnableE = new RunnablePipeToWriter(receiveOutputWriter, ise);
				Thread t = ThreadUtil.start(runnable);
				Thread te = ThreadUtil.start(runnableE);
				t.join();
				te.join();
				if (runnable.threadException != null) {
					throw new RuntimeException(runnable.threadException);
				}
				if (runnableE.threadException != null) {
					throw new RuntimeException(runnable.threadException);
				}
				retCode.set(p.waitFor()); // side note, by this point the threads reading the input have joined, so probably won't block long if at all on this line
			} catch (InterruptedException e) {
				ExceptionUtil.rethrowRuntime(e);
			}
		} catch (IOException e1) {
			ExceptionUtil.rethrowRuntime(e1);
		}
		return retCode.get();
	}
}
