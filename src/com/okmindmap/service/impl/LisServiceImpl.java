package com.okmindmap.service.impl;

import java.util.List;

import com.okmindmap.dao.LisDAO;
import com.okmindmap.model.LisGrade;
import com.okmindmap.service.LisService;

public class LisServiceImpl implements LisService{
	
	private LisDAO lisDAO;
	
	public void setLisDAO(LisDAO lisDAO) {
		this.lisDAO = lisDAO;
	}
	
	public boolean insertLisGrade(LisGrade score) {
		return lisDAO.insertLisGrade(score);
	}

	public LisGrade getLisGrade(int id) {
		return lisDAO.getLisGrade(id);
	}

	public LisGrade getLisGrade(int userid, int mapid, int nodeid) {
		return lisDAO.getLisGrade(userid, mapid, nodeid);
	}
	
	public double getScore(int userid, int mapid, int nodeid) {
		return lisDAO.getScore(userid, mapid, nodeid);
	}
	
	public List<LisGrade> getMaxListScore(int mapid, int nodeid){
		return lisDAO.getMaxListScore(mapid, nodeid);
	}
	
	public List<LisGrade> getLastListScore(int mapid, int nodeid){
		return lisDAO.getLastListScore(mapid, nodeid);
	}
	public List<LisGrade> getAverageListScore(int mapid, int nodeid){
		return lisDAO.getAverageListScore(mapid, nodeid);
	}
	
}
