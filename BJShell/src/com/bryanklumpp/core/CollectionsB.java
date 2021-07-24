package com.bryanklumpp.core;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

import com.bryanklumpp.file.PathSearchStrategy;

/**
 * Convenience methods, etc. for dealing with Collections, Lists, Sets,
 * Maps, etc.
 * 
 * @author Bryan Klumpp
 */
public class CollectionsB {
	
	private static final String[] EMPTY_STRING_ARRAY = new String[] {};

	public static <T, U>Map<T, U> newMap() {
		return new HashMap<T, U>();
	}

	public static boolean hasKey(Map<?, ?> m, Object key) {
	    return m.containsKey(key);
	}

	public static <T,R> List<R> transform(List<T> b4, Function<T, R> mapper) {
		return b4.stream().map(mapper).collect(Collectors.toList());
	}
	
	@SafeVarargs
	public static <T,V> void putMultipleKeys(Map<T, V> map, V val, T...keys) { //compiler warning?https://stackoverflow.com/questions/12462079/possible-heap-pollution-via-varargs-parameter
		for(T key : keys) {
			map.put(key, val);
		}
	}
	
	public static <T> void addAll(Collection<T> collection, Collection<T> items) {
		collection.addAll(items);
	} 
	@SafeVarargs
	public static <T> void addAll(Collection<T> collection, T... items) {
		collection.addAll(Arrays.asList(items));
	} 
	

	@SafeVarargs
	public static <T> List<T> list(T... elements) {
		return Arrays.asList(elements);
	}

	public static <T> List<T> newList() {
		return new ArrayList<T>();
	}
	
	public static <T> List<T> newList(T o1) {
		List<T> res = new ArrayList<T>(1);
		res.add(o1);
		return res;
	}
	public static <T> List<T> newList(T o1, T o2) {
		List<T> res = new ArrayList<T>(1);
		res.add(o1); res.add(o2);
		return res;
	}
	public static <T> List<T> newList(T o1, T o2, T[] a1) {
		return newList(o1, o2, Arrays.asList(a1));
	}
	public static <T> List<T> newList(T o1, List<T> l1) {
		List<T> res = new ArrayList<T>(l1.size() + 1);
		res.add(o1); res.addAll(l1);
		return res;
	}
	public static <T> List<T> newList(T o1, T o2, List<T> l1) {
		List<T> res = new ArrayList<T>(l1.size() + 2);
		res.add(o1); res.add(o2); res.addAll(l1);
		return res;
	}
	public static String[] newArray(String o1, String... a1) {
		String[] res = new String[a1.length + 1];
		res[0] = o1; System.arraycopy(a1, 0, res, 1, a1.length);
		return res;
	}
	public static String[] newArray(String o1, String o2, String[] a1) {
		String[] res = new String[a1.length + 2];
		res[0] = o1; res[1] = o2; System.arraycopy(a1, 0, res, 2, a1.length);
		return res;
	}
	public static <T> List<T> newSubList(int firstIndex, List<T> l) {
		List<T> res = new ArrayList<T>(l.size() - firstIndex);
		res.addAll(l.subList(firstIndex, l.size()));
		return res;
	}

	/**
	 * Searches through multiple hashmaps and returns the value for the first key match found
	 * 
	 * @param <K>
	 * @param <V>
	 * @param key
	 * @param maps
	 * @return
	 */
	@SafeVarargs
	public static <K, V> V getFirstMatch(K key, Map<K, V>... maps) {
		for (Map<K, V> map : maps) {
			V val = map.get(key);
			if (val != null) {
				return val;
			}
		}
		return null;
	}

	public static <T> Iterable<T> iterable(final Enumeration<T> e) {
		return new Iterable<T>() {
			@Override
			public Iterator<T> iterator() {
				return new Iterator<T>() {
					@Override
					public boolean hasNext() {
						return e.hasMoreElements();
					}
					@Override
					public T next() {
						return e.nextElement();
					}
				};
			}
		};
	}

	public static <T> List<T> iteratorToList(Iterable<T> iterable) {
		List<T> res = newList();
		for(T next : iterable) {
			res.add(next);
		}
		return res;
	}

	public static String[] toStringArray(List<String> elements) {
		return elements.toArray(EMPTY_STRING_ARRAY);
	}

	public static <K, V> Map<K, V> mergeMaps(Map<K, V> ... maps) {
		Map<K, V> res = newMap();
		for(Map<K, V> map : maps) {
			res.putAll(map);
		}
		return res;
	}

	public static <T> Set<T> newSet() {
		return new HashSet<T>();
	}


}
