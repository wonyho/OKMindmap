package com.okmindmap.thumb;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.imageio.ImageIO;
import javax.xml.bind.DatatypeConverter;

import org.apache.batik.dom.svg.SAXSVGDocumentFactory;
import org.apache.batik.transcoder.TranscoderException;
import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.image.ImageTranscoder;
import org.apache.batik.util.XMLResourceDescriptor;
import org.w3c.dom.Document;

/**
 * 맵 SVG를 PNG로 변경하
 * 중심 노드를 가운데로 오게 해서
 * 일정 크기로 자른다.
 * 
 * @author jinhoon
 *
 */
public class ThumbnailTranscoder {
	public static void transcode(String svg, int width, int height, int dx, int dy, OutputStream out) {
		try {
	        BufferedImage image = loadSVG(svg);
	        
	        image = crop(image, width, height, dx, dy);
	        
	        ImageIO.write(image, "png", out);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void transcodeBase64(String base64, int width, int height, int dx, int dy, OutputStream out) {
		try {
	        BufferedImage image = decodeBase64(base64);
	        if(image != null ) {
	        	image = crop(image, width, height, dx, dy);
		        
		        ImageIO.write(image, "png", out);
	        }
	        
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private static BufferedImage loadSVG(String svg) throws TranscoderException, IOException {
		ByteArrayInputStream is = new ByteArrayInputStream(svg.getBytes());
		String parser = XMLResourceDescriptor.getXMLParserClassName();
	    SAXSVGDocumentFactory f = new SAXSVGDocumentFactory(parser);
	    Document doc = f.createDocument("", is);
	    
	    TranscoderInput input = new TranscoderInput(doc);
	    
        BufferedImageTranscoder trans = new BufferedImageTranscoder();
        trans.transcode(input, null);
        trans.addTranscodingHint(ImageTranscoder.KEY_BACKGROUND_COLOR, Color.WHITE);
        
        BufferedImage image = trans.getImage();
        
        return image;
	}
	
	private static BufferedImage crop(BufferedImage image, int width, int height, int dx, int dy) {
		int x = (width - image.getWidth()) / 2 + dx;
		int y = (height - image.getHeight()) / 2 + dy;
		
		BufferedImage thumbImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
		Graphics2D graphics = thumbImage.createGraphics();
		
		graphics.setColor(Color.WHITE);
		graphics.fillRect(0, 0, width, height);
		graphics.drawImage(image, x, y, image.getWidth(), image.getHeight(), null);
		
		return thumbImage;
	}
	
	private static BufferedImage decodeBase64(String base64){
		if(base64.split(",").length < 2) return null;
		String data = base64.split(",")[1];
		
		byte[] imageBytes = DatatypeConverter.parseBase64Binary(data);
		
		try {
			BufferedImage bufImg = ImageIO.read(new ByteArrayInputStream(imageBytes));
			return bufImg;
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;
		
	}
}
