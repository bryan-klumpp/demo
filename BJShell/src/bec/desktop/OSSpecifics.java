package bec.desktop;

import java.nio.file.Path;

public interface OSSpecifics {
	
	String getLnDir();

	String[] getPlayAudioCmdWords(String audFile);

	boolean isAbsolutePath(Path p);

	Path getSystemDir();
		
}
