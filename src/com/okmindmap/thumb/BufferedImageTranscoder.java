package com.okmindmap.thumb;

import java.awt.Color;
import java.awt.image.BufferedImage;

import org.apache.batik.transcoder.TranscoderException;
import org.apache.batik.transcoder.TranscoderOutput;
import org.apache.batik.transcoder.image.ImageTranscoder;

public class BufferedImageTranscoder extends ImageTranscoder {
	private BufferedImage image = null;
	
	public BufferedImageTranscoder() {
        hints.put(ImageTranscoder.KEY_BACKGROUND_COLOR, Color.white);
    }
	
	@Override
	public BufferedImage createImage(int w, int h) {
		return new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
	}

	@Override
	public void writeImage(BufferedImage image, TranscoderOutput output) throws TranscoderException {
		this.image = image;
	}
	
	public BufferedImage getImage() {
		return this.image;
	}

}
