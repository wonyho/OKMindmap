package com.okmindmap.web.spring;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import com.google.gson.Gson;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.service.UserService;
import com.okmindmap.model.NodeFunctions;

public class UserNodeSettingAction extends BaseAction {
	private UserService userService = null;
	
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String confirmed = request.getParameter("confirmed");
		User user = getUser(request);
		int userid = user.getId();
		
		if(Objects.equals(confirmed, "active")) {
			String [] fields = request.getParameterValues("fields");
			String [] data = request.getParameterValues("data");
			
			String sdata = "";
			for(int i = 0; i < fields.length; i++) {
				if(Objects.equals(data[i],"true")) 
					sdata += fields[i] +",";
			}
			sdata = sdata.substring(0, sdata.length()-1);
			this.userService.setUserConfigData(userid, "menu.edit", sdata);
			return null;
		}
		
		if(Objects.equals(confirmed, "order")) {
			String order = request.getParameter("order");
			if(order != null)
			this.userService.setUserConfigData(userid, "userNmenuOrder", order);
		}

		String defaultOrder = "18,19,22,23,24,25,30,20,4,6,7,8,10,11,16,13,14,12,39,40,37,38,9,43,15,29,31,28,46,41";

		List<UserConfigData> configData = this.userService.getUserConfigData(userid);
		String save = "";
		for(UserConfigData data : configData) {
			if(Objects.equals(data.getFieldname(),"userNmenuOrder")) {
				save = data.getData();
				break;
			}
		}
		
		if(save != "") if(save.length() > 10) defaultOrder = save;
		if(userid == 2) defaultOrder = "18,19,22,23,24,25,30,6";

		String[] dafaultNode = defaultOrder.split("\\,", -1);
		List<NodeFunctions> nodeFuncss = this.userService.getNodeFunctions();
		List<NodeFunctions> nodeFunc = new ArrayList<NodeFunctions>();
		
		for(String id: dafaultNode) {
			for(NodeFunctions node : nodeFuncss) {
				if(node.getId() == Integer.valueOf(id)) {
					nodeFunc.add(node);
				}
			}
		}
		
		if(Objects.equals(confirmed, "node")) {
			String json = new Gson().toJson(nodeFunc);
			response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write(json);
			return null;
		}
		
		if(Objects.equals(confirmed, "json")){
			save="";
			for(UserConfigData data : configData) {
				if(Objects.equals(data.getFieldname(),"menu.edit")) {
					save = data.getData();
					break;
				}
			}
			if(userid == 2) save = "18,19,22,23,24,25,30,6";
			else if(save.equals("")) save = "18,19,20,4,6,7,8,16,10,11";
			List<NodeFunctions> enableNodeFunc = new ArrayList<NodeFunctions>();
			String[] saves = save.split("\\,", -1);
			for(NodeFunctions node : nodeFunc){
				for(String s :saves) {
					if(node.getId() == 47 || node.getId() == 48) continue;
					int nid = Integer.parseInt(s);
					if(nid == 26 || nid == 27) continue;
					if(node.getId() == nid) {
						enableNodeFunc.add(node);
					}
				}
			}
			
			String json = new Gson().toJson(enableNodeFunc);
			response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write(json);
			return null;
		}else {
			String defaultListOrder = "18,4,13,9,19,6,14,43,22,7,12,15,23,8,39,29,24,10,40,31,25,11,37,28,30,16,38,41,46,20";
			String[] dafaultListNode = defaultListOrder.split("\\,", -1);
			List<NodeFunctions> listFunc = new ArrayList<NodeFunctions>();
			for(String id: dafaultListNode) {
				for(NodeFunctions node : nodeFuncss) {
					if(node.getId() == 47 || node.getId() == 48) continue;
					if(node.getId() == Integer.valueOf(id)) {
						listFunc.add(node);
					}
				}
			}
			request.setAttribute("listFuncs", listFunc);
			request.setAttribute("nodeFuncs", nodeFunc);
			return new ModelAndView("user/node_menu_setting");
		}
	}
}
