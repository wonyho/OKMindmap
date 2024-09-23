package com.okmindmap.api.backup;

import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.api.sa.SuperAdminManager;
import com.okmindmap.model.User;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;

public class GetOkmCloudInfo extends BaseAction {
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
		if (SuperAdminManager.isSA(user)) {
			Gson gson = new Gson();
			HashMap<String, Object> data = new HashMap<String, Object>();
			
			String info = this.getInfo();
			System.out.println(info);
			if(!"".equals(info) && !"Denied".equals(info)) {
				
				JSONObject resp = new JSONObject(info);
				data.put("info", info);
				if("accepted".equals(resp.getString("status"))) {
					data.put("connected", true);
				}else {
					data.put("connected", false);
				}
			}
			
			response.getWriter().write(gson.toJson(data));
		} else {
			response.getWriter().write("denied");
		}

		return null;
	}

	private String getInfo() {
		HttpRequest.Builder builder = SuperAdminManager.makeOkmCloudRequest(userService, "/okmcloud/info");
		if(builder != null) {
			builder.method("GET", HttpRequest.BodyPublishers.ofString(""));
			HttpRequest request = builder.build();
			
			HttpResponse<String> response;
			try {
				response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
				return response.body();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "";
	}
}
