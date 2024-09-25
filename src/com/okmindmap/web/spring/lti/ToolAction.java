package com.okmindmap.web.spring.lti;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.imsglobal.lti.launch.LtiLaunch;
import org.imsglobal.lti.launch.LtiOauthVerifier;
import org.imsglobal.lti.launch.LtiUser;
import org.imsglobal.lti.launch.LtiVerificationException;
import org.imsglobal.lti.launch.LtiVerificationResult;
import org.imsglobal.lti.launch.LtiVerifier;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.LtiProvider;
import com.okmindmap.model.User;
import com.okmindmap.service.LtiProviderService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.ShareService;
import com.okmindmap.util.PasswordEncryptor;
import com.okmindmap.web.spring.BaseAction;

public class ToolAction extends BaseAction {
	private LtiProviderService ltiProviderService;

	public void setLtiProviderService(LtiProviderService ltiProviderService) {
		this.ltiProviderService = ltiProviderService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		//Get id of Provider, each endpoint is considered as a Provider
		//ex: .../mindmap/tool.do?id=1
		long id = Long.valueOf(request.getParameter("id"));
		
		LtiVerifier ltiVerifier = new LtiOauthVerifier();
		String key = request.getParameter("oauth_consumer_key");
		LtiProvider resourse = this.ltiProviderService.getLtiProvider(id); // retrieve corresponding secret for key from DB
		LtiVerificationResult res;
		try {
			res = ltiVerifier.verify(request, resourse.getSecret());
		} catch (LtiVerificationException e) {
			// TODO Auto-generated catch block
			res = new LtiVerificationResult(); //considered as error
			e.printStackTrace();
		}
		
		if (res.getSuccess()) {
			System.out.println("Sign OK !");
			LtiLaunch data = res.getLtiLaunchResult();
//			System.out.println("UserId: " + ltiUser.getId());
//			System.out.println("ContextId: " + data.getContextId());
//			System.out.println("LaunchPresentationReturnUrl: " + data.getLaunchPresentationReturnUrl());
//			System.out.println("MessageType: " + data.getMessageType());
//			System.out.println("ResourceLinkId: " + data.getResourceLinkId());
//			System.out.println("ToolConsumerInstanceGuid: " + data.getToolConsumerInstanceGuid());
//			System.out.println("Version: " + data.getVersion());
//			Sync user data
			LtiUser ltiUser = data.getUser();
			User okmmUser = this.syncUserInfo(key, ltiUser.getId(), data.getContextId());
//			Store Lti data
			
//			Redirect to resource
			HttpSession session = request.getSession();
//			session.setAttribute("ltiprovider", resourse.getReturnUrl());
			if(resourse.getResourseType().equals("okmindmap") && okmmUser != null) {
				System.out.println("Login as : " + okmmUser.getUsername());
				getUserService().login(request, response, okmmUser.getUsername(), okmmUser.getUsername(), true);
				session.setAttribute("ltiprovi", resourse);
			}
			try {
				response.sendRedirect(resourse.getReturnUrl());
			}catch(Exception e) {
				
			}
			
		} else {
			System.out.println("Sign failed !");
			response.getWriter().append("Fail, reason: ").append(request.getContextPath());
		}
		return null;
	}
	
	private User syncUserInfo(String consumerKey, String ltiUserID, String ContextId) {
		try {
			String username = this.ltiUsernameCreator(consumerKey, ltiUserID);
			User foundUser = getUserService().get(username);			
			if(foundUser == null) {
				if(username == "") return null;
				
				User user = new User();
				user.setUsername(username);
				user.setEmail(username+"@LTI_User");
				user.setPassword(PasswordEncryptor.encrypt(username));
				user.setFirstname(ContextId);
				user.setLastname("");
				user.setAuth("lti");
				user.setConfirmed(1);
				user.setDeleted(0);
				
				getUserService().add(user);
				return getUserService().get(username);
			}else {
				return foundUser;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private String MD5(String text) throws NoSuchAlgorithmException {
		MessageDigest m=MessageDigest.getInstance("MD5");
        m.update(text.getBytes(),0,text.length());
        return new BigInteger(1,m.digest()).toString(16);
	}

	private String ltiUsernameCreator(String consumerKey, String ltiUserId){
		try {
			String userKey = "";
			if(consumerKey.length() > 0 && ltiUserId.length() > 0) {
				userKey = consumerKey + "::" +consumerKey + ":" + ltiUserId;
			}else{
				userKey = consumerKey + "::" + String.valueOf(false);
			}
			return "ltiprovider" + this.MD5(userKey);
		}catch(Exception e) {
			e.printStackTrace();
			return "";
		}
	}
}
