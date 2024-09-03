package com.okmindmap.model.iot;

public class IotDevices {
	private int id;
	private IotModules modules;
	private int userId;
	private String name;
	private String secret;
	private long created;
	public IotDevices() {
		// TODO Auto-generated constructor stub
	}
	
	public IotDevices(int id) {
		super();
		this.id = id;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public IotModules getModules() {
		return modules;
	}
	public void setModules(IotModules modules) {
		this.modules = modules;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSecret() {
		return secret;
	}
	public void setSecret(String secret) {
		this.secret = secret;
	}
	public long getCreated() {
		return created;
	}
	public void setCreated(long created) {
		this.created = created;
	}
	
}
