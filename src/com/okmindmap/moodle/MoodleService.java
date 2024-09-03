package com.okmindmap.moodle;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.HttpURLConnection;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringEscapeUtils;
import org.imsglobal.lti.launch.LtiOauthSigner;
import org.imsglobal.lti.launch.LtiSigner;
import org.imsglobal.lti.launch.LtiSigningException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Whitelist;

import com.okmindmap.dao.MindmapDAO;
import com.okmindmap.model.Attribute;
import com.okmindmap.model.Category;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.Repository;
import com.okmindmap.model.RichContent;
import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.model.group.Group;
import com.okmindmap.model.group.Member;
import com.okmindmap.model.share.Permission;
import com.okmindmap.model.share.PermissionType;
import com.okmindmap.model.share.Share;
import com.okmindmap.model.share.ShareMap;
import com.okmindmap.service.GroupService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.ShareService;
import com.okmindmap.service.UserService;

public class MoodleService {
	private ShareService shareService;
	private GroupService groupService;
	protected UserService userService;
	private OKMindmapService okmindmapService;
	private MindmapService mindmapService;
	private User user;
	
	public MoodleService(User user, OKMindmapService okmindmapService, MindmapService mindmapService){
		this.user = user;
		this.okmindmapService = okmindmapService;
		this.mindmapService = mindmapService;
	}
	public MoodleService(User user, OKMindmapService okmindmapService, MindmapService mindmapService, UserService userService){
		this.user = user;
		this.okmindmapService = okmindmapService;
		this.mindmapService = mindmapService;
		this.userService = userService;
	}
	public MoodleService(User user, OKMindmapService okmindmapService, MindmapService mindmapService, UserService userService, ShareService shareService, GroupService groupService){
		this.user = user;
		this.okmindmapService = okmindmapService;
		this.mindmapService = mindmapService;
		this.userService = userService;
		this.shareService = shareService;
		this.groupService = groupService;
	}
	
	public JSONObject getMoodleConfig(String url) {
		try {
			String moodle_connections = this.okmindmapService.getSetting("moodle_connections");
			
			if(moodle_connections.isEmpty()) return null;
			JSONArray connections = new JSONArray(moodle_connections);
			if(connections.length()==0) return null;
			
			JSONObject config = null;
			url = this.str_finish(url, "/");
			for (int i = 0; i < connections.length(); i++) {
				JSONObject con = connections.getJSONObject(i);
				
//				if(url.equals(this.str_finish(con.getString("url"), "/"))) {
				if((this.str_finish(con.getString("url"), "/")).indexOf(url) != -1) {
					config = new JSONObject();
					config.put("name", con.getString("name"));
					config.put("url", this.str_finish(con.getString("url"), "/"));
					config.put("secret", con.getString("secret"));
					config.put("creator_group_id", con.getString("creator_group_id"));
					break;
				}
			}
			return config;
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public String getSiteName(JSONObject config) {
		try {
			return config.getString("name");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public String getUrl(JSONObject config) {
		try {
			return config.getString("url");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public String getSecret(JSONObject config) {
		try {
			return config.getString("secret");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public int getCreatorGroupId(JSONObject config) {
		try {
			String id = config.getString("creator_group_id");
			return id.isEmpty() ? 0 : Integer.parseInt(id);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}
	
	public JSONArray getMoodleConnections() {
		try {
			String moodle_connections = this.okmindmapService.getSetting("moodle_connections");
			if(moodle_connections.isEmpty()) return null;
			JSONArray res = new JSONArray(moodle_connections);
			return res;
		} catch (JSONException e) {} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String str_finish(String str, String delimiter) {
		return str.endsWith(delimiter) ? str : str + delimiter;
	}
	
	public HashMap<String, Object> getCourseCategories(String mdlurl) {
		HashMap<String, Object> res = new HashMap<String, Object>();
		try {
			JSONObject config = this.getMoodleConfig(mdlurl);
			if(config != null) {
				JSONObject obj = new JSONObject();
				obj.put("role", "coursecreator");
				obj.put("info", "course_categories");
				
				String query = this.request(this.getUrl(config), obj, this.getSecret(config), this.user);
				
				JSONObject data = new JSONObject(query);
				if(data != null) {
					res = this.toHashMap(data);
				}
			}
		} catch (JSONException e) {}
		return res;
	}
	
	public String create_course(String mdlurl, String title, String shortname, int category, String summary) {
		try {
			JSONObject config = this.getMoodleConfig(mdlurl);
			if(config == null) return null;
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "create_course");
			obj.put("fullname",  StringEscapeUtils.escapeHtml(title));
			obj.put("shortname",  StringEscapeUtils.escapeHtml(shortname));
			obj.put("category", category);
			obj.put("summary",  StringEscapeUtils.escapeHtml(summary));
			
			return this.request(this.getUrl(config), obj, this.getSecret(config), this.user);
		} catch (JSONException e) {}
		return null;
	}
	
	public void set_course_connection(Map map, String mdlurl, int course) {
		try {
			JSONObject config = this.getMoodleConfig(mdlurl);
			if(config == null) return;
			
			Node root = map.getNodes().get(0);
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) root.getAttributes();
			
			Attribute moodleUrl = new Attribute();
			moodleUrl.setName("moodleUrl");
			moodleUrl.setNodeId(root.getId());
			moodleUrl.setValue(this.getUrl(config));
			attrs.add(moodleUrl);
			
			Attribute moodleCourseId = new Attribute();
			moodleCourseId.setName("moodleCourseId");
			moodleCourseId.setNodeId(root.getId());
			moodleCourseId.setValue(Integer.toString(course));
			attrs.add(moodleCourseId);
			
			root.setAttributes(attrs);
			this.mindmapService.updateNode(map.getId(), root);
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "set_course_connection");
			obj.put("moodleCourseId",  course);
			obj.put("okmmMapId",  map.getId());
			
			this.request(this.getUrl(config), obj, this.getSecret(config), this.user);
		} catch (JSONException e) {}
	}
	
	public void set_module_connection(JSONObject mapConfig, Node node, String modname, int moduleid) {
		try {
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null || mapConfig.getString("moodleCourseId") == null) return;
			
			int mapid = node.getMapId();
			
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) node.getAttributes();
			node.getMapId();
			
			Attribute moodleModule = new Attribute();
			moodleModule.setName("moodleModule");
			moodleModule.setValue(modname);
			attrs.add(moodleModule);
			
			Attribute moodleModuleId = new Attribute();
			moodleModuleId.setName("moodleModuleId");
			moodleModuleId.setValue(Integer.toString(moduleid));
			attrs.add(moodleModuleId);
			
			node.setAttributes(attrs);
			this.mindmapService.updateNode(mapid, node);
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "set_module_connection");
			obj.put("moodleCourseId",  mapConfig.getString("moodleCourseId"));
			obj.put("moodleModuleId",  moduleid);
			obj.put("okmmNodeId",  node.getId());
			
			this.request(this.getUrl(config), obj, this.getSecret(config), this.user);
		} catch (JSONException e) {}
	}
	
	public void set_section_connection(JSONObject mapConfig, Node node, String section) {
		try {
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null || mapConfig.getString("moodleCourseId") == null) return;
			
			int mapid = node.getMapId();
			
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) node.getAttributes();
			node.getMapId();
			
			Attribute moodleSection = new Attribute();
			moodleSection.setName("moodleCourseSection");
			moodleSection.setValue(section);
			attrs.add(moodleSection);
			
			node.setAttributes(attrs);
			this.mindmapService.updateNode(mapid, node);
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "set_section_connection");
			obj.put("moodleCourseId",  mapConfig.getString("moodleCourseId"));
			obj.put("section",  section);
			obj.put("okmmNodeId",  node.getId());
			
			System.out.println(obj);
			
			this.request(this.getUrl(config), obj, this.getSecret(config), this.user);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	public void delete_course_connection(int mapId) {
		try {
			Map map = this.mindmapService.getMap(mapId);
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			if(mapConfig == null) return;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return;
			
			if(mapConfig.has("moodleCourseTeacherShareId")) this.shareService.deleteShare(Integer.parseInt(mapConfig.getString("moodleCourseTeacherShareId")));
			if(mapConfig.has("moodleCourseStudentShareId")) this.shareService.deleteShare(Integer.parseInt(mapConfig.getString("moodleCourseStudentShareId")));
			
			if(mapConfig.has("moodleCourseTeacherGroupId")) this.groupService.deleteGroup(Integer.parseInt(mapConfig.getString("moodleCourseTeacherGroupId")));
			if(mapConfig.has("moodleCourseStudentGroupId")) this.groupService.deleteGroup(Integer.parseInt(mapConfig.getString("moodleCourseStudentGroupId")));
			
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "delete_course_connection");
			obj.put("okmmMapId", mapId);
			obj.put("moodleCourseId", mapConfig.getInt("moodleCourseId"));
			
			this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner);
		} catch (JSONException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public JSONObject add_module(int mapId, int section, String module, String name) {
		try {
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			if(mapConfig == null) return null;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return null;
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "add_module");
			obj.put("moduleName", module);
			obj.put("add", module);
			obj.put("section", section);
			obj.put("name", name);
			obj.put("moodleCourseId", mapConfig.getInt("moodleCourseId"));
			
			JSONObject res = new JSONObject(this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner));

			return res;
		} catch (JSONException e) {
			return null;
		}
	}

	public JSONObject getMoodleConnection(Node node) {
		if(node == null) return null;
		
		JSONObject con = null;
		try {
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) node.getAttributes();
			
			for(Attribute attr: attrs) {
				if(attr.getName().startsWith("moodle")) {
					if(con == null) con = new JSONObject();
					con.put(attr.getName(), attr.getValue());
				}
			}
			return con;
		} catch (JSONException e) {}
		return con;
	}
	
	public void updateNode(int mapId, Node node) {
		try {
			node = this.mindmapService.getNode(node.getIdentity(), mapId, false);
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			JSONObject nodeConfig = this.getMoodleConnection(node);
			JSONObject obj = new JSONObject();
			
			if(mapConfig == null && nodeConfig != null) return;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return;
			
			String nodeText = node.getText();
			if(nodeText == null && node.getRichContent() != null) {
				nodeText = this.getPlainText(node.getRichContent().getContent()).replaceAll("\n \n", " ");
			}
			
			obj.put("role", "coursecreator");
			obj.put("moodleCourseId", mapConfig.getString("moodleCourseId"));
			obj.put("name",  nodeText);
			obj.put("okmmMapId", mapId);
			
			if(nodeConfig.has("moodleCourseSection")) {
				obj.put("info", "edit_section");
				obj.put("section", nodeConfig.getString("moodleCourseSection"));
				obj.put("okmmNodeId", node.getId());
			}else if(nodeConfig.has("moodleCourseId")) {
				obj.put("info", "edit_course");
			}else {
				if(nodeConfig.has("moodleModule") && nodeConfig.getString("moodleModule").equals("label")) {
					obj.put("intro", nodeText);
				}else {
					obj.put("intro", "");
				}
				obj.put("info", "edit_module");
				obj.put("okmmNodeId", node.getId());
				obj.put("moodleModule", nodeConfig.getString("moodleModule"));
				obj.put("moodleModuleId", nodeConfig.getString("moodleModuleId"));
			}
			
			this.request(mapConfig.getString("moodleUrl"), obj, this.getSecret(config), mapOwner);
		} catch (JSONException e) {}
	}
	
	public void deleteNode(int mapId, Node node) {
		try {
			MindmapDAO mindmapDAO = this.mindmapService.getMindmapDAO();
			Node orgNode = mindmapDAO.getNode(node.getIdentity(), mapId, false);
			
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			JSONObject nodeConfig = this.getMoodleConnection(node);
			JSONObject obj = new JSONObject();
			
			if(mapConfig == null || orgNode == null && nodeConfig != null) return;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return;
			
			obj.put("role", "coursecreator");
			obj.put("moodleCourseId", mapConfig.getString("moodleCourseId"));
			obj.put("okmmMapId", map.getId());
			
			if(nodeConfig.has("moodleCourseId")) {
				
//				obj.put("info", "edit_course");
			}else {
				obj.put("info", "delete_module");
				obj.put("okmmNodeId", orgNode.getId());
				obj.put("moodleModule", nodeConfig.getString("moodleModule"));
				obj.put("moodleModuleId", nodeConfig.getString("moodleModuleId"));
			}
			this.request(mapConfig.getString("moodleUrl"), obj, this.getSecret(config), mapOwner);
			
			List<Node> childrens = node.getChildren();
			Iterator<Node> it = childrens.iterator();
			while(it.hasNext()) {
				Node children = it.next();
				this.deleteNode(mapId, children);
			}
			
		} catch (JSONException e) {}
	}
	
	public void moveNode(int mapId, Node node, String parent, String next) {
		try {
			node = this.mindmapService.getNode(node.getIdentity(), mapId, false);
			Node parentNode = this.mindmapService.getNode(parent, mapId, false);
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			JSONObject nodeConfig = this.getMoodleConnection(node);
			JSONObject obj = new JSONObject();
			
			if(mapConfig == null && nodeConfig != null && !nodeConfig.has("moodleModuleId")) return;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return;
			
			obj.put("role", "coursecreator");
			obj.put("moodleCourseId", mapConfig.getString("moodleCourseId"));
			obj.put("okmmMapId", mapId);
			obj.put("info", "move_to_section");
			obj.put("module", nodeConfig.getString("moodleModuleId"));
			obj.put("section", this.findSection(map.getNodes().get(0).getId(), parentNode));
			
			this.request(mapConfig.getString("moodleUrl"), obj, this.getSecret(config), mapOwner);
		} catch (JSONException e) {}
	}
	
	public Boolean syncAction(int mapId, String launchURL) {
//		System.out.println("==== syncAction ====");
		try {
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			
			if(mapConfig != null) {
			
				JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
				if(config == null) return true;
				
				String moodleCourseId = "";
				
				if(!mapConfig.has("moodleCourseId")) {
					JSONObject obj = new JSONObject();
					obj.put("role", "coursecreator");
					obj.put("info", "get_moodleCourseId");
					obj.put("okmmMapId", mapId);
					JSONObject _res = new JSONObject(this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner));
					
					if("".equals(_res.getString("moodleCourseId"))) return true;
					moodleCourseId = _res.getString("moodleCourseId");
					
					// recover connection
					Node root = map.getNodes().get(0);
					ArrayList<Attribute> attrs = (ArrayList<Attribute>) root.getAttributes();
					
					Attribute _moodleCourseId = new Attribute();
					_moodleCourseId.setName("moodleCourseId");
					_moodleCourseId.setNodeId(root.getId());
					_moodleCourseId.setValue(moodleCourseId);
					attrs.add(_moodleCourseId);
					
					root.setAttributes(attrs);
					this.mindmapService.updateNode(map.getId(), root);
					map = this.mindmapService.getMap(mapId);
				} else {
					moodleCourseId = mapConfig.getString("moodleCourseId");
				}
				
				JSONObject obj = new JSONObject();
				obj.put("role", "coursecreator");
				obj.put("info", "get_modules");
				obj.put("moodleCourseId", moodleCourseId);
				obj.put("okmmMapId", mapId);
				JSONObject res = new JSONObject(this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner));
				
				if(res != null && "ok".equals(res.getString("status"))) {
					JSONObject data = res.getJSONObject("data");
					
					if(data != null) {
						/// sync sections
						JSONObject section_nodeids = data.getJSONObject("section_nodeids");
						JSONObject sequence = data.getJSONObject("sequence");
						Iterator<?> _isec = section_nodeids.keys();
						
						while(_isec.hasNext()) {
							String sec = (String)_isec.next();
							
							try {
							
							if(!"0".equals(section_nodeids.getString(sec))) {
								//section
								Node _n = this.mindmapService.getNode(Integer.parseInt(section_nodeids.getString(sec)), false);
								JSONObject _nodeConfig = this.getMoodleConnection(_n);
								if(_nodeConfig == null) {
									this.set_section_connection(mapConfig, _n, sec.split("_")[1]);
								}	
							}
							}catch(Exception e) {
								e.printStackTrace();
							}
						}
						
						
						/// sync modules
						JSONObject _modules = data.getJSONObject("modules");
						Iterator<?> _i = _modules.keys();
						
						while(_i.hasNext()) {
							String mod_id = (String)_i.next();
							try {
								JSONObject _mod = (JSONObject) _modules.get(mod_id);
								if(_mod.has("node_id") &&  !"0".equals(_mod.getString("node_id"))) {
									Node _n = this.mindmapService.getNode(Integer.parseInt(_mod.getString("node_id")), false);
									JSONObject _nodeConfig = this.getMoodleConnection(_n);
									if(_nodeConfig == null) {
										this.set_module_connection(mapConfig, _n, _mod.getString("modname"), _mod.getInt("id"));
									}	
								}
							}catch(Exception e) {
								e.printStackTrace();
							}
						}
					}
					
					map = this.mindmapService.getMap(mapId);
					Node root = map.getNodes().get(0);
					
					JSONObject sections = data.getJSONObject("sections");
					if(sections != null) {
						JSONObject cm = data.getJSONObject("modules");
						JSONObject sequence = data.getJSONObject("sequence");
						
						if(cm != null) {
							cm = this.syncModules(map, sections, cm, launchURL);
							
//							if(sequence != null && sequence.has("section_0")) {
//								String[] modIds = sequence.getString("section_0").split(",");
//								
//								for(String modId : modIds) {
//									if(cm.has("mod_"+modId)) {
//										Node mod = this.mindmapService.getNode(cm.getInt("mod_"+modId), false);
//										mod.setLeft(false);
//										
//										if(mod.getRichContent() == null) {
//											mod = this.modifyNodeText(mod, mod.getOriginText());
//										}
//										
//										this.mindmapService.updateNode(mapId, mod);
//										this.mindmapService.moveNode(mapId, mod, root.getIdentity(), root.getIdentity());
//									}
//								}
//								sequence.remove("section_0");
//							}
						}
						
						String section_order = data.getString("section_order");
						sections = this.syncSections(map, sections, section_order, sequence);
						
						if(sequence != null) {
							Iterator<?> i = sequence.keys();
							while(i.hasNext()) {
								String key = (String)i.next();
								String sec = key.split("section_", 2)[1];
								
								String[] modIds = sequence.getString(key).split(",");
								Node parent = this.mindmapService.getNode(sections.getInt("section_"+sec), false);
								
								for(String modId : modIds) {
									if(cm.has("mod_"+modId)) {
										Node mod = this.mindmapService.getNode(cm.getInt("mod_"+modId), false);
										mod.setPosition("");
										
										if(mod.getRichContent() == null) {
											mod = this.modifyNodeText(mod, mod.getOriginText());
										}
										
										this.mindmapService.updateNode(mapId, mod);
										this.mindmapService.moveNode(mapId, mod, parent.getIdentity(), parent.getIdentity());
									}
								}
							}
						}
					}
					
					
					// Update course name
					root = this.mindmapService.getNode(root.getId(), false);
					String fullname = data.getJSONObject("course").getString("fullname");
					this.mindmapService.updateNode(mapId, this.modifyNodeText(root, fullname));
					
					return true;
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
//		System.out.println("==== End of syncAction ====");
		return false;
	}
	
	public Node modifyNodeText(Node node, String text) {
		if(text == null) return node;
		
		text = StringEscapeUtils.unescapeHtml(text);
		
//		if(text.contains("_")) {
//			String[] p = text.split("_");
//			String body = "";
//			for (String s: p) {           
//		        body += "<p>" + StringEscapeUtils.escapeHtml(s) + "</p>";
//		    }
//			
//			if(node.getRichContent() == null) {
//				RichContent richContent = new RichContent();
//				node.setRichContent(richContent);
//			}
//			
//			node.getRichContent().setContent("<html><head></head><body>"+body+"</body></html>");
//			node.setText(null);
//		} else {
			node.setText(text);
			node.setRichContent(null);
//		}
		
		return node;
	}
	
	public JSONObject modifySection(Map map, Node node, JSONObject modify) {
		try {
			Iterator<Node> it = node.getChildren().iterator();
			while(it.hasNext()) {
				Node n = it.next();
				JSONObject sections = modify.getJSONObject("sections");
				JSONObject resIds = modify.getJSONObject("resIds");
				JSONObject nodeConfig = this.getMoodleConnection(n);
				
				if(nodeConfig != null && nodeConfig.has("moodleCourseSection")) {
					String name = "section_" + nodeConfig.getString("moodleCourseSection");
					if(sections.has(name)) {
						String sectionName = sections.getString(name);
						n.setLeft(false);
						this.mindmapService.updateNode(map.getId(), this.modifyNodeText(n, sectionName));
						
						resIds.put(name, n.getId());
						sections.remove(name);
						modify.put("sections", sections);
						modify.put("resIds", resIds);
					} else {
						this.mindmapService.deleteNode(map.getId(), n);
					}
				}
				modify = this.modifySection(map, n, modify);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return modify;
	}
	
	public JSONObject syncSections(Map map, JSONObject sections, String section_order, JSONObject sequence) {
		JSONObject resIds = new JSONObject();
		try {
			JSONObject modify = new JSONObject();
			modify.put("sections", sections);
			modify.put("resIds", resIds);
			
//			System.out.println("===  modifySection ====");
			
			Node root = map.getNodes().get(0);
			modify = this.modifySection(map, root, modify);
			
			sections = modify.getJSONObject("sections");
			resIds = modify.getJSONObject("resIds");
			
//			System.out.println(sections);
			
//			System.out.println("=== End of modifySection ====");
			
			JSONObject mapConfig = this.getMoodleConnection(root);
			
			// create
			Iterator<?> i = sections.keys();
			while(i.hasNext()) {
				String key = (String)i.next();
				String sec = key.split("section_", 2)[1];
				
				String identity = "ID_" + Integer.toString(new Random().nextInt(2000000000));
				long created = new Date().getTime();
				Node new_node = new Node();
				new_node.setIdentity(identity);
				new_node.setCreated( created );
				new_node.setModified( created );
				new_node.setParent(root);
				new_node.setLeft(false);
				
				
//				ArrayList<Attribute> attrs = new ArrayList<Attribute>();
//				
//				Attribute moodleSection = new Attribute();
//				moodleSection.setName("moodleCourseSection");
//				moodleSection.setValue(sec);
//				attrs.add(moodleSection);
//				
//				new_node.setAttributes(attrs);
				
				String txt = sections.getString(key);
				this.mindmapService.newNodeAfterSibling(map.getId(), this.modifyNodeText(new_node, txt), root.getIdentity(), root.getIdentity());
				resIds.put(key, new_node.getId());
				this.set_section_connection(mapConfig, new_node, sec);
			}
			
			// sort
			String[] order = section_order.split(",");
			int half = order.length / 2;
			for(String idx : order) {
				String key  ="section_" + idx;
				if(resIds.has(key)) {
					Node node = this.mindmapService.getNode(resIds.getInt(key), false);
					if(Integer.parseInt(idx) > half) {
						node.setLeft(true);
						node = this.modifyNodeText(node, node.getOriginText());
						this.mindmapService.updateNode(map.getId(), node);
					}
					
					this.mindmapService.moveNode(map.getId(), node, root.getIdentity(), root.getIdentity());
				}
			}
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return resIds;
	}
	
	public JSONObject modifyModule(Map map, JSONObject sections, Node node, JSONObject modify, String launchURL) {
		try {
			Iterator<Node> it = node.getChildren().iterator();
			while(it.hasNext()) {
				Node n = it.next();
				JSONObject modules = modify.getJSONObject("modules");
				JSONObject resIds = modify.getJSONObject("resIds");
				JSONObject nodeConfig = this.getMoodleConnection(n);
				
				if(nodeConfig != null && !nodeConfig.has("moodleCourseSection")) {
				
					if(nodeConfig.has("moodleModuleId") && modules.has("mod_" + nodeConfig.getString("moodleModuleId"))) {
						String name = "mod_" + nodeConfig.getString("moodleModuleId");
						
						JSONObject cm = modules.getJSONObject(name);
						
						String link = cm.getString("link");
						if(link != null) {
							n.setLink(launchURL + link);
						}
						
						String txt = cm.getString("name");
						n = this.modifyNodeText(n, txt);
						this.mindmapService.updateNode(map.getId(), n);
						
						resIds.put(name, n.getId());
						modules.remove(name);
						modify.put("modules", modules);
						modify.put("resIds", resIds);
					} else {
						this.mindmapService.deleteNode(map.getId(), n);
					}
				}
				modify = this.modifyModule(map, sections, n, modify, launchURL);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return modify;
	}
	
	public JSONObject syncModules(Map map, JSONObject sections, JSONObject cm, String launchURL) {
		JSONObject resIds = new JSONObject();
		try {
			JSONObject modify = new JSONObject();
			modify.put("modules", cm);
			modify.put("resIds", resIds);
			
			Node root = map.getNodes().get(0);
			modify = this.modifyModule(map, sections, root, modify, launchURL);
			
			cm = modify.getJSONObject("modules");
			resIds = modify.getJSONObject("resIds");
			
			JSONObject mapConfig = this.getMoodleConnection(root);
			
			// create
			if(cm != null) {
				Iterator<?> i = cm.keys();
				while(i.hasNext()) {
					String new_cm = (String)i.next();
					JSONObject _cm = cm.getJSONObject(new_cm);
					
					String identity = "ID_" + Integer.toString(new Random().nextInt(2000000000));
					long created = new Date().getTime();
					Node new_node = new Node();
					new_node.setIdentity(identity);
					new_node.setCreated( created );
					new_node.setModified( created );
					new_node.setParent(root);
					new_node.setLink(launchURL + _cm.getString("link"));
					
//					ArrayList<Attribute> attrs = new ArrayList<Attribute>();
//					
//					Attribute moodleModule = new Attribute();
//					moodleModule.setName("moodleModule");
//					moodleModule.setValue(_cm.getString("modname"));
//					attrs.add(moodleModule);
//					
//					Attribute moodleModuleId = new Attribute();
//					moodleModuleId.setName("moodleModuleId");
//					moodleModuleId.setValue(_cm.getString("id"));
//					attrs.add(moodleModuleId);
//					
//					new_node.setAttributes(attrs);
					
					this.mindmapService.newNodeAfterSibling(map.getId(), this.modifyNodeText(new_node, _cm.getString("name")), root.getIdentity(), root.getIdentity());
					resIds.put(new_cm, new_node.getId());
					
					this.set_module_connection(mapConfig, new_node, _cm.getString("modname"), _cm.getInt("id"));
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return resIds;
	}
	
	public int findSection(int root, Node node) {
		JSONObject nodeConfig = this.getMoodleConnection(node);
		if(nodeConfig == null || node == null) return 0;
		
		try {
			if(node.getId() != root) {
				
				if(nodeConfig != null && nodeConfig.has("moodleCourseSection")) {
					return Integer.parseInt(nodeConfig.getString("moodleCourseSection"));
				}
				
				return this.findSection(root, node.getParent());
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return 0;
	}
	
	public JSONObject getMoodleActivities(int mapId, String lang) {
		JSONObject activities = null;
		try {
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			
			if(mapConfig == null) return null;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return null;
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "get_activities");
			obj.put("moodleCourseId", mapConfig.getString("moodleCourseId"));
			obj.put("lang", lang);
			
			JSONObject res = new JSONObject(this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner));
			
			if("ok".equals(res.getString("status"))) {
				activities = res.getJSONObject("activities");
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return activities;
	}
	
	public JSONObject courseEnrolment(int mapId, String search, String page, String perpage, String action, JSONObject enroluser, Boolean returnViewList) {
		JSONObject courseEnrolment = null;
		try {
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			if(mapConfig == null) return null;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return null;
			
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "course_enrolment");
			obj.put("moodleCourseId", mapConfig.getString("moodleCourseId"));
			obj.put("viewlist", returnViewList);
			
			if(search !=null && search != "") obj.put("search", search);
			if(page !=null && page != "") obj.put("page", page);
			if(perpage !=null && perpage != "") obj.put("perpage", perpage);
			if(action !=null && action != "") obj.put("action", action);
			if(enroluser !=null) obj.put("enroluser", enroluser);
			
			courseEnrolment = new JSONObject(this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner));
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return courseEnrolment;
	}
	
	public JSONObject getOKMMEnrolment(int mapId, List<User> users) {
		JSONObject res = null;
		try {
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			if(mapConfig == null) return null;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return null;
			
			JSONObject obj = new JSONObject();
			obj.put("role", "coursecreator");
			obj.put("info", "course_enrolment");
			obj.put("moodleCourseId", mapConfig.getString("moodleCourseId"));
			
			obj.put("action", "check_okmmusers");
			List<String> okmmusers = new ArrayList<String>();
			for(User u : users) {
				if(!"guest".equals(u.getUsername())) {
					okmmusers.add(this.getIdEncrypt(u));
				}
			}
			obj.put("okmmusers", okmmusers);
			
			res = new JSONObject(this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner));
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return res;
	}
	
	public HashMap<String, Object> getMoodleLoginPageIdps() {
		JSONArray connections = this.getMoodleConnections();
		if(connections == null || connections.length()==0) return null;
		
		List<Object> res = new ArrayList<Object>();
		
		try {
			for (int i = 0; i < connections.length(); i++) {
				JSONObject con = connections.getJSONObject(i);
				HashMap<String, Object> c = new HashMap<String, Object>();
				c.put("name", con.getString("name"));
				c.put("url", this.str_finish(con.getString("url"), "/") + "auth/okmmauth/login.php");
				
				res.add(c);
			}
			HashMap<String, Object> idps = new HashMap<String, Object>();
			idps.put("idps", res);
			return idps;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public User syncUser(String auth, String username, String firstname, String lastname, String email) {
		User user = null;
		
		if("okmmauth".equals(auth)) {
			user = this.userService.get(this.getIdDecrypt(username));
		}else {
			user = this.userService.get(username);
		
			if(user == null) {
				user = new User();
				
				user.setAuth(auth);
				user.setConfirmed(1);
				user.setUsername(username);
				user.setFirstname(firstname);
				user.setLastname(lastname);
				user.setEmail(email);
				user.setPassword("not cached");
				
				this.userService.add(user);
			}else {
				user.setFirstname(firstname);
				user.setLastname(lastname);
				user.setEmail(email);
				
				this.userService.update(user);
			}
			
			user = this.userService.get(username);
		}
		return user;
	}
	
//	public User syncUser(String auth, String username, String firstname, String lastname, String email, String avatar) {
//		User user = null;
//		
//		if("okmmauth".equals(auth)) {
//			user = this.userService.get(this.getIdDecrypt(username));
//		}else {
//			user = this.userService.get(username);
//		
//			if(user == null) {
//				user = new User();
//				
//				user.setAuth(auth);
//				user.setConfirmed(1);
//				user.setUsername(username);
//				user.setFirstname(firstname);
//				user.setLastname(lastname);
//				user.setEmail(email);
//				user.setPassword("not cached");
//				
//				this.userService.add(user);
//			}else {
//				user.setFirstname(firstname);
//				user.setLastname(lastname);
//				user.setEmail(email);
//				
//				this.userService.update(user);
//			}
//			
//			user = this.userService.get(username);
//			
//			if(user != null && avatar != null) {
//				try {
//					this.userService.setUserConfigData(user.getId(), "avatar", avatar);
//				} catch (Exception e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//			}
//		}
//		
//		return user;
//	}
	
	public User syncMoodleId(String mdlauth, String mdlurl) {
		try {
			JSONObject config = this.getMoodleConfig(mdlurl);
			if(config == null) return null;
			
			String auth = this.decrypt(mdlauth, this.getSecret(config));
			if(auth == null) return null;
			
			JSONObject mdlUser = new JSONObject(auth);
			
			if(mdlUser != null) {
				return this.syncUser(mdlUser.getString("auth"), mdlUser.getString("username"), mdlUser.getString("firstname"), mdlUser.getString("lastname"), mdlUser.getString("email"));
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Group getStudentGroup(int groupId, Map map) {
		Group group = null;
		try {
			group = this.groupService.getGroup(groupId);
		} catch (Exception e) {}
		
		if(group == null) {
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			// add new group
			Group newGroup = new Group();
			newGroup.setName("[Student] " + map.getName());
			newGroup.setUser(mapOwner);
			newGroup.setPolicy(this.groupService.getPolicy("closed"));
			
			List<Category> categories = this.groupService.getUserCategoryTree(mapOwner.getId());
			if(categories.size() > 0) {
				groupId = this.groupService.addGroup(newGroup, categories.get(0).getId());
			}else {
				groupId = this.groupService.addGroup(newGroup);
			}
			
			// update mapConfig
			Node root = map.getNodes().get(0);
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) root.getAttributes();
			
			Attribute _groupId = null;
			
			for (int i = 0; i < attrs.size(); i++) {
				if("moodleCourseStudentGroupId".equals(attrs.get(i).getName())) {
					_groupId = attrs.get(i);
					_groupId.setValue(Integer.toString(groupId));
					attrs.set(i, _groupId);
				}
			}
			
			if(_groupId == null) {
				_groupId = new Attribute();
				_groupId.setName("moodleCourseStudentGroupId");
				_groupId.setNodeId(root.getId());
				_groupId.setValue(Integer.toString(groupId));
				attrs.add(_groupId);
			}
			
			root.setAttributes(attrs);
			this.mindmapService.updateNode(map.getId(), root);
			
			group = this.groupService.getGroup(groupId);
		}
		return group;
	}
	
	public Group getTeacherGroup(int groupId, Map map) {
		Group group = null;
		try {
			group = this.groupService.getGroup(groupId);
		} catch (Exception e) {}
		
		if(group == null) {
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			// add new group
			Group newGroup = new Group();
			newGroup.setName("[Teacher] " + map.getName());
			newGroup.setUser(mapOwner);
			newGroup.setPolicy(this.groupService.getPolicy("closed"));
			
			List<Category> categories = this.groupService.getUserCategoryTree(mapOwner.getId());
			if(categories.size() > 0) {
				groupId = this.groupService.addGroup(newGroup, categories.get(0).getId());
			}else {
				groupId = this.groupService.addGroup(newGroup);
			}
			
			// update mapConfig
			Node root = map.getNodes().get(0);
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) root.getAttributes();
			
			Attribute _groupId = null;
			
			for (int i = 0; i < attrs.size(); i++) {
				if("moodleCourseTeacherGroupId".equals(attrs.get(i).getName())) {
					_groupId = attrs.get(i);
					_groupId.setValue(Integer.toString(groupId));
					attrs.set(i, _groupId);
				}
			}
			
			if(_groupId == null) {
				_groupId = new Attribute();
				_groupId.setName("moodleCourseTeacherGroupId");
				_groupId.setNodeId(root.getId());
				_groupId.setValue(Integer.toString(groupId));
				attrs.add(_groupId);
			}
			
			root.setAttributes(attrs);
			this.mindmapService.updateNode(map.getId(), root);
			
			group = this.groupService.getGroup(groupId);
		}
		return group;
	}
	
	public Share getStudentShare(int shareId, Group group, Map map) {
		Share share = null;
		
		try {
			share = this.shareService.getShare(shareId);
		} catch (Exception e) {}
		
		if(share == null) {
			// add Share
			share = new Share();
			ShareMap shareMap = new ShareMap();
			shareMap.setId(map.getId());
			share.setMap(shareMap);
			
			share.setShareType(this.shareService.getShareType("group"));
			
			share.setGroup(group);
			
			List<Permission> permissions = new ArrayList<Permission>();
			List<PermissionType> permissionTypes = this.shareService.getPermissionTypes();
			for(PermissionType permissionType : permissionTypes) {
				Permission permission = new Permission();
				permission.setPermissionType(permissionType);
				permission.setPermited("view".equals(permissionType.getShortName()));
				permissions.add(permission);
			}
			share.setPermissions(permissions);
			
			shareId = this.shareService.addShare(share);
			
			// update mapConfig
			Node root = map.getNodes().get(0);
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) root.getAttributes();
			
			Attribute _groupId = null;
			
			for (int i = 0; i < attrs.size(); i++) {
				if("moodleCourseStudentShareId".equals(attrs.get(i).getName())) {
					_groupId = attrs.get(i);
					_groupId.setValue(Integer.toString(shareId));
					attrs.set(i, _groupId);
				}
			}
			
			if(_groupId == null) {
				_groupId = new Attribute();
				_groupId.setName("moodleCourseStudentShareId");
				_groupId.setNodeId(root.getId());
				_groupId.setValue(Integer.toString(shareId));
				attrs.add(_groupId);
			}
			
			root.setAttributes(attrs);
			this.mindmapService.updateNode(map.getId(), root);
			
			share = this.shareService.getShare(shareId);
		}
		
		return share;
	}
	
	public Share getTeacherShare(int shareId, Group group, Map map) {
		Share share = null;
		
		try {
			share = this.shareService.getShare(shareId);
		} catch (Exception e) {}
		
		if(share == null) {
			// add Share
			share = new Share();
			ShareMap shareMap = new ShareMap();
			shareMap.setId(map.getId());
			share.setMap(shareMap);
			
			share.setShareType(this.shareService.getShareType("group"));
			
			share.setGroup(group);
			
			List<Permission> permissions = new ArrayList<Permission>();
			List<PermissionType> permissionTypes = this.shareService.getPermissionTypes();
			for(PermissionType permissionType : permissionTypes) {
				Permission permission = new Permission();
				permission.setPermissionType(permissionType);
				permission.setPermited(true);
				permissions.add(permission);
			}
			share.setPermissions(permissions);
			
			shareId = this.shareService.addShare(share);
			
			// update mapConfig
			Node root = map.getNodes().get(0);
			ArrayList<Attribute> attrs = (ArrayList<Attribute>) root.getAttributes();
			
			Attribute _groupId = null;
			
			for (int i = 0; i < attrs.size(); i++) {
				if("moodleCourseTeacherShareId".equals(attrs.get(i).getName())) {
					_groupId = attrs.get(i);
					_groupId.setValue(Integer.toString(shareId));
					attrs.set(i, _groupId);
				}
			}
			
			if(_groupId == null) {
				_groupId = new Attribute();
				_groupId.setName("moodleCourseTeacherShareId");
				_groupId.setNodeId(root.getId());
				_groupId.setValue(Integer.toString(shareId));
				attrs.add(_groupId);
			}
			
			root.setAttributes(attrs);
			this.mindmapService.updateNode(map.getId(), root);
			
			share = this.shareService.getShare(shareId);
		}
		
		return share;
	}
	
	public void syncShareMap(int mapId) {
		try {
			Map map = this.mindmapService.getMap(mapId);
			User mapOwner = this.mindmapService.getMapOwner(map.getId());
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			if(mapConfig == null) return;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return;
			
			Group teacherGroup = null;
			if(!mapConfig.has("moodleCourseTeacherGroupId")) {
				teacherGroup = this.getTeacherGroup(0, map);
			}else {
				teacherGroup = this.getTeacherGroup(Integer.parseInt(mapConfig.getString("moodleCourseTeacherGroupId")), map);
			}
			
			if(!mapConfig.has("moodleCourseTeacherShareId")) {
				this.getTeacherShare(0, teacherGroup, map);
			}else {
				this.getTeacherShare(Integer.parseInt(mapConfig.getString("moodleCourseTeacherShareId")), teacherGroup, map);
			}
			
			Group studentGroup = null;
			if(!mapConfig.has("moodleCourseStudentGroupId")) {
				studentGroup = this.getStudentGroup(0, map);
			}else {
				studentGroup = this.getStudentGroup(Integer.parseInt(mapConfig.getString("moodleCourseStudentGroupId")), map);
			}
			
			if(!mapConfig.has("moodleCourseStudentShareId")) {
				this.getStudentShare(0, studentGroup, map);
			}else {
				this.getStudentShare(Integer.parseInt(mapConfig.getString("moodleCourseStudentShareId")), studentGroup, map);
			}

			JSONObject obj = new JSONObject();
			obj.put("info", "enrolled_users");
			obj.put("moodleCourseId", mapConfig.getString("moodleCourseId"));
			JSONArray res = new JSONArray(this.request(this.getUrl(config), obj, this.getSecret(config), mapOwner));
			
			if(res != null) {
				List<Member> students = this.groupService.getGroupMembers(studentGroup.getId());
				List<Member> teachers = this.groupService.getGroupMembers(teacherGroup.getId());
				
				HashMap<String, Boolean> student_enrolled = new HashMap<String, Boolean>();
				HashMap<String, Boolean> teacher_enrolled = new HashMap<String, Boolean>();
				
				for (int i = 0; i < res.length(); i++) {
					JSONObject enrolled_user = res.getJSONObject(i);
					User u = this.syncUser(enrolled_user.getString("auth"), enrolled_user.getString("username"), enrolled_user.getString("firstname"), enrolled_user.getString("lastname"), enrolled_user.getString("email"));
					
					if(u != null && "0".equals(enrolled_user.getString("is_teacher"))) {
						if(!this.groupService.isMember(studentGroup.getId(), u.getId())) { 
							this.groupService.addMember(studentGroup.getId(), u.getId(), true);
						}
						student_enrolled.put(u.getUsername(), true);
					}
					
					if(u != null && "1".equals(enrolled_user.getString("is_teacher"))) {
						if(!this.groupService.isMember(teacherGroup.getId(), u.getId())) {
							this.groupService.addMember(teacherGroup.getId(), u.getId(), true);
						}
						teacher_enrolled.put(u.getUsername(), true);
					}
				}
				
				for (Member member : students) {
					User u = member.getUser();
					if(!student_enrolled.containsKey(u.getUsername())) {
						this.groupService.removeMember(studentGroup.getId(), u.getId());
					}
				}
				
				for (Member member : teachers) {
					User u = member.getUser();
					if(!teacher_enrolled.containsKey(u.getUsername())) {
						this.groupService.removeMember(teacherGroup.getId(), u.getId());
					}
				}
			}
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	public void groupAction(String action, int groupId, int userId) {
		try {
			List<ShareMap> shareMaps = this.shareService.getGroupSharedMaps(groupId);
			if(shareMaps.size() == 0) return;
				
			Map map = this.mindmapService.getMap(shareMaps.get(0).getId()); 
			
			JSONObject mapConfig = this.getMoodleConnection(map.getNodes().get(0));
			if(mapConfig == null) return;
			
			JSONObject config = this.getMoodleConfig(mapConfig.getString("moodleUrl"));
			if(config == null) return;
			
			JSONObject user = new JSONObject();
			
			if(Integer.parseInt(mapConfig.getString("moodleCourseTeacherGroupId")) == groupId) {
				user.put("assign_role", "editingteacher");
			}else if(Integer.parseInt(mapConfig.getString("moodleCourseStudentGroupId")) == groupId) {
				user.put("assign_role", "student");
			}else {
				return;
			}
			
			User u = this.userService.get(userId);
			
			if("moodle".equals(u.getAuth())) {
				user.put("id", this.getIdDecrypt(u.getUsername()));
			}else {
				user.put("okmmauth", 1);
				user.put("username", this.getIdEncrypt(u));
				user.put("firstname", StringEscapeUtils.escapeHtml(u.getFirstname()));
				user.put("lastname", StringEscapeUtils.escapeHtml(u.getLastname()));
				user.put("email", u.getEmail());
			}
			
			this.courseEnrolment(map.getId(), "", "", "", action, user, false);
			
			this.syncShareMap(map.getId());
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getCourses(String mdlurl, int page, int pagelimit, String searchfield, String search) {
		HashMap<String, Object> res = new HashMap<String, Object>();
		try {
			JSONObject config = this.getMoodleConfig(mdlurl);
			if(config == null) return res;
			
			JSONObject obj = new JSONObject();
			obj.put("role", "");
			obj.put("info", "get_courses");
			
			obj.put("page", String.valueOf(page));
			obj.put("pagelimit", String.valueOf(pagelimit));
			obj.put("searchfield", searchfield);
			obj.put("search", search);
			
			String query = this.request(this.getUrl(config), obj, this.getSecret(config), this.user);
			
			JSONObject data = new JSONObject(query);
			if(data != null) {
				HashMap<String, Object> query_data = this.toHashMap(data);
				
				List<HashMap<String, Object>> _res = (List<HashMap<String, Object>>) query_data.get("courses");
				List<Object> courses = new ArrayList<Object>();
				
				for(HashMap<String, Object> course : _res) {
					HashMap<String, Object> c = course;
					int map_id = Integer.parseInt((String) course.get("okmmMapId"));
					Map map = this.mindmapService.getMap(map_id);
					JSONObject mapConfig = null;
					
					if(map != null) {
						mapConfig = this.getMoodleConnection(map.getNodes().get(0));
					}
					
					if(map != null && mapConfig != null && mapConfig.has("moodleCourseId")) {
						c.put("map_key", map != null ? map.getKey():"");
						c.put("map_id", map != null ? map.getId():"");
					} else {
						c.put("map_key", "");
						c.put("map_id", "");
					}
					
					courses.add(c);
				}
				
				res.put("courses", courses);
				res.put("total", query_data.get("total"));
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return res;
	}
	
//	private String request_url(String url, JSONObject data, String secret, User user) {
//		try {
//			String _auth = user.getAuth();
//			String _username = "";
//			
//			if("moodle".equals(_auth)) {
//				_username = user.getUsername();
//			}else {
//				_auth = "okmmauth";
//				_username = this.getIdEncrypt(user);
//			}
//			
//			data.put("auth", _auth);
//			data.put("username", _username);
//			data.put("firstname", StringEscapeUtils.escapeHtml(user.getFirstname()));
//			data.put("lastname", StringEscapeUtils.escapeHtml(user.getLastname()));
//			data.put("email", user.getEmail());
//			
//			String p = this.encrypt(data.toString(), secret);
//			p = p.replace("+", "-");
//			p = p.replace("/", "_");
//			p = p.replace("=", ",");
//		
//			url += "auth/okmmauth/services.php?q=" + p;
//			return url;
//		} catch (JSONException e) {
//			System.out.println(e.getMessage());
//			return "";
//		}
//	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public String request_url(String url, JSONObject data, String secret, User user) {
		try {			
//			System.out.println(user.getId()+"; " + user.getAuth() + "; " + user.getUsername());
			
			String _auth = user.getAuth();
			String _username = "";
			
			if("moodle".equals(_auth)) {
				_username = user.getUsername();
			}else {
				_auth = "okmmauth";
				_username = this.getIdEncrypt(user);
			}
			
			LtiSigner ltiSigner = new LtiOauthSigner();
			java.util.Map<String, String> params = new HashMap<String, String>();
			
			String key = "1";
			String launch_url = url +"auth/okmmauth/services.php";
			
			if(user.getEmail() != null) params.put("lis_person_contact_email_primary",	 user.getEmail());
			if(user.getFirstname() != null && user.getLastname() != null) {
				params.put("lis_person_name_given", java.net.URLEncoder.encode(user.getFirstname(), "UTF-8"));
				params.put("lis_person_name_family", java.net.URLEncoder.encode(user.getLastname(), "UTF-8"));
				params.put("lis_person_name_full", java.net.URLEncoder.encode(user.getFirstname() + " " + user.getLastname(), "UTF-8"));
			}
			
			params.put("lti_message_type", "basic-lti-launch-request");
			params.put("lti_version", "LTI-1p0");
			params.put("resource_link_id", "1");
			
			//
			params.put("lis_person_auth", _auth);
			params.put("lis_person_username", _username);
			
			Iterator<String> keysItr = data.keys();
		    while(keysItr.hasNext()) {
		        String param = keysItr.next();
		        params.put("resource_" + param, data.getString(param));
		    }
		    //
			
			
			java.util.Map<String, String> signedParameters = ltiSigner.signParameters(params, key, secret, launch_url, "GET");
			
			launch_url += "?";
			boolean separator = false;
			
			for(java.util.Map.Entry<String, String> param : signedParameters.entrySet()) {
				if(param.getKey() != null && param.getValue() != null) {
					if(separator) {
						launch_url += "&";
					}
					launch_url += param.getKey() + "=" + URLEncoder.encode(param.getValue(), "UTF-8");
					separator = true;
				}
			}
			
//			System.out.println(launch_url);
	
			return launch_url;
		} catch (LtiSigningException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return "";
	}
	
	public String request(String url, JSONObject data, String secret, User user) {
		if(this.user == null || "guest".equals(this.user.getUsername())) return "";
		
		if(user == null) user = this.user;
		
		try {
			url = this.request_url(url, data, secret, user);
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			con.setRequestMethod("GET");
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			
			return response.toString();
		} catch (MalformedURLException e) {
			 e.printStackTrace();
		} catch (IOException e) {
			 e.printStackTrace();
		}
		return "{}";
	}
	
	public String getAuthRedirect(String auth, String mdlurl) {
		JSONObject userConfig = this.getMoodleConfig(mdlurl);
		if(userConfig != null) {
			try {
				String okmmauth_secret = this.getSecret(userConfig);
				String str = this.decrypt(auth, okmmauth_secret);
				
				if(str != null){
					JSONObject auth_state = new JSONObject();
					
					String _auth = this.user.getAuth();
					String _username = "";
					
					if("moodle".equals(_auth)) {
						_username = this.user.getUsername();
					}else {
						_auth = "okmmauth";
						_username = this.getIdEncrypt(this.user);
					}
					
					auth_state.put("auth", _auth);
					
					auth_state.put("role", "user");
					
					auth_state.put("username", _username);
					auth_state.put("firstname", StringEscapeUtils.escapeHtml(this.user.getFirstname()));
					auth_state.put("lastname", StringEscapeUtils.escapeHtml(this.user.getLastname()));
					auth_state.put("email", this.user.getEmail());
					
					String stateData = this.encrypt(auth_state.toString(), okmmauth_secret);
					return this.getUrl(userConfig) + "auth/okmmauth/login.php?auth=" + stateData;
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return "";
	}
	
	public HashMap<String, Object> getUserConnections(User user){
		try {
			HashMap<String, Object> res = new HashMap<String, Object>();
			List<Object> conns = new ArrayList<Object>();
			JSONArray connections = this.getMoodleConnections();
			
			if(connections == null) return null;
			
			for (int i = 0; i < connections.length(); i++) {
				JSONObject con = connections.getJSONObject(i);
//				if(this.hasRole("coursecreator", user, this.getUrl(con))) { // Turn off group permission for moodle activity
					conns.add(this.toHashMap(con));
//				}
			}
			res.put("connections", conns);
			return conns.size() > 0 ? res : null;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
//	public Boolean hasRole(String role, User user, String mdlurl) {
//		if("admin".equals(user.getRoleShortName())) return true;
//		
//		Boolean res = false;
//		JSONObject config = this.getMoodleConfig(mdlurl);
//		if(config == null) return res;
//		try {
//			if("coursecreator".equals(role)) {
//				Group group = this.groupService.getGroup(this.getCreatorGroupId(config));
//				
//				if(group != null) {
//					res = this.groupService.isMember(group.getId(), user.getId());
//				}
//			}
//		} catch (NumberFormatException e) {
//		}
//		
//		return res;
//	}
	
	/**
     * AES Encrypt
     */
	public String encrypt(String input, String key){
//		byte[] crypted = null;
//		try{
//			SecretKeySpec skey = new SecretKeySpec(key.getBytes(), "AES");
//			Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
//			cipher.init(Cipher.ENCRYPT_MODE, skey);
//			crypted = cipher.doFinal(input.getBytes());
//			
//			String str = new String(Base64.encodeBase64(crypted));
//			str = str.replace("+", "-");
//			str = str.replace("/", "_");
//			str = str.replace("=", ",");
//			System.out.println(str);
//		    return str;
//	    }catch(Exception e){}
//		return null;
		try {
			int CIPHER_KEY_LEN = 16;
			
            if (key.length() < CIPHER_KEY_LEN) {
                int numPad = CIPHER_KEY_LEN - key.length();

                for(int i = 0; i < numPad; i++){
                    key += "0"; //0 pad to len 16 bytes
                }

            } else if (key.length() > CIPHER_KEY_LEN) {
                key = key.substring(0, CIPHER_KEY_LEN); //truncate to 16 bytes
            }
            
            // Get random initialization vector
            SecureRandom secureRandom = new SecureRandom();
            byte[] initVectorBytes = new byte[CIPHER_KEY_LEN / 2];
            secureRandom.nextBytes(initVectorBytes);
            String iv = bytesToHex(initVectorBytes);

            IvParameterSpec initVector = new IvParameterSpec(iv.getBytes("UTF-8"));
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, initVector);

            byte[] encryptedData = cipher.doFinal((input.getBytes()));

            String base64_EncryptedData = java.util.Base64.getEncoder().encodeToString(encryptedData);
            String base64_IV = java.util.Base64.getEncoder().encodeToString(iv.getBytes("UTF-8"));

            String str = base64_EncryptedData + ":" + base64_IV;
			str = str.replace("+", "-");
			str = str.replace("/", "_");
			str = str.replace("=", ",");
//			System.out.println(str);
			return str;

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
	}
	
	public static String bytesToHex(byte[] bytes) {
		char[] hexArray = "0123456789ABCDEF".toCharArray();
        char[] hexChars = new char[bytes.length * 2];
        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }
	
	/**
     * AES Decrypt
     */
	public String decrypt(String input, String key){
//	    byte[] output = null;
//	    input = input.replace("-", "+");
//	    input = input.replace("_", "/");
//	    input = input.replace(",", "=");
//	    try{
//	      SecretKeySpec skey = new SecretKeySpec(key.getBytes(), "AES");
//	      Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
//	      cipher.init(Cipher.DECRYPT_MODE, skey);
//	      output = cipher.doFinal(Base64.decodeBase64(input));
//	      return new String(output);
//	    }catch(Exception e){}
//	    return null;
		
		try {

		    input = input.replace("-", "+");
		    input = input.replace("_", "/");
		    input = input.replace(",", "=");
            String[] parts = input.split(":");

            IvParameterSpec iv = new IvParameterSpec( java.util.Base64.getDecoder().decode(parts[1]));
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);

            byte[] decodedEncryptedData =  java.util.Base64.getDecoder().decode(parts[0]);

            byte[] original = cipher.doFinal(decodedEncryptedData);
            
//            System.out.println(new String(original));

            return new String(original);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
	}
	
	public HashMap<String, Object> toHashMap(JSONObject object) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
		    Iterator<String> keysItr = object.keys();
		    while(keysItr.hasNext()) {
		        String key = keysItr.next();
		        Object value = object.get(key);
	
		        if(value instanceof JSONArray) {
		            value = this.toList((JSONArray) value);
		        }else if(value instanceof JSONObject) {
		            value = this.toHashMap((JSONObject) value);
		        }
		        map.put(key, value);
		    }
		} catch (JSONException e) {
			e.printStackTrace();
		}
	    return map;
	}
	
	public List<Object> toList(JSONArray array) {
		List<Object> list = new ArrayList<Object>();
		try {
		    for(int i = 0; i < array.length(); i++) {
		        Object value;
				value = array.get(i);
		        if(value instanceof JSONArray) {
		            value = toList((JSONArray) value);
		        }else if(value instanceof JSONObject) {
		            value = this.toHashMap((JSONObject) value);
		        }
		        list.add(value);
		    }
		} catch (JSONException e) {
			e.printStackTrace();
		}
	    return list;
	}
	
	public String getIdEncrypt(User user) {
		String str = "";
		MessageDigest digest;
		try {
			digest = MessageDigest.getInstance("MD5");
			digest.update(user.getUsername().getBytes());
			BigInteger bigInteger = new BigInteger(1,digest.digest());
			str = bigInteger.toString(16);
		} catch (NoSuchAlgorithmException e) {};
		return Integer.toString(user.getId()) + "_" + str;
	}
	
	public int getIdDecrypt(String id) {
		return Integer.parseInt(id.split("_", 2)[0]);
	}
	
	public String getPlainText(String html) {
	    String result = "";
	    if (html == null) return html;
	    
	    Document document = Jsoup.parse(html);
	    document.outputSettings(new Document.OutputSettings().prettyPrint(false));
	    document.select("p").prepend("\\n");
	    result = document.html().replaceAll("\\\\n", "\n");
	    result = Jsoup.clean(result, "", Whitelist.none(),
	            new Document.OutputSettings().prettyPrint(false));
	    return result.trim();
	}

//	public MoodleService() {}
//	public static void main(String[] args) {
//	}
}
