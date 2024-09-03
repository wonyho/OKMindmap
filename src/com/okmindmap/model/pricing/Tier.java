package com.okmindmap.model.pricing;

import java.io.Serializable;

@SuppressWarnings("serial")
public class Tier implements Serializable {
	private int id;
	private String name;
	private String summary;
	private int sortorder = 0;
	private boolean activated;
	private long created;
	private long modified;
	
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
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	public boolean getActivated() {
		return activated;
	}
	public void setActivated(boolean activated) {
		this.activated = activated;
	}
	public long getCreated() {
		return created;
	}
	public void setCreated(long created) {
		this.created = created;
	}
	public long getModified() {
		return modified;
	}
	public void setModified(long modified) {
		this.modified = modified;
	}
	public int getSortorder() {
		return sortorder;
	}
	public void setSortorder(int sortorder) {
		this.sortorder = sortorder;
	}
}
