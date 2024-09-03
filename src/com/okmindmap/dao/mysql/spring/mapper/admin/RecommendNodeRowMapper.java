package com.okmindmap.dao.mysql.spring.mapper.admin;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.admin.RecommendNode;

public class RecommendNodeRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		RecommendNode recommendnode = new RecommendNode();
		
		recommendnode.setId(rs.getInt("id"));
		recommendnode.setViewcount(rs.getInt("viewcount"));
		recommendnode.setRcount(rs.getInt("rcount"));
		recommendnode.setNcount(rs.getInt("ncount"));
		
		return recommendnode;
	}

}