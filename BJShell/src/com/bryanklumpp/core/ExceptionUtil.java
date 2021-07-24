package com.bryanklumpp.core;

import java.io.Closeable;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Map;

/**
 * @author Bryan Klumpp
 *
 * Central invocation of common exception handling patterns
 */
public class ExceptionUtil {
	
	/**
	 * Empty catch blocks sometimes make sense (you will find them in the JRE source
	 * code in java.lang.Integer, for example). This method does nothing right now,
	 * but this is a central method to be called by otherwise empty catch blocks for
	 * which logging might be overkill right now, and which don't do anything with
	 * an Exception. This will make for easier debugging of undesirable silent
	 * failures if they do happen, and will also enable easy audits for later
	 * conversion to use debug/trace events if desired.
	 *
	 * @param exception
	 */
	public static void eatIt(Exception exception) {
	}

	/**
	 * This will rethrow some specific RuntimeException subclass equivalents of
	 * checked exceptions that relatively few callers seem to care about; for example,
	 * InterruptedException to RuntimeInterruptedException, so that classes that
	 * want to can catch those Runtime... exceptions but those that don't care don't
	 * need to clutter code with catch blocks.
	 * 
	 * @param e
	 */
	public static void rethrowRuntime(Exception e) {
		if(e instanceof InterruptedException) {
			throw new RuntimeInterruptedException(e);
		}
		if(e instanceof RuntimeException) {
			throw (RuntimeException)e;
		}
		throw new RuntimeException(e);
	}
}
