package web;

import javax.persistence.EntityManager;

import org.springframework.ui.Model;

public interface DbOperation {
	void run(EntityManager em);
}