package com.okmindmap.api.search;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.api.sa.SuperAdminManager;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;

public class GoogleVideoSearch extends BaseAction {
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
		String pageToken = request.getParameter("pageToken");

		String url = "https://www.googleapis.com/youtube/v3/search?key=" + this.getActiveKey() + "&q=" + q
				+ "&type=video&part=snippet&safeSearch=strict&maxResults=25&pageToken=" + pageToken + "&cx=" + this.getSearchEngineID();

		String json = SuperAdminManager.getHttpsInputStream(url);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(json);
		return null;
	}

	private String getActiveKey() {
//		return "AIzaSyBBlzzuTQWuTy5FSKpSB5Ax8Q4IEKT3fKo";
		return SuperAdminManager.getActiveGoogleSearchKey(this.userService, "youtube");
	}

	private String getSearchEngineID() {
		return "006697568995703237209:vljrny3h45w";
	}
}