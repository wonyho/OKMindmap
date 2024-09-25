package com.okmindmap.web.spring;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.service.MailService;
import com.okmindmap.web.spring.BaseAction;

public class ContactMailSender extends BaseAction {
	private MailService mailService;
	
	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String name = request.getParameter("txtName");
		String mail = request.getParameter("txtEmail");
		String phone = request.getParameter("txtPhone");
		String id = request.getParameter("txtID");
		String content = request.getParameter("txtContent");
		
		String text = "0";
		if(name != null && name != "" && mail != null && mail != "" && content != null && content != "") {
			if(this.mailService != null) {
				LocalDateTime timeid = LocalDateTime.now();
				DateTimeFormatter time = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
				String html = "<h1>Tubestory contact mail !</h1> "
						+ "<p>Fullname: "+name+"</p>"
						+ "<p>Email: "+mail+"</p>"
						+ "<p>Phone: "+phone+"</p>"
						+ "<p>Tubestory ID: "+id+"</p>"
						+ "<p>Content: "+content+"</p>"
						+ "<p>Sent time: "+timeid.format(time)+"</p>";
				String html2 = "<h1>Thank for your contact !</h1> "
						+ "<p style=\"color: red;\">We got your info as bellow :</p>"
						+ "<p>Fullname: "+name+"</p>"
						+ "<p>Email: "+mail+"</p>"
						+ "<p>Phone: "+phone+"</p>"
						+ "<p>Tubestory ID: "+id+"</p>"
						+ "<p>Content: "+content+"</p>"
						+ "<p>Sent time: "+timeid.format(time)+"</p>"
						+ "<p style=\"color: red;\">We will check and feedback to you soon. Please let us know if you need a help.</p><p style=\"color: red;\"> Thanks!</p>";
				this.mailService.sendMail("csetempmail@gmail.com", "Tubestory contact mail - " + timeid.format(time), html, "html");
				this.mailService.sendMail("support@intube.kr", "Tubestory contact mail - " + timeid.format(time), html, "html");
				this.mailService.sendMail(mail, "Thank for your contact", html2, "html");
				
				text = "1";
			}
		}
		
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(text);

		return null;
	}
}
