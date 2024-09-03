package com.okmindmap.web.spring;
import java.io.IOException;
import java.io.InputStream;

import java.io.StringWriter;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.MindmapDigester;
import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.model.share.Permission;
import com.okmindmap.model.share.PermissionType;
import com.okmindmap.model.share.Share;
import com.okmindmap.model.share.ShareMap;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.service.ShareService;

public class ImportZipMapsAction extends BaseAction {

	private MindmapService mindmapService;
	private RepositoryService repositoryService;
	private ShareService shareService;
	private PricingService pricingService;
	
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
	
	public void setShareService(ShareService shareService) {
		this.shareService = shareService;
	}
	
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		User user = getUser(request);
		
		String confirmed = request.getParameter("confirm");
		String format = request.getParameter("format");
//		String filetype = request.getParameter("filetype");

		if(confirmed != null && Integer.parseInt(confirmed) == 1) {
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
			
			Hashtable<String,String> result = new Hashtable<String, String>();
	
			MultipartFile multipartFile = multipartRequest.getFile("file");
			String mmFilePath = this.repositoryService.saveMMFile(multipartFile);
			
			int last_map_id = 0;
			String last_map_key = "";
			String last_map_name = "";
			Boolean can_create_new_map = this.canCreateNewMap(user.getId());
			
			try {
				ZipFile zipFile = new ZipFile(mmFilePath);
				Enumeration<? extends ZipEntry> entries = zipFile.entries();

				while(entries.hasMoreElements() && can_create_new_map) {
					ZipEntry entry = entries.nextElement();
					InputStream stream = zipFile.getInputStream(entry);
					String filename = entry.getName();
					
					Matcher exceptFilename = Pattern.compile("^(_|\\.)").matcher(filename);
					
					if(!entry.isDirectory() && !exceptFilename.find() && "mm".equals(FilenameUtils.getExtension(filename))) {
						StringWriter writer = new StringWriter();
						IOUtils.copy(stream, writer);
						String xml = writer.toString();
						
						Map map = MindmapDigester.parseMap(xml);
						
						// 끝에 .mm 을 제거한다.
						filename = removeExtension(filename);
						
						// remove m.getId() + "-"
						// ZipEntry mmfile = new ZipEntry(m.getId() + "-" + m.getName() + ".mm");
						Matcher m = Pattern.compile("(^[\\d]+)-.+").matcher(filename);
						if(m.find() && m.groupCount() > 0) {
							filename = filename.replace(m.group(1) + "-", "");
						}
						
						map.setName(filename);
						
						int map_id = 0;
						if(user.getUsername().endsWith("guest")) {
							if(email != null && password != null) {
								map_id = this.mindmapService.saveMap(map, email, password);
							} else {
								map_id = this.mindmapService.saveMap(map);
							}
						} else {
							map_id = this.mindmapService.saveMap(map, user.getId());
						}
						
						String openmap = "1";
						if(openmap!=null && openmap.equals("1")){
							//맵생성시 전체 공유 추가하기
							Share share = new Share();
							
							
							ShareMap shareMap = new ShareMap();
							shareMap.setId(map_id);
							share.setMap(shareMap);
							
							String shareType = "open";
							share.setShareType(this.shareService.getShareType(shareType));
							List<Permission> permissions = new ArrayList<Permission>();
							List<PermissionType> permissionTypes = this.shareService.getPermissionTypes();
							for(PermissionType permissionType : permissionTypes) {
								//int permited = getOptionalParam(request, "permission_" + permissionType.getShortName(), 0);
								Permission permission = new Permission();
								permission.setPermissionType(permissionType);
								if(permissionType.getShortName().equalsIgnoreCase("view")){
									permission.setPermited(true);
								}else
									permission.setPermited(false);
								
								permissions.add(permission);
							}
							share.setPermissions(permissions);
							
							this.shareService.addShare(share);
							
							//공유추가 끝
						}
					
						map = this.mindmapService.getMap(map_id);
						last_map_id = map_id;
						last_map_key = map.getKey();
						last_map_name = map.getName();
						
						can_create_new_map = this.canCreateNewMap(user.getId());
					}
				}
				
				zipFile.close();
			} catch (IOException ex) {
				System.err.println(ex);
			}
			
			if(last_map_id != 0) {
				result.put("id", Integer.toString(last_map_id));
				result.put("key", last_map_key);
				result.put("name", last_map_name);
				result.put("message", "Success!");
			} else if(!can_create_new_map) {
				result.put("message", "Your account has expired number of maps created.");
			} else {
				result.put("message", "Error: File does not exits!");
			}
			
			if("json".equals(format)) {
				response.setContentType("application/json");
				JSONObject res = new JSONObject(result);
				response.getOutputStream().write(res.toString().getBytes());
				return null;
			} else {
				return new ModelAndView("import/import_map-result", "result", result);
			}
			
		} else {
			return new ModelAndView("import/import_maps_zip", "user", user);
		}
		
	}
	
	private String removeExtension(String s) {

	    String separator = System.getProperty("file.separator");
	    String filename;

	    // Remove the path upto the filename.
	    int lastSeparatorIndex = s.lastIndexOf(separator);
	    if (lastSeparatorIndex == -1) {
	        filename = s;
	    } else {
	        filename = s.substring(lastSeparatorIndex + 1);
	    }

	    // Remove the extension.
	    int extensionIndex = filename.lastIndexOf(".");
	    if (extensionIndex == -1)
	        return filename;

	    return filename.substring(0, extensionIndex);
	}
	
	private Boolean canCreateNewMap(int userid) throws JSONException {
		Boolean res = true;
		JSONObject map_create_policy = this.pricingService.getCurrentTiersofUser(userid, "map_create");
		int limit_map_create = map_create_policy != null ? map_create_policy.getInt("value") : 0;
		if(limit_map_create > 0) {
			int countUserMaps = this.mindmapService.countUserMaps(userid, null, null);
			if(countUserMaps >= limit_map_create) {
				res = false;
			}
		}
		return res;
	}

}
