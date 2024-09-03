package com.okmindmap.model.pricing;

import com.okmindmap.model.User;

public class Member {
	private int id;
	private Tier tier;
	private User user;
	private boolean status;
	private long created;
	private long expiryDate;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Tier getTier() {
		return tier;
	}
	public void setTier(Tier tier) {
		this.tier = tier;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public boolean getStatus() {
		return status;
	}
	public void setStatus(boolean status) {
		this.status = status;
	}
	public long getCreated() {
		return created;
	}
	public void setCreated(long created) {
		this.created = created;
	}
	public long getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(long expiryDate) {
		this.expiryDate = expiryDate;
	}
}
