package com.okmindmap.util;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.logging.Logger;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import org.apache.sanselan.formats.jpeg.exifRewrite.ExifRewriter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.drew.imaging.jpeg.JpegMetadataReader;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import com.drew.metadata.exif.ExifReader;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGDecodeParam;
import com.sun.image.codec.jpeg.JPEGImageDecoder;

public class ImageUtils {
	
	private static final long JPG_RESIZE_SKIP_SIZE = 262144;	// 256 Kbyte
	
	/**
	 * 이미지 resize & rotate
	 * @param file
	 * @param fileUploadMap
	 * @return
	 */
	public static Map<String, Object> resizeImage(CommonsMultipartFile file, String filepath, int limitWidth) {
		String fileName = null;
        String path = null;
        long fileSize = 0;
        
		Map<String, Object> fileMap = new HashMap<String, Object>();
		try {
			EasyImage image = new EasyImage(file.getInputStream());
			if(image.isSuppoprtedImageFormat()){
				fileName = file.getOriginalFilename();
				if(fileName != null && fileName.lastIndexOf(".") > 0) {
					image.setFileType(fileName.substring(fileName.lastIndexOf(".") + 1).toUpperCase());
				}
				
				image = image.resizeHV(limitWidth);
				image.checkRotation(file.getInputStream());
				File saveFile = new File(filepath);
				
				path = saveFile.getAbsolutePath();
				fileSize = image.writeTo(saveFile);
				// JPEG 이미지이며 일정용량 이하인 경우 EXIF 메타정보만 삭제한 원본저장
				if(file.getSize() <= JPG_RESIZE_SKIP_SIZE && ("JPG".equals(image.getFileType()) || "JPEG".equals(image.getFileType()))) {
					try {
						// 이미지에 회전정보가 있을경우 원본저장 SKIP!!
						if(image.checkRotation(file.getInputStream()) == null) {
							ExifRewriter exifRemover = new ExifRewriter();
							File outputFile = new File(filepath);
							FileOutputStream fos = new FileOutputStream(outputFile);
							exifRemover.removeExifMetadata(file.getInputStream(), fos);
							path = outputFile.getAbsolutePath();
							fileSize = outputFile.length();
						}
					} catch(Exception e) {
						e.printStackTrace();
					}
				}
				
				//GIF파일은 원본으로 저장시키기 위해 PASS시킴
				/*if(!"GIF".equals(image.getFileType())) {
					image = image.resizeHV(limitWidth);
				} 
				
				image.checkRotation(file.getInputStream());
				File saveFile = new File(filepath);
				path = saveFile.getAbsolutePath();*/
				
			   /** GIF파일은 원본으로 저장시키기 위해 PASS시킴
				** (이미지첨부가 아닌 파일첨부로 경로에 저장하기 위함)
				**/
				/*if(!"GIF".equals(image.getFileType())) {
					fileSize = image.writeTo(saveFile);
				}*/ 
				
			}
		} catch (Exception e) {
			// log.error("not supported image type!");
		}
		fileMap.put("fileSize", fileSize);
		fileMap.put("path", path);
		return fileMap;
	}
	
	//public static void resize(File src, File dest, int width, int height) throws IOException {
    public static void resize(File src, int width, int height) throws IOException {
        Image srcImg = null;
        boolean isGif = false;
        String suffix = src.getName().substring(src.getName().lastIndexOf('.')+1).toLowerCase();
        if (suffix.equals("bmp") || suffix.equals("png") || suffix.equals("gif")) {
            srcImg = ImageIO.read(src);
            if(suffix.equals("gif")) isGif = true;
        } else {
            // BMP가 아닌 경우 ImageIcon을 활용해서 Image 생성
            // 이렇게 하는 이유는 getScaledInstance를 통해 구한 이미지를
            // PixelGrabber.grabPixels로 리사이즈 할때
            // 빠르게 처리하기 위함이다.
            srcImg = new ImageIcon(src.toURL()).getImage();
        }
        
        int srcWidth = srcImg.getWidth(null);
        int srcHeight = srcImg.getHeight(null);
        //logger.info("srcWidth : " + srcWidth);
        //logger.info("srcHeight : " + srcHeight);
        int destWidth = -1;
        int destHeight = -1;
        double ratio = 1;
        boolean overSize = false;
        
        // 가로 혹은 세로 비율을 비교하여 큰 비율에 맞춰 줄임
        if(srcWidth > width || srcHeight > height){
        	overSize = true;
        	if(((double)width)/((double)srcWidth) < ((double)height)/((double)srcHeight)){
        		ratio = ((double)width)/((double)srcWidth);
            	destWidth = (int)((double)srcWidth * ratio);
            	destHeight = (int)((double)srcHeight * ratio);
        	}else{
        		ratio = ((double)height)/((double)srcHeight);
            	destWidth = (int)((double)srcWidth * ratio);
            	destHeight = (int)((double)srcHeight * ratio);
        	}
        }
        //logger.info("destWidth : " + destWidth);
        //logger.info("destHeight : " + destHeight);
        
        // 기준 size보다 클 경우 resize 수행
        if(overSize || isGif){
        	//logger.info("overSize : " + overSize);
            Image imgTarget = srcImg.getScaledInstance(destWidth, destHeight, Image.SCALE_SMOOTH); 
            int pixels[] = new int[destWidth * destHeight]; 
            PixelGrabber pg = new PixelGrabber(imgTarget, 0, 0, destWidth, destHeight, pixels, 0, destWidth); 
            try {
                pg.grabPixels();
            } catch (InterruptedException e) {
                throw new IOException(e.getMessage());
            } 
            BufferedImage destImg = new BufferedImage(destWidth, destHeight, BufferedImage.TYPE_INT_RGB); 
            destImg.setRGB(0, 0, destWidth, destHeight, pixels, 0, destWidth); 
            
            //ImageIO.write(destImg, "jpg", dest);
            ImageIO.write(destImg, "jpg", src);
        }
    }
}
