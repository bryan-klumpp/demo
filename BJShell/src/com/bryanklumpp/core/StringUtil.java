package com.bryanklumpp.core;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.bryanklumpp.bjshell.DesktopUtil;

public class StringUtil {
	
	public static final String N = System.getProperty("line.separator");
	
	public static boolean containsAll(String s, Collection<Pattern> patterns) {
		boolean foundPatternMissing = false;
		for(Pattern patt : patterns) {
			if( !StringUtil.contains(s, patt)) {
				foundPatternMissing = true;
				break;
			}
		}
		return !foundPatternMissing;
	}

	public static String extractRegex(String regex, String src) {
		return extractRegex(Pattern.compile(regex), src);
	}
	
	public static String extractRegex(Pattern pattern, String src) {
		return extractRegex(0, pattern, src);
	}
	
	public static String extractRegex(int i, Pattern pattern, String src) {
		Matcher matcher = pattern.matcher(src);
		boolean matchFound = matcher.find();
		if (matchFound) {
			return matcher.group(i);
		} else {
			return null;
		}
	}

	public static String spaceDelim(List<String> args) {
		return oneStringSpaceDelimited(args);
	}
	public static String reassembleArgs(List<String> args) {
		return oneStringSpaceDelimited(args);
	}
	public static String oneStringSpaceDelimited(List<String> frags) {
		return delimit(" ", frags);
	}
	public static String underSD(String... frags) {
		return delimit("_", Arrays.asList(frags));
	}
	public static String underSD(List<String> frags) {
		return delimit("_", frags);
	}
	public static String delimit(String delimiter, String ...strings ) {
		return delimit(delimiter, Arrays.asList(strings));
	}
	public static String delimit(String delimiter, Object[] o) {
		return delimit(delimiter, Arrays.asList(o));
	}
	public static String delimit(String delimiter, List<? extends Object> objects) {
		StringBuffer sb = new StringBuffer();
		boolean first = true;
		for(Object o:objects) {
			if (first) {
				first = false;
			} else {
				sb.append(delimiter);
			}
			sb.append(o);
		}
		return sb.toString();
	}
	
	public static boolean contains(String src, Pattern patt) {
		return extractRegex(patt, src) != null;
	}
	public static boolean contains(String src, String regex) {
		return extractRegex(regex, src) != null;
	}

	public static <T> Comparator<T> getToStringComparator() {;
		return new Comparator<T>() {
			@Override
			public int compare(T o1, T o2) {
				if(o1 == null) {
					return -1;
				}
				return o1.toString().compareTo(o2.toString());
			}
		};
	}

	public static List<String> argsWithClipboardDefault(List<String> args) {
		if (args.isEmpty()) {
			String clipboardText = DesktopUtil.getClipboardText();
			clipboardText = StringUtil.extractRegex("^[^\r\n]*", clipboardText);
			return CollectionsB.newList(clipboardText);
		}
		return args;
	}

	public static boolean isInteger(String string) {
		try {
			Integer.valueOf(string);
		} catch (NumberFormatException e) { 
			return false;
		}
		return true;
	}
	public static Integer intOrDefault(String string, int defaultInt) {
		Integer res;
		try {
			res = Integer.valueOf(string);
		} catch (NumberFormatException e) { 
			return defaultInt;
		}
		return res;
	}
	/**
	 * @param string
	 * @return -1 if not an integer string
	 */
	public static Integer getPositiveInteger(String string) {
		Integer res;
		try {
			res = Integer.valueOf(string);
		} catch (NumberFormatException e) { 
			return -1;
		}
		return res;
	}

	public static List<Pattern> getPatternsCaseInsensitive(List<String> args) {
		return CollectionsB.transform(args, (s) -> {
			return Pattern.compile(s, Pattern.CASE_INSENSITIVE);
		});
	}

	public static String timeString14() {
	    return new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
	}


	public static String startStringUpTo(int i, String s) {
		return s.substring(0, (s.length() < i ? s.length() : i));
	}

	/**
	 * @param <T>
	 * @param lines
	 * @return one String, multiple lines, but no endline character after last line
	 */
	public static <T> String toStringMultiLine(Collection<T> lines) {
		StringBuffer sb = new StringBuffer();
		boolean first = true;
		for(T next : lines) {
			if (first) {
				first = false;
			} else {
				sb.append(StringUtil.N);
			}
			sb.append(next);
		}
		return sb.toString();
	}

	/**
	 * Prints multiple lines to a PrintWriter, a println for each line (including
	 * the last one, so an endline character will be the last thing printed
	 * 
	 * @param <T>
	 * @param lines
	 * @param outputWriter
	 */
	public static <T> void printAsLines(Collection<T> lines, PrintWriter outputWriter) {
		for(T line : lines) {
			outputWriter.println(line);
		}
	}

	public static String lastNChars(int len, String text) {
		if (text.length() <= len) {
			return text;
		}
		return text.substring(text.length() - len, text.length());
	}

	public static String urlEncode(String... args) throws UnsupportedEncodingException {
		return urlEncode(Arrays.asList(args));
	}

	public static String urlEncode(List<String> args) throws UnsupportedEncodingException {
		return URLEncoder.encode(delimit(" ", args), "utf-8");
	}

	public static List<String> tokenize(String str, String delim) {
		return CollectionsB.iteratorToList(iterate(new StringTokenizer(str, delim)));
	}

	public static Iterable<String> iterate(StringTokenizer st) {
		return new Iterable<String>() {
			@Override
			public Iterator<String> iterator() {
				return new Iterator<String>() {
					@Override
					public boolean hasNext() {
						return st.hasMoreTokens();
					}
					@Override
					public String next() {
						return st.nextToken();
					}
				};
			}
		};
	}

	public static List<String> listOfToString(Object[] objects) {
		List<String> l = CollectionsB.newList();
		for(Object o : objects) {
			l.add(String.valueOf(o));
		}
		return l;
	}

	public static Iterable<String> stringIterable(Collection<Object> coll) {
		Iterator<Object> iterO = coll.iterator();
		return new Iterable<String>() {
			@Override
			public Iterator<String> iterator() {
				return new Iterator<String>() {
					@Override
					public boolean hasNext() {
						return iterO.hasNext();
					}
					@Override
					public String next() {
						return String.valueOf(iterO.next());
					}
				};
			}
		};
	}
}
