package bec.desktop;

import java.io.Closeable;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Map;

import com.bryanklumpp.core.RuntimeInterruptedException;

public class ExceptionUtil {
	public static String doWithSpecialTraceLoggingAndExceptionHandling(String goodView, Map<String, Object> loggingAttributes, Runnable r) {
		try {
			r.run();
			return goodView;
		} catch (Exception e) {
			systemErrLogException(e);
			loggingAttributes.put("exception", e.toString());
//			String grep = St ringUtil.grep(swTrace.toString(), "^(com|org|Caused by)");
//			String grep = StringUtil.grepV(swTrace.toString(), "^\\s*(at|...) ");
//			String reversed = StringUtil.reverseLines(grep);
			final String swTrace = stringTrace(e);
			loggingAttributes.put("traceBrief",
					swTrace); //TODO use reversed
			loggingAttributes.put("trace", swTrace);
			return "error2";
		}
	}
	
	public static String stringTrace(Throwable t) {
		StringWriter swTrace = new StringWriter();
		t.printStackTrace(new PrintWriter(swTrace));
		return swTrace.toString();
	}
	
	public static void systemErrLogException(Exception e) {
		e.printStackTrace();
	}
	
	public static void tryWithResources(Runnable r, final Closeable resource1) {
		try ( final Closeable resource1Ref = resource1 ) {
			r.run();
		} catch (IOException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}

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
