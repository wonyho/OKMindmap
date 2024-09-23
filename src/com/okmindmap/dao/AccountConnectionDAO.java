package com.okmindmap.dao;

import java.util.List;

import com.okmindmap.model.AccountConnection;

public interface AccountConnectionDAO {
	public boolean addConnection(int userId, int accountId, String value);
	
	public List<AccountConnection> getConnection(int userId);
	
	public AccountConnection getConnection(int userId, int accountId, String value);
	
	public boolean removeConnection(int id);
}
