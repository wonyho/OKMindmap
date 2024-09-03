package com.okmindmap.export;

import java.awt.Rectangle;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringEscapeUtils;
//import org.apache.log4j.Logger; // wait for the upgrade to log4j 2.15.0

import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.openxml4j.opc.PackagePartName;
import org.apache.poi.openxml4j.opc.PackageRelationship;
import org.apache.poi.openxml4j.opc.TargetMode;
import org.apache.poi.sl.usermodel.AutoNumberingScheme;
import org.apache.poi.sl.usermodel.PictureData;
import org.apache.poi.sl.usermodel.PictureData.PictureType;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xslf.usermodel.SlideLayout;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFHyperlink;
import org.apache.poi.xslf.usermodel.XSLFPictureData;
import org.apache.poi.xslf.usermodel.XSLFPictureShape;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.apache.poi.xslf.usermodel.XSLFSlideLayout;
import org.apache.poi.xslf.usermodel.XSLFSlideMaster;
import org.apache.poi.xslf.usermodel.XSLFTextParagraph;
import org.apache.poi.xslf.usermodel.XSLFTextRun;
import org.apache.poi.xslf.usermodel.XSLFTextShape;

import org.htmlparser.Parser;
import org.htmlparser.util.ParserException;
import org.htmlparser.visitors.TextExtractingVisitor;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.openxmlformats.schemas.drawingml.x2006.main.CTHyperlink;
import org.openxmlformats.schemas.presentationml.x2006.main.CTApplicationNonVisualDrawingProps;
import org.openxmlformats.schemas.presentationml.x2006.main.CTPicture;
import org.openxmlformats.schemas.presentationml.x2006.main.CTSlide;
import org.openxmlformats.schemas.presentationml.x2006.main.CTTLCommonMediaNodeData;
import org.openxmlformats.schemas.presentationml.x2006.main.CTTLCommonTimeNodeData;
import org.openxmlformats.schemas.presentationml.x2006.main.CTTimeNodeList;
import org.openxmlformats.schemas.presentationml.x2006.main.STTLTimeIndefinite;
import org.openxmlformats.schemas.presentationml.x2006.main.STTLTimeNodeFillType;
import org.openxmlformats.schemas.presentationml.x2006.main.STTLTimeNodeRestartType;
import org.openxmlformats.schemas.presentationml.x2006.main.STTLTimeNodeType;

import com.okmindmap.model.ForeignObject;
import com.okmindmap.model.Map;
import com.okmindmap.model.Node;
import com.okmindmap.model.RichContent;
import com.okmindmap.model.Slide;
import com.okmindmap.service.MindmapService;

public class ExportPpt_bak implements Export {
	// bullet의 최대 indent level 은 3(0~2).
	private int MAX_INDENT_LEVEL = 3;

	// Limit text row on Slide
	private int MAX_ROW = 16;
	// margin top for text content
	private int TOP = 80;
	// margin left for image content
	private int IMG_LEFT = 10;
	// margin left for text content
	private int TEXT_LEFT = 40;
	// length of depth level
	private int DEPTH_LENGTH = 38;
	// font size for level 0 text;
	private double FONT_SIZE = 20;
	// height unit of text content
	private int HEIGHT_UNIT = 23;
	// width unit of text content
	private int WIDTH_UNIT = 11;
	// Max width can display
	private int MAX_WIDTH = 700;
	// Max height can display
	private int MAX_HEIGHT = 400;

	private static final Hashtable<String, PictureData.PictureType> SUPPORTED_IMAGE_FORMAT = new Hashtable<String, PictureData.PictureType>();
	// JPEG, PNG 만 지원
	static {
		SUPPORTED_IMAGE_FORMAT.put("JPEG", PictureData.PictureType.JPEG);
		SUPPORTED_IMAGE_FORMAT.put("PNG", PictureData.PictureType.PNG);
		SUPPORTED_IMAGE_FORMAT.put("PNG", PictureData.PictureType.BMP);
	}
	// Define for service
	private MindmapService mindmapService;
//	Logger logger; // wait for the upgrade to log4j 2.15.0

	// Store path of location on local host
	private String realPath = "";

	// Define for slide creator
	private XMLSlideShow slideShow = null;
	private XSLFSlideMaster slideMaster = null;
	private XSLFSlideLayout slideLayout = null;
	private XSLFSlide slide = null;
	private XSLFTextShape textShape = null;
	private XSLFTextParagraph textParagraph = null;
	private XSLFTextRun textRun = null;
	private XSLFPictureData pictureData = null;
	private XSLFPictureShape pictureShape = null;
	private String themeSource;

	// Control text content
	private String title = "";
	private String url = ""; // link of slide title save to import next slide
	private int currentRow = 0; // current row position at current slide
	private int maxCharacterPerRow = 80; // default is 70 for max width
	private int maxCharacter = 0; // save max character to know width of row
	private int maxDepth = 0; // save max depth of paragraph
	private int rowOfText = 0; // save row of current text is processed
	private boolean hasElement = false; // has one or more element havn't been put into slide
	private boolean onPutEvent = false; // turn on put element into slide event
	private boolean hasEmtrySlide = false;
	private List<Double> fontSize;
	private List<Node> pt_nodes;
	private boolean isDivide;
	private boolean hasGpage;


	// Store elements of Map
	private ArrayList<Text> textContents;
	private ArrayList<Picture> pictureContents;
	private Webpage webPageContent;
	private Iframe iframeContent;
	private Video videoContent;
	

	// temp value
	private int videoID = 0;

	public ExportPpt_bak() {
//		logger = Logger.getLogger(ExportPpt_old.class); // wait for the upgrade to log4j 2.15.0
	}

	public ExportPpt_bak(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
//		logger = Logger.getLogger(ExportPpt_old.class); // wait for the upgrade to log4j 2.15.0
		this.fontSize = new ArrayList<Double>();
	}
	
	public boolean isDivide() {
		return isDivide;
	}

	public void setDivide(boolean isDivide) {
		this.isDivide = isDivide;
	}
	
	public boolean isHasGpage() {
		return hasGpage;
	}

	public void setHasGpage(boolean hasGpage) {
		this.hasGpage = hasGpage;
	}

	public void addFontSizeLevel(Double val) {
		this.fontSize.add(val);
	}

	public int getMAX_ROW() {
		return MAX_ROW;
	}

	public void setMAX_ROW(int mAX_ROW) {
		MAX_ROW = mAX_ROW;
	}

	public double getFONT_SIZE() {
		return FONT_SIZE;
	}

	public void setFONT_SIZE(double fONT_SIZE) {
		FONT_SIZE = fONT_SIZE;
	}

	public String getThemeSource() {
		return themeSource;
	}

	public void setThemeSource(String themeSource) {
		this.themeSource = themeSource;
		this.themeSource = this.themeSource + ".pptx";
	}

	public void transform(Map map, Properties prop, OutputStream out) throws IOException {
		// get real path and load all theme
		this.realPath = prop.getProperty("realPath");
		this.initSlideTheme();

		// create new slide show with theme option
		// User will choice one theme from theme list.
		this.createSlideShow(this.realPath + "plugin/slideshow/theme/" + this.themeSource);
		String oder = map.getPt_sequence();
		this.pt_nodes = new ArrayList<Node>();
		if(oder != null) {
			String[] oders = oder.split(" ");
			for(String id : oders){
				Node n = this.mindmapService.getNode(id, map.getId(), true);
				if(n != null) this.pt_nodes.add(n);
			}
		}

		// get root node and add first slide
		Node root = map.getNodes().get(0);
		if(this.pt_nodes.size() < 1) {
			this.pt_nodes = root.getChildren();
		}
		this.addFirstSlide(root);
		// Get all child of root and run processing
//		List<Node> Nodes = root.getChildren();
		for (int i = 0; i < this.pt_nodes.size(); i++) {
			Node child = this.pt_nodes.get(i);
			
			String title = extractText(child);
			if (title == null) {
				title = "";
			} else {
				title = title.replace("\n", "");
			}
			this.title = title;
			this.url = this.extractLink(child);
			if (this.hasEmtrySlide) {
				this.addTextTitle(this.title, this.FONT_SIZE, true);
			} else {
				this.addNewSlide(SlideLayout.TITLE_AND_CONTENT);
			}
			
			Slide slide = this.mindmapService.getSlide(child.getId());
			this.MAX_INDENT_LEVEL = (slide != null ? slide.getShowDepths() : 3) - 1;
			
//			this.hasElement = false;
//			
//			for (Node node : child.getChildren()) {
//				transformProcess(node, 0, title);
//			}
//			
//			this.textShape = this.slide.getPlaceholder(1);
//			this.textShape.clearText();
//			
//			if (this.hasElement) {
//				this.putElementIntoSlide();
//			} else {
//				this.textRun = this.textShape.addNewTextParagraph().addNewTextRun();
//				this.textRun.setText("");
//			}
			for (Node node : child.getChildren()) {
				transformProcess(node, 0, title);
			}
			if (this.hasElement) {
				this.slidePutEvent(title);
			}
		}
		// Remove last entry slide
		int index = this.slideShow.getSlides().size();
		if (this.hasEmtrySlide && index > 0) {
			this.slideShow.removeSlide(index - 1);
		}
		// save to stream
		saveSlideShow(out);
	}

	private void transformProcess(Node node, int depth, String title) {
		// If full slide, turn on put event to create new slide and run again
		if (this.currentRow > MAX_ROW) {
			this.slidePutEvent(title);
			this.transformProcess(node, depth, title);
			return;
		}

		// text processing
		String text = this.extractText(node);
		String url = this.extractLink(node);
		if (text != "" && text.length() > 0) {
			text = this.textProcessing(text);
			Text newText = new Text();
			newText.setText(text);
			newText.setLineNumber(this.rowOfText);
			newText.setIdentLevel(depth);
			newText.setPlaceHolder(1);
			if (url != null) {
				if (url != "" && url.length() > 0) {
					newText.setUrl(url);
				}
			}
			this.textContents.add(newText);
			this.currentRow = this.currentRow + this.rowOfText;
			if (depth > this.maxDepth)
				this.maxDepth = depth;
			this.hasElement = true;
		}

		// image processing
		String[] images = this.extractImage(node);
		if (images != null && images.length > 0) {
			for (String image : images) {
				Picture pic = new Picture(this.realPath);
				pic.setUrl(image);
				pic.setText(text);
				pic.loadPictureData();
				this.pictureContents.add(pic);
			}
			if (text != "" && text.length() > 0) {
				this.textContents.remove(this.textContents.size() - 1);
			}
			if(this.isDivide) {
				this.onPutEvent = true;
			}
			this.hasElement = true;
			
		}

		// video processing
		String video = this.extractVideo(node);
		if (video != null) {
			this.videoContent.setVideoCode((String.valueOf(this.videoID)));
			this.videoID++;
			//this.videoContent.setUrl("file:/home/cseadmin/Downloads/video.mp4", true);
			this.videoContent.setUrl(video, false);
			if(this.isDivide) {
				this.onPutEvent = true;
			}
			this.hasElement = true;
		}

		// webpage processing
		String webpage = this.extractWebpage(node);
		if (webpage != null) {
			this.webPageContent = new Webpage(webpage, this.maxCharacterPerRow);
			if(this.isDivide) {
				this.onPutEvent = true;
			}
			this.hasElement = true;
		}

		// iframe processing
		String iframe = this.extractiFrame(node);
		if (iframe != null) {
			this.iframeContent = new Iframe(iframe, this.realPath);
			if(this.isDivide) {
				this.onPutEvent = true;
			}
			this.hasElement = true;
		}

		// Elements processing and put to slide
		if (this.onPutEvent) {
			this.slidePutEvent(title);
		}

		if (depth < MAX_INDENT_LEVEL) {
			for (Node child : node.getChildren()) {
				this.transformProcess(child, depth + 1, title);
			}
		}
	}

	private void initSlideTheme() {
		// Create store objects
		this.textContents = new ArrayList<Text>();
		this.pictureContents = new ArrayList<Picture>();
		this.webPageContent = new Webpage(this.maxCharacterPerRow);
		this.iframeContent = new Iframe(this.realPath);
	}

	private void createSlideShow(String theme) {
		try {
			// try to load theme from local
			this.slideShow = new XMLSlideShow(new FileInputStream(theme));
			// every theme have ready had two theme, must delete them
			this.slideShow.removeSlide(0);
			this.slideShow.removeSlide(0);
			this.videoContent = new Video(this.slideShow);
		} catch (Exception e) {
			// create default, with out theme.
			this.slideShow = new XMLSlideShow();
			this.videoContent = new Video(this.slideShow);
		}
		// Get slide master, that is important
		this.slideMaster = this.slideShow.getSlideMasters().get(0);
	}

	private void saveSlideShow(OutputStream out) {
		try {
			this.slideShow.write(out);
			this.slideShow.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void addFirstSlide(Node node) {
		// set layout for slide
		this.slideLayout = this.slideMaster.getLayout(SlideLayout.TITLE);

		// new first slide to slide show
		this.slide = this.slideShow.createSlide(this.slideLayout);
		// get first place holder and remove all text
		this.textShape = this.slide.getPlaceholder(0);
		this.textShape.clearText();
		// set font size and font style
		this.textRun = this.textShape.addNewTextParagraph().addNewTextRun();
		// get text from Root node and set to slide
		this.title = this.extractText(node).replace("\n", "");
		this.textRun.setText(this.title);
		// get second place holder and remove all text
		this.textShape = this.slide.getPlaceholder(1);
		this.textShape.setText(" ");
	}
	
	private void addSecondSlide(Node root){
		// Set layout for new slide
		this.slideLayout = this.slideMaster.getLayout(SlideLayout.TITLE_AND_CONTENT);
		// create new slide with layout above
		this.slide = this.slideShow.createSlide(this.slideLayout);
		this.slide.getPlaceholder(0).clearText();
		this.slide.getPlaceholder(1).clearText();
		this.addTextTitle(this.title, this.FONT_SIZE, true);
		
		int iidx = 0;
		if (this.pt_nodes.get(0).getIdentity().equals(root.getIdentity())) iidx = 1;
		for (int i = iidx; i < this.pt_nodes.size(); i++) {
			Node node = this.pt_nodes.get(i);
			String text = this.extractText(node);
			if (text != "" && text.length() > 0) {
				text = this.textProcessing(text);
				Text newText = new Text();
				newText.setText(text);
				newText.setLineNumber(this.rowOfText);
				newText.setIdentLevel(0);
				newText.setPlaceHolder(1);
				
				this.textContents.add(newText);
				this.currentRow = this.currentRow + this.rowOfText;
			}
		}
		this.putTextIntoSlide();
	}

	private void addNewSlide(SlideLayout layout) {
		// Set layout for new slide
		this.slideLayout = this.slideMaster.getLayout(layout);
		// create new slide with layout above
		this.slide = this.slideShow.createSlide(this.slideLayout);
		this.slide.getPlaceholder(0).clearText();
		if (layout.equals(SlideLayout.TITLE_AND_CONTENT)) {
			this.slide.getPlaceholder(1).clearText();
		}
		if (this.url != null) {
			if (this.url != "" && this.url.length() > 0) {
				this.addHyperlink(this.title, this.url);
			}
		} else {
			this.addTextTitle(this.title, this.FONT_SIZE, true);
		}
		
		this.currentRow = 0;
		this.maxCharacter = 0;
		this.onPutEvent = false;
		this.maxDepth = 0;
	}

	private void addTextTitle(String title) {
		this.textShape = this.slide.getPlaceholder(0);
		this.textShape.clearText();
		this.textShape.addNewTextParagraph().addNewTextRun().setText(title);
	}

	private void addTextTitle(String title, double fontSize, boolean bold) {
		this.textShape = this.slide.getPlaceholder(0);
		this.textShape.clearText();
//		this.textShape.setAnchor(new Rectangle(10, 0, 600, 60));
		this.textRun = this.textShape.addNewTextParagraph().addNewTextRun();
//		this.textRun.setBold(bold);
		this.textRun.setFontSize(fontSize);
		this.textRun.setText(title);
	}

	private void addTextParagraph(String paragraph) {
		try {
			this.textShape = this.slide.getPlaceholder(1);
			this.textShape.setAnchor(new Rectangle(30, 80, 660, 400));
			this.textParagraph = this.textShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(0);
			this.textParagraph.addNewTextRun().setText(paragraph);
			this.textParagraph.setBullet(false);

		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addTextBullet(String text, int indentLevel) {
		try {
			this.textShape = this.slide.getPlaceholder(1);
			this.textShape.setAnchor(new Rectangle(30, 80, 660, 400));
			this.textParagraph = this.textShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(indentLevel);
			this.textRun = this.textParagraph.addNewTextRun();
			this.textRun.setText(text);
			this.textParagraph.setBullet(true);

		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addTextBullet(XSLFTextShape txtShape, Text text, double fontSize) {
		try {
			txtShape.setAnchor(new Rectangle(30, 80, 660, 400));
			this.textParagraph = txtShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(text.getIdentLevel());
//			this.textRun = this.textParagraph.addNewTextRun();
//			this.textRun.setFontSize(-(double)text.getIdentLevel() - 2);
//			this.textRun.setText(text);

			// start configure string to fit text shape
			int start = 0;
			int end = 0;
			if (text.getLengh() > 2) {
				int count = 2;
				for (end = 2; end < text.getLengh(); end++) {
					if (count > (this.maxCharacterPerRow - text.getIdentLevel() * 6)) {
						if (text.getText().charAt(end) != ' ') {
							while (text.getText().charAt(end) != ' ' && end > 1 && end > start) {
								end--;
							}
						}
						this.textRun = this.textParagraph.addNewTextRun();
						this.textRun.setFontSize(this.fontSize.get(text.getIdentLevel()));
						this.textRun.setText(text.getText().substring(start, end));
						this.textParagraph.addLineBreak();
						end++;
						start = end;
						count = 0;
					}
					count++;
				}
			}

			if (start < text.getLengh() - 1) {
				this.textRun = this.textParagraph.addNewTextRun();
				this.textRun.setFontSize(this.fontSize.get(text.getIdentLevel()));
				this.textRun.setText(text.getText().substring(start, text.getLengh()));
			}
			// end configure string to fit text shape
			this.textParagraph.setBullet(true);

		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addHtmlText(HtmlElement he) {
		int il = 0;
		if (he.hasBullet())
			il = 1;
		try {
			this.textShape = this.slide.getPlaceholder(1);
			this.textShape.setAnchor(new Rectangle(30, 80, 660, 400));
			this.textParagraph = this.textShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(il);

			// start configure string to fit text shape
			int start = 0;
			int end = 0;
			if (he.getContent().length() > 2) {
				int count = 2;
				for (end = 2; end < he.getContent().length(); end++) {
					if (count > (this.maxCharacterPerRow - il * 6)) {
						if (he.getContent().charAt(end) != ' ') {
							while (he.getContent().charAt(end) != ' ' && end > 1 && end > start) {
								end--;
							}
						}
						this.textRun = this.textParagraph.addNewTextRun();
						this.textRun.setBold(he.getBold());
						this.textRun.setItalic(he.getItalic());
						this.textRun.setFontSize(he.getFontSize());
						this.textRun.setText(he.getContent().substring(start, end));
						this.textParagraph.setBullet(he.hasBullet());
						this.textParagraph.addLineBreak();
						end++;
						start = end;
						count = 0;
					}
					count++;
				}
			}

			if (start < he.getContent().length() - 1) {
				this.textRun = this.textParagraph.addNewTextRun();
				this.textRun.setBold(he.getBold());
				this.textRun.setItalic(he.getItalic());
				this.textRun.setFontSize(he.getFontSize());
				this.textRun.setText(he.getContent().substring(start, he.getContent().length()));
				this.textParagraph.setBullet(he.hasBullet());
			}
		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addHyperlink(String text, String url) {
		try {
			this.textShape = this.slide.getPlaceholder(0);
			this.textParagraph = this.textShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(0);
			this.textRun = this.textParagraph.addNewTextRun();
			this.textRun.setText(text);
			this.textParagraph.setBullet(false);
			this.textRun.createHyperlink().setAddress(url);
		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addHyperlink(String text, String url, int placeHolder) {
		try {
			this.textShape = this.slide.getPlaceholder(placeHolder);
			this.textParagraph = this.textShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(0);
			this.textRun = this.textParagraph.addNewTextRun();
			this.textRun.setText(text);
			this.textParagraph.setBullet(false);
			this.textRun.createHyperlink().setAddress(url);
		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addHyperlink(String text, String url, int placeHolder, int indentLevel) {
		try {
			this.textShape = this.slide.getPlaceholder(placeHolder);
			this.textParagraph = this.textShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(indentLevel);
			this.textRun = this.textParagraph.addNewTextRun();
			this.textRun.setFontSize(16. - (float)indentLevel);
			this.textRun.setText(text);
			this.textParagraph.setBullet(true);
			this.textRun.createHyperlink().setAddress(url);
		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addHyperlink(XSLFTextShape txtShape, String text, String url, int indentLevel, double fontSize) {
		try {
			txtShape.setAnchor(new Rectangle(30, 80, 660, 400));
			this.textParagraph = txtShape.addNewTextParagraph();
			this.textParagraph.setIndentLevel(indentLevel);
			this.textRun = this.textParagraph.addNewTextRun();
			this.textRun.setFontSize(fontSize);
			this.textRun.setText(text);
			this.textParagraph.setBullet(true);
			this.textRun.createHyperlink().setAddress(url);
		} catch (Exception e) {
			// Out of range for Place holder;
			e.printStackTrace();
		}
	}

	private void addPicture(Picture picture, int idx) {
		if(!this.isDivide) {
			picture.setWidth(100);
			picture.setHeightAutoScale(1);
			picture.setTop(110*idx + 80);
			picture.setLeft(560);
		}
		
		if(picture.pictureIsLoaded()) {
			this.pictureData = this.slideShow.addPicture(picture.getPictureData(),
					SUPPORTED_IMAGE_FORMAT.get(picture.getPictureFormat()));
			this.pictureShape = this.slide.createPicture(this.pictureData);
			this.pictureShape.setAnchor(picture.getRectangle());
		}else {
			if(picture.getUrl().length() > 100) {
				this.addTextBullet("Error while loading Picture: " + picture.getUrl().substring(0, 100) + "...", 0);
			}else {
				this.addTextBullet("Error while loading Picture: " + picture.getUrl(), 0);
			}
			this.addTextBullet("Please change to available Picture", 1);
			this.addTextBullet("Try export again", 1);
			
		}
	}

	private void addVideo(Video video) {
		try {
			this.addHyperlink(video.getUrl(), video.getUrl(), 1, 0);
			byte[] pd = video.getThumbnailImage();
			if(pd == null) {
				pd = IOUtils.toByteArray(new FileInputStream(this.realPath + "plugin/slideshow/video.png"));
			}
			this.pictureData = this.slideShow.addPicture(pd, PictureType.JPEG);
			this.pictureShape = this.slide.createPicture(this.pictureData);
			this.pictureShape.setAnchor(
					new Rectangle(200, 250, this.slideShow.getPageSize().width - 400, this.slideShow.getPageSize().height-300));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void addVideo(PackagePart video, int top, int left, int width, int height) {
		try {
			byte[] pd = IOUtils.toByteArray(new FileInputStream(this.realPath + "plugin/slideshow/video.png"));
			this.pictureData = this.slideShow.addPicture(pd, PictureType.JPEG);
			this.pictureShape = this.slide.createPicture(this.pictureData);
			this.pictureShape.setAnchor(new Rectangle(left, top, width, height));

			// csedung break code add video because can not get Youtube stream link.
			// We can attach Youtube video by watch link, must be stream link
			// add video data
			PackagePartName partName = video.getPartName();
			PackageRelationship prsExec1 = this.slide.getPackagePart().addRelationship(partName, TargetMode.INTERNAL,
					"http://schemas.openxmlformats.org/officeDocument/2006/relationships/video");
			CTPicture pic = (CTPicture) this.pictureShape.getXmlObject();
			CTHyperlink link = pic.getNvPicPr().getCNvPr().addNewHlinkClick();
			link.setId("");
			link.setAction("ppaction://media");
			CTApplicationNonVisualDrawingProps nvPr = pic.getNvPicPr().getNvPr();
			nvPr.addNewVideoFile().setLink(prsExec1.getId());
			// set video frame controller
			CTSlide ctSlide = this.slide.getXmlObject();
			CTTimeNodeList ctnl;
			if (!ctSlide.isSetTiming()) {
				CTTLCommonTimeNodeData ctn = ctSlide.addNewTiming().addNewTnLst().addNewPar().addNewCTn();
				ctn.setDur(STTLTimeIndefinite.INDEFINITE);
				ctn.setRestart(STTLTimeNodeRestartType.NEVER);
				ctn.setNodeType(STTLTimeNodeType.TM_ROOT);
				ctnl = ctn.addNewChildTnLst();
			} else {
				ctnl = ctSlide.getTiming().getTnLst().getParArray(0).getCTn().getChildTnLst();
			}
			CTTLCommonMediaNodeData cmedia = ctnl.addNewVideo().addNewCMediaNode();
			cmedia.setVol(100);
			CTTLCommonTimeNodeData ctn = cmedia.addNewCTn();
			ctn.setFill(STTLTimeNodeFillType.HOLD);
			ctn.setDisplay(false);
			ctn.addNewStCondLst().addNewCond().setDelay(STTLTimeIndefinite.INDEFINITE);
			cmedia.addNewTgtEl().addNewSpTgt().setSpid("" + this.pictureShape.getShapeId());
			// csedung and break code. Do not remove code were contented
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void slidePutEvent(String title) {
		if(this.isDivide) this.computeDisplayMode(title);
		this.putElementIntoSlide();
		this.addNewSlide(SlideLayout.TITLE_AND_CONTENT);
		
		this.hasEmtrySlide = true;

	}

	private void putElementIntoSlide() {
		this.putTextIntoSlide();
		this.putPictureIntoSilde();
		this.putWebpageIntoSlide();
		this.putIframeIntoSlide();
		if (this.videoContent.hasVideo()) {
			if (this.currentRow != 0) {
				this.addNewSlide(SlideLayout.TITLE_AND_CONTENT);
				this.putVideoIntoSlide();
			}
			this.putVideoIntoSlide();
		}
		this.hasElement = false;
		this.hasEmtrySlide= false;
	}

	private void putTextIntoSlide() {
		this.textShape = this.slide.getPlaceholder(1);
		for (Text t : this.textContents) {
			if (t.hasUrl()) {
				this.addHyperlink(this.textShape, t.getText(), t.getUrl(), t.getIdentLevel(), this.fontSize.get(t.getIdentLevel()));
			} else {
				this.addTextBullet(this.textShape, t, this.FONT_SIZE - t.getIdentLevel());
			}
		}
		// Free template memory
		this.textContents.clear();
	}

	private void putPictureIntoSilde() {
		int i=0;
		for (Picture p : this.pictureContents) {
			this.addPicture(p, i);
			i++;
		}
		// Free template memory
		this.pictureContents.clear();
	}

	private void putWebpageIntoSlide() {
		ArrayList<HtmlElement> hes = new ArrayList<HtmlElement>();
		hes = this.webPageContent.getContents();
		for (HtmlElement he : hes) {
			this.addHtmlText(he);
		}
		this.webPageContent.clearContent();
	}

	private void putIframeIntoSlide() {
		if (this.iframeContent.hasIframe()) {
			this.pictureData = this.slideShow.addPicture(this.iframeContent.getCapturedImage(),
					PictureData.PictureType.PNG);
			this.pictureShape = this.slide.createPicture(this.pictureData);
			this.pictureShape.setAnchor(new Rectangle(0, 120, this.slideShow.getPageSize().width,
					(this.slideShow.getPageSize().height) - 120));
			this.iframeContent = new Iframe(this.realPath);
		}
	}

	private void putVideoIntoSlide() {
		if (this.videoContent.hasVideo()) {
//			this.addVideo(this.videoContent.getContent(), 0, 0, this.slideShow.getPageSize().width,
//					this.slideShow.getPageSize().height);
			this.addVideo(this.videoContent);
		}
		this.videoContent = new Video(this.slideShow);
	}

	private void computeDisplayMode(String title) {
		if (this.pictureContents.size() > 0) {
			boolean computed = false;
			// Compute display with Picture
			// try to put one, two or three Pictures on Slide.
			if (this.currentRow > MAX_ROW / 2) {
				if (this.maxCharacter < this.maxCharacterPerRow / 2) {
					// Option 1:
					// Row more than MAX_ROW / 2
					// No line longer MAX_CHAR_PER_ROW / 2
					switch (this.pictureContents.size()) {
					case 1: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP);
						pic.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
						pic.setWidth(
								MAX_WIDTH - this.maxCharacter * WIDTH_UNIT - TEXT_LEFT - DEPTH_LENGTH * this.maxDepth);
						pic.setHeightAutoScale(1);
						computed = true;
						break;
					}
					case 2: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP);
						pic.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
						pic.setHeight(MAX_HEIGHT / 2);
						pic.setWidthAutoScale(2);

						Picture pic2 = this.pictureContents.get(1);
						pic2.setTop(TOP + MAX_HEIGHT / 2 + 10);
						pic2.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
						pic2.setHeight(MAX_HEIGHT / 2);
						pic2.setWidthAutoScale(2);
						computed = true;
						break;
					}
					default: {
						if (this.currentRow < 0.7 * MAX_ROW) {
							Picture pic = this.pictureContents.get(0);
							pic.setTop(TOP);
							pic.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
							pic.setHeight(MAX_HEIGHT / 2);
							pic.setWidthAutoScale(2);

							Picture pic2 = this.pictureContents.get(1);
							pic2.setTop(TOP + MAX_HEIGHT / 2 + 10);
							pic2.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
							pic2.setHeight(MAX_HEIGHT / 2);
							pic2.setWidthAutoScale(2);

							Picture pic3 = this.pictureContents.get(2);
							pic3.setTop(TOP + this.currentRow * HEIGHT_UNIT);
							pic3.setLeft(IMG_LEFT);
							pic3.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
							pic3.setWidthAutoScale(2);
							computed = true;
						}
						break;
					}
					}
				} else {
					// Option 2:
					// Row more than MAX_ROW / 2
					// Exist line longer MAX_CHAR_PER_ROW / 2
					switch (this.pictureContents.size()) {
					case 1: {
						if (this.currentRow < 0.7 * MAX_ROW) {
							Picture pic = this.pictureContents.get(0);
							pic.setTop(TOP + this.currentRow * HEIGHT_UNIT);
							pic.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
							pic.setWidthAutoScale(1);
							pic.setLeft((MAX_WIDTH - pic.getWidth()) / 2);
							computed = true;
						}
						break;
					}
					case 2: {
						if (this.currentRow < 0.7 * MAX_ROW) {
							Picture pic = this.pictureContents.get(0);
							pic.setTop(TOP + this.currentRow * HEIGHT_UNIT);
							pic.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
							pic.setWidthAutoScale(1);
							pic.setLeft(IMG_LEFT);

							Picture pic2 = this.pictureContents.get(1);
							pic2.setTop(TOP + this.currentRow * HEIGHT_UNIT);
							pic2.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
							pic2.setWidthAutoScale(1);
							pic2.setLeft(IMG_LEFT + pic.getWidth() + 10);
							computed = true;
						}
						break;
					}
					default: {
						if (this.currentRow < 0.7 * MAX_ROW) {
							Picture pic = this.pictureContents.get(0);
							pic.setTop(TOP + this.currentRow * HEIGHT_UNIT);
							pic.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
							pic.setWidthAutoScale(1);
							pic.setLeft(IMG_LEFT);

							Picture pic2 = this.pictureContents.get(1);
							pic2.setTop(TOP + this.currentRow * HEIGHT_UNIT);
							pic2.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
							pic2.setWidthAutoScale(1);
							pic2.setLeft(IMG_LEFT + pic.getWidth() + 10);

							int maxR = 0; // find row longest
							int idxR = 0; // find index has max_R
							for (int i = this.textContents.size() - 1; i > MAX_ROW / 2 - 1; i++) {
								if (this.textContents.get(i).getLengh() > maxR) {
									maxR = this.textContents.get(i).getLengh();
									idxR = i;
								}
							}
							maxR = 0;
							if (idxR > 0.4 * MAX_ROW) {
								for (int i = 0; i < idxR; i++) {
									if (this.textContents.get(i).getLengh() > maxR) {
										maxR = this.textContents.get(i).getLengh();
									}
								}

								Picture pic3 = this.pictureContents.get(2);
								pic3.setTop(TOP);
								pic3.setLeft(TEXT_LEFT + maxR * WIDTH_UNIT);
								pic3.setHeight(MAX_HEIGHT - idxR * HEIGHT_UNIT);
								pic3.setWidthAutoScale(2);
								computed = true;
							}
						}
						break;
					}
					}
				}
			} else if (this.currentRow > 0) {
				if (this.maxCharacter > this.maxCharacterPerRow / 2) {
					// Option 3:
					// Row little than MAX_ROW / 2
					// Exist line longer MAX_CHAR_PER_ROW / 2
					switch (this.pictureContents.size()) {
					case 1: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP + this.currentRow * HEIGHT_UNIT);
						pic.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
						pic.setWidthAutoScale(1);
						pic.setLeft((MAX_WIDTH - pic.getWidth()) / 2);
						computed = true;
						break;
					}
					case 2: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP + this.currentRow * HEIGHT_UNIT);
						pic.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
						pic.setWidthAutoScale(1);
						pic.setLeft(IMG_LEFT);

						Picture pic2 = this.pictureContents.get(1);
						pic2.setTop(TOP + this.currentRow * HEIGHT_UNIT);
						pic2.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
						pic2.setWidthAutoScale(1);
						pic2.setLeft(IMG_LEFT + pic.getWidth() + 10);
						computed = true;
						break;
					}
					default: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP + this.currentRow * HEIGHT_UNIT);
						pic.setHeight(MAX_HEIGHT / 2);
						pic.setWidthAutoScale(1);
						pic.setLeft(IMG_LEFT);

						Picture pic2 = this.pictureContents.get(1);
						pic2.setTop(TOP + this.currentRow * HEIGHT_UNIT);
						pic2.setHeight(MAX_HEIGHT / 2);
						pic2.setWidthAutoScale(1);
						pic2.setLeft(IMG_LEFT + pic.getWidth() + 10);

						int maxR = 0; // find row longest
						for (int i = this.pictureContents.size() - 1; i > MAX_ROW / 2 - 1; i++) {
							if (this.textContents.get(i).getLengh() > maxR) {
								maxR = this.textContents.get(i).getLengh();
							}
						}
						Picture pic3 = this.pictureContents.get(2);
						pic3.setTop(TOP);
						pic3.setLeft(TEXT_LEFT + maxR * WIDTH_UNIT);
						pic3.setHeight(MAX_HEIGHT / 2);
						pic3.setWidthAutoScale(2);
						computed = true;
						break;
					}
					}
				} else {
					// Option 4:
					// Row little than MAX_ROW / 2
					// No line longer MAX_CHAR_PER_ROW / 2
					switch (this.pictureContents.size()) {
					case 1: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP + MAX_HEIGHT / 2);
						pic.setHeight(MAX_HEIGHT / 2 - 10);
						pic.setWidthAutoScale(1);
						pic.setLeft((MAX_WIDTH - pic.getWidth()) / 2);
						computed = true;
						break;
					}
					case 2: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP);
						pic.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
						pic.setHeight(MAX_HEIGHT / 2);
						pic.setWidthAutoScale(2);

						Picture pic2 = this.pictureContents.get(1);
						pic2.setTop(TOP + MAX_HEIGHT / 2 + 10);
						pic2.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
						pic2.setHeight(MAX_HEIGHT / 2);
						pic2.setWidthAutoScale(2);
						computed = true;
						break;
					}
					default: {
						Picture pic = this.pictureContents.get(0);
						pic.setTop(TOP);
						pic.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
						pic.setHeight(MAX_HEIGHT / 2);
						pic.setWidthAutoScale(2);

						Picture pic2 = this.pictureContents.get(1);
						pic2.setTop(TOP + MAX_HEIGHT / 2 + 10);
						pic2.setLeft(this.maxCharacter * WIDTH_UNIT + TEXT_LEFT + DEPTH_LENGTH * this.maxDepth);
						pic2.setHeight(MAX_HEIGHT / 2);
						pic2.setWidthAutoScale(2);

						Picture pic3 = this.pictureContents.get(2);
						pic3.setTop(TOP + this.currentRow * HEIGHT_UNIT);
						pic3.setLeft(IMG_LEFT);
						pic3.setHeight(MAX_HEIGHT - this.currentRow * HEIGHT_UNIT);
						pic3.setWidthAutoScale(2);
						computed = true;
						break;
					}
					}
				}

			} else {
				// Option 5 none text
				Picture pic = this.pictureContents.get(0);
				pic.setTop(TOP);
				pic.setHeight(MAX_HEIGHT);
				pic.setWidthAutoScale(1);
				pic.setLeft((MAX_WIDTH - pic.getWidth()) / 2);
				computed = true;
			}
			if (!computed) {
				this.putTextIntoSlide();
				this.addNewSlide(SlideLayout.TITLE_AND_CONTENT);
				this.currentRow = MAX_ROW;
			}
		}
		if (this.webPageContent.getRowOfContent() > 0) {
			// Compute display Webpage
			if (this.pictureContents.size() > 0 || this.webPageContent.getRowOfContent() > MAX_ROW - this.currentRow) {
				this.putTextIntoSlide();
				this.putPictureIntoSilde();
				this.addNewSlide(SlideLayout.TITLE_AND_CONTENT);
			}
		}

		if (this.iframeContent.hasIframe()) {
			this.putTextIntoSlide();
			this.putPictureIntoSilde();
			this.putWebpageIntoSlide();
			this.addNewSlide(SlideLayout.TITLE_AND_CONTENT);
		}
	}

	private String extractText(Node node) {
		String txt = node.getText();
		if (txt == null)
			txt = "";

		String richTxt = null;
		RichContent richContent = node.getRichContent();
		if (richContent != null) {
			richTxt = richContent.getContent();
		}
		if (richTxt != null) {
			Parser parser = new Parser();
			try {
				parser.setInputHTML(richTxt);
				TextExtractingVisitor visitor = new TextExtractingVisitor();
				parser.visitAllNodesWith(visitor);
				txt += visitor.getExtractedText().trim();
			} catch (ParserException e) {
				e.printStackTrace();
			}
		}

		return StringEscapeUtils.unescapeHtml(txt);
	}

	private String extractLink(Node node) {
		return node.getLink();
	}

	private String[] extractImage(Node node) {
		ArrayList<String> images = new ArrayList<String>();

		String richTxt = null;
		RichContent richContent = node.getRichContent();
		if (richContent != null) {
			richTxt = richContent.getContent();
		}
		if (richTxt != null) {
			Document doc = Jsoup.parse(richTxt);
			Elements elements = doc.select("img");
			for (Element element : elements) {
				images.add(element.attr("src"));
			}
		}
		;

		// Find images that exist in the ForeignObject (example in the webpage)
		ForeignObject foreignObject = node.getForeignObject();
		if (foreignObject != null) {
			Document doc = Jsoup.parse(foreignObject.getContent());
			Elements elements = doc.select("img");
			for (Element element : elements) {
				images.add(element.attr("src"));
			}
		}

		return images.toArray(new String[images.size()]);
	}

	private String extractVideo(Node node) {
		String video = null;
		ForeignObject foreignObject = node.getForeignObject();
		if (foreignObject != null) {
			String link = node.getLink();
			if (link != null && link.trim().length() > 0) {
				String regexUrl = "https?:\\/\\/(?:[0-9A-Z-]+\\.)?(?:youtu\\.be\\/|youtube\\.com\\S*[^\\w\\-\\s])([\\w\\-]{11})(?=[^\\w\\-]|$)(?![?=&+%\\w]*(?:['\"][^<>]*>|<\\/a>))[?=&+%\\w]*";
				Pattern compiledPattern = Pattern.compile(regexUrl, Pattern.CASE_INSENSITIVE);
				Matcher matcher = compiledPattern.matcher(link);
				if (matcher.find()) {
					video = matcher.group();
				}
			}
		}
		return video;
	}

	private String extractWebpage(Node node) {
		String content = null;
		ForeignObject foreignObject = node.getForeignObject();
		if (foreignObject != null) {
			Document doc = Jsoup.parse(foreignObject.getContent());
			Elements elements = doc.select("iframe");
			if (elements.size() == 0) {
				content = foreignObject.getContent();
			}
		}
		return content;
	}

	private String extractiFrame(Node node) {
		String iframe = null;
		ForeignObject foreignObject = node.getForeignObject();
		String link = node.getLink();
		if (foreignObject != null && link != null && extractVideo(node) == null) {
			iframe = link;
		}
		return iframe;
	}

	private String textProcessing(String text) {
		String result = "";
		// remove shift enter
		result = text.replace("\n", "");

		// compute how many line
		int x = result.length() / this.maxCharacterPerRow;
		int y = result.length() % this.maxCharacterPerRow;
		if (y > 0) {
			if(this.isDivide) this.rowOfText = x + 1;
			if (y > this.maxCharacter) {
				if (x == 0) {
					this.maxCharacter = y;
				} else {
					this.maxCharacter = this.maxCharacterPerRow;
				}
			}
		} else {
			if(this.isDivide) this.rowOfText = x;
			this.maxCharacter = this.maxCharacterPerRow;
		}
		return result;
	}
}

