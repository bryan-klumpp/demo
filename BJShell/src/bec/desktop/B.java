package bec.desktop;

import java.io.BufferedReader;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.Writer;
import java.nio.file.AccessDeniedException;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.ContextEnvironment;
import com.bryanklumpp.core.RunResults;
import com.bryanklumpp.core.StringUtil;

import bec.file.FileUtil;

public class B {
	
	public static void scrapbook() {
		System.out.println("Hello World4");
		throw new RuntimeException("testing");
	}
	
	public static final long MILLIS_IN_DAY = 86400000;

    private static final String fs = "/";
	public static void main(String[] args) {
        try {
            main2(args);
        } catch (Exception e) {
            ExceptionUtil.rethrowRuntime(e);
        }
    }

    static String prettyPrint(Object[] o) {
        return StringUtil.delimit("\n", o);
    }

    static String alnum = "[:alnum:]";

    static RunResults sh(String... parts) {
        String[] parts2 = new String[parts.length + 2];
        System.arraycopy(parts, 0, parts2, 2, parts.length);
        parts2[0] = "bash";
        parts2[1] = "-c";
        return Run.execOSTextCollectOutput(parts2);
    }

	static void assertContains(String s1, String s2) {
        if (!s1.contains(s2)) {
            throw new RuntimeException("\"" + s1 + "\" does not contain \"" + s2 + "\"");
        }
    }
    static int gematriaVal(char lowerCaseLetter) {
		if(lowerCaseLetter == 'a') {
			return 1;
		} else {
			return (gematriaVal((char)(lowerCaseLetter - 1)));
		}
	}

    B() {}



	protected static void copyToMobile(String bDir, String mobileDeviceLabel) {
        String root = "/b";
        copyToMobile(root, bDir, mobileDeviceLabel);
    }

    /**
     * actually searches for all folders that still need to be scanned for
     * offensive content
     */
    static void findMoth(Path contextDir) throws Exception {
        String higherDir = contextDir.toString();
        final List<Path> possibleOffenders = new ArrayList<>();
        final Path root = getPath(higherDir);
        Files.walkFileTree(root, new java.nio.file.FileVisitor<Path>() {
            @Override
            public FileVisitResult visitFileFailed(Path path, IOException e) throws IOException {
                if (e instanceof AccessDeniedException) {
                    if (path.toString().contains("lost+found")) { //harmless
                        return FileVisitResult.SKIP_SUBTREE;
                    }
                }
                throw e;
            }

            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
                    throws IOException {
                FileUtil.read(S.toString(file));
                return FileVisitResult.CONTINUE;
            }

            @Override
            public FileVisitResult preVisitDirectory(Path path, BasicFileAttributes attrs)
                    throws IOException {
                //~ Path targetdir = target.resolve(source.relativize(dir));
                File pathF = path.toFile();
                pathF.getAbsolutePath();
                String dirNameShort = pathF.getName();
                if (path.equals(root)) {
                    return FileVisitResult.CONTINUE;
                }
                if (FileUtil.containsFileNameFrag(path, "flag_recursive_Moth0.txt") || dirNameShort.contains("Moth0")) {
                    return FileVisitResult.SKIP_SUBTREE;
                }
                if (FileUtil.containsFileNameFrag(path, "flag_filesonly_Moth0.txt")) {
                    return FileVisitResult.CONTINUE;
                }
                possibleOffenders.add(path);
                return FileVisitResult.CONTINUE;
            }

            @Override
            public FileVisitResult postVisitDirectory(Path dir, IOException e)
                    throws IOException {
                if (e != null) {
                    // directory iteration failed
                    throw e;
                }
                return FileVisitResult.CONTINUE;
            }
        });
        sop(possibleOffenders);
    }

    public static void copyToMobile(String root, String from,
            String mobileDeviceLabel) {
        copy(new File(root + "/" + from), new File("/media/b/" + mobileDeviceLabel + "/" + from));
    }

    //note: assumes recursive if a directory is passed in
    private static void copy(File from, File to) {
        if (from.isDirectory()) {
            for (File fromSub : from.listFiles()) {
                String name = fromSub.getName();
                File toSub = new File(to.getPath() + fs + name);
                copy(fromSub, toSub);
            }
            return;
        }
        to.getParentFile().mkdirs();
        try {
            try (FileInputStream in  =  new FileInputStream (from);
                FileOutputStream out =  new FileOutputStream( to ); ) { 
            	stream(in, out);
            }
        } catch (IOException e) {
            ExceptionUtil.rethrowRuntime(e);
        }
    }

    private static void stream(InputStream in,
            OutputStream out) {
        byte[] buf = new byte[1024 ^ 2];
        try {
            int ct = in.read(buf, 0, buf.length);
            while (ct != -1) {
                out.write(buf, 0, ct);
                ct = in.read(buf, 0, buf.length);
            }
        } catch (IOException e) {
            ExceptionUtil.rethrowRuntime(e);
        }
    }
    //TODO below Expensive2  maybe more if compiled?
    public static SimpleDateFormat SQLITE_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    public static SimpleDateFormat NUMERIC_SIMPLE_DATE_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");

    public static SimpleDateFormat[] WHOLE_DATE_FORMATS = new SimpleDateFormat[]{SQLITE_DATE_FORMAT, NUMERIC_SIMPLE_DATE_FORMAT, new SimpleDateFormat("yyyy-MM-dd"), new SimpleDateFormat("yyyyMMdd")};

    public static String sqlite(Date d) {
        return SQLITE_DATE_FORMAT.format(d);
    }

    public static String btime(Date d) {
        return NUMERIC_SIMPLE_DATE_FORMAT.format(d);
    }

    public static Timestamp timestamp(String s, boolean expectValidFormat, boolean logIfParseException) {
        try {
            //special case time only, assume within past 24 hours
            if (s.matches("[012]?\\d:[012345]\\d")) {
                SimpleDateFormat f = new SimpleDateFormat("H:m");
                Date timeOnly = f.parse(s);
                GregorianCalendar g = new GregorianCalendar(); //use today's date
                 g.set(Calendar.HOUR_OF_DAY, timeOnly.getHours());  //untested, trying to get rid of compiler warning as per 2021-06-14
                g.set(Calendar.MINUTE, timeOnly.getMinutes());  //untested, trying to get rid of compiler warning as per 2021-06-14
                g.set(Calendar.SECOND, 0);
                g.set(Calendar.MILLISECOND, 0);
                Long gMillis = g.getTimeInMillis();
                if (gMillis > System.currentTimeMillis()) {
                    g.add(Calendar.DATE, -1); //TODO test possible month boundary rollover bug
                }
                return new Timestamp(g.getTimeInMillis());
            }
        } catch (ParseException ex) {
            if (logIfParseException) {
            	ExceptionUtil.systemErrLogException(ex);
            }
        }
        for (SimpleDateFormat f : WHOLE_DATE_FORMATS) {
            try {
                return new Timestamp(f.parse(s).getTime());
            } catch (ParseException ex) {
                //ignore, try the next one
            }
        }
        if (expectValidFormat) {
            throw new RuntimeException("did not find valid timestamp format");
        }

        return null;
    }
    static List<String> findb(final File file, String encoding) {
        final List<String> returnMe = new ArrayList<String>();
        final List<Pattern> firstCutPatterns = getCaseInsensitivePatternsFromFile(new File("/media/b/5tb/Cat/0_MASTER_Caterpillar_originally_from_crisis_hpt_home/crisis/file_list/other_peoples_computers_list_grabbed_during_2015_crisis/criteria/firstcut.txt"));
        final List<Pattern> whitelistPatterns = getCaseInsensitivePatternsFromFile(new File("/media/b/5tb/Cat/0_MASTER_Caterpillar_originally_from_crisis_hpt_home/crisis/file_list/other_peoples_computers_list_grabbed_during_2015_crisis/criteria/whitelist.txt"));

        visitLines(file, encoding, new Adapter<String, String>() {
            public String adapt(String line) {
                if (containsAnyPattern(line, firstCutPatterns) && !containsAnyPattern(line, whitelistPatterns)) {
                    returnMe.add(file.getName() + ":::" + line);
                }
                return null; //unused return capability
            }

            private boolean containsAnyPattern(String s,
                    final List<Pattern> patterns) {
                boolean firstCut = false;
                for (Pattern p : patterns) {
                    if (contains(s, p)) {
                        firstCut = true;
                        break;
                    }
                }
                return firstCut;
            }
        });
        return returnMe;
    }

    private static List<Pattern> getCaseInsensitivePatternsFromFile(File f) {
        return adapt(readLines(f, null), new Adapter<String, Pattern>() {
            public Pattern adapt(String s) {
                return Pattern.compile(s, Pattern.CASE_INSENSITIVE);
            }
        });
    }

    protected static boolean contains(String s, Pattern p) {
        return group(0, p, s) != null;
    }
    
    static String[] array(List<String> l) {
		return (String[])l.toArray();
	}

    private static List<String> readLines(File file, String encoding) {
        final List<String> returnMe = new ArrayList<String>();
        final Adapter<String, String> adapter = new Adapter<String, String>() {
            public String adapt(String line) {
                returnMe.add(line);
                return null;
            }
        };
        visitLines(file, encoding, adapter);
        return returnMe;
    }

    /**
     * @param file
     * @param encoding
     * @param adapter
     * 
     * example usage of feature introduced with Java SE 7 : try-with-resources 
     * note that this code does not nest constructors, as cautioned against in per https://dzone.com/articles/carefully-specify-multiple-resources-in-single-try
     */
    private static void visitLines(File file, String encoding,
            final Adapter<String, String> adapter) {
		try (FileInputStream fis = new FileInputStream(file);
		     Reader          isr = encoding == null ? new InputStreamReader(fis) : new InputStreamReader(fis, encoding);
		     BufferedReader   br = new BufferedReader(isr);
		) {
			String line = br.readLine();
			while (line != null) {
				adapter.adapt(line);
				line = br.readLine();
			}
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
    }

    protected List<File> dir(File dir) {
        return list(dir.listFiles());
    }

    public static <P, R> List<R> adapt(List<P> l, Adapter<P, R> adapter) {
        List<R> returnMe = new ArrayList<R>(l.size());
        for (P p : l) {
            returnMe.add(adapter.adapt(p));
        }
        return returnMe;
    }

    protected void breakPoint() {
        // TODO Auto-generated method stub

    }

    protected void makeBare(File filePath, File outputDir) {
        final String ignoreLine = "renee_kids_desktop_dates.txt";
        tru(filePath.getPath().contains("."));
        List<String> pathSplit = pathSplit(filePath);
        String genBarePath = outputDir + "/" + pathSplit.get(1) + "_bare_generated." + pathSplit.get(2);
        deleteFile(genBarePath);
        try {
//            final ;

            
			try (FileOutputStream out = new FileOutputStream(genBarePath, true);
					Writer bareWriter = new OutputStreamWriter(out, "Cp1252")) {
                String charsetName = "Cp1252"; //hard to recall but I think this was needed for processing Windows-written files from a Linux PC
                final Mutable<String> curDir = new Mutable<String>();
                final Adapter<String, String> lineVisitor = new Adapter<String, String>() {
                    @Override
                    public String adapt(String line) {
                        try {
                            Pattern p = getPatternI("Directory of (.*)$");
                            Pattern p2 = getPatternI("^((.{24}<\\w{3,8}> {5,10})|(.{37}\\d ))(.*?)( \\[.*\\])?$");
                            String s1 = group(1, p, line);
                            String outputLine = null;
                            if (s1 != null) {
                                curDir.o = s1;
                            } else if (curDir.o != null) {
                                String s2 = group(4, p2, line);
                                if (s2 != null && !s2.matches("\\.\\.?") && !s2.contains(ignoreLine)) {
                                    outputLine = (curDir + (curDir.o.endsWith("\\") ? "" : "\\") + s2);
                                }
                            }
                            if (outputLine != null) {
                                bareWriter.write(outputLine + "\r\n"); //preserve Windows line terminator, not Linux
                            }
                        } catch (IOException e) {
                            ExceptionUtil.rethrowRuntime(e);
                        }
                        return null;
                    }
                };
                visitLines(filePath, charsetName, lineVisitor);
            }
        } catch (Exception e) {
            ExceptionUtil.rethrowRuntime(e);
        }
    }

    static private void deleteFile(String path) {
        File file = new File(path);
        deleteFile(file);
    }

    public static void deleteFile(File file) {
        file.delete();
    }


    static protected String group(int i, Pattern pattern, String s) {
        Matcher m = pattern.matcher(s);
        if (m.find()) {
            return m.group(i);
        }
        return null;
    }

    private static void tru(boolean b) {
        if (!b) {
            fail();
        }
    }

    public static void fail() {
        String message = "";
        fail(message);
    }

	//note: lines are not re-output, which might seem to some to be intuitive, but perhaps some lines should not be output so adapter gets to choose
	/**
	 * @param lineProcessor
	 * @param isp  NOTE this will be closed at the end
	 */
	public static void processLinesWithStreamClose(Adapter<String, String> lineProcessor, InputStream isp) {
		try (final InputStream is = isp;
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);) {
			String nextLine = br.readLine();
			while (nextLine != null) {
				lineProcessor.adapt(nextLine);
				nextLine = br.readLine();
			}
		} catch (IOException e1) {
			ExceptionUtil.rethrowRuntime(e1);
		}
	}

    private static void fail(String message) {
        throw new RuntimeException("assertion failed: " + message);
    }

    //TODO check for intellectual property violation
    private static List<String> pathSplit(File f) {
        String filePath = f.getPath();
        tru(filePath.contains("/"));
        String leafName = f.getName();
        String pathWithoutLeafName = filePath.replace("/" + leafName, "");
        List<String> returnMe = new ArrayList<String>(3);
        returnMe.add(pathWithoutLeafName);
        if (!filePath.contains(".") || filePath.endsWith(".")) {
            returnMe.add(leafName);
        } else {
            int i = leafName.lastIndexOf(".");
            returnMe.add(leafName.substring(0, i));
            returnMe.add(leafName.substring(i + 1, leafName.length()));
        }
        return returnMe;
    }

    public static Pattern getPatternI(String s) {
        return Pattern.compile(s, Pattern.CASE_INSENSITIVE);
    }

    protected static String upTo(String s, int n) {
        return s.substring(0, (min(s.length(), n) - 1));
    }

    static int min(int j, int k) {
        return j < k ? j : k;
    }

    static int max(int j, int k) {
        return j > k ? j : k;
    }

    static Path getPath(String path) {
        return FileSystems.getDefault().getPath(path);
    }

    static void main2(String[] args) throws Exception {
        if (args.length == 0) {
            unitTest();
            return;
        }
        if (args.length > 0 && CollectionsB.hasKey(DraftCommands.getStaticCommands(), args[0])) {
            try {
                final Command cmd = DraftCommands.getStaticCommands().get(args[0]);
                List<String> largs = list(args);
                largs.remove(0);
				cmd.exec(StringUtil.delimit(" ", args), largs, ContextEnvironment.SYSTEM_OUT_PRINTWRITER, CommandContext.DEFAULT_CMD_CONTEXT);
				ContextEnvironment.SYSTEM_OUT_PRINTWRITER.flush();
            } catch (Exception e) {
                ExceptionUtil.rethrowRuntime(e);
            }
        } else {
            listCommands();
        }
    }

    static void listCommands() {
        sop("commands:");
        for (String key : DraftCommands.getStaticCommands().keySet()) {
            sop(key);
        }
    }

    //private static void tsk() {
    ////diatheke("TSK","");
    //}
    static java.util.List<File> climb(String f) {
        java.util.List<File> list = new ArrayList<File>();
        climb(new File(f), list);
        return list;
    }

    static void climb(File f, java.util.List<File> list) {
        list.add(f);
        if (f.isDirectory()) {
            File[] files = f.listFiles();
            for (File next : files) {
                climb(next, list);
            }
        }
    }

    public static void diff(String charSet, int chunkSize, String file1, String file2) {
		try {
			try (   FileInputStream fis1 = new FileInputStream(file1);
					FileInputStream fis2 = new FileInputStream(file2);
					final InputStreamReader in1 = new InputStreamReader(fis1, charSet);
					InputStreamReader in2 = new InputStreamReader(fis2, charSet);
					BufferedReader br1 = new BufferedReader(in1);
					BufferedReader br2 = new BufferedReader(in2);) {
				char[] chunk1 = new char[chunkSize];
				char[] chunk2 = new char[chunkSize];
				// TODO make sure we are verifying the last chunk properly, including when the
				// last chunk happens to be full-sized or partial
				int i1 = br1.read(chunk1);
				int i2 = br2.read(chunk2);
				String s1 = new String(Arrays.copyOf(chunk1, i1));
				String s2 = new String(Arrays.copyOf(chunk2, i2));
				while (i1 == chunkSize) {
					/*
					 * no need to check i2 because if they aren't equal, an Exception should be
					 * thrown in the String check ?? TODO revisit this and compare lengths
					 */
					assertEquals(s1, s2);
					i1 = br1.read(chunk1);
					i2 = br2.read(chunk2);
					s1 = new String(Arrays.copyOf(chunk1, i1));
					s2 = new String(Arrays.copyOf(chunk2, i2));
				}
				assertEquals(s1, s2); // tail check
			}
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
    }

    protected void makeBare() {
        File sourceDir = new File("/media/b/5tb/Cat/0_MASTER_Caterpillar_originally_from_crisis_hpt_home/crisis/file_list/other_peoples_computers_list_grabbed_during_2015_crisis/dates_original");
        File outputDir = new File("/media/b/5tb/Cat/0_MASTER_Caterpillar_originally_from_crisis_hpt_home/crisis/file_list/other_peoples_computers_list_grabbed_during_2015_crisis");
        for (File path : dir(sourceDir)) {
            makeBare(path, outputDir);
        }
    }

    static boolean isDir(File f) {
        return f.isDirectory();
    }

    static void sop(Object o) {
        System.out.println(o.toString());
    }

    static void sop(Object[] o) {
        if (o.toString() == "") {
            breakpoint();
        }
        System.out.println(list(o));
    }

    static void sop(List<?> l) {
        for (Object o : l) {
            sop(o);
        }
    }

    private static void breakpoint() {
        "".toString(); //dummy code
    }

    static void so(Object o) {
        System.out.print(o.toString());
    }

    static void assertTrue(boolean b) {
        if (!b) {
            throw new RuntimeException("something wrong here");
        }
    }
    
    static void assertClose(double left, double right, double d) {
		double diff = Math.abs(left - right);
		assertTrue(diff < (left * d) && diff < (right * d));
	}

    static void assertEquals(Object o1, Object o2) {
        if (!o1.equals(o2)) {
            String o1s = o1.toString(), o2s = o2.toString();
            throw new RuntimeException("something wrong here: \no1 length " + o1s.length() + "=" + escapeJava(o1s) + "\no2 length " + o2s.length() + "=" + escapeJava(o2s));
        }
    }

    private static String escapeJava(String s) {
        return s;
    }

    static <K, V> Set<K> keys(Map<K, V> m) {
        return m.keySet();
    }

    static boolean isPackageDir(File dir) {
        return !dir.getPath().contains("META-INF") && StringUtil.delimit("", list(dir.list())).contains(".java");
    }

    static void unitTest() throws Exception {
        int bufSize = 1024;
        StringBuffer sb = new StringBuffer("   aaaaaaaaaaaa\r\naaaaaaaaaaaaa\raaaaaaaaaaaaa\naaaaa汉语 / 漢語aaaaaa aa"); //throw some interesting stuff in there including some UTF-8 characters
        String padString = "0123456789";
        for (int i = 0; i < (bufSize / padString.length()); i++) {
            sb.append(padString);
        } //make it bigger than buffer size
        String testString = sb.toString(), testFile = "/tmp/testFile.txt";
        FileUtil.write(testFile, testString);
        assertEquals(testString, (FileUtil.readCustom(testFile, bufSize, null)));

        assertContains(Run.execOSTextCollectOutput(new String[]{"echo", "asdf\nasdf"}).getNormalOutput(), "asdf\nasdf");
        assertContains(Run.execOSTextCollectOutput(new String[]{"bash", "/sh/echoe.sh", "this_is_an_error"}).getNormalOutput(), "this_is_an_error");
        RunResults tee = Run.execOSTextCollectOutput(new String[]{"bash", "/sh/echotee.sh", "write_this_to_both"});
        assertContains(tee.getErrorOutput(), "write_this_to_both");
        assertEquals(tee.getNormalOutput(), tee.getErrorOutput());
        RunResults teeEmpty = Run.execOSTextCollectOutput(new String[]{"echo", "-n"});
        assertEquals(teeEmpty.getNormalOutput(), "");
        assertEquals(teeEmpty.getNormalOutput(), teeEmpty.getErrorOutput());
        assertEquals(pathSplit(new File("/b/b/b/asdf")), ilist("/b/b/b", "asdf"));
        assertEquals(pathSplit(new File("/b/b/b/asdf.")), ilist("/b/b/b", "asdf.")); //special case, hopefully rare
        assertEquals(pathSplit(new File("/b/b/b/asdf.txt")), ilist("/b/b/b", "asdf", "txt"));
//        new FileOutputStream("/b/t/does_this_file_exist.txt");

        try {
            assertEquals(0, Q.sqlMod("create table sandbox( mytext varchar )"));
            String nightmareUnicodeString = nightmareUnicodeStringRandom(500);
            assertEquals(1, Q.sqlMod("insert into sandbox(mytext) values (?)", nightmareUnicodeString));
            assertEquals("" + nightmareUnicodeString, Q.cell("select mytext from sandbox where mytext = ?", nightmareUnicodeString));
        } finally {
            Q.sqlMod("drop table sandbox");
        }
        timestamp("23:00", true, true);
        
        assertEquals(TimeTrackingCommand.dadcat("asdf"),"asdf");
        assertEquals(TimeTrackingCommand.dadcat("asdf#yyy"),"asdf");
        assertEquals(TimeTrackingCommand.dadcat("asdf:yyy"),"asdf");
        assertEquals(TimeTrackingCommand.dadcat("asdf yyy"),"asdf");
        
        sop("back2geany");
        sop("unit testing complete with no Exceptions. Woohoo!");
//        System.out.flush();
//        System.err.flush();
    }


    static <T> List<T> list(T[] array) {
        List<T> l = new ArrayList<>(array.length);
        for (T next : array) {
            l.add(next);
        }
        return l;
    }


    //heap pollution warning? TODO
    //static <T> List<T> ilist(? extends T... items) {
    //	return list(items);
    //}
    static List<String> ilist(String... items) {
        return list(items);
    }

    static <T> Iterable<T> iter(final Enumeration<T> e) {
        return new Iterable<T>() {
            public Iterator<T> iterator() {
                return new Iterator<T>() {
                    public boolean hasNext() {
                        return e.hasMoreElements();
                    }

                    public T next() {
                        return e.nextElement();
                    }

                    public void remove() {
                        throw new UnsupportedOperationException("backed by Enumeration, remove() not supported");
                    }
                };
            }
        };
    }

    //static <T> T cast(Object obj) {
    //	return (T)obj;
    //}
    static <T> List<T> list(List<T> l) {
        return l;
    }

    public static void textEditor(String filePath) {
        sop(Run.execOSTextCollectOutput("nautilus").getNormalOutput());
    }

    public static String nightmareUnicodeStringRandom(int numCodePoints) {
        return nightmareUnicodeStringRandom(numCodePoints, Character.MAX_CODE_POINT);
    }

    //Moth1 uses some ideas from Moth code (much of this b.B class does so actually) but significant new functionality here
    public static String nightmareUnicodeStringRandom(int numCodePoints, int maxCodePoint) {
        List<Character> chars = new ArrayList<>(numCodePoints * 2); //initial size assumes lots of multi-byte characters
        for (int i = 0; i < numCodePoints; i++) {
            int codePoint = (int)randInt(Character.MIN_CODE_POINT, maxCodePoint);
            char[] ca = Character.toChars(codePoint);
            for (char c : ca) {
                chars.add(c);
            }
        }
        return toString(chars);
    }

	//Moth1 did this at Moth but pretty basic code here
    public static long randInt(long min, long max) {
        long span = max - min;
        return min + Math.round((Math.random() * span));
    }

    private static String toString(List<Character> l) {
        char[] a = new char[l.size()];
        int i = 0;
        for (Character c : l) {
            a[i++] = c;
        }
        return new String(a);
    }
    public static double parseDouble(Object o) {
		return Double.parseDouble(o.toString());
	}
//    public static <T> List<T> list(T[] a) {
	//	List<T> l = new ArrayList<>(a.length);
		//for(int i=0;i<a.length;i++){l.add(a[i]);}
//		return l;
	//}



	public static <T> Iterable<T> iterable(final Iterator<T> iterator) {
		return new Iterable<T>() {
			public Iterator<T> iterator() {
				return iterator;
			}
		};
	}

	public static PrintWriter sysOutWriter() {
		return new PrintWriter(new OutputStreamWriter(System.out), true);
	}

	public static void close(Closeable is) {
		throw new RuntimeException("unsupported_______");
	}

	public static Path bp(String key) {
		return Paths.get(SpecialCustomIndexedFiles.b(key));
	}

	public static String delimit(List<? extends Object> list, String delimiter) {
		return StringUtil.delimit(delimiter, list);
	}

}


/*class MutableP<T> {

    public T o = null;

    public MutableP(T p_o) {
        o = p_o;
    }

    public Mutable() {
    }

    public String toString() {
        return o == null ? null : o.toString();
    }
} */
