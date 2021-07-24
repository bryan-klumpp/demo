package dev.start;

public enum TestStartupErrorEnum {

	INSTANCE ("hellow");
	
	private String s;

	TestStartupErrorEnum(String s) {
		this.s = s;
	}
	
	@Override
	public String toString() {
		return getClass().getName() + " - "+s;
	}
}
