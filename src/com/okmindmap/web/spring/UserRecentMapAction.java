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

public class UserRecentMapAction extends BaseAction {
	private UserService userService = null;
	
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User user = getUser(request);
		if(!user.getUsername().equals("guest")) {
			String confirmed = request.getParameter("action");
			int userid = user.getId();
			
			if(Objects.equals(confirmed, "set")) {
				String rMaps = request.getParameter("recentMaps");
				if(rMaps.equals("1") || rMaps.equals("2")) return null;
				
				List<UserConfigData> configData = this.userService.getUserConfigData(userid);
				String save = "";
				for(UserConfigData data : configData) {
					if(Objects.equals(data.getFieldname(),"user.rMaps")) {
						save = data.getData();
						break;
					}
				}
				
				int num_rMaps = 10;
				for(UserConfigData data : configData) {
					if(Objects.equals(data.getFieldname(),"default_rMaps_number")) {
						num_rMaps = Integer.parseInt(data.getData());
						break;
					}
				}
				
				String[] mList = save.split(" ");
				save = "";
				boolean found = false;
				for(int i = 0; i<mList.length && i<num_rMaps; i++) {
					if(mList[i].equals(rMaps)) {
						save = rMaps + " " + save;
						found = true;
					}else {
						save = save + " " + mList[i];
					}
				}
				if(!found) save = rMaps + " " + save;
				save = save.replace("  ", " ");
				this.userService.setUserConfigData(userid, "user.rMaps", save);
				return null;
			}
			else if(Objects.equals(confirmed, "get")){

				List<UserConfigData> configData = this.userService.getUserConfigData(userid);
				String save = "";
				for(UserConfigData data : configData) {
					if(Objects.equals(data.getFieldname(),"user.rMaps")) {
						save = data.getData();
						break;
					}
				}
				response.setContentType("application/json");
			    response.setCharacterEncoding("UTF-8");
			    response.getWriter().write(save);
			}
		}
		
		return null;
	}
}

