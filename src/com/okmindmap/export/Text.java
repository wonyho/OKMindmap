package com.okmindmap.export;

public class Text {
	private String textContent = "";
	private String urlContent = "";
	private int lineNumber = 0;
	private int indentLevel = 0;
	private int placeHolder = 0;
	private boolean hasUrl = false;
	private int lengh = 0;
	
	public Text() {
		
	}
	
	public void setText(String text) {
		this.textContent = text;
		this.lengh = text.length();
	}
	
	public String getText() {
		return this.textContent;
	}
	
	public void setUrl(String url) {
		this.urlContent = url;
		this.hasUrl = true;
	}
	
	public String getUrl() {
		return this.urlContent;
	}
	
	public void setLineNumber(int lines) {
		this.lineNumber = lines;
	}
	
	public int getLineNumber() {
		return this.lineNumber;
	}
	
	public void setIdentLevel(int level) {
		this.indentLevel = level;
	}
	
	public int getIdentLevel() {
		return this.indentLevel;
	}
	
	public void setPlaceHolder(int placeHolder) {
		this.placeHolder = placeHolder;
	}
	
	public int getPlaceHolder() {
		return this.placeHolder;
	}
	
	public int getLengh() {
		return this.lengh;
	}
	
	public boolean hasUrl() {
		return this.hasUrl;
	}
}
