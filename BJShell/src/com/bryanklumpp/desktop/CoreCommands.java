package com.bryanklumpp.desktop;

import static com.bryanklumpp.core.CollectionsB.putMultipleKeys;

import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.file.FileTypeMatcher;
import com.bryanklumpp.jash.DesktopUtil;
import com.bryanklumpp.jash.Jash;

import bec.desktop.DraftCommands;
import bec.desktop.Run;
import bec.file.FileUtil;
import bec.file.PathSearchStrategy;

public class CoreCommands {

	public static final Map<String, Command> cmds = buildStaticCmds();

	public static Map<String, Command> buildStaticCmds() {
		Map<String, Command> cmds = CollectionsB.newMap();
		cmds.putAll(DraftCommands.getStaticCommands());
		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			args = StringUtil.argsWithClipboardDefault(args);
			Path wd = context.getContextDir();
			Path newD = wd.resolve(StringUtil.delimit("_", args));
			Files.createDirectories(newD);
			context.setContextDir(newD);
			FileUtil.printContextDirectory(cmdWriter, newD);
		}, "md" );
		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			FileUtil.printContextDirectory(cmdWriter, context.getContextDir());
		}, "pwd" );
		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			DesktopUtil.setClipboardText(context.getContextDir().toString());
		}, "clipwd" );
		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			FileUtil.prettyPrintChildren(context.getContextDir(), cmdWriter);
		}, "d" );
		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			CollectionsB.transform(args.subList(1, args.size()), (t) -> {
				return Pattern.compile(t);
			});
		}, "g" );
		putMultipleKeys(cmds, (argsv, args, cmdWriter, context) -> {
			String exe = "\"c:/Program Files/7-Zip/7z.exe\"";
			// https://sevenzip.osdn.jp/chm/cmdline/switches/type.htm
			// https://sevenzip.osdn.jp/chm/cmdline/switches/method.htm
			cmdWriter.println(
					StringUtil.delimit(" ", exe, "a", "-p", "-tzip", "-mem=AES256", "c:\\temp\\myarchive.zip", "*txt"));
		}, "7ze" );
		putMultipleKeys(cmds, new Command() {
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				Path best;
				if (args.isEmpty()) {
					best = context.getContextDir();
				} else {
					// TODO make this search more strategies
					FileTypeMatcher ftm = FileTypeMatcher.ALL;
					PathSearchStrategy[] strategies = { PathSearchStrategy.getExactMatchStrategy(ftm), 
							                            PathSearchStrategy.B_SPECIAL_PATHS, 
							                            PathSearchStrategy.getRegexClosestLevelMatchStrategy(ftm) };
					best = FileUtil.getBestMatch(context.getContextDir(), args, strategies);
				}
				DesktopUtil.fileExplorer(cmdWriter, best);
			}
		}, "explorer", "e" );
		putMultipleKeys(cmds, new Command() {
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				Path best;
				if (args.isEmpty()) {
					best = context.getContextDir();
				} else {
					// TODO make this search more strategies
					FileTypeMatcher ftm = FileTypeMatcher.ALL;
					PathSearchStrategy[] strategies = { PathSearchStrategy.getExactMatchStrategy(ftm), 
							                            PathSearchStrategy.B_SPECIAL_PATHS, 
							                            PathSearchStrategy.getRegexClosestLevelMatchStrategy(ftm) };
					best = FileUtil.getBestMatch(context.getContextDir(), args, strategies);
				}
				DesktopUtil.fileExplorerSelected(cmdWriter, best);
			}
		}, "explorerselect", "es" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				Path parent = context.getContextDir().getParent();
				context.setContextDir(parent);
				FileUtil.prettyPrintChildren(parent, cmdWriter);
			}
		}, "u" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				Path parent = context.getContextDir().getParent().getParent();
				context.setContextDir(parent);
				FileUtil.prettyPrintChildren(parent, cmdWriter);
			}
		}, "uu" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				Path parent = context.getContextDir().getParent().getParent().getParent();
				context.setContextDir(parent);
				FileUtil.prettyPrintChildren(parent, cmdWriter);
			}
		}, "uuu" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
//				Run.execOSText(cmdWriter, CollectionsB.newList(Run.BAT_DIR + "/b.bat", "alarm", args), context.getContextDir());
				Run.execExternalJavaB(cmdWriter, context.getContextDir(), CollectionsB.newList("alarm", args));
			}
		}, "alarm" );
		putMultipleKeys(cmds, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception {
				Path bestMatch = FileUtil.getBestMatch(context.getContextDir(), args, 
						PathSearchStrategy.EXACT_MATCH_DIRS_ONLY, 
						PathSearchStrategy.B_SPECIAL_PATHS,
						PathSearchStrategy.REGEX_DIRS_ONLY);
				if(bestMatch != null) {
					context.setContextDir(bestMatch);
					FileUtil.prettyPrintChildren(context.getContextDir(), cmdWriter);
				}else {
					cmdWriter.println("no directory match found");
					FileUtil.printContextDirectory(cmdWriter, context.getContextDir());
				}
			}
		}, "c" );
		return cmds;
	}
}
