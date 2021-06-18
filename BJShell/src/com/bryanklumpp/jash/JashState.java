package com.bryanklumpp.jash;

import java.awt.Dimension;
import java.awt.Point;
import java.io.File;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;

import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.ContextEnvironment;
import com.bryanklumpp.core.StringUtil;

/**
 * @author Bryan Klumpp
 *
 *         Serialization is used to persist this state to disk for short-term
 *         persistence across invocations. This allows developers to make code
 *         changes, re-launch (or clone) the Jash window (an AutoHotkey script
 *         can make this a one-key operation), and resume right where they left
 *         off (same context directory, etc.) with the new code. As this is
 *         short-term, non-critical data, object serialization has proven to be
 *         "good enough" so far.
 *
 */
public class JashState implements Serializable, CommandContext {
	private File workingDir = null; //storing as File instead of Path because Path isn't Serializable.
	/**
	 * Note that the persisted* fields will get out of sync as soon as the
	 * corresponding GUI elements are changed. Also, some memory could be saved by
	 * setting the persistedTaText, in particular, to null after applying it to the
	 * GUI, but to be consistent it's left in memory for now like the others.
	 * Ideally this could be reworked to separate the out-of-sync GUI attributes
	 * from fields like the contextDirectory for which this class is actually the
	 * safe source
	 */
	public String persistedTaText = "";
	private Dimension persistedSize = null;
	private Point persistedLocationOnScreen = null;
	
	private static final long serialVersionUID = 1L;
	static Path SERIALIZATION_FILE = Paths.get("c:/temp/jash.ser");

	public String getPersistedTaText() {
		return persistedTaText;
	}

	public void setPersistedTaText(String taText) {
		this.persistedTaText = taText;
	}

	public Path getContextDir() {
		if (this.workingDir == null) {
			this.workingDir = ContextEnvironment.USER_HOME.toFile();
		}
		return workingDir.toPath();
	}

	public void setContextDir(Path workingDir) {
		this.workingDir = workingDir.toFile();
	}

	public Dimension getPersistedSize() {
		if (this.persistedSize == null) {
			persistedSize = new Dimension(800, 400);
		}
		return persistedSize;
	}

	public void setPersistedSize(Dimension size) {
		this.persistedSize = size;
	}

	public Point getPersistedLocationOnScreen() {
		if(this.persistedLocationOnScreen == null) {
			this.persistedLocationOnScreen = new Point(150, 150);
		}
		return persistedLocationOnScreen;
	}

	public void setPersistedLocationOnScreen(Point loc) {
		this.persistedLocationOnScreen = loc;
	}
	
}
