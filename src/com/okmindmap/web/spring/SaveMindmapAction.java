package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.ActionDigester;
import com.okmindmap.action.Action;
import com.okmindmap.action.MoveAction;
import com.okmindmap.action.NewAction;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.RichContent;
import com.okmindmap.model.User;
import com.okmindmap.moodle.MoodleService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.service.MindmapService;

public class SaveMindmapAction extends BaseAction {

	private OKMindmapService okmindmapService;
	private MindmapService mindmapService;
	private RepositoryService repositoryService;

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
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
//		String mapId = request.getParameter("mapId");
		String xml = request.getParameter("action");
		String actionList = request.getParameter("actionList");
		if(actionList == null) actionList = "None";
		if(actionList.equals("hasList")) {
//			System.out.println(actionList);
			JSONArray mJsonArray = new JSONArray(xml);
			String addr = request.getRemoteAddr();
			User user = getUser(request);
			for (int i = 0; i < mJsonArray.length(); i++) {
			    xml = mJsonArray.getString(i);
//			    System.out.println(i);
//			    System.out.println(xml);
			    byte[] decoded = org.apache.commons.codec.binary.Base64.decodeBase64(xml);
				xml = unescape(new String(decoded));
				Action action = ActionDigester.parseAction(xml); 
				processAction(action, addr, user);
			}
		}else {
			byte[] decoded = org.apache.commons.codec.binary.Base64.decodeBase64(xml);
			if(decoded != null) {
				xml = unescape(new String(decoded));
				
				Action action = ActionDigester.parseAction(xml); 
				String addr = request.getRemoteAddr();
				User user = getUser(request);
				
				int result = processAction(action, addr, user);
				
				response.setContentType("application/json");

				// 결과값을 리턴한다.
				// -1 이 리턴되는 경우는 에러가 발생한 경우이다.
				String res = "{\"status\": "+(Integer.toString(result))+"}";
				response.getOutputStream().write(res.getBytes());
			}
		}
		return null;
	}
	
	private int processAction(Action action, String addr, User user) {
		String name = action.getName();
		Node node = action.getNode();
		int mapId = action.getMapId();
		
		long currentTime = getCurrentTime();
		
		// nvhoang
		MoodleService moodleService = new MoodleService(user, this.okmindmapService, this.mindmapService);
		JSONObject moodleConnection = moodleService.getMoodleConnection(node);
		// nvhoang
		
		node.setModified(currentTime);
		if(!user.isGuest()) {
			node.setModifier(user.getId());
		}
		node.setModifierIP(addr);
		if(Action.NEW.equals(name)) {
			node.setCreated(currentTime);
			if(!user.isGuest()) {
				node.setCreator(user.getId());
			}
			node.setCreatorIP(addr);
			NewAction nAction = (NewAction)action;
			String parent = nAction.getParent();
			String next = nAction.getNext();
			
			return this.mindmapService.newNodeBeforeSibling(mapId, node, parent, next);
		} else if(Action.EDIT.equals(name)) {
			int res = this.mindmapService.updateNode(mapId, node);
			if(moodleConnection != null) moodleService.updateNode(mapId, node);
			return res;
		} else if(Action.DELETE.equals(name)) {
			if(moodleConnection != null) moodleService.deleteNode(mapId, node);
			String fileId = this.getFileContentId(node);
			if(fileId != null) {
				if(this.mindmapService.canDeleteFileContent("/map/file/"+fileId+"/", mapId)) {
					this.repositoryService.removeFile(Integer.parseInt(fileId));
				}
			}
			fileId = this.getFileAttachedId(node);
			if(fileId != null) {
				if(this.mindmapService.canDeleteFileAttached("/map/file/"+fileId+"/", mapId)) {
					this.repositoryService.removeFile(Integer.parseInt(fileId));
				}
			}
			return this.mindmapService.deleteNode(mapId, node);
		} else if(Action.MOVE.equals(name)) {
			MoveAction nAction = (MoveAction)action;
			String parent = nAction.getParent();
			String next = nAction.getNext();
			
			int res = this.mindmapService.moveNode(mapId, node, parent, next);
			if(moodleConnection != null) moodleService.moveNode(mapId, node, parent, next);
			return res;
		}
		
		return -1;
	}
	
	private long getCurrentTime() {
		long time = System.currentTimeMillis();
		
		return time;
	}
	
	public String unescape(String src) { 
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
	
	private String getFileContentId(Node node) {
		RichContent rc = node.getRichContent();
		if(rc == null) return null;
		String content = rc.getContent();
		int start = content.indexOf("/map/file/");
		if(start > 0) {
			int end = start + 11;
			for(int i=end; i<content.length(); i++) {
				if(content.charAt(i) != '/') end++;
				else break;
			}
			String fileId = content.substring(start + 10, end);
			if(fileId != "") return fileId;
		}
		return null;
	}
	
	private String getFileAttachedId(Node node) {
		String content = node.getFile(); 
		if(content == null) return null;
		int start = content.indexOf("/map/file/");
		if(start > 0) {
			int end = start + 11;
			for(int i=end; i<content.length(); i++) {
				if(content.charAt(i) != '/') end++;
				else break;
			}
			String fileId = content.substring(start + 10, end);
			if(fileId != "") return fileId;
		}
		return null;
	}
}
