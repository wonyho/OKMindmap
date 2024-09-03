package com.okmindmap.web.spring;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.StringUtils;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;
import com.okmindmap.model.User;
import com.okmindmap.service.PricingService;

public class UserTierPolicyAction extends BaseAction {
	private PricingService pricingService;
	
	
		
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
		
		String policy_key = request.getParameter("policy_key");
		
		User user = getUser(request);
		if(user == null || user.getUsername().equals("guest") || policy_key == null) {
			out.write(toBytes("{\"status\": 0}"));
			out.flush();
			out.close();
			return null;
		}
		
		JSONObject policy = this.pricingService.getCurrentTiersofUser(user.getId());
		int status = 0;
		if(policy != null && policy.has(policy_key)) {
			status = 1;
		}
		
		out.write(toBytes("{\"status\": "+status+"}"));
		out.flush();
		out.close();
		return null;
	}
	
	private byte[] toBytes(String txt) {
		try {
			return txt.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return txt.getBytes();
	}
}

