package com.nirali.ice.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="Portfolio")

public class Company {
	
	private String name;
	
	@Id
	private String symbol;
	
	private float lastTradedPrice;
	
	private int numberOfStocks;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public float getLastTradedPrice() {
		return lastTradedPrice;
	}
	public void setLastTradedPrice(float lastTradedPrice) {
		this.lastTradedPrice = lastTradedPrice;
	}
	public int getNumberOfStocks() {
		return numberOfStocks;
	}
	public void setNumberOfStocks(int numberOfStocks) {
		this.numberOfStocks = numberOfStocks;
	}
	
}
