package dev.desktop;

import java.io.PrintWriter;
import java.util.List;

import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;

public abstract class CmdBase implements Command {
	
	private PrintWriter outputWriter;

	public PrintWriter getOutputWriter() {
		return outputWriter;
	}

	public void setOutputWriter(PrintWriter outputWriter) {
		this.outputWriter = outputWriter;
	}

	protected CmdBase(PrintWriter outputWriter) {
		setOutputWriter(outputWriter);
	}

}
