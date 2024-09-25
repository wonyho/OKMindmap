package com.okmindmap.web.spring;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.LisService;
import com.okmindmap.service.MindmapService;

public class LisScoreAction extends BaseAction {

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
//	    StringBuilder requestURL = new StringBuilder(request.getRequestURL().toString());
//	    String url = requestURL.toString();
//	    System.out.println(url.substring(0,url.indexOf("/mindmap/")));		    
		Node node = this.mindmapService.getNode(nodeid,Integer.parseInt(mapid), false);

		if(node == null)
			return null;
		User user = getUser(request);
		String userID = "0";
		if(user == null) 
			userID =  "2";
		else if(user.getUsername().equals("guest")) 
			userID =  "2";
		else 
			userID = String.valueOf(user.getId());
		
		double score = this.lisService.getScore(Integer.parseInt(userID), node.getMapId(), node.getId());
		
		response.setContentType("text");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(nodeid + "::" + String.format("%.1f",score));
	    
		return null;
	}

}
