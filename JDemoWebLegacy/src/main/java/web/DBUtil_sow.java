package web;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.ParameterExpression;
import javax.persistence.criteria.Root;

import org.springframework.util.CollectionUtils;

public class DBUtil_sow {
	
	public static void newRow(final Object o, String db) {
		DBUtil_sow.dbExec(new DbOperation() { //NOTE: do not use Lambda here, need to copy to old 1.6 project
			@Override
			public void run(EntityManager em) {
				em.persist(o);
			}
		}, db);
	}
	public static void dbExec(DbOperation dbe, String persistenceUnitName) {
		EntityManager em = Persistence.createEntityManagerFactory(persistenceUnitName).createEntityManager();
		EntityTransaction tran = em.getTransaction();
		try {
			tran.begin();
			dbe.run(em);
			tran.commit();
			em.close();
		} catch (Exception e) {
			try {
				tran.rollback();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			throw new RuntimeException(e);
		} finally {
			if(em.isOpen()) {
				try {
					em.close();
				} catch (Exception e2) {
					e2.printStackTrace();
				}
			}
		}
	}



}
