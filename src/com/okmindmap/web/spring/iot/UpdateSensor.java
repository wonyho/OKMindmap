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

public class UpdateSensor extends BaseAction {

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
					String note = request.getParameter("note");
					String id = request.getParameter("id");
					String layout = request.getParameter("layout");
					String layoutW = request.getParameter("layoutW");
					String layoutH = request.getParameter("layoutH");
					this.iotService.editSensorConnection(Integer.parseInt(id), name, note, layout, layoutW, layoutH);
					return null;
				}
			}
			String did = request.getParameter("id");
			String boardid = request.getParameter("bid");
			data.put("board", boardid);
			IotConnection connection = this.iotService.getConnection(user.getId(), Integer.parseInt(did));
			String layout = "'" + connection.getLayout().replace("\n", "'+\n'") + "'";
			connection.setLayout(layout);
			data.put("connection", connection);
			return new ModelAndView("iot/updateConnection", "data", data);
		}
		return null;
	}

}
