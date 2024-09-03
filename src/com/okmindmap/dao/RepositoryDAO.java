package com.okmindmap.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.okmindmap.model.Repository;

public interface RepositoryDAO {
	
	public int insertRepository(int mapid, int userid, String fileName, String path, String contentType, long fileSize);
	public Repository withdrawRepository(int repoid);
	public int totalUploadFileCapacity(int userid);
	public int removeRepository(int fileId) throws DataAccessException;
	public int removeRepositories(int mapId) throws DataAccessException;
	public List<Repository> withdrawRepositories(int mapId);
}