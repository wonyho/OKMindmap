package com.okmindmap.model.sa;

public class OkmCloud {
	private String url;
	private String app;
	private String user;
	private String key;
	private String token;
	public OkmCloud() {

	}
	
	public OkmCloud(String url, String app, String user, String key, String token) {
		this.url = url;
		this.app = app;
		this.user = user;
		this.key = key;
		this.token = token;
	}

	public String getApp() {
		return app;
	}
	public void setApp(String app) {
		this.app = app;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	
	
}
