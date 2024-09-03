package com.okmindmap.web.spring.iot;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class UserSetDeviceValue  extends BaseAction {
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String sensor = request.getParameter("iot_sensor");
		String result = String.valueOf(false);
		User user = getUser(request);
		if(user != null){
			if(user.getId() != 2) {
				String value = request.getParameter("iot_sensor_value");
				boolean rs = this.iotService.setConnectValue(Integer.parseInt(sensor), value);
				result =  String.valueOf(rs);
			}
		}
		response.setContentType("text");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(result);
		return null;
	}

	

}
