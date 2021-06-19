package bec.desktop;

import java.util.Properties;
import java.util.regex.Pattern;

import bec.file.FileUtil;

/**
 * @author Bryan Klumpp
 * 
 *         This class enables a file organization strategy whereby special files
 *         can be indexed by using a special pattern at the beginning of the
 *         file name; for example, a file named b18_shopping_list.docx has index
 *         number 18, and b18_ at the beginning of the file name is what marks
 *         it as such. A special batch job is run periodically (or on demand) to
 *         update a properties file that maps the index number to the current
 *         location of the file on disk. The file can then be used by calling
 *         method .b(18) - even if the rest of the file name or the containing
 *         folders have been renamed/reorganized. This is much less brittle than
 *         traditional soft links.
 */
public class SpecialCustomIndexedFiles {

	public static final Pattern NON_MASTER_FILE_PATTERN = Pattern.compile("(\\.lnk$|RECYCLE.BIN|backup|copy|archive|RecentDocuments|transfer|wav_masters|tmp|hardlink|deleteme|coreboot)");
	public static final Pattern SPECIAL_CUSTOM_INDEXED_FILE_PATTERN = Pattern.compile("/b([0-9]{1,})_[^/]*$");

	public static final String SHOPPING_LIST = "18";
	public static final String SQLITE_DB = "15";
	public static final String JOURNAL = "3";
	public static final String BODY_FOLDER = "444";
	public static final String SCAN_DIR = "4750";
	public static final String STUFF_ORGANIZER = "100";
	public static final String BKEYS_PROPS_FILE = "c:\\users\\b\\Documents\\bkeys.properties";
	static private Properties BKEYS = loadBSpecialFileProperties();
	protected static Properties loadBSpecialFileProperties() {
		try {
			return FileUtil.loadProperties(BKEYS_PROPS_FILE);
		} catch (Exception e) {
			e.printStackTrace();
			return new Properties();
		}
	}
	public static String b(String bkey) {
		return BKEYS.getProperty(bkey);
	}
	public static String b(int bkey) {
		return BKEYS.getProperty(String.valueOf(bkey));
	}
}
