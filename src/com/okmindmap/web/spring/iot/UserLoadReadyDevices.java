package com.okmindmap.web.spring.iot;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class UserLoadReadyDevices  extends BaseAction  {

	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HashMap<String, Object> data = new HashMap<String, Object>();
		User user = getUser(request);
		List<IotDevices> devices = new ArrayList<IotDevices>();
		if(user != null) {
			devices = this.iotService.getDevices(user.getId());
			data.put("user", user.getUsername());
			StringBuilder requestURL = new StringBuilder(request.getRequestURL().toString());
			String Url = requestURL.toString();
			Url = Url.substring(0,Url.indexOf("/iot/")) + "/iot/";
			data.put("server", Url);
		}
		data.put("devices", devices);
		return new ModelAndView("iot/readyDevice", "data", data);
	}
}
