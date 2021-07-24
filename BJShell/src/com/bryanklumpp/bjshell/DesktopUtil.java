package com.bryanklumpp.bjshell;

import java.awt.Color;
import java.awt.Desktop;
import java.awt.Toolkit;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.swing.plaf.ColorUIResource;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.desktop.Run;
import com.bryanklumpp.file.FileUtil;

/**
 * @author Bryan Klumpp
 * 
 *         Some helper stuff for apps running in "desktop" (non-webapp) mode,
 *         interactions with windowing systems, clipboard, file/web browsers, etc.
 *
 */
public class DesktopUtil {

	public static void web(String url) {
		try {
			Desktop.getDesktop().browse(new URI(url));
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		} catch (URISyntaxException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static void setClipboardText(String text) {
		Toolkit.getDefaultToolkit().getSystemClipboard().setContents(new StringSelection(text), null);
	}

	public static String getClipboardText() {
		try {
			return (String) Toolkit.getDefaultToolkit().getSystemClipboard().getData(DataFlavor.stringFlavor);
		} catch (UnsupportedFlavorException e) {
			throw new RuntimeException(e);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * TODO this only supports Windows right now, abstract to OSSpecifics and implement
	 * Linux
	 * 
	 * @param w
	 * @param p
	 */
	public static void fileExplorer(PrintWriter w, Path p) {
		try {
			if (FileUtil.isDirectory(p)) {
				Desktop.getDesktop().open(p.toFile());
			} else {
				fileExplorerSelect(w, p);
			} 
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static void fileExplorerSelect(PrintWriter outputWriter, Path p) {
		// This will be passed to ProcessBuilder as a List containing only one string
		// This doesn't seem like normal use of ProcessBuilder, but I
		// couldn't find any other way to get this to work with
		// spaces/commas in filenames
		String oneExecString = Run.EXPLORER_EXE+" /select,\""+p.toString()+"\"";
		List<String> listWithOnlyOneString = CollectionsB.newList(oneExecString);
		Run.execProcessOSTextGuts(null, outputWriter, listWithOnlyOneString);
	}

	public static void comWebsite(String domainNameBase) {
		browseWebsite(domainNameBase, "com");
	}

	public static void browseWebsite(String domainNameBase, String suffix) {
		try {
			Desktop.getDesktop().browse(new URI("https://"+domainNameBase+"."+suffix));
		} catch (IOException | URISyntaxException e) {
			throw new RuntimeException(e);
		}
	}

	public static void desktop(Path p) throws IOException {
		Desktop.getDesktop().open(p.toFile());
	}

	public static void desktop(String fileName) throws IOException {
		desktop(Paths.get(fileName));
	}

	

}