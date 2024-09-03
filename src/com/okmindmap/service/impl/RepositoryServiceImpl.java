package com.okmindmap.service.impl;


import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
//import org.apache.log4j.Logger; // wait for the upgrade to log4j 2.15.0
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.okmindmap.dao.RepositoryDAO;
import com.okmindmap.model.OkmmMultipart;
import com.okmindmap.model.Repository;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.util.ImageUtils;

//import io.minio.errors.ErrorResponseException;
//import io.minio.errors.InsufficientDataException;
//import io.minio.errors.InternalException;
//import io.minio.errors.InvalidBucketNameException;
//import io.minio.errors.InvalidResponseException;
//import io.minio.errors.RegionConflictException;
//import io.minio.errors.ServerException;
//import io.minio.errors.XmlParserException;

public class RepositoryServiceImpl implements RepositoryService {
	
//	Logger logger = Logger.getLogger(RepositoryServiceImpl.class); // wait for the upgrade to log4j 2.15.0
	
	private static final long JPG_RESIZE_SKIP_SIZE = 262144;	// 256 Kbyte
	
	private RepositoryDAO repositoryDAO;
	private String path;
	private int fileMaxUploadSize;
	private int imageMaxUploadSize;
	private String fileFormat;
	private String imageFormat;
	private int limitWidth;
	private int limitHeight;
	private String watermarkPath;
	private String baseurl;
	
	public RepositoryDAO getRepositoryDAO() {
		return repositoryDAO;
	}

	public void setRepositoryDAO(RepositoryDAO repositoryDAO) {
		this.repositoryDAO = repositoryDAO;
	}
	
	public RepositoryServiceImpl(String path, int fileMaxUploadSize, int imageMaxUploadSize, String fileFormat, 
			String imageFormat, int limitWidth, int limitHeight, String watermarkPath,
			String baseurl/*
							 * , String minioHost, String minioAccessKey, String minioSecretKey, String
							 * minioBucket
							 */) throws InvalidKeyException, IOException, IllegalArgumentException, NoSuchAlgorithmException
	/*
	 * , ErrorResponseException, InsufficientDataException, InternalException,
	 * InvalidBucketNameException, InvalidResponseException, ServerException,
	 * XmlParserException, RegionConflictException
	 */ {
        this.path = path;
        this.fileMaxUploadSize = fileMaxUploadSize;
        this.imageMaxUploadSize = imageMaxUploadSize;
        this.fileFormat = fileFormat;
        this.imageFormat = imageFormat;
        this.limitWidth = limitWidth;
        this.limitHeight = limitHeight;
        this.watermarkPath = watermarkPath;
        this.baseurl = baseurl;
        File saveFolder = new File(path);
        if(!saveFolder.exists() || saveFolder.isFile()){
            saveFolder.mkdirs();
        }       
    }
	
	public String saveMMFile(MultipartFile sourcefile) throws IOException {
        if ((sourcefile==null)||(sourcefile.isEmpty())) return null;
        
        String key = UUID.randomUUID().toString();
        String targetFilePath = path + "/Freemind/" + key;
        File file = new File(targetFilePath);
        file.mkdirs();
        sourcefile.transferTo(file);
        
        return targetFilePath;
    }
	
	public String saveBookmarkFile(MultipartFile sourcefile) throws IOException {
        if ((sourcefile==null)||(sourcefile.isEmpty())) return null;
        
        String key = UUID.randomUUID().toString();
        String targetFilePath = path + "/Bookmark/" + key;
        File file = new File(targetFilePath);
        file.mkdirs();
        sourcefile.transferTo(file);
        
        return targetFilePath;
    }
	
	public String saveTextFile(MultipartFile sourcefile) throws IOException {
		if ((sourcefile==null)||(sourcefile.isEmpty())) return null;
        
        String key = UUID.randomUUID().toString();
        String targetFilePath = path + "/Text/" + key;
        File file = new File(targetFilePath);
        file.mkdirs();
        sourcefile.transferTo(file);
        
        return targetFilePath;
	}
	
	// rang 고용량 고해상도 이미지 업로드시 이슈사항 수정되면 업데이트
	public int saveFile(MultipartFile sourcefile, String subPath, int mapid, int userid) throws IOException {
		if ((sourcefile==null)||(sourcefile.isEmpty())) return -1;
		Map<String, Object> saveMap = new HashMap<String, Object>();
        String key = UUID.randomUUID().toString();
        if(!subPath.startsWith("/")) subPath = "/" + subPath;
        if(!subPath.endsWith("/")) subPath = subPath + "/";
        String targetFilePath = path + subPath + key;
        
        new File(path + subPath).mkdirs();
	    
        String fileName = null;
        String filePath = null;
        String contentType = null;
        long fileSize = 0;
        
        try {
        	// image일경우 resize & rotate
    	    if(sourcefile.getContentType().contains("image")){
    	    	//업로드파일이 GIF일 경우
    	    	if(sourcefile.getContentType().contains("image/gif")){
    	    		// jpg 변환
    	    		String url = targetFilePath;
    		        File origin = convertFile((CommonsMultipartFile) sourcefile);
    		        File dest = new File(url);
    				
    		        FileUtils.copyFile(origin, dest);
                    if(dest.exists()){
                    	origin.delete();
                    }
                    saveMap = ImageUtils.resizeImage((CommonsMultipartFile) sourcefile, targetFilePath, limitWidth);
                    
                    this.watermark((String)saveMap.get("path"));
                    
    	    		// gif 그대로 저장.
                    File file = new File(targetFilePath + ".gif");
	       			//file.mkdirs();
	       			sourcefile.transferTo(file);
	       			
	       			//fileName = sourcefile.getOriginalFilename();
	       			fileName = FilenameUtils.getBaseName(sourcefile.getOriginalFilename())+".jpg";
	       			filePath = (String) saveMap.get("path");
	       			contentType = sourcefile.getContentType();
	       			fileSize = (Long) saveMap.get("fileSize");
    	    	} else {
    	    		fileName = FilenameUtils.getBaseName(sourcefile.getOriginalFilename()); 
    	    		fileName += (sourcefile.getContentType().contains("png")) ? ".png" : ".jpg";
    	    		saveMap = ImageUtils.resizeImage((CommonsMultipartFile) sourcefile, targetFilePath, limitWidth);
    	    		
    	    		contentType = sourcefile.getContentType();
        	    	filePath = (String) saveMap.get("path");
        			fileSize = (Long) saveMap.get("fileSize");
        			
        			 System.out.println(fileName);
        			 System.out.println(filePath);
        			 System.out.println(contentType);
        			 System.out.println(fileSize);
    		    }
    	    }else{
    			 File file = new File(targetFilePath);
    			 file.mkdirs();
    			 sourcefile.transferTo(file);
    			     			 
    			 fileName = sourcefile.getOriginalFilename();
    			 filePath = file.getAbsolutePath();
    			 contentType = sourcefile.getContentType();
    			 fileSize = sourcefile.getSize();
    			
    	    }
    	    return this.repositoryDAO.insertRepository(mapid, userid, makupFileName(fileName), filePath, contentType, fileSize);
		} catch (Exception e) {
//			logger.info("Exception : " + e); // wait for the upgrade to log4j 2.15.0
			//return 0;
			e.printStackTrace();
		}
        return -2;
        //logger.info("targetFilePath : " + targetFilePath);
        //logger.info("path : " + path);
        //logger.info("fileName : " + fileName);
        //logger.info("contentType : " + contentType);
        //logger.info("fileSize : " + fileSize);
	}
	
	public int saveFile(OkmmMultipart sourcefile, String subPath, int mapid, int userid) throws IOException {
		if ((sourcefile==null)||(sourcefile.isEmpty())) return -1;
        String key = UUID.randomUUID().toString();
        if(!subPath.startsWith("/")) subPath = "/" + subPath;
        if(!subPath.endsWith("/")) subPath = subPath + "/";
        String targetFilePath = path + subPath + key;
        
        new File(path + subPath).mkdirs();
	    
        String fileName = null;
        String filePath = null;
        String contentType = null;
        long fileSize = 0;
        
        try {
			 sourcefile.setOriginalFilename(targetFilePath);
			 File file = convertFile(sourcefile);
			 
			 
			 fileName = sourcefile.getOriginalFilename();
			 filePath = file.getAbsolutePath();
			 contentType = sourcefile.getContentType();
			 fileSize = sourcefile.getSize();
			 
    	    return this.repositoryDAO.insertRepository(mapid, userid, makupFileName(fileName), filePath, contentType, fileSize);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return -2;
	}
	
	private String makupFileName(String fname) {
		fname = fname.toLowerCase();
		fname = fname.replace(" ","-");
		return fname;
	}
	
	/*public int saveFile(MultipartFile sourcefile, String subPath, int mapid, String mbr_no) throws IOException {
		if ((sourcefile==null)||(sourcefile.isEmpty())) return -1;
        
        String key = UUID.randomUUID().toString();
        if(!subPath.startsWith("/")) subPath = "/" + subPath;
        if(!subPath.endsWith("/")) subPath = subPath + "/";
        String targetFilePath = path + subPath + key;
        File file = new File(targetFilePath);
        file.mkdirs();
        sourcefile.transferTo(file);
        
        if(file != null && file.exists()) {
        	String fileName = sourcefile.getOriginalFilename();
            String path = file.getAbsolutePath();
            String contentType = sourcefile.getContentType();
            long fileSize = sourcefile.getSize();
            
            String[] tmpAry = contentType.split("/");
            if(tmpAry[0].equals("image")){
            	logger.info("contentType : " + tmpAry[0]);
            	logger.info("before fileSize : " + fileSize);
            	ImageUtils.resize(file, limitWidth, limitHeight);
            }
            return this.repositoryDAO.insertRepository(mapid, mbr_no, fileName, path, contentType, fileSize);
        } else {
        	return -1;
        }
	}*/
	
	public String saveTempFile(MultipartFile sourcefile, String subPath) throws IOException {
		if ((sourcefile==null)||(sourcefile.isEmpty())) return "";
        
        String key = UUID.randomUUID().toString();
        if(!subPath.startsWith("/")) subPath = "/" + subPath;
        if(!subPath.endsWith("/")) subPath = subPath + "/";
        String targetFilePath = path + subPath + key;
        File file = new File(targetFilePath);
        file.mkdirs();
        sourcefile.transferTo(file);
        
        if(file != null && file.exists()) {
            return file.getAbsolutePath();
        } else {
        	return "";
        }
	}
	
	public Repository loadFile(int repoid) throws IOException {
		Repository repo = this.repositoryDAO.withdrawRepository(repoid);
		return repo;
	}
	public String getPath() {
		return this.path;
	}
	public int fileMaxUploadSize(){
		return this.fileMaxUploadSize;
	};
	public int imageMaxUploadSize(){
		return this.imageMaxUploadSize;
	};
	public String fileFormat(){
		return this.fileFormat;
	};
	public String imageFormat(){
		return this.imageFormat;
	};
	private File convertFile(CommonsMultipartFile file) throws IOException{    
	    File convFile = new File(file.getOriginalFilename());
	    convFile.createNewFile(); 
	    FileOutputStream fos = new FileOutputStream(convFile); 
	    fos.write(file.getBytes());
	    fos.close(); 
	    return convFile;
	}
	
	private File convertFile(OkmmMultipart file) throws IOException{    
	    File convFile = new File(file.getOriginalFilename());
	    convFile.createNewFile(); 
	    FileOutputStream fos = new FileOutputStream(convFile); 
	    fos.write(file.getBytes());
	    fos.close(); 
	    return convFile;
	}
	
	private void watermark(String imgFilePath) throws IOException {
		ImageIcon photo = new ImageIcon(imgFilePath);
		BufferedImage bufferedImage = new BufferedImage(photo.getIconWidth(),
                photo.getIconHeight(),
                BufferedImage.TYPE_INT_RGB);
		Graphics2D g2d = (Graphics2D) bufferedImage.getGraphics();
		g2d.drawImage(photo.getImage(), 0, 0, null);
		
		ImageIcon wartermark = new ImageIcon(this.watermarkPath);
		
		int x = (photo.getIconWidth() - wartermark.getIconWidth()) / 2;
		int y = (photo.getIconHeight() - wartermark.getIconHeight()) / 2;
		g2d.drawImage(wartermark.getImage(), x, y, null);
		
		ImageIO.write(bufferedImage, "jpg", new File(imgFilePath));
	}
	
	public String baseUrl() {
		return this.baseurl;
	}
	
	public double totalUploadFileCapacity(int userId) {
		return this.repositoryDAO.totalUploadFileCapacity(userId) / (double)1048576;
	}
	
	public boolean removeFile(int fileId) {
		try {
			Repository file = this.loadFile(fileId);
			File f = new File(file.getPath());
			if(Files.deleteIfExists(f.toPath())) {
				return this.repositoryDAO.removeRepository(fileId) > 0;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean removeFiles(int mapId) {
		int err = 0;
		try {
			List<Repository> repoes = this.loadFiles(mapId);
			for(Repository file : repoes) {
				File f = new File(file.getPath());
				if(Files.deleteIfExists(f.toPath())) {
					if(this.repositoryDAO.removeRepository(file.getId()) < 1) err++;
				}
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return err == 0;
	}
	
	public List<Repository> loadFiles(int mapId) throws IOException{
		List<Repository> repoes = this.repositoryDAO.withdrawRepositories(mapId);
		return repoes;
	}

//	@Override
//	public String uploadToMinIO(MultipartFile sourcefile, String filename) {
//		// TODO Auto-generated method stub
//		return null;
//	}
}
