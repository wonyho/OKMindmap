package com.okmindmap.web.spring.admin.pricing.tier;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.service.PricingService;
import com.okmindmap.web.spring.BaseAction;

public class MemberAddAction extends BaseAction {
	private PricingService pricingService;
	
	
		
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		int tierId = (Integer) getRequiredParam(request, "id", Integer.class);
		Tier tier = this.pricingService.getTier(tierId);
		
		User adminuser = getUser(request);
		if(adminuser.getRoleId()!=1 || tier == null) {
			data.put("messag", "권한이 없습니다.");
			data.put("url", "/");
			return new ModelAndView("error/index", "data", data);
		}
		
		String formdata = ServletRequestUtils.getStringParameter(request, "formdata", null);
		
		if(formdata != null) {
			BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
			
			JSONObject json = new JSONObject(formdata);
			
			this.pricingService.insertTierMember(tier.getId(), json.getInt("userid"), true, json.getLong("expiry_date"));
			
			out.write(toBytes("{\"status\":\"ok\"}"));
			out.flush();
			out.close();
			
			return null;
		}
		
		int totalNotMembers =  0;
		int page = ServletRequestUtils.getIntParameter(request, "page", 1);
		
		int pagelimit = 10;
		String search = ServletRequestUtils.getStringParameter(request, "search");
		String searchfield = ServletRequestUtils.getStringParameter(request, "searchfield");
		String sort = ServletRequestUtils.getStringParameter(request, "sort", "created");
		boolean isAsc = ServletRequestUtils.getBooleanParameter(request, "isAsc", false);
		
		data.put("notMembers", this.pricingService.getNotTierMembers(tierId,  page, pagelimit, searchfield, search, sort, isAsc));
		totalNotMembers = this.pricingService.countNotTierMembers(tierId, searchfield, search);
		
		data.put("tier", tier);
		data.put("searchfield", searchfield);
		data.put("search", search);
		data.put("sort", sort);
		data.put("isAsc", isAsc);		
		data.put("totalNotMembers", totalNotMembers);
		data.put("page", page);		
		data.put("pagelimit", pagelimit);
		data.put("plPageRange", 10 );
		
		return new ModelAndView("admin/pricing/tier/add_member", "data", data);
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

