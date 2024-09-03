package com.okmindmap.export;

import java.util.ArrayList;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.okmindmap.export.HtmlElement;

public class Webpage {
	private String Html = "";
	private int rowContent = 0;
	private ArrayList<HtmlElement> contents;
	private int maxCharacterPerRow = 70; // default is 70 for max width
	
	public Webpage(int maxCharPerRow) {
		contents = new ArrayList<HtmlElement>();
		this.maxCharacterPerRow = maxCharPerRow;
	}
	
	public Webpage(String html, int maxCharPerRow) {
		this.Html = html;
		contents = new ArrayList<HtmlElement>();
		this.maxCharacterPerRow = maxCharPerRow;
		this.extractTabContent(this.Html, "div");
		
	}
	
	public void setHtml(String html) {
		this.Html = html;
	}
	
	public String getHtml() {
		return this.Html;
	}
	
	public ArrayList<HtmlElement> getContents(){
		return this.contents;
	}
	
	public int getRowOfContent() {
		return this.rowContent;
	}
	
	public void extractTabContent(String html, String tab) {
		Document doc = Jsoup.parse(html);
		Elements elements = doc.select(tab+" > *");
		for(Element content: elements) {
			if(content.tagName().equals("ul")) {
				this.extractTabContent(html, "ul");
			}else if(content.tagName().equals("ol")) {
				this.extractTabContent(html, "ol");
			} else if(content.tagName().equals("table")) {
				// Format for table tab
			}else {
				HtmlElement newE = new HtmlElement(content.text(), content.tagName());
				this.contents.add(newE);
				// compute how many line
				int x = content.text().length() / this.maxCharacterPerRow;
				int y = content.text().length() % this.maxCharacterPerRow;
				if (y > 0) {
					this.rowContent = this.rowContent + x + 1;
				} else {
					this.rowContent = this.rowContent + x;
				}
			}
		}
	}
	
	public void clearContent() {
		this.contents.clear();
		this.rowContent = 0;
	}
}
