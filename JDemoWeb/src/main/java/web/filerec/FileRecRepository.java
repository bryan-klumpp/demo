package web.filerec;

import java.util.List;

import org.springframework.context.annotation.PropertySource;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

//Spring wiring error 2021-06-04 17:38:22.327  INFO 13692 --- [main] .RepositoryConfigurationExtensionSupport : Spring Data JDBC - Could not safely identify store assignment for repository candidate interface web.RepositoryFileRec. If you want this repository to be a JDBC repository, consider annotating your entities with one of these annotations: org.springframework.data.relational.core.mapping.Table.


/**
 * @author Bryan Klumpp
 * 
 * expand as per https://www.appsdeveloperblog.com/spring-data-jpa-native-update-sql-query/
 *
 */
//@Configuration
//@EnableAutoConfiguration
//@ComponentScan({"web"})
//@EntityScan(basePackages = {"web"})
//@EnableJpaRepositories(basePackages = {"web"})
//@EnableTransactionManagement
//
//@Service


//-Spring I ran into this bug https://stackoverflow.com/questions/58912292/nosuchbeandefinitionexception-after-update-to-spring-boot-2-2-1
//@Component
//@ManagedBean //this did seem to take away the webapp startup error that said need to create a fileRecRepository bean
//@Table(name="file_rec")
//@org.springframework.data.relational.core.mapping.Table("file_rec")

//@Table(value = "file_rec")//howto good overview of Autowire and troubleshootinghttps://technology.amis.nl/languages/java-ee-2/java-how-to-fix-spring-autowired-annotation-not-working-issues/ and manually invoking autowire
//howto so annoying only allow single annotation https://stackoverflow.com/questions/53203051/redis-consider-renaming-one-of-the-beans-or-enabling-overriding-by-setting-spr
//TODO follow this guide to fix issues frustrating https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.repositories
@Repository
//@PropertySource({ "classpath:META-INF/persistence.xml" })
public interface FileRecRepository extends CrudRepository<file_rec, Integer> {


////	@Transactional   //use Spring or core JPA package??
//    @Modifying
//    @Query(value = "delete from FileRec")
//	@Override
//	default void deleteAll() {
//		// TODO Auto-generated method stub
//		
//	}
	

}
