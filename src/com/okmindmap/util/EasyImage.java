package com.okmindmap.util;

import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.imgscalr.Scalr.Rotation;

import com.drew.imaging.ImageMetadataReader;
import com.drew.metadata.Metadata;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.mortennobel.imagescaling.AdvancedResizeOp;
import com.mortennobel.imagescaling.MultiStepRescaleOp;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public class EasyImage {
	private BufferedImage buffer;
	private Rotation rotation;
	private boolean useQuality = false;
	private String fileType = null;
	private PatchedGifUtils reader = new PatchedGifUtils(null);
	
	private final float JPEG_QUALITY = 0.85f;
//	private final float JPEG_QUALITY = 1.0f;

	public EasyImage(File file) throws IOException {
		try{
			this.buffer = ImageIO.read(file);		
		} catch (Exception e){
			//arrayoutofboundsexception 4096 바이트 에러가 발생하는 GIF처리
			reader.setInput(ImageIO.createImageInputStream(new FileInputStream(file)));
			int ub = reader.getNumImages(true);
			BufferedImage img = null;
			for(int x=0; x<ub; x++){
				img = reader.read(x);
			}
			this.buffer = img;		
		}		
	} 

	public EasyImage(URL url) throws IOException {
		this.buffer = ImageIO.read(url);
	}

	public EasyImage(InputStream stream) throws IOException {
		this.buffer = ImageIO.read(stream);
	}

	public EasyImage(BufferedImage buffer) {
		this.buffer = buffer;
	}

	public int getWidth() {
		return this.buffer.getWidth();
	}

	public int getHeight() {
		return this.buffer.getHeight();
	}

	public boolean isUseQuality() {
		return useQuality;
	}

	public void setUseQuality(boolean useQuality) {
		this.useQuality = useQuality;
	}
	
	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public EasyImage resize(int width, int height) {
		BufferedImage dest = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics2D g = dest.createGraphics();
		g.setComposite(AlphaComposite.Src);
		g.drawImage(buffer, 0, 0, width, height, Color.WHITE, null);
		g.dispose();
		return new EasyImage(dest);
	}
	
	public EasyImage resizeJavaImageScaling(int width, int height) {
		MultiStepRescaleOp rescale = new MultiStepRescaleOp(width, height);
        rescale.setUnsharpenMask(AdvancedResizeOp.UnsharpenMask.Soft);
        
        BufferedImage bufferIm = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    	EasyImage result = new EasyImage(rescale.filter(buffer, bufferIm));
    	result.setUseQuality(useQuality);
    	return result;
	}

	public EasyImage resize(int width) {
		int resizedHeight = (width * buffer.getHeight()) / buffer.getWidth();
		return resize(width, resizedHeight);
	}
	
	public EasyImage resizeHV(int limitSize) {
		int width = buffer.getWidth();
		int height = buffer.getHeight();
		int imageSize = Math.max(buffer.getWidth(), buffer.getHeight());
		int scaleSize = Math.min(limitSize, imageSize);
		
		if(imageSize > scaleSize){
			
//			float scale = 1.0f * scaleSize / imageSize;
//			width = (int)(width * scale);
//			height = (int)(height * scale);
			
//			2018.04.17 리사이즈 계산방식 수정
			if(width >= height) {
				width = limitSize;
				height = limitSize * height / buffer.getWidth();
			} else {
				height = limitSize;
				width = limitSize * width / buffer.getHeight();
			}
			useQuality = true;
		} else if(imageSize == scaleSize){
			useQuality = true;
		}
		
		return resizeJavaImageScaling(width, height);
	}

	public long writeTo(File file) throws IOException {		
		String fileName = file.getName().toUpperCase();
		
		if(rotation != null){
			BufferedImage scaleImage = Scalr.rotate(buffer, rotation);
			//writeToJPG(scaleImage, file, JPEG_QUALITY);
			if(useQuality) {
				//writeToJPG(scaleImage, file, JPEG_QUALITY);
				if(fileName.contains("PNG")) {
					ImageIO.write(scaleImage, "png", file);
				} else {
					ImageIO.write(scaleImage, "jpg", file);
				}
			} else {
				if(fileName.contains("PNG")) {
					ImageIO.write(scaleImage, "png", file);
				} else {
					ImageIO.write(scaleImage, "jpg", file);
				}
			}
		}else{
			//writeToJPG(buffer, file, JPEG_QUALITY);
			if(useQuality) {
				//writeToJPG(buffer, file, JPEG_QUALITY);
				if(fileName.contains("PNG")) {
					ImageIO.write(buffer, "png", file);
				} else {
					ImageIO.write(buffer, "jpg", file);
				}
			} else {
				if(fileName.contains("PNG")) {
					ImageIO.write(buffer, "png", file);
				} else {
					ImageIO.write(buffer, "jpg", file);
				}
			}
		}
		return file.length();
	}
	
    private void writeToJPG(BufferedImage img, File file, float quality) throws IOException {
        FileOutputStream out = new FileOutputStream(file);

        // Encodes image as a JPEG data stream
        JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
        JPEGEncodeParam param = encoder.getDefaultJPEGEncodeParam(img);

        param.setQuality(JPEG_QUALITY, true);
        encoder.setJPEGEncodeParam(param);
        encoder.encode(img);
    }
	
	public Rotation checkRotation(InputStream inputStream){
		int orientation = 1;
		try {
			Metadata metadata = ImageMetadataReader.readMetadata(new BufferedInputStream(inputStream), false);
			ExifIFD0Directory directory = metadata.getDirectory(ExifIFD0Directory.class);
			orientation = directory.getInt(ExifIFD0Directory.TAG_ORIENTATION);
		} catch (Exception e) {}
		if(orientation==3 || orientation==4) rotation = Rotation.CW_180;
		if(orientation==5 || orientation==6) rotation = Rotation.CW_90;
		if(orientation==7 || orientation==8) rotation = Rotation.CW_270;
		return rotation;
	}

	public void writeTo(OutputStream stream, String formatName) throws IOException {
		ImageIO.write(buffer, formatName, stream);
	}

	public boolean isSuppoprtedImageFormat() {
		return buffer != null ? true : false;
	}
}
