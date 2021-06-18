package com.bryanklumpp.core;

public class RuntimeInterruptedException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	public RuntimeInterruptedException(Exception e) {
		super(e);
	}
}
