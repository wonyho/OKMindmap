package com.okmindmap.api.backup;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.api.sa.SuperAdminManager;
import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.model.sa.OkmCloud;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;

public class SetOkmCloudInfo extends BaseAction {
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
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		if (SuperAdminManager.isSA(user) && SuperAdminManager.sureExistedUserConfigField(userService, "sa_okmcloud_api_connection", "OkmCloud API connection")) {
			Gson gson = new Gson();
			int userid = 1; //always is admin
			String host = request.getParameter("host");
			String usr = request.getParameter("user");
			String app = request.getParameter("app");
			String key = request.getParameter("key");
			if(!"".equals(host) && !"".equals(usr) && !"".equals(app) && !"".equals(key) ) {
				this.userService.setUserConfigData(userid, "sa_okmcloud_api_connection", gson.toJson(new OkmCloud(host, app, usr, key, ""), OkmCloud.class));
			}
			UserConfigData data = this.userService.getUserConfigData(userid, "sa_okmcloud_api_connection");
			if(data != null) response.getWriter().write(data.getData());
			else response.getWriter().write("null");
		} else {
			response.getWriter().write("denied");
		}

		return null;
	}
}
