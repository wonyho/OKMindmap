package com.okmindmap.dao.mysql.spring.mapper.iot;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.iot.IotModules;

public class IotModuleMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		IotModules md = new IotModules();
		md.setId(rs.getInt("module_id"));
		md.setName(rs.getString("module_name"));
		return md;
	}

}
