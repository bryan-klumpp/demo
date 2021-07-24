package com.bryanklumpp.custom;

import static com.bryanklumpp.core.CollectionsB.putMultipleKeys;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import com.bryanklumpp.bjshell.DesktopUtil;
import com.bryanklumpp.core.AbstractCommand;
import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;

import dev.desktop.DraftCommands;

public class CustomCommands {
	public static final Map<String, Command> COMMANDS = buildCommands();
	public static final Map<String, Command> COMMANDS_COMBINED_WITH_DRAFT = CollectionsB.mergeMaps(DraftCommands.getStaticCommands(), COMMANDS);

	private static Map<String, Command> buildCommands() {
		Map<String, Command> c = CollectionsB.newMap();
		putMultipleKeys(c, new AbstractCommand("") {
			@Override
			public void exec(String argsOneString, List<String> args, PrintWriter cmdWriter, CommandContext context)
					throws Exception {
				DesktopUtil.comWebsite("waveapps");
			}
		}, "wave");
		putMultipleKeys(c, new AbstractCommand("") {
			@Override
			public void exec(String argsOneString, List<String> args, PrintWriter cmdWriter, CommandContext context)
					throws Exception {
				CommandContext.changeWorkingDirectory(SelfNameIndexedFiles.bPath("50").resolve("ty21"), context, cmdWriter);
			}
		}, "ty21");
		return c;
	}

}
