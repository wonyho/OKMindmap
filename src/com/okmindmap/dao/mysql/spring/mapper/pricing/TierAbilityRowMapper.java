package com.okmindmap.dao.mysql.spring.mapper.pricing;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.dao.mysql.spring.mapper.RowMapperBase;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;

public class TierAbilityRowMapper extends RowMapperBase implements RowMapper {

	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		TierAbility tierAbility = new TierAbility();
		
		tierAbility.setId(rs.getInt("id"));
		
		Tier tier = new Tier();
		tier.setId(rs.getInt("tierid"));
		tier.setName(rs.getString("name"));
		tier.setSummary(rs.getString("summary"));
		tier.setActivated(rs.getInt("tier_activated") == 1);
		tierAbility.setTier(tier);
		
		tierAbility.setPolicyKey(rs.getString("policy_key"));
		tierAbility.setValue(rs.getString("value"));
		tierAbility.setActivated(rs.getInt("activated") == 1);
		tierAbility.setCreated(rs.getLong("created"));
		tierAbility.setModified(rs.getLong("modified"));
		
		return tierAbility;
	}

}
