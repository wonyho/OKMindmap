package com.okmindmap.web.spring.iot;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.model.iot.IotModules;
import com.okmindmap.service.IotService;
import com.okmindmap.web.spring.BaseAction;

public class AddDevice  extends BaseAction  {

	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HashMap<String, Object> data = new HashMap<String, Object>();
		String confirm = request.getParameter("confirm");
		if("1".equals(confirm)) {
			User user = getUser(request);
			if(user != null) {
				if(user.getId() != 2) {
					String name = request.getParameter("name");
					String type = request.getParameter("type");
					IotDevices device = new IotDevices();
					device.setModules(new IotModules(Integer.parseInt(type)));
					device.setName(name);
					device.setUserId(user.getId());
					String key = user.getUsername() +"::"+ name +"::"+ type +"::"+ System.currentTimeMillis();
					String generated="";
					for(int i=0; i<10; i++) {
						generated += new Random().nextInt(9);
					}
					device.setSecret(this.MD5(key+generated));
					boolean rs = this.iotService.addDevices(device);
					if(rs) {
						response.setContentType("text");
					    response.setCharacterEncoding("UTF-8");
					    response.getWriter().write("1");
					    return null;
					}
				}
			}
			response.setContentType("text");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write("Add device failed !");
		    return null;
			
		}else {
			List<IotModules> modules = this.iotService.getModuleList();
			data.put("modules", modules);
			
			return new ModelAndView("iot/add", "data", data);
		}
	}
	
	private String MD5(String text) throws NoSuchAlgorithmException {
		MessageDigest m=MessageDigest.getInstance("MD5");
        m.update(text.getBytes(),0,text.length());
        return new BigInteger(1,m.digest()).toString(16);
	}

}
