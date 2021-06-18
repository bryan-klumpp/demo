package com.bryanklumpp.jash;

import java.awt.Color;
import java.awt.Desktop;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
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
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JRootPane;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.plaf.ColorUIResource;
import javax.swing.plaf.metal.DefaultMetalTheme;
import javax.swing.plaf.metal.MetalLookAndFeel;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.MakeTheValidatorHappyException;
import com.bryanklumpp.core.StringUtil;

import bec.desktop.ExceptionUtil;
import bec.desktop.Run;

/**
 * @author Bryan Klumpp
 * 
 *         Some helper stuff for apps running in "desktop" (non-webapp) mode,
 *         interactions with windowing systems, clipboard, file/web browsers, etc.
 *
 */
public class DesktopUtil {
	private static final ColorUIResource LIGHT_GRAY = new ColorUIResource(Color.lightGray);

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

	public static void setLightGrayMetalLookAndFeel(JFrame f) {
		f.setUndecorated(true);
		f.getRootPane().setWindowDecorationStyle(JRootPane.FRAME);
		MetalLookAndFeel.setCurrentTheme(allLightGrayMetalTheme());
		try {
			UIManager.setLookAndFeel(new MetalLookAndFeel());
		} catch (UnsupportedLookAndFeelException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static DefaultMetalTheme allLightGrayMetalTheme() {
		return new DefaultMetalTheme() {
			@Override
			protected ColorUIResource getPrimary1() {
				return LIGHT_GRAY;
			}

			@Override
			protected ColorUIResource getPrimary2() {
				return LIGHT_GRAY;
			}

			@Override
			protected ColorUIResource getPrimary3() {
				return LIGHT_GRAY;
			}

			@Override
			protected ColorUIResource getSecondary1() {
				return LIGHT_GRAY;
			}

			@Override
			protected ColorUIResource getSecondary2() {
				return LIGHT_GRAY;
			}

			@Override
			protected ColorUIResource getSecondary3() {
				return LIGHT_GRAY;
			}

			@Override
			protected ColorUIResource getWhite() {
				return LIGHT_GRAY;
			}

			@Override
			protected ColorUIResource getBlack() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getFocusColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getDesktopColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getControl() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getControlShadow() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getControlDarkShadow() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getControlInfo() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getControlHighlight() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getControlDisabled() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getPrimaryControl() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getPrimaryControlShadow() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getPrimaryControlDarkShadow() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getPrimaryControlInfo() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getPrimaryControlHighlight() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getSystemTextColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getControlTextColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getInactiveControlTextColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getInactiveSystemTextColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getUserTextColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getTextHighlightColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getHighlightedTextColor() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getWindowBackground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getWindowTitleBackground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getWindowTitleForeground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getWindowTitleInactiveBackground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getWindowTitleInactiveForeground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getMenuBackground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getMenuForeground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getMenuSelectedBackground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getMenuSelectedForeground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getMenuDisabledForeground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getSeparatorBackground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getSeparatorForeground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getAcceleratorForeground() {
				return LIGHT_GRAY;
			}

			@Override
			public ColorUIResource getAcceleratorSelectedForeground() {
				return LIGHT_GRAY;
			}
		};
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
			if (Files.isDirectory(p, LinkOption.NOFOLLOW_LINKS)) {
				Desktop.getDesktop().open(p.toFile());
			} else {
				fileExplorerSelected(w, p);
			} 
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static void fileExplorerSelected(PrintWriter w, Path p) {
		/*
		 * It just seems like there should be a better way, but the only way I've found
		 * to get this to properly select a file with spaces in the name is to use the
		 * spaces to split the file name into pieces and attach the first piece to the
		 * /select,  ; using the entire file name as one String doesn't work.
		 * For example, "c:\\temp\\this has spaces.txt" would be selected using:
		 * new ArrayList("...\\explorer.exe", "/select,c:\\temp\\this", "has", "spaces.txt")
		 */
		List<String> filePieces = StringUtil.tokenize(p.toString(), " ");
		List<String> s = CollectionsB.newList(Run.EXPLORER_EXE, 
				"/select,"+filePieces.get(0), filePieces.subList(1, filePieces.size()));
		Run.execProcessOSTextGuts(p.getParent(), w, s);
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

}