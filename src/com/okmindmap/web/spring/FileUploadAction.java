package com.okmindmap.web.spring;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.apache.log4j.Logger; // wait for the upgrade to log4j 2.15.0
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.icu.text.CharsetDetector;
import com.ibm.icu.text.CharsetMatch;
import com.okmindmap.MindmapDigester;
import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.service.RepositoryService;

import net.sf.json.JSONArray;

public class FileUploadAction extends BaseAction {
	
	private RepositoryService repositoryService;
	private MindmapService mindmapService;
	private PricingService pricingService;
	private int maxCapacity;
	
//	Logger logger = Logger.getLogger(FileUploadAction.class); // wait for the upgrade to log4j 2.15.0
	
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

	public PricingService getPricingService() {
		return pricingService;
	}

	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String confirmed = request.getParameter("confirm");		
		String url_only = request.getParameter("url_only");
		User user = (User) request.getSession().getAttribute("user");
		String nodeId = request.getParameter("nodeId");
		
		// wait for the upgrade to log4j 2.15.0
//		logger.info("############### CHECK UPLOAD VALUE ###############");
//		logger.info("CONFIRMED : " + confirmed);
//		logger.info("NODEID : " + nodeId);
//		logger.info("MAPID : " + request.getParameter("mapid"));
		
		//KHANG: use this parameter to return url only.
		//it is usefull with AjaxForm
		
		Hashtable<String,String> data = new Hashtable<String, String>();
		if(confirmed != null && Integer.parseInt(confirmed) == 1) {
			int map_id = Integer.parseInt(request.getParameter("mapid"));
			
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;			
			MultipartFile multipartFile = multipartRequest.getFile("file");
			// 저장 경로 : /map-files/{owner_user id}/{map id}
			String subPath = "/map-files/";
			int ownerUserId = this.mindmapService.getMapOwner(map_id).getId();
			double useable = this.useableCapacity(ownerUserId);
			if(useable - (multipartFile.getSize() / 1048576) > 0) {
				subPath = subPath + ownerUserId + "/";
				subPath = subPath + map_id + "/";
				int repoID = this.repositoryService.saveFile(multipartFile, subPath, map_id, ownerUserId);
				String url = "";
				if(repoID != -1) {
					String fileName = multipartFile.getOriginalFilename();
					// url 정보 : ./file/{repository id}/{user id}/{fileName}
					url = "/file/" + repoID + "/"+ ownerUserId + "/" + fileName;
					
					String ext = getFileExtension(fileName);

					data.put("repoid", String.valueOf(repoID));
					data.put("owner_userid", String.valueOf(ownerUserId));
					data.put("filename", fileName);
					data.put("ext", ext);
					data.put("url", url);
					data.put("type", "fileupload");

					String contentType = multipartFile.getContentType();
					String serverUrl = request.getRequestURL().toString();
					String insertPath = "";
		            String[] array1 = contentType.split("/");
		            String[] array2 = serverUrl.split("/");
		            String insertType = "file";
		            String actionDesc = url;
		            if(array1[0].equals("image")){
		            	insertType = array1[0];
		            	
		            	for(int i=0; i < array2.length-2; i++){
		            		insertPath += array2[i] + "/";
		            	}	            	
		            	actionDesc = "<img src='" + insertPath + "map" + actionDesc + "' style='width: 100%;'/>";
		            }
		            
//					this.mindmapService.insertMapHistory(insertType, actionDesc, "add", nodeId, map_id, user);
				} else {
					data.put("message", "Error");
				}
				if (url_only != null) {		
					response.setContentType("application/json");
					String res = "{\"url\":\"" + url + "\"}";
					response.getOutputStream().write(res.getBytes());
					return null;
				}
			}else {
//				System.out.println("Out of");
				data.put("message", "Out of upload capacity.\n(capacity: "+this.maxCapacity+"Mb, useable: "+String.format("%.3f", useable)+"Mb)");
				
			}
			
			
			JSONArray json = JSONArray.fromObject(data);
			response.setContentType("application/json");
			OutputStream out = response.getOutputStream();
			out.write(json.toString().getBytes("UTF-8"));
			out.close();
			return null;
			//return new ModelAndView("media/fileupload-result", "data", data);
		} else {			
			//return new ModelAndView("fileupload-form");
			data.put("type", "fileupload");
			return new ModelAndView("media/image", "data", data);
		}
		
	}
	
	protected String getFileExtension(String fileName) {
		int i = fileName.lastIndexOf('.');
		if(i > 0 && i < fileName.length() - 1) {
			return fileName.substring(i + 1).toLowerCase();
		}
		return "";
	}
	
	private int getCapacityLimit(int UID) {
		JSONObject upload_capacity;
		try {
			upload_capacity = this.pricingService.getCurrentTiersofUser(UID, "capacity_limit");
			int limit_upload_capacity = upload_capacity != null ? upload_capacity.getInt("value"):0;
			return limit_upload_capacity;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	private double useableCapacity(int UID) {
		double used = this.repositoryService.totalUploadFileCapacity(UID);
		this.maxCapacity = this.getCapacityLimit(UID);
		return this.maxCapacity - used;
	}
}
