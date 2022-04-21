package web.greeting;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import web.CustomerDemo;

/**
 * Handles requests for the application home page.
 */
@Controller
public class GreetingHomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(GreetingHomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@GetMapping("/greeting")
	public String home(@RequestParam(name="name", required=false, defaultValue="Wooorld")String name, Locale locale, Model model) {
		System.out.println("Hit homecontroller");
		try {
			CustomerDemo.demoCustomer();
			logger.info("Welcome home! The client locale is {}.", locale);
			
			Date date = new Date();
			DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
			
			String formattedDate = dateFormat.format(date);
			
			model.addAttribute("serverTime", formattedDate );

			model.addAttribute("name",name);
			
			model.addAttribute(new Greeting());

			return "greeting";
		} catch (Exception e) {
			StringWriter sw = new StringWriter();
			e.printStackTrace();
			e.printStackTrace(new PrintWriter(sw));
			model.addAttribute("exception", sw.toString().replaceAll("\r?\n", "<br/>"));
			System.err.println(sw.toString());
			return "error";
		}
	}
	@PostMapping("/greeting")
	  public String greetingSubmit(@ModelAttribute Greeting greeting, Model model) {
	    model.addAttribute("greeting", greeting);
	    return "result";
	  }
	
	
}
