package com.okmindmap.service.impl;

import java.util.List;

//import org.apache.log4j.Logger; // wait for the upgrade to log4j 2.15.0

import com.okmindmap.dao.OKMindmapDAO;
import com.okmindmap.model.Setting;
import com.okmindmap.service.OKMindmapService;


public class OKMindmapServiceImpl implements OKMindmapService{
	OKMindmapDAO okmindmapDAO;
	
//	Logger logger = Logger.getLogger(OKMindmapServiceImpl.class); // wait for the upgrade to log4j 2.15.0
	
	public OKMindmapDAO getOkmindmapDAO() {
		return okmindmapDAO;
	}

	public void setOkmindmapDAO(OKMindmapDAO okmindmapDAO) {
		this.okmindmapDAO = okmindmapDAO;
	}


	@Override
	public String getSetting(String key) {		
		String nodeUrl = this.okmindmapDAO.getSetting(key);
		
		return nodeUrl;
	}

	@Override
	public List<Setting> getSettings() {
		return this.okmindmapDAO.getSettings();
	}

	@Override
	public int updateSetting(String key, String value) {
		return this.okmindmapDAO.updateSetting(key, value);
	}
}
