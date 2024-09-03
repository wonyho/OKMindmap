package com.okmindmap.model.iot;

public class IotConnection {
	private int id;
	private IotDevices device;
	private IotSensor sensor;
	private String status;
	private String actions;
	private String value;
	private long lastUpdate;
	private long created;
	private String name;
	private String note;
	private String layout;
	private int layoutWidth;
	private int layoutHeight;
	
	public IotConnection() {
		// TODO Auto-generated constructor stub
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public IotDevices getDevice() {
		return device;
	}

	public void setDevice(IotDevices device) {
		this.device = device;
	}

	public IotSensor getSensor() {
		return sensor;
	}

	public void setSensor(IotSensor sensor) {
		this.sensor = sensor;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getActions() {
		return actions;
	}

	public void setActions(String actions) {
		this.actions = actions;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public long getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(long lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public long getCreated() {
		return created;
	}

	public void setCreated(long created) {
		this.created = created;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getLayout() {
		return layout;
	}

	public void setLayout(String layout) {
		this.layout = layout;
	}

	public int getLayoutWidth() {
		return layoutWidth;
	}

	public void setLayoutWidth(int layoutWidth) {
		this.layoutWidth = layoutWidth;
	}

	public int getLayoutHeight() {
		return layoutHeight;
	}

	public void setLayoutHeight(int layoutHeight) {
		this.layoutHeight = layoutHeight;
	}
	
	
}
