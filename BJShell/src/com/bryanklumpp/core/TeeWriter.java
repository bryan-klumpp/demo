package com.bryanklumpp.core;

import java.io.IOException;
import java.io.Writer;
import java.util.Arrays;
import java.util.List;

/**
 * Note that there is a same-named class in Apache Commons IO
 * that provides similar (but probably more robust) functionality
 * 
 * @author Bryan Klumpp
 *
 */
public class TeeWriter extends Writer {
	private List<Writer> writers;
	
	public TeeWriter(Writer... writers) {
		this.writers = Arrays.asList(writers);
	}

	@Override
	public void write(char[] cbuf, int off, int len) throws IOException {
		for(Writer w : writers) {
			w.write(cbuf, off, len);
		}
	}

	@Override
	public void flush() throws IOException {
		for(Writer w : writers) {
			w.flush();
		}
	}

	@Override
	public void close() throws IOException {
		IOException lastException = null; // only going to try to save one of them, if there happens to be more than one
		for (Writer w : writers) {
			try {
				w.close();
			} catch (IOException e) {
				lastException = e;
			}
		}
		if (lastException != null) {
			throw lastException;
		}
	}
}
