package com.bryanklumpp.file;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

import bec.file.DepthStats;

public class FileSearchResult {
	public List<Path> matches = new ArrayList<Path>();
	
	/**
	 * This is intended to be used as a 1-indexed array; index 1 contains the stats
	 * for the first search level. Perhaps index 0 could refer to the root
	 * directory, but in practice this is not used, so to avoid misuse, an
	 * exception will be thrown if index 0 is accessed.
	 */
	public List<DepthStats> depthStats = new ArrayList<DepthStats>() {
		private static final long serialVersionUID = 1L; //just to make the validator happy
		public DepthStats get(int index) {
			if (index == 0) {
				throw new RuntimeException("this list is intended to be used one-indexed, see Javadoc");
			}
			while (size() <= (index)) {
				add(new DepthStats());
			}
			return super.get(index);
		};
	};

	@Override
	public String toString() {
		return "matches: " + matches + " - depthStats: " + depthStats;
	}
}
