package web;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

import web.greeting.greeeeeting2_GreetingController;

@ServletComponentScan
public class ComponentScanSpringRegistrationComponentScanServletInitializer extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(ComponentScanSpringRegistration.class, greeeeeting2_GreetingController.class);
	}

}
