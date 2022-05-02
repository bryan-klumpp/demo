package com.bryanklumpp.bjshell;

import java.util.List;
import java.util.Map;

import javax.swing.JFrame;

import com.bryanklumpp.core.CollectionsB;
import com.bryanklumpp.core.Command;
import com.bryanklumpp.file.PathSearchStrategy;

/**
 *         Allows a type-safe way to expose custom properties to a shell.
 *         Properties are assumed to be immutable, and BJShellState has the
 *         mutable elements.
 *
 * @author Bryan Klumpp
 */
public interface BJShellCustomizer {
	
	/**
	 * @return a Map of personalized/customized commands to be added to existing commands
	 */
	Map<String, Command> getCustomCommands();
	/**
	 * @param shellWindow a JFrame to which a custom look and feel is to be applied
	 */
	public void applyLookAndFeel(JFrame shellWindow);
	/**
	 * Add your own personal methods of searching the file system
	 * @return 
	 */
	public List<PathSearchStrategy> getCustomExtraFileMatchStrategies();
	
	/**
	 * Singleton for use when no customization is needed; does basically nothing.
	 */
	static BJShellCustomizer DEFAULT = new BJShellCustomizer() {
		@Override
		public Map<String, Command> getCustomCommands() {
			return CollectionsB.newMap();
		}

		@Override
		public void applyLookAndFeel(JFrame shellWindow) {
			// just leave the default L&F
		}

		@Override
		public List<PathSearchStrategy> getCustomExtraFileMatchStrategies() {
			return CollectionsB.newList();
		}

	};
	
}
