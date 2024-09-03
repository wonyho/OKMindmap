package com.okmindmap.service;

import java.util.List;

import com.okmindmap.model.Setting;

public interface OKMindmapService {
	public String getSetting(String key);
	public List<Setting> getSettings();
	public int updateSetting(String key, String value);
}
