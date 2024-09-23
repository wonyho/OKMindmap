package com.okmindmap.api.search;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.api.sa.SuperAdminManager;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;

public class GoogleTextSearch extends BaseAction {
	protected UserService userService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String q = request.getParameter("q");
		q = new String(q.getBytes("ISO-8859-1"), "UTF-8");
		if(!"".equals(q)) q = q.replace(" ", "_");
		int start = Integer.parseInt(request.getParameter("page")) * 9 + 1;

		String url = "https://www.googleapis.com/customsearch/v1?key=" + this.getActiveKey() + "&q=" + q
				+ "&num=9&start=" + start + "&cx=" + this.getSearchEngineID();

		String json = SuperAdminManager.getHttpsInputStream(url);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(json);
		return null;
	}

	private String getActiveKey() {
		return SuperAdminManager.getActiveGoogleSearchKey(this.userService, "text");
	}

	private String getSearchEngineID() {
		return "006697568995703237209:vljrny3h45w";
	}
}

//https://www.googleapis.com/customsearch/v1?key=AIzaSyA5j1VZ3hJccqvMQZ8h_nWAl5kzRMZNnUQ&q=ok&searchType=image&num=10&start=1&cx=006697568995703237209:vljrny3h45w
