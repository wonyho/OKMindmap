package com.okmindmap.api.translate;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.api.sa.SuperAdminManager;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;

public class AiTranslator extends BaseAction {
	protected UserService userService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
//		String q = request.getParameter("q");
//		q = new String(q.getBytes("ISO-8859-1"), "UTF-8");
//		String r = this.tranlate(q);
//		
//		response.setContentType("application/json");
//		response.setCharacterEncoding("UTF-8");
//		if(r.indexOf("\"messages\"") == 0) response.getWriter().write("false");
//		else response.getWriter().write(r);
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(this.getActiveKey());
		return null;
	}

	private String getActiveKey() {
		return SuperAdminManager.getActiveTranslateKey(this.userService);
	}
	
//	private String tranlate(String data) {
//		HttpRequest request = HttpRequest.newBuilder()
//				.uri(URI.create("https://ai-translate.p.rapidapi.com/translates"))
//				.header("content-type", "application/json")
//				.header("X-RapidAPI-Key", this.getActiveKey())
//				.header("X-RapidAPI-Host", "ai-translate.p.rapidapi.com")
//				.method("POST", HttpRequest.BodyPublishers.ofString(data))
//				.build();
//		HttpResponse<String> response;
//		try {
//			response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
//			return response.body().substring(1, response.body().length()-1);
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		return "";
//	}
}

//https://www.googleapis.com/customsearch/v1?key=AIzaSyA5j1VZ3hJccqvMQZ8h_nWAl5kzRMZNnUQ&q=ok&searchType=image&num=10&start=1&cx=006697568995703237209:vljrny3h45w
