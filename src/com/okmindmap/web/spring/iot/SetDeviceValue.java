package com.okmindmap.web.spring.iot;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class SetDeviceValue  extends BaseAction {
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String secret = request.getParameter("iot_device_key");
//		String usr = request.getParameter("iot_user");
		String sensor = request.getParameter("iot_sensor");
		HashMap<String, Object> data = new HashMap<String, Object>();
		String[] sec = secret.split("-");
		if(sec.length != 2) return null;
		String usr = sec[0];
		secret = sec[1];
		if(this.iotService.getDevice(Integer.parseInt(usr), secret) != null){
			String value = request.getParameter("iot_sensor_value");
			boolean rs = this.iotService.setConnectValue(Integer.parseInt(sensor), value);
			data.put("iot_set_result", String.valueOf(rs));
		}else {
			data.put("iot_set_result", String.valueOf(false));
		}
		data.put("iot_device_key",usr + "-" + secret);
		
		
		
		String json = new Gson().toJson(data);
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
		return null;
	}

	

}