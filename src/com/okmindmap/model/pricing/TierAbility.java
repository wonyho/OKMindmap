package com.okmindmap.model.pricing;

public class TierAbility {
	private int id;
	private Tier tier;
	private String policyKey;
	private String value;
	private boolean activated;
	private long created;
	private long modified;
	
	
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
	public String getPolicyKey() {
		return policyKey;
	}
	public void setPolicyKey(String policyKey) {
		this.policyKey = policyKey;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
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
	
}
