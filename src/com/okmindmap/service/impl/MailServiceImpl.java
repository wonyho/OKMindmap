package com.okmindmap.service.impl;

import java.util.List;

import javax.mail.*;  
import javax.mail.internet.*;  

import org.springframework.mail.javamail.JavaMailSender;
import com.okmindmap.service.MailService;

public class MailServiceImpl implements MailService {

	private JavaMailSender mailSender;
	
	public void setMailSender(JavaMailSender mailSender){
		this.mailSender = mailSender;
	}
	
	@Override
	public void sendMail(String to, String subject, String body) {
		sendMail(new String[]{to}, subject, body);
	}
	
	@Override
	public void sendMail(String to, String subject, String body, String type) {
		sendMail(new String[]{to}, subject, body, type);
	}

	@Override
	public void sendMail(List<String> to, String subject, String body) {
		sendMail(to.toArray(new String[to.size()]), subject, body);
	}

	@Override
	public void sendMail(String[] to, String subject, String body) {
		MimeMessage message = mailSender.createMimeMessage();

		try {
			InternetAddress addresses[] = new InternetAddress[to.length];
			for(int i = 0; i < to.length; i++) {
				addresses[i] = new InternetAddress(to[i]);
			}
			message.addRecipients(Message.RecipientType.TO, addresses);
			message.setSubject(subject, "UTF-8");
			message.setText(body, "UTF-8");
			
			mailSender.send(message);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public void sendMail(String[] to, String subject, String body, String type) {
		MimeMessage message = mailSender.createMimeMessage();
		if(type.equals("text")) {
			try {
				InternetAddress addresses[] = new InternetAddress[to.length];
				for(int i = 0; i < to.length; i++) {
					addresses[i] = new InternetAddress(to[i]);
				}
				message.addRecipients(Message.RecipientType.TO, addresses);
				message.setSubject(subject, "UTF-8");
				message.setText(body, "UTF-8");
				mailSender.send(message);
			} catch (MessagingException e) {
				e.printStackTrace();
			}
		}else if(type.equals("html")) {
			try {
				InternetAddress addresses[] = new InternetAddress[to.length];
				for(int i = 0; i < to.length; i++) {
					addresses[i] = new InternetAddress(to[i]);
				}
				message.addRecipients(Message.RecipientType.TO, addresses);
				message.setSubject(subject, "UTF-8");
				// Create the message part 
				MimeBodyPart messageBodyPart = new MimeBodyPart();
				// Fill the message
				messageBodyPart.setText(body,"UTF-8","html");
				Multipart multipart = new MimeMultipart();
				multipart.addBodyPart(messageBodyPart);
				message.setContent(multipart);
				mailSender.send(message);

		        
			} catch (MessagingException e) {
				e.printStackTrace();
			}
		}else if(type.equals("file")) {
			
		}
		
		
	}

}
