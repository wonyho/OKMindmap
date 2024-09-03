package com.okmindmap.servlet;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.service.helper.MindmapServiceHelper;
import com.okmindmap.service.helper.PricingServiceHelper;

public class SVGServlet extends HttpServlet {

	private static final long serialVersionUID = 378444570547257806L;
	private MindmapService mindmapService;
	private PricingService pricingService;
	
	public void init(ServletConfig servletConfig) throws ServletException {
		super.init(servletConfig);
		
		mindmapService = MindmapServiceHelper.getMindMapService(servletConfig.getServletContext());
		pricingService = PricingServiceHelper.getPricingService(servletConfig.getServletContext());
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws IOException, ServletException {
		
		String svg = request.getParameter("svg");
		String mapId = request.getParameter("id");
		String type = request.getParameter("type");
//		System.out.println();
//		System.out.println(mapId);
//		System.out.println(type);
//		System.out.println(svg.length());
//		System.out.println("=====================");
		
		Object obj = request.getSession().getAttribute("user");
		User user = null;
		if(obj != null) {
			user = (User)obj;
		}
		
		try {
			Map map = this.mindmapService.getMap(Integer.parseInt(mapId));
			String fileName = map.getName();
			
			if(user != null) {
				this.pricingService.setPolicyValue(user.getId(), "map.export_total", this.pricingService.getPolicyValue(user.getId(), "map.export_total") + 1);
			}
			
			if("png".equals(type)){
				if(user != null) {
					this.pricingService.setPolicyValue(user.getId(), "export.png", this.pricingService.getPolicyValue(user.getId(), "export.png") + 1);
				}
				
				toPNG(response, svg, fileName);
			} else {	
				if(user != null) {
					this.pricingService.setPolicyValue(user.getId(), "export.svg", this.pricingService.getPolicyValue(user.getId(), "export.svg") + 1);
				}
				
				toSVG(response, svg, fileName);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void toSVG(HttpServletResponse response, String svg, String fileName) throws IOException {
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Type", "image/svg+xml");
		response.setHeader( "Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8") + ".svg\"" );
		
		ByteArrayInputStream in = new ByteArrayInputStream(unescape(svg));
		BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());

		byte[] data = new byte[8000];
		for( int length = in.read(data, 0, data.length); length > 0; length = in.read(data, 0, data.length)) {
			out.write(data, 0, length);
		}
		
		out.flush();
		out.close();
	}
	
	private void toPNG(HttpServletResponse response, String svg, String fileName) throws IOException {

		response.setHeader("Content-type","image/png"); 
		response.setHeader( "Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8") + ".png\"" );
	   
	    svg = svg.replace(' ', '+');
	   	    
	    byte[] decoded = org.apache.commons.codec.binary.Base64.decodeBase64(svg);
	    
	    ByteArrayInputStream in = new ByteArrayInputStream(decoded);
	    BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
	    
	    byte[] data = new byte[8000];
		for( int length = in.read(data, 0, data.length); length > 0; length = in.read(data, 0, data.length)) {
			out.write(data, 0, length);
		
		} 
		
	}
	
	private byte[] unescape(String src) { 
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
		
		try {
			return tmp.toString().getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return tmp.toString().getBytes();
	}
	
	
}
