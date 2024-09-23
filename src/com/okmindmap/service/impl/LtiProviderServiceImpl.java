package com.okmindmap.service.impl;

import com.okmindmap.dao.LtiProviderDAO;
import com.okmindmap.model.LtiProvider;
import com.okmindmap.service.LtiProviderService;

public class LtiProviderServiceImpl implements LtiProviderService {

	private LtiProviderDAO ltiProviderDAO;

	public void setLtiProviderDAO(LtiProviderDAO ltiProviderDAO) {
		this.ltiProviderDAO = ltiProviderDAO;
	}

	public boolean insertLtiProvider(LtiProvider lti) {
		return this.ltiProviderDAO.insertLtiProvider(lti);
	}
	
	public boolean deleteLtiProvider(long id) {
		return this.ltiProviderDAO.deleteLtiProvider(id);
	}
	
	public boolean deleteLtiProvider(String url) {
		return this.ltiProviderDAO.deleteLtiProvider(url);
	}
	
	public LtiProvider getLtiProvider(long id) {
		return this.ltiProviderDAO.getLtiProvider(id);
	}
	
	public LtiProvider getLtiProvider(String url) {
		return this.ltiProviderDAO.getLtiProvider(url);
	}
	
}
