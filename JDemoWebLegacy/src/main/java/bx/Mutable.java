package bx;

public class Mutable<T> {

public T o = null;

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
