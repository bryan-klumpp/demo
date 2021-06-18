package bec.desktop;

import java.nio.file.Path;
import java.nio.file.Paths;

public class WindowsSpecifics implements OSSpecifics {

	private static final Path SYSTEM_DIR = Paths.get("c:\\Windows\\System32");

	@Override
	public String getLnDir() {
		return "c:\\l";
	}

	@Override
	public String[] getPlayAudioCmdWords(String audFile) {
		return new String[] { Run.POWERSHELL_EXE, "-c", "(New-Object Media.SoundPlayer","'"+audFile+"').PlaySync();" };
	}
	
	@Override
	public boolean isAbsolutePath(Path p) {
		return p.toString().length() >= 2 && p.toString().charAt(1) == ':';
	}

	@Override
	public Path getSystemDir() {
		return SYSTEM_DIR;
	}

}
