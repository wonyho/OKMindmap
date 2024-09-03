package com.okmindmap.service.impl;

import java.util.ArrayList;
import java.util.Map;

import com.okmindmap.dao.RestrictDAO;
import com.okmindmap.service.RestrictService;

public class RestrictServiceImpl implements RestrictService{

	private RestrictDAO restrictDAO;
	
	public RestrictDAO getRestrictDAO() {
		return restrictDAO;
	}

	public void setRestrictDAO(RestrictDAO restrictDAO) {
		this.restrictDAO = restrictDAO;
	}

	@Override
	@SuppressWarnings("rawtypes")	
	public Map executeSelectQuery(String sql, ArrayList<Object> params) {
		return this.restrictDAO.executeSelectQuery(sql, params);
	}

}
