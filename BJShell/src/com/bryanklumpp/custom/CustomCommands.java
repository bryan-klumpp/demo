package com.bryanklumpp.custom;

import static com.bryanklumpp.core.CollectionsB.putMultipleKeys;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.jash.DesktopUtil;

public class CustomCommands {
	public static final Map<String, Command> COMMANDS = buildCommands();

	private static Map<String, Command> buildCommands() {
		Map<String, Command> c = CollectionsB.newMap();
		putMultipleKeys(c, new Command() {
			@Override
			public void exec(String argsOneString, List<String> args, PrintWriter cmdWriter, CommandContext context)
					throws Exception {
				DesktopUtil.comWebsite("waveapps");
			}
		}, "wave");
		return c;
	} 
}
