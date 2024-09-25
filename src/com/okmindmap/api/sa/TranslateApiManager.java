package com.okmindmap.api.sa;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.okmindmap.model.sa.ApiKey;

public class TranslateApiManager  extends BaseAction{
	protected UserService userService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	@SuppressWarnings("unchecked")
	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {

		User user = getUser(request);
		if(SuperAdminManager.isSA(user) && SuperAdminManager.sureExistedUserConfigField(userService, "sa_aitranlate_api_keys", "Translate API Key manager")) {
			String api_key = getOptionalParam(request, "api_key", "");
			HashMap<String, Object> data = new HashMap<String, Object>();
			if("".equals(api_key)) {
				data.put("keys", SuperAdminManager.getApiKeys(this.userService,  "sa_aitranlate_api_keys"));
			}else {
				if("del".equals(getOptionalParam(request, "action", ""))) {
					data.put("keys", this.removeKey(api_key));
				}else {
					data.put("keys", this.insertKey(api_key));
				}
				
			}
			data.put("total_key", ((List<ApiKey>)data.get("keys")).size());
			return new ModelAndView("sa/translateapi", "data", data);
		}
		return SuperAdminManager.requestSA(this.userService, request, response);
	}
	
	private List<ApiKey> insertKey(String api_key) {
		int userid = 1; //always is admin
		try {
			Gson gson = new Gson();
			UserConfigData data = this.userService.getUserConfigData(userid, "sa_aitranlate_api_keys");
			if(data != null) {
				List<ApiKey> google_keys = gson.fromJson(data.getData(), new TypeToken<ArrayList<ApiKey>>(){}.getType());
				if(!this.isExsited(google_keys, api_key)) {
					ApiKey newK = new ApiKey();
					newK.setKey(api_key);
					newK.setCounter("day", 0);
					newK.setCounter("month", 0);
					newK.setCounter("year", 0);
					newK.setCounter("total", 0);
					newK.setLastUsed("day", newK.getCreated());
					newK.setLastUsed("month", new SimpleDateFormat("yyyy-MM").format(new Date()));
					newK.setLastUsed("year", new SimpleDateFormat("yyyy").format(new Date()));
					google_keys.add(newK);
					this.userService.setUserConfigData(userid, "sa_aitranlate_api_keys", gson.toJson(google_keys, new TypeToken<ArrayList<ApiKey>>(){}.getType()));
				}
			}else {
				List<ApiKey> google_keys = new ArrayList<ApiKey>();
				ApiKey newK = new ApiKey();
				newK.setKey(api_key);
				newK.setCounter("day", 0);
				newK.setCounter("month", 0);
				newK.setCounter("year", 0);
				newK.setCounter("total", 0);
				newK.setLastUsed("day", newK.getCreated());
				newK.setLastUsed("month", new SimpleDateFormat("yyyy-MM").format(new Date()));
				newK.setLastUsed("year", new SimpleDateFormat("yyyy").format(new Date()));
				google_keys.add(newK);
				this.userService.setUserConfigData(userid, "sa_aitranlate_api_keys", gson.toJson(google_keys, new TypeToken<ArrayList<ApiKey>>(){}.getType()));
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return SuperAdminManager.getApiKeys(this.userService,  "sa_aitranlate_api_keys");
	}
	
	private List<ApiKey> removeKey(String api_key) {
		int userid = 1; //always is admin
		List<ApiKey> keys = SuperAdminManager.getApiKeys(this.userService,  "sa_aitranlate_api_keys");
		for(int i = 0; i<keys.size(); i++) {
			if(keys.get(i).getKey().equals(api_key)) {
				keys.remove(i);
				break;
			}
		}
		Gson gson = new Gson();
		try {
			this.userService.setUserConfigData(userid, "sa_aitranlate_api_keys", gson.toJson(keys, new TypeToken<ArrayList<ApiKey>>(){}.getType()));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return SuperAdminManager.getApiKeys(this.userService,  "sa_aitranlate_api_keys");
	}
	
	private boolean isExsited(List<ApiKey> google_keys, String key) {
		for(ApiKey k : google_keys) {
			if(k.getKey().equals(key)) return true;
		}
		return false;
	}
}
