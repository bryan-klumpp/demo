package com.bryanklumpp.core;

import java.util.Set;

/**
 * @author Bryan Klumpp
 *
 * Some helper methods related to JVM lifecycle
 */
public class JVMState {
	
	private static final Set<Object> singleExecutionRecord = CollectionsB.newSet();

	/**
	 * There are some activities that should only be done once in a running JVM that
	 * would have side effects if done again. This uses a Set to track invocations
	 * of Runnables, and if the key is already in the map, the Runnable will not be
	 * invoked (regardless of any differences between the Runnable instances).
	 * 
	 * @param key (the already-ran check will be synchronized on this key;
	 *             recommend using a constant which should have only one copy in the JVM)
	 * @param runnable
	 */
	public static void doOnlyOnceInJVM(Object key, Runnable runnable) {
		boolean firstTime;
		synchronized (key) {
			firstTime = singleExecutionRecord.add(key);
		}
		if (firstTime) {
			runnable.run();
		}
	}
}
