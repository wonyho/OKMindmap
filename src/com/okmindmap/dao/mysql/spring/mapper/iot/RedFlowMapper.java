package com.okmindmap.dao.mysql.spring.mapper.iot;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.iot.RedFlow;

public class RedFlowMapper extends RowMapperBase implements RowMapper {
	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		RedFlow rf = new RedFlow();
		
		rf.setId(rs.getLong("id"));
		rf.setUsername(rs.getString("username"));
		rf.setUserId(rs.getLong("user_id"));
		rf.setFlowId(rs.getString("flow_id"));
		rf.setFlowName(rs.getString("flow_name"));
		rf.setCreated(rs.getLong("created"));
		rf.setEdited(rs.getLong("edited"));
		rf.setMacAddress(rs.getString("connected"));
		
		return rf;
	}
}
