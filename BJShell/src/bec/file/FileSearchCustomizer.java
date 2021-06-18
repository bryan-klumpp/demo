package bec.file;

import java.nio.file.Path;

import com.bryanklumpp.file.FileSearchResult;

public abstract class FileSearchCustomizer {
	public FileSearchResult res = new FileSearchResult();
	public int maxDepth = Integer.MAX_VALUE;
	
	public FileSearchCustomizer(int maxDepth) {
		this.maxDepth = maxDepth;
//		this.res = res;
	}
	
	public FileSearchResult getResult() {
		return res;
	}
	
	/**
	 * @param p
	 * @return
	 */
	abstract void acceptMatch(Path p);
//	abstract void acceptMatchDeepestLevel(Path p);
}
