package com.okmindmap.web.spring;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.json.JSONObject;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.PricingService;

public class IndexAction extends BaseAction {
	private OKMindmapService okmindmapService;
	private PricingService pricingService;
	private MindmapService mindmapService;

	public MindmapService getMindmapService() {
		return mindmapService;
	}

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}

	public OKMindmapService getOkmindmapService() {
		return okmindmapService;
	}

	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}
	
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		
		User user = getUser(request);
		
		if(user == null || user.getUsername().equals("guest")) {
			String persistent = getPersistentCookie(request);
			String fb_token = request.getParameter("fb_token");
			if(persistent != null) {
				User user_ps = this.userService.loginFromPersistent(request, response, persistent);
				if(user_ps != null) {
					user = user_ps;
				}
			} else if(fb_token != null && !"".equals(fb_token)) {
				User user_fb = this.userService.loginFromFacebook(request, response, fb_token);
				if(user_fb != null) {
					user = user_fb;
				}
			}
			
			String guest_map_allow = this.okmindmapService.getSetting("guest_map_allow");
			data.put("guest_map_allow", guest_map_allow);
		}
		data.put("user", user);
		
		
		// Mobile 식별을 위한 값
		String userAgent = request.getHeader("user-agent");
		if(userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPod") != -1){
			data.put("mobile", "iPhone");
		}else if(userAgent.indexOf("iPad") != -1){
			data.put("mobile", "iPad");
		}else if(userAgent.indexOf("Android") != -1){
			data.put("mobile", "Android");
		}
		
		if(data.get("mobile") != null) {
			request.setAttribute("menu", "off");
		}
		
		if(user != null) {
			JSONObject u_policy = this.pricingService.getCurrentTiersofUser(user.getId());
			data.put("user_policy_name", u_policy == null ? "" : u_policy.get("tier_name"));
			
			String url;
			int mapId = user.getLastmap();
			Map map = this.mindmapService.getMap(mapId);
			if(map != null){
				url = request.getContextPath() + "/map/" + map.getKey();
				response.sendRedirect(url);
				return null;
			}
		}
		return new ModelAndView("../index", "data", data);
		
	}

}
