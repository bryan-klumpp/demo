package com.bryanklumpp.desktop;

import java.io.PrintWriter;
import java.io.Writer;
import java.util.Arrays;
import java.util.List;

import com.bryanklumpp.core.ContextEnvironment;
import com.bryanklumpp.core.StringUtil;

public class DebugUtil {

	public static void debugLog(String... args) {
		debugLog(Arrays.asList(args));
	}
	public static void debugLog(List<String> args) {
		debugLog(args, ContextEnvironment.SYSTEM_OUT_PRINTWRITER);
	}
	public static void debugLog(List<String> args, PrintWriter w) {
		w.print(System.currentTimeMillis()+": ");
		w.println(StringUtil.spaceDelim(args));
	}
}
