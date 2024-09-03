package com.okmindmap.export;

import java.util.concurrent.TimeUnit;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class Iframe {

	private String url="";
	private byte[] captured;
	private int waitingSecond = 45;
	private String realPath;
	private boolean hasIframe = false;
	
	public Iframe(String realPath) {
		this.realPath = realPath;
	}
	
	public Iframe(String url, String realPath) {
		this.url = url;
		this.realPath = realPath;
		this.captureUrl();
	}
	
	public void setUrl(String url) {
		this.url = url;
		this.captureUrl();
	}
	
	public String getUrl() {
		return this.url;
	}
	
	public byte[] getCapturedImage() {
		return this.captured;
	}
	
	public boolean hasIframe() {
		return this.hasIframe;
	}
	
	private void captureUrl() {
		this.captured = new byte[0];
		try {
			System.setProperty("webdriver.gecko.driver", this.realPath + "plugin/slideshow/geckodriver");
			//System.setProperty("webdriver.gecko.driver", "/home/cseadmin/Jinotech/okmindmap/war/plugin/slideshow/geckodriver");
			WebDriver driver = new FirefoxDriver();
			try {
				driver.get(this.url);
				driver.manage().timeouts().implicitlyWait(this.waitingSecond, TimeUnit.SECONDS);
				driver.manage().window().maximize();
				TimeUnit.SECONDS.sleep(3);
				this.captured = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
				this.hasIframe = true;
				driver.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}
