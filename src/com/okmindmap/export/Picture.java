package com.okmindmap.export;

import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

public class Picture {

	// margin top for text content
	private static final int TOP = 130;
	// margin left for image content
	private static final int LEFT = 10;
	// Max width can display
	private static final int MAX_WIDTH = 700;
	// Max height can display
	private static final int MAX_HEIGHT = 400;

	private String url = "";
	private String text = "";
	private byte[] pictureData;
	private int pictureWidth = 1;
	private int pictureHeight = 1;
	private String pictureFormat = "";
	private boolean pictureLoaded = false;

	// A text line has 30 pixel in height
	// Max width of slide can show image is 940 pixel
	// Max height of slide can show image is 300 pixel,
	// if over one line up to 330 pixel
	// Start a text content at 170 pixel from top
	// To have big image size, should have size 940x330,
	// then margin left is 10 pixels
	// Define rectangle to visible image
	private int top = TOP;
	private int left = LEFT;
	private int width = MAX_WIDTH;
	private int height = MAX_HEIGHT;

	public Picture(String realPath) {
		this.pictureLoaded = false;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getUrl() {
		return this.url;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getText() {
		return this.text;
	}

	public void setTop(int top) {
		this.top = top;
	}

	public int getTop() {
		return this.top;
	}

	public void setLeft(int left) {
		this.left = left;
	}

	public int getLeft() {
		return this.left;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public int getWidth() {
		return this.width;
	}

	public void setHeight(int height) {
		this.height = height;
	}

	public int getHeight() {
		return this.height;
	}

	public byte[] getPictureData() {
		if (this.pictureLoaded) {
			return this.pictureData;
		} else {
			this.loadPictureData();
			return this.pictureData;
		}
	}

	public int getPictureHeight() {
		return this.pictureHeight;
	}

	public int getPictureWidth() {
		return this.pictureWidth;
	}

	public String getPictureFormat() {
		return this.pictureFormat;
	}

	public Rectangle getRectangle() {
		return new Rectangle(this.left, this.top, this.width, this.height);
	}

	public void setHeightAutoScale(int split) {
		this.height = this.width * this.pictureHeight / this.pictureWidth;
		if (this.height > MAX_HEIGHT / split) {
			this.height = MAX_HEIGHT / split;
			this.width = this.pictureWidth * this.height / this.pictureHeight;
		}
	}

	public void setWidthAutoScale(int split) {
		this.width = this.pictureWidth * this.height / this.pictureHeight;
		if (this.width > MAX_WIDTH / split) {
			this.width = MAX_WIDTH / split;
			this.height = this.width * this.pictureHeight / this.pictureWidth;
		}
	}
	
	public boolean pictureIsLoaded(){
		return this.pictureLoaded;
	}

	public void loadPictureData() {
		this.pictureData = new byte[0];
		if(this.pingURL(this.url, 5000))
		try {
			System.out.println(this.url);
			// Connect to image url
			URLConnection openConnection = (new URL(this.url)).openConnection();
			openConnection.setRequestProperty("User-Agent",
					"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11");
			openConnection.connect();

			// Extract image data
			InputStream in = new BufferedInputStream(openConnection.getInputStream());
			byte[] b = new byte[4096];
			int length = 0;
			for (length = in.read(b); length > 0; length = in.read(b)) {
				this.pictureData = concat(this.pictureData, b, 0, length);
			}
			in.close();

			// Get image format
			InputStream fis = new ByteArrayInputStream(this.pictureData);
			ImageInputStream iis = ImageIO.createImageInputStream(fis);
			Iterator<ImageReader> iter = ImageIO.getImageReaders(iis);
			if (!iter.hasNext()) {
				this.pictureFormat = "";
			}
			ImageReader reader = (ImageReader) iter.next();
			iis.close();
			fis.close();
			this.pictureFormat = reader.getFormatName().toUpperCase();

			ByteArrayInputStream bis = new ByteArrayInputStream(this.pictureData);
			BufferedImage image = ImageIO.read(bis);
			this.pictureWidth = image.getWidth();
			this.pictureHeight = image.getHeight();
			this.pictureLoaded = true;

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private byte[] concat(byte[] A, byte[] B, int offset, int length) {
		byte[] C = new byte[A.length + length];
		System.arraycopy(A, 0, C, 0, A.length);
		System.arraycopy(B, 0, C, A.length, length);
		return C;
	}
	
	 boolean pingURL(String url, int timeout) {
	    url = url.replaceFirst("^https", "http"); // Otherwise an exception may be thrown on invalid SSL certificates.

	    try {
	        HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
	        connection.setConnectTimeout(timeout);
	        connection.setReadTimeout(timeout);
	        connection.setRequestMethod("HEAD");
	        int responseCode = connection.getResponseCode();
	        return (200 <= responseCode && responseCode <= 399);
	    } catch (IOException exception) {
	        return false;
	    }
	}

}
