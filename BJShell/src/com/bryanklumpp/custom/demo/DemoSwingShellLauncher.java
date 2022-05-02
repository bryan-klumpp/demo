package com.bryanklumpp.custom.demo;

import java.util.List;
import java.util.Map;

import javax.swing.JFrame;
import javax.swing.JRootPane;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.plaf.ColorUIResource;
import javax.swing.plaf.metal.DefaultMetalTheme;
import javax.swing.plaf.metal.MetalLookAndFeel;

import com.bryanklumpp.bjshell.BJShellCustomizer;
import com.bryanklumpp.bjshell.DesktopUtil;
import com.bryanklumpp.bjshell.SwingShell;
import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.core.ExceptionUtil;
import com.bryanklumpp.core.JVMState;
import com.bryanklumpp.file.PathSearchStrategy;

public class DemoSwingShellLauncher {
	public static void main(String[] args) {
		new SwingShell(new BJShellCustomizer() {
			@Override
			public Map<String, Command> getCustomCommands() {
				return DemoCustomCommands.COMMANDS;
			}
			@Override
			public void applyLookAndFeel(JFrame shellWindow) {
			}
			@Override
			public List<PathSearchStrategy> getCustomExtraFileMatchStrategies() {
				return CollectionsB.newList();
			}
		}).setVisible(true);

	}
}
