package com.okmindmap.web.spring.iot.red;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.iot.RedFlow;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class FlowIdByMacAction  extends BaseAction {
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String mac = request.getParameter("mac");
		String username = request.getParameter("username");

		System.out.println("name = " + mac);
		System.out.println("username = " + username);
		
		User usr = this.userService.get(username);
		String result = "none";
		if(usr != null) {
			if(usr.getId() != 2) {
				RedFlow rf = this.iotService.getFlow(username, mac);
				
				if(rf != null) {
					result = rf.getFlowId();
				}
			}
		}

		response.setContentType("text");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(result);
		return null;
	}
}
