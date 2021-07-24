package com.bryanklumpp.core;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;

import javax.naming.OperationNotSupportedException;

import com.bryanklumpp.file.FileUtil;

public interface CommandContext {
	
	final CommandContext DEFAULT_CMD_CONTEXT = new CommandContext() {
		private Path workingDir = null;
		@Override
		public void setWorkingDir(Path workingDir) {
			this.workingDir = workingDir;
		}
		@Override
		public Path getWorkingDir() {
			if(workingDir == null) {
				workingDir = SystemB.USER_HOME;
			}
			return workingDir;
		}
	};

	void setWorkingDir(Path workingDir);
	Path getWorkingDir();

	static void changeWorkingDirectory(Path newDir, CommandContext context, PrintWriter cmdWriter)
			throws IOException {
		context.setWorkingDir(newDir);
		FileUtil.prettyPrintChildren(context.getWorkingDir(), cmdWriter);
	}
	static CommandContext readOnlyContext(final Path path) {
		return new CommandContext() {
			@Override
			public void setWorkingDir(Path workingDir) {
				throw new RuntimeException("read only path - runtime equivalent of OperationNotSupportedException");
			}
			
			@Override
			public Path getWorkingDir() {
				return path;
			}
		};
	}
	static void changeWorkingDirectoryUp(int ct, CommandContext context, PrintWriter cmdWriter) throws IOException {
		Path dir = context.getWorkingDir();
		for(int i = 0; i < ct; i++) {
			Path parent = dir.getParent();
			if (parent == null) {
				// do nothing, we are already at the top. Maybe log a debug/trace event?
			} else {
				dir = parent;
			}
		}
		changeWorkingDirectory(dir, context, cmdWriter);
	}

}
