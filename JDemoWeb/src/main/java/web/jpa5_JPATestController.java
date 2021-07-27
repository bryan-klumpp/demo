package web;

import java.util.Locale;

import javax.persistence.EntityManager;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bryanklumpp.demo.LibraryProject;
import web.filerec.file_rec;

//@EnableAutoConfiguration
//@ComponentScan(basePackages = { "web", "weblib" })
@Controller
public class jpa5_JPATestController {

	@RequestMapping(value = "/jpa5", method = RequestMethod.GET)
	public String root(@RequestParam(name="name", required=false, defaultValue="World")String name, Locale locale, Model model) {
//		System.out.println("Hit GreetingController");
		
		final StringBuffer path = new StringBuffer();
		DBUtil.dbExec(new DbOperation() {
			@Override
			public void run(EntityManager em) {
				path.append(em.find(file_rec.class, 1340669552).getPath());
			}
		}, "SalesDB");
		model.addAttribute("name", LibraryProject.hello()+"from db: "+ CustomerDemo.demoCustomer().getName()+" - file_rec path: "+path);
		return "greeting";
	}

}
