package web;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.AbstractApplicationContext;

@Configuration
public class SingletonBeanExampleTest {
	
	private static String NAME = "asdf";
	
	@Test
	public void testGiven1() {
		System.out.println("Im here!!!!!!!!");
		ApplicationContext context = new AnnotationConfigApplicationContext(SingletonBeanExample.class,SingletonBeanExampleTest.class);
		SingletonBeanExample SingletonBeanExampleSingletonA = (SingletonBeanExample) context
				.getBean("singletonBeanExampleSingleton");
		SingletonBeanExample SingletonBeanExampleSingletonB = (SingletonBeanExample) context
				.getBean("singletonBeanExampleSingleton");
		SingletonBeanExampleSingletonA.setX(NAME);
		Assert.assertEquals(NAME, SingletonBeanExampleSingletonB.getX());
		((AbstractApplicationContext) context).close();
	}
}
