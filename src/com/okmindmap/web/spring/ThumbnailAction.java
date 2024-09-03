package com.okmindmap.web.spring;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.service.MindmapService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.thumb.ThumbnailTranscoder;

public class ThumbnailAction extends BaseAction {
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
		
		String mapId = request.getParameter("id");
		String svg = request.getParameter("svg");
		String base64 = request.getParameter("base64");
		String dx = request.getParameter("dx");
		String dy = request.getParameter("dy");
		
		int width = 500;
		int height = 300;
		
		// 저장경로
		String path = this.repositoryService.getPath() + "/map-files/" + mapId + "/thumb/";
		File file = new File(path);
        file.mkdirs();
		
        if(svg != null) {
			byte[] decoded = org.apache.commons.codec.binary.Base64.decodeBase64(svg);	
			svg = this.unescape(new String(decoded));
			
			ThumbnailTranscoder.transcode(svg, width, height, Integer.parseInt(dx), Integer.parseInt(dy), new FileOutputStream(path + "thumb.png"));
        } else if(base64 != null) {
        	ThumbnailTranscoder.transcodeBase64(base64, width, height, Integer.parseInt(dx), Integer.parseInt(dy), new FileOutputStream(path + "thumb.png"));
        }
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("success", "1");
		
		ModelAndView view = new ModelAndView();
		view.setViewName("jsonResponse");
		view.addAllObjects(resultMap);
		
		return view;
	}
	
	private String unescape(String src) { 
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
