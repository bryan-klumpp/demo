package com.bryanklumpp.core;

import java.io.PrintWriter;
import java.util.List;


/**
 * @author Bryan Klumpp
 * 
 *         Commands wrapping functionality to be executed primarily on a
 *         console, although they could have other uses as well
 */
public interface Command {

    /**
     * @param argsOneString
     * @param args - argsOneString tokenized by spaces
     * @param cmdWriter - use this to write output to be displayed on a console or redirected
     * @param context - contains information on context (working) directory, etc.
     * @throws Exception
     */
    void exec(String argsOneString, List<String> args, PrintWriter cmdWriter, CommandContext context) throws Exception;
}