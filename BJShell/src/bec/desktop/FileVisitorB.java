package bec.desktop;

import java.io.File;

public interface FileVisitorB {
	void visitFile(File f);
	void visitDirectory(File f);
}
