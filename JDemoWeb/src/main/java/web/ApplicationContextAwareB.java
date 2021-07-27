package web;

import javax.annotation.ManagedBean;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

@ManagedBean
public class ApplicationContextAwareB implements ApplicationContextAware {
	
	private static ApplicationContext firstApplicationContext = null;

//	@Autowired
//	public ApplicationContextAwareB(ApplicationContext applicationContext) {
//		System.out.println("constructorApplicationContext"+applicationContext);
//		ApplicationContextAwareB.firstApplicationContext = applicationContext;
//	}

	public static ApplicationContext getFirstApplicationContext() {
		return firstApplicationContext;
	}

	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		System.out.println("setterApplicationContext: "+applicationContext);
		ApplicationContextAwareB.firstApplicationContext = applicationContext;
	}

}
