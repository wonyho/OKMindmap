package com.okmindmap.dao.mysql.spring;

import java.util.List;

import com.okmindmap.dao.AccountConnectionDAO;
import com.okmindmap.dao.mysql.spring.mapper.AccountConnectionRowMapper;
import com.okmindmap.model.AccountConnection;

public class SpringAccountConnectionDAO extends SpringDAOBase implements AccountConnectionDAO{
	@Override
	public boolean addConnection(int userId, int accountId, String value) {
		String sql = "INSERT INTO `mm_account_connected`(`id_user`, `id_account`, `time`, `disabled`, `value`) VALUES (?,?,?,0,?) ";
		
		int result = getJdbcTemplate().update(sql,new Object[]{
				userId,
				accountId,
				System.currentTimeMillis(),
				value
		});
		return result > 0;
		
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<AccountConnection> getConnection(int userId) {
		String sql ="SELECT * FROM `mm_account_connected` ac "
				+ "JOIN `mm_account_type` a ON ac.id_account = a.id "
				+ "WHERE ac.id_user = ?";
		
		List<AccountConnection> list = getJdbcTemplate().query(sql, new Object[] {userId}, new AccountConnectionRowMapper());
		
		return list;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public AccountConnection getConnection(int userId, int accountId, String value) {
		String sql ="SELECT * FROM `mm_account_connected` ac "
				+ "JOIN `mm_account_type` a ON ac.id_account = a.id "
				+ "WHERE ac.id_user = ? AND ac.id_account = ? AND ac.value = ? ";
		
		List<AccountConnection> list = getJdbcTemplate().query(sql, new Object[] {userId, accountId, value}, new AccountConnectionRowMapper());
		if(list == null) return null;
		if(list.size() == 0) return null;
		return list.get(0);
	}

	@Override
	public boolean removeConnection(int id) {
		String sql = "DELETE FROM `mm_account_connected` WHERE ac.id_user = ? AND ac.id_account = ?";
		int result = getJdbcTemplate().update(sql,new Object[]{
				id
		});
		return result > 0;
	}
}
