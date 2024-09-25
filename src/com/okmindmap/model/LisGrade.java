package com.okmindmap.model;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class LisGrade {
	private int id;
	private int userid;
	private int mapid;
	private int nodeid;
	private double score;
	private String lisResultSourcedid;
    private long time;
    private String username;
    private String fullname;
    private String fulltime;
    private String quiz;
    private List<String> quizList;
    private List<Double> scoreList;
	
	public LisGrade() {
		// TODO Auto-generated constructor stub
		this.quizList = new ArrayList<String>();
		this.scoreList = new ArrayList<Double>();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public int getMapid() {
		return mapid;
	}

	public void setMapid(int mapid) {
		this.mapid = mapid;
	}

	public int getNodeid() {
		return nodeid;
	}

	public void setNodeid(int nodeid) {
		this.nodeid = nodeid;
	}

	public double getScore() {
		return score;
	}

	public void setScore(double score) {
		this.score = score;
	}

	public String getLisResultSourcedid() {
		return lisResultSourcedid;
	}

	public void setLisResultSourcedid(String lisResultSourcedid) {
		this.lisResultSourcedid = lisResultSourcedid;
	}

	public long getTime() {
		return time;
	}

	public void setTime(long time) {
		this.time = time;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	
	public String getFulltime() {
		return fulltime;
	}

	public void setFulltime(String fulltime) {
		this.fulltime = fulltime;
	}

	@SuppressWarnings("unused")
	private String convertTime(long time){
	    Date date = new Date(time);
	    Format format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    return format.format(date);
	}

	public String getQuiz() {
		return quiz;
	}

	public void setQuiz(String quiz) {
		this.quiz = quiz;
	}

	public List<String> getQuizList() {
		return quizList;
	}

	public void setQuizList(List<String> quizList) {
		this.quizList = quizList;
	}

	public List<Double> getScoreList() {
		return scoreList;
	}

	public void setScoreList(List<Double> scoreList) {
		this.scoreList = scoreList;
	}
	
	public void addQuiz(String q) {
		this.quizList.add(q);
	}
	
	public void addScore(Double c) {
		this.scoreList.add(c);
	}
}
