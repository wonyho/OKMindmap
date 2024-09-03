package com.okmindmap.web.spring.iot;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.web.spring.BaseAction;

public class NoderedAuth extends BaseAction {
	
	private OKMindmapService okmindmapService;
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		String result = "0";
		IoT iot = new IoT(this.okmindmapService);
		
		if(username != null && password != null && iot.noderedAuth(username, password)) {
			result = "1";
		}
		
		response.getOutputStream().write(result.getBytes());
		return null;
	}

}
