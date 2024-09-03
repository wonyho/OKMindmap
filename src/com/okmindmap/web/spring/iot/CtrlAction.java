package com.okmindmap.web.spring.iot;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.web.spring.BaseAction;

public class CtrlAction extends BaseAction {
	
	private OKMindmapService okmindmapService;
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String id = request.getParameter("id");
		String params = request.getParameter("params");
		
		if(id != null && params != null) {
			IoT iot = new IoT(this.okmindmapService);
			iot.ctrlAction(id, params);
		}
		
		
		response.getOutputStream().write("done!".getBytes());
		return null;
	}

}
