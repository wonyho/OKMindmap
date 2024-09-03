package com.okmindmap.dao.mysql.spring;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.okmindmap.dao.OKMindmapDAO;
import com.okmindmap.dao.mysql.spring.mapper.SettingRowMapper;
import com.okmindmap.model.Setting;

 

public class SpringOKMindmapDAO extends SpringDAOBase implements OKMindmapDAO {

	@Override
	public String getSetting(String key) throws DataAccessException {
		String sql = "SELECT * FROM mm_okm_setting WHERE setting_key = ?";
		
		Setting setting = (Setting)getJdbcTemplate().queryForObject(sql, new Object[] {key}, new SettingRowMapper());
		
		if(setting != null) {
			return setting.getValue();
		}
		
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Setting> getSettings() throws DataAccessException {
		String query = "SELECT * FROM mm_okm_setting";
		
		return getJdbcTemplate().query(query, new SettingRowMapper());
	}

	@Override
	public int updateSetting(String key, String value) throws DataAccessException {
		String sql = "UPDATE mm_okm_setting SET setting_value = ?"
				+ " WHERE setting_key = ?";
		
		return getJdbcTemplate().update(sql, new Object[] { value, key });
	}

}
