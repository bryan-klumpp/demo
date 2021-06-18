package com.bryanklumpp.core;

import java.nio.file.Path;

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

}
