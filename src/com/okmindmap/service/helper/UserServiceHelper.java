package com.okmindmap.service.helper;

import javax.servlet.ServletContext;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.okmindmap.service.UserService;

public class UserServiceHelper {
	public static UserService getUserService(ServletContext ctx) {
    	WebApplicationContext wac = WebApplicationContextUtils
                .getRequiredWebApplicationContext(ctx);
         return (UserService) wac.getBean("userService");
    }
}
