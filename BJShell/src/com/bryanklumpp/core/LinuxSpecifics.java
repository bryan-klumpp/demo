package com.bryanklumpp.core;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Pattern;

/**
 * Handling unique to Linux systems. Much less tested and developed (as of 6/2021)
 * than the Windows counterpart.
 * 
 * @author Bryan Klumpp
 */
public class LinuxSpecifics implements OSSpecifics {

	private static final Path SYSTEM_DIR = Paths.get("/usr/bin");
	

	@Override
	public boolean isAbsolutePath(String p) {
		return p.toString().length() >= 1 && p.toString().charAt(0) == '/';
	}

	@Override
	public Path getSystemDir() {
		return SYSTEM_DIR;
	}

	@Override
	public Pattern getDefaultFileSearchExclusions() {
		return null; // TODO right now this leaves the search wide-open on Linux machines, should narrow it down
	}

}
