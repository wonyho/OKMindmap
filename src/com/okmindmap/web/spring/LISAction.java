package com.okmindmap.web.spring;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpResponseException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.imsglobal.lti.launch.LtiOauthSigner;
import org.imsglobal.lti.launch.LtiSigner;
import org.imsglobal.pox.IMSPOXRequest;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Attribute;
import com.okmindmap.model.LisGrade;
import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.LisService;
import com.okmindmap.service.MindmapService;

import oauth.signpost.commonshttp.CommonsHttpOAuthConsumer;
import oauth.signpost.http.HttpParameters;


public class LISAction  extends BaseAction {

	private MindmapService mindmapService;
	private LisService lisService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	public void setLisService(LisService lisService) {
		this.lisService = lisService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		//Get secret key
		String mapid = request.getParameter("map");		
		String nodeid = request.getParameter("node");
	    if(nodeid == null)
	    	return null;
	    Node node = this.mindmapService.getNode(Integer.parseInt(nodeid), false);		    
//		System.out.print("mapid: ");
		
		if(node == null)
			return null;	
		String secret = null;
		List<Attribute> attrs = node.getAttributes();
		for (int i = 0; i < attrs.size(); i++)
			if (attrs.get(i).getName().equals("secret")) {
				secret = attrs.get(i).getValue();
					break;
			}
		
		if (secret == null)
			return null;
		String key = "OKMindmap:" + mapid + ":"  + node.getId();
		//Handle request		
		IMSPOXRequest req = new IMSPOXRequest(key, secret, request);
		
		if (req.valid) {
			String body  = req.getPostBody();
			//Handle body
			String score = "";
			LisGrade lis = new LisGrade();
			int start = body.indexOf("<sourcedId>");
			int end = body.indexOf("</sourcedId>");
			if(start > -1 && end > start) {
				String GUID = body.substring(start + "<sourcedId>".length(), end);
				String[] list = GUID.split(":");
//				System.out.println(GUID);
				
				lis.setUserid(Integer.parseInt(list[0]));
				lis.setMapid(Integer.parseInt(list[1]));
				lis.setNodeid(Integer.parseInt(list[2]));
				lis.setLisResultSourcedid(GUID);
			}
			start = body.indexOf("<textString>");
			end = body.indexOf("</textString>");
			if(start > -1 && end > start) {
				score = body.substring(start + "<textString>".length(), end);
				lis.setScore(Double.parseDouble(score));
			}
			boolean result = lisService.insertLisGrade(lis);
			if(result) {
				response.setContentType("text");
			    response.setCharacterEncoding("UTF-8");
			    response.getWriter().write("success");
			    return null;
			}
		} else {
			//error: Message is invalid 
		}
		response.setContentType("text");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write("failed");
		return null;
	}	
}
