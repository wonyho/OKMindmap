package com.okmindmap.service;

import java.util.List;

import com.okmindmap.dao.AccountConnectionDAO;
import com.okmindmap.model.AccountConnection;
import com.okmindmap.model.User;

public interface AccountConnectionService {
	
	public void setUserService(UserService userService);
	
	public void setaccountConnectionDAO(AccountConnectionDAO accountConnectionDAO);
	
	public boolean addConnection(int userId, int accountId, String value);
	
	public List<AccountConnection> getConnection(int userId);
	
	public AccountConnection getConnection(int userId, int accountId, String value);
	
	public boolean removeConnection(int id);
	
	public User findUser(String username, String email);

}
