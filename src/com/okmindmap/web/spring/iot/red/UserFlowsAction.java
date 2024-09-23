package com.okmindmap.web.spring.iot.red;

import java.io.BufferedReader;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.model.User;
import com.okmindmap.model.iot.RedFlow;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class UserFlowsAction  extends BaseAction {
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		StringBuilder sb = new StringBuilder();
		BufferedReader reader = request.getReader();
	    try {
	        String line;
	        while ((line = reader.readLine()) != null) {
	            sb.append(line).append('\n');
	        }
	    } finally {
	        reader.close();
	    }
	    
		String jsonString = sb.toString();
		jsonString = jsonString.substring(1, jsonString.length()-2);
		jsonString = jsonString.replace("\\\"", "\"");
		System.out.println(jsonString);
		
		JSONObject obj = new JSONObject(jsonString);
		String username = obj.getString("username");
		
		

		System.out.println("username = " + username);
		List<RedFlow> userFlows = null;
		User usr = this.userService.get(username);
		if(usr != null) {
			if(usr.getId() != 2) {
				userFlows = this.iotService.getFlows(username);
			}
		}

		String json = new Gson().toJson(userFlows);
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
		return null;
	}
}
