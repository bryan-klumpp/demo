package web.filerec;

import javax.annotation.ManagedBean;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

//howto https://learningprogramming.net/java/spring-boot-jpa/create-new-entity-with-crudrepository-interface-in-spring-boot-jpa/ may also be helpful to get this autowiring working
//@Configuration
//@EnableAutoConfiguration
//@ComponentScan({"web"})
//@EntityScan(basePackages = {"web"})
//@EnableJpaRepositories(basePackages = {"web"})
//@EnableTransactionManagement
//

//howto different types of class-level annotation https://www.baeldung.com/spring-bean-annotations

@Component
@Service
@ManagedBean
//@PropertySource({ "classpath:META-INF/persistence.xml" })
public class FileRecService {
	
	//to debug this also try steps maybe transactionmanager not enabled for SalesDB as it is for default which is hitting autowired constructor: https://stackoverflow.com/questions/15949565/spring-jpa-repository-autowire-issue
//	 @Autowired  //trace logs say this so why is it null? 2021-06-05 12:27:16.263 DEBUG 18700 --- [main] o.s.b.f.s.DefaultListableBeanFactory     : Autowiring by type from bean name 'fileRecService' via constructor to bean named 'fileRecRepository'
	 private static FileRecRepository fileRecRepository;  //for more help on autowiring howto see https://stackoverflow.com/questions/36663048/spring-boot-autowiring-repository-always-null
	 
//	 public List<FileRec> findPeople(FileRec probe) {
//		    return ListUtil.getList(fileRecRepository.findAll());
//		 }

//		public UserService() {
//			System.out.println("FileRecService constructor hit");
//			new RuntimeException().printStackTrace();
////			JpaRepositoryFactoryBean<FileRecRepository, FileRec, Integer> myFactBean = new JpaRepositoryFactoryBean<FileRecRepository, FileRec, Integer>(FileRecRepository.class);
////			JpaRepositoryFactory myFact = new jparep
////			myFact.
//		}

	 public static FileRecRepository getRepository() {
		 return fileRecRepository;
	 }
	 
		@Autowired
		public FileRecService(FileRecRepository fileRecRepository) {
			System.out.println("FileRecService parameterized constructor hit: "+fileRecRepository);
			FileRecService.fileRecRepository = fileRecRepository; //kludgy but autowiring on the field itself wasn't working for whatever reason so using constructor
//			JpaRepositoryFactoryBean<FileRecRepository, FileRec, Integer> myFactBean = new JpaRepositoryFactoryBean<FileRecRepository, FileRec, Integer>(FileRecRepository.class);
//			JpaRepositoryFactory myFact = new jparep
//			myFact.
		}
	
	public FileRecRepository getFileRecRepository() {
		return fileRecRepository;
	}
	
//	@Bean
//	@Primary
//	  public UserRepository fileRecRepository(UserRepository repository) {
//		System.out.println("in bean: "+repository);
//		this.fileRecRepository = repository;
//		return repository;
//
//	}
	 

//	public static UserService getInstance() {
//		if(instance == null) {
//			instance = new UserService();
//		}
//		return instance;
//	}

	public void setFileRecRepository(FileRecRepository Repository) {
		System.out.println("setFileRecRepository hit");
		this.fileRecRepository = Repository;
	}
	
}
