package com.okmindmap.web.spring.admin.pricing.tier;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.StringUtils;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.User;
import com.okmindmap.service.PricingService;
import com.okmindmap.web.spring.BaseAction;

public class ListAction extends BaseAction {
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
		if("deletetier".equals(action)) {
			BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
			
			String id = request.getParameter("id");
			if(!StringUtils.isNullOrEmpty(id)) {
				this.pricingService.deleteTier(Integer.parseInt(id));
				this.pricingService.deleteTierAbilities(Integer.parseInt(id));
			}
			
			out.write(toBytes("{\"status\":\"ok\"}"));
			out.flush();
			out.close();
			
			return null;
		}
		
		int page = ServletRequestUtils.getIntParameter(request, "page", 1);
		int pagelimit = ServletRequestUtils.getIntParameter(request, "pagelimit", 10);
		String search = ServletRequestUtils.getStringParameter(request, "search");
		String searchfield = ServletRequestUtils.getStringParameter(request, "searchfield", "name");
		
		String sort = ServletRequestUtils.getStringParameter(request, "sort", "created");
		boolean isAsc = ServletRequestUtils.getBooleanParameter(request, "isAsc", false);
		
		List<Tier> tiers = this.pricingService.getAllTiers(page, pagelimit, searchfield, search, sort, isAsc);
		int total =  this.pricingService.countTiers(searchfield, search);
		
		data.put("tiers", tiers);
		data.put("total", total);
		data.put("page", page);
		data.put("pagelimit", pagelimit);
		data.put("sort", sort);
		data.put("isAsc", isAsc);
		data.put("searchfield", searchfield);
		data.put("search", search);
		data.put("plPageRange", 10 );
		
		return new ModelAndView("admin/pricing/tier/list", "data", data);
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

