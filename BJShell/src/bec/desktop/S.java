/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bec.desktop;

import java.nio.file.Path;

/**
 *
 * @author Bryan Klumpp
 */
public class S {

    public static boolean eq(String l, String r) {
        return l != null && r != null && l.equals(r);
    }
	public static String lpad(int len, String before, char c) {
		while(before.length() < len) { //quick and dirty
			before = c + before;
		}
		return before;
	}
	
	public static String toString(Path path) {
		return path.toString();
	}
}
