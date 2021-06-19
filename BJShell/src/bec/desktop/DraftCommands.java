package bec.desktop;

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

import com.bryanklumpp.bjshell.BJShell;
import com.bryanklumpp.bjshell.DesktopUtil;
import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.MakeTheValidatorHappyException;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.ThreadUtil;
import com.bryanklumpp.file.FileTypeMatcher;

import bec.file.FileUtil;
import bec.file.PathSearchStrategy;

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

	static Command newOpenDesktopCmd(String bKey) {
		return (argsv, x1, x2, context) -> {
			String slpath = SpecialCustomIndexedFiles.b(bKey);
			Run.desktop(slpath);
		};
	}
	static Command newPrintDesktopCmd(String bKey) {
		return (argsv, x1, x2, context) -> {
			String slpath = SpecialCustomIndexedFiles.b(bKey);
			Desktop.getDesktop().print(new File(slpath));
		};
	}

	public static void addCommand(Command cmd, String... keys) {
		CollectionsB.putMultipleKeys(COMMANDS, cmd, keys);
	}
	
	private static void buildCmdsExpensive2() {

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.sop(StringUtil.urlEncode(args.get(0)));
			}
		}, "urlencode");
		addCommand((argsv, a, w, context) ->  {
			new BJShell();
		}, "bjshell");
		addCommand((argsv, args, w, context) ->  {
			args = StringUtil.argsWithClipboardDefault(args);
			FileUtil.findAndPrint(args, context, w);
			w.println("## done searching for: "+argsv+" ##");
			FileUtil.printContextDirectory(w, context.getContextDir());
		}, "f");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				List<Path> matches = FileUtil.getMatchesDeep(context.getContextDir(), args, FileTypeMatcher.ALL);
				FileUtil.prettyPrint(matches, w);
			}
		}, "s");
		
		

		addCommand((argsv, args, w, context) ->  {
			args = StringUtil.argsWithClipboardDefault(args);
			Path result = FileUtil.getBestMatch(context.getContextDir(), args, 
					PathSearchStrategy.getExactMatchStrategy(FileTypeMatcher.NON_DIRECTORIES),
					PathSearchStrategy.getRegexClosestLevelMatchStrategy(FileTypeMatcher.NON_DIRECTORIES) );
			if(result != null) {
				File file = result.toFile();
				w.println("opening: "+file);
				ThreadUtil.sleepSeconds(1);
				Desktop.getDesktop().open(file);
			}else {
				w.println("no match found");
			}
		}, "o");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.findMoth(context.getContextDir());
			}
		}, "findMoth");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				// Panel p = new JPanel();
				// p.show();
				// p.getGraphics().draw()...
			}
		}, "white");
		addCommand(new MakeBLinksCommand(), "bln");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				System.out.println("x");
				String s = args.get(0).toLowerCase();
				int num = 0;
				for (int i = 0; i < s.length(); i++) {
					num += B.gematriaVal(s.charAt(i));
				}
				System.out.println("gematria: " + num);
			}
		}, "countword");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Alarm.main2(args);
			}
		}, "alarm");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				final Pattern slashPattern = B.getPatternI("(.*?)/");
				InputStreamReader isr = new InputStreamReader(System.in);
				BufferedReader br = new BufferedReader(isr);
				List<String> lines = new ArrayList<>();
				String nextLine = br.readLine();
				while (nextLine != null) {
					lines.add(nextLine);
					nextLine = br.readLine();
				}
				Collections.sort(lines, new Comparator<String>() {
					@Override
					public int compare(String s1, String s2) {
						B.group(1, slashPattern, s1);
						B.group(1, slashPattern, s2);
						// TODO finish logic
						return 0;
					}
				});
				for (String sLine : lines) {
					System.out.println(sLine);
				}
			}
		}, "sortShortestLast");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.processLinesWithStreamClose(new Adapter<String, String>() {
					public String adapt(String nextFilePath) {
						String[] charsets = new String[] { "US-ASCII", "ISO-8859-1", "Cp1252" };
						new HashMap<>();
						String utf8Contents = FileUtil.readCustom(nextFilePath, 1024 ^ 3, "UTF-8");
						for (String cs : charsets) {
							String otherCharsetContents = FileUtil.readCustom(nextFilePath, 1024 ^ 3, cs);
							if (!otherCharsetContents.equals(utf8Contents)) {
								System.out.println("mismatch with charset " + cs + " for file " + nextFilePath);
							}
						}
						// if(!mismatch)sop("ckutf8 file ok: "+nextFilePath);
						return null;
					}
				}, System.in);
			}
		}, "ckutf8");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				final Mutable<Long> totSize = new Mutable<Long>(0L);
				B.processLinesWithStreamClose(new Adapter<String, String>() {
					public String adapt(String line) {
						File f = new File(line);
						totSize.set(totSize.get() + f.length());
						return null;
					}
				}, System.in);
				// double totSizeMiB = ((double)totSize) / (double)(1024*1024);
				// totSizeMiB = Math.round(totSizeMiB);
				B.so(totSize);
			}
		}, "size");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.processLinesWithStreamClose(new Adapter<String, String>() {
					public String adapt(String line) {
						File f = new File(line);
						B.so(B.btime(new Date(f.lastModified())) + "_____ "); // last modified date for sorting
						B.sop(line + (f.isDirectory() ? "/" : "")); // directories end in slash
						return null;
					}
				}, System.in);
			}
		}, "findDecorate");
		addCommand(new Command() { // ##
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				String pstart = args.get(0), pend = args.get(1);
				Timestamp start = B.timestamp(pstart, true, true), end = B.timestamp(pend, true, true);
				double pdiff = (end.getTime() - start.getTime()) / B.MILLIS_IN_DAY;
				String mainSql = "select sum(effort) totalDays, pubcat from v_do_log where pubcat is not null and start > ? and end < ? group by pubcat";
				double totalTime = B.parseDouble(
						Q.cell("select sum(totalDays) from (" + mainSql + ")", B.sqlite(start), B.sqlite(end)));
				B.sop("pdiff: " + pdiff);
				B.sop("totalTime: " + totalTime + " days");
				B.assertClose(pdiff, totalTime, .02);
				B.sop(Q.table(
						"select round(100 * totalDays / " + pdiff
								+ ", 1)||' %' percent, pubcat category, pubcat.desc from (" + mainSql
								+ ") main left join pubcat on main.pubcat = pubcat.key order by totalDays desc",
						true, B.sqlite(start), B.sqlite(end)));
			}
		}, "timesum");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				// Warn.play(Alarm.AUDIO);
			}
		}, "bark");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				// Warn.loop(Alarm.AUDIO);
			}
		}, "barkloop");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
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
		addCommand(new Command() { 
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
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
					B.sop(forwardA[i]);
				}
			}
		}, "reverse");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.sop(Q.table("select * from b", true));
			}
		}, "borg");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				List<String> l = CollectionsB.newList();
				l.add(Run.MSEDGE_EXE);
				l.add("-inprivate");
				l.addAll(args);
				Run.execProcessOSTextGuts(context.getContextDir(), w, l);
			}
		}, "inprivate", "priv","webp"); //https://storejobs.wal-mart.com/HiringCenter/homeScreen waljobs walmart jobs Karen
		

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				w.println(
				Q.table(StringUtil.delimit(" ", args) , true)
				);
			}
		}, "sql");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				new TimeTrackingCommand(w).exec(args);
			}
		}, "t");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Run.execProcessOSTextGuts(context.getContextDir(), w, CollectionsB.newList(Run.EPSON_SCAN_EXE, args));
				w.println("scanner closed");
			}
		}, "scanexe","scane");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Path srcRoot = Paths.get(SpecialCustomIndexedFiles.b(SpecialCustomIndexedFiles.SCAN_DIR));
				Path destRoot = context.getContextDir();
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
				w.println("file(s) moved without error: "+destinationFilesAbs);
			}
		}, "scanmove", "sm");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Path scanInboxJunction = Paths.get("C:\\Users\\b\\junctions\\scan");
				Path destRoot = context.getContextDir();
				String nameBase = FileUtil.saferFileName(StringUtil.timeString14(), FileUtil.saferFileName(args));
				destRoot = destRoot.resolve(nameBase);
				Files.createDirectories(destRoot);
				FileUtil.deleteIfExists(scanInboxJunction);
				Run.execProcessOSText(null, w, "mklink", "/J", scanInboxJunction, destRoot);
				w.println("Junction created, go ahead and scan to: " + scanInboxJunction);
			}
		}, "scanjunction", "sj");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				DesktopUtil.web("https://forecast.weather.gov/MapClick.php?CityName=Peoria&state=IL&site=ILX&lat=40.745&lon=-89.6092");
			}
		}, "weather", "we");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				journal(w, argsv);
			}
		}, "jnl");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				File file = journal(w, argsv);
				Desktop.getDesktop().edit(file);
			}
		}, "jnle");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				journal(w, argsv+" "+DesktopUtil.getClipboardText());
				
			}
		}, "jnlp","credit");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Paths.get("cannot possibly exist");
				Paths.get("C:/cannot possibly exist");
			}
		}, "sandbox");


		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				System.err.println(B.delimit(B.list(args), " "));
			}
		}, "echoe");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				w.println(B.delimit(B.list(args), " "));
			}
		}, "echo");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				JDBC.class.getName(); // should register the driver

			}
		}, "sqlite");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.sh("mkdir /b/t/dir1");
				B.sh("mkdir /b/t/dir2 && mkdir /b/t/dir3");
				B.sh("echo file1 > /b/t/dir1/file1.txt && echo file2 > /b/t/dir2/file2.txt && echo file3 > /b/t/dir3/file3.txt");
				B.sh("ln -s /b/t/dir2 /b/t/dir1/dir2.softlink");
				B.sh("ln /b/t/dir3/file3.txt /b/t/dir1/file3.txt.hardlink");
				B.sop(new File("/b/t/dir1/dir2.softlink").list());
			}
		}, "lndemo");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				java.awt.Toolkit.getDefaultToolkit().beep();
			}
		}, "beep");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				System.out.print(B.randInt(new Integer(args.get(0)), new Integer(args.get(1))));
			}
		}, "randint");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				File currentDir = new File(context.getContextDir().toString());
				new FileTreeBWalker(new Visitor<File>() {
					public void visit(File next) {
						if (next.isDirectory() && next.list().length == 0) {
							B.deleteFile(next);
						}
					}
				}).walk(currentDir);
			}
		}, "prune");

		// stops on first diff. Does not do line-level, line terminators are considered
		// normal characters
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				String charSet = "Cp1252";
				int chunkSize = 250;
				String file1 = "/media/b/6tb_1/t/renee_kids_desktop_bare.txt";
				String file2 = "/media/b/6tb_1/t/renee_kids_desktop_dates_bare_generated.txt";
				B.diff(charSet, chunkSize, file1, file2);
			}

		}, "diff");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.scrapbook();
				// final String nightmareUnicodeStringRandom =
				// nightmareUnicodeStringRandom(500);
				// sop(nightmareUnicodeStringRandom.length() + " - " +
				// nightmareUnicodeStringRandom);
				// makeBare();
				// List<File> files = dir(new
				// File("/5/Cat/0_MASTER_Caterpillar_originally_from_crisis_hpt_home/crisis/file_list/other_peoples_computers_list_grabbed_during_2015_crisis"));
				// for(File file:files) {
				// if(!file.isDirectory()) {
				// sop(findb(file, "Cp1252"));
				// }
				// }
			}
		}, "scrapbook");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				System.err.println(B.delimit(args, " ")); // delimit(list(args)," ")
				B.sop(B.delimit(args, " "));
			}
		}, "echotee");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				System.out.println("asdf2");
			}
		}, "dummy");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				w.print(SpecialCustomIndexedFiles.b(args.get(0)));
			}
		}, "b");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
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
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				String filename = args.get(0);
				
				Properties p = FileUtil.loadProperties("/l/20");
				String app = p.getProperty(filename.substring(filename.lastIndexOf(".") + 1).toLowerCase());
				if (app == null) {
					app = "xdg-open";
				}
				B.so(app);
			}
		}, "getapp");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				String[] deviceLabels = new String[] { "ntfs", "ext4", "fat", "fat32", "ext2" };
				for (String lab : deviceLabels) {
					if (new File("/media/b/" + lab).exists()) {
						B.sop("starting device: " + lab);
						B.copyToMobile("classes", lab);
						B.copyToMobile("dummy", lab);
						B.copyToMobile("lnb", lab);
						B.copyToMobile("/home/b", "ba.sh", lab);
					}
				}
				for (String lab : deviceLabels) {
					if (new File("/media/b/" + lab).exists()) {
						B.sop("starting backup to device: " + lab);
					}
				}
			}
		}, "gomobile");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Properties p = System.getProperties();
				for (Object key : p.keySet()) { // properties.keys()
					B.sop(key + "=" + System.getProperty(key.toString()));
				}
			}
		}, "sysprops");
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.sop(context.getContextDir().toString());
			}
		}, "pwd");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception { // options FileVisitResult.SKIP_SUBTREE,
																				// SKIP_SIBLINGS, CONTINUE, and
																				// TERMINATE in javadoc
				if (args.size() > 0 && new File(args.get(0)).exists()) {
					B.sop(args.get(0));
					return;
				}
				final List<Pattern> patterns = new ArrayList<>();
				for (String arg : args) {
					patterns.add(B.getPatternI(arg));
				}
				final Mutable<Boolean> found = new Mutable<Boolean>(Boolean.FALSE);
				// TODO following is just not working, need to write my own walker
				for (int i = 2; i < 10 && !found.o.booleanValue(); i++) { // try deeper each time - a little crude
																			// because we are doing some re-visiting,
																			// but simple
					Files.walkFileTree(context.getContextDir(), new HashSet<FileVisitOption>(), i, new SimpleFileVisitor<Path>() {
						@Override
						public FileVisitResult visitFileFailed(Path path, IOException e) {
							if (!(e instanceof AccessDeniedException
									|| e.toString().matches(".*AccessDeniedException.*/(lost\\+found|root)$"))) {
								ExceptionUtil.rethrowRuntime(e);
								throw new MakeTheValidatorHappyException(e);
							} else {
								return FileVisitResult.CONTINUE;
							}
						}

						@Override
						public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
							return FileVisitResult.CONTINUE; // only care about directories
						}

						@Override
						public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs)
								throws IOException {

							String abs = FileUtil.getAbsolutePathString(dir);
							if (abs.matches("/(proc)")) {
								return FileVisitResult.SKIP_SUBTREE;
							}

							for (Pattern p : patterns) {
								if (B.group(0, p, abs) == null) {
									return FileVisitResult.CONTINUE; // ALL patterns need to match
								}
							}
							System.out.println(abs);
							found.o = Boolean.TRUE;
							return FileVisitResult.TERMINATE; // simplify things for now and don't try to choose between
																// results
						}

						@Override
						public FileVisitResult postVisitDirectory(Path dir, IOException e) throws IOException {
							if (e != null) {
								// directory iteration failed
								throw e;
							}
							return FileVisitResult.CONTINUE;
						}
					});
				}
			}
		}, "findDir");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.unitTest();
			}
		}, "unittest");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				String root = context.getContextDir().toString();
				List<File> files = B.climb(root);
				List<String> dirs = new ArrayList<String>();
				for (File f : files) {
					if (f.isDirectory() && B.isPackageDir(f)) {
						String pkg = f.getPath().replace(root, "").replace("/", ".").replaceAll("^.", "");
						if (!pkg.equals("")) {
							dirs.add(pkg);
						}
					}
				}
				B.sop(B.delimit(dirs, " "));
			}
		}, "jpackages");

		// ~ addCommand("alarm", new Cmd() { public void x(List<String> args) throws
		// Exception {
		// ~ Alarm a = new Alarm();
		// ~ if (args.size() > 0) {
		// ~ a.preSnooze = Double.parseDouble(args.get(0));
		// ~ }
		// ~ a.main();
		// ~ } } );
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.climb("/b");
			}
		}, "climb");// /media/b/5tb/b/src/java/openjdk-7_source_code_from_debian_source_dvd_7/jdk-1e6db4f8b0f3/src/share/classes
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
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
		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				B.sop("07:00");
			}
		}, "compiletest");// /media/b/5tb/b/src/java/openjdk-7_source_code_from_debian_source_dvd_7/jdk-1e6db4f8b0f3/src/share/classes

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				int i = 0;
				String from;
				if (args.size() > 1) {
					from = args.get(i++);
				} else {
					from = context.getContextDir().toString();
				}
				if (from.equals(".")) {
					from = context.getContextDir().toString();
				}
				String to = "/b/Moth9/archive/" + StringUtil.timeString14() + "_" + args.get(i++).replaceAll(" ", "_");
				new File(to).mkdir();
				Runtime.getRuntime().exec(new String[] { "cp", "-a", from, to }, new String[] { /* env vars */ },
						new File(context.getContextDir().toString()));
			}
		}, "archive");

		addCommand(new Command() {
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				while (true) {
					try (FileOutputStream fos = new FileOutputStream("/5/t/batch.log", true);) {
						fos.write((StringUtil.timeString14() + "\n").getBytes());
						Thread.sleep(1000 * 60 * 1);
					}
				}
			}
		}, "batch");
		addCommand(new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				w.print(SpecialCustomIndexedFiles.b(args.get(0)));
			}
		}, "bfile");
		addCommand(newOpenDesktopCmd(SpecialCustomIndexedFiles.SHOPPING_LIST) ,  "sl");
		addCommand((argsv, args, writer, context)->{
			writer.println(context.getContextDir().toString() );
		}, "pwd");
		addCommand(new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Path bestMatch = FileUtil.getBestMatch(context.getContextDir(), args, PathSearchStrategy.EXACT_MATCH_DIRS_ONLY, PathSearchStrategy.REGEX_DIRS_ONLY);
				if(bestMatch != null) {
					w.print(bestMatch); //w.flush();
				} else {
					w.print(context.getContextDir()); //w.flush();
				}
			}
		}, "cdd");
		addCommand(new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				throw new OutOfMemoryError("attempting to force heap dump, not really out of memory (yet)");
			}
		}, "heapdump");
		addCommand(newPrintDesktopCmd(SpecialCustomIndexedFiles.SHOPPING_LIST), "slp");
		addCommand(newWinExplorerCmd(SpecialCustomIndexedFiles.BODY_FOLDER), "bod");
		addCommand(newOpenDesktopCmd(SpecialCustomIndexedFiles.BODY_FOLDER), "bodtest");
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
		return new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				Path target = Paths.get(SpecialCustomIndexedFiles.b(bKey));
				String[] parts = new String[]{"c:/windows/explorer.exe","/root,\""+target+"\""};  //select,path also helpful
				Run.execOSTextCollectOutput(parts);
			}
		};
	}

	public static File journal(PrintWriter w, String argsv) {
		String timeString14 = StringUtil.timeString14();
		String descriptiveFileName = FileUtil.saferFileName(StringUtil.startStringUpTo(150, argsv));
		File file = new File(SpecialCustomIndexedFiles.b("3")+"/dated/"+timeString14+"_jnl_"+descriptiveFileName+".txt");
		FileUtil.write(file, timeString14 + " " + argsv);
		w.println("journal file written: "+file);
		return file;
	}
}