package web;

import javax.persistence.EntityManager;

import org.hibernate.Hibernate;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.bryanklumpp.demo.Mutable;


//@EnableTransactionManagement
//@Configuration
public class CustomerDemo {

	public static Customer demoCustomer() {
		final Mutable<Customer> c = new Mutable<Customer>();
		DBUtil.dbExec(new DbOperation() {
			
			@Override
			public void run(EntityManager em) {
				c.set(doTestLoadCustomer(em, 1L));
				if(c.get() == null) {
					throw new RuntimeException("could not find customer 1");
				}
				doTestSaveCustomer(em);
			} 
		}, "SalesDB");
		return c.get();
	}
	public static Customer doTestLoadCustomer(EntityManager em2, long id) {
		Customer c = new Customer();
		Hibernate.initialize(c);
		c.setId(id);
		return em2.find(c.getClass(), c.getId());
	}

	@Transactional
	private static void doTestSaveCustomer(EntityManager em2) {
	 		Customer c = new Customer();
			c.setId(System.currentTimeMillis() % 999999);
			c.setAddress("some_address");
			c.setEmail("me@you.com");
			c.setName("Bryan");
	//		Hibernate.initialize(c);
//			em2.joinTransaction();
			em2.persist(c);
//			em2.flush(); // this is a clue to many of my JPA silently failing woes I think: https://stackoverflow.com/questions/1801828/hibernate-jpa-and-spring-javax-persistence-transactionrequiredexception-no-tran
//			System.out.println("saved customer: ");
		}

	public void doAll(Model model) throws Exception {
			demoCustomer();
	//		testSaveAndFind();
	//		testSaveAndGet();
	//		testSaveOrderWithItems();
		}

}
