package com.okmindmap.web.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.LisGrade;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.LisService;
import com.okmindmap.service.MindmapService;

public class LisAllScoreAction extends BaseAction {

	private MindmapService mindmapService;
	private LisService lisService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	public void setLisService(LisService lisService) {
		this.lisService = lisService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String mapid = request.getParameter("map");
		String nodeid = request.getParameter("node"); // this is Identity
		
	    if(nodeid == null)
	    	return null;	    
		Node node = this.mindmapService.getNode(nodeid,Integer.parseInt(mapid), false);
		

		if(node == null)
			return null;
		User user = getUser(request);
		String userID = String.valueOf(user.getId());
		if(user == null) 
			userID =  "2";
		else if(user.getUsername().equals("guest")) 
			userID =  "2";
		HashMap<String, Object> data = new HashMap<String, Object>();
		int mapOwnerId = this.mindmapService.getMapOwner(node.getMapId()).getId();
		if((!userID.equals("2") && mapOwnerId == Integer.parseInt(userID)) || userID.equals("1")) {
			String calAction = request.getParameter("calAction");
			String viewMode = request.getParameter("viewMode");
			List<LisGrade> scores = null;
			if(calAction.equals("last")) {
				scores = this.lisService.getLastListScore(Integer.parseInt(mapid), node.getId());
				data.put("scores", scores);
			}else if(calAction.equals("max")) {
				scores = this.lisService.getMaxListScore(Integer.parseInt(mapid), node.getId());
				data.put("scores", scores);
			}else if(calAction.equals("average")) {
				scores = this.lisService.getAverageListScore(Integer.parseInt(mapid), node.getId());
				data.put("scores", scores);
			}
			
			
			if(viewMode.equals("html")) {
				return new ModelAndView("scoreTable", "data", data);
			}else if(viewMode.equals("csv")) {
//				return new ModelAndView("", "data", data);
			}else if(viewMode.equals("map")) {
//				return new ModelAndView("", "data", data);
			}
		}

	    return null;
	}

}
