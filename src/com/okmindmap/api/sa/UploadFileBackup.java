package com.okmindmap.api.sa;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.Repository;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;

public class UploadFileBackup extends BaseAction {
	protected UserService userService;
	private OKMindmapService okmindmapService;
	private MindmapService mindmapService;
	private RepositoryService repositoryService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {

		User user = getUser(request);
		
		String page = request.getParameter("page");
		String search = request.getParameter("search");
		if("".equals(page) || page == null) page = "1";
		if("".equals(search) || search == null) search = "";
		List<Map> maps =this.mindmapService.Sa_getAllMaps(Integer.parseInt(page), 15, search);
		for(Map map : maps) {
			List<Repository> files = this.mindmapService.Sa_getMapFiles(map.getId());
			map.setCounter("files", files.size());
			List<Node> nodes = this.mindmapService.Sa_getMapNodes(map.getId());
			map.setCounter("nodes", nodes.size());
			nodes = this.mindmapService.Sa_getMapFileNodes(map.getId());	
			map.setCounter("fnodes", nodes.size());
			int lost = 0; int nfiles = 0; int used = 0;
			for(Node node : nodes) {
				String html = node.getText();
				long size = 0;
				if(html != null) {
					size = this.repoIsExistedOnDisk(files, html);
					if(size == 0) lost++;
					nfiles++;
				}
				html = node.getFile();
				if(html != null) {
					size = this.repoIsExistedOnDisk(files, html);
					if(size == 0) lost++;
					nfiles++;
				}
				used += size;
			}
			map.setCounter("lost", lost);
			map.setCounter("nfiles", nfiles);
			map.setCounter("used", used / 1024); // B to KB
		}
		 

		HashMap<String, Object> data = new HashMap<String, Object>();
		int total_map = this.mindmapService.Sa_countAllMaps(search);
		data.put("maps", maps);
		data.put("page", page);
		data.put("search", search);
		data.put("pages", total_map / 15 + (total_map % 15 == 0 ? 0 : 1));
		data.put("rows", total_map);
		return new ModelAndView("sa/filebackup", "data", data);

	}
	
	private long repoIsExistedOnDisk(List<Repository> files, String html) {
		int start = html.indexOf("/map/file/") + 10;
		int end = html.substring(start).indexOf("/") + start;
		if(end > start) {
			int repoid = Integer.parseInt(html.substring(start, end));
			if(repoid > 0) {
				for(Repository file : files) {
					if(file.getId() == repoid) {
						File f = new File(file.getPath());
						if(f.exists()) return (file.getFileSize()); 
					}
				}
				
			}
		}
		return 0;
	}

}
