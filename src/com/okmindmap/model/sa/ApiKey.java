package com.okmindmap.model.sa;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

public class ApiKey {
	private String key;
	private String created;
	private int today;
	private int thisMonth;
	private int total;
	private HashMap<String, Integer> counter;
	private HashMap<String, String> used;

	public ApiKey() {
		this.created = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		this.today = 0;
		this.total = 0;
		this.thisMonth = 0;
		this.counter = new HashMap<String, Integer>();
		this.used = new HashMap<String, String>();
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public int getToday() {
		return today;
	}
	public void setToday(int today) {
		this.today = today;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public int getThisMonth() {
		return thisMonth;
	}
	public void setThisMonth(int thisMonth) {
		this.thisMonth = thisMonth;
	}
	public void setCounter(String key, int val) {
		this.counter.put(key, val);
	}
	public int getCounter(String key) {
		return this.counter.get(key);
	}
	public void increaCounter(String key) {
		this.counter.put(key, this.getCounter(key) + 1);
	}
	public void setLastUsed(String key, String val) {
		this.used.put(key, val);
	}
	public String getLastUsed(String key) {
		return this.used.get(key);
	}
}
