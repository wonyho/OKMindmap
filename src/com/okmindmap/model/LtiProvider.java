package com.okmindmap.model;

public class LtiProvider {

	private long id;
	private String secret;
	private String contextId;
	private String resourseType;
	private String resourseAttrs;
	private String returnUrl;
	private String messageType;
	private String resourceLinkId;
	private String instanceGuid;
	private String version;
	private long created;
	
	public LtiProvider() {
		// TODO Auto-generated constructor stub
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getSecret() {
		return secret;
	}

	public void setSecret(String secret) {
		this.secret = secret;
	}
	

	public String getResourseType() {
		return resourseType;
	}

	public void setResourseType(String resourseType) {
		this.resourseType = resourseType;
	}

	public String getResourseAttrs() {
		return resourseAttrs;
	}

	public void setResourseAttrs(String resourseAttrs) {
		this.resourseAttrs = resourseAttrs;
	}

	public String getContextId() {
		return contextId;
	}

	public void setContextId(String contextId) {
		this.contextId = contextId;
	}

	public String getReturnUrl() {
		return returnUrl;
	}

	public void setReturnUrl(String returnUrl) {
		this.returnUrl = returnUrl;
	}

	public String getMessageType() {
		return messageType;
	}

	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}

	public String getResourceLinkId() {
		return resourceLinkId;
	}

	public void setResourceLinkId(String resourceLinkId) {
		this.resourceLinkId = resourceLinkId;
	}

	public String getInstanceGuid() {
		return instanceGuid;
	}

	public void setInstanceGuid(String instanceGuid) {
		this.instanceGuid = instanceGuid;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public long getCreated() {
		return created;
	}

	public void setCreated(long created) {
		this.created = created;
	}
	
	

}
