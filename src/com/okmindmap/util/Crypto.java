package com.okmindmap.util;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class Crypto {
	private static final String initVector = "920CCE07BAB27D76";

	public static String encrypt(String strClearText,String strKey) throws Exception{
		try {
	        IvParameterSpec iv = new IvParameterSpec(initVector.getBytes("UTF-8"));
	        SecretKeySpec skeySpec = new SecretKeySpec(strKey.getBytes("UTF-8"), "AES");
	 
	        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
	        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv);
	 
	        byte[] encrypted = cipher.doFinal(strClearText.getBytes());
	        return Base64.encodeBase64String(encrypted);
	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }
	    return null;

	}
	
	public static String decrypt(String strEncrypted,String strKey) throws Exception{
		try {
	        IvParameterSpec iv = new IvParameterSpec(initVector.getBytes("UTF-8"));
	        SecretKeySpec skeySpec = new SecretKeySpec(strKey.getBytes("UTF-8"), "AES");
	 
	        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
	        cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
	        byte[] original = cipher.doFinal(Base64.decodeBase64(strEncrypted));
	 
	        return new String(original);
	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }
	 
	    return null;

	}
}
