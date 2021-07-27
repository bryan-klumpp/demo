package web;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * @author Bryan Klumpp
 * 
 * https://www.baeldung.com/transaction-configuration-with-jpa-and-spring
 *
 */
//@Configuration
//@EnableTransactionManagement
public class ManualJava_PersistenceJPAConfig{

//   @Bean
//   public LocalContainerEntityManagerFactoryBean
//     entityManagerFactoryBean(){
//      //...
//   }
//
//   @Bean
//   public PlatformTransactionManager transactionManager(){
//      JpaTransactionManager transactionManager
//        = new JpaTransactionManager();
//      transactionManager.setEntityManagerFactory(
//        entityManagerFactoryBean().getObject() );
//      return transactionManager;
//   }
}