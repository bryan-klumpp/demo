package web.filerec;

import static org.junit.Assert.assertNull;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestComponent;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import junit.framework.TestCase;

//@RunWith(SpringRunner.class)
@SpringBootTest
@EnableTransactionManagement
//@TestComponent
public class JpaMultipleDBIntegrationTest extends TestCase {
 
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
    }

}