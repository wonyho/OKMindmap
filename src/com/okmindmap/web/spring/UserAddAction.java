package com.okmindmap.web.spring;

import java.nio.charset.Charset;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.octo.captcha.module.servlet.image.SimpleImageCaptchaServlet;
import com.okmindmap.model.User;
import com.okmindmap.service.MailService;
import com.okmindmap.service.OKMindmapService;
import com.okmindmap.service.PricingService;
import com.okmindmap.service.RepositoryService;
import com.okmindmap.util.PasswordEncryptor;

public class UserAddAction extends BaseAction {
	
	private OKMindmapService okmindmapService;
	private PricingService pricingService;
	private MailService mailService;
	private RepositoryService repositoryService;
	
	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}
	
	public void setOkmindmapService(OKMindmapService okmindmapService) {
		this.okmindmapService = okmindmapService;
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
		
		String confirmed = request.getParameter("confirmed");

		if(confirmed != null && Integer.parseInt(confirmed) == 1) {
			
			String userCaptchaResponse = request.getParameter("japtcha");
			
			boolean captchaPassed = SimpleImageCaptchaServlet.validateResponse(request, userCaptchaResponse);
//			System.out.println(userCaptchaResponse);
			if(captchaPassed){
				String username = request.getParameter("username");
				String email = request.getParameter("email");
				String firstname = request.getParameter("firstname");
				String lastname = request.getParameter("lastname");
				String password = request.getParameter("password");
				String password1 = request.getParameter("password1");
				String facebook = request.getParameter("facebook");
				
				String register_role = request.getParameter("register_role");
				String school_name = request.getParameter("school_name");
				
				if(username == null || username.trim() == "") {
					return new ModelAndView("user/new", "required", "username");
				}
				if(email == null || email.trim() == "") {
					return new ModelAndView("user/new", "required", "email");
				}
				if(firstname == null || firstname.trim() == "") {
					return new ModelAndView("user/new", "required", "firstname");
				}
				if(lastname == null || lastname.trim() == "") {
					return new ModelAndView("user/new", "required", "lastname");
				}
				if(password == null || password1 == null || !password.equals(password1)) {
					return new ModelAndView("user/new", "required", "password");
				}
				
				User user = new User();
				user.setUsername(username.trim());
				user.setEmail(email.trim());
				user.setPassword( PasswordEncryptor.encrypt(password));
//				user.setFirstname( new String(firstname.trim().getBytes("ISO-8859-1"), "UTF-8") );
//				user.setLastname(new String(lastname.trim().getBytes("ISO-8859-1"), "UTF-8"));
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

				// 패북으로 가입시 가입후 바로 로그인.
				// 이미 페북으로 가입되어 있음 바로 로그인.
				if(facebook != null && facebook != "") {
					user.setFacebookAccessToken(facebook);
					
					User facebookMan = getUserService().loginFromFacebook(request, response, facebook);
					
					if(facebookMan == null) {
						int user_id = getUserService().add(user);
						if(user_id < 0) return new ModelAndView("user/new");
						
						if(register_role != null && school_name != null) {
							String teacher_role = this.okmindmapService.getSetting("default_account_level_teacher");
							if(teacher_role != null) {
								this.pricingService.insertTierMember(Integer.parseInt(teacher_role), user_id, true, 0);
								getUserService().setUserConfigData(user_id, "school_name", school_name);
							}
						}
						
						facebookMan = getUserService().loginFromFacebook(request, response, facebook);
					}
					
					if(facebookMan != null) {	// 성공
//						String url = getOptionalParam(request, "return_url", null);
//						if(url == null || url.trim() == "") {
//							url = request.getContextPath() + "/index.do";
//						}
//						response.getOutputStream().write(url.getBytes());
						response.getOutputStream().write("1".getBytes());
					} else {					// 실패
						response.getOutputStream().write("0".getBytes());
					}
					return null;
				} else {
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
						
						if(register_role != null && school_name != null) {
							String teacher_role = this.okmindmapService.getSetting("default_account_level_teacher");
							if(teacher_role != null) {
								this.pricingService.insertTierMember(Integer.parseInt(teacher_role), user_id, true, 0);
								getUserService().setUserConfigData(user_id, "school_name", school_name);
							}
						}
						return new ModelAndView("user/pleaseconfirm2");
					}
				}
			}else{
			// return error to user
				
			}
		}
		return new ModelAndView("user/new");
	}
	
	public String getBaseUrl(HttpServletRequest request) {
	    String scheme = request.getScheme();
	    String contextPath = request.getContextPath();

	    String baseUrl = scheme + "://" + this.repositoryService.baseUrl() + contextPath;
	    return baseUrl;
	}
}
