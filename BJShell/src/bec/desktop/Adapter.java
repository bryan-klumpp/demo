package bec.desktop;

public interface Adapter<P, R> {

    R adapt(P input);
}