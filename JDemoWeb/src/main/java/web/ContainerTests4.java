package web;

import java.util.Optional;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import com.bryanklumpp.demo.LibraryProject;

import junit.framework.TestCase;
import web.filerec.FileRecService;
import web.filerec.file_rec;

public class ContainerTests4 extends TestCase {

//	@Test
//	public void test() {
//		testLoadFileDbRecordFromMySQL();
//		testLibraryProjectReferenceTo_bxargs();
//		testCustomerDemoMySQL();
	
	public void testCustomerDemoMySQL() {
		assertEquals("Bryan", CustomerDemo.demoCustomer().getName());
	}
	
	public void testApplicationContextCentral() {
		assertNotNull(ApplicationContextAwareB.getFirstApplicationContext());
	}

	public void testLibraryProjectReferenceTo_bxargs() {
		assertNotNull(LibraryProject.hello());
	}

	public void testLoadFileDbRecordFromMySQL() {
		final StringBuffer path = new StringBuffer();
		
		DBUtil.dbExec(new DbOperation() {
			@Override
			public void run(EntityManager em) {
				Query jpqlQuery = Datasource___Sales_DB.EM.createQuery("SELECT u FrOM file_rec u WHERE u.id=(select min(x.id) from file_rec x)");  // :id
//			    jpqlQuery.setParameter("id", 446);
			    file_rec frMin =  (file_rec) jpqlQuery.getSingleResult();
				path.append(em.find(file_rec.class, frMin.getId()).getPath());
			}
		}, "SalesDB");
		assertTrue(path.toString().length() > 0);
	}

    public void testRepositoryWhenCreatingUser_thenCreated() {
        file_rec user = new file_rec();
        user.setPath("mypathpath!!!");
//        int id = 500000 + (int)(Math.random() * 10000);
//		user.setId(id);
        user = FileRecService.getRepository().save(user);
        int id = user.getId();
		System.out.println(id);

		Optional<file_rec> findById = FileRecService.getRepository().findById(id);
		System.out.println(findById);
        System.out.println(findById.get().getPath());
    }

	
}
