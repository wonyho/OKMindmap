package com.okmindmap.servlet;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.okmindmap.dao.MindmapDAO;
import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.UserService;
import com.okmindmap.service.helper.MindmapServiceHelper;
import com.okmindmap.service.helper.UserServiceHelper;

@SuppressWarnings("serial")
public class ExportUserDataServlet extends HttpServlet {
	private MindmapService mindmapService;
	private UserService userService;
	
	public void init(ServletConfig servletConfig) throws ServletException {
		super.init(servletConfig);
		
		mindmapService = MindmapServiceHelper.getMindMapService(servletConfig.getServletContext());
		userService = UserServiceHelper.getUserService(servletConfig.getServletContext());
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String all = request.getParameter("all");
		String createdFrom = request.getParameter("createdFrom"); 
		String createdTo = request.getParameter("createdTo");
		
		String exportUsername = request.getParameter("exportUsername");

		User user = null;
		Object sessionUser = request.getSession().getAttribute("user");
		if(sessionUser != null) user = (User) sessionUser;
		
		OutputStream out = response.getOutputStream();

		if(user != null && !"guest".equals(user.getUsername())) {
			
			if(user.getRoleId() ==1 && exportUsername != null) {
				user  = this.userService.get(exportUsername);
			}
			
			
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Pragma", "no-cache");
			response.setContentType("application/zip"); 
			response.setDateHeader("Expires", 0);
			
			MindmapDAO mindmapDAO = this.mindmapService.getMindmapDAO();
			List<Map> data = new ArrayList<Map>();
			if("1".equals(all)) {
				data = mindmapDAO.getUserMaps(user.getId());
			} else if(createdFrom != null && createdTo != null) {
				data = mindmapDAO.getUserMaps(user.getId(), Long.parseLong(createdFrom), Long.parseLong(createdTo));
			}
			
			ZipOutputStream zOut = new ZipOutputStream(out);
			for(Map map : data) {
				Map m = this.mindmapService.getMap(map.getId(), true);
				byte[] mapData = m.toXml().getBytes();
				
				ZipEntry mmfile = new ZipEntry(m.getId() + "-" + m.getName() + ".mm"); 
	        	mmfile.setSize(mapData.length);
	        	zOut.putNextEntry(mmfile);
	        	zOut.write(mapData);
	        	zOut.closeEntry();
			}
			zOut.close();
			
		} else {
			out.write("Not Supported!".getBytes());
		}
		out.close();
	}
}
