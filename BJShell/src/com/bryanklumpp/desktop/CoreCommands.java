package com.bryanklumpp.desktop;

import static com.bryanklumpp.core.CollectionsB.putMultipleKeys;

import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import com.bryanklumpp.bjshell.DesktopUtil;
import com.bryanklumpp.core.AbstractCommand;
import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.SystemB;
import com.bryanklumpp.file.FileTypeMatcher;
import com.bryanklumpp.file.FileUtil;
import com.bryanklumpp.file.PathSearchStrategy;

public class CoreCommands {

	public static final Map<String, Command> cmds = buildStaticCmds();

	public static Map<String, Command> buildStaticCmds() {
		Map<String, Command> cmds = CollectionsB.newMap();
		putMultipleKeys(cmds, (argsv, args, outputWriter, context) -> {
			args = StringUtil.argsWithClipboardDefault(args);
			Path wd = context.getWorkingDir();
			Path newD = wd.resolve(StringUtil.delimit("_", args));
			Files.createDirectories(newD);
			context.setWorkingDir(newD);
			FileUtil.printWorkingDirectory(outputWriter, newD);
		}, "md" );

		putMultipleKeys(cmds, (argsv, args, outputWriter, context) -> {
			FileUtil.printWorkingDirectory(outputWriter, context.getWorkingDir());
		}, "pwd" );
		putMultipleKeys(cmds, (argsv, args, outputWriter, context) -> {
			DesktopUtil.setClipboardText(context.getWorkingDir().toString());
		}, "clipwd" );
		putMultipleKeys(cmds, (argsv, args, outputWriter, context) -> {
			FileUtil.prettyPrintChildren(context.getWorkingDir(), outputWriter);
		}, "d" );
		putMultipleKeys(cmds, (argsv, args, outputWriter, context) -> {
			CollectionsB.transform(args.subList(1, args.size()), (t) -> {
				return Pattern.compile(t);
			});
		}, "g" );
		putMultipleKeys(cmds, new AbstractCommand("This command is a helper to generate 7-Zip command lines (7-Zip syntax has never been intuitive to me), but does not actually execute them at this point") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				String exe = "\"c:/Program Files/7-Zip/7z.exe\"";
				outputWriter.println("https://sevenzip.osdn.jp/chm/cmdline/switches/type.htm"
						+ "\nhttps://sevenzip.osdn.jp/chm/cmdline/switches/method.htm");
				outputWriter.println("The following command creates a zip file with AES256 encryption:");
				outputWriter.println(StringUtil.delimit(" ", exe, "a", "-p", "-tzip", "-mem=AES256", "c:\\temp\\myarchive.zip", "*txt"));
			}
		}, "7ze" );
		putMultipleKeys(cmds, new AbstractCommand("Executes WinDirStat on the working directory to find disk space hogs") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				String exe = "c:/Program Files (x86)/WinDirStat/windirstat.exe";
				Run.execProcessOSText(outputWriter, exe, context.getWorkingDir());
			}
		}, "fstat" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				DesktopUtil.fileExplorer(outputWriter, FileUtil.getBestSingleMatch(args, context));
			}
		}, "explorer", "e" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				int retCode = Run.execProcessOSTextGuts(null, outputWriter, args);
				outputWriter.println("return code: "+retCode);
			}
		}, "runtimeexec" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				DesktopUtil.fileExplorerSelect(outputWriter, FileUtil.getBestSingleMatch(args, context));
			}

		}, "eselect", "select", "sel" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				Path best;
				if (args.isEmpty()) {
					best = context.getWorkingDir();
				} else {
					// TODO make this search more strategies
					FileTypeMatcher ftm = FileTypeMatcher.ALL;
					List<PathSearchStrategy> strategies = CollectionsB.newList();
					strategies.add   (PathSearchStrategy.getExactMatchStrategy(ftm));
					strategies.add   (PathSearchStrategy.getRegexClosestLevelMatchStrategy(ftm));
					strategies.addAll(PathSearchStrategy.CUSTOM_EXTRA_MATCH_STRATEGIES);
					best = FileUtil.getBestSingleMatch(context.getWorkingDir(), args, strategies);
				}
				DesktopUtil.fileExplorerSelect(outputWriter, best);
			}
		}, "explorerselect", "es" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
//				Run.execOSText(outputWriter, CollectionsB.newList(Run.BAT_DIR + "/b.bat", "alarm", args), context.getWorkingDir());
				Run.execExternalJava(Main.class, outputWriter, context.getWorkingDir(), CollectionsB.newList("alarm", args));
			}
		}, "alarm" );
		putMultipleKeys(cmds, new AbstractCommand("test whether assertions are enabled") {
			public void exec(String argsv, List<String> args, PrintWriter outputWriter, CommandContext context) throws Exception {
				try {
					assert false;
					outputWriter.println("assertions are disabled");
				} catch (AssertionError e) {
					outputWriter.println("assertions are enabled");
				}
			}
		}, "testassert" );

		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			CommandContext.changeWorkingDirectory(SystemB.getWorkspacePath(), context, cmdWriter);
		}, "cworkspace", "ws");
		putMultipleKeys(cmds, new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				List<PathSearchStrategy> strategies = CollectionsB.newList();
				strategies.add   (PathSearchStrategy.EXACT_MATCH_DIRS_ONLY);
				strategies.addAll(PathSearchStrategy.CUSTOM_EXTRA_MATCH_STRATEGIES);
				strategies.add   (PathSearchStrategy.REGEX_DIRS_ONLY);
				Path bestMatch = FileUtil.getBestSingleMatch(context.getWorkingDir(), args, strategies);
				if(bestMatch != null) {
					CommandContext.changeWorkingDirectory(bestMatch, context, cmdWriter);
				}else {
					cmdWriter.println("no directory match found");
					FileUtil.printWorkingDirectory(cmdWriter, context.getWorkingDir());
				}
			}

		}, "c" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				CommandContext.changeWorkingDirectory(SystemB.USER_HOME, context, cmdWriter);
			}
		}, "hm" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				CommandContext.changeWorkingDirectoryUp(args.size() == 0 ? 1 : Integer.valueOf(args.get(0)), context, cmdWriter);
			}
		}, "u" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				CommandContext.changeWorkingDirectoryUp(2, context, cmdWriter);
			}
		}, "uu" );
		putMultipleKeys(cmds, new AbstractCommand("") {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				CommandContext.changeWorkingDirectoryUp(3, context, cmdWriter);
			}
		}, "uuu" );

		
		return cmds;
	}
}
