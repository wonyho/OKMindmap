package com.okmindmap.export;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.openxml4j.opc.PackagePartName;
import org.apache.poi.openxml4j.opc.PackagingURIHelper;
import org.apache.poi.xslf.usermodel.XMLSlideShow;

public class Video {

	private String url = "";
	private String name = "";
	private PackagePart content = null;
	private XMLSlideShow slideShow = null;
	private boolean hasVideo = false;
	private String videoCode = "";
	private String thumbnail = "";
	private byte[] thumbnailData;

	public Video(XMLSlideShow slideshow) {
		this.slideShow = slideshow;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public PackagePart getContent() {
		return content;
	}
	
	public String getVideoCode() {
		return videoCode;
	}

	public void setVideoCode(String videoCode) {
		this.videoCode = videoCode;
	}

	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}

	public byte[] getThumbnailImage() {
		return this.thumbnailData;
	}
	
	public String getUrl() {
		return url;
	}

	public void setUrl(String url, boolean load) {
		this.url = url;
		if (load) {
			this.loadVideo();
			this.loadThumbnail();
		}else {
			this.name = this.url.substring(this.url.length()-11);
			this.setThumbnail("https://img.youtube.com/vi/"+this.name+"/0.jpg");
			this.loadThumbnail();
			this.hasVideo = true;
		}
			
	}

	private void loadVideo() {
		try {
			URL videoUrl = new URL(this.url);
			this.name = videoUrl.getPath().substring(videoUrl.getPath().lastIndexOf('/') + 1);
			try {
				PackagePartName partName = PackagingURIHelper
						.createPartName("/ppt/media/" + this.videoCode + this.name);
				this.setThumbnail("https://img.youtube.com/vi/"+this.name+"/0.jpg");
				this.content = this.slideShow.getPackage().createPart(partName, "video/mpeg");
				OutputStream partOs = this.content.getOutputStream();
				InputStream fis;
				try {
					fis = videoUrl.openStream();
					byte buf[] = new byte[1024];
					for (int readBytes; (readBytes = fis.read(buf)) != -1; partOs.write(buf, 0, readBytes))
						;
					fis.close();
					partOs.close();
					this.hasVideo = true;
				} catch (IOException e) {
					e.printStackTrace();
				}
			} catch (InvalidFormatException e) {
				e.printStackTrace();
			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}

	}
	
	private void loadThumbnail() {
		this.thumbnailData = new byte[0];

		try {
			// Connect to image url
			URLConnection openConnection = (new URL(this.thumbnail)).openConnection();
			openConnection.setRequestProperty("User-Agent",
					"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11");
			openConnection.connect();

			// Extract image data
			InputStream in = new BufferedInputStream(openConnection.getInputStream());
			byte[] b = new byte[4096];
			int length = 0;
			for (length = in.read(b); length > 0; length = in.read(b)) {
				this.thumbnailData = concat(this.thumbnailData, b, 0, length);
			}
			in.close();
		} catch (IOException e) {
			this.thumbnailData = null;
			e.printStackTrace();
		}

	}

	private byte[] concat(byte[] A, byte[] B, int offset, int length) {
		byte[] C = new byte[A.length + length];
		System.arraycopy(A, 0, C, 0, A.length);
		System.arraycopy(B, 0, C, A.length, length);
		return C;
	}

	public boolean hasVideo() {
		return hasVideo;
	}
}
