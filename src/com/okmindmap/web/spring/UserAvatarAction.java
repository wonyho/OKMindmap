package com.okmindmap.web.spring;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Repository;
import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.service.UserService;

public class UserAvatarAction extends BaseAction {

	private UserService userService = null;
	private RepositoryService repositoryService;
	
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	public RepositoryService getRepositoryService() {
		return repositoryService;
	}

	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int userid = Integer.parseInt(request.getParameter("userid"));
		
		User user = this.userService.get(userid);
		String path = null;
		String default_path = request.getServletContext().getRealPath("/") + "theme/dist/images/icons/user-2.png";
		
		if(user != null) {
			List<UserConfigData> configData = this.userService.getUserConfigData(userid);
			
			Iterator<UserConfigData> it = configData.iterator();
			while(it.hasNext() && path == null) {
				UserConfigData u = it.next();
				if("avatar".equals(u.getFieldname())) {
					Repository repo = this.repositoryService.loadFile(Integer.parseInt(u.getData()));
					path = repo.getPath();
				}
			}
		}
		
		if(path == null) path = default_path;
		
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Type", "image/png");
		//response.setHeader( "Content-Disposition", "attachment; filename=\"" + URLEncoder.encode("thumb.png", "UTF-8") + "\"" );
		
		File f = new File(path);
		if(!f.exists() || f.length() == 0) { 
			path = default_path;
		}
		
		FileInputStream in = new FileInputStream(path);
		BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());

		byte[] data = new byte[4096];
		for( int length = in.read(data, 0, data.length); length > 0; length = in.read(data, 0, data.length)) {
			out.write(data, 0, length);
		}
		
		out.flush();
		out.close();
		
		return null;
		
	}
}
