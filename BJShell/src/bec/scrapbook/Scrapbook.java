package bec.scrapbook;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;

import bec.desktop.ExceptionUtil;

/**
 * @author Bryan Klumpp
 *
 */
public class Scrapbook {
	/**
	 * @Deprecated
	 * Not sure if this has any usefulness over FileReader... keep for posterity
	 * It might have use in a few fringe cases where more control is needed
	 * TODO replace with FileReader where possible
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

}
