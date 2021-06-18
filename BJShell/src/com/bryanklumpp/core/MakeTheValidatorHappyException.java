package com.bryanklumpp.core;

/**
 * @author Bryan Klumpp
 * 
 * This exception should never actually be thrown; the class exists just to make validators happy, but should only be used in places where the previous line is guaranteed to (re)throw an exception
 *
 */
public class MakeTheValidatorHappyException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	public MakeTheValidatorHappyException(Exception e) {
		super("This exception should never actually be thrown; the class exists just to make validators happy, but should only be used in places where the previous line is guaranteed to (re)throw an exception: "+e.getMessage(), e);
	}
}
