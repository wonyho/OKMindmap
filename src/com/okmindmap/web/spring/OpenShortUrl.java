package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.ModelAndView;
import com.okmindmap.api.shorturl.OkmmSite;
import com.okmindmap.model.Map;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.RepositoryService;
public class OpenShortUrl extends BaseAction {
	
	private MindmapService mindmapService;
	private RepositoryService repositoryService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String map_short = request.getParameter("id");
		int mapid = OkmmSite.decodeMapId(map_short);
		Map m = this.mindmapService.getMap(mapid);
		String base = this.getBaseUrl(request);
		if(m != null) {
			response.sendRedirect(base + "/map/" + m.getKey());
			return null;
		}
		response.sendRedirect(base);
		return null;
	}
	
	public String getBaseUrl(HttpServletRequest request) {
	    String scheme = request.getScheme();
	    return scheme + "://" + this.repositoryService.baseUrl();
	}
}
