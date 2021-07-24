package dev.desktop;

import static com.bryanklumpp.custom.SelfNameIndexedFiles.bPath;

import java.awt.Desktop;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.file.AccessDeniedException;
import java.nio.file.FileVisitOption;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Pattern;

import org.sqlite.JDBC;

import com.bryanklumpp.bjshell.SwingShell;
import com.bryanklumpp.bjshell.BJShellCustomizer;
import com.bryanklumpp.bjshell.DesktopUtil;
import com.bryanklumpp.core.AbstractCommand;
import com.bryanklumpp.core.Adapter;
import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.SystemB;
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.core.MakeTheValidatorHappyException;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.ThreadUtil;
import com.bryanklumpp.custom.CustomCommands;
import com.bryanklumpp.custom.SelfNameIndexedFiles;
import com.bryanklumpp.custom.SwingShellLauncher;
import com.bryanklumpp.desktop.Run;
import com.bryanklumpp.file.FileTypeMatcher;
import com.bryanklumpp.file.FileUtil;
import com.bryanklumpp.file.PathSearchStrategy;

/**
 * These are some older commands used for personal stuff, need some cleanup
 * 
 * @author Bryan Klumpp
 *
 */
public class DraftCommands {

	private final static Map<String, Command> COMMANDS = new HashMap<String, Command>();
	static {buildCmdsExpensive2();}

	public static Map<String, Command> getStaticCommands() {
		return COMMANDS;
	}

	public static void addCommand(Command cmd, String... keys) {
		CollectionsB.putMultipleKeys(COMMANDS, cmd, keys);
	}
	
	private static void buildCmdsExpensive2() {

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				System.out.println((Object) StringUtil.urlEncode(args.get(0)));
			}
		}, "urlencode");
		addCommand(new AbstractCommand("Searches for files using regular expressions") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				final List<String> fargs = StringUtil.argsWithClipboardDefault(args);
				// This is using the typical exclusions; it's technically redundant here, but
				// this is an example of how to override the default/typical exclusions if desired
				ThreadUtil.runWithThreadLocal(PathSearchStrategy.getSearchExclusions(), SystemB.getOSSpecifics().getDefaultFileSearchExclusions(), 
						() -> FileUtil.findAndPrint(context, outputWriter, fargs));
				outputWriter.println("## done searching for: "+argsv+" ##");
				FileUtil.printWorkingDirectory(outputWriter, context.getWorkingDir());
			}
		}, "find", "f");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Path rootDirectory = bPath(SelfNameIndexedFiles.STUFF_ORGANIZER);
				List<Path> matches = FileUtil.getMatchesDeep(rootDirectory, args, FileTypeMatcher.ALL);
				FileUtil.prettyPrint(matches, outputWriter);
			}
		}, "s");
		addCommand((argsv, args, outputWriter, context) ->  {
			args = StringUtil.argsWithClipboardDefault(args);
			List<PathSearchStrategy> strategies = CollectionsB.newList();
			strategies.add   (PathSearchStrategy.getExactMatchStrategy(FileTypeMatcher.NON_DIRECTORIES));
			strategies.addAll(PathSearchStrategy.CUSTOM_EXTRA_MATCH_STRATEGIES);
			strategies.add   (PathSearchStrategy.getRegexClosestLevelMatchStrategy(FileTypeMatcher.NON_DIRECTORIES));
			Path result = FileUtil.getBestSingleMatch(context.getWorkingDir(), args, strategies);
			if(result != null) {
				File file = result.toFile();
				outputWriter.println("opening: "+file);
				ThreadUtil.sleepSeconds(1); //give user time to visually confirm that file being opened is the desired file
				Desktop.getDesktop().open(file);
			}else {
				outputWriter.println("no match found");
			}
		}, "o");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Alarm.main2(args);
			}
		}, "alarm");


		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				B.processLinesWithStreamClose(new Adapter<String, String>() {
					public String adapt(String line) {
						File f = new File(line);
						System.out.print((B.btime(new Date(f.lastModified())) + "_____ ").toString()); // last modified date for sorting
						System.out.println((Object) (line + (FileUtil.isDirectory(f.toPath()) ? "/" : ""))); // directories end in slash
						return null;
					}
				}, System.in);
			}
		}, "findDecorate");
		addCommand(new AbstractCommand("") { // ##
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				String pstart = args.get(0), pend = args.get(1);
				Timestamp start = B.timestamp(pstart, true, true), end = B.timestamp(pend, true, true);
				double pdiff = (end.getTime() - start.getTime()) / B.MILLIS_IN_DAY;
				String mainSql = "select sum(effort) totalDays, pubcat from v_do_log where pubcat is not null and start > ? and end < ? group by pubcat";
				double totalTime = B.parseDouble(
						Q.cell("select sum(totalDays) from (" + mainSql + ")", B.sqlite(start), B.sqlite(end)));
				System.out.println((Object) ("pdiff: " + pdiff));
				System.out.println((Object) ("totalTime: " + totalTime + " days"));
				B.assertClose(pdiff, totalTime, .02);
				outputWriter.println(Q.table(
						"select round(100 * totalDays / " + pdiff
								+ ", 1)||' %' percent, pubcat category, pubcat.desc from (" + mainSql
								+ ") main left join pubcat on main.pubcat = pubcat.key order by totalDays desc",
						true, B.sqlite(start), B.sqlite(end)));
			}
		}, "timesum");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				// Warn.play(Alarm.AUDIO);
			}
		}, "bark");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				// Warn.loop(Alarm.AUDIO);
			}
		}, "barkloop");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				if (args.size() > 1) {
					throw new RuntimeException("expected single main String, you may have quoting or escaping issues");
				}
				String t = args.get(0);
				if (!B.contains(t, Pattern.compile("Moth.(\\w|$)"))) {
					t = t + " assumed_Moth0";
				}
				Q.sqlMod("insert intoasdf ", args.get(0)); // TODO
			}
		}, "journal");
		addCommand(new AbstractCommand("") { 
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				final List<String> forward = new ArrayList<>();
				B.processLinesWithStreamClose(new Adapter<String, String>() {
					public String adapt(String next) {
						// sop("debug:"+next);
						forward.add(next);
						return null;
					}
				}, System.in);
				Object[] forwardA = forward.toArray();
				for (int i = forwardA.length - 1; i >= 0; i--) {
					System.out.println(forwardA[i]);
				}
			}
		}, "reverse");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				outputWriter.println(Q.table("select * from b", true));
			}
		}, "borg");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				List<String> l = CollectionsB.newList();
				l.add(Run.MSEDGE_EXE);
				l.add("-inprivate");
				l.addAll(args);
				Run.execProcessOSTextGuts(context.getWorkingDir(), outputWriter, l);
			}
		}, "inprivate", "priv","webp"); //https://storejobs.wal-mart.com/HiringCenter/homeScreen waljobs walmart jobs Karen
		

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				outputWriter.println(
				Q.table(StringUtil.delimit(" ", args) , true)
				);
			}
		}, "sql");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				new TimeTrackingCommand().exec(args, outputWriter);
			}
		}, "t");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Run.execProcessOSTextGuts(context.getWorkingDir(), outputWriter, CollectionsB.newList("C:\\Program Files (x86)\\epson\\Epson Scan 2\\Core\\es2launcher.exe", args));
				outputWriter.println("scanexe exited");
			}
		}, "scanexe","scane");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Path srcRoot = Paths.get(SelfNameIndexedFiles.pathString(SelfNameIndexedFiles.SCAN_DIR));
				Path destRoot = context.getWorkingDir();
				List<Path> childrenAbs = FileUtil.getChildrenAbsolute(srcRoot);
				List<Path> destinationFilesAbs = new ArrayList<Path>(childrenAbs.size());
				String nameBase = FileUtil.saferFileName(StringUtil.timeString14(), FileUtil.saferFileName(args));
				if (childrenAbs.size() == 1) { // if just one file, move the individual file without making a folder, prepending nameBase
					Path childAbs = childrenAbs.get(0);
					String childRel = FileUtil.saferFileName(srcRoot.relativize(childAbs).toString());
					Path destAbs = destRoot.resolve(nameBase + "_" + childRel);
					destinationFilesAbs.add(FileUtil.move(childAbs, destAbs)); //TODO CopyAndDelete not ideal, working around a Windows bug...
				} else {
					destRoot = destRoot.resolve(nameBase);
					Files.createDirectories(destRoot);
					for (Path f : childrenAbs) {
						destinationFilesAbs.add(FileUtil.relativizeAndMove(srcRoot, destRoot, f)); //TODO CopyAndDelete not ideal, working around a Windows bug...
					}
				}
				outputWriter.println("file(s) moved without error: "+destinationFilesAbs);
			}
		}, "scanmove", "ss");
		addCommand(new AbstractCommand("This is an alternate to scanmove; it modifies a scan inbox which is a directory junction, and simply updates the junction to point to the actual directory where you want the scanned files to go.") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Path scanInboxJunction = Paths.get("C:\\Users\\b\\junctions\\scan");
				Path destRoot = context.getWorkingDir();
				String nameBase = FileUtil.saferFileName(StringUtil.timeString14(), FileUtil.saferFileName(args), "bscanned");
				destRoot = destRoot.resolve(nameBase);
				Files.createDirectories(destRoot);
				FileUtil.deleteIfExists(scanInboxJunction);
				Run.execProcessOSText(outputWriter, "mklink", "/J", scanInboxJunction, destRoot);
				outputWriter.println("Junction created, go ahead and scan to: " + scanInboxJunction);
			}
		}, "scanjunction");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				DesktopUtil.web("https://forecast.weather.gov/MapClick.php?CityName=Peoria&state=IL&site=ILX&lat=40.745&lon=-89.6092");
			}
		}, "weather", "we");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				journal(outputWriter, argsv);
			}
		}, "jnl");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				File file = journal(outputWriter, argsv);
				Desktop.getDesktop().edit(file);
			}
		}, "jnle");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				journal(outputWriter, argsv+" "+DesktopUtil.getClipboardText());
				
			}
		}, "jnlp","credit");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Paths.get("cannot possibly exist");
				Paths.get("C:/cannot possibly exist");
			}
		}, "sandbox");


		addCommand(new AbstractCommand("Test System.out and System.err because this project may redirect or tee it...") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				System.out.println("out");
				System.err.println("err");
			}
		}, "testsysout");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				outputWriter.println(argsv);
			}
		}, "echo");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				JDBC.class.getName(); // should register the driver

			}
		}, "sqlite");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				B.sh("mkdir /b/t/dir1");
				B.sh("mkdir /b/t/dir2 && mkdir /b/t/dir3");
				B.sh("echo file1 > /b/t/dir1/file1.txt && echo file2 > /b/t/dir2/file2.txt && echo file3 > /b/t/dir3/file3.txt");
				B.sh("ln -s /b/t/dir2 /b/t/dir1/dir2.softlink");
				B.sh("ln /b/t/dir3/file3.txt /b/t/dir1/file3.txt.hardlink");
				System.out.println(B.list(new File("/b/t/dir1/dir2.softlink").list()));
			}
		}, "lndemo");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				java.awt.Toolkit.getDefaultToolkit().beep();
			}
		}, "beep");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				System.out.print(B.randInt(new Integer(args.get(0)), new Integer(args.get(1))));
			}
		}, "randint");

		// stops on first diff. Does not do line-level, line terminators are considered
		// normal characters
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				String charSet = "Cp1252";
				int chunkSize = 250;
				String file1 = "/media/b/6tb_1/t/renee_kids_desktop_bare.txt";
				String file2 = "/media/b/6tb_1/t/renee_kids_desktop_dates_bare_generated.txt";
				B.diff(charSet, chunkSize, file1, file2);
			}

		}, "diff");


		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				System.err.println(B.delimit(args, " ")); // delimit(list(args)," ")
				System.out.println((Object) B.delimit(args, " "));
			}
		}, "echotee");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				System.out.println("asdf2");
			}
		}, "dummy");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				outputWriter.print(SelfNameIndexedFiles.pathString(args.get(0)));
			}
		}, "b");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				refreshBKEYS_PROPS_FILE(outputWriter);
			}
		}, "ff");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Calendar c = new GregorianCalendar(2016, 1, 1);
				for (int i = 0; i < 9; i++) {
					c.get(Calendar.YEAR);
					c.get(Calendar.MONTH);
					c.get(Calendar.DAY_OF_MONTH);
					String uval = ""; // c.get(Calendar.DAY_OF_WEEK)
					System.out.println(uval);
					// Q.sqlMod("insert into cal (year,monthi,dayi) values (?,?,?)",new
					// Object[]{year,month,day});
					// Q.sqlMod("update cal set dayw = ? where year = ? and monthi = ? and dayi =
					// ?",new Object[]{uval, year,month,day});
					c.add(Calendar.DATE, 1);
				}
			}
		}, "updatecal");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				String filename = args.get(0);
				
				Properties p = FileUtil.loadProperties(new File("/l/20")); //TODO test if file does not exist, also obviously abstract for Windows
				String app = p.getProperty(filename.substring(filename.lastIndexOf(".") + 1).toLowerCase());
				if (app == null) {
					app = "xdg-open";
				}
				System.out.print(app.toString());
			}
		}, "getapp");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				String[] deviceLabels = new String[] { "ntfs", "ext4", "fat", "fat32", "ext2" };
				for (String lab : deviceLabels) {
					if (new File("/media/b/" + lab).exists()) {
						System.out.println((Object) ("starting device: " + lab));
						B.copyToMobile("classes", lab);
						B.copyToMobile("dummy", lab);
						B.copyToMobile("lnb", lab);
						B.copyToMobile("/home/b", "ba.sh", lab);
					}
				}
				for (String lab : deviceLabels) {
					if (new File("/media/b/" + lab).exists()) {
						System.out.println((Object) ("starting backup to device: " + lab));
					}
				}
			}
		}, "gomobile");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Properties p = System.getProperties();
				for (Object key : p.keySet()) { // properties.keys()
					System.out.println((Object) (key + "=" + System.getProperty(key.toString())));
				}
			}
		}, "sysprops");
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				System.out.println((Object) context.getWorkingDir().toString());
			}
		}, "pwd");


		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				B.unitTest();
			}
		}, "unittest");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				InputStream is = System.in;
				try {
					BufferedReader br = new BufferedReader(new InputStreamReader(is));
					String line = br.readLine();
					while (line != null) {
						// String err = line.substring(0, 23);
						// String out = line.substring(23, line.length());
						/* System.out.print(err); */ System.out.println(/* out */line);
						line = br.readLine();
					}
				} catch (Exception e) {
					ExceptionUtil.rethrowRuntime(e);
				}

			}
		}, "fcout");// /media/b/5tb/b/src/java/openjdk-7_source_code_from_debian_source_dvd_7/jdk-1e6db4f8b0f3/src/share/classes
		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				System.out.println((Object) "07:00");
			}
		}, "compiletest");// /media/b/5tb/b/src/java/openjdk-7_source_code_from_debian_source_dvd_7/jdk-1e6db4f8b0f3/src/share/classes

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				int i = 0;
				String from;
				if (args.size() > 1) {
					from = args.get(i++);
				} else {
					from = context.getWorkingDir().toString();
				}
				if (from.equals(".")) {
					from = context.getWorkingDir().toString();
				}
				String to = "/b/Moth9/archive/" + StringUtil.timeString14() + "_" + args.get(i++).replaceAll(" ", "_");
				new File(to).mkdir();
				Runtime.getRuntime().exec(new String[] { "cp", "-a", from, to }, new String[] { /* env vars */ },
						new File(context.getWorkingDir().toString()));
			}
		}, "archive");

		addCommand(new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				while (true) {
					try (FileOutputStream fos = new FileOutputStream("/5/t/batch.log", true);) {
						fos.write((StringUtil.timeString14() + "\n").getBytes());
						Thread.sleep(1000 * 60 * 1);
					}
				}
			}
		}, "batch");
		addCommand(new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				outputWriter.print(SelfNameIndexedFiles.pathString(args.get(0)));
			}
		}, "bfile");
		addCommand((argsv1, x1, x2, context1) -> {
			String slpath = SelfNameIndexedFiles.pathString(SelfNameIndexedFiles.SHOPPING_LIST);
			DesktopUtil.desktop(slpath);
		} ,  "sl");
		addCommand((argsv, args, writer, context)->{
			writer.println(context.getWorkingDir().toString() );
		}, "pwd");
		addCommand(new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				throw new OutOfMemoryError("attempting to force heap dump, not really out of memory (yet)");
			}
		}, "heapdump");
		addCommand((argsv3, x11, x21, context3) -> {
			String slpath1 = SelfNameIndexedFiles.pathString(SelfNameIndexedFiles.SHOPPING_LIST);
			Desktop.getDesktop().print(new File(slpath1));
		}, "slp");
		addCommand(newWinExplorerCmd(SelfNameIndexedFiles.BODY_FOLDER), "bod");
		addCommand((argsv2, x1, x2, context2) -> {
			String slpath = SelfNameIndexedFiles.pathString(SelfNameIndexedFiles.BODY_FOLDER);
			DesktopUtil.desktop(slpath);
		}, "bodtest");
		addCommand((argsv, args, writer, context)->{
			DesktopUtil.web("https://www.google.com/search?q="+StringUtil.urlEncode(args));
		}, "se");
		
	}

	/**
	 * This is a workaround as per these sites: https://bugs.openjdk.java.net/browse/JDK-8233994 and https://stackoverflow.com/questions/40963947/open-a-file-in-default-file-explorer-and-highlight-it-using-javafx-or-plain-java/51017185#51017185
	 * But Desktop.open seems to work as well which would be a more elegant solution
	 * 
	 * @param bKey
	 * @return
	 */
	private static Command newWinExplorerCmd(final String bKey) {
		return new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Path target = Paths.get(SelfNameIndexedFiles.pathString(bKey));
				String[] parts = new String[]{"c:/windows/explorer.exe","/root,\""+target+"\""};  //select,path also helpful
				Run.execOSTextCollectOutput(parts);
			}
		};
	}

	public static File journal(PrintWriter outputWriter, String argsv) {
		String timeString14 = StringUtil.timeString14();
		String descriptiveFileName = FileUtil.saferFileName(StringUtil.startStringUpTo(150, argsv));
		File file = new File(SelfNameIndexedFiles.pathString("3")+"/dated/"+timeString14+"_jnl_"+descriptiveFileName+".txt");
		FileUtil.write(file, timeString14 + " " + argsv);
		outputWriter.println("journal file written: "+file);
		return file;
	}

	public static void refreshBKEYS_PROPS_FILE(PrintWriter outputWriter) {
		final Properties bprops = SelfNameIndexedFiles.getRefreshedBKeySpecialFileLinkIndex(outputWriter);
		SelfNameIndexedFiles.setBKEYS(bprops); //replace central cache in memory of running JVM
		FileUtil.writeProperties(bprops, SelfNameIndexedFiles.BKEYS_PROPS_FILE.toFile()); //persist for future JVM invocations
		outputWriter.println("special file link properties file updated");
	}
}
