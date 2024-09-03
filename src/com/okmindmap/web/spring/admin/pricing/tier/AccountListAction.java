package com.okmindmap.web.spring.admin.pricing.tier;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.StringUtils;
import com.okmindmap.model.pricing.Member;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;
import com.okmindmap.model.User;
import com.okmindmap.service.PricingService;
import com.okmindmap.web.spring.BaseAction;

public class AccountListAction extends BaseAction {
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
		
		String action = ServletRequestUtils.getStringParameter(request, "action");
		if("changelevel".equals(action)) {
			BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
			
			String tierid = request.getParameter("tierid");
			String userid = request.getParameter("userid");
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
		
		int page = ServletRequestUtils.getIntParameter(request, "page", 1);
		int pagelimit = ServletRequestUtils.getIntParameter(request, "pagelimit", 10);
		String search = ServletRequestUtils.getStringParameter(request, "search");
		String searchfield = ServletRequestUtils.getStringParameter(request, "searchfield", "username");
		
		String sort = ServletRequestUtils.getStringParameter(request, "sort", "u.id");
		boolean isAsc = ServletRequestUtils.getBooleanParameter(request, "isAsc", true);
		
		List<Member> members = this.pricingService.getMemberList(page, pagelimit, searchfield, search, sort, isAsc);
		int total =  this.pricingService.countMemberList(searchfield, search);
		
		List<Tier> tiers = this.pricingService.getAllTiers(1, -1, null, null, null, true);
		
		data.put("members", members);
		data.put("tiers", tiers);
		data.put("total", total);
		data.put("page", page);
		data.put("pagelimit", pagelimit);
		data.put("sort", sort);
		data.put("isAsc", isAsc);
		data.put("searchfield", searchfield);
		data.put("search", search);
		data.put("plPageRange", 10 );
		
		return new ModelAndView("admin/pricing/tier/account_list", "data", data);
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

