package com.okmindmap.web.spring;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.GroupService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.ShareService;
import com.okmindmap.moodle.MoodleService;

import java.net.URI;
import java.net.URLDecoder;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.*;
import java.util.ArrayList;

public class LaunchMoodleAction extends BaseAction {
	private OKMindmapService okmindmapService;
	private MindmapService mindmapService;
	private ShareService shareService;
	private GroupService groupService;
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}
	
	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	public void setShareService(ShareService shareService) {
		this.shareService = shareService;
	}
	public void setGroupService(GroupService groupService) {
		this.groupService = groupService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String url = request.getParameter("url");
		
		User user = getUser(request);
		MoodleService moodleService = new MoodleService(user, this.okmindmapService, this.mindmapService, this.userService, this.shareService, this.groupService);
		
//		if(user == null || user.getUsername().equals("guest")) {
//			response.sendRedirect(url);
//		}else {
//			String auth = user.getAuth();
//			if("moodle".equals(auth)) {
//				url += "&username=" + user.getUsername();
//			}else {
//				auth = "okmmauth";
//				url += "&username=" + moodleService.getIdEncrypt(user);
//			}
//			
//			url += "&auth=" + auth;
//			url += "&firstname=" + java.net.URLEncoder.encode(StringEscapeUtils.escapeHtml(user.getFirstname()), "UTF-8");
//			url += "&lastname=" + java.net.URLEncoder.encode(StringEscapeUtils.escapeHtml(user.getLastname()), "UTF-8");
//			url += "&email=" + java.net.URLEncoder.encode(StringEscapeUtils.escapeHtml(user.getEmail()), "UTF-8");
//			response.sendRedirect(url);
//		}
		
		String resource_info = request.getParameter("resource_info");
		if(resource_info != null &&  "create_activity".equals(resource_info)) {
			String oauth_callback = request.getParameter("oauth_callback");
			JSONObject _mdConfig = moodleService.getMoodleConfig(oauth_callback);
			
			if(_mdConfig != null) {
				JSONObject obj = new JSONObject();
				obj.put("info", "create_activity");
				obj.put("role", "coursecreator");
				obj.put("moodleCourseId", request.getParameter("resource_moodleCourseId"));
				obj.put("module", request.getParameter("resource_module"));
				obj.put("mapid", request.getParameter("mapid"));
				obj.put("mapkey", request.getParameter("mapkey"));
				obj.put("section", request.getParameter("section"));
				obj.put("oauth_callback",  oauth_callback);
				
				response.sendRedirect(moodleService.request_url(moodleService.getUrl(_mdConfig), obj, moodleService.getSecret(_mdConfig), user));
				return null;
			}
		}
		
		if(url != null) {
			url = java.net.URLDecoder.decode(url, "UTF-8");
			
			URI uri = new URI(url);
		    String domain = uri.getHost() + this.clearPort(uri.getPort()) + this.clearPath(uri.getPath()) ;
		    
		    JSONObject mdConfig = moodleService.getMoodleConfig(domain);
			
		    System.out.println(domain);
		    System.out.println(mdConfig);
		    
			if(mdConfig != null) {
				String url_redirect = uri.getQuery().replace("redirect=", "");
				
				JSONObject obj = new JSONObject();
				obj.put("info", "oauth_callback");
				obj.put("oauth_callback",  url_redirect);
				
				response.sendRedirect(moodleService.request_url(moodleService.getUrl(mdConfig), obj, moodleService.getSecret(mdConfig), user));
				return null;
				
			}
		}
		
		response.getOutputStream().write("Moodle connection not found!".getBytes());
		
		return null;
	}
	
	private String clearPath(String path) {
		path = path.substring(0, path.indexOf("/auth/okmmauth/services.php"));
		if(path == "") return "";
		return path + "/";
	}
	
	private String clearPort(int port) {
		if(port == 80 || port == 443 || port < 1) return "";
		return ":" + port ;
	}
}