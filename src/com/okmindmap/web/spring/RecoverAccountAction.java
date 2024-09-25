package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.MailService;
import com.okmindmap.util.PasswordEncryptor;

public class RecoverAccountAction extends BaseAction {
	private MailService mailService;
	
	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		
		if(username != null && email != null) {
			User user = userService.get(username);
			if(user == null) {
				request.setAttribute("error_message", getMessage("user.recover.username_not_founded", new String[]{username}));
				return new ModelAndView("user/recover_password_error");
			} else if(!email.equals(user.getEmail())) {
				request.setAttribute("error_message", getMessage("user.recover.email_not_match", new String[]{username, email}));
				return new ModelAndView("user/recover_password_error");
			} else {
				// 비밀번호 변경
				String password = generatePassword(true, true, true, false, 10);
				user.setPassword( PasswordEncryptor.encrypt(password));
				getUserService().update(user);
				
				// 이메일 보내기
				this.mailService.sendMail(email, getMessage("user.recover.smtp_subject", null), getMessage("user.recover.smtp_body", new String[]{password}));
				
				request.setAttribute("message", getMessage("user.recover.sent_email", new String[]{email}));
				return new ModelAndView("user/recover_password_2");
			}
		} else {
			return new ModelAndView("user/recover_password");
		}
	}
	
	private String generatePassword(boolean useDG, boolean useUpperCase, boolean useLowerCase, boolean usePunctuation, int length) {
		String srcStr = "";
		if(useDG)          srcStr += "1234567890";
		if(useUpperCase)   srcStr += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		if(useLowerCase)   srcStr += "abcdefghijklmnopqrstuvwxyz";
		if(usePunctuation) srcStr += "~!@#$%^&*()_=+-[]{}<>,.;:'";
		
		int srcLength = srcStr.length();
		if(srcLength == 0) {
			return "";
		}
		
		if( length < 1 )   length = 1;
		if( length > 128 ) length = 128;
		
		String str = "";
		do {
			int x = (int)Math.floor( Math.random() * srcLength );
			str += srcStr.charAt(x);
		} while ( str.length() < length);
		
		return str;
	}

}
