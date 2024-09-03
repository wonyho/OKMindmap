package com.okmindmap.dao.mysql.spring.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.model.Setting;

public class SettingRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		
		Setting setting = new Setting();
		
		setting.setId(rs.getInt("id"));
		setting.setKey(rs.getString("setting_key"));
		setting.setValue(rs.getString("setting_value"));
		
		return setting;
	}

}
