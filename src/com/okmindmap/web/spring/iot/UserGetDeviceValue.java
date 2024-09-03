package com.okmindmap.web.spring.iot;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.model.User;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class UserGetDeviceValue  extends BaseAction {
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@SuppressWarnings("deprecation")
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String sensor = request.getParameter("iot_sensor");
		String result = "0";
		User user = getUser(request);
		HashMap<String, Object> data = new HashMap<String, Object>();
		if(user != null){
			if(user.getId() != 2) {
				IotConnection connection = this.iotService.getConnection(user.getId(), Integer.parseInt(sensor));
				String layout = connection.getLayout();
				String para = connection.getValue();
				if(!"0".equals(para)) {
					String[] parameters = para.split(",");
					for(int i = 0; i<parameters.length; i++) {
						String[] val = parameters[i].split(":");
						layout = layout.replace("{{" + val[0] + "}}", val[1]);
					}
				}
				long time = connection.getLastUpdate();
				Timestamp stamp = new Timestamp(time);
				Date date = new Date(stamp.getTime());
				layout = layout.replace("{{TIME}}", date.toLocaleString());
				result = layout;
				data.put("width", connection.getLayoutWidth());
				data.put("height", connection.getLayoutHeight());
				data.put("value", connection.getValue());
			}
		}
		data.put("html", result);
		String json = new Gson().toJson(data);
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
		return null;
	}

	

}
