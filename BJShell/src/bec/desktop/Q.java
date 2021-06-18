/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bec.desktop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.sqlite.JDBC;

import com.bryanklumpp.core.MakeTheValidatorHappyException;

/**
 *
 * @author Bryan Klumpp
 */
public class Q {
    
    public static Connection conn = null;
    

    public static int sqlMod(String sql, Object... parameters) {
		B.so(sql + " - ");
		B.sop(parameters);
		try (Connection conn = getSQLiteConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {
			if (parameters != null) {
				int i = 1;
				for (Object parm : parameters) {
					ps.setObject(i++, parm);
				}
			}
			int i = ps.executeUpdate();
			if (i > 1) {
				B.sop("WARNING: more rows updated than expected: " + i);
			}
			return i;
		} catch (Exception ex) {
		    ExceptionUtil.rethrowRuntime(ex);
		    throw new MakeTheValidatorHappyException(ex);
        }
    }

	public static Connection getSQLiteConnection() throws SQLException {
		if (conn == null || conn.isClosed()) {
			conn = DriverManager.getConnection(JDBC.PREFIX + SpecialCustomIndexedFiles.b(SpecialCustomIndexedFiles.SQLITE_DB));
		}
		return conn;
	}
    
    static Object cell(String sql, Object... parameters) {
        return cell(false, sql, parameters);
    }

    static Object cell(boolean allowNulls, String sql, Object... parameters) {
        List<List<Object>> table = table(sql, false, parameters);
        if (allowNulls && table.isEmpty()) {
				return null;
		}
         if (!(table.size() == 1 && table.get(0).size() == 1)) {
            throw new RuntimeException("SQL did not return a single cell: " + table);
        } else {
			Object cell = table.get(0).get(0);
			if(!allowNulls) {B.assertTrue(cell != null);}
			return cell;
        }

    }

	/**
	 * @deprecated unused?
	 * 
	 * @param sql
	 * @param parameters
	 * @return
	 * @throws RuntimeException
	 */
	protected static Object cellOldWay(String sql, List<?> parameters) throws RuntimeException {
		try (Connection conn = getSQLiteConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {
			if (parameters != null) {
				int i = 1;
				for (Object parm : parameters) {
					ps.setObject(i++, parm);
				}
			}
			try (ResultSet rs = ps.executeQuery();) {
				if (!rs.next()) {
					throw new RuntimeException("no rows where one row was expected");
				}
				Object cell = rs.getObject(1);
				if (rs.next()) {
					throw new RuntimeException("multiple rows where one row was expected");
				}
				return cell;
			}
		} catch (Exception ex) {
			ExceptionUtil.rethrowRuntime(ex);
			throw new MakeTheValidatorHappyException(ex);
		}
	}

    //try to limit Moth similarity by using just ResultSetHandler
    static List<List<Object>> table(String sql, boolean includeHeader, Object... parameters) {
		try (Connection conn = getSQLiteConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {
			if (parameters != null) {
				int i = 1;
				for (Object parm : parameters) {
					ps.setObject(i++, parm);
				}
			}
			try (ResultSet rs = ps.executeQuery();) {
				int width = rs.getMetaData().getColumnCount();
				List<List<Object>> rows = new ArrayList<>();
				if (includeHeader) {
					List<Object> header = new ArrayList<>(width);
					for (int i = 1; i <= width; i++) {
						header.add(rs.getMetaData().getColumnLabel(i));
					}
					rows.add(header);
				}
				while (rs.next()) {
					List<Object> row = new ArrayList<>(width);
					for (int i = 1; i <= width; i++) {
						row.add(rs.getObject(i));
					}
					rows.add(row);
				}
				return rows;
			}
		} catch (Exception ex) {
			ExceptionUtil.rethrowRuntime(ex);
			throw new MakeTheValidatorHappyException(ex);
		}
	}

    static List<Object> column(String sql, Object... parms) {
        List<List<Object>> table = Q.table(sql, false, parms);
        List<Object> column = new ArrayList<>();
        if (!table.isEmpty()) {
            if (table.get(0).size() != 1) {
                throw new RuntimeException("incorrect number of columns, expected 1:" + table);
            }
            for (List<Object> row : table) {
                column.add(row.get(0));
            }
        }
        return column;
    }

    static List<Object> row(String sql, Object... parms) {
        List<List<Object>> table = Q.table(sql, false, parms);
        if (table.isEmpty()) { 
            return null; //always correct behavior?
        } else if (table.size() == 1) {
            return table.get(0);
        } else {
            throw new RuntimeException("incorrect number of rows, expected 1:" + table);
        }
    }

    static Integer i(String sql, Object ...parms) {
        return new Integer(Q.cell(false, sql, parms).toString());
    }
}
