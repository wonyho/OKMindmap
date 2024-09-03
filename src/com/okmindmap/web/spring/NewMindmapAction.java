package com.okmindmap.web.spring;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.model.share.Permission;
import com.okmindmap.model.share.PermissionType;
import com.okmindmap.model.share.Share;
import com.okmindmap.model.share.ShareMap;
import com.okmindmap.moodle.MoodleService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.service.GroupService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.ShareService;

public class NewMindmapAction extends BaseAction {
	
	private OKMindmapService okmindmapService;
	private MindmapService mindmapService;
	private ShareService shareService;
	private GroupService groupService;
	private PricingService pricingService;
	
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
	
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		User user = getUser(request);
		
		String title = request.getParameter("title");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String map_style = request.getParameter("mapstyle");
		String openmap = request.getParameter("openmap");
		
		// Moodle
		String mapType = (String) request.getParameter("type");
		String tabIdx = getOptionalParam(request, "tab",  "frm");
		String create_moodle = request.getParameter("create_moodle");
		String mdlurl = request.getParameter("mdlurl");
		String courseId = request.getParameter("courseId");
		
		String page = getOptionalParam(request, "page",  "1");
		int pagelimit = 10;
		String search = getOptionalParam(request, "search",  "");
		String searchfield = getOptionalParam(request, "searchfield",  "fullname");
		HashMap<String, Object> data = new HashMap<String, Object>();
		String message = "";
		String messageErr = this.getMessage("message.moodle.permission_denied");
		
		MoodleService moodleService = new MoodleService(user, this.okmindmapService, this.mindmapService, this.userService, this.shareService, this.groupService);

		HashMap<String, Object> userConnections = null;
		if(mapType != null && "moodle".equals(mapType)) {
			JSONObject moodle_policy = this.pricingService.getCurrentTiersofUser(user.getId(), "moodle");
			moodle_policy = moodle_policy != null ? (new JSONObject(moodle_policy.getString("value"))) : null;
			
			if(mdlurl == null) {
				userConnections = moodleService.getUserConnections(user);
				if(userConnections == null || moodle_policy == null || (moodle_policy.has("only_student") && moodle_policy.getBoolean("only_student"))) message = messageErr;
			}else {
				if(moodle_policy == null || (moodle_policy.has("only_student") && moodle_policy.getBoolean("only_student"))) message = messageErr;
				else if(moodle_policy.has("course_hosting") && moodle_policy.getInt("course_hosting") > 0 && moodle_policy.getInt("course_hosting") <= this.mindmapService.countMoodleMaps(user.getId())) message = "Your account can only create up to " + moodle_policy.getInt("course_hosting") + " courses.";
				else if(create_moodle == null){
					if("frm".equals(tabIdx)) data = moodleService.getCourseCategories(mdlurl);
					else {
						if(courseId != null && !"".equals(courseId)) {
							List<Map> maps = mindmapService.getUserMaps(user.getId(), Integer.parseInt(page), pagelimit, "title", search, null, false);
							data.put("maps", maps);
						} else 
						{
							data = moodleService.getCourses(mdlurl, Integer.parseInt(page), pagelimit, searchfield, search);
//							HashMap<String, Object> temp = new HashMap<String, Object>();
//							temp = moodleService.getCourses(mdlurl, 1, 10000, searchfield, search);
//							data.put("tolCourse", temp);
							
						}
					}
					message = "";
				}
			}
		}
		
		if(create_moodle != null) {
			BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
			if("".equals(message)) {
				String shortname = request.getParameter("shortname");
				String category = getOptionalParam(request, "category",  "1");
				String summary = getOptionalParam(request, "summary",  "");
				
				out.write(toBytes(moodleService.create_course(mdlurl, title, shortname, Integer.parseInt(category), summary)));
			}else {
				out.write(toBytes("{\"status\":\"error\", \"message\":\" "+message+" \"}"));
			}
			out.flush();
			out.close();

			return null;
		}
		
		if(title != null) {
		//	title = new String(title.getBytes("ISO-8859-1"), "UTF-8");
			
			int mapId = 0;
			
			// 게스트인 경우, 이메일, 비밀번호 입력
			if(user.getUsername().endsWith("guest")) {
				if(email != null && email.trim().length() != 0 //TODO 이메일 형식 체크
						&& password != null && password.trim().length() != 0) {
					mapId = this.mindmapService.newMap(title, email, password);
				} else {
					mapId = this.mindmapService.newMap(title);
				}
			} else {
//				Restrict restrict = new CreateMapRestrict(user.getId(), request.getSession().getServletContext());
//				if(restrict.isAvailable()) {
					mapId = this.mindmapService.newMap(title, user.getId());
					
					
					if(openmap!=null && openmap.equals("1")){
						//맵생성시 전체 공유 추가하기
						Share share = new Share();
						
						
						ShareMap shareMap = new ShareMap();
						shareMap.setId(mapId);
						share.setMap(shareMap);
						
						String shareType = "open";
						share.setShareType(this.shareService.getShareType(shareType));
						List<Permission> permissions = new ArrayList<Permission>();
						List<PermissionType> permissionTypes = this.shareService.getPermissionTypes();
						for(PermissionType permissionType : permissionTypes) {
							//int permited = getOptionalParam(request, "permission_" + permissionType.getShortName(), 0);
							Permission permission = new Permission();
							permission.setPermissionType(permissionType);
							if(permissionType.getShortName().equalsIgnoreCase("view")
									|| permissionType.getShortName().equalsIgnoreCase("copynode")){
								permission.setPermited(true);
							} else {
								permission.setPermited(false);
							}
							
							permissions.add(permission);
						}
						share.setPermissions(permissions);
						
						this.shareService.addShare(share);
						
						//공유추가 끝
					}
					
//				} else {
//					return new ModelAndView("error/createMapRestrict", "user", user);
//				}
			}
			this.mindmapService.updateMapStyle(mapId, map_style);
			
			Map map = this.mindmapService.getMap(mapId);
			
			String moodleUrl = request.getParameter("moodleUrl");
			String moodleCourseId = request.getParameter("moodleCourseId");
			if(moodleUrl!=null && moodleCourseId != null) {
				moodleService.set_course_connection(map, moodleUrl, Integer.parseInt(moodleCourseId));
			}
			
			response.sendRedirect(request.getContextPath() + "/map/" + map.getKey());
			
			return null;//new ModelAndView("index", "params", params);
		} else {
			data.put("message", message);
			data.put("maptype", mapType);
			data.put("tabidx", tabIdx);
			
			data.put("page", page);		
			data.put("pagelimit", pagelimit);		
			data.put("searchfield", searchfield);
			data.put("search", search);
			
			data.put("mdlurl", mdlurl);
			data.put("moodle_connections", userConnections);
			data.put("courseId", courseId);
			
			JSONObject map_create_policy = this.pricingService.getCurrentTiersofUser(user.getId(), "map_create");
			int limit_map_create = map_create_policy != null ? map_create_policy.getInt("value"):0;
			if(limit_map_create > 0) {
				int countUserMaps = this.mindmapService.countUserMaps(user.getId(), null, null);
				if(countUserMaps >= limit_map_create) {
					data.put("message", "Your account can only create up to " + limit_map_create + " maps.");
				}
			}
			return new ModelAndView("new", "data", data);
		}
	}
	
	private byte[] toBytes(String txt) {
		try {
			return txt.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return txt.getBytes();
	}

}
