package com.bryanklumpp.file;

import java.nio.file.Files;
import java.nio.file.Path;

/**
 * @author Bryan Klumpp
 *
 * for now, all methods here will return false on symbolic links which are not supported at this time
 */
public enum FileTypeMatcher {
	NON_DIRECTORIES() {
		@Override
		protected boolean isMatch2(Path p) {
			return !Files.isDirectory(p);
		}
	},
	DIRECTORIES_ONLY() {
		@Override
		protected boolean isMatch2(Path p) {
			return Files.isDirectory(p);
		}
	},
	ALL() {
		@Override
		protected boolean isMatch2(Path p) {
			return true;
		}
	};

	abstract protected boolean isMatch2(Path p);
	public final boolean isMatch(Path p) {
		return (! Files.isSymbolicLink(p)) && isMatch2(p); 
	}
}