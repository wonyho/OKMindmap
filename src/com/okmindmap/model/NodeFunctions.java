package com.okmindmap.model;

import java.io.Serializable;

@SuppressWarnings("serial")
public class NodeFunctions implements Serializable{
	private int id;
	private String fieldname;
	public NodeFunctions() {
		
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	public String getFieldname() {
		return fieldname;
	}
	public void setFieldname(String fieldname) {
		this.fieldname = fieldname;
	}
}
