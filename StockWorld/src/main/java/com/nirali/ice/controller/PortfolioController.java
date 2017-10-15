package com.nirali.ice.controller;

import java.util.List;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.nirali.ice.DAO.CompanyDAO;
import com.nirali.ice.model.Company;

@RestController
public class PortfolioController {

	@RequestMapping(value = "/addToPortfolio", method = RequestMethod.GET)
	public String saveToPortfolio(@RequestParam(value = "name", required = false, defaultValue = "World") String name,
			@RequestParam(value = "symbol", required = false, defaultValue = "World") String symbol,
			@RequestParam(value = "ltp", required = false, defaultValue = "World") float ltp,
			@RequestParam(value = "noOfStocks", required = false, defaultValue = "") int noOfStocks) {
		System.out.println("in controller : " + noOfStocks);

		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
		CompanyDAO companyDAO = context.getBean(CompanyDAO.class);

		Company c = new Company();
		c.setName(name);
		c.setNumberOfStocks(noOfStocks);
		c.setSymbol(symbol);
		c.setLastTradedPrice(ltp);

		String message;
		List<Company> companyList = companyDAO.list();
		if (companyList.size() < 5) {
			boolean flag = true;
			for (Company company : companyList) {
				if (symbol.equals(company.getSymbol())) {
					flag = false;
					break;
				}
			}

			if (flag) {
				companyDAO.save(c);
				message = "{\"inserted\":\"yes\"}";
			} else {
				message = "{\"inserted\":\"no\"}";
			}
		} else {
			message = "{\"inserted\":\"more than 5\"}";
		}
		return message;
	}

	@RequestMapping(value = "/deleteFromPortfolio", method = RequestMethod.GET)
	public String deleteFromPortfolio(
			@RequestParam(value = "symbol", required = false, defaultValue = "World") String symbol) {
		System.out.println("in controller");

		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
		CompanyDAO companyDAO = context.getBean(CompanyDAO.class);

		Company c = new Company();
		String message;
		c.setSymbol(symbol);
		companyDAO.delete(c);
		message = "{\"deleted\":\"yes\"}";
		return message;
	}

	@RequestMapping(value = "/getPortfolio", method = RequestMethod.GET)
	public String showPortfolio() {
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
		CompanyDAO companyDAO = context.getBean(CompanyDAO.class);
		List<Company> companyList = companyDAO.list();
		String response = "";

		Gson gson = new Gson();
		String json = gson.toJson(companyList);
		System.out.println(json);

		return json;

	}
	
	@RequestMapping(value = "/simple.html", method = RequestMethod.GET)
	public ModelAndView simple() {
		
		ModelAndView mv = new ModelAndView("simple");
		
		return mv;
	
	}
	

}