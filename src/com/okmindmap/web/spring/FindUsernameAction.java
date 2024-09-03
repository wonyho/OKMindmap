package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.MailService;
import com.okmindmap.util.PasswordEncryptor;

public class FindUsernameAction extends BaseAction {
	private MailService mailService;
	
	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String email = request.getParameter("email");
		
		if(email != null) {
			User user = userService.getByEmail(email);
			if(user == null) {
				request.setAttribute("error_message", getMessage("user.findusername.email_not_founded", new String[]{email}));
				return new ModelAndView("user/find_username_error");
			} else {
				// 이메일 보내기
				this.mailService.sendMail(email, getMessage("user.findusername.smtp_subject", null), getMessage("user.findusername.smtp_body", new String[]{user.getUsername()}));
				
				request.setAttribute("message", getMessage("user.findusername.sent_email", new String[]{email}));
				return new ModelAndView("user/find_username_2");
			}
		} else {
			return new ModelAndView("user/find_username");
		}
	}

}
