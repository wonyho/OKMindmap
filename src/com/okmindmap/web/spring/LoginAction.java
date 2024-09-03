package com.okmindmap.web.spring;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.moodle.MoodleService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.MindmapService;

public class LoginAction extends BaseAction {
	
	private OKMindmapService okmindmapService;
	private MindmapService mindmapService;
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}
	
	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String persistent = request.getParameter("persistent");
		String facebook = request.getParameter("facebook");
		String moodle = request.getParameter("moodle");
		String google = request.getParameter("google");
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		
		User authUser = getUser(request);
		
		// Moodle auth request
		
		MoodleService moodleService = new MoodleService(authUser, this.okmindmapService, this.mindmapService, getUserService());

		String moodle_oauth_callback = (String) request.getParameter("moodle_oauth_callback");
		
		if(moodle_oauth_callback == null) data.put("moodle_loginpage_idps", moodleService.getMoodleLoginPageIdps());
		else data.put("moodle_loginpage_idps", null);
		
		data.put("moodle_login", moodle);
		data.put("moodle_oauth_callback", moodle_oauth_callback);
		
		if(google != null && !"".equals(google)) {
			
			User user = getUserService().loginFromGoogle(request, response, google);
			
			if(user == null) {
				return new ModelAndView("user/login", "message", "Google account not found");
			}
			
			String url = getOptionalParam(request, "return_url", null);
			if(url == null || url.trim() == "" || url.indexOf("index") != -1) {
				int mapId = user.getLastmap();
				Map map = this.mindmapService.getMap(mapId);
				if(map == null) {
					url = request.getContextPath() + "/";
				} else {
					url = request.getContextPath() + "/map/" + map.getKey();
				}					
			}
			
			response.sendRedirect(url);
			
			
		} else if(facebook != null && !"".equals(facebook)) {
			User user = getUserService().loginFromFacebook(request, response, facebook);
			
			if(user == null) {
//				String url = request.getContextPath() + "/user/joinmethod.jsp";
//				response.getOutputStream().write(url.getBytes());
//				return null;
				response.getOutputStream().write("0".getBytes());
				return null;
			}
			
			String url = getOptionalParam(request, "return_url", null);
			if(url == null || url.trim() == "" || url.indexOf("index") != -1) {
				int mapId = user.getLastmap();
				Map map = this.mindmapService.getMap(mapId);
				if(map == null) {
					url = request.getContextPath() + "/index.do";
				} else {
					url = request.getContextPath() + "/map/" + map.getKey();
				}					
			}
			
			response.getOutputStream().write(url.getBytes());
			return null;
			//response.sendRedirect(url);
		} else  if(username != null && password != null) {
			try {
				User user = null;
				if(persistent != null && "1".equals(persistent)) {
					user = getUserService().login(request, response, username, password, true);
				} else {
					user = getUserService().login(request, response, username, password, false);
				}
				
				//csedung check confirming email
				if(user.getConfirmed() == 0) {
					this.getUserService().logout(request, response);
					return new ModelAndView("user/pleaseconfirm");
				}
				
				String fbconnect = getOptionalParam(request, "facebook_connect", null);
				if(fbconnect != null && !"".equals(fbconnect)) {
					getUserService().updateFacebook(user.getId(), fbconnect);
				}
				
				if(moodle_oauth_callback != null) {
					if(user != null && !user.getUsername().equals("guest")) {
						MoodleService _moodleService = new MoodleService(user, this.okmindmapService, this.mindmapService, getUserService());
						JSONObject _mdConfig = _moodleService.getMoodleConfig(moodle_oauth_callback);
						
						if(_mdConfig != null) {
							JSONObject obj = new JSONObject();
							obj.put("info", "oauth_callback");
							obj.put("oauth_callback",  moodle_oauth_callback + "/index.php?redirect=0");
							
							response.sendRedirect(_moodleService.request_url(_moodleService.getUrl(_mdConfig), obj, _moodleService.getSecret(_mdConfig), user));
							return null;
							
						}
					}
				}
				
				String url = getOptionalParam(request, "return_url", null);
				if(url == null || url.trim() == "" || url.indexOf("index") != -1) {
					int mapId = user.getLastmap();
					Map map = this.mindmapService.getMap(mapId);
					if(map == null) {
						url = request.getContextPath() + "/";
					} else {
						url = request.getContextPath() + "/map/" + map.getKey();
					}					
				}
				
				response.sendRedirect(url);
			} catch (Exception e) {
				return new ModelAndView("user/login", "message", e.getMessage());
			}
		} else {
			return new ModelAndView("user/login", "data", data);
		}
		
		return null;
	}

}
