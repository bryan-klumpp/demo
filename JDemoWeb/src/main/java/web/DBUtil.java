package web;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.ParameterExpression;
import javax.persistence.criteria.Root;

import org.springframework.util.CollectionUtils;

public class DBUtil {
	
	public static Query getQuery(String jpql) {
		return Datasource___Sales_DB.EM.createQuery(jpql);  // :id
	}
	
	/**
	 * adapted from https://stackoverflow.com/questions/14977018/jpa-how-to-get-entity-based-on-field-value-other-than-id/57900710
	 * @param <T>
	 * 
	 * @param entityClass
	 * @param yourFieldValue
	 * @param em
	 * @return
	 */
	public static <T> List<T> findByYourField(Class<T> entityClass, String fieldName, String yourFieldValue)
	{
	    final List<T> queryResult = new ArrayList<T>();
	    dbExec(new DbOperation() {
			@Override
			public void run(EntityManager em) {
			    CriteriaBuilder criteriaBuilder = em.getCriteriaBuilder();
			    CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(entityClass);
			    Root<T> root = criteriaQuery.from(entityClass);
			    criteriaQuery.select(root);

			    ParameterExpression<String> params = criteriaBuilder.parameter(String.class);
			    criteriaQuery.where(criteriaBuilder.equal(root.get(fieldName), params));

			    TypedQuery<T> query = em.createQuery(criteriaQuery);
			    query.setParameter(params, yourFieldValue);

			    queryResult.addAll(query.getResultList());
			}
		}, "SalesDB");
	    return queryResult;
	}
	
	public static void newRow(final Object o, String db) {
		DBUtil.dbExec(new DbOperation() { //NOTE: do not use Lambda here, need to copy to old 1.6 project
			@Override
			public void run(EntityManager em) {
				em.persist(o);
			}
		}, db);
	}
	public static void dbExec(DbOperation dbe, String persistenceUnitName) {
		EntityManager em = Datasource___Sales_DB.EM;
		EntityTransaction tran = em.getTransaction();
		try {
			tran.begin();
			dbe.run(em);
			tran.commit();
//			em.close();
		} catch (Exception e) {
			try {
				tran.rollback();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			throw new RuntimeException(e);
		} finally {
//			if(em.isOpen()) {
//				try {
//					em.close();
//				} catch (Exception e2) {
//					e2.printStackTrace();
//				}
//			}
		}
	}



}
