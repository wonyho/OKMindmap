package com.okmindmap.dao;

import com.okmindmap.model.LtiProvider;

public interface LtiProviderDAO {
	
	public boolean insertLtiProvider(LtiProvider lti);
	
	public boolean deleteLtiProvider(long id);
	
	public boolean deleteLtiProvider(String url);
	
	public LtiProvider getLtiProvider(long id);
	
	public LtiProvider getLtiProvider(String url);
}
