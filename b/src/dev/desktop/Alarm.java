package dev.desktop;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.util.List;

import javax.sound.sampled.Clip;
import javax.swing.JFrame;
import javax.swing.JTextArea;
import javax.swing.SwingUtilities;
import javax.swing.WindowConstants;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.core.RuntimeInterruptedException;
import com.bryanklumpp.core.ThreadUtil;
import com.bryanklumpp.custom.SelfNameIndexedFiles;

/**
 * @author Bryan Klumpp
 *
 *         TODO add synchronization, some race conditions are theoretically
 *         possible with audio stopping/starting based on timers vs. keystrokes,
 *         etc. 
 */
public class Alarm {
	private double preSnoozeHours = 0;
	private double typeSnoozeMinutes = 2;
	private long normalTypingDelaySec = 10;
	private volatile long lastUserInteraction = System.currentTimeMillis();
	private Clip playerProc = null;
	private final JFrame f = new JFrame();

	public static String audfile() {
		return SelfNameIndexedFiles.pathString("90");
	} 


	void main() {
		gui();
	}

	
	public static void main2(List<String> args) {
		main(CollectionsB.toStringArray(args));
	}
	public static void main(String[] args) {
		Alarm a = new Alarm();
		if (args.length > 0) {
			a.typeSnoozeMinutes = Double.parseDouble(args[0]);
		}
		if (args.length > 1) {
			a.preSnoozeHours = Double.parseDouble(args[1]);
		}
		a.main();
	}

	public interface StringRunnable {
		String run(String s);
	}

	private void sleepSecond() {
		ThreadUtil.sleepSeconds(1);
	}

	void ensurePlaying(double pvol) {
		try {
			if (playerProc == null) {
				playerProc = AudioPlayer.loopWav(audfile());
			}
		} catch (java.lang.Exception e) {
			stopAudio();
			ExceptionUtil.rethrowRuntime(e);
		}
	}


	protected void stopAudio() {
		if (playerProc != null) {
			try {
				playerProc.stop();
			} finally {
				try {
					playerProc.close();
				} finally {
					playerProc = null;
				}
			}
		}
	}

	private void gui() {
		if (!new File(audfile()).exists()) {
			throw new RuntimeException("audfile missing: ");
		}
		f.setLayout(new BorderLayout());
		final JTextArea ta = new JTextArea();
		ta.setForeground(Color.WHITE);
		ta.setBackground(Color.BLACK);
		ta.setSelectionColor(Color.BLUE);
		ta.setFont(new Font("Serif", Font.PLAIN, 20));
		ta.addKeyListener(new KeyAdapter() {
			public void keyTyped(KeyEvent arg0) {
				SwingUtilities.invokeLater(() -> {
					lastUserInteraction = System.currentTimeMillis();
					ta.setForeground(Color.WHITE);
					ta.setBackground(Color.BLACK);
					f.setTitle("Alarm ..............");
					stopAudio();
				});
			}
		});
		f.add(ta, BorderLayout.CENTER);
		f.setVisible(true);
		f.setSize(1000, 500);
		f.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
		final Thread mainThread = Thread.currentThread();
		f.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent arg0) {
				mainThread.interrupt();
			}
		});
		try {
			lastUserInteraction = System.currentTimeMillis();
			System.out.println(SwingUtilities.isEventDispatchThread());
			if(preSnoozeHours > .0001) {
				ensurePlaying(1); // test sound
				ThreadUtil.sleepSeconds(10);
				stopAudio();
				ta.setText("you should have heard a test sound.  Entering long wait phase for " + preSnoozeHours + " hours...");
				ThreadUtil.sleepSeconds(60 * 60 * preSnoozeHours);
			}
			ta.setText("entering interactive phase...");
			ta.select(0, ta.getText().length());
			while (true) { // could have just used f.isShowing() which would be simpler, but would have a delay up to whatever the loop sleep time is.  Been looking for an excuse to try Thread interruption and propagating RuntimeInterruptedException anyway... 
				SwingUtilities.invokeLater(() -> {
					if (!violation()) {
						updateTitleNonViolation();
					} else {
						f.setTitle("no activity - type something!");
						// Maybe should use external program like AutoHotkey to bring window to foreground based on Window title change...
						ta.setBackground(ta.getBackground() == Color.WHITE ? Color.BLACK : Color.WHITE);
						ta.setForeground(ta.getBackground() == Color.WHITE ? Color.BLACK : Color.WHITE);
						ensurePlaying(1);
					}
				});
				sleepSecond();
			}
		} catch (RuntimeInterruptedException e) {
			// probably came from the WindowListener interrupting the main thread when window closed
		}
		stopAudio();
	}
	void updateTitleNonViolation() {
		if (secondsLeft() < (typeSnoozeMinutes * 60) - normalTypingDelaySec) {
			SwingUtilities.invokeLater(() -> f.setTitle("Alarm thinking: " + secondsLeft()));
		}
	}

	long secondsLeft() {
		return (typeSnoozeMillis() - (System.currentTimeMillis() - lastUserInteraction)) / 1000;
	}

	long typeSnoozeMillis() {
		return (long) (typeSnoozeMinutes * 60 * 1000);
	}
	private boolean violation() {
		return System.currentTimeMillis() - lastUserInteraction > typeSnoozeMillis();
	}
}
