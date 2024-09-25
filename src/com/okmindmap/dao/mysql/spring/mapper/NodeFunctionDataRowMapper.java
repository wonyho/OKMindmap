package com.okmindmap.dao.mysql.spring.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.model.NodeFunctions;

public class NodeFunctionDataRowMapper extends RowMapperBase implements RowMapper {
	@Override
	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		NodeFunctions data = new NodeFunctions();
		
		data.setId(rs.getInt("id"));
		data.setFieldname(rs.getString("field"));
		
		return data;
	}
}
