package com.bryanklumpp.file;

import java.nio.file.Files;
import java.nio.file.Path;

public enum FileTypeMatcher {
	NON_DIRECTORIES() {
		@Override
		public boolean isMatch(Path p) {
			return !Files.isDirectory(p);
		}
	},
	DIRECTORIES_ONLY() {
		@Override
		public boolean isMatch(Path p) {
			return Files.isDirectory(p);
		}
	},
	ALL() {
		@Override
		public boolean isMatch(Path p) {
			return true;
		}
	};

	abstract public boolean isMatch(Path p);
}