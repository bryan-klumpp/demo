package com.bryanklumpp.custom;

import java.util.Arrays;
import java.util.List;

/**
 * This class is intended as a safe source for methods that are very frequently
 * used during heavy development for which I can define very short method names,
 * combined with static imports, to save a lot of keystrokes. When you're ready
 * to release your code to a broader audience, use refactoring tools to give more
 * descriptive names, move the methods to a more descriptive parent, and/or
 * inline them out of existence.
 *
 * @author Bryan Klumpp
 *
 */
public class s {

	/**
	 * Shorthand for creating a List from varags syntax. This method could probably
	 * just be inlined before release.
	 * 
	 * @param <T>
	 * @param elements (varargs or array)
	 * @return List
	 */
	@SafeVarargs
	public static <T> List<T> l(T... elements) {
		return Arrays.asList(elements);
	}
	
	
	
}
