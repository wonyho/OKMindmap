package com.okmindmap.api.sa;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;

public class SuperAdminDashBoard extends BaseAction {
	protected UserService userService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {

		User user = getUser(request);

		HashMap<String, Object> data = new HashMap<String, Object>();
		return new ModelAndView("sa/index", "data", data);

	}

}
