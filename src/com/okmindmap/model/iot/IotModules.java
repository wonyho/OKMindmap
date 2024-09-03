package com.okmindmap.model.iot;

public class IotModules {
	private int id;
	private String name;
	public IotModules() {
		// TODO Auto-generated constructor stub
	}
	
	public IotModules(int id) {
		super();
		this.id = id;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
}
