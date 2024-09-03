package com.okmindmap.api.shorturl;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;


public final class Shrtcode {
	public static String shorten(final String longUrl) {
		OkHttpClient client = new OkHttpClient();
		System.out.println("LONG_URL = " + longUrl);
		RequestBody body = new FormBody.Builder()
			.add("url", longUrl)
			.build();

		Request request = new Request.Builder()
			.url("https://api.shrtco.de/v2/shorten")
			.post(body)
			.build();

		try {
			Response response = client.newCall(request).execute();
			JSONObject content;
			try {
				content = (new JSONObject(response.body().string())).getJSONObject("result");
				System.out.println("SHORT_URL = " + content.getString("short_link"));
				return content.getString("short_link");
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
