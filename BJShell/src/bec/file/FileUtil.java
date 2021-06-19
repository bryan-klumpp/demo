package bec.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.AccessDeniedException;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Properties;
import java.util.function.Consumer;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.MakeTheValidatorHappyException;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.file.FileSearchResult;
import com.bryanklumpp.file.FileTypeMatcher;

import bec.desktop.ExceptionUtil;
import bec.desktop.FileVisitorB;
import bec.desktop.j;

/**
 * @author Bryan Klumpp
 * 
 * TODO all file operations should not follow symbolic links
 *
 */
public class FileUtil {
	private static final String DIR_DECORATION_LABEL = "_________(dir)";
	private static final Comparator<Path> LAST_MODIFIED_COMPARATOR = Comparator.comparing(t -> {
		try {
			return Files.getLastModifiedTime(t);
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
			throw new MakeTheValidatorHappyException(e);
		}
	});
	private static final String WORKING_DIR_DECORATION_LABEL = "__________________________(WD)";
	public static final String home = "/home/bryan/";
	public static final String q = "";
	
	public static void main(String[] args) {
		copyBankStatementsWithoutPwd();
	}

	public static void deleteIfExists(Path p) throws IOException {
		try {
			Files.delete(p);
		} catch (NoSuchFileException e) {
			ExceptionUtil.eatIt(e);
		}
	}

	
	public static Path getPath(String pathString) {
		return Paths.get(pathString);
	}
	
	/**
	 * It's generally easier to work with Windows file paths if the backslashes are
	 * turned to forward slashes, and Windows itself even allows this in many
	 * places. This also allows more commands to operate on relative file paths
	 * without worry about Windows vs. Linux
	 * 
	 * @param s
	 * @return
	 */
	public static String forwardSlashFilePath(String s) {
		return s.replace('\\', '/');
	}

	public static List<Path> getMatchesDeep(Path rootDirectory, List<String> fileFrags, FileTypeMatcher ftm) {
		return getMatches(rootDirectory, fileFrags, ftm, Integer.MAX_VALUE).matches;
	}
	public static FileSearchResult getMatches(Path rootDirectory, List<String> fileFrags, FileTypeMatcher ftm, int maxDepth) {
		List<Pattern> patterns = StringUtil.getPatternsCaseInsensitive(fileFrags);
		return PathSearchStrategy.getLimitedLevelPatternMatches(rootDirectory, rootDirectory, patterns, ftm, maxDepth);
	}
			
	
	public static Pattern getPatternFromFileFrags(List<String> fileFrags) {
		return Pattern.compile(StringUtil.delimit(" ", fileFrags), Pattern.CASE_INSENSITIVE); //TODO not necessarily an accurate reconstruction...
	}
	public static Path getExplorerPath(List<String> args, CommandContext context) {
		Path best;
		if (args.isEmpty()) {
			best = context.getContextDir();
		} else {
			// TODO make this search more strategies
			FileTypeMatcher ftm = FileTypeMatcher.ALL;
			PathSearchStrategy[] strategies = { PathSearchStrategy.getExactMatchStrategy(ftm), 
					                            PathSearchStrategy.B_SPECIAL_PATHS, 
					                            PathSearchStrategy.getRegexClosestLevelMatchStrategy(ftm) };
			best = FileUtil.getBestMatch(context.getContextDir(), args, strategies);
		}
		return best;
	}

	/**
	 * @param workingDirectory
	 * @param fileFrags
	 * @param fileTypes
	 * @return can be null
	 */
	public static Path getBestMatch(Path workingDirectory, List<String> fileFrags, PathSearchStrategy... strategies) {
		
		Path bestMatch = null;
		for(PathSearchStrategy strategy: strategies) {
//			res.countAll = 0;
			FileSearchResult res = strategy.getMatches(workingDirectory, fileFrags);
			if ( ! res.matches.isEmpty()) {
				bestMatch = getBestMatchFromSiblings(res.matches)/*.toAbsolutePath()*/; // TODO pick shortest pathname not just the first
				break; // no need to try more strategies, just after the first decent match
			}
		}
		return bestMatch;
	}

	
	private static Path getBestMatchFromSiblings(List<Path> siblings) {
		int minLength = Integer.MAX_VALUE;
		Path res = null;
		for(Path p : siblings) {
			int pLen = p.toString().length();
			if(pLen < minLength) {
				minLength = pLen;
				res = p;
			}
		}
		return res;
	}

	public static void createBSymbolicLink(Path target, String linki) {
	    try {
			Path link = Paths.get("c:\\l\\"+linki);
			if (Files.exists(link)) {
//	        Files.delete(link);
			}
			Files.createSymbolicLink(link, target);
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}
	
	private static void copyBankStatementsWithoutPwd() {
		final String fin = home + "1/fin/";
		walk(fin + "bank_statements_password", new FileVisitorB() {
			public void visitFile(File f) {
				try {
					final String[] cmdArray = new String[] { "pdftk", f.getPath(), "input_pw", getPwd("b"), "output",
							fin + "bank_statements/" + f.getName() };
					j.o(delimit(" ", cmdArray));
					Runtime.getRuntime().exec(cmdArray);
				} catch (IOException e) {
					ExceptionUtil.rethrowRuntime(e);
				}
			}

			public void visitDirectory(File f) {
			}
		});
	}

	protected static String delimit(String delimitor, Object[] array) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < array.length; i++) {
			sb.append(array[i]);
			if (i < array.length - 1) {
				sb.append(delimitor);
			}
		}
		return sb.toString();
	}

	protected static String getPwd(String key) {
		Properties p = FileUtil.loadProperties(home + "1/p/p.properties");
			return p.getProperty(key);

	}

	public static void walk(String root, FileVisitorB fv) {
		for (File f : new File(root).listFiles()) {
			if (f.isDirectory()) {
				fv.visitDirectory(f);
			} else {
				fv.visitFile(f);
			}
		}
	}

	public static String getFirstExisting(String... filePaths) {
		for (String s : filePaths) {
			if (new File(s).exists()) {
				return s;
			}
		}
		return null;
	}

	public static void append(Path file, String s) {
		try ( FileWriter fw = new FileWriter(file.toFile().getCanonicalPath(), true); ) {
			fw.write(s);
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static boolean containsFileNameFrag(Path dir, String fragment) {
		for(File f:dir.toFile().listFiles()) {
			if(f.getName().contains(fragment)) {
				return true;
			}
		}
		return false;
	}

	public static String getAbsolutePathString(Path p) {
		return p.toAbsolutePath().toString();
	}

	public static String read(String filePath) {
	    return readCustom(filePath, 1024 ^ 3, "utf-8");
	}

	/**
	 * @Deprecated
	 * 
	 * @param filePath
	 * @param bufSize
	 * @param encoding
	 * @return
	 */
	public static String readCustom(String filePath, int bufSize, String encoding) {
		StringBuffer sb = new StringBuffer();
		try (  FileInputStream fileInput = new FileInputStream(filePath);
			   Reader reader = encoding == null ? new InputStreamReader(fileInput)	: new InputStreamReader(fileInput, encoding);) {
			char[] buf = new char[bufSize > 0 ? bufSize : 1024 ^ 3];
			int ct = reader.read(buf, 0, buf.length);
			while (ct > 0) {
				if (ct == buf.length) {
					sb.append(buf);
				} else {
					char[] endbuf = new char[ct];
					System.arraycopy(buf, 0, endbuf, 0, ct);
					sb.append(endbuf);
				}
				ct = reader.read(buf, 0, buf.length);
			}
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
		return sb.toString();
	}
	public static void write(String file, String contents) {
		write(new File(file), contents);;
	}
	public static void write(File file, String contents) {
		try (FileWriter fw = new FileWriter(file); ) {
			fw.write(contents);
		} catch (IOException e) { //TODO Eclipse bug the auto-suggest that created this block made it Exception when we only needed IOException (also too bad Java doesn't allow us to only catch exceptions from the close operation).
			ExceptionUtil.rethrowRuntime(e);
		}
	}


	public static void printChildrenBare(Path dir, PrintWriter w) throws IOException {
		try (Stream<Path> s = children(dir);) {
			s.forEach(new Consumer<Path>() {
				@Override
				public void accept(Path p) {
					w.println(p.toString());
				}
			});
		}
	}

	public static Stream<Path> children(Path dir) throws IOException {
		return Files.list(dir);
	}

	public static void prettyPrintChildren(Path dir, PrintWriter w) throws IOException {
		//note that performance-wise the sort does force reading the entire list before printing any output: https://stackoverflow.com/questions/58383060/some-of-the-stateful-intermediate-operation-in-java-8-stream-are-still-lazy-seek
		
		try (Stream<Path> s = children(dir).sorted(LAST_MODIFIED_COMPARATOR);) {
			s.forEach(new Consumer<Path>() {
				@Override
				public void accept(Path p) {
					prettyPrint(p, w);
				}
			});
			printContextDirectory(w, dir);
		}
	}

	public static String forwardSlashFilePath(Path p) {
		return forwardSlashFilePath(p.toString());
	}

	protected static boolean isDirectory(Path p) {
		return Files.isDirectory(p);
	}

	public static OutputStream nullOutputStream() {
		return new OutputStream() {
			@Override
			public void write(int b) throws IOException {
				// note we could probably save some method calls by overriding other methods,
				// but I'm going with simpler code here unless there's a serious measured
				// performance hit.  There's a nullWriter() method in newer JREs when we get there.
			}
		};
	}

	public static void prettyPrint(Path p, PrintWriter w) {
		String ps = FileUtil.forwardSlashFilePath(p.toString());
		w.println(isDirectory(p) ? ps + DIR_DECORATION_LABEL : ps);
	}
	public static void prettyPrint(List<Path> paths, PrintWriter w) {
		for(Path p : FileUtil.sortByLastModified(paths)) {
			prettyPrint(p, w);
		}
	}

	public static Properties loadProperties(String fileName) {
		Properties p = new Properties();
		try(FileInputStream fis=new FileInputStream(fileName)) {
			p.load(fis);
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
		return p;
	}

	public static void writeProperties(Properties bprops, String propsFile) {
		try(FileOutputStream fos = new FileOutputStream(new File(propsFile))) {
			bprops.store(fos, "");
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static void printContextDirectory(PrintWriter w, Path workingDirectory) {
		w.println(FileUtil.forwardSlashFilePath(workingDirectory) + WORKING_DIR_DECORATION_LABEL);
	}

	public static List<Path> getChildrenAbsolute(Path parent) throws IOException {
		final List<Path> children = new ArrayList<Path>();
		try (Stream<Path> s = children(parent);) {
			s.forEach(new Consumer<Path>() {
				@Override
				public void accept(Path p) {
					children.add(p);
				}
			});
		}
		return children;
	}
	public static List<Path> getChildrenRelative(Path parent) throws IOException {
		final List<Path> children = new ArrayList<Path>();
		try (Stream<Path> s = children(parent);) {
			s.forEach(new Consumer<Path>() {
				@Override
				public void accept(Path p) {
					children.add(parent.relativize(p));
				}
			});
		}
		return children;
	}
//	public static List<Path> getCopyWithRelativePaths(Path parent, List<Path> children) {
//		List<Path> res = new ArrayList<Path>(children.size());
//		for(Path child : children) {
//			res.add(parent.relativize(child));
//		}
//		return res;
//	}

	/**
	 * @param srcRoot
	 * @param destRoot
	 * @param absChild
	 * @return the destination file
	 */
	public static Path relativizeAndMove(Path srcRoot, Path destRoot, Path absChild) {
		try {
			Path rel = srcRoot.relativize(absChild);
			Path destAbs = destRoot.resolve(rel);
			move(srcRoot.resolve(rel), destAbs);
			return destAbs;
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
			throw new MakeTheValidatorHappyException(e);
		}
	}

	/**
	 * 
	 * @param src
	 * @param dest
	 * @return dest
	 * @throws IOException
	 */
	public static Path move(Path src, Path dest) throws IOException {
		Files.move(src, dest);
		return dest;
	}

	/**
	 * This will combine strings into one String; perhaps not an obvious choice but
	 * hopefully the exceptions don't become the rule...
	 * 
	 * @param s
	 * @return
	 */
	public static String saferFileName(String... s) {
		return saferFileName(Arrays.asList(s));
	}
	/**
	 * This will combine strings into one String; perhaps not an obvious choice but
	 * hopefully the exceptions don't become the rule...
	 * 
	 * @param s
	 * @return
	 */
	public static String saferFileName(List<String> s) {
		return StringUtil.delimit("_", s).replaceAll("[^A-Za-z0-9_-]","_"); //TODO add escaping for special characters, etc.
	}

	public static Object loadObject(Path serFile) {
		try(FileInputStream fis = new FileInputStream(serFile.toFile());
				ObjectInputStream ois=new ObjectInputStream(fis);){
			return ois.readObject();
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
			throw new MakeTheValidatorHappyException(e);
		} catch (ClassNotFoundException e) {
			ExceptionUtil.rethrowRuntime(e);
			throw new MakeTheValidatorHappyException(e);
		}
	}
	public static void saveObject(Path serFile, Object object) {
		try(FileOutputStream fos = new FileOutputStream(serFile.toFile());
				ObjectOutputStream oos=new ObjectOutputStream(fos);){
			oos.writeObject(object);
		} catch (FileNotFoundException e) {
			ExceptionUtil.rethrowRuntime(e);
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static List<Path>sortByLastModified(List<Path> list) {
		return list.stream().sorted(LAST_MODIFIED_COMPARATOR).collect(Collectors.toList());
	}

	public static Path locateResource(String resource) {
		URL resourceURL = ClassLoader
				.getSystemResource(resource.replaceAll("\\.", "/").concat(".class"));
		String fullPathString;
		try {
			fullPathString = Paths.get(resourceURL.toURI()).toString();
		} catch (URISyntaxException e) {
			throw new RuntimeException(e);
		}
		String s = forwardSlashFilePath(fullPathString);
		Path resourcePath = Paths.get(s);
		return resourcePath;
	}

	public static void findAndPrint(List<String> args, CommandContext context, PrintWriter w) {
		int maxDepth = Integer.MAX_VALUE; //maybe limit this default if you have crazy number of files
		if(StringUtil.isInteger(args.get(0))) {
			maxDepth = Integer.valueOf(args.get(0));
			args = CollectionsB.newSubList(1, args);
		}
		List<Path> matches = getMatches(context.getContextDir(), args, FileTypeMatcher.ALL, maxDepth).matches;
		prettyPrint(matches, w);
	}

}
