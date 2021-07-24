package com.bryanklumpp.core;

import java.nio.file.Path;
import java.util.regex.Pattern;

/**
 * Definition of attributes that will likely vary between operating systems
 * 
 * @author Bryan Klumpp
 */
public interface OSSpecifics {
	
	boolean isAbsolutePath(String p);

	Path getSystemDir();

	/**
	 * @return Pattern of file/directory pattern to exclude; can be null to exclude
	 *         nothing/search everything
	 */
	Pattern getDefaultFileSearchExclusions();
		
}
