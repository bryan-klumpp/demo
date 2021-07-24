package com.bryanklumpp.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.net.URL;
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
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.core.MakeTheValidatorHappyException;
import com.bryanklumpp.core.StringUtil;

/**
 * @author Bryan Klumpp
 * 
 *         File operations.  In the process of converting as much as possible to use NIO.
 *
 */
public class FileUtil {
	private static final String         DIR_DECORATION_LABEL =                  "_________(dir)";
	private static final String CONTEXT_DIR_DECORATION_LABEL = "__________________________(context directory)";
	private static final Comparator<Path> LAST_MODIFIED_COMPARATOR = Comparator.comparing(t -> {
		try {
			return Files.getLastModifiedTime(t);
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
			throw new MakeTheValidatorHappyException(e);
		}
	});
	
	public static void deleteIfExists(Path p) throws IOException {
		try {
			Files.delete(p);
		} catch (NoSuchFileException e) {
			ExceptionUtil.eatIt(e);
		}
	}

	
	/**
	 * It's generally easier to work with Windows file paths if the backslashes are
	 * turned to forward slashes, and Windows itself even allows this in many
	 * places. This also allows more commands to operate on relative file paths
	 * without worrying about Windows vs. Linux
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
	
	public static Path getBestSingleMatch(List<String> args, CommandContext context) {
		Path best;
		if (args.isEmpty()) {
			best = context.getWorkingDir();
		} else {
			FileTypeMatcher ftm = FileTypeMatcher.ALL;
			List<PathSearchStrategy> strategies = CollectionsB.newList();
			strategies.add   (PathSearchStrategy.getExactMatchStrategy(ftm)); 
			strategies.addAll(PathSearchStrategy.CUSTOM_EXTRA_MATCH_STRATEGIES);
			strategies.add   (PathSearchStrategy.getRegexClosestLevelMatchStrategy(ftm));
			
			best = getBestSingleMatch(context.getWorkingDir(), args, strategies);
		}
		return best;
	}

	public static Path getBestSingleMatch(Path workingDirectory, List<String> fileFrags, List<PathSearchStrategy> strategies) {
		Path bestMatch = null;
		for(PathSearchStrategy strategy: strategies) {
			FileSearchResult res = strategy.getMatches(workingDirectory, fileFrags);
			if ( ! res.matches.isEmpty()) {
				bestMatch = getShortestPathFromSiblings(res.matches);
				break; // no need to try more strategies, just return result from the first strategy that matched
			}
		}
		return bestMatch;
	}

	
	private static Path getShortestPathFromSiblings(List<Path> siblings) {
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

	public static String getAbsolutePathString(Path p) {
		return p.toAbsolutePath().toString();
	}

	public static void write(String file, String contents) {
		write(new File(file), contents);
	}
	public static void write(File file, String contents) {
		try (FileWriter fw = new FileWriter(file); ) {
			fw.write(contents);
		} catch (IOException e) {
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

	/**
	 * Will exclude symbolic links which are not supported at this time
	 * 
	 * @param dir
	 * @return
	 * @throws IOException
	 */
	public static Stream<Path> children(Path dir) throws IOException {
		return Files.list(dir);
	}

	/**
	 * Sorts file list by last modified, showing last modified at the bottom
	 * 
	 * @param dir
	 * @param w
	 * @throws IOException
	 */
	public static void prettyPrintChildren(Path dir, PrintWriter w) throws IOException {
		//note that performance-wise the sort does force reading the entire list before printing any output: https://stackoverflow.com/questions/58383060/some-of-the-stateful-intermediate-operation-in-java-8-stream-are-still-lazy-seek
		
		try (Stream<Path> s = children(dir).sorted(LAST_MODIFIED_COMPARATOR);) {
			s.forEach(new Consumer<Path>() {
				@Override
				public void accept(Path p) {
					prettyPrint(p, w);
				}
			});
			printWorkingDirectory(w, dir);
		}
	}

	public static String forwardSlashFilePath(Path p) {
		return forwardSlashFilePath(p.toString());
	}

	/**
	 * Files.isDirectory is wrapped here to facilitate skipping symbolic links
	 * (which are more complexity than the rest of the code is prepared to deal with
	 * right now). TODO search workspace and utilize this where possible
	 * 
	 * @param p
	 * @return
	 */
	public static boolean isDirectory(Path p) {
		return FileTypeMatcher.DIRECTORIES_ONLY.isMatch(p);
	}

	public static OutputStream nullOutputStream() {
		return new OutputStream() {
			@Override
			public void write(int b) throws IOException {
				// note we could probably save some method calls by overriding other methods,
				// but I'm going with simpler code here unless there's a serious measured
				// performance hit. There's a nullWriter() method in newer JREs when we get
				// there, but this is to keep compatibility with Java 1.8 for now.
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

	public static Properties loadProperties(File file) {
		Properties p = new Properties();
		try(FileInputStream fis=new FileInputStream(file)) {
			p.load(fis);
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
		return p;
	}

	public static void writeProperties(Properties bprops, File propsFile) {
		try(FileOutputStream fos = new FileOutputStream(propsFile)) {
			bprops.store(fos, "");
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static void printWorkingDirectory(PrintWriter w, Path workingDirectory) {
		w.println(FileUtil.forwardSlashFilePath(workingDirectory) + CONTEXT_DIR_DECORATION_LABEL);
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

	public static Path locateCompiledClassFile(Class c) {
		URL resourceURL = ClassLoader
				.getSystemResource(c.getName().replaceAll("\\.", "/").concat(".class"));
		String fullPathString;
		try {
			fullPathString = Paths.get(resourceURL.toURI()).toString();
		} catch (URISyntaxException e) {
			throw new RuntimeException(e);
		}
		return Paths.get(fullPathString);
	}

	public static void findAndPrint(CommandContext context, PrintWriter w, List<String> args) {
		int maxDepth = Integer.MAX_VALUE; //maybe limit this default if you have crazy number of files
		if(StringUtil.isInteger(args.get(0))) {
			maxDepth = Integer.valueOf(args.get(0));
			args = CollectionsB.newSubList(1, args);
		}
		List<Path> matches = getMatches(context.getWorkingDir(), args, FileTypeMatcher.ALL, maxDepth).matches;
		prettyPrint(matches, w);
	}

}
