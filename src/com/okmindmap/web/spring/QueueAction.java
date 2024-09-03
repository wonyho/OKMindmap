package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.QueueService;

import net.sf.json.JSONObject;

public class QueueAction extends BaseAction {
	
	private QueueService queueService;
	private MindmapService mindmapService;


	public void setQueueService(QueueService queueService) {
		this.queueService = queueService;
	}
	
	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = getUser(request);
		String username = user.getUsername();
		
		String action = request.getParameter("action");
		String sender = request.getParameter("sender");
		String mapKey = request.getParameter("mapKey");
		
		int result = -1;
		
		if( !"guest".equals(username) && this.queueService.isQueueing(mapKey)) {
			if("NodeCoordMove".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("dx", request.getParameter("dx"));
				jsonObject.put("dy", request.getParameter("dy"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("delete".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("foreign".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("data", request.getParameter("html"));
				jsonObject.put("width", request.getParameter("width"));
				jsonObject.put("height", request.getParameter("height"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("insert".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("data", request.getParameter("data"));
				jsonObject.put("index", request.getParameter("index"));
				jsonObject.put("isLeft", request.getParameter("isLeft"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("paste".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("data", request.getParameter("data"));
				jsonObject.put("index", request.getParameter("index"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("Node Move".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("parentNodeID", request.getParameter("parentNodeID"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("position", request.getParameter("position"));
				jsonObject.put("targNodeID", request.getParameter("targNodeID"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("edit".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("data", request.getParameter("data"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("image".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("data", request.getParameter("data"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("recovery".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("data", request.getParameter("data"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("hyper".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("nodeId", request.getParameter("nodeId"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				jsonObject.put("data", request.getParameter("data"));
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("attrs".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("xml", request.getParameter("xml"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			} else if("refresh".equals(action)) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("action", action);
				jsonObject.put("data", request.getParameter("userid"));
				jsonObject.put("sender", sender);
				jsonObject.put("username", username);
				queueService.insert(mapKey, jsonObject.toString());
				
				result = 1;
			}
		}
		
		response.getOutputStream().write(Integer.toString(result).getBytes());
		
		return null;
	}
}
