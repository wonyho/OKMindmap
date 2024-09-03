package com.okmindmap.servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Properties;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.apache.log4j.Logger; // wait for the upgrade to log4j 2.15.0

import com.okmindmap.MindmapDigester;
import com.okmindmap.export.ExportHTML;
import com.okmindmap.export.ExportPersionalPpt;
import com.okmindmap.export.ExportPpt;
import com.okmindmap.export.ExportTWIKI;
import com.okmindmap.model.Map;
import com.okmindmap.model.Repository;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.service.helper.MindmapServiceHelper;
import com.okmindmap.service.helper.PricingServiceHelper;

public class ExportServlet extends HttpServlet {

	private static final long serialVersionUID = 4174746009699292841L;

	private MindmapService mindmapService;
	private PricingService pricingService;
//	Logger logger; // wait for the upgrade to log4j 2.15.0

	public void init(ServletConfig servletConfig) throws ServletException {
		super.init(servletConfig);
		
		mindmapService = MindmapServiceHelper.getMindMapService(servletConfig.getServletContext());
		pricingService = PricingServiceHelper.getPricingService(servletConfig.getServletContext());
		
//		logger = Logger.getLogger(ExportServlet.class); // wait for the upgrade to log4j 2.15.0
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws IOException, ServletException {
		
		String format = request.getParameter("format");
		String mapId = request.getParameter("id");
		
		Map map = this.mindmapService.getMap( Integer.parseInt(mapId));
		
		OutputStream out = response.getOutputStream();
		
		Object obj = request.getSession().getAttribute("user");
		User user = null;
		if(obj != null) {
			user = (User)obj;
		}
		
		if("html".equals(format)) {
			response.setContentType("application/zip"); 
			
			try {
				String realPath = getServletContext().getRealPath("/");
				Properties prop = new Properties();
				prop.put("iconDir", realPath + "images/icons");
				prop.put("xsltFileName", "toxhtml.xsl");
				prop.put("files", "marktree.js,minus.png,plus.png,ilink.png,treestyles.css");
				prop.put("filePrefix", realPath + "WEB-INF/classes/com/okmindmap/export/");
				ExportHTML html = new ExportHTML();
				html.transform(map, prop, out);
				
				if(user != null) {
					this.pricingService.setPolicyValue(user.getId(), "export.html", this.pricingService.getPolicyValue(user.getId(), "export.html") + 1);
					this.pricingService.setPolicyValue(user.getId(), "map.export_total", this.pricingService.getPolicyValue(user.getId(), "map.export_total") + 1);
				}
			} catch(Exception e) {
//				logger.error(e); // wait for the upgrade to log4j 2.15.0
			}
			
		} else if("twiki".equals(format)) {
			response.setContentType("text/twi"); 
			
			try {
				String realPath = getServletContext().getRealPath("/");
				Properties prop = new Properties();
				prop.put("xsltFileName", "mm2twiki.xsl");
				prop.put("filePrefix", realPath + "WEB-INF/classes/com/okmindmap/export/");
				ExportTWIKI twiki = new ExportTWIKI();
				twiki.transform(map, prop, out);
				
			} catch(Exception e) {
//				logger.error(e); // wait for the upgrade to log4j 2.15.0
			}
		} else if("ppt".equals(format)) {
			response.setContentType("application/vnd.openxmlformats-officedocument.presentationml.presentation");
			
			String font = request.getParameter("font");
			String font1 = request.getParameter("font1");
			String font2 = request.getParameter("font2");
			String font3 = request.getParameter("font3");
			String lines = request.getParameter("lines");
			String divide = request.getParameter("divide");
			String perSlide = request.getParameter("perSlide");

			String realPath = getServletContext().getRealPath("/");
			Properties prop = new Properties();
			prop.put("realPath", realPath);

			
			if(perSlide.equals("true")) {
				String theme2 = request.getParameter("theme2");
				ExportPersionalPpt ppt = new ExportPersionalPpt(this.mindmapService);
				ppt.setFONT_SIZE(Double.valueOf(font));
				ppt.addFontSizeLevel(Double.valueOf(font1));
				ppt.addFontSizeLevel(Double.valueOf(font2));
				ppt.addFontSizeLevel(Double.valueOf(font3));
				ppt.addFontSizeLevel(14.);
				ppt.addFontSizeLevel(14.);
				ppt.addFontSizeLevel(14.);
				ppt.setDivide(divide.equals("true") || divide.equals("True"));
				ppt.setMAX_ROW(Integer.parseInt(lines) - 1);
				ppt.setThemeSource(theme2.replace("--", "/"));
				ppt.transform(map, prop, out);
			}else {
				String theme = request.getParameter("theme");
				ExportPpt ppt = new ExportPpt(this.mindmapService);
				ppt.setFONT_SIZE(Double.valueOf(font));
				ppt.addFontSizeLevel(Double.valueOf(font1));
				ppt.addFontSizeLevel(Double.valueOf(font2));
				ppt.addFontSizeLevel(Double.valueOf(font3));
				ppt.addFontSizeLevel(14.);
				ppt.addFontSizeLevel(14.);
				ppt.addFontSizeLevel(14.);
				ppt.setDivide(divide.equals("true") || divide.equals("True"));
				ppt.setMAX_ROW(Integer.parseInt(lines) - 1);
				ppt.setThemeSource(theme);
				ppt.transform(map, prop, out);
			}
			
			if(user != null) {
				this.pricingService.setPolicyValue(user.getId(), "export.ppt", this.pricingService.getPolicyValue(user.getId(), "export.ppt") + 1);
				this.pricingService.setPolicyValue(user.getId(), "map.export_total", this.pricingService.getPolicyValue(user.getId(), "map.export_total") + 1);
			}
			
			
//			Try to change for Issue: Make PPT as PP on redmine
//			ExportPPT ppt = new ExportPPT(this.mindmapService);
//			ppt.transform(map, prop, out);
//			Apply new revision for PPT as PP
			
			// nvhoang
			// because it is not used for edit export ppt
//			try {
//				// 한글 깨지는 문제 때문에....
//				map = MindmapDigester.parseMap(map.toXml());
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
		
			
		} else {
			out.write("Not Supported!".getBytes());
		}
		
		out.close();
	}
}
