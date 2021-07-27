package web;

import javax.servlet.ServletContext;

import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

/**
 * @author Bryan Klumpp
 * 
 * I am going insane trying to get thymeleaf to transfer from gs-serving-web-content (from git load instructions at spring.io examples/tutorials) to this project.  This class is based on https://www.baeldung.com/spring-xml-vs-java-config
 *
 */
public class ManualJava_MyWebAppInitializer {
//    @Override
//    public void onStartup(ServletContext container) {
//        AnnotationConfigWebApplicationContext context
//          = new AnnotationConfigWebApplicationContext();
//        context.setConfigLocation("com.example.app.config");
//
//        container.addListener(new ContextLoaderListener(context));
//
//        ServletRegistration.Dynamic dispatcher = container
//          .addServlet("dispatcher", new DispatcherServlet(context));
//        
//        dispatcher.setLoadOnStartup(1);
//        dispatcher.addMapping("/");
//    }
}