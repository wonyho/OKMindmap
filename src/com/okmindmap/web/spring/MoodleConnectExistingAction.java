package com.okmindmap.web.spring;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Attribute;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.GroupService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.ShareService;
import com.okmindmap.moodle.MoodleService;
import org.json.*;
import java.util.ArrayList;

public class MoodleConnectExistingAction extends BaseAction {
	private MindmapService mindmapService;
	private ShareService shareService;
	private GroupService groupService;
	private OKMindmapService okmindmapService;
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
	}
	
	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	public void setShareService(ShareService shareService) {
		this.shareService = shareService;
	}
	public void setGroupService(GroupService groupService) {
		this.groupService = groupService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		User user = getUser(request);
		String mapId = request.getParameter("map_id");
		String courseId = request.getParameter("course_id");
		String moodleUrl = request.getParameter("moodleUrl");
		
		Map map = this.mindmapService.getMap(Integer.parseInt(mapId));
		
		String status = "false";
		String map_key = "";
		
		if(map != null && user != null) {
			User owner = this.mindmapService.getMapOwner(map.getId());
			if(owner != null && owner.getUsername().equals(user.getUsername()) && moodleUrl!=null && courseId != null) {
				MoodleService moodleService = new MoodleService(user, this.okmindmapService, this.mindmapService, this.userService, this.shareService, this.groupService);
				
				moodleService.delete_course_connection(map.getId());
//				this.delete_node_connection(map.getId(), map.getNodes().get(0));
				for(Node n: this.mindmapService.getChildNodes(map.getNodes().get(0).getId(), false)) {
					this.delete_node_connection(map.getId(), n);
				}
				
				map = this.mindmapService.getMap(Integer.parseInt(mapId));
				moodleService.set_course_connection(map, moodleUrl, Integer.parseInt(courseId));
				
				status = "true";
				map_key = map.getKey();
			}
		}
		
		response.setContentType("application/json");
		StringBuffer buffer = new StringBuffer();
		buffer.append("{");
		buffer.append("\"status\":" + status + ", \"map_key\": \"" + map_key + "\"");
		buffer.append("}");
		
		response.getOutputStream().write(buffer.toString().getBytes());
		
		return null;
	}
	
//	public void delete_node_connection(int mapId, Node node) {
//		ArrayList<Attribute> attrs = new ArrayList<Attribute>();
//		for(Attribute attr: node.getAttributes()) {
//			if(!attr.getName().startsWith("moodle")) {
//				attrs.add(attr);
//			}
//		}
//		node.setAttributes(attrs);
//		this.mindmapService.updateNode(mapId, node);
//	}
	
	public void delete_node_connection(int mapId, Node node) {
		for(Attribute attr: node.getAttributes()) {
			if(attr.getName().startsWith("moodle")) {
				this.mindmapService.deleteNode(mapId, node);
//				System.out.println("Disconnected node");
				break;
			}
		}
	}
}
