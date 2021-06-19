package com.bryanklumpp.bjshell;

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
	public static final ColorUIResource LIGHT_GRAY = new ColorUIResource(Color.lightGray);
	public static final ColorUIResource FOREST_GREEN = new ColorUIResource(1, 68, 33);

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

	public static void setMetalLookAndFeel(ColorUIResource color, JFrame f) {
		f.setUndecorated(true);
		f.getRootPane().setWindowDecorationStyle(JRootPane.FRAME);
		MetalLookAndFeel.setCurrentTheme(buildSingleColorMetalTheme(color));
		try {
			UIManager.setLookAndFeel(new MetalLookAndFeel());
		} catch (UnsupportedLookAndFeelException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static DefaultMetalTheme buildSingleColorMetalTheme(ColorUIResource color) {
		return new DefaultMetalTheme() {
			@Override
			protected ColorUIResource getPrimary1() {
				return color;
			}

			@Override
			protected ColorUIResource getPrimary2() {
				return color;
			}

			@Override
			protected ColorUIResource getPrimary3() {
				return color;
			}

			@Override
			protected ColorUIResource getSecondary1() {
				return color;
			}

			@Override
			protected ColorUIResource getSecondary2() {
				return color;
			}

			@Override
			protected ColorUIResource getSecondary3() {
				return color;
			}

			@Override
			protected ColorUIResource getWhite() {
				return color;
			}

			@Override
			protected ColorUIResource getBlack() {
				return color;
			}

			@Override
			public ColorUIResource getFocusColor() {
				return color;
			}

			@Override
			public ColorUIResource getDesktopColor() {
				return color;
			}

			@Override
			public ColorUIResource getControl() {
				return color;
			}

			@Override
			public ColorUIResource getControlShadow() {
				return color;
			}

			@Override
			public ColorUIResource getControlDarkShadow() {
				return color;
			}

			@Override
			public ColorUIResource getControlInfo() {
				return color;
			}

			@Override
			public ColorUIResource getControlHighlight() {
				return color;
			}

			@Override
			public ColorUIResource getControlDisabled() {
				return color;
			}

			@Override
			public ColorUIResource getPrimaryControl() {
				return color;
			}

			@Override
			public ColorUIResource getPrimaryControlShadow() {
				return color;
			}

			@Override
			public ColorUIResource getPrimaryControlDarkShadow() {
				return color;
			}

			@Override
			public ColorUIResource getPrimaryControlInfo() {
				return color;
			}

			@Override
			public ColorUIResource getPrimaryControlHighlight() {
				return color;
			}

			@Override
			public ColorUIResource getSystemTextColor() {
				return color;
			}

			@Override
			public ColorUIResource getControlTextColor() {
				return color;
			}

			@Override
			public ColorUIResource getInactiveControlTextColor() {
				return color;
			}

			@Override
			public ColorUIResource getInactiveSystemTextColor() {
				return color;
			}

			@Override
			public ColorUIResource getUserTextColor() {
				return color;
			}

			@Override
			public ColorUIResource getTextHighlightColor() {
				return color;
			}

			@Override
			public ColorUIResource getHighlightedTextColor() {
				return color;
			}

			@Override
			public ColorUIResource getWindowBackground() {
				return color;
			}

			@Override
			public ColorUIResource getWindowTitleBackground() {
				return color;
			}

			@Override
			public ColorUIResource getWindowTitleForeground() {
				return color;
			}

			@Override
			public ColorUIResource getWindowTitleInactiveBackground() {
				return color;
			}

			@Override
			public ColorUIResource getWindowTitleInactiveForeground() {
				return color;
			}

			@Override
			public ColorUIResource getMenuBackground() {
				return color;
			}

			@Override
			public ColorUIResource getMenuForeground() {
				return color;
			}

			@Override
			public ColorUIResource getMenuSelectedBackground() {
				return color;
			}

			@Override
			public ColorUIResource getMenuSelectedForeground() {
				return color;
			}

			@Override
			public ColorUIResource getMenuDisabledForeground() {
				return color;
			}

			@Override
			public ColorUIResource getSeparatorBackground() {
				return color;
			}

			@Override
			public ColorUIResource getSeparatorForeground() {
				return color;
			}

			@Override
			public ColorUIResource getAcceleratorForeground() {
				return color;
			}

			@Override
			public ColorUIResource getAcceleratorSelectedForeground() {
				return color;
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
				fileExplorerSelect(w, p);
			} 
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

	public static void fileExplorerSelect(PrintWriter w, Path p) {
		// This will be passed to ProcessBuilder as a List containing only one string
		// with spaces in it. This doesn't seem like normal use of ProcessBuilder, but I
		// couldn't find a way to get this to work with
		// spaces/commas in filenames any other way
		String oneExecString = Run.EXPLORER_EXE+" /select,\""+p.toString()+"\"";
		List<String> listWithOnlyOneString = CollectionsB.newList(oneExecString);
		Run.execProcessOSTextGuts(null, w, listWithOnlyOneString);
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