package com.okmindmap.web.spring.share;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.LtiProvider;
import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.model.share.Share;
import com.okmindmap.service.LtiProviderService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.ShareService;
import com.okmindmap.web.spring.BaseAction;

public class DeleteAction extends BaseAction {

	private ShareService shareService;
	private MindmapService mindmapService;
	private LtiProviderService ltiProviderService;
	
	public void setShareService(ShareService shareService) {
		this.shareService = shareService;
	}
	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	public void setLtiProviderService(LtiProviderService ltiProviderService) {
		this.ltiProviderService = ltiProviderService;
	}
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		int shareId = (Integer)getRequiredParam(request, "id", Integer.class);
		int map_id = (Integer)getRequiredParam(request, "map_id", Integer.class);
		
		User user = null;
		try {
			user = getRequireLogin(request);
		} catch (Exception e) {
			HashMap<String, Object> data = new HashMap<String, Object>();
			data.put("url", "/share/delete.do?id=" + shareId);
			return new ModelAndView("user/login", "data", data);
		}
		
		int confirmed = getOptionalParam(request, "confirmed", 0);
		if(confirmed == 0) {
			HashMap<String, Object> data = new HashMap<String, Object>();
			Share share = this.shareService.getShare(shareId);
			data.put("share",  share);
			data.put("map", share.getMap());
			
			return new ModelAndView("share/delete", "data", data);
		}
		
		
		this.shareService.deleteShare(shareId);
		
		StringBuilder requestURL = new StringBuilder(request.getRequestURL().toString());
		String Url = requestURL.toString();
		Map mapp = mindmapService.getMap(map_id);
		Url = Url.substring(0,Url.indexOf("/share")) + "/map/" + mapp.getKey();
		LtiProvider lti =this.ltiProviderService.getLtiProvider(Url);
		if(lti != null) this.ltiProviderService.deleteLtiProvider(lti.getId());
		
		

		
		response.sendRedirect(request.getContextPath() + "/share/list.do?map_id="+map_id);
		
		return null;
	}

}
