package com.bryanklumpp.core;

import bec.desktop.ExceptionUtil;

public class ThreadUtil {

	/**
	 * This method doesn't do much, perhaps the most useful thing is that a search
	 * for references is a really convenient way to analyze all the thread creation
	 * in a program, if this is used consistently
	 * 
	 * @param r
	 * @return 
	 */
	public static Thread start(Runnable r) {
		Thread thread = new Thread(r);
		thread.start();
		return thread;
	}

	/**
	 * @param seconds (possibly fractional) number of seconds to sleep
	 * @throws RuntimeInterruptedException
	 */
	public static void sleepSeconds(double seconds) throws RuntimeInterruptedException {
		sleep((long) (seconds * 1000));
	}

	/**
	 * @param millis
	 * @throws RuntimeInterruptedException
	 */
	public static void sleep(long millis) throws RuntimeInterruptedException {
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			ExceptionUtil.rethrowRuntime(e);
		}
	}
}
