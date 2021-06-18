package bec.desktop;

import java.io.PrintWriter;
import java.util.List;

import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;

public abstract class CmdBase implements Command {
	
	private PrintWriter writer;

	protected CmdBase(PrintWriter w) {
		this.writer = w;
	}
	
	protected PrintWriter getWriter() {
		return writer;
	}

	@Override
	public void exec(String argsv, List<String> args, PrintWriter writer, CommandContext context) throws Exception {
		this.writer = writer;
		exec(args);
	}
	
	abstract protected void exec(List<String> args);
	
	protected void sop(Object o) {
		writer.println(o);
	}

}
