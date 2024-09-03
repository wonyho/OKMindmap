package com.okmindmap.web.spring.admin.pricing.tier;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.StringUtils;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;
import com.okmindmap.model.User;
import com.okmindmap.service.PricingService;
import com.okmindmap.web.spring.BaseAction;

public class FormAction extends BaseAction {
	private PricingService pricingService;
	
	
		
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		
		User adminuser = getUser(request);
		if(adminuser.getRoleId()!=1) {
			data.put("messag", "권한이 없습니다.");
			data.put("url", "/");
			return new ModelAndView("error/index", "data", data);
		}
		
		String formdata = request.getParameter("formdata");
		if(formdata != null) {
			BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
			
			JSONObject json = new JSONObject(formdata);
			
			if(StringUtils.isNullOrEmpty(json.getString("id"))) {
				int newid = this.pricingService.newTier(json.getString("name"), json.getString("summary"), 0,  json.getBoolean("activated"));
				this.updateTierAbility(newid, json.getJSONArray("functions"));
			} else {
				Tier tier = this.pricingService.getTier(json.getInt("id"));
				if(tier != null) {
					tier.setName(json.getString("name"));
					tier.setSummary(json.getString("summary"));
					tier.setActivated(json.getBoolean("activated"));
					
					this.pricingService.updateTier(tier);
					this.updateTierAbility(tier.getId(), json.getJSONArray("functions"));
				}
			}
			
			out.write(toBytes("{\"status\":\"ok\"}"));
			out.flush();
			out.close();
			
			return null;
		}
		
		String action = ServletRequestUtils.getStringParameter(request, "action");
		if("loadtier".equals(action)) {
			BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
			
			String tierid = request.getParameter("tierid");
			
			JSONObject policy = new JSONObject();
			List<TierAbility> functions = this.pricingService.getTierAbilities(Integer.parseInt(tierid));
			for(TierAbility fn : functions) {
				if(fn.getActivated()) {
					JSONObject value = new JSONObject();
					value.put("value", fn.getValue());
					
					String key = fn.getPolicyKey().replace('.', '_');
					if(!policy.has(key)) {
						JSONArray arr = new JSONArray();
						if(!"".equals(fn.getValue())) {
							arr.put(value);
						}
						policy.put(key, arr);
					} else {
						JSONArray arr = (JSONArray) policy.get(key);
						if(!"".equals(fn.getValue())) {
							arr.put(value);
						}
						policy.put(key, arr);
					}
				}
			}
			
			out.write(toBytes("{\"status\":\"ok\", \"data\": "+policy.toString()+"}"));
			out.flush();
			out.close();
			
			return null;
		}
		
		String id = request.getParameter("id");
		if(!StringUtils.isNullOrEmpty(id)) {
			Tier tier = this.pricingService.getTier(Integer.parseInt(id));
			if(tier != null) {
				data.put("tier", tier);
				
				List<TierAbility> functions = this.pricingService.getTierAbilities(tier.getId());
				for(TierAbility fn : functions) {
					String key = fn.getPolicyKey().replace('.', '_');
					
					data.put(key+"_key", fn.getPolicyKey());
					data.put(key+"_activated", fn.getActivated());
					data.put(key+"_value", fn.getValue());
				}
			}
		}
		
		List<Tier> tiers = this.pricingService.getAllTiers(1, -1, null, null, null, true);
		data.put("tiers", tiers);
		
		return new ModelAndView("admin/pricing/tier/form", "data", data);
	}
	
	private byte[] toBytes(String txt) {
		try {
			return txt.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return txt.getBytes();
	}
	
	private void updateTierAbility(int tierid, JSONArray functions) {
		try {
		    for(int i = 0; i < functions.length(); i++) {
		    	JSONObject fn = (JSONObject) functions.get(i);
		    	
		        if(!fn.has("type") || !"header".equals(fn.getString("type"))) {
		            this.pricingService.updateTierAbility(tierid, fn.getString("policy_key"), fn.getString("value"), fn.getBoolean("activated"));
		        }
		    }
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
}

