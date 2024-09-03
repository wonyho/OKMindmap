package com.okmindmap.web.spring;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Map;
import com.okmindmap.model.Repository;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.RepositoryService;

public class ThumbnailDownloadAction extends BaseAction {
	
	private RepositoryService repositoryService;
	private MindmapService mindmapService;
	
	public MindmapService getMindmapService() {
		return mindmapService;
	}

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
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
		
		String mapKey = request.getParameter("key");
		
		Map map = this.mindmapService.getMap(mapKey);
		
		String path = this.repositoryService.getPath() + "map-files/" + map.getId() + "/thumb/thumb.png";
		String default_path = request.getServletContext().getRealPath("/") + "/images/default-thumb.png";
		
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
