package com.bryanklumpp.desktop;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.SystemB;

/**
 * A way to invoke parameters from a command line java invocation, specifying
 * this class and the command name as the first command line argument after
 * that.
 * 
 * @author Bryan Klumpp
 *
 */
public class Main {

	public static void main(String[] args) {
	    try {
	        main2(args);
	    } catch (Exception e) {
	        ExceptionUtil.rethrowRuntime(e);
	    }
	}

	public static void main2(String[] args) throws Exception {
		Map<String, Command> cmds = CoreCommands.buildStaticCmds();
	    PrintWriter outputWriter = SystemB.DEFAULT_SYSTEM_OUT_PRINTWRITER;
		if (args.length > 0 && CollectionsB.hasKey(cmds, args[0])) {
	        try {
	            final Command cmd = cmds.get(args[0]);
	            List<String> largs = CollectionsB.list(args);
	            largs.remove(0);
				cmd.exec0(StringUtil.delimit(" ", args), largs, outputWriter, CommandContext.DEFAULT_CMD_CONTEXT);
				outputWriter.flush();
	        } catch (Exception e) {
	            ExceptionUtil.rethrowRuntime(e);
	        }
	    } else {
	        Command.listCommands(cmds, outputWriter);
	    }
	}
}
