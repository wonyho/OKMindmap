package com.okmindmap.service;

import java.util.List;

import com.okmindmap.model.LisGrade;

public interface LisService {
	public boolean insertLisGrade(LisGrade score);
	
	public LisGrade getLisGrade(int id);
	public LisGrade getLisGrade(int userid, int mapid, int nodeid);
	public double getScore(int userid, int mapid, int nodeid);
	public List<LisGrade> getMaxListScore(int mapid, int nodeid);
	public List<LisGrade> getLastListScore(int mapid, int nodeid);
	public List<LisGrade> getAverageListScore(int mapid, int nodeid);
}
