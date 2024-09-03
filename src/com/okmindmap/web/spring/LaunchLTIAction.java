package com.okmindmap.web.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.okmindmap.ActionDigester;
import com.okmindmap.action.Action;
import com.okmindmap.action.MoveAction;
import com.okmindmap.action.NewAction;
import com.okmindmap.model.Node;
import com.okmindmap.model.User;
import com.okmindmap.service.MindmapService;
import com.okmindmap.model.Attribute;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.security.cert.X509Certificate;
import java.util.*;
import org.imsglobal.lti.launch.*;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

public class LaunchLTIAction extends BaseAction {

	private MindmapService mindmapService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String mapid = request.getParameter("map");
		String identity = request.getParameter("node");
		

	    if(mapid != null && identity != null) {
			int map_id = Integer.parseInt(mapid);
			Node node = this.mindmapService.getNode(identity, map_id, false);

			if(node != null) {
				String url = null, secret = "", key = "";
				List<Attribute> attrs = node.getAttributes();
				for (int i = 0; i < attrs.size(); i++) {
					if (attrs.get(i).getName().equals("url"))
						url = attrs.get(i).getValue();
					else if (attrs.get(i).getName().equals("secret"))
						secret = attrs.get(i).getValue();
					else if (attrs.get(i).getName().equals("key"))
						key = attrs.get(i).getValue();
					
				}
				if (url != null) {
					// get secure launch url
					BufferedReader in = null;
					if(url.indexOf("https://") > -1) {
						in = this.getHttpsInputStream(url);
					}else {
						URL xml = new URL(url);
						in = new BufferedReader(new InputStreamReader(xml.openStream()));
					}
					
//					URL obj = new URL(url);
//					HttpURLConnection con = (HttpURLConnection) obj.openConnection();
//					con.setRequestMethod("GET");
//					BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
//					
					if(in != null) {
						String content = "";
						String inputLine = "";
						while((inputLine = in.readLine()) != null) {
							content += inputLine;
						}
						in.close();
						if(content.indexOf("<blti:secure_launch_url>") > -1) {
							int start = content.indexOf("<blti:secure_launch_url>");
							int end = content.indexOf("</blti:secure_launch_url>");
							if(start > -1 && end > start) {
								url = content.substring(start + "<blti:secure_launch_url>".length(), end);
							}
						} 
					}
					
					// end secure launch url
					LtiSigner ltiSigner = new LtiOauthSigner();
					Map<String, String> params = new HashMap<String, String>();
					
					User user = getUser(request);
					String userID = String.valueOf(user.getId());
					String email = user.getEmail();
					String firstName = user.getFirstname();
					String lastName = user.getLastname();
					boolean isGuest = false;
					if(user == null) 
						isGuest = true;
					else if(user.getUsername().equals("guest")) 
						isGuest = true;
					if(isGuest) {
						userID =  "2"; 
						firstName = "Guest";
						lastName = "Guest";
						email = "guest@jinotech.com";
					}
					
					params.put("roles",									"urn:lti:instrole:ims/lis/Student"); //Instructor
					
					params.put("launch_presentation_document_target", 	"frame");
					params.put("launch_presentation_locale", 			"en-GB");
					
					params.put("user_id",							"OKMM_" + userID);
					params.put("lis_person_contact_email_primary",		email);
					params.put("lis_person_name_family",				lastName);
					params.put("lis_person_name_full", 					firstName + " " + lastName);
					params.put("lis_person_name_given", 				firstName);
					
					StringBuilder requestURL = new StringBuilder(request.getRequestURL().toString());
					String Url = requestURL.toString();
					
					params.put("lis_outcome_service_url",					Url.substring(0,Url.indexOf("/mindmap/"))+"/mindmap/lis.do?map=" + mapid + "&node=" + node.getId());
					params.put("lis_result_sourcedid",						userID+":"+mapid+":"+String.valueOf(node.getId()));
					
					params.put("lti_message_type", 						"basic-lti-launch-request");
					params.put("lti_version", 							"LTI-1p0");
					params.put("oauth_callback", 						"about:blank");
					
					params.put("resource_link_id",						String.valueOf(node.getId()));
					params.put("resource_link_title",					node.getText());
					params.put("resource_link_description",				node.getText());
					
					params.put("context_id",							mapid);
					
					params.put("roles",									"urn:lti:instrole:ims/lis/Student"); //Instructor
					params.put("tool_consumer_info_product_family_code","okmm");
					params.put("tool_consumer_info_version", 			"1.0");
					params.put("tool_consumer_instance_contact_email",	"okmindmap@jinotech.com");
					params.put("tool_consumer_instance_description",	"Tubestory mindmap");
					params.put("tool_consumer_instance_name",			"Tubestory");
					
					params.put("tool_consumer_instance_guid", 			"tubestory.co.kr"); //very important !
					key = "tubestory:" + mapid + ":" + node.getId();
										
					/*
					 * int idx = url.indexOf("?"); // url of node, get from node attr if(idx > 0) {
					 * String paraString = url.substring(idx + 1); String[] paraArray =
					 * paraString.split("&"); for(String para : paraArray) { String[] temp =
					 * para.split("="); params.put(temp[0], temp[1]); } }
					 */
					
					Map<String, String> signedParameters = ltiSigner.signParameters(params, key, secret, url, "POST");

					String result = "<html><body onload='document.getElementById(\"launchform\").submit()' >";
					result += "<form id='launchform' method='POST' enctype='application/x-www-form-urlencoded' action='" + url + "'>";
					
					for (Map.Entry<String, String> param : signedParameters.entrySet()) {
		        		result += "<input type='hidden' name='" + param.getKey() + "' value='" + param.getValue() + "'>";
		    		}
					result += "<button type='submit'>Launch</button>"
						+ "</form></body></html>";

				    response.getOutputStream().write(result.getBytes());
				} else
					response.getOutputStream().write(("Url null attrs:" + url).getBytes());
			} else
				response.getOutputStream().write("Node null".getBytes());
		}
		
		return null;
		
	}
	
	private BufferedReader getHttpsInputStream(String https_url) {
		TrustManager[] trustAllCerts = new TrustManager[] { 
			new X509TrustManager() {
				public java.security.cert.X509Certificate[] getAcceptedIssuers() {
					return null;
				}
	
				public void checkClientTrusted(X509Certificate[] certs, String authType) {
				}
	
				public void checkServerTrusted(X509Certificate[] certs, String authType) {
				}
			} 
		};
		
		try {
			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

			// Create all-trusting host name verifier
			HostnameVerifier allHostsValid = new HostnameVerifier() {
				public boolean verify(String hostname, SSLSession session) {
					return true;
				}
			};
			// Install the all-trusting host verifier
			HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

			URL _url = new URL(https_url);
			URLConnection con = _url.openConnection();
			
			
			return new BufferedReader( new InputStreamReader(con.getInputStream()));
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
