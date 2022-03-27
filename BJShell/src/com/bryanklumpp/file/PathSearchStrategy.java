package com.bryanklumpp.file;

import java.io.IOException;
import java.nio.file.AccessDeniedException;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.function.Consumer;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.SystemB;

/**
 * Various ways of searching for individual files/directories or lists of files/directories
 * 
 * @author Bryan Klumpp
 *
 */
public abstract class PathSearchStrategy {
	private static final InheritableThreadLocal<Pattern> SEARCH_EXCLUSIONS = new InheritableThreadLocal<Pattern>();

	public static InheritableThreadLocal<Pattern> getSearchExclusions() {
		return SEARCH_EXCLUSIONS;
	}
	
	/**
	 * User-customizable strategies to be used by default in File Search commands
	 * that typically employ most available strategies.
	 */
	public static final List<PathSearchStrategy> CUSTOM_EXTRA_MATCH_STRATEGIES = CollectionsB.newList();
	
	abstract public FileSearchResult getMatches(Path workingDir, List<String> args);

	public static PathSearchStrategy EXACT_MATCH_DIRS_ONLY = getExactMatchStrategy(FileTypeMatcher.DIRECTORIES_ONLY);

	public static PathSearchStrategy REGEX_DIRS_ONLY = getRegexClosestLevelMatchStrategy(
			FileTypeMatcher.DIRECTORIES_ONLY);

	public static PathSearchStrategy getExactMatchStrategy(FileTypeMatcher ftm) {
		return new PathSearchStrategy() {
			@Override
			public FileSearchResult getMatches(Path workingDir, List<String> args) {
				FileSearchResult res = new FileSearchResult();
				try {
					// for this particular strategy, assume the args represent a single path
					// (possibly with spaces in it) and put them back together
					Path path = Paths.get(StringUtil.delimit(" ", args));
					if ( ! path.isAbsolute() ) {
						path = workingDir.resolve(path);
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
	

	/**
	 * Searches shallow to start; only recurses as deep as needed to find the first
	 * match, finishes that depth level, and then returns
	 * 
	 * @param ftm
	 * @return
	 */
	public static PathSearchStrategy getRegexClosestLevelMatchStrategy(FileTypeMatcher ftm) {
		return new PathSearchStrategy() {
			@Override
			public FileSearchResult getMatches(Path workingDir, List<String> args) {
				List<Pattern> patterns = StringUtil.getPatternsCaseInsensitive(args);
				FileSearchResult res = null;

				/*
				 * this loop may seem inefficient because we traverse over portions of the tree
				 * once for each level, but the alternative would be to cache much larger
				 * portions of the file tree in memory or disk (caching would be needed because
				 * of the shallow-as-possible traversal strategy). Performance seems to be
				 * acceptable for many scenarios, but an alternative that uses caching would be
				 * good to try out
				 */
				boolean doneSearching = false;
				for (int depth = 1; !doneSearching; depth++) {
					res = getLimitedLevelPatternMatches(workingDir, workingDir, patterns, ftm, depth);
					boolean foundSomething = (!res.matches.isEmpty());
					boolean reachedDeepestLevel = res.depthStats.get(depth).getTotalDirs() == 0; // if there are no directories at this level, the search can't go any deeper
					doneSearching = foundSomething || reachedDeepestLevel;
				}
				return res;
			}
		};
	}

	/**
	 * Searches a file tree, providing some automatic statistics, built-in regex
	 * matching with easy "and" matches for multiple regular expression that
	 * automatically operates on relative paths only (excluding the root from
	 * matching operations), etc. By default, symbolic links are not dereferenced or
	 * followed. For directories, to avoid showing what is excessive detail in many
	 * cases, it will not recurse into the children if the parent is a match.
	 * Initially I decided not to use java.nio.file.FileTreeWalker API for several
	 * reasons such as not having easy access to a depth counter, among others. In
	 * hindsight, this method could invoke the FileTreeWalker, although with the
	 * current functionality set, using FileTreeWalker wouldn't simplify the code much.
	 *
	 * 
	 * @param root
	 * @param parent
	 * @param patterns
	 * @param ftm
	 * @param cust
	 * @param depth
	 */
	public static void genericPatternSearchRecursive(Path root, Path parent, List<Pattern> patterns,
			FileTypeMatcher ftm, FileSearchCustomizer cust, int depth) {
		try (Stream<Path> children = FileUtil.children(parent);) {
			children.forEach(new Consumer<Path>() {
				public void accept(Path child) {
					String forwardSlashRelativizedFilePath = FileUtil.forwardSlashFilePath(root.relativize(child));
					if (matchesExclusions(forwardSlashRelativizedFilePath)) {
						return; // don't even bother processing children in this case
					}
					boolean fullMatchConfirmed = false;
					DepthStats depthStats = cust.getResult().depthStats.get(depth);
					if (ftm.isMatch(child)) {
						fullMatchConfirmed = StringUtil.containsAll(forwardSlashRelativizedFilePath, patterns);
						if (fullMatchConfirmed) {
							depthStats.setCountMatches(depthStats.getCountMatches() + 1);
							cust.acceptMatch(child);
						}
					}
					if ( (! Files.isSymbolicLink(child)) && FileUtil.isDirectory(child)) {
						depthStats.setTotalDirs(depthStats.getTotalDirs() + 1);
						if (!fullMatchConfirmed) { 
							if (depth < cust.maxDepth) {
								genericPatternSearchRecursive(root, child, patterns, ftm, cust, depth + 1);
							}
						}
					}
				}
			});
		} catch (AccessDeniedException e) {
			ExceptionUtil.eatIt(e); // Unlikely that inaccessible directories will be the target of a search anyway...
		} catch (IOException e) {
			System.out.println("error with this directory or one of its children: "+parent+" - "+e);
		}
	}

	protected static boolean matchesExclusions(String forwardSlashRelativizedPath) {
		Pattern pattern = SEARCH_EXCLUSIONS.get();
		if (pattern == null) {
			pattern = SystemB.getOSSpecifics().getDefaultFileSearchExclusions();
		}
		return StringUtil.contains(forwardSlashRelativizedPath, pattern);
	}

	/**
	 * Allows specifying a hard limit on search depth
	 * 
	 * @param ftm
	 * @param maxLevel
	 * @return
	 */
	public static PathSearchStrategy getRegexLimitedLevelMatchStrategy(FileTypeMatcher ftm, int maxLevel) {
		return new PathSearchStrategy() {
			@Override
			public FileSearchResult getMatches(Path workingDir, List<String> args) {
				List<Pattern> patterns = StringUtil.getPatternsCaseInsensitive(args);
				return getLimitedLevelPatternMatches(workingDir, workingDir, patterns, ftm, maxLevel);
			}
		};
	}
	public static FileSearchResult getLimitedLevelPatternMatches(Path root, Path parent, List<Pattern> patterns,
			FileTypeMatcher ftm, int maxDepth) {
		FileSearchCustomizer cust = new FileSearchCustomizer(maxDepth) {
			@Override
			public void acceptMatch(Path p) {
				getResult().matches.add(p);
			}
		};
		genericPatternSearchRecursive(root, parent, patterns, ftm, cust, 1);
		return cust.getResult();
	}
}
