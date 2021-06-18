package bec.desktop;

import java.nio.file.Path;
import java.nio.file.Paths;

public class LinuxSpecifics implements OSSpecifics {

	private static final Path SYSTEM_DIR = Paths.get("/usr/bin");

	@Override
	public String getLnDir() {
		return "/l";
	}
 
	@Override
	public String[] getPlayAudioCmdWords(String audFile) {
		return new String[]{"/usr/bin/paplay", audFile};
	}

	@Override
	public boolean isAbsolutePath(Path p) {
		return p.toString().length() >= 1 && p.toString().charAt(0) == '/';
	}

	@Override
	public Path getSystemDir() {
		return SYSTEM_DIR;
	}

}
