package com.okmindmap.web.spring.iot;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.iot.RedFlow;
import com.okmindmap.service.IotService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.web.spring.BaseAction;

public class Providers extends BaseAction {
	
	private OKMindmapService okmindmapService;
	private MindmapService mindmapService;
	private PricingService pricingService;
	private IotService iotService;
	
	public void setIotService(IotService iotService) {
		this.iotService = iotService;
	}
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}
	
	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		User user = getUser(request);
		
		String id = request.getParameter("id");
		String control = request.getParameter("control");
		if(!control.equals("1")) control = "0";
		
		JSONObject iot_policy =this.pricingService.getCurrentTiersofUser(user.getId(), "iot_add");
		int limit_iot = iot_policy != null ? iot_policy.getInt("value") : 0;
		int countIoTMaps = this.mindmapService.countIoTMaps(user.getId());
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		
		if(limit_iot > 0 && limit_iot <= countIoTMaps) {
			data.put("message", "Your account can only create up to " + limit_iot + " iot devices.");
		} else {
			IoT iot = new IoT(this.okmindmapService);
			
			JSONObject res = iot.getProviders(id, control.equals("1"));
			if(res != null) {
				List<RedFlow> userFlows = null;
				if(user != null) {
					if(user.getId() != 2) {
						userFlows = this.iotService.getFlows(user.getId());
						if(res.has("providers")) {
							JSONArray save = new JSONArray();
							JSONArray objs = res.getJSONArray("providers");
							boolean found = false;
							for(int i = 0; i<objs.length(); i++) {
								
								found = false; 
								JSONObject obj = objs.getJSONObject(i);
								System.out.println( "id = " + obj.toString());
								id = obj.getString("id");
								for(RedFlow rf : userFlows) {
									if(id.equals(rf.getFlowId()) || id.equals(rf.getFlowName())) {
										found = true;
									}
								}
								if(found) {
									save = save.put(obj);
									System.out.println(obj.getString("id"));
								}
							}
							res.put("providers", save);
						}
					}
				}
			}
			
			data = iot.toHashMap(res);
		}
		
		data.put("control", control);
		
		return new ModelAndView("iot/providers", "data", data);
	}

}
