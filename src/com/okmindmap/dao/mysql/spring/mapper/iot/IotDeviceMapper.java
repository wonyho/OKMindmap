package com.okmindmap.dao.mysql.spring.mapper.iot;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.model.iot.IotModules;

public class IotDeviceMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		IotDevices de = new IotDevices();
		de.setId(rs.getInt("dev_id"));
		de.setName(rs.getString("dev_name"));
		de.setSecret(rs.getString("dev_secret"));
		de.setUserId(rs.getInt("dev_user"));
		de.setCreated(rs.getLong("dev_created"));
		IotModules md = new IotModules();
		md.setId(rs.getInt("module_id"));
		md.setName(rs.getString("module_name"));
		de.setModules(md);
		return de;
	}

}
