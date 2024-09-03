package com.okmindmap.dao.mysql.spring.mapper.iot;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.model.iot.IotModules;
import com.okmindmap.model.iot.IotSensor;

public class IotConnectionMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		IotSensor is = new IotSensor();
		is.setId(rs.getInt("sensor_id"));
		is.setName(rs.getString("sensor_name"));
		is.setGroupId(rs.getInt("groupid"));
		is.setLayout(rs.getString("default_layout"));
		is.setLayoutH(rs.getInt("default_h"));
		is.setLayoutW(rs.getInt("default_w"));
		IotDevices de = new IotDevices();
		de.setId(rs.getInt("dev_id"));
		de.setName(rs.getString("dev_name"));
		de.setSecret(rs.getString("dev_secret"));
		de.setUserId(rs.getInt("dev_user"));
		de.setCreated(rs.getLong("dev_created"));
		IotConnection ic = new IotConnection();
		ic.setActions(rs.getString("actions"));
		ic.setCreated(rs.getLong("created"));
		ic.setDevice(de);
		ic.setId(rs.getInt("id"));
		ic.setLastUpdate(rs.getLong("last_update"));
		ic.setSensor(is);
		ic.setStatus(rs.getString("status"));
		ic.setValue(rs.getString("value"));
		ic.setName(rs.getString("name"));
		ic.setNote(rs.getString("note"));
		ic.setLayout(rs.getString("layout"));
		ic.setLayoutHeight(rs.getInt("layout_h"));
		ic.setLayoutWidth(rs.getInt("layout_w"));
		
		return ic;
	}

}
