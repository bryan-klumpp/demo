package bec.desktop;

import java.io.File;

class FileTreeBWalker {

    private Visitor<File> visitor = null;

    FileTreeBWalker(Visitor<File> visitor) {
        this.visitor = visitor;
    }

    void walk(File f) {
        if (f.isDirectory()) {
            for (File next : f.listFiles()) {
                walk(next); //recursive
            }
        }
        visitor.visit(f);
    }
}