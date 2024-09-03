package com.okmindmap.web.spring.oauth;

import com.okmindmap.model.User;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;
import jakarta.ws.rs.core.Response;
import java.io.PrintStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.oltu.oauth2.as.issuer.MD5Generator;
import org.apache.oltu.oauth2.as.issuer.OAuthIssuerImpl;
import org.apache.oltu.oauth2.as.request.OAuthAuthzRequest;
import org.apache.oltu.oauth2.as.response.OAuthASResponse;
import org.apache.oltu.oauth2.common.OAuth;
import org.apache.oltu.oauth2.common.exception.OAuthProblemException;
import org.apache.oltu.oauth2.common.exception.OAuthSystemException;
import org.apache.oltu.oauth2.common.message.OAuthResponse;
import org.apache.oltu.oauth2.common.message.types.ResponseType;
import org.springframework.web.servlet.ModelAndView;

public class Authorize extends BaseAction
{

    private String authorizationCode;

    public Authorize()
    {
        authorizationCode = "";
    }

    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
        throws Exception
    {
        String redirect_uri;
        String client_id;
        User user;
        String username;
        String password;
        redirect_uri = request.getParameter("redirect_uri");
        client_id = request.getParameter("client_id");
        String response_type = request.getParameter("response_type");
        String confirmed = request.getParameter("confirmed");
        HashMap<String, Object> data = new HashMap<String, Object>();
        data.put("client_id", client_id);
        data.put("redirect_uri", redirect_uri);
        data.put("response_type", response_type);
        user = getUser(request);
        username = request.getParameter("username");
        password = request.getParameter("password");
        System.out.println(username);
        
        if(username != null && password != null && username != "" && password != ""){
        	user = getUserService().login(request, response, username, password, false);
        }
        
        if("tubestory.co.kr".contentEquals(client_id))
        {
            if(user.isGuest() || !"manual".equals(user.getAuth()))
            {
                return new ModelAndView("user/oauth", "data", data);
            }
            data.put("client_secret", "12345");
            authorize(request);
            userService.setOAuthCode(user.getId(), authorizationCode);
            response.sendRedirect((new StringBuilder()).append(redirect_uri).append("?code=").append(authorizationCode).append("&scope=email+profile&authuser=2&prompt=consent&response_type=code&redirect_uri=").append(redirect_uri).append("&client_id=").append(client_id).append("&client_secret=12345").toString());
        }
        return null;
    }

    public int authorize(HttpServletRequest request) {
    	try {
    		OAuthResponse response;
            OAuthAuthzRequest oauthRequest = new OAuthAuthzRequest(request);
            OAuthIssuerImpl oauthIssuerImpl = new OAuthIssuerImpl(new MD5Generator());
            String responseType = oauthRequest.getParam("response_type");
            OAuthASResponse.OAuthAuthorizationResponseBuilder builder = OAuthASResponse.authorizationResponse(request, 302);
            if(responseType.equals(ResponseType.CODE.toString()))
            {
                authorizationCode = oauthIssuerImpl.authorizationCode();
                builder.setCode(authorizationCode);
            }
            String redirectURI = oauthRequest.getParam("redirect_uri");
            response = builder.location(redirectURI).buildQueryMessage();
            URI uri = new URI(response.getLocationUri());
            Response.status(response.getResponseStatus()).location(uri).build();
            return response.getResponseStatus();
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
    	return 401;
    }
//    public int authorize(HttpServletRequest request)
//        throws URISyntaxException, OAuthSystemException
//    {
//        OAuthResponse response;
//        OAuthAuthzRequest oauthRequest = new OAuthAuthzRequest(request);
//        OAuthIssuerImpl oauthIssuerImpl = new OAuthIssuerImpl(new MD5Generator());
//        String responseType = oauthRequest.getParam("response_type");
//        org.apache.oltu.oauth2.as.response.OAuthASResponse.OAuthAuthorizationResponseBuilder builder = OAuthASResponse.authorizationResponse(request, 302);
//        if(responseType.equals(ResponseType.CODE.toString()))
//        {
//            authorizationCode = oauthIssuerImpl.authorizationCode();
//            builder.setCode(authorizationCode);
//        }
//        String redirectURI = oauthRequest.getParam("redirect_uri");
//        response = builder.location(redirectURI).buildQueryMessage();
//        URI uri = new URI(response.getLocationUri());
//        Response.status(response.getResponseStatus()).location(uri).build();
//        return response.getResponseStatus();
//        Exception e;
//        e;
//        break MISSING_BLOCK_LABEL_139;
//        e;
//        e.printStackTrace();
//        return 0;
//    }
}