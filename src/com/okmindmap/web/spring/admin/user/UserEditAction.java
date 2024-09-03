package com.okmindmap.web.spring.admin.user;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.StringUtils;
import com.okmindmap.model.User;
import com.okmindmap.model.group.Group;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.service.GroupService;
import com.okmindmap.service.PricingService;
import com.okmindmap.web.spring.BaseAction;

public class UserEditAction extends BaseAction {
	private GroupService groupService;
	private PricingService pricingService;
	
	public void setGroupService(GroupService groupService) {
		this.groupService = groupService;
	}
	
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		User user = getUser(request);
		
		String userid = request.getParameter("userid");
		
		if(user.getRoleId()!=1 || userid == null){
			HashMap<String, String> data = new HashMap<String, String>();
			data.put("messag", "권한이 없습니다.");
			data.put("url", "/");
			return new ModelAndView("error/index", "data", data);
			
		}
		
		// actions
		String action = ServletRequestUtils.getStringParameter(request, "action");
		if("changelevel".equals(action)) {
			BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
			
			String tierid = request.getParameter("tierid");
			String username = request.getParameter("username");
			if(!StringUtils.isNullOrEmpty(tierid) && !StringUtils.isNullOrEmpty(userid)) {
				this.pricingService.deleteTierMemberByUserId(Integer.parseInt(userid));
				this.pricingService.insertTierMember(Integer.parseInt(tierid), Integer.parseInt(userid), true, 0);
				
			} else if(!StringUtils.isNullOrEmpty(tierid) && !StringUtils.isNullOrEmpty(username)) {
				User u = getUserService().get(username);
				if(u != null) {
					this.pricingService.deleteTierMemberByUserId(u.getId());
					this.pricingService.insertTierMember(Integer.parseInt(tierid), u.getId(), true, 0);
				}
			}
			
			out.write(toBytes("{\"status\":\"ok\"}"));
			out.flush();
			out.close();
			
			return null;
		}
		//
		
		User user_edit = getUserService().get(Integer.parseInt(userid));
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		
		List<Tier> tiers = this.pricingService.getAllTiers(1, -1, null, null, null, true);
		data.put("tiers", tiers);
		
		JSONObject currentTier = this.pricingService.getCurrentTiersofUser(Integer.parseInt(userid));
		
		data.put("currentTier", currentTier);
		data.put("tierId", currentTier.get("tier_id"));
		data.put("userEdit", user_edit);
		
		List<Group> user_groups = this.groupService.getMemberGroups(Integer.parseInt(userid));
		data.put("user_groups", user_groups);
		
		
		return new ModelAndView("admin/users/edit", "data", data);
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
