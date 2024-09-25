package com.okmindmap.dao.mysql.spring.mapper.sa;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.Node;
import com.okmindmap.util.EscapeUnicode;

public class SaNodeFileRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
		Node node = new Node();
		node.setId(rs.getInt("id")); 
		node.setText(rs.getString("content"));
		node.setFile(rs.getString("file"));
		return node;
	}

}
