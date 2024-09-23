package com.okmindmap.web.spring.oauth;

import com.google.gson.Gson;
import com.okmindmap.model.User;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.oltu.oauth2.as.issuer.*;
import org.apache.oltu.oauth2.as.request.OAuthTokenRequest;
import org.apache.oltu.oauth2.as.response.OAuthASResponse;
import org.apache.oltu.oauth2.common.OAuth;
import org.apache.oltu.oauth2.common.exception.OAuthProblemException;
import org.apache.oltu.oauth2.common.exception.OAuthSystemException;
import org.apache.oltu.oauth2.common.message.OAuthResponse;
import org.apache.oltu.oauth2.common.message.types.GrantType;
import org.springframework.web.servlet.ModelAndView;

public class Token extends BaseAction {

	private String accessToken;

	public Token() {
		accessToken = "";
	}

	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String redirect_uri = request.getParameter("redirect_uri");
		String client_id = request.getParameter("client_id");
		String response_type = request.getParameter("response_type");
		String consumer_key = request.getParameter("consumer_key");
		String code = request.getParameter("code");
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("client_id", client_id);
		data.put("redirect_uri", redirect_uri);
		data.put("response_type", response_type);
		if ("tubestory.co.kr".contentEquals(client_id)) {
			authorize(request);
			data.put("access_token", accessToken);
			User user = getUser(request);
			if (!user.isGuest() || "manual".equals(user.getAuth())) {
				userService.setOAuthToken(code, accessToken);
			}
			String json = (new Gson()).toJson(data);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(json);
		}
		return null;
	}
	
	public String authorize(HttpServletRequest request) {
		try {
			OAuthTokenRequest oauthRequest;
	        OAuthIssuer oauthIssuerImpl;
	        oauthRequest = new OAuthTokenRequest(request);
	        oauthIssuerImpl = new OAuthIssuerImpl(new MD5Generator());
	        if(oauthRequest.getParam("grant_type").equals(GrantType.AUTHORIZATION_CODE.toString()) && !checkAuthCode(oauthRequest.getParam("code")))
	        {
	            return "Auth error!";
	        }
	        accessToken = oauthIssuerImpl.accessToken();
	        return accessToken;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";
	}

//	public String authorize(HttpServletRequest request)
//        throws OAuthSystemException
//    {
//        OAuthTokenRequest oauthRequest;
//        OAuthIssuer oauthIssuerImpl;
//        oauthRequest = new OAuthTokenRequest(request);
//        oauthIssuerImpl = new OAuthIssuerImpl(new MD5Generator());
//        if(oauthRequest.getParam("grant_type").equals(GrantType.AUTHORIZATION_CODE.toString()) && !checkAuthCode(oauthRequest.getParam("code")))
//        {
//            return "Auth error!";
//        }
//        accessToken = oauthIssuerImpl.accessToken();
//        return accessToken;
//        OAuthProblemException e;
//        e;
//        OAuthResponse res = OAuthASResponse.errorResponse(400).error(e).buildJSONMessage();
//        return res.getBody();
//    }

	private boolean checkAuthCode(String authCode) {
		return true;
	}
}