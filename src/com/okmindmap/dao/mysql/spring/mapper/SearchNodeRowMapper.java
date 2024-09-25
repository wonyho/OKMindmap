package com.okmindmap.dao.mysql.spring.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.model.Node;
import com.okmindmap.util.EscapeUnicode;

public class SearchNodeRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
		Node node = new Node();
		node.setId(rs.getInt("id")); 
		node.setFolded(rs.getString("folded"));
		node.setIdentity(rs.getString("identity"));
		node.setMapId(rs.getInt("map_id"));

		
		return node;
	}

}
