package com.nirali.ice.DAO;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;

import com.nirali.ice.model.Company;

public class CompanyDAO {
	
	private SessionFactory sessionFactory;
	
	public void save(Company c){
		Session session = this.getSessionFactory().openSession();
		Transaction tx = session.beginTransaction(); 
		session.persist(c);
		tx.commit();
		session.close();
	}
	
	public void delete(Company c){
		Session session = this.getSessionFactory().openSession();
		Transaction tx = session.beginTransaction(); 
		session.delete(c);
		tx.commit();
		session.close();
	}

	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}
	
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	public List<Company> list() {
		Session session = this.sessionFactory.openSession();
		List<Company> companyList = session.createQuery("from Company").list();
		session.close();
		return companyList;
	}
	
	
	
	
	

}