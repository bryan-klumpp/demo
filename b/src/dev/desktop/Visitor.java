package dev.desktop;

interface Visitor<T> {

    void visit(T next);
}