package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;


public class CheckSession extends BaseAction{

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		User user = getUser(request);
				
		if(user == null || user.getUsername().equals("guest")) {
			response.setContentType("text");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write("0");
		}else {
			response.setContentType("text");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write(String.valueOf(user.getId()));
		}
		
	    return null;
	}
}
