package com.okmindmap.web.spring.iot;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class UserLoadReadySensor extends BaseAction {

	private IotService iotService;

	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HashMap<String, Object> data = new HashMap<String, Object>();
		User user = getUser(request);
		if (user != null) {
			String did = request.getParameter("id");			
			data.put("board", did);
			List<IotConnection> connections = this.iotService.getDeviceConnection(user.getId(), Integer.parseInt(did));
			data.put("connections", connections);
			return new ModelAndView("iot/readySensor", "data", data);
		}
		return null;
	}

}
