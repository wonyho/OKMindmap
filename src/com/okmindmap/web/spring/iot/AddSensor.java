package com.okmindmap.web.spring.iot;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.model.iot.IotSensor;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class AddSensor extends BaseAction {

	private IotService iotService;

	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HashMap<String, Object> data = new HashMap<String, Object>();
		String confirm = request.getParameter("confirm");
		User user = getUser(request);
		if (user != null) {
			String did = request.getParameter("id");
			if ("1".equals(confirm)) {
				if (user.getId() != 2) {
					String name = request.getParameter("name");
					String type = request.getParameter("type");
					String note = request.getParameter("note");
					String board = request.getParameter("board");
					String layout = request.getParameter("layout");
					String layoutW = request.getParameter("layoutW");
					String layoutH = request.getParameter("layoutH");
					
					IotConnection conn = new IotConnection();
					conn.setDevice(new IotDevices(Integer.parseInt(board)));
					conn.setSensor(new IotSensor(Integer.parseInt(type)));
					conn.setName(name);
					conn.setNote(note);
					conn.setLayout(layout);
					conn.setLayoutWidth(Integer.parseInt(layoutW));
					conn.setLayoutHeight(Integer.parseInt(layoutH));
					
					boolean rs = this.iotService.addSensorConnection(conn);
					if (rs) {
						response.getWriter().append("1");
					}
					response.getWriter().append("Add device failed !");
					return null;
				}
			} else {
				List<IotSensor> sensors = this.iotService.getSensorList();
				data.put("sensors", sensors);
				data.put("board", did);
				return new ModelAndView("iot/addConnection", "data", data);
			}
		}
		return null;
	}
}
