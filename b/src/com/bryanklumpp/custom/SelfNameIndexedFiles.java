package com.bryanklumpp.custom;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.AccessDeniedException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.Properties;
import java.util.regex.Pattern;

import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.file.FileUtil;

import dev.desktop.FileTreeWalker;

/**
 * @author Bryan Klumpp
 * 
 *         This class enables a file organization strategy whereby special files
 *         can be indexed by using a special pattern in the file name; for
 *         example, a file named b18_shopping_list.docx has index number 18,
 *         based on index pattern "/b([0-9]{1,})_[^/]*$". A special batch job is
 *         run periodically (or on demand) to update a properties file that maps
 *         the index number to the current location of the file on disk. The
 *         file can then be referenced by calling method bPath("18"). This helps
 *         overcome the brittleness of traditional soft links, because the
 *         remainder of the file name can be changed or the file moved, and 
 *         the index can be updated by a simple refresh job.
 */
public class SelfNameIndexedFiles {

	public static final Pattern NON_MASTER_FILE_PATTERN = Pattern.compile("(\\.lnk$|RECYCLE.BIN|AppData|backup|copy|archive|RecentDocuments|transfer|wav_masters|tmp|hardlink|deleteme|coreboot)");
	public static final Pattern SPECIAL_CUSTOM_INDEXED_FILE_PATTERN = Pattern.compile("/b([0-9]{1,})_[^/]*$");

	public static final String SHOPPING_LIST = "18";
	public static final String SQLITE_DB = "15";
	public static final String JOURNAL = "3";
	public static final String BODY_FOLDER = "444";
	public static final String SCAN_DIR = "4750";
	public static final String STUFF_ORGANIZER = "100";
	public static final Path BKEYS_PROPS_FILE = Paths.get("c:\\users\\b\\Documents\\bkeys.properties");
	private static Properties BKEYS = loadBSpecialFileProperties();
	public static Properties getBKEYS() {
		return BKEYS;
	}
	public static void setBKEYS(Properties bKEYS) {
		BKEYS = bKEYS;
	}
	protected static Properties loadBSpecialFileProperties() {
		try {
			return FileUtil.loadProperties(BKEYS_PROPS_FILE.toFile());
		} catch (Exception e) {
			e.printStackTrace();
			return new Properties();
		}
	}
	public static Path bPath(String bkey) {
		return Paths.get(pathString(bkey));
	}
	public static String pathString(String bkey) {
		return BKEYS.getProperty(bkey);
	}
	public static Properties getRefreshedBKeySpecialFileLinkIndex(PrintWriter outputWriter) {
		final Properties bprops = new Properties();
		
		SimpleFileVisitor<Path> sfv = new SimpleFileVisitor<Path>() {
			@Override
			public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
				if (Files.isSymbolicLink(file)) {
					outputWriter.println("file symbolic link: " + file);
					return FileVisitResult.SKIP_SUBTREE;
				}
				visitFileOrDirectory(file);
				return super.visitFile(file, attrs);
			}
	
			private void visitFileOrDirectory(Path file) {
				String f = file.toString().replaceAll("\\\\", "/");
				String bKey = StringUtil.extractRegex(1, SPECIAL_CUSTOM_INDEXED_FILE_PATTERN, f);
				if (bKey != null) {
					if (!StringUtil.contains(f, NON_MASTER_FILE_PATTERN)) {
						String existing = bprops.getProperty(bKey);
						if (existing != null) {
							outputWriter.println("duplicate path for bkey "+bKey+" - however, new one takes precedence.  New row, then old row shown below:");
							outputWriter.println(f);
							outputWriter.println(existing);
						} 
						bprops.setProperty(bKey, f);
					}
				}
			}
	
			@Override
			public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
				if (Files.isSymbolicLink(dir)) {
					outputWriter.println("directory symbolic link (not following): " + dir);
					return FileVisitResult.SKIP_SUBTREE;
				}
				visitFileOrDirectory(dir);
				return super.preVisitDirectory(dir, attrs);
			}
	
			public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
				if (!(exc instanceof AccessDeniedException || exc instanceof NoSuchFileException)) {
					throw exc;
				} else {
					return FileVisitResult.CONTINUE;
				}
			};
		};
		FileTreeWalker.walk(sfv, "c:\\users\\b");
		FileTreeWalker.walk(sfv, "z:\\");
		return bprops;
	}
}
