package web;

import java.io.PrintStream;

import org.springframework.boot.ExitCodeGenerator;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.ApplicationContext;

import junit.framework.TestSuite;
import junit.textui.ResultPrinter;
import junit.textui.TestRunner;
import web.filerec.file_rec;

// GO TO END for daily usage


//https://stackoverflow.com/questions/36663048/spring-boot-autowiring-repository-always-null
//@EnableAutoConfiguration
//  and more.....

//block below seems to fix Repository autowiring, suggested by https://stackoverflow.com/questions/41563779/how-to-autowire-spring-data-crudrepository
//@Configuration
//@ComponentScan(basePackages={"web", "web.filerec"}) 
//@EntityScan(basePackages={"web", "web.filerec"}) 
//@EnableJpaRepositories(basePackages={"web"}) 
//@EnableTransactionManagement

@ServletComponentScan
@SpringBootApplication
public class Main_sbw_SpringBootApplicationEmbeddedWebServer {

	public static void main(String[] args) {
		SpringApplication application = new SpringApplication(Main_sbw_SpringBootApplicationEmbeddedWebServer.class);
//		application.setWebApplicationType(WebApplicationType.NONE);
		ApplicationContext context = application.run(args);
//		SpringApplication.run(Main_sbw_SpringBootApplicationEmbeddedWebServer.class, args);

		try {
			doMain();

			System.out.println("doneeeee");
			// https://dzone.com/articles/spring-bean-lifecycle-using-spring-aware-interface
			// @Autowired ApplicationContext applicationContext and @Inject
			// ApplicationContext applicationContext are the newer mechanisms
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				Thread.sleep(0); //allow for JUnits maybe
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			appExit(context);
		}
	}

	private static void appExit(ApplicationContext context) {
		ApplicationContext context2 = ApplicationContextAwareB.getFirstApplicationContext();
		if(context != context2) {
			System.out.println("berror:asfdjeifj3f3ijf3if3ji");
		}
		SpringApplication.exit(context2, new ExitCodeGenerator() {
			@Override
			public int getExitCode() {
				return 0;
			}
		});
	}

	public static void runJUnits(PrintStream outPrintStream) {
		TestSuite s = new TestSuite();
		s.addTestSuite(ContainerTests4.class);

		TestRunner tr = new TestRunner();
		tr.setPrinter(new ResultPrinter(outPrintStream));

		tr.doRun(s);
	}

	private static void doMain() {
		runJUnits(System.out);
		
		
//			file_rec.ff_RefreshFileNameCache();
	}


}
