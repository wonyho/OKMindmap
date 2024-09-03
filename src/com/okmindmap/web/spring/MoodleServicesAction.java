package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.AccountConnection;
import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.moodle.MoodleService;
import com.okmindmap.service.AccountConnectionService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.OKMindmapService;

import java.util.*;
import org.imsglobal.lti.launch.*;
import org.json.JSONObject;

public class MoodleServicesAction extends BaseAction {

	private MindmapService mindmapService;
	private OKMindmapService okmindmapService;
	private AccountConnectionService accountConnectionService;
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}

	public void setAccountConnectionService(AccountConnectionService accountConnectionService) {
		this.accountConnectionService = accountConnectionService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String oauth_callback = request.getParameter("oauth_callback");
		String resource_info = request.getParameter("resource_info");
		String want_url = request.getParameter("wants");
		
		if(oauth_callback != null && resource_info != null) {
			
			User authUser = getUser(request);
			MoodleService moodleService = new MoodleService(authUser, this.okmindmapService, this.mindmapService, getUserService());
			
			JSONObject mdConfig = moodleService.getMoodleConfig(oauth_callback);
			
			if(mdConfig != null) {
				LtiVerifier ltiVerifier = new LtiOauthVerifier();
				String _key = request.getParameter("oauth_consumer_key");
				String _secret = moodleService.getSecret(mdConfig);
				LtiVerificationResult ltiResult = ltiVerifier.verify(request, _secret);
				
				if(ltiResult.getSuccess()) {
					
					if("loginpage_idp".equals(resource_info)) {
						if(authUser == null || authUser.getUsername().equals("guest")) {
							response.sendRedirect(request.getContextPath() + "/user/login.do?moodle_oauth_callback=" + oauth_callback);
						} else {
							JSONObject obj = new JSONObject();
							obj.put("info", "oauth_callback");
							obj.put("oauth_callback", "".equals(want_url) ? oauth_callback + "/index.php?redirect=0" : want_url);
							
							response.sendRedirect(moodleService.request_url(moodleService.getUrl(mdConfig), obj, moodleService.getSecret(mdConfig), authUser));
							return null;
						}
					} 
					
					if("oauth_callback".equals(resource_info)) {
						
						this.accountConnectionService.setUserService(this.userService);
						User findUser = this.accountConnectionService.findUser(request.getParameter("lis_person_username"), 
								request.getParameter("lis_person_contact_email_primary"));
						
						if(findUser != null) {
							AccountConnection ac = this.accountConnectionService.getConnection(findUser.getId(), 2, oauth_callback);
							if(ac == null) {
								if(findUser.getAuth().equals("moodle")) {
									if(this.accountConnectionService.addConnection(findUser.getId(), 2, oauth_callback)) {
										findUser = getUserService().loginFromMoodle(request, response, findUser.getUsername());
										
										if(findUser != null) {
											int mapId = findUser.getLastmap();
											Map map = this.mindmapService.getMap(mapId);
											if(map == null) {
												response.sendRedirect(request.getContextPath() + "/");
												return null;
											} else {
												response.sendRedirect(request.getContextPath() + "/map/" + map.getKey());
												return null;
											}
										}
									}else {
										response.getOutputStream().write(("Create Moodle connection failed!").getBytes());
										return null;
									}
								}else {
									HashMap<String, Object> data = new HashMap<String, Object>();
									data.put("user", findUser);
									data.put("type", 2);
									data.put("value", oauth_callback);
									return new ModelAndView("user/connectAccount", "data", data);
								}	
							}else {
								findUser = getUserService().loginFromMoodle(request, response, findUser.getUsername());
								
								if(findUser != null) {
									int mapId = findUser.getLastmap();
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
							User mdlUser = moodleService.syncUser(
									request.getParameter("lis_person_auth"), 
									request.getParameter("lis_person_username"), 
									java.net.URLDecoder.decode(request.getParameter("lis_person_name_given"), "UTF-8"), 
									java.net.URLDecoder.decode(request.getParameter("lis_person_name_family"), "UTF-8"), 
									request.getParameter("lis_person_contact_email_primary")
							);
							
							if(mdlUser !=null) {
								if(this.accountConnectionService.addConnection(mdlUser.getId(), 2, oauth_callback)) {
									User user = getUserService().loginFromMoodle(request, response, mdlUser.getUsername());
									
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
									}else {
										response.getOutputStream().write(("Moodel login failed!").getBytes());
										return null;
									}
								}else {
									response.getOutputStream().write(("Create connetion failed!").getBytes());
									return null;
								}
								
							}
							response.getOutputStream().write(("Async Moodle user failed!").getBytes());
							return null;
						}
						
					}				
					 
					response.getOutputStream().write(("resource_info not found!").getBytes());
					return null;
				} else {
					response.getOutputStream().write(("Verify failed!").getBytes());
					return null;
				}
			} else {
				response.getOutputStream().write(("mdConfig not found: " + oauth_callback).getBytes());
				return null;
			}
		} 
		
		response.getOutputStream().write(("Request failed!").getBytes());
		return null;

	}
}
