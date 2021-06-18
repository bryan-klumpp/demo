package com.bryanklumpp.core;

public class Counter {
	private int ct;
	
	public int get() {return ct;}
	
	public synchronized void increment() {
		ct++;
	}
}
