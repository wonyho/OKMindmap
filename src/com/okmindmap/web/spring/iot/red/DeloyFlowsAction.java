package com.okmindmap.web.spring.iot.red;

import java.io.BufferedReader;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.model.User;
import com.okmindmap.model.iot.RedFlow;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class DeloyFlowsAction  extends BaseAction {
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
		
		JSONObject data = new JSONObject(jsonString);
		String username = data.getString("username");
		
		System.out.println(jsonString);
		System.out.println("username = " + username);
		String result = "passed";
		User usr = this.userService.get(username);
		if(usr != null) {
			if(usr.getId() != 2) {
				JSONArray objs = new JSONArray(data.getString("data"));
				for(int i = 0; i<objs.length(); i++) {
					JSONObject obj = objs.getJSONObject(i);
					String id = obj.getString("id");
					if(obj.has("z")) continue;
					
					RedFlow rf = new RedFlow();
					rf.setFlowId(id);
					rf.setFlowName(obj.getString("label"));
					rf.setUserId(usr.getId());
					rf.setUsername(username);
					if(this.iotService.addFlow(rf)) {
						
					}else {
						result = "failed";
					}
				}
			}
		}
		response.setContentType("text");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(result);
		return null;
	}
}
