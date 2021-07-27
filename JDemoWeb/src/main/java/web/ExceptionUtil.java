package web;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Map;

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
	public static void systemErrLogException(Exception e) {
		e.printStackTrace();
	}
	
	public static String stringTrace(Throwable t) {
		StringWriter swTrace = new StringWriter();
		t.printStackTrace(new PrintWriter(swTrace));
		return swTrace.toString();
	}

}
