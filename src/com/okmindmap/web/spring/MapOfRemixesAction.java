package com.okmindmap.web.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.MindmapDigester;
import com.okmindmap.dao.MindmapDAO;
import com.okmindmap.model.Attribute;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.util.EscapeUnicode;

public class MapOfRemixesAction extends BaseAction {

	private MindmapService mindmapService;
	private RepositoryService repositoryService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}
	
	private Node createNode(String text) {
		  String identity = "ID_" + Integer.toString(new Random().nextInt(2000000000));
		  long created = new Date().getTime();
		  
		  Node node = new Node();
		  node.setText(text);
		  node.setIdentity(identity);
		  node.setCreated( created );
		  node.setModified( created );
		  
		  return node;
	}
	
	private void updateNodes(Integer mapId, Integer mapOfRemixId, Node node) {
		MindmapDAO mindmapDAO = this.mindmapService.getMindmapDAO();
		List<Attribute> attrs = mindmapDAO.getAttributes("remixMap", String.valueOf(mapId));
		
		for(Attribute attr : attrs){
			Node attrNode = mindmapService.getNode(attr.getNodeId(), false);
			Map map = mindmapService.getMap(attrNode.getMapId());
			if(map != null) {
				Node tempNode = createNode(map.getName());
				tempNode.setLink(this.repositoryService.baseUrl() + "/map/" + map.getKey());
				int newNodeId = this.mindmapService.newNodeAfterSibling(mapOfRemixId, tempNode, node.getIdentity(), null);
				
				Node newNode = mindmapService.getNode(newNodeId, false);
				this.updateNodes(map.getId(), mapOfRemixId, newNode);
			}
		}
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		response.setContentType("application/json");
		
		String mapId = request.getParameter("mapId");
		String mapOfRemixesId = request.getParameter("mapOfRemixes");
		
		User user = getUser(request);
		Map map = mindmapService.getMap(Integer.parseInt(mapId));
		User owner = mindmapService.getMapOwner(Integer.parseInt(mapId));
		Map mapOfRemixes = null;
		String url = "";
		
		if(user != null && map != null && owner != null && owner.getId() == user.getId()) {			
			if(!"".equals(mapOfRemixesId)) {
				mapOfRemixes = mindmapService.getMap(Integer.parseInt(mapOfRemixesId));
			}
			
			if(mapOfRemixes == null){
				String mapofremixesText = map.getName() + ": " + getMessage("menu.mindmap.mapofremixes", null);
				int newMapId = mindmapService.newMap(mapofremixesText, user.getId());
				mindmapService.updateMapStyle(newMapId, "jHTreeLayout");
				mapOfRemixes = mindmapService.getMap(newMapId);
				
				Node mapOfRemixesRoot = mapOfRemixes.getNodes().get(0);
				mapOfRemixesRoot.setLink(this.repositoryService.baseUrl() + "/map/"+map.getKey());
				
				Attribute mapOfRemixesRootAttr = new Attribute();
				mapOfRemixesRootAttr.setNodeId(mapOfRemixesRoot.getId());
				mapOfRemixesRootAttr.setName("remixesOfMap");
				mapOfRemixesRootAttr.setValue(String.valueOf(map.getId()));
				
				mapOfRemixesRoot.addAttribute(mapOfRemixesRootAttr);
				mindmapService.updateNode(mapOfRemixes.getId(), mapOfRemixesRoot);
				
				// update mapOfRemixes attribute for map
				ArrayList<Attribute> attrs = new ArrayList<Attribute>();
				Node root = map.getNodes().get(0);
				
				for(Attribute attr : root.getAttributes()) {
					if(!"mapOfRemixes".equals(attr.getName())) {
						attrs.add(attr);
					}
				}
				
				Attribute attr = new Attribute();
				attr.setNodeId(root.getId());
				attr.setName("mapOfRemixes");
				attr.setValue(String.valueOf(mapOfRemixes.getId()));
				
				attrs.add(attr);
				
				root.setAttributes(attrs);
				mindmapService.updateNode(map.getId(), root);
			} else {
				for(Node n: mapOfRemixes.getNodes().get(0).getChildren()) {
					mindmapService.deleteNode(mapOfRemixes.getId(), n);
				}
			}
			
			this.updateNodes(map.getId(), mapOfRemixes.getId(), mapOfRemixes.getNodes().get(0));
			
			url = request.getScheme() + "://" + this.repositoryService.baseUrl() + "/map/"+mapOfRemixes.getKey();
		}
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("{");
		buffer.append("\"redirect\":\"" + url + "\"" );
		buffer.append("}");
		
		response.getOutputStream().write(buffer.toString().getBytes());
		
		return null;
	}
	
}
