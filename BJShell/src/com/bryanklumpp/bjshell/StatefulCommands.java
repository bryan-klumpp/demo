package com.bryanklumpp.bjshell;

import static com.bryanklumpp.core.CollectionsB.putMultipleKeys;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.ContextEnvironment;

import bec.file.FileUtil;
import bec.file.PathSearchStrategy;

/**
 * @author Bryan Klumpp
 *
 *         These commands are functionality that are only intended to be useful
 *         from a stateful shell, but don't actually require a reference to a
 *         particular shell instance
 */
public class StatefulCommands {
	public static final Map<String, Command> COMMANDS = buildCommands();

	private static Map<String, Command> buildCommands() {
		Map<String, Command> cmds = CollectionsB.newMap();
		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			Path wsPath = ContextEnvironment.getWorkspacePath();
			cmdWriter.println(wsPath);
		}, "cworkspace", "ws");
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				Path bestMatch = FileUtil.getBestMatch(context.getContextDir(), args, 
						PathSearchStrategy.EXACT_MATCH_DIRS_ONLY, 
						PathSearchStrategy.B_SPECIAL_PATHS,
						PathSearchStrategy.REGEX_DIRS_ONLY);
				if(bestMatch != null) {
					changeContextDirectory(bestMatch, context, cmdWriter);
				}else {
					cmdWriter.println("no directory match found");
					FileUtil.printContextDirectory(cmdWriter, context.getContextDir());
				}
			}

		}, "c" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				changeContextDirectory(context.getContextDir().getParent(), context, cmdWriter);
			}
		}, "u" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				changeContextDirectory(context.getContextDir().getParent().getParent(), context, cmdWriter);
			}
		}, "uu" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				changeContextDirectory(context.getContextDir().getParent().getParent().getParent(), context, cmdWriter);
			}
		}, "uuu" );

		return cmds;
	}
	public static void changeContextDirectory(Path newDir, CommandContext context, PrintWriter cmdWriter)
			throws IOException {
		context.setContextDir(newDir);
		FileUtil.prettyPrintChildren(context.getContextDir(), cmdWriter);
	}
}
