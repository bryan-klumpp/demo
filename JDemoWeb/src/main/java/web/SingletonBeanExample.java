package web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

@Configuration
public class SingletonBeanExample {
	private String x;
	public String getX() {
		return x;
	}
	public void setX(String x) {
		this.x = x;
	}
	@Bean
	@Scope(value=ConfigurableBeanFactory.SCOPE_SINGLETON)
	public SingletonBeanExample singletonBeanExampleSingleton() {
		return new SingletonBeanExample();
	}
}
