package web.greeting;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

//@Controller //conflicts with HomeController
public class greeeeeting2_GreetingController {

	@RequestMapping(value = "/greeting2", method = RequestMethod.GET)
	public String greeting(@RequestParam(name="name", required=false, defaultValue="World") String name, Model model) {
		System.out.println("Hit GreetingController");
		model.addAttribute("name", name);
		return "greetingconflict";
	}

}
