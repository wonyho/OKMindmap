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

public class UpdateDevice extends BaseAction {

	private IotService iotService;

	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HashMap<String, Object> data = new HashMap<String, Object>();
		User user = getUser(request);
		if (user != null) {
			String confirm = request.getParameter("confirm");
			if("1".equals(confirm)) {
				if(user.getId() != 2) {
					String name = request.getParameter("name");
					String id = request.getParameter("id");
					this.iotService.editDevice(Integer.parseInt(id), name);
				}
			}
			String did = request.getParameter("id");			
			data.put("board", did);
			IotDevices device = this.iotService.getDevice(user.getId(), Integer.parseInt(did));
		
			data.put("device", device);
			return new ModelAndView("iot/updateDevice", "data", data);
		}
		return null;
	}

}
