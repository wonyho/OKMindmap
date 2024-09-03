package com.okmindmap.model.iot;

public class IotSensor {
	private int id;
	private String name;
	private int groupId;
	private String layout;
	private int layoutW;
	private int layoutH;
	
	public IotSensor() {
		// TODO Auto-generated constructor stub
	}
	
	public IotSensor(int id) {
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

	public int getGroupId() {
		return groupId;
	}

	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}

	public String getLayout() {
		return layout;
	}

	public void setLayout(String layout) {
		this.layout = layout;
	}

	public int getLayoutW() {
		return layoutW;
	}

	public void setLayoutW(int layoutW) {
		this.layoutW = layoutW;
	}

	public int getLayoutH() {
		return layoutH;
	}

	public void setLayoutH(int layoutH) {
		this.layoutH = layoutH;
	}
	
	
}
