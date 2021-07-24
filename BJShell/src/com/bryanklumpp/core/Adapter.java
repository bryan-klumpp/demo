package com.bryanklumpp.core;

/**
 * @author Bryan Klumpp
 * 
 *         I just realized this is pretty much the same functionality as
 *         java.util.function.Function; TODO phase this out for Function
 *
 * @param <P>
 * @param <R>
 */
public interface Adapter<P, R> {

    R adapt(P input);
}