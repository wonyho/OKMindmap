package com.okmindmap.service.impl;

import java.util.List;

import com.okmindmap.dao.AccountConnectionDAO;
import com.okmindmap.model.AccountConnection;
import com.okmindmap.model.User;
import com.okmindmap.service.AccountConnectionService;
import com.okmindmap.service.UserService;

public class AccountConnectionServiceImpl implements AccountConnectionService{
	private AccountConnectionDAO accountConnectionDAO;
	protected UserService userService;

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public void setaccountConnectionDAO(AccountConnectionDAO accountConnectionDAO) {
		this.accountConnectionDAO = accountConnectionDAO;
	}

	public boolean addConnection(int userId, int accountId, String value) {
		return this.accountConnectionDAO.addConnection(userId, accountId, value);
	}
	
	public List<AccountConnection> getConnection(int userId){
		return this.accountConnectionDAO.getConnection(userId);
	}
	
	public AccountConnection getConnection(int userId, int accountId, String value) {
		return this.accountConnectionDAO.getConnection(userId, accountId, value);
	}
	
	public boolean removeConnection(int id) {
		return this.accountConnectionDAO.removeConnection(id);
	}
	
	public User findUser(String username, String email) {
		User user = null;
		
		user = this.userService.get(username);
		
		if(user == null) {
			user = this.userService.getByEmail(email);
		}

		return user;
	}

}
