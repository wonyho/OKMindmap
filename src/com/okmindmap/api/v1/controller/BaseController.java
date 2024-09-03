package com.okmindmap.api.v1.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.mvc.Controller;

import com.okmindmap.model.User;
import com.okmindmap.service.UserService;

public abstract class BaseController implements Controller {
	protected UserService userService;
	
	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	protected String getBaseUrl(HttpServletRequest request) {
		String scheme = request.getScheme() + "://";
	    String serverName = request.getServerName();
	    String serverPort = (request.getServerPort() == 80) ? "" : ":" + request.getServerPort();
	    String contextPath = request.getContextPath();
	    return scheme + serverName + serverPort + contextPath;
	}
	
	protected User getUser(HttpServletRequest request) throws Exception {
		Object obj = request.getSession().getAttribute("user");
		User user = null;
		if(obj != null) {
			user = (User)obj;
		} else {
			user = this.userService.loginAsGuest(request);
		}
		
		return user;
	}
}
