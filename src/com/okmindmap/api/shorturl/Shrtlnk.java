package com.okmindmap.api.shorturl;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public final class Shrtlnk {
	public static String shorten(final String longUrl) {
		OkHttpClient client = new OkHttpClient();
		System.out.println("LONG_URL = " + longUrl);
		RequestBody body = new FormBody.Builder().add("url", longUrl).build();

		Request request = new Request.Builder().addHeader("api-key", "05f3i2VYC7HkP6fcSGD8wk2xTwQ8TQiAtMNh2Ris1kmRT")
				.addHeader("Accept", "application/json").addHeader("Content-Type", "application/json")
				.url("https://www.shrtlnk.dev/api/v2/link").post(body).build();

		try {
			Response response = client.newCall(request).execute();
			JSONObject content;
			try {
				System.out.println(response.body().string());
				content = new JSONObject(response.body().string());
				System.out.println(content);
				System.out.println("SHORT_URL = " + content.getString("shrtlnk"));
				return content.getString("shrtlnk");
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
