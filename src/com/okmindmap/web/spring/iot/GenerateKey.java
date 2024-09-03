package com.okmindmap.web.spring.iot;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class GenerateKey extends BaseAction {

	private IotService iotService;

	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = getUser(request);
		if (user != null) {
			HashMap<String, Object> data = new HashMap<String, Object>();
			String did = request.getParameter("id");			
			IotDevices device = this.iotService.getDevice(user.getId(), Integer.parseInt(did));
			StringBuilder requestURL = new StringBuilder(request.getRequestURL().toString());
			String Url = requestURL.toString();
			Url = Url.substring(0,Url.indexOf("/iot/")) + "/iot/";
//			String key = "{\\\"iot_user\\\":\\\""+user.getId()
//				+"\\\",\\\"iot_device_key\\\":\\\""+device.getSecret()
//				+"\\\",\\\"iot_server\\\":\\\""+Url+"\\\"}";
			String key = "{\\\"iot_device_key\\\":\\\""+user.getId() + "-" + device.getSecret()
			+"\\\",\\\"iot_server\\\":\\\""+Url+"\\\"}";
			data.put("key", key);
			return new ModelAndView("iot/key", "data", data);
		}
		return null;
	}

}
