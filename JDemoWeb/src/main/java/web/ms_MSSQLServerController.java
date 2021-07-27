package web;

import javax.persistence.EntityManager;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ms_MSSQLServerController {

	@RequestMapping(value = "/ms", method = RequestMethod.GET)
	public String root(@RequestParam(name="name", required=false, defaultValue="World")String name, Model model) {
//		model.addAttribute("mytrace","mock stacktrace\nendlinen\r\nendlinern");
//		model.addAttribute("myexception","WhoopsieException");
		System.out.println("entering "+getClass().getName());
		model.addAttribute("name", "yikes");
		
		Runnable lambda1 = () -> {
			DBUtil.dbExec((em2) -> {
				em2.find(Customer.class, 1L); 
				model.addAttribute("myhtml", "it worked!");
			}, "msloc");
		};
		return ExceptionUtil.doWithSpecialTraceLoggingAndExceptionHandling("msloc", model.asMap(), lambda1);
	}
	private String rootNoLambda(@RequestParam(name="name", required=false, defaultValue="World")String name, Model model) {
//		model.addAttribute("mytrace","mock stacktrace\nendlinen\r\nendlinern");
//		model.addAttribute("myexception","WhoopsieException");
		model.addAttribute("name","just a hello: ");
		return web.ExceptionUtil.doWithSpecialTraceLoggingAndExceptionHandling("msloc", model.asMap(), new Runnable() {
			@Override
			public void run() {
				DBUtil.dbExec(new DbOperation() {
					@Override
					public void run(EntityManager em) {
						em.find(Customer.class, "1"); //yeah yeah wrong database for entity, just seeing if I can get a conneaction
						model.addAttribute("myhtml","it worked!");
					}
				}, "msloc");
			}
		});
	}

}
