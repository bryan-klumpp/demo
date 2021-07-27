package com.bryanklumpp.demo;

/**
 * Simple generic for enabling passing a mutable object as a parameter. Same
 * basic idea as Mutable in Apache Commons Lang.
 * 
 * @author Bryan Klumpp
 *
 * @param <T>
 */
public class Mutable<T> {
	private T val = null;

	public Mutable() {
	}

	public Mutable(T val) {
		this.val = val;
	}

	public void set(T val) {
		this.val = val;
	}

	public T get() {
		return this.val;
	}

	public String toString() {
		return val == null ? null : val.toString();
	}
}
