package bec.desktop;

public class Mutable<T> {

public T o = null; //TODO why is this public?

  public Mutable() {}

  public Mutable(T p_obj) {
    this.o = p_obj;
  }

  public void set(T p_obj) {
    this.o = p_obj;
  }

  public T get() {
    return this.o;
  }

  public String toString() {
    return o == null ? null : o.toString();
  }
}
