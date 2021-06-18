package bec.file;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.function.Consumer;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import com.bryanklumpp.core.ContextEnvironment;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.file.FileSearchResult;
import com.bryanklumpp.file.FileTypeMatcher;

import bec.desktop.ExceptionUtil;
import bec.desktop.SpecialCustomIndexedFiles;

public abstract class PathSearchStrategy {
	abstract public FileSearchResult getMatches(Path workingDir, List<String> args);

	PathSearchStrategy() {
	
	}

	public static PathSearchStrategy EXACT_MATCH_DIRS_ONLY = getExactMatchStrategy(FileTypeMatcher.DIRECTORIES_ONLY);
	public static PathSearchStrategy B_SPECIAL_PATHS = getBSpecialPathsStrategy(FileTypeMatcher.ALL);
	public static PathSearchStrategy REGEX_DIRS_ONLY = getRegexClosestLevelMatchStrategy(
			FileTypeMatcher.DIRECTORIES_ONLY);

	public static PathSearchStrategy getExactMatchStrategy(FileTypeMatcher ftm) {
		return new PathSearchStrategy() {
			@Override
			public FileSearchResult getMatches(Path workingDir, List<String> args) {
				FileSearchResult res = new FileSearchResult();
				try {
					Path path = Paths.get(StringUtil.delimit(" ", args));
					boolean isAbsolute = ContextEnvironment.getOSSpecifics().isAbsolutePath(path);
					if (!isAbsolute) {
						path = Paths.get(workingDir + File.pathSeparator + path);
					}
					if (Files.exists(path)) {
						res.matches.add(path);
					}
				} catch (InvalidPathException e) {
					// Somewhat expected if a regex is used and this is not the right strategy.
					// Consider adding trace logging.
					ExceptionUtil.eatIt(e); 
				}
				return res;
			}
		};
	}

	static private PathSearchStrategy getBSpecialPathsStrategy(FileTypeMatcher ftm) {
		return new PathSearchStrategy() {
			@Override
			public FileSearchResult getMatches(Path workingDir, List<String> args) {
				FileSearchResult res = new FileSearchResult();
				String bKey = args.get(0);
				String b = SpecialCustomIndexedFiles.b(bKey);
				if (b != null) {
					Path p = Paths.get(b);
					if (Files.exists(p)) {
						res.matches.add(p);
					}
				}
				return res;
			}
		};
	}

	public static PathSearchStrategy getRegexClosestLevelMatchStrategy(FileTypeMatcher ftm) {
		return new PathSearchStrategy() {
			@Override
			public FileSearchResult getMatches(Path workingDir, List<String> args) {
				List<Pattern> patterns = StringUtil.getPatternsCaseInsensitive(args);
				FileSearchResult res = null;

				// this loop may seem inefficient because we traverse over portions of the
				// tree once for each level, but the alternative would be to cache much larger
				// portions of the file tree in memory.  Performance seems to be fine as-is.
				boolean doneSearching = false;
				for (int depth = 1; !doneSearching; depth++) {
					res = getLimitedLevelPatternMatches(workingDir, workingDir, patterns, ftm, depth);
					boolean foundSomething = (!res.matches.isEmpty());
					boolean reachedDeepestLevel = res.depthStats.get(depth).totalDirs == 0;
					doneSearching = foundSomething || reachedDeepestLevel;
				}
				return res;
			}
		};
	}

	public static PathSearchStrategy getRegexLimitedLevelMatchStrategy(FileTypeMatcher ftm, int maxLevel) {
		return new PathSearchStrategy() {
			@Override
			public FileSearchResult getMatches(Path workingDir, List<String> args) {
				List<Pattern> patterns = StringUtil.getPatternsCaseInsensitive(args);
				new FileSearchResult();
				return getLimitedLevelPatternMatches(workingDir, workingDir, patterns, ftm, maxLevel);
			}
		};
	}

	/**
	 * This provides a bit of functionality not found in the Java NIO FileTreeWalker
	 * API: easy access to the depth counter and some automatic statistics. By
	 * default it will not recurse into the children if the parent is a match
	 * (although if that's your only requirement, that's easy enough to do with the
	 * NIO FileTreeWalker). If a directory matches, listing its children in the
	 * initial search is often just clutter.
	 * 
	 * In the case of IOExceptions (AccessDeniedException, for example), this method
	 * currently prints the exception to System.out.  Room for
	 * improvement in this error handling...
	 * 
	 * @param root
	 * @param parent
	 * @param patterns
	 * @param ftm
	 * @param cust
	 * @param levelsRemaining
	 * @return the number of directories in the deepest level
	 */
	public static void genericPatternSearchRecursive(Path root, Path parent, List<Pattern> patterns,
			FileTypeMatcher ftm, FileSearchCustomizer cust, int depth) {
		try (Stream<Path> children = FileUtil.children(parent);) {
			children.forEach(new Consumer<Path>() {
				public void accept(Path child) {
					boolean fullMatchConfirmed = false;
					DepthStats depthStats = cust.res.depthStats.get(depth);
					if (ftm.isMatch(child)) {
						fullMatchConfirmed = StringUtil.containsAll(FileUtil.forwardSlashFilePath(root.relativize(child)),
								patterns);
						if (fullMatchConfirmed) {
							depthStats.ctMatches++;
							cust.acceptMatch(child);
						}
					}
					boolean isDir = Files.isDirectory(child);
					if (isDir) {
						depthStats.totalDirs++;
						if (!fullMatchConfirmed) { 
							if (depth < cust.maxDepth) {
								genericPatternSearchRecursive(root, child, patterns, ftm, cust, depth + 1);
							}
						}
					}
				}
			});
		} catch (IOException e) {
			System.out.println("error with this directory or one of its children: "+parent+" - "+e);
		}
	}

	public static FileSearchResult getLimitedLevelPatternMatches(Path root, Path parent, List<Pattern> patterns,
			FileTypeMatcher ftm, int maxDepth) {
		FileSearchCustomizer cust = new FileSearchCustomizer(maxDepth) {
			@Override
			void acceptMatch(Path p) {
				res.matches.add(p);
			}
		};
		genericPatternSearchRecursive(root, parent, patterns, ftm, cust, 1);
		return cust.getResult();
	}
}
