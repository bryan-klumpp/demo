package dev.desktop;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

import com.bryanklumpp.core.ThreadUtil;
import com.bryanklumpp.custom.SelfNameIndexedFiles;

public class AudioPlayer {
	
	public static void main(String[] args) {
		Clip clip = loopWav(SelfNameIndexedFiles.pathString("90"));
		while(clip.isOpen()) {
			ThreadUtil.sleep(1000);
		}
	}
	
	/**
	 * Loop-plays a wav file infinitely
	 * 
	 * @param wavFile
	 * @return
	 */
	public static Clip loopWav(final String wavFile) {
		
		try (FileInputStream fis = new FileInputStream(new File(wavFile));
				BufferedInputStream bis = new BufferedInputStream(fis);
				AudioInputStream inputStream = AudioSystem
				.getAudioInputStream(bis);) {
			Clip clip = AudioSystem.getClip();
			clip.open(inputStream);
			clip.loop(Clip.LOOP_CONTINUOUSLY);
			return clip;
		} catch (LineUnavailableException e) {
			throw new RuntimeException(e);
		} catch (FileNotFoundException e1) {
			throw new RuntimeException(e1);
		} catch (IOException e1) {
			throw new RuntimeException(e1);
		} catch (UnsupportedAudioFileException e1) {
			throw new RuntimeException(e1);
		}
	}
}
