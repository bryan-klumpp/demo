package bec.file;

public class DepthStats {
	//should use AtomicInteger if multithreading needed
	public int totalDirs;
	public int ctMatches;
	
	@Override
	public String toString() {
		return totalDirs+","+ctMatches;
	}
}
