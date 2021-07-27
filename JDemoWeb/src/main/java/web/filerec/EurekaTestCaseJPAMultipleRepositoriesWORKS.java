package web.filerec;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

//@SpringBootTest
//@EnableTransactionManagement

public class EurekaTestCaseJPAMultipleRepositoriesWORKS {

	@Test
	void test() {
//		fail("Not yet implemented");
	}
    @Autowired
    private FileRecRepository userRepository;

    public void testHello() {}
    
    
    @Test
    @Transactional("userTransactionManager")
    public void testWhenCreatingUser_thenCreated() {
        file_rec user = new file_rec();
        user.setPath("mypathpath!!!");
        user.setId(500000 + (int)(Math.random() * 10000));
        user = userRepository.save(user);

        assertNotNull(userRepository.findById(user.getId()));
        
        assertTrue(userRepository.findById(92).get().getPath().contains("big_files"));
    }

}
