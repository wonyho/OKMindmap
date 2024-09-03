package com.okmindmap.dao.mysql.spring.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.model.Repository;


public class RepositoryRowMapper extends RowMapperBase implements RowMapper {

	@Override
	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		Repository data = new Repository();
		
		data.setId(rs.getInt("id"));
		data.setMapID(rs.getInt("mapid"));
		data.setUserID(rs.getInt("userid"));
		data.setFileName(rs.getString("filename"));
		String path = rs.getString("path");
		if(path != null )
        path = path.replace("/usr/local/Tomcat/webapps/okmindmap_upload", "/home/tubestory/upload");
        data.setPath(path);
		data.setContentType(rs.getString("mime"));
		data.setFileSize(rs.getInt("filesize"));
		
		return data;
	}

}