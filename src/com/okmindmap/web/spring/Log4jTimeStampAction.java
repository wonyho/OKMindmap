package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.apache.log4j.Logger; // wait for the upgrade to log4j 2.15.0
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;

public class Log4jTimeStampAction extends BaseAction {
	
//	Logger logger = Logger.getLogger(Log4jTimeStampAction.class); // wait for the upgrade to log4j 2.15.0
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String msg = (String) request.getParameter("message");
		String mapName = (String) request.getParameter("mapName");
		String mapId = (String) request.getParameter("mapId");
		int userId = 0;
		User user = getUser(request);
		
		if(user != null) {
			userId = user.getId();
		}
		
		// wait for the upgrade to log4j 2.15.0
//		logger.info("############### " + msg + " ###############");
//		logger.info(msg + " MAP NAME = " + mapName);
//		logger.info(msg + " MAP ID = " + mapId);
//		logger.info(msg + " USER ID = " + userId);
//		logger.info("############### " + msg + " ###############");
		
		return null;
	}

}
