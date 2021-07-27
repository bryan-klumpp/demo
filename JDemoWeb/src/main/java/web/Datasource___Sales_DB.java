package web;

import javax.annotation.ManagedBean;
import javax.annotation.PreDestroy;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

@ManagedBean
public class Datasource___Sales_DB {
	public static String SALES_DB = "SalesDB";
	
	//TODO expensive
	public static EntityManagerFactory EMF = Persistence.createEntityManagerFactory(SALES_DB);
	public static EntityManager EM = EMF.createEntityManager();

	@PreDestroy
	public void shutdown() {
		System.out.println("predestroy");
		try {
			EM.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			EMF.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
