package com.okmindmap.web.spring;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.MindmapDigester;
import com.okmindmap.model.Attribute;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.util.EscapeUnicode;

public class RemixMindmapAction extends BaseAction {

	private MindmapService mindmapService;
	private PricingService pricingService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		response.setContentType("application/json");
		
		String title = request.getParameter("title");
		String remixMap = request.getParameter("remixMap");
		String link = request.getParameter("link");
		
		User user = getUser(request);
		
		JSONObject remix_policy =this.pricingService.getCurrentTiersofUser(user.getId(), "map_remix");
		int limit_remix = remix_policy != null ? remix_policy.getInt("value"):0;
		int countRemixMaps = this.mindmapService.countRemixMaps(user.getId());
		if(limit_remix > 0 && limit_remix <= countRemixMaps) {
			StringBuffer buffer = new StringBuffer();
			buffer.append("{");
			buffer.append("\"status\":\"false\"" );
			buffer.append(",");
			
			buffer.append("\"message\":\"Your account can only remix up to " + limit_remix + " maps.\"" );
			buffer.append("}");
			
			response.getOutputStream().write(buffer.toString().getBytes());
			return null;
		}
		
		int countDuplicatedMapName = mindmapService.countDuplicateMapName(user.getId(), title);
	
		
		String xml = request.getParameter("xml");
		
		byte[] decoded = org.apache.commons.codec.binary.Base64.decodeBase64(xml);
		xml = unescape(new String(decoded));
		
		
		Map map = MindmapDigester.parseMap(xml);
		map.setName(title);
		map.getNodes().get(0).setLink(link);
		
		ArrayList<Attribute> attrs = new ArrayList<Attribute>();
		Node root = map.getNodes().get(0);
		
		for(Attribute attr : root.getAttributes()) {
			if(!"remixMap".equals(attr.getName()) && !"mapOfRemixes".equals(attr.getName())) {
				attrs.add(attr);
			}
		}
		
		if(remixMap != null) {
			Attribute attr = new Attribute();
			attr.setNodeId(root.getId());
			attr.setName("remixMap");
			attr.setValue(remixMap);
			
			attrs.add(attr);
		}
		
		map.getNodes().get(0).setAttributes(attrs);
		int mapId = mindmapService.saveMap(map, user.getId());

		map = mindmapService.getMap(mapId);

		StringBuffer buffer = new StringBuffer();
		buffer.append("{");
		buffer.append("\"id\":\"" + mapId + "\"" );
		buffer.append(",");
		buffer.append("\"name\":\"" + EscapeUnicode.text(title) + "\"" );
		buffer.append(",");
				
		buffer.append("\"status\":\"" + (countDuplicatedMapName == 0?"ok": "duplicated") + "\"" );
		buffer.append(",");
		
		buffer.append("\"redirect\":\"" + request.getContextPath() + "/map/" + map.getKey() + "\"" );
		buffer.append("}");
		
		response.getOutputStream().write(buffer.toString().getBytes());
		
		//response.sendRedirect(request.getContextPath() + "/map/" + map.getKey());
		
		return null;
	}

	public String unescape(String src) { 
		StringBuffer tmp = new StringBuffer(); 
		tmp.ensureCapacity(src.length()); 

		int lastPos = 0, pos = 0; 
		char ch;

		while (lastPos < src.length()) {
			pos = src.indexOf("%", lastPos);
			if (pos == lastPos) {
				if (src.charAt(pos+1) == 'u') {
					ch = (char) Integer.parseInt(src.substring(pos+2, pos+6), 16); 
					tmp.append(ch);
					lastPos = pos+6; 
				} else { 
					ch = (char) Integer.parseInt(src.substring(pos+1, pos+3), 16); 
					tmp.append(ch); 
					lastPos = pos+3; 
				} 
			} else { 
				if (pos == -1) { 
					tmp.append(src.substring(lastPos)); 
					lastPos = src.length(); 
				} else { 
					tmp.append(src.substring(lastPos, pos)); 
					lastPos = pos; 
				} 
			} 
		} 
		return tmp.toString(); 
	}
}
