package com.okmindmap.web.spring;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.dao.MindmapDAO;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;

public class MyDataStatisticsAction extends BaseAction {

	private MindmapService mindmapService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		response.setContentType("application/json");
		
		String all = request.getParameter("all");
		String createdFrom = request.getParameter("createdFrom"); 
		String createdTo = request.getParameter("createdTo");
		
		User user = getUser(request);
		List<java.util.Map<String, Object>> data = new ArrayList<java.util.Map<String, Object>>();
		
		if(user != null && !"guest".equals(user.getUsername())) {
			MindmapDAO mindmapDAO = this.mindmapService.getMindmapDAO();
			if("1".equals(all)) {
				data = mindmapDAO.getStatisticsByMonth(user.getId());
			} else if(createdFrom != null && createdTo != null) {
				data = mindmapDAO.getStatisticsByMonth(user.getId(), Long.parseLong(createdFrom), Long.parseLong(createdTo));
			}
		}
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("{");
		buffer.append("\"data\":" + this.listmap_to_json_string(data));
		buffer.append("}");
		
		response.getOutputStream().write(buffer.toString().getBytes());
		
		return null;
	}
	
	public String listmap_to_json_string(List<java.util.Map<String, Object>> list)
	{
		JSONArray json_arr=new JSONArray();
	    for (java.util.Map<String, Object> map : list) {
	        JSONObject json_obj=new JSONObject();
	        for (java.util.Map.Entry<String, Object> entry : map.entrySet()) {
	            String key = entry.getKey();
	            Object value = entry.getValue();
	            try {
	                json_obj.put(key,value);
	            } catch (JSONException e) {
	                // TODO Auto-generated catch block
	                e.printStackTrace();
	            }                           
	        }
	        json_arr.put(json_obj);
	    }
	    return json_arr.toString();
	}
}
