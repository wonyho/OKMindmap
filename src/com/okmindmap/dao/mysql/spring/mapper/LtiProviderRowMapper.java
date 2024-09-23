package com.okmindmap.dao.mysql.spring.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.model.LtiProvider;

public class LtiProviderRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		LtiProvider lti = new LtiProvider();
		
		lti.setId(rs.getLong("id"));
		lti.setSecret(rs.getString("secret"));
		lti.setContextId(rs.getString("contextId"));
		lti.setInstanceGuid(rs.getString("instanceGuid"));
		lti.setMessageType(rs.getString("messageType"));
		lti.setResourceLinkId(rs.getString("resourceLinkId"));
		lti.setResourseType(rs.getString("resourseType"));
		lti.setResourseAttrs(rs.getString("resourseAttrs"));
		lti.setReturnUrl(rs.getString("returnUrl"));
		lti.setVersion(rs.getString("version"));
		lti.setCreated(rs.getLong("created"));
		
		return lti;
	}

}
