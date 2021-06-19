package com.bryanklumpp.core;

import java.nio.file.Path;

import javax.naming.OperationNotSupportedException;

public interface CommandContext {
	
	final CommandContext DEFAULT_CMD_CONTEXT = new CommandContext() {
		private Path workingDir = null;
		@Override
		public void setContextDir(Path workingDir) {
			this.workingDir = workingDir;
		}
		@Override
		public Path getContextDir() {
			if(workingDir == null) {
				workingDir = ContextEnvironment.USER_HOME;
			}
			return workingDir;
		}
	};

	void setContextDir(Path contextDir);
	Path getContextDir();
	static CommandContext readOnlyContext(final Path path) {
		return new CommandContext() {
			@Override
			public void setContextDir(Path contextDir) {
				throw new RuntimeException("read only path - runtime equivalent of OperationNotSupportedException");
			}
			
			@Override
			public Path getContextDir() {
				return path;
			}
		};
	}

}
