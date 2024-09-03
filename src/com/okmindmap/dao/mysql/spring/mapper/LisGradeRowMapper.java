package com.okmindmap.dao.mysql.spring.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.model.LisGrade;

public class LisGradeRowMapper extends RowMapperBase implements RowMapper{

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		LisGrade lis = new LisGrade();
		
		lis.setId(rs.getInt("id"));
		lis.setLisResultSourcedid(rs.getString("lis_result_sourcedid"));
		lis.setUserid(rs.getInt("userid"));
		lis.setMapid(rs.getInt("mapid"));
		lis.setNodeid(rs.getInt("nodeid"));
		lis.setScore(rs.getDouble("score"));
		lis.setTime(rs.getLong("ts"));
		return lis;
	}

}
