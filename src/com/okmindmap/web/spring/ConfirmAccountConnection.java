package com.okmindmap.web.spring;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.service.AccountConnectionService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.util.PasswordEncryptor;

public class ConfirmAccountConnection extends BaseAction{
	private MindmapService mindmapService;
	private AccountConnectionService accountConnectionService;
	
	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	public void setAccountConnectionService(AccountConnectionService accountConnectionService) {
		this.accountConnectionService = accountConnectionService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String confirm = getOptionalParam(request, "confirm", null);
		String username = getOptionalParam(request, "username", null);
		String type = getOptionalParam(request, "type", null);
		String value = getOptionalParam(request, "value", null);
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("user", username);
		data.put("type", type);
		data.put("value", value);
		
		if("1".equals(confirm)) {
			String password = request.getParameter("password");
			
			if(username != null && password != null) {
				User user = null;
				user = this.userService.get(username);
				String encrypted = PasswordEncryptor.encrypt(password);
				
				
				if(user != null) {
					if(encrypted.equals(user.getPassword())) {
						if(this.accountConnectionService.addConnection(user.getId(), Integer.parseInt(type), value)) {
							if("2".equals(type)) {
								user = getUserService().loginFromMoodle(request, response, user.getUsername());
								
								if(user != null) {
									int mapId = user.getLastmap();
									Map map = this.mindmapService.getMap(mapId);
									if(map == null) {
										response.sendRedirect(request.getContextPath() + "/");
										return null;
									} else {
										response.sendRedirect(request.getContextPath() + "/map/" + map.getKey());
										return null;
									}
								}
							}
						}else {
							data.put("msg", "Can not add connection");
						}
					}else {
						data.put("msg", "Wrong password");
					}
				}else {
					data.put("msg", "Indentity failed");
				}
			}
		}
		return new ModelAndView("user/connectAccountConfirm", "data", data);
	}

}
