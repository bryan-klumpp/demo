package com.bryanklumpp.core;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Pattern;

/**
 * Implementation of Windows-specific behavior
 * 
 * @author Bryan Klumpp
 */
public class WindowsSpecifics implements OSSpecifics {

	private static final Path SYSTEM_DIR = Paths.get("c:\\Windows\\System32");
	private static final Pattern WINDOWS_DEFAULT_FILE_SEARCH_EXCLUSIONS = Pattern.compile("(^|[^A-Za-z0-9])(Windows|Program Files|eclipse|.p2|.m2|AppData)$");
	
	@Override
	public boolean isAbsolutePath(String p) {
		return p.length() >= 2 && p.charAt(1) == ':';
	}

	@Override
	public Path getSystemDir() {
		return SYSTEM_DIR;
	}

	@Override
	public Pattern getDefaultFileSearchExclusions() {
		return WINDOWS_DEFAULT_FILE_SEARCH_EXCLUSIONS;
	}

}
