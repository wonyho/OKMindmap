package com.okmindmap.api.shorturl;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;


public final class Rapid {
	public static String shorten(final String longUrl) {
		OkHttpClient client = new OkHttpClient();
		System.out.println("LONG_URL = " + longUrl);
		RequestBody body = new FormBody.Builder()
			.add("url", longUrl)
			.build();

		Request request = new Request.Builder()
			.url("https://url-shortener-service.p.rapidapi.com/shorten")
			.post(body)
			.addHeader("content-type", "application/x-www-form-urlencoded")
			.addHeader("X-RapidAPI-Key", "32b9f2f3ecmshb5d365168f07daap1a8031jsn7152974fe46f")
			.addHeader("X-RapidAPI-Host", "url-shortener-service.p.rapidapi.com")
			.build();

		try {
			Response response = client.newCall(request).execute();
			JSONObject content;
			try {
				content = new JSONObject(response.body().string());
				System.out.println("SHORT_URL = " + content.getString("result_url"));
				return content.getString("result_url");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
}
