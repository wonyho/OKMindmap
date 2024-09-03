package com.okmindmap.service;


import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.okmindmap.model.OkmmMultipart;
import com.okmindmap.model.Repository;

public interface RepositoryService {
	public String saveMMFile(MultipartFile sourcefile) throws IOException;
	public String saveBookmarkFile(MultipartFile sourcefile) throws IOException;
	public String saveTextFile(MultipartFile sourcefile) throws IOException;
	
	public int saveFile(MultipartFile sourcefile, String subPath, int mapid, int userid) throws IOException;	
	public int saveFile(OkmmMultipart sourcefile, String subPath, int mapid, int userid) throws IOException;
	public String saveTempFile(MultipartFile sourcefile, String subPath) throws IOException;
	public Repository loadFile(int repoid) throws IOException;
	public String getPath();
	public int fileMaxUploadSize();
	public int imageMaxUploadSize();
	public String fileFormat();
	public String imageFormat();
	public String baseUrl();
	public double totalUploadFileCapacity(int userId);
	
//	public String uploadToMinIO(MultipartFile sourcefile, String filename);
	public boolean removeFile(int fileId);
	public boolean removeFiles(int mapId);
	public List<Repository> loadFiles(int mapId) throws IOException;
}
