package web;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.Persistence;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.dialect.H2Dialect;
import org.springframework.transaction.annotation.Transactional;

//@Configuration
//@RunWith(SpringJUnit4ClassRunner.class)
public class HSQL_OrderPersistenceServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//		resp.getWriter().println("yes!");
//		try {
//			doAll(resp.getWriter());
//		} catch (Exception e) {
//			e.printStackTrace(resp.getWriter());
//		}
		super.doGet(req, resp);
	}
	
	@PersistenceContext(unitName="SalesDB") //was "JSFTestPU??
	//private EntityManager entityManager = null;//getEntityManager_application();//Bryan start herePersistence.createEntityManagerFactory("application").createEntityManager(); //Bryan decided to manually initialize was not auto-initalizing
	private EntityManager em = getEntityManager_mysql();//Bryan start herePersistence.createEntityManagerFactory("application").createEntityManager(); //Bryan decided to manually initialize was not auto-initalizing

	private EntityManager getEntityManager_application() {
		Map<String, Object> props = new HashMap<String, Object>();
		putHsqlProps(props);
		return Persistence.createEntityManagerFactory("application", props).createEntityManager();

	}
	private EntityManager getEntityManager_mysql() {
		Map<String, Object> props = new HashMap<String, Object>();
		putMysqlPropsSalesDB(props);
		return Persistence.createEntityManagerFactory("SalesDB").createEntityManager();

	}

	private void putHsqlProps(Map<String, Object> props) {
		props.put("hibernate.dialect", H2Dialect.class.getName());
//		props.put("hibernate.cache.provider_class", HashtableCacheProvider.class.getName());
		props.put("spring.datasource.url","jdbc:h2:file:c:/b/server/bh2tmp");
		props.put("spring.datasource.driverClassName","org.h2.Driver");
		props.put("spring.datasource.username","sa");
		props.put("spring.datasource.password","");
		props.put("spring.jpa.database-platform","org.hibernate.dialect.H2Dialect");
		props.put("spring.jpa.hibernate.ddl-auto","update");
	}
	
	private void putMysqlPropsSalesDB(Map<String, Object> props) {
		props.put("javax.persistence.jdbc.url","jdbc:mysql://localhost:3306/sales");
        props.put("javax.persistence.jdbc.user","b");
        props.put("javax.persistence.jdbc.password",Passwords.G);
        props.put("javax.persistence.jdbc.driver","com.mysql.jdbc.Driver");
        props.put("hibernate.show_sql","true");
        props.put("hibernate.format_sql","true");
	}

	public void testSaveOrderWithItems() throws Exception {
		Order order = new Order();
		order.getItems().add(new Item());
		em.persist(order);
		em.flush();  //only for transactions
	}

//	@Transactional
	public void testSaveAndGet() throws Exception {
		Order order = new Order();
		order.getItems().add(new Item());
		em.persist(order);
		em.flush();  //only for transactions
		// Otherwise the query returns the existing order (and we didn't set the
		// parent in the item)...
		em.clear();
		Order other = (Order) em.find(Order.class, order.getId());
	}

	@Transactional
	public void testSaveAndFind() throws Exception {
		Order order = new Order();
		Item item = new Item();
		item.setProduct("foo");
		order.getItems().add(item);
		em.persist(order);
//		entityManager.flush(); //only for transactions
		// Otherwise the query returns the existing order (and we didn't set the
		// parent in the item)...
		em.clear();
		Order other = (Order) em
				.createQuery(
						"select o from Order o join o.items i where i.product=:product")
				.setParameter("product", "foo").getSingleResult();
		System.out.println("order: "+other.getId());
	}

}
