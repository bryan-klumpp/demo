package bec.desktop;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;


public class FileTreeWalker {
   public static void walk(SimpleFileVisitor<Path> sfv, String... paths) {
	   try {
		for(String path : paths) {
			   Files.walkFileTree(Paths.get(path, new String[] {}), sfv);
		   }
	} catch (IOException e) {
		ExceptionUtil.rethrowRuntime(e);
	}
   }
}
