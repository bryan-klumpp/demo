package com.bryanklumpp.bjshell;

import static com.bryanklumpp.custom.ShortcutsStaticImport.f;

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.event.WindowFocusListener;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.WindowConstants;
import javax.swing.event.CaretEvent;
import javax.swing.event.CaretListener;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.CommandContext;
import com.bryanklumpp.core.StringUtil;
import com.bryanklumpp.core.TeeWriter;
import com.bryanklumpp.core.ThreadUtil;
import com.bryanklumpp.custom.CustomCommands;
import com.bryanklumpp.desktop.CoreCommands;

import bec.desktop.ExceptionUtil;
import bec.desktop.Run;
import bec.file.FileUtil;

/**
 * @author Bryan Klumpp
 * @since 6/15/2021
 * 
 *        I have found this kind of desktop developer-hackable utility shell to
 *        be very useful for software support activities, and to a lesser degree
 *        for development. I did search a bit for alternatives and didn't come
 *        up with much. This code is not to be confused with the project
 *        https://sourceforge.net/projects/jash/ which appears to be pretty much
 *        abandoned. There is also JCmd, https://sourceforge.net/projects/jcmd/
 *        I was able to fire that up. It could perhaps have been upgraded to use
 *        modern language features (it's no newer than Java 1.4, possibly
 *        older), but immediately after launch I encountered serious bugs in the
 *        command history, which was enough for me to move on. I haven't come
 *        across anything else in this space...
 *
 *        I didn't (yet) make this code as polished as a normal production app
 *        before releasing it; the currently intended audience is software
 *        developers who will likely run it from an IDE and will probably want
 *        to tinker with it anyway. This is also why there is not much
 *        externalization, as the whole point is to use the full power of a Java
 *        IDE, where feasible, to write developer tasks. The core code has no
 *        dependencies other than JRE 1.8+, but it is easy enough to plug in
 *        commands with additional dependencies. An AutoHotkey script works well
 *        to easily close the current window and re-launch after code
 *        modification.
 */
public class BJShell extends JFrame implements CommandContext {
	
	// This initialization could be done in a constructor, but this
	// just feels natural here and allows final fields which are generally a good
	// smell.  Final fields mitigate the need for some
	// boilerplate code setters, etc. A bit of an experiment, perhaps.
	private final JTextArea ta = new JTextArea();
	private final JScrollPane scrollPane = new JScrollPane(ta);
	private final PrintWriter printWriter = buildPrintWriter(ta, scrollPane);
	private final BJShellState shellState = attemptLoadState(printWriter);
	private final Map<String, Command> instanceCommands = buildInstanceCommands();
	private final JTextField tf = new JTextField();
	private static final long serialVersionUID = 1L; // unused, just to make the validator happy

	private PrintWriter buildPrintWriter(JTextArea ta2, JScrollPane sp2) {
		StringWriter stringWriter = buildStringWriter(ta2, sp2);
		OutputStreamWriter outputStreamWriter = new OutputStreamWriter(System.out);
		return new PrintWriter(new TeeWriter(stringWriter, outputStreamWriter), true);
	}

	/**
	 * @param taLocal - asking for this as a parameter to enforce initialization sequence, even though it's available as a field
	 * @param spLocal - asking for this as a parameter to enforce initialization sequence, even though it's available as a field
	 * @return
	 */
	StringWriter buildStringWriter(JTextArea taLocal, JScrollPane spLocal) { 
		final JTextArea syncMe = taLocal;
		return new StringWriter() {
			public void flush() {
				synchronized (syncMe) { // unlikely that synchronized vs. not is going to be critical here, but if it
										// becomes an issue see
										// https://stackoverflow.com/questions/11072253/is-printwriter-thread-safe and
										// https://community.oracle.com/tech/developers/discussion/2170775/is-jtextarea-append-method-thread-safe
					super.flush();
					taLocal.append(getBuffer().toString());
					getBuffer().delete(0, getBuffer().length());
					
					// This forces scroll to bottom. Just calling scroll methods seems like the
					// more natural way to do this, but initial attempts were unsuccessful;
					// TODO try again to invoke scroll methods instead.
					taLocal.setCaretPosition(taLocal.getText().length()); 
				}
			}
		};
	}

	private String getContextDirectoryS() {
		return getContextDir().toString();
	}

	public Path getContextDir() {
		return getShellState().getContextDir();
	}

	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			@Override
			public void run() {
				new BJShell();
			}
		});
	}

	private void printContextDirectory(PrintWriter w) {
		w.println(getContextDir());
	}

	public BJShell() {
		// With the default system L&F, there was some issue on my PC with
		// delayed painting of the title bar when switching to that
		// Window from an AutoHotkey script.  This can be commented out to
		// revert to the system L&F
		DesktopUtil.setMetalLookAndFeel(DesktopUtil.LIGHT_GRAY, this);  

		setTitle("BJShell");
		addWindowFocusListener(new WindowFocusListener() {
			@Override
			public void windowGainedFocus(WindowEvent e) {
				tf.requestFocusInWindow();
			}
			@Override
			public void windowLostFocus(WindowEvent e) {
			}
		});
		addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				syncAndSaveState(getWriter());
			}
		});
		setLayout(new BorderLayout());
		ta.setLineWrap(true);
		ta.setWrapStyleWord(true);
		ta.setAutoscrolls(true);
		ta.setEditable(false);
		ta.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				tf.requestFocusInWindow();
				tf.setText(tf.getText() + e.getKeyChar());
			}
		});
		add(scrollPane, BorderLayout.CENTER);
		tf.addActionListener(buildActionListener());
		add(tf, BorderLayout.SOUTH);
		setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
		ta.addCaretListener(getCaretListener());
		applyStateAndPack(shellState);
		setVisible(true);
		getWriter().flush(); // forces scroll to the bottom of the JTextArea in the case
		tf.requestFocusInWindow();
	}
	private void applyStateAndPack(BJShellState s) {
		setContextDir(s.getContextDir());
		scrollPane.setPreferredSize(s.getPersistedSize());
		setLocation(s.getPersistedLocationOnScreen());
		pack(); 
		// it is important to set size/location and pack before populating the JTextArea; 
		// doing it in the reverse order proved quite slow if there was a lot of saved text
		ta.setText(s.persistedTaText);
	}
	public BJShellState getShellState() {
		return shellState;
	}

	public BJShellState attemptLoadState(PrintWriter printWriter2) {
		BJShellState state1;
		try {
			state1 = (BJShellState) FileUtil.loadObject(BJShellState.SERIALIZATION_FILE);
		} catch (Exception e) {
			e.printStackTrace(printWriter2);
			state1 = new BJShellState();
		}
		return state1;
	}
	/**
	 * This method updates the record of visual elements of BJShellState that are
	 * probably out of sync by now and saves the state to disk
	 * 
	 * @param w
	 */
	public void syncAndSaveState(PrintWriter errorWriter) {
		try {
			getShellState().persistedTaText = StringUtil.lastNChars(100000, ta.getText()); // Keeping history forever will impact performance eventually... 
			getShellState().setPersistedSize(scrollPane.getSize());
			getShellState().setPersistedLocationOnScreen(getLocationOnScreen());// https://support.oracle.com/knowledge/Middleware/2355820_1.html
			FileUtil.saveObject(BJShellState.SERIALIZATION_FILE, getShellState());
		} catch (Exception e) {
			e.printStackTrace(errorWriter);
		}
	}
	@Override
	public void dispose() {
		getWriter().close();
		super.dispose();
	}

	PrintWriter getWriter() {
		return printWriter;
	}

	private CaretListener getCaretListener() {
		return new CaretListener() {
			@Override
			public void caretUpdate(CaretEvent e) {
				String selectedText = ta.getSelectedText();
				if (selectedText != null && !selectedText.isEmpty()) { // filter out caret being set at end after
																		// output, which is not a clipboard-copy event
																		// and also throws an Exception for some reason,
																		// maybe because launched from a user-generated
																		// Thread and not using
																		// SwingUtilities.invokeLater?
					DesktopUtil.setClipboardText(selectedText);
				}
			}
		};
	}

	ActionListener buildActionListener() {
		return new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				String text = tf.getText();
				String args = (text.contains(" ") ? text.substring(text.indexOf(' ') + 1, text.length()) : "");
				tf.setText("");
				getWriter().println();
				printWriter.println("> " + text + " >>");
				final String[] piecesA = text.split(" ");
				List<String> pieces = Arrays.asList(piecesA);
				String cmdString = pieces.get(0);
				final Command cmd = getCmd(cmdString);
				Runnable r = () -> {
					try {
						if (cmd != null) {
							cmd.exec(args, pieces.subList(1, pieces.size()), printWriter, getShellState());
						} else {
							Run.execProcessOSTextGuts(getContextDir(), printWriter, pieces);
						}
						printWriter.flush();
					} catch (Exception e1) {
						e1.printStackTrace(printWriter);
						ExceptionUtil.rethrowRuntime(e1);
					}
				};
				ThreadUtil.start(r);
			}

			Command getCmd(String cmdString) {
				return CollectionsB.getFirstMatch(cmdString, 
						instanceCommands,
						CustomCommands.COMMANDS,
						StatefulCommands.COMMANDS,
						CoreCommands.cmds);
			}
		};
	}

	/**
	 * These are commands that require a reference to a BJShell GUI window
	 * 
	 * @return
	 */
	public Map<String, Command> buildInstanceCommands() {
		Map<String, Command> cmdMap = CollectionsB.newMap();
		String[] keys = { "cls", "cl" };
		CollectionsB.putMultipleKeys(cmdMap, (argsv, args, w, context) -> {
			ta.setText("");
		}, keys);
		String[] keys1 = { "unicode" };
		CollectionsB.putMultipleKeys(cmdMap, (argsv, args, w, context) -> {
			w.println(ta.getFont());
			ta.setFont(new Font("unifont", java.awt.Font.PLAIN, 14));
			w.println("0x0702: \u0702");
		}, keys1);
		CollectionsB.putMultipleKeys(cmdMap, (argsv, args, w, context) -> {
			Runnable r = () -> {
				ThreadUtil.sleepSeconds(.3); // ok this is a big-time hack, but just give a bit of time to ensure that the
										// new one launched before we exit this instance.
				setVisible(false);  
				dispose();
				w.println("this window should be hidden or even disposed, why isn't it?");
				/*
				 * Without the System.exit, this method was doing incredibly weird things -
				 * leaving the old window visible despite the call to setVisible, mirroring
				 * output to both windows, freezing one of the windows... System.exit doesn't
				 * feel like the cleanest solution possible, but it'll have to do for now. I
				 * wonder if having a java.lang.Process still running might prevent an automatic
				 * exit anyway, but more testing needed.
				 */
				System.exit(0);
			};
			SwingUtilities.invokeLater(r);
			Run.execExternalJavaB(w, getContextDir(), f("bjshell"));
		}, new String[] { "newsh", "jj" });
		String[] keys3 = { "ser" };
		CollectionsB.putMultipleKeys(cmdMap, new Command() {
			@Override
			public void exec(String argsv, List<String> args, PrintWriter w, CommandContext context) throws Exception {
				syncAndSaveState(w);
			}
		}, keys3);

		return cmdMap;
	}
	
	@Override
	public void setContextDir(Path contextDir) {
		getShellState().setContextDir(contextDir);
	}



}
