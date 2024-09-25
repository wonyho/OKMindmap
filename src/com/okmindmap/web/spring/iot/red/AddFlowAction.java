package com.okmindmap.web.spring.iot.red;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.model.User;
import com.okmindmap.model.iot.RedFlow;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class AddFlowAction  extends BaseAction {
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String username = request.getParameter("username");
		String mac = request.getParameter("mac");
		
		System.out.println("id = " + id);
		System.out.println("name = " + name);
		System.out.println("username = " + username);
		
		User usr = this.userService.get(username);
		String result = "passed";
		if(usr != null) {
			if(usr.getId() != 2) {
				RedFlow rf = new RedFlow();
				rf.setFlowId(id);
				rf.setFlowName(name);
				rf.setUserId(usr.getId());
				rf.setUsername(username);
				rf.setMacAddress(mac);
				if(this.iotService.addFlow(rf)) {
					if(mac != "" && mac != " " && mac != "undefined" && mac != null) {
						this.iotService.updateConnectedFlow(rf);
					}
				}else {
					result = "failed";
				}
			}
		}

		response.setContentType("text");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(result);
		return null;
	}
}
