/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dev.desktop;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.bryanklumpp.core.ExceptionUtil;

/**
 *
 * @author Bryan Klumpp
 */
public class SoundCVLC {

    public static void main(String[] args) {
//        Sound sound = new Sound();
//        sound.playWithCVLC(.25, Alarm.file);
    }
    private Process currentPlayer = null;

/*    public static JavaSoundAudioClip getClip(String audioFileName) {
        try {
            return new JavaSoundAudioClip(new FileInputStream(audioFileName));
        } catch (IOException ex) {
            ExceptionUtil.rethrow(ex);
        }
    }

    public static void play(String fileName) {
        try {
            new JavaSoundAudioClip(new FileInputStream(fileName)).play();
        } catch (IOException ex) {
            ExceptionUtil.rethrow(ex);
        }
    }
*/    
    void playWithCVLC(double pvol, String file) {
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
            ExceptionUtil.rethrowRuntime(e);
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
