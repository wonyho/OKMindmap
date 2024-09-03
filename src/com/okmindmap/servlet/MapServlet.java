package com.okmindmap.servlet;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;

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

@SuppressWarnings("serial")
public class MapServlet extends HttpServlet {
	private MindmapService mindmapService;
	private PricingService pricingService;
	
	public void init(ServletConfig servletConfig) throws ServletException {
		super.init(servletConfig);
		
		mindmapService = MindmapServiceHelper.getMindMapService(servletConfig.getServletContext());
		pricingService = PricingServiceHelper.getPricingService(servletConfig.getServletContext());
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String mapId = request.getParameter("id");
		String lazy = request.getParameter("lazy");
		
		Object obj = request.getSession().getAttribute("user");
		User user = null;
		if(obj != null) {
			user = (User)obj;
		}
		
		if(user != null) {
			this.pricingService.setPolicyValue(user.getId(), "export.freemind", this.pricingService.getPolicyValue(user.getId(), "export.freemind") + 1);
			this.pricingService.setPolicyValue(user.getId(), "map.export_total", this.pricingService.getPolicyValue(user.getId(), "map.export_total") + 1);
		}
		
		boolean allNode = true;
		if(lazy != null && lazy.trim().toLowerCase().equals("on")) {
			allNode = false;
		}
		
		Map map = this.mindmapService.getMap( Integer.parseInt(mapId), allNode );
		
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Content-Type", "application/x-freemind");
		response.setDateHeader("Expires", 0);
//		response.setHeader("Content-Disposition", "attachment; filename=\""	+ URLEncoder.encode(map.getName(), "UTF-8") + "\"");
		
//		logger.info(map.toXml());
		ByteArrayInputStream in = new ByteArrayInputStream(map.toXml().getBytes());
		BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
//		out.write(map.toXml().getBytes());
		byte[] data = new byte[4096];
		for( int length = in.read(data, 0, data.length); length > 0; length = in.read(data, 0, data.length)) {
			out.write(data, 0, length);
		}
		
		out.flush();
		out.close();
	}
}
