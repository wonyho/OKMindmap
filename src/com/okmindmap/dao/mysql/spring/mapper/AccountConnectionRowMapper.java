package com.okmindmap.dao.mysql.spring.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.okmindmap.model.AccountConnection;

public class AccountConnectionRowMapper  extends RowMapperBase implements RowMapper  {
	public Object mapRow(ResultSet rs, int arg1) throws SQLException {
		AccountConnection ac = new AccountConnection();
		
		ac.setAccountName(rs.getString("name"));
		ac.setDisabled(rs.getBoolean("disabled"));
		ac.setId_account(rs.getInt("id_account"));
		ac.setId_user(rs.getInt("id_user"));
		ac.setTime(rs.getLong("time"));
		ac.setValue(rs.getString("value"));
		ac.setId(rs.getInt("idc"));
		
		return ac;
	}

}
