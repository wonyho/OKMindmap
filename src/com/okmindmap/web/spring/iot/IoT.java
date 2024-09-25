package com.okmindmap.web.spring.iot;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.okmindmap.model.User;
import com.okmindmap.service.OKMindmapService;

public class IoT {
	private OKMindmapService okmindmapService;
	
	public IoT(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}
	
	public String str_finish(String str, String delimiter) {
		return str.endsWith(delimiter) ? str : str + delimiter;
	}
	
	public String getUrl(String path) {
		String url = this.okmindmapService.getSetting("nodejs_url");
		return this.str_finish(url, "/") + (path == null ? "":path);
	}
	
	private String request(String url) {
		try {
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			con.setRequestMethod("GET");
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			
			return response.toString();
		} catch (MalformedURLException e) {
			 e.printStackTrace();
		} catch (IOException e) {
			 e.printStackTrace();
		}
		return "";
	}
	
	public HashMap<String, Object> toHashMap(JSONObject object) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
		    Iterator<String> keysItr = object.keys();
		    while(keysItr.hasNext()) {
		        String key = keysItr.next();
		        Object value = object.get(key);
	
		        if(value instanceof JSONArray) {
		            value = this.toList((JSONArray) value);
		        }else if(value instanceof JSONObject) {
		            value = this.toHashMap((JSONObject) value);
		        }
		        map.put(key, value);
		    }
		} catch (JSONException e) {
			e.printStackTrace();
		}
	    return map;
	}
	
	public List<Object> toList(JSONArray array) {
		List<Object> list = new ArrayList<Object>();
		try {
		    for(int i = 0; i < array.length(); i++) {
		        Object value;
				value = array.get(i);
		        if(value instanceof JSONArray) {
		            value = toList((JSONArray) value);
		        }else if(value instanceof JSONObject) {
		            value = this.toHashMap((JSONObject) value);
		        }
		        list.add(value);
		    }
		} catch (JSONException e) {
			e.printStackTrace();
		}
	    return list;
	}

	public Boolean noderedAuth(String username, String password) {
		Boolean result = false;
		try {
			String nodered_connections = this.okmindmapService.getSetting("nodered_connections");
			
			if(!nodered_connections.isEmpty()) {
				JSONArray connections = new JSONArray(nodered_connections);
				for (int i = 0; i < connections.length(); i++) {
					JSONObject account = connections.getJSONObject(i);
					if(account.getString("username").equals(username) && account.getString("password").equals(password)) {
						result = true;
						break;
					}
				}
			}
		} catch (JSONException e) {} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
		
	}
	
	public void ctrlAction(String id, String params) {
		String nodered_connections = this.okmindmapService.getSetting("nodered_connections");
		
		if(!nodered_connections.isEmpty()) {
			String url = this.getUrl("iot/ctrl/"+id+"/"+params);
			this.request(url);
		}
	}
	
	public JSONObject getProviders(String id, Boolean isControl) {
		JSONObject res = new JSONObject();
		try {
			String url = this.getUrl("iot/providers");
			if(id != null) {
				url += "/"+id;
				if(isControl) url += "/listeners";
				else url += "/emitters";
			}
			res = new JSONObject(this.request(url));
			return res;
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}

}
