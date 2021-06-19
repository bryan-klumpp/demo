package com.bryanklumpp.bjshell;

import java.awt.Dimension;
import java.awt.Font;
import java.awt.Point;
import java.io.File;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;

import com.bryanklumpp.core.CommandContext;

/**
 * @author Bryan Klumpp
 *
 *         This is a one-for-one object corresponding to a single BJShell
 *         window. Serialization is used to persist this state to disk for
 *         short-term persistence across invocations. This allows developers to
 *         make code changes, re-launch (or clone) the shell window (an
 *         AutoHotkey script can make this a one-key operation), and resume
 *         right where they left off (same context directory, etc.) with the new
 *         code using type-safe mapping. Object serialization has proven to be
 *         "good enough" so far for this short-term, single-PC, non-critical
 *         data.
 *
 */
public class BJShellState implements Serializable, CommandContext {
	/**
	 * With serialization this class is a optimistic in that it sets default values
	 * in getters rather than in the field declaration, so that if one field is
	 * renamed (for example) it will fail to deserialize but can recover with the
	 * default value and hopefully not affect other fields.
	 */ 
	private static final long serialVersionUID = 1L;
	private File contextDir = null; // storing as File instead of Path because Path isn't Serializable.
	/**
	 * Note that the persisted* fields will get out of sync as soon as the
	 * corresponding GUI elements are changed. Also, some memory could be saved by
	 * setting the persistedTaText, in particular, to null after applying it to the
	 * GUI, but to be consistent it's left in memory for now like the others.
	 * Ideally this could be reworked to separate the out-of-sync GUI attributes
	 * from fields like the contextDirectory for which this class is actually the
	 * safe source
	 */
	private Font persistedFont = null;
	private String persistedTaText = null;
	private Dimension persistedSize = null;
	private Point persistedLocationOnScreen = null;

	public Font getPersistedFont() {
		if (persistedFont == null) {
			persistedFont = new Font(Font.DIALOG, Font.PLAIN, 12); // TODO raise this default on hi-res screens
		}
		return persistedFont;
	}

	public void setPersistedFont(Font font) {
		this.persistedFont = font;
	}

	static Path SERIALIZATION_FILE = Paths.get(System.getProperty("java.io.tmpdir") + "/BJShell.ser");

	public String getPersistedTaText() {
		if (persistedTaText == null) {
			persistedTaText = "";
		}
		return persistedTaText;
	}

	public void setPersistedTaText(String taText) {
		this.persistedTaText = taText;
	}

	public Path getContextDir() {
		if (contextDir == null) {
			contextDir = CommandContext.DEFAULT_CMD_CONTEXT.getContextDir().toFile();
		}
		return contextDir.toPath();
	}

	public void setContextDir(Path workingDir) {
		this.contextDir = workingDir.toFile();
	}

	public Dimension getPersistedSize() {
		if (persistedSize == null) {
			persistedSize = new Dimension(800, 400);
		}
		return persistedSize;
	}

	public void setPersistedSize(Dimension size) {
		this.persistedSize = size;
	}

	public Point getPersistedLocationOnScreen() {
		if (persistedLocationOnScreen == null) {
			persistedLocationOnScreen = new Point(150, 150);
		}
		return persistedLocationOnScreen;
	}

	public void setPersistedLocationOnScreen(Point loc) {
		this.persistedLocationOnScreen = loc;
	}
}
