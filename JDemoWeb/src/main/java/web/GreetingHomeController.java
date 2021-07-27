package web;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Handles requests for the application home page.
 */
@Controller
public class GreetingHomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(GreetingHomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/greeting", method = RequestMethod.GET)
	public String home(@RequestParam(name="name", required=false, defaultValue="World")String name, Locale locale, Model model) {
		System.out.println("Hit homecontroller");
		try {
			CustomerDemo.demoCustomer();
			logger.info("Welcome home! The client locale is {}.", locale);
			
			Date date = new Date();
			DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
			
			String formattedDate = dateFormat.format(date);
			
			model.addAttribute("serverTime", formattedDate );

			model.addAttribute("name",name);

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
	
}
