package com.bryanklumpp.core;

import java.io.PrintWriter;
import java.util.List;

/**
 * @author Bryan Klumpp
 *
 *         Stores documentation for command, enables InheritableThreadLocal
 *         outputWriter to reduce the need to pass it all over the place
 */
public abstract class AbstractCommand implements Command {

	private String documentation;
	private static InheritableThreadLocal<PrintWriter> writerThreadLocal = new InheritableThreadLocal<PrintWriter>();

	public AbstractCommand(String documentation) {
		this.documentation = documentation;
	}
	
	@Override
	final public void exec0(String argsOneString, List<String> args, PrintWriter cmdWriter, CommandContext context)
			throws Exception {
		writerThreadLocal.set(cmdWriter);
		exec(argsOneString, args, cmdWriter, context);
	}
	public abstract void exec(String argsOneString, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception;
	
	protected PrintWriter getWriter() {
		return writerThreadLocal.get();
	}
}
