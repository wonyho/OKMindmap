package com.okmindmap.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.UserService;

public class LTIProviderFilter implements Filter {
	
//	@Autowired
//	protected UserService userService;

	@Override
	public void destroy() {
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
	
//		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		HttpServletRequest req = (HttpServletRequest) request;
		
		User user = this.getUser(req);
		String ltiprovider = this.getLTIProviderSession(req);
		
		if(user != null && ltiprovider != null) {
			if(!req.getRequestURL().toString().equals(ltiprovider)) {
				HttpServletResponse res = (HttpServletResponse) response;
				res.sendRedirect(ltiprovider);
			}
		}
		
		chain.doFilter(request, response);
	}

	@Override
	public void init(FilterConfig cfg) throws ServletException {
	}
	
	protected User getUser(HttpServletRequest request) {
		Object obj = request.getSession().getAttribute("user");
		User user = null;
		if(obj != null) {
			user = (User)obj;
		}
		
		return user;
	}
	
	protected String getLTIProviderSession(HttpServletRequest request) {
		return (String)request.getSession().getAttribute("ltiprovider");
	}
	
	protected void setLTIProviderSession(HttpServletRequest request, String ltiprovider) {
		HttpSession session = request.getSession();
	    session.setAttribute("ltiprovider", ltiprovider);
	}

}
