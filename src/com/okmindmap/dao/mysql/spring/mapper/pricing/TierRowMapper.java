package com.okmindmap.dao.mysql.spring.mapper.pricing;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.pricing.Tier;

public class TierRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		Tier tier = new Tier();
		
		tier.setId(rs.getInt("id"));
		tier.setName(rs.getString("name"));
		tier.setSummary(rs.getString("summary"));
		tier.setSortorder(rs.getInt("sortorder"));
		tier.setActivated(rs.getInt("activated") == 1);
		tier.setCreated(rs.getLong("created"));
		tier.setModified(rs.getLong("modified"));
		
		return tier;
	}

}
