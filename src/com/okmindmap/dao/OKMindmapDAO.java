package com.okmindmap.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.okmindmap.model.Setting;



public interface OKMindmapDAO {
	public String getSetting(String key) throws DataAccessException;
	public List<Setting> getSettings() throws DataAccessException;
	public int updateSetting(String key, String value) throws DataAccessException;
}
