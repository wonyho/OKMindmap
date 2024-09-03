package com.okmindmap.dao.mysql.spring.mapper.iot;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.iot.IotSensor;

public class IotSensorMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		IotSensor is = new IotSensor();
		is.setId(rs.getInt("sensor_id"));
		is.setName(rs.getString("sensor_name"));
		is.setGroupId(rs.getInt("groupid"));
		is.setLayout(rs.getString("default_layout"));
		is.setLayoutH(rs.getInt("default_h"));
		is.setLayoutW(rs.getInt("default_w"));
		return is;
	}

}
