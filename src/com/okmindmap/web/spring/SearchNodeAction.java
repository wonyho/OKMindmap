package com.okmindmap.web.spring;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.model.Node;
import com.okmindmap.service.MindmapService;

public class SearchNodeAction extends BaseAction {
	private MindmapService mindmapService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String mapid = request.getParameter("mapid");
		String keyword = request.getParameter("keyword");
		String hidden = request.getParameter("hidden");
		
		List<Node> founds = this.mindmapService.searchNodes(Integer.parseInt(mapid), keyword, Boolean.getBoolean(hidden));
		
		System.out.println(founds.size());
		
		String json = new Gson().toJson(founds);
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
		return null;
	}

}
