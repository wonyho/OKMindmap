package com.okmindmap.api.sa;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.net.http.HttpRequest;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.model.sa.ApiKey;
import com.okmindmap.model.sa.OkmCloud;
import com.okmindmap.service.UserService;

public class SuperAdminManager {
	public static boolean isSA(User user) {
		if (user.getUsername().toLowerCase().equals("wonho"))
			return true;
		if (user.getUsername().toLowerCase().equals("okmmdev"))
			return true; // temp account for dev testing
		return false;
	}

	public static ModelAndView requestSA(UserService userService, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			userService.logout(request, response);
			response.sendRedirect(request.getContextPath() + "/");
		} catch (Exception e) {
			return new ModelAndView("error/index", "message", e.getMessage());
		}

		return null;
	}

	public static boolean sureExistedUserConfigField(UserService userService, String key, String descript) {
		try {
			return userService.sureConfigFieldExisted(key, descript);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

	public static List<ApiKey> getApiKeys(UserService userService, String key) {
		int userid = 1; // always is admin
		try {
			Gson gson = new Gson();
			UserConfigData data = userService.getUserConfigData(userid, key);
			if (data != null) {
				return gson.fromJson(data.getData(), new TypeToken<ArrayList<ApiKey>>() {
				}.getType());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new ArrayList<ApiKey>();
	}

	public static String getActiveGoogleSearchKey(UserService userService, String searchType) {
		int userid = 1; // always is admin
		List<ApiKey> keys = SuperAdminManager.getApiKeys(userService, "sa_google_api_keys");
		int minu = 999999;
		int idx = 0;
		String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		for (int i = 0; i < keys.size(); i++) {
			if (!today.equals(keys.get(i).getLastUsed(searchType))) {
				keys.get(i).setLastUsed(searchType, today);
				keys.get(i).setCounter(searchType, 0);
				idx = i;
				break;
			}
			if (keys.get(i).getCounter(searchType) < minu) {
				minu = keys.get(i).getCounter(searchType);
				idx = i;
			}
		}
		ApiKey key = keys.get(idx);
		key.increaCounter(searchType + "_all");
		key.increaCounter(searchType);
		Gson gson = new Gson();
		try {
			userService.setUserConfigData(userid, "sa_google_api_keys",
					gson.toJson(keys, new TypeToken<ArrayList<ApiKey>>() {
					}.getType()));
			return keys.get(idx).getKey();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "AIzaSyA5j1VZ3hJccqvMQZ8h_nWAl5kzRMZNnUQ";
	}

	public static String getActiveTranslateKey(UserService userService) {
		int userid = 1; // always is admin
		List<ApiKey> keys = SuperAdminManager.getApiKeys(userService, "sa_aitranlate_api_keys");
		int minu = 999999;
		int idx = 0;
		String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		for (int i = 0; i < keys.size(); i++) {
			if (!today.equals(keys.get(i).getLastUsed("day"))) {
				keys.get(i).setLastUsed("day", today);
				keys.get(i).setCounter("day", 0);
				idx = i;
				break;
			}

			if (keys.get(i).getCounter("day") < minu) {
				minu = keys.get(i).getCounter("day");
				idx = i;
			}
		}
		ApiKey key = keys.get(idx);
		key.increaCounter("total");
		key.increaCounter("day");

		String month = new SimpleDateFormat("yyyy-MM").format(new Date());
		if (month.equals(key.getLastUsed("month"))) {
			key.increaCounter("month");
		} else {
			key.setCounter("month", 1);
			key.setLastUsed("month", month);
		}
		String year = new SimpleDateFormat("yyyy").format(new Date());
		if (year.equals(key.getLastUsed("year"))) {
			key.increaCounter("year");
		} else {
			key.setCounter("year", 1);
			key.setLastUsed("year", year);
		}
		Gson gson = new Gson();
		try {
			userService.setUserConfigData(userid, "sa_aitranlate_api_keys",
					gson.toJson(keys, new TypeToken<ArrayList<ApiKey>>() {
					}.getType()));
			return keys.get(idx).getKey();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "32b9f2f3ecmshb5d365168f07daap1a8031jsn7152974fe46f";
	}

	public static String getHttpsInputStream(String https_url) {
		TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
			public java.security.cert.X509Certificate[] getAcceptedIssuers() {
				return null;
			}

			public void checkClientTrusted(X509Certificate[] certs, String authType) {
			}

			public void checkServerTrusted(X509Certificate[] certs, String authType) {
			}
		} };

		BufferedReader in = null;
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

			in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		String content = "";
		if (in != null) {

			String inputLine = "";
			try {
				while ((inputLine = in.readLine()) != null) {
					content += inputLine;
				}
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		return content;
	}

	public static HttpRequest.Builder makeOkmCloudRequest(UserService userService, String path) {
		int userid = 1; // always is admin
		UserConfigData data;
		try {
			data = userService.getUserConfigData(userid, "sa_okmcloud_api_connection");
			if (data != null) {
				Gson gson = new Gson();
				OkmCloud cloud = gson.fromJson(data.getData(), OkmCloud.class);
				return HttpRequest.newBuilder().uri(URI.create(cloud.getUrl() + "/okmcloud/info"))
						.header("content-type", "application/json")
						.header("app", cloud.getApp())
						.header("user", cloud.getUser())
						.header("key", cloud.getKey())
						.header("token", cloud.getToken());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}
}

//ALTER TABLE `mm_user_config_data` CHANGE `data` `data` MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL;
