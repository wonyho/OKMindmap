package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.UserService;
import com.okmindmap.util.PasswordEncryptor;

public class UserConfirmAction extends BaseAction {
	private UserService userService = null;
	
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		String uid = request.getParameter("uid");
		
		String codedb = this.userService.getValidateCode(Integer.parseInt(uid));
	    
	    if(codedb != null) {
	    	if(codedb.equals(PasswordEncryptor.encrypt(code))) {
	    		User usr = this.userService.get(Integer.parseInt(uid));
	    		usr.setConfirmed(1);
	    		if(this.userService.update(usr) > -1) {
	    			return new ModelAndView("user/confirmed");
	    		}
	    	}
	    }
	    return new ModelAndView("error/index");
	}
}

