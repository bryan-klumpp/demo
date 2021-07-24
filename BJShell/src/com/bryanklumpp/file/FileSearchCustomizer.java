package com.bryanklumpp.file;

import java.nio.file.Path;

/**
 * Visitor that allows custom handling of file search results. Stores the
 * FileSearchResult.
 * 
 * @author Bryan Klumpp
 */
public abstract class FileSearchCustomizer {
	private final FileSearchResult res = new FileSearchResult();
	public int maxDepth = Integer.MAX_VALUE;
	
	public FileSearchCustomizer(int maxDepth) {
		this.maxDepth = maxDepth;
	}
	
	public FileSearchResult getResult() {
		return res;
	}
	
	public abstract void acceptMatch(Path p);
}
