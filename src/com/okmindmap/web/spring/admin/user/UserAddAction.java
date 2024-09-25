package com.okmindmap.web.spring.admin.user;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.model.User;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.service.MailService;
import com.okmindmap.service.PricingService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.util.PasswordEncryptor;
import com.okmindmap.web.spring.BaseAction;

public class UserAddAction extends BaseAction {
	private MailService mailService;
	private PricingService pricingService;
	private RepositoryService repositoryService;
	
	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}
	
	public void setPricingService(PricingService pricingService) {
		this.pricingService = pricingService;
	}
	
	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}

	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String adduser = request.getParameter("adduser");
		
		if(adduser != null && adduser != "" && Integer.parseInt(adduser) == 1) {
			String username = request.getParameter("username");
			String email = request.getParameter("email");
			String firstname = request.getParameter("firstname");
			String lastname = request.getParameter("lastname");
			String password = request.getParameter("password");
//			String password1 = request.getParameter("password1");
			
			String account_level = request.getParameter("account_level");
			
			User adminuser = getUser(request);
			if(adminuser.getRoleId()!=1){
				PrintError(response, "Access not permitted.");
				return null;
			}
			if(username == null || username.trim() == "") {
				PrintError(response, "Required username.");
				return null;
			}
			if(lastname == null || lastname.trim() == "") {
				PrintError(response, "Required lastname.");
				return null;
			}
			if(firstname == null || firstname.trim() == "") {
				PrintError(response, "Required firstname.");
				return null;
			}
			if(email == null || email.trim() == "") {
				PrintError(response, "Required email.");
				return null;
			}
			
			// 아이디 검사			
			if(this.userService.isUsernameExist(username)) {
				PrintError(response, "Username already exists.");
				return null;
			}
			// 메일 검사
			User testuseremail = getUserService().getByEmail(email);
			if(testuseremail != null) {
				PrintError(response, "Email already exists.");
				return null;
			}
			
			// 비번 생성
			if(password == null || password.trim() == "") {
				// 비밀번호 생성
				password = generatePassword(true, true, true, false, 10);
				
				// 비번 이메일 보내기
				this.mailService.sendMail(email, getMessage("admin.newuser.smtp_subject", null), getMessage("admin.newuser.smtp_body", new String[]{password}));				
			}
			
			User user = new User();
			user.setUsername(username.trim());
			user.setEmail(email.trim());
			user.setPassword( PasswordEncryptor.encrypt(password));
//			user.setFirstname( new String(firstname.trim().getBytes("ISO-8859-1"), "UTF-8") );
//			user.setLastname(new String(lastname.trim().getBytes("ISO-8859-1"), "UTF-8"));
			user.setFirstname( firstname.trim() );
			user.setLastname( lastname.trim() );
			user.setAuth("manual");
			user.setConfirmed(0);
			user.setDeleted(0);
			
			// cseung set validation code;
			String generated="";
			for(int i=0; i<10; i++) {
				generated += new Random().nextInt(9);
			}
			user.setValidation(PasswordEncryptor.encrypt(generated));
			
			if(this.mailService != null) {
				int user_id = getUserService().add(user);
				if(user_id < 0) return new ModelAndView("user/new");
				String html = "<h1>Welcome to Tubestory!</h1> "
						+ "<p>Thank for your creating account. Please confirm your email to continue:</p>"
						+ "<br/><a style='background-color: #4CAF50;border: none; "
						+ "color: white;padding: 15px 32px;text-align: center; "
						+ "text-decoration: none; display: inline-block; "
						+ "font-size: 16px; margin: 4px 2px; cursor: pointer;' "
						+ " href='" + this.getBaseUrl(request) + "/user/validation.do?code="+generated+"&uid="+user_id 
						+ "'>Click here to confirm</a>"
						+ "<p>Please let us know if you need a help.</p><p> Thanks!</p>";
				this.mailService.sendMail(user.getEmail(), "Verify your Tubestory account", html, "html");
				
				if(!(user_id < 0)) {
					if(account_level != null) {
						this.pricingService.insertTierMember(Integer.parseInt(account_level), user_id, true, 0);
					}
					
					JSONArray json = JSONArray.fromObject(user);
					OutputStream out = response.getOutputStream();
					out.write(json.toString().getBytes("UTF-8"));
					out.close();
					return null;
				}
			}
		}
		
		List<Tier> tiers = this.pricingService.getAllTiers(1, -1, null, null, null, true);
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("tiers", tiers);
		
		
		return new ModelAndView("admin/users/add", "data", data);
	}
	
	private void PrintError(HttpServletResponse response, String error) throws IOException {
		OutputStream out = response.getOutputStream();
		out.write(error.getBytes());
		out.close();
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
	
	public String getBaseUrl(HttpServletRequest request) {
	    String scheme = request.getScheme();
	    String contextPath = request.getContextPath();

	    String baseUrl = scheme + "://" + this.repositoryService.baseUrl() + contextPath;
	    return baseUrl;
	}
}
