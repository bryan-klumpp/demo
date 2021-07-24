package com.bryanklumpp.custom.demo;

import static com.bryanklumpp.core.CollectionsB.putMultipleKeys;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import com.bryanklumpp.bjshell.DesktopUtil;
import com.bryanklumpp.core.AbstractCommand;
import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;

public class DemoCustomCommands {
	public static final Map<String, Command> COMMANDS = buildCommands();

	private static Map<String, Command> buildCommands() {
		Map<String, Command> commands = CollectionsB.newMap();
		putMultipleKeys(commands, new AbstractCommand("") {
			@Override
			public void exec(String argsOneString, List<String> args, PrintWriter cmdWriter, CommandContext context)
					throws Exception {
				cmdWriter.println("Hello World!");
			}
		}, "demo");
		return commands;
	}
}
