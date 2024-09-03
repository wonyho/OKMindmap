package com.okmindmap.web.spring;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.AccountConnection;
import com.okmindmap.model.User;
import com.okmindmap.service.AccountConnectionService;
import com.okmindmap.util.PasswordEncryptor;

public class UserUpdateAction extends BaseAction {
	
	private AccountConnectionService accountConnectionService;
	
	public void setAccountConnectionService(AccountConnectionService accountConnectionService) {
		this.accountConnectionService = accountConnectionService;
	}

	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String confirmed = request.getParameter("confirmed");
		String userid = request.getParameter("userid");
		String redirect_url = request.getParameter("redirect_url");

		User user = getUser(request);
		HashMap<String, Object> data = new HashMap<String, Object>();
		if(user.getRoleId() == 1 && userid != null && userid != "") {
			user = getUserService().get(Integer.parseInt(userid));
		}
		
		if(confirmed != null && Integer.parseInt(confirmed) == 1) {
			String email = ServletRequestUtils.getStringParameter(request, "email");
			String firstname = ServletRequestUtils.getStringParameter(request, "firstname");
			String lastname = ServletRequestUtils.getStringParameter(request, "lastname");
			String password = ServletRequestUtils.getStringParameter(request, "password");
			String password1 = ServletRequestUtils.getStringParameter(request, "password1");
			
			if(user == null ) {
				return new ModelAndView("user/edit", "error", "user_not_exists");
			} else if(user.getUsername().equals("guest")) {
				return new ModelAndView("user/edit", "error", "not_login");
			}
			
			if(email == null || email.trim() == "") {
				return new ModelAndView("user/edit", "required", "email");
			}
			if(firstname == null || firstname.trim() == "") {
				return new ModelAndView("user/edit", "required", "firstname");
			}
			if(lastname == null || lastname.trim() == "") {
				return new ModelAndView("user/edit", "required", "lastname");
			}
			
			
			if(password != null && password.trim().length() > 0) {
				if(!password.equals(password1)) {
					return new ModelAndView("user/new", "error", "password_not_equal");
				} else {
					user.setPassword( PasswordEncryptor.encrypt(password));
				}
			}
			
			user.setEmail(email.trim());
			user.setFirstname( firstname.trim() );
			user.setLastname( lastname.trim() );
			
			getUserService().update(user);
			
			HashMap<String, String> data2 = new HashMap<String, String>();
			data2.put("redirect_url", redirect_url);
			
			return new ModelAndView("user/edit_complete",  "data", data2);
		} else {
			if(user == null || user.getUsername().equals("guest")) {
				HashMap<String, String> data3 = new HashMap<String, String>();
				data3.put("messag", "not_login");
				data3.put("url", "/");
				return new ModelAndView("error/index", "data", data3);
			}
			
			List<AccountConnection> connections = this.accountConnectionService.getConnection(user.getId());
			data.put("user", user);
			data.put("connection", connections);
			return new ModelAndView("user/edit", "data", data);
		}
	}
	
}
