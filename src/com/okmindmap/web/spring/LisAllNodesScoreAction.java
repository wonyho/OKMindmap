package com.okmindmap.web.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.LisGrade;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.LisService;
import com.okmindmap.service.MindmapService;

public class LisAllNodesScoreAction extends BaseAction {

	private MindmapService mindmapService;
	private LisService lisService;
	private List<String> quizList;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	public void setLisService(LisService lisService) {
		this.lisService = lisService;
	}

	@SuppressWarnings("null")
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String mapid = request.getParameter("map");
		String nodeid = request.getParameter("node"); // this is Identity
		
		
		
	    if(mapid == null)
	    	return null;	    
				
		Map map = this.mindmapService.getMap(Integer.parseInt(mapid), true);
		if(map == null)
			return null;
		
		User user = getUser(request);
		String userID = String.valueOf(user.getId());
		if(user == null) 
			userID =  "2";
		else if(user.getUsername().equals("guest")) 
			userID =  "2";
		HashMap<String, Object> data = new HashMap<String, Object>();
		int mapOwnerId = this.mindmapService.getMapOwner(map.getId()).getId();
		if((!userID.equals("2") && mapOwnerId == Integer.parseInt(userID)) || userID.equals("1")) {
			String calAction = request.getParameter("calAction");
			String viewMode = request.getParameter("viewMode");
			List<LisGrade> scores = new ArrayList<LisGrade>();
			List<LisGrade> scorestemp = new ArrayList<LisGrade>();
			List<Node> nodes = map.getNodes();
			this.quizList = new ArrayList<String>();
			scores = this.getScore(scores, scorestemp, map.getId(), nodes.get(0), calAction);
			data.put("scores", scores);
			data.put("quizs", this.quizList);
			if(viewMode.equals("html")) {
				return new ModelAndView("nodeScoreTable", "data", data);
			}else if(viewMode.equals("csv")) {
//				return new ModelAndView("", "data", data);
			}else if(viewMode.equals("map")) {
//				return new ModelAndView("", "data", data);
			}
		}

	    return null;
	}
	
	private List<LisGrade> getScore(List<LisGrade> scores, List<LisGrade> scorestemp,int mapId, Node node, String calAction){
		if(calAction.equals("last")) {
			scorestemp = this.lisService.getLastListScore(mapId, node.getId());
		}else if(calAction.equals("max")) {
			scorestemp = this.lisService.getMaxListScore(mapId, node.getId());
		}else if(calAction.equals("average")) {
			scorestemp = this.lisService.getAverageListScore(mapId, node.getId());
		}
		this.mergeList(scores, scorestemp, node.getText());
		List<Node> nodes = node.getChildren();
		for(Node n : nodes) {
			this.getScore(scores, scorestemp, mapId, n, calAction);
		}
		return scores;
	}
	
	private List<LisGrade> mergeList(List<LisGrade> scores, List<LisGrade> scorestemp, String quiz) {
		if(scorestemp.size() < 1) return scores;
		this.quizList.add(quiz);
		for(LisGrade s : scorestemp) {
//			s.setQuiz(quiz);
//			scores.add(s);
			LisGrade found = this.existElement(scores, s.getUserid());
			if(found != null) {
				found.addQuiz(quiz);
				found.addScore(s.getScore());
			}else {
				if(this.quizList.size() == 0) {
					s.addQuiz(quiz);
					s.addScore(s.getScore());
				}else {
					for(int i = 0;  i < this.quizList.size() - 1 ; i++) {
						s.addQuiz(this.quizList.get(i));
						s.addScore(-1.0);
					}
					s.addQuiz(quiz);
					s.addScore(s.getScore());
				}
				scores.add(s);
			}
		}
		for(LisGrade s : scores) {
			if(this.quizList.size() != s.getQuizList().size()) {
				s.addQuiz(quiz);
				s.addScore(-1.0);
			}
		}
		return scores;
	}
	
	private LisGrade existElement(List<LisGrade> scores, int userId) {
		for(LisGrade s : scores) {
			if(s.getUserid() == userId) return s;
		}
		return null;
	}

}
