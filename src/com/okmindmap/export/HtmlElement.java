package com.okmindmap.export;

public class HtmlElement {
	private String content = "";
	private String tag = "";
	private boolean bold = false;
	private boolean italic = false;
	private double fontSize = 16. ;
	private boolean hasBullet= false;

	public HtmlElement() {

	}

	public HtmlElement(String content, String tag) {
		this.content = content;
		this.tag = tag;
		// call compute format function
		this.computeFormatTag();
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getContent() {
		return this.content;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public String getTag() {
		return this.tag;
	}
	
	public boolean getBold() {
		return this.bold;
	}
	
	public boolean getItalic() {
		return this.italic;
	}
	
	public boolean hasBullet() {
		return this.hasBullet;
	}
	
	public double getFontSize() {
		return this.fontSize;
	}

	public void computeFormatTag() {
		// get <h1> format
		if (this.tag.equals("h1")) {
			this.bold = true;
			this.italic = false;
			this.fontSize = 32.;
			this.hasBullet = false;
		}
		// get <h2> format
		else if (this.tag.equals("h2")) {
			this.bold = true;
			this.italic = false;
			this.fontSize = 24.;
			this.hasBullet = false;
		}
		// get <h3> format
		else if (this.tag.equals("h3")) {
			this.bold = true;
			this.italic = false;
			this.fontSize = 18.72;
			this.hasBullet = false;
		}
		// get <h4> format
		else if (this.tag.equals("h4")) {
			this.bold = true;
			this.italic = false;
			this.fontSize = 16.;
			this.hasBullet = false;
		}
		// get <h5> format
		else if (this.tag.equals("h5")) {
			this.bold = true;
			this.italic = false;
			this.fontSize = 13.28;
			this.hasBullet = false;
		}
		// get <h6> format
		else if (this.tag.equals("h6")) {
			this.bold = true;
			this.italic = false;
			this.fontSize = 12.;
			this.hasBullet = false;
		}
		// get <pre> format
		else if (this.tag.equals("pre")) {
			this.bold = false;
			this.italic = false;
			this.fontSize = 16.;
			this.hasBullet = false;
		}
		// get <p> format
		else if (this.tag.equals("p")) {
			this.bold = false;
			this.italic = false;
			this.fontSize = 16.;
			this.hasBullet = false;
		}
		// get <li> format
		else if (this.tag.equals("li")) {
			this.bold = false;
			this.italic = false;
			this.fontSize = 16.;
			this.hasBullet = true;
		}
	}
}
