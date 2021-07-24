/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.desktop;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 *
 * @author Bryan Klumpp
 */
public class Sound {

    public static void main(String[] args) {
        new Sound();
    }
    Process currentPlayer = null;

    void play(double pvol, String file) {
        try {
            String cmd = "cvlc --no-loop --play-and-exit --volume " + Math.round(pvol * 256) + " " + file;
            System.out.println(cmd);
            Process p = Runtime.getRuntime().exec(cmd);
            currentPlayer = p;
            try {
                logStreamByLine(p.getInputStream());
// timing issue?               logStreamByLine(p.getErrorStream()); 

                p.waitFor();
            } finally {
                if (currentPlayer == p) {
                    currentPlayer = null;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void logStreamByLine(InputStream is) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(is));
        String line = br.readLine();
        while (line != null) {
            System.out.println(line);
        }
    }

    public void stopPlayer() {
        if (currentPlayer != null) {
            currentPlayer.destroy();
        }
    }
}
