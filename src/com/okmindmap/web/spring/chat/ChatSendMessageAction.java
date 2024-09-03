package com.okmindmap.web.spring.chat;

import java.io.BufferedOutputStream;
import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.service.ChatService;
import com.okmindmap.web.spring.BaseAction;

public class ChatSendMessageAction extends BaseAction {
private ChatService chatService;

	
	public void setChatService(ChatService chatService) {
		this.chatService = chatService;
	}


	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		
		BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
		
		User user = getUser(request);
		int roomnumber = ServletRequestUtils.getIntParameter(request, "roomnumber", 0);
		String message = ServletRequestUtils.getStringParameter(request, "message", "");
		String username = ServletRequestUtils.getStringParameter(request, "username", "");
		
		if(user == null || roomnumber == 0 || message.equals("")) {
			out.write(toBytes("{\"status\":\"error\", \"message\":\"Error\"}"));
		} else {
			this.chatService.insert(roomnumber, user.getId(), username, message);
			out.write(toBytes("{\"status\":\"success\", \"timecreated\":\"" + new Timestamp(new Date().getTime()) + "\"}"));
		}
		

		out.flush();
		out.close();

		return null;
		
		
	}
	
	private byte[] toBytes(String txt) {
		try {
			return txt.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return txt.getBytes();
	}
}
