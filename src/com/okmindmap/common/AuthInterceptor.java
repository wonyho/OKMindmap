package com.okmindmap.common;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import com.okmindmap.configuration.Configuration;
import com.okmindmap.model.User;
import com.okmindmap.service.UserService;
import com.okmindmap.util.Crypto;

public class AuthInterceptor extends HandlerInterceptorAdapter {
	private final String CRYPTO_KEY = "EDB92B7E672C7CE3";
	
	protected UserService userService;
	
	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handle) throws Exception {
		if(this.getSessionUser(request, response)) {
			return true;
		}
		
//		if(this.makeTestAuth(request, response)) {
//			return true;
//		}
		
		return true;
	}
	
	private boolean getSessionUser(HttpServletRequest request, HttpServletResponse response) {
		User user = null;
		
//		String token = request.getParameter("popk");
//		if(token != null && !"".equals(token)) {
//			user = this.userService.getByToken(token);
//			
//			if(user != null) {
//				String portrait = user.getPortrait();
//				if(portrait == null || "".equals(portrait.trim())) {
//					user.setPortrait(getBaseUrl(request) + "/images/portrait_00.png");
//				}
//				
//				//request.getSession().setAttribute("user", user);
//				WebUtils.setSessionAttribute(request, "user", user);
//				
//				return true;
//			}
//		}
		
		if(user == null) {
			//Object obj = request.getSession().getAttribute("user");
			Object obj = WebUtils.getSessionAttribute(request, "user");
			if(obj != null) {
				user = (User)obj;
				
				return true;
			}
		}
		
		
		return false;
	}
	
	private String getBaseUrl(HttpServletRequest request) {
		String scheme = request.getScheme() + "://";
	    String serverName = request.getServerName();
	    String serverPort = (request.getServerPort() == 80) ? "" : ":" + request.getServerPort();
	    String contextPath = request.getContextPath();
	    return scheme + serverName + serverPort + contextPath;
	}
	
//	private boolean makeTestAuth(HttpServletRequest request, HttpServletResponse response) {
//		String testYN = Configuration.getString("auth.testYN");
//		if("Y".equals(testYN)) {
//			String testNo = request.getParameter("testNo");
//			if(testNo == null) {
//				testNo = this.getCookie(request, "testNo");
//			}
//			if(testNo == null) {
//				testNo = Configuration.getString("auth.testNo");
//			}
//			this.setCookie(response, "testNo", testNo);
//			
//			User user = this.userService.get(testNo);
//			String portrait = user.getPortrait();
//			if(portrait == null || "".equals(portrait)) {
//				user.setPortrait(getBaseUrl(request) + "/images/portrait_00.png");
//			}
//			
//			if(user != null) {
//				//HttpSession session = request.getSession();
//				//session.setAttribute("user", user);
//				WebUtils.setSessionAttribute(request, "user", user);
//				
//				return true;
//			}
//		}
//		return false;
//	}
	
	private String getCookie(HttpServletRequest request, String name) {
		String value = null;
		
		try {
			String encName = Base64.encodeBase64String(name.getBytes()).replaceAll("[^a-zA-Z]", "");
			
			Cookie[] cookies = request.getCookies();
			if(cookies != null) {
				for(Cookie cookie : cookies) {
					if(encName.equals(cookie.getName())) {
						String cookieValue = cookie.getValue();
						value = Crypto.decrypt(cookieValue, this.CRYPTO_KEY);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return value;
	}
	
	private void setCookie(HttpServletResponse response, String name, String value) {
		try {
			String encName = Base64.encodeBase64String(name.getBytes()).replaceAll("[^a-zA-Z]", "");
			String encValue = Crypto.encrypt(value, this.CRYPTO_KEY);
			
			Cookie cookie = new Cookie(encName, encValue);
			cookie.setPath("/");
			response.addCookie(cookie);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
