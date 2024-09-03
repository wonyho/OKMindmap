package com.okmindmap.web.spring.iot;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.model.iot.IotSensor;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class SensorListAction  extends BaseAction {
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		List<IotSensor> sensors = this.iotService.getSensorList();
		
		String json = new Gson().toJson(sensors);
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
		return null;
	}

	

}
