package bec.desktop;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.List;

import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;

public class MakeBLinksCommand implements Command {

	@Override
	public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
		String searchDir = "C:\\Users\\b\\Documents";
		FileVisitor<Path> fv = new FileVisitor<Path>() {

			@Override
			public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
				return FileVisitResult.CONTINUE;
			}

			@Override
			public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
				System.out.println(file);
				return FileVisitResult.CONTINUE;
			}

			@Override
			public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
				ExceptionUtil.systemErrLogException(exc);
				return FileVisitResult.SKIP_SUBTREE;
			}

			@Override
			public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
				return FileVisitResult.CONTINUE;
			}
		};
		Files.walkFileTree(Paths.get(searchDir), fv);
	}

}
