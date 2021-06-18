package bec.desktop;

import static com.bryanklumpp.core.CollectionsB.addAll;
import static com.bryanklumpp.core.CollectionsB.newList;

import java.awt.Desktop;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.ContextEnvironment;
import com.bryanklumpp.core.MakeTheValidatorHappyException;
import com.bryanklumpp.core.RunResults;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.ThreadUtil;
import com.bryanklumpp.jash.DesktopUtil;

import bec.file.FileUtil;

public class Run {
	public static final String CMD_EXE = "c:\\windows\\system32\\cmd.exe";
	public static final String EXPLORER_EXE = "c:\\windows\\explorer.exe";
		
	public static String POWERSHELL_EXE = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
	public static String EPSON_SCAN_EXE = "C:\\Program Files (x86)\\epson\\Epson Scan 2\\Core\\es2launcher.exe";
	public static String MSEDGE_EXE = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"; 
	
	
	
	private static final class RunnablePipeToWriter implements Runnable {
		private final Mutable<Exception> threadException;
		private final PrintWriter receiveOutputWriter;
		private final InputStream is;

		/**
		 * @param threadException
		 * @param receiveOutputWriter
		 * @param is
		 */
		private RunnablePipeToWriter(Mutable<Exception> threadException, PrintWriter receiveOutputWriter,
				InputStream is) {
			this.threadException = threadException;
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
		        threadException.o = t1;
		    }
		}
	}

	public static void execExternalJavaB(PrintWriter receiveOutputWriter, Path contextDir, List<String> args) {
		execExternalJava(B.class, args, receiveOutputWriter, contextDir);
	}
	public static <T> void execExternalJava(Class<T> mainClass, List<String> args, PrintWriter receiveOutputWriter, Path contextDir) {
		List<String> exeParts = newList();
		addAll(exeParts, ContextEnvironment.JAVA_EXE.toString(), "-Dfile.encoding=Cp1252", "-classpath",
				ContextEnvironment.CLASSPATH, "-XX:+ShowCodeDetailsInExceptionMessages",
				"-XX:+HeapDumpOnOutOfMemoryError", mainClass.getName());
		addAll(exeParts, args);
		receiveOutputWriter.println("externalJava attempt: "+StringUtil.spaceDelim(exeParts));
		execProcessOSTextGuts(contextDir, receiveOutputWriter, exeParts);
		receiveOutputWriter.println("externalJava completed normally: "+StringUtil.spaceDelim(exeParts));
	}

	static RunResults execOSTextCollectOutput(String... parts) {
		return exeOSTextCollectOutput(ContextEnvironment.USER_HOME, Arrays.asList(parts));
	}
	 
	/**
	 * 
	 * For now this is dumping everything into normalOutput including errors, so
	 * errorOutput will be empty or null.
	 * 
	 * @param contextDirectory
	 * @param parts
	 * @return
	 */
	public static RunResults exeOSTextCollectOutput(Path contextDirectory, List<String> parts) {
		final RunResults results = new RunResults();
		try (  StringWriter sw = new StringWriter(); 
				PrintWriter pw = new PrintWriter(sw);) {
			execProcessOSTextGuts(contextDirectory, pw, parts);
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
	 * @param contextDirectory - can be null and it will use the system directory
	 * @param receiveOutputWriter
	 * @param parts
	 * @return
	 */
	public static int execProcessOSTextGuts(Path contextDirectory, PrintWriter receiveOutputWriter, List<String> parts) {
		if (contextDirectory == null) {
			contextDirectory = ContextEnvironment.getOSSpecifics().getSystemDir();
		}
		final Mutable<Integer> retCode = new Mutable<Integer>(-2463);
		final Mutable<Exception> threadException = new Mutable<Exception>();
		try {
			ProcessBuilder pb = new ProcessBuilder(CollectionsB.newList(CMD_EXE, "/c", parts));
//			Map<String, String> env = pb.environment();
//			System.out.println(env.get("PATH"));
			pb.redirectErrorStream(true);
			pb.directory(contextDirectory.toFile());
			Process p = pb.start();
			
//			Process p = Runtime.getRuntime().exec(CollectionsB.newArray(CMD_EXE, "/c", parts), new String[] { /* env vars */ },
//					contextDirectory.toFile());

			try (InputStream ise = p.getErrorStream(); final InputStream is = p.getInputStream();) {
				Thread t = ThreadUtil.start(new RunnablePipeToWriter(threadException, receiveOutputWriter, is));
				Thread te = ThreadUtil.start(new RunnablePipeToWriter(threadException, receiveOutputWriter, ise)); //see pb.redirectErrorStream, this may not be needed?
				t.join();
				te.join();
				retCode.set(p.waitFor());
			} catch (InterruptedException e) {
				ExceptionUtil.rethrowRuntime(e);
			}
		} catch (IOException e1) {
			ExceptionUtil.rethrowRuntime(e1);
		}
		if (threadException.o != null) {
			ExceptionUtil.rethrowRuntime(threadException.o);
			throw new MakeTheValidatorHappyException(threadException.o);
		} else {
			return retCode.get();
		}
	}
//	playerProc = Runtime.getRuntime().exec(Environment.getOSSpecifics().getPlayAudioCmdWords(audfile));
//	playerProc.waitFor();}catch(java.lang.Exception e){ExceptionUtil.rethrow(e);}

	public static void desktop(Path p) throws IOException {
		Desktop d = Desktop.getDesktop();
		d.open(p.toFile());
	}
	public static void desktop(String fileName) throws IOException {
		desktop(Paths.get(fileName));
	}

	public static Path BAT_DIR = Paths.get("c:/users/b/documents/bat");




}
