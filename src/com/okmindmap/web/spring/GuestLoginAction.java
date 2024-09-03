package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public class GuestLoginAction extends BaseAction {
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String url = request.getParameter("url");
		
		getUserService().loginAsGuest(request);
				
		if(url == null) {
			url = request.getContextPath();
		}
		
		response.sendRedirect(url);
		
		return null;
	}

}
