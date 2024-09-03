package com.okmindmap.dao.mysql.spring.mapper.pricing;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.User;
import com.okmindmap.model.pricing.Member;
import com.okmindmap.model.pricing.Tier;

public class MemberRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		Member member = new Member();
		
		member.setId(rs.getInt("id"));
		
		Tier tier = new Tier();
		tier.setId(rs.getInt("tierid"));
		tier.setName(rs.getString("tier_name"));
		tier.setSummary(rs.getString("tier_summary"));
		tier.setActivated(rs.getInt("tier_activated") == 1);
		member.setTier(tier);
		
		User user = new User();
		user.setId(rs.getInt("userid"));
		user.setUsername(rs.getString("username"));
		user.setFirstname(rs.getString("firstname"));
		user.setLastname(rs.getString("lastname"));
		user.setEmail(rs.getString("email"));
		member.setUser(user);
		
		member.setStatus(rs.getInt("status") == 1);
		member.setCreated(rs.getLong("created"));
		member.setExpiryDate(rs.getLong("expiry_date"));
		
		return member;
	}

}
