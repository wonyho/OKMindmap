package com.okmindmap.web.spring;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import com.google.gson.Gson;

import org.apache.poi.sl.usermodel.SlideShow;
import org.apache.poi.xslf.usermodel.SlideLayout;
//import org.apache.log4j.Logger; // wait for the upgrade to log4j 2.15.0
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFBackground;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.OkmmMultipart;
import com.okmindmap.model.Repository;
import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.service.UserService;

public class UserSlideMaster extends BaseAction {
	private UserService userService = null;
	private RepositoryService repositoryService;
	private MindmapService mindmapService;

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

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = getUser(request);
		if (!user.getUsername().equals("guest")) {
			String confirmed = request.getParameter("action");
			int userid = user.getId();

			Hashtable<String, String> data = new Hashtable<String, String>();
			if (Objects.equals(confirmed, "set")) {
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				MultipartFile multipartFile = multipartRequest.getFile("file");
				// 저장 경로 : /map-files/{owner_user id}/{map id}
				String subPath = "/slide_master/" + userid + "/";
				int repoID = this.repositoryService.saveFile(multipartFile, subPath, 2, userid);
				

				Repository pptxFile = this.repositoryService.loadFile(repoID);
				if (pptxFile != null && checkSlideMaster(pptxFile.getPath())) {
					
					OkmmMultipart multipartFile2 = this.getSlideThumb(pptxFile.getPath());
					if(multipartFile2 != null) {
						int repoID2 = this.repositoryService.saveFile(multipartFile2, subPath, 2, userid);
						System.out.println(repoID2);
						if(repoID2 > 0) {
							List<UserConfigData> configData = this.userService.getUserConfigData(userid);
							String pptx = "";
							for (UserConfigData con : configData) {
								if (Objects.equals(con.getFieldname(), "user.slideMaster")) {
									pptx = con.getData();
									break;
								}
							}
							if (pptx.split(" ").length < 10)
								pptx += " " + repoID;
							this.userService.setUserConfigData(userid, "user.slideMaster", pptx);
							String jpeg = "";
							for (UserConfigData con : configData) {
								if (Objects.equals(con.getFieldname(), "user.slideMaster.thumb")) {
									jpeg = con.getData();
									break;
								}
							}
							if (jpeg.split(" ").length < 10)
								jpeg += " " + repoID2;
							this.userService.setUserConfigData(userid, "user.slideMaster.thumb", jpeg);
							data.put("repoid", String.valueOf(repoID));
							data.put("repoid2", String.valueOf(repoID2));
						}else {
							data.put("message", "Error");
						}
					}else {
						data.put("message", "Error");
					}
				} else {
					data.put("message", "Error");
				}
				JSONArray json = JSONArray.fromObject(data);
				response.setContentType("application/json");
				OutputStream out = response.getOutputStream();
				out.write(json.toString().getBytes("UTF-8"));
				out.close();
				return null;
			} else if (Objects.equals(confirmed, "get")) {
				List<UserConfigData> configData = this.userService.getUserConfigData(userid);
				String jpeg = "";
				for (UserConfigData con : configData) {
					if (Objects.equals(con.getFieldname(), "user.slideMaster.thumb")) {
						jpeg = con.getData();
						break;
					}
				}
				String pptx = "";
				for (UserConfigData con : configData) {
					if (Objects.equals(con.getFieldname(), "user.slideMaster")) {
						pptx = con.getData();
						break;
					}
				}
				String[] arr = pptx.split(" ");
				String[] arrs = jpeg.split(" ");
				List<Repository> list = new ArrayList<Repository>();
				for (int i = 1; i < arrs.length; i++) {
					Repository thumb = this.repositoryService.loadFile(Integer.parseInt(arrs[i]));
					Repository f = this.repositoryService.loadFile(Integer.parseInt(arr[i]));
					thumb.setPath(thumb.getPath().substring(thumb.getPath().indexOf("okmindmap_upload"),
							thumb.getPath().length()));
					int idx = f.getPath().indexOf("okmindmap_upload" + "/slide_master/" + userid + "/");
					String r = f.getPath().substring(idx, f.getPath().length());
					r = r.replace("okmindmap_upload" + "/slide_master/", "");
					r = r.replace("/", "--");
					thumb.setContentType(r);
					list.add(thumb);
				}
				String json = new Gson().toJson(list);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(json);
				return null;
			}
		}

		return null;
	}

	protected String getFileExtension(String fileName) {
		int i = fileName.lastIndexOf('.');
		if (i > 0 && i < fileName.length() - 1) {
			return fileName.substring(i + 1).toLowerCase();
		}
		return "";
	}

	private boolean checkSlideMaster(String path) {
		try {
			XMLSlideShow slideShow = new XMLSlideShow(new FileInputStream(path));
			if (slideShow.getSlideMasters().get(0) == null)
				return false;
			if (slideShow.getSlideMasters().get(0).getLayout(SlideLayout.TITLE) == null)
				return false;
			if (slideShow.getSlideMasters().get(0).getLayout(SlideLayout.TITLE_AND_CONTENT) == null)
				return false;
			return true;
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

	private OkmmMultipart getSlideThumb(String path) {
		File file = new File(path);
		XMLSlideShow ppt;
		try {
			ppt = new XMLSlideShow(new FileInputStream(file));
		    Dimension pgsize = ppt.getPageSize();
			
		    BufferedImage img = new BufferedImage((int)Math.ceil(pgsize.width), (int)Math.ceil(pgsize.height), BufferedImage.TYPE_INT_RGB);
	        Graphics2D graphics = img.createGraphics();

	        graphics.setPaint(Color.white);
	        graphics.fill(new Rectangle.Float(0, 0, pgsize.width, pgsize.height));
	        
	        XSLFSlide slide = ppt.getSlides().get(0);
	        
//	        XSLFBackground backround = ppt.getSlideMasters().get(0).getBackground();
//	        
//	        backround.draw(graphics, new Rectangle.Float(0, 0, pgsize.width, pgsize.height));
	        slide.draw(graphics);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageIO.write( img, "png", baos );
			baos.flush();
			
			System.out.println(baos.size() + "================================");
			
			OkmmMultipart f = new OkmmMultipart(baos.toByteArray(), "temp", "temp", "image/png", baos.size());
			return f;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
