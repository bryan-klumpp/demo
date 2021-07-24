package com.bryanklumpp.file;

/**
 * Used to keep track of statistics during File / NIO Path searches.
 * 
 * @author Bryan Klumpp
 *
 */
public class DepthStats {
	private int totalDirs;
	private int countMatches;
	
	public int getTotalDirs() {
		return totalDirs;
	}

	public void setTotalDirs(int totalDirs) {
		this.totalDirs = totalDirs;
	}

	public int getCountMatches() {
		return countMatches;
	}

	public void setCountMatches(int countMatches) {
		this.countMatches = countMatches;
	}
}
