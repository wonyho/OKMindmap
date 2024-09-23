/**
 *
 * @author Nguyen Van Hoang (nvhoangag@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com)
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */
///////////////////////////////////////////////////////////////////////////////
///////////////////    jZoomableTreemapNodeController    //////////////////////
///////////////////////////////////////////////////////////////////////////////
jZoomableTreemapNodeController = function() {
	jZoomableTreemapNodeController.superclass.call(this);
};
extend(jZoomableTreemapNodeController, jNodeController);

jZoomableTreemapNodeController.prototype.type = "jZoomableTreemapNodeController";

jZoomableTreemapNodeController.prototype.dblclick = function(e) {
	var node = jMap.getSelected();
	
	var originalEvent;
	if (!e) var e = window.event;
	originalEvent = e.originalEvent.originalEvent || e.originalEvent || e;
	if (originalEvent.preventDefault)
		originalEvent.preventDefault();
	else
		originalEvent.returnValue = false;

	if (jMap.arcTweenNode.id == node.parent.id) {
		jMap.getRootNode().zoomExecute();
	} else {
		node.parent.zoomExecute();
	}
};

jZoomableTreemapNodeController.prototype.mouseenter = function(e) {
	this.node.showPopover();
};

jZoomableTreemapNodeController.prototype.mouseleave = function(e) {
	var id = 'data-popover-id';
	var el = e.toElement || e.relatedTarget;
	if ($(el).closest('.jpopover').parent().attr(id) != this.node.popover.container.attr(id)) {
		this.node.hidePopover();
	}

};

jZoomableTreemapNodeController.prototype.popoverMouseleave = function(e) {
	var id = $(this).parent().attr('data-popover-id');
	if (jMap.nodes[id]) {
		jMap.nodes[id].hidePopover();
	}
};

///////////////////////////////////////////////////////////////////////////////
////////////////// jZoomableTreemapNodeControllerGuest    /////////////////////
///////////////////////////////////////////////////////////////////////////////
jZoomableTreemapNodeControllerGuest = function() {
	jZoomableTreemapNodeControllerGuest.superclass.call(this);
};
extend(jZoomableTreemapNodeControllerGuest, jNodeControllerGuest);

jZoomableTreemapNodeControllerGuest.prototype.type = "jZoomableTreemapNodeControllerGuest";

jZoomableTreemapNodeControllerGuest.prototype.dblclick = function(e) {
	var originalEvent;
	if (!e) var e = window.event;
	originalEvent = e.originalEvent.originalEvent || e.originalEvent || e;
	if (originalEvent.preventDefault)
		originalEvent.preventDefault();
	else
		originalEvent.returnValue = false;

	if (jMap.arcTweenNode.id == this.node.parent.id) {
		jMap.getRootNode().zoomExecute();
	} else {
		this.node.parent.zoomExecute();
	}
};

jZoomableTreemapNodeControllerGuest.prototype.mouseenter = function(e) {
	this.node.showPopover();
};

jZoomableTreemapNodeControllerGuest.prototype.mouseleave = function(e) {
	var id = 'data-popover-id';
	var el = e.toElement || e.relatedTarget;
	if ($(el).closest('.jpopover').parent().attr(id) != this.node.popover.container.attr(id)) {
		this.node.hidePopover();
	}
};

jZoomableTreemapNodeControllerGuest.prototype.popoverMouseleave = function(e) {
	var id = $(this).parent().attr('data-popover-id');
	if (jMap.nodes[id]) {
		jMap.nodes[id].hidePopover();
	}
};

///////////////////////////////////////////////////////////////////////////////
///////////////////////    jZoomableTreemapNode    ////////////////////////////
///////////////////////////////////////////////////////////////////////////////
jZoomableTreemapNode = function(param) {
	var parentNode = param.parent;
	var text = param.text;
	var id = param.id;
	var index = param.index;
	var position = param.position;

	this.popover = {
		container : null,
		body : null,
		text : null,

		img : null,
		hyperlink : null,
		foreignObjEl : null
	};

	jZoomableTreemapNode.superclass.call(this, parentNode, text, id, index, position);
};

extend(jZoomableTreemapNode, jNode);

jZoomableTreemapNode.prototype.type = "jZoomableTreemapNode";

jZoomableTreemapNode.prototype.initElements = function() {
	this.body = RAPHAEL.rect();
	this.text = RAPHAEL.text();
	this.wrapElements(this.body, this.text);

	this.popover.container = $('<div data-popover-type="' + this.type + '" data-popover-id="' + this.id + '"><div class="jpopover"></div></div>').appendTo(jMap.popoverContainer);
	this.popover.body = $('<div class="jpopover-body"></div>').appendTo(this.popover.container.children('.jpopover'));
	this.popover.text = $('<div class="jpopover-text"></div>').appendTo(this.popover.container.children('.jpopover'));
	this.popover.iconMenus = $('<div class="jpopover-menu"></div>').appendTo(this.popover.container.children('.jpopover'));
};

jZoomableTreemapNode.prototype.create = function() {
	var centerLocation = jMap.layoutManager.getCenterLocation();

	this.position = this.position || ((this.parent && this.parent.position) ? this.parent.position : 'left');

	this.groupEl.setAttribute('data-node-type', this.type);
	this.groupEl.setAttribute('data-node-id', this.id);
	this.groupEl.setAttribute('pointer-events', 'all');

	this.body.node.setAttribute('pointer-events', 'all');

	this.setBackgroundColorExecute(jMap.cfg.nodeDefalutColor);
	this.setTextColorExecute(jMap.cfg.textDefalutColor);
	

	if (typeof NodeColorMix !== 'undefined') {
		NodeColorMix.rawDressColor(this);
	}
	
	this.setEdgeColorExecute(jMap.cfg.edgeDefalutColor, jMap.cfg.edgeDefalutWidth);
	
	var fontWeight = 400;
	var fontFamily = 'Malgun Gothic, 맑은고딕, Gulim, 굴림, Arial, sans-serif';
	this.fontSize = jMap.cfg.nodeFontSizes[3];
	if (!this.getParent()) {
		fontWeight = '400';
	} else if (this.getParent() && this.getParent().isRootNode()) {
		fontWeight = '400';
	} else {
		fontWeight = '400';
	}

	this.text.attr({
		'font-family' : fontFamily,
		'font-size' : this.fontSize,
		'font-weight' : fontWeight,
		'text-anchor' : null
	});
	$(this.text.node).css('pointer-events', 'none');

	this.setTextExecute(this.plainText);
};

var custom_zoomable_treemap_touchtime = 0;
jZoomableTreemapNode.prototype.addEventController = function(c) {
	c = jMap.mode ? new jZoomableTreemapNodeController() : new jZoomableTreemapNodeControllerGuest();
	this.controller = c;

	$(this.groupEl).on("vmousedown", c.mousedown);
	$(this.groupEl).on("vmousemove", c.mousemove);
	$(this.groupEl).on("vmouseup", c.mouseup);

	//	$(this.groupEl).on("vmouseover", c.mouseover);
	//	$(this.groupEl).on("vmouseout", c.mouseout);
	// Use it for popover and do not affect the base event
	$(this.groupEl).on("mouseover", c.mouseenter);
	$(this.groupEl).on("mouseout", c.mouseleave);
	this.popover.container.children('.jpopover').on("mouseleave", c.popoverMouseleave);

	var self = this;
	this.popover.container.children('.jpopover').on('vclick', function() {
		if (custom_zoomable_treemap_touchtime == 0) {
			// set first click
			custom_zoomable_treemap_touchtime = new Date().getTime();
		} else {
			// compare first click to this click and see if they occurred within double click threshold
			if (((new Date().getTime()) - custom_zoomable_treemap_touchtime) < 400) {
				custom_zoomable_treemap_touchtime = 0;
				// double click occurred
				if(!jMap.cfg.isShrdGuest) jMap.controller.startNodeEdit(self);
			} else {
				// not a double click so set as a new first click
				custom_zoomable_treemap_touchtime = new Date().getTime();
			}
		}
	});

	$(this.groupEl).on("taphold", c.taphold);

	$(this.groupEl).on("vclick", c.click);

	//$(this.groupEl).on("dblclick", c.dblclick);

	//	$(this.groupEl).on("dragenter", c.dragenter);
	//	$(this.groupEl).on("dragleave", c.dragexit);
	//	$(this.groupEl).on("drop", c.drop);

	// Disable the contextmenu on mobile. The short cut menu will be used.
	//if(!(ISMOBILE || supportsTouch)) $(this.groupEl).on("contextmenu", c.contextmenu);
};

jZoomableTreemapNode.prototype.setTextExecute = function(text) {
	this.plainText = text;
	this.text.attr({
		text : text.split('\n')[0]
	});
	this.CalcBodySize();

	if (text.indexOf('\n')) {
		text = text.split('\n').join('<br>');
	}
	this.popover.text.html(text);
};

jZoomableTreemapNode.prototype.setHyperlink = function(url) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}

	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);

	this.setHyperlinkExecute(url);

	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);

	jMap.saveAction.editAction(this);

	jMap.fireActionListener(ACTIONS.ACTION_NODE_HYPER, this);
	jMap.setSaved(false);
};

jZoomableTreemapNode.prototype.setHyperlinkExecute = function(url) {
	if (url == null || url == "") {
		if (this.hyperlink) {
			this.hyperlink = null;

			this.popover.hyperlink.remove();
			this.popover.hyperlink = null;
			this.popover.container.removeAttr('data-has-hyperlink');

			this.CalcBodySize();
		}
		return;
	}
	if (!this.hyperlink) {
		this.hyperlink = RAPHAEL.image(jMap.cfg.contextPath + '/images/hyperlink.png', 0, 0, 11, 11);
		this.hyperlink.attr({
			cursor : "pointer"
		});

		this.popover.hyperlink = $('<a></a>')
			.attr('class', 'jpopover-hyperlink')
			.appendTo(this.popover.body);
		$('<img />').attr('src', jMap.cfg.contextPath + '/images/hyperlink.png')
			.width(11)
			.height(11)
			.appendTo(this.popover.hyperlink);
		this.popover.container.attr('data-has-hyperlink', true);
	}
	this.hyperlink.attr({
		href : url,
		target : "blank"
	});
	this.popover.hyperlink.attr('href', url).attr('target', '_blank');

	this.CalcBodySize();
	jMap.resolveRendering();
};

jZoomableTreemapNode.prototype.setFile = function(url){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setFileExecute(url);
	
	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	

	jMap.fireActionListener(ACTIONS.ACTION_NODE_FILE, this);	
	jMap.setSaved(false);
	
	// selectedNodeMenu(true, this);
}

jZoomableTreemapNode.prototype.setFileExecute = function(url){
	if (url == null || url == "") {
		if (this.file){
			// var aTag = this.file.node.parentNode;
			// var gTag = this.file.node.parentNode.parentNode;
			
			// gTag.removeChild(aTag);
			// this.file = null;
			
			// this.CalcBodySize();

			this.file = null;

			this.popover.file.remove();
			this.popover.file = null;
			this.popover.container.removeAttr('data-has-file');

			this.CalcBodySize();
		}
		return;
	}
	if(!this.file){
		this.file = RAPHAEL.image(jMap.cfg.contextPath+'/menu/icons/icon_file.png',
										0, 0, 24, 24);
		// if(Raphael.svg) this.groupEl.appendChild(this.file.node);
		// if(Raphael.vml) this.groupEl.appendChild(this.file.Group);
		
		// this.file.attr({cursor:"pointer"});

		this.popover.file = $('<a></a>')
			.attr('class', 'jpopover-file')
			.appendTo(this.popover.iconMenus);
		$('<img />').attr('src', jMap.cfg.contextPath + '/menu/icons/icon_file.png')
			.width(24)
			.height(24)
			.appendTo(this.popover.file);
		this.popover.container.attr('data-has-file', true);
	}
	this.file.attr({href:url, target:"blank"});			
	this.popover.file.attr('href', url).attr('target', '_blank');
	this.CalcBodySize();
	
	jMap.resolveRendering();
}

jZoomableTreemapNode.prototype.setNote = function(txt){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setNoteExecute(txt);
	
	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	

	jMap.fireActionListener(ACTIONS.ACTION_NODE_NOTE, this);	
	jMap.setSaved(false);
	
	// selectedNodeMenu(true, this);
}

jZoomableTreemapNode.prototype.setNoteExecute = function(txt){
	if (txt == null || txt == "") {
		if (this.note){
			// var aTag = this.note.node.parentNode;
			// var gTag = this.note.node.parentNode.parentNode;
			
			// gTag.removeChild(aTag);
			// this.note = null;
			// this.noteText = null;
			
			// this.CalcBodySize();

			this.note = null;

			this.popover.note.remove();
			this.popover.note = null;
			this.popover.container.removeAttr('data-has-note');

			this.CalcBodySize();
		}
		return;
	}
	if(!this.note){
		this.note = RAPHAEL.image(jMap.cfg.contextPath+'/menu/icons/icon_note.png',
										0, 0, 24, 24);
		// if(Raphael.svg) this.groupEl.appendChild(this.note.node);
		// if(Raphael.vml) this.groupEl.appendChild(this.note.Group);
		
		// this.note.attr({cursor:"pointer"});

		this.popover.note = $('<a></a>')
			.attr('class', 'jpopover-note')
			.appendTo(this.popover.iconMenus);
		$('<img />').attr('src', jMap.cfg.contextPath + '/menu/icons/icon_note.png')
			.width(24)
			.height(24)
			.appendTo(this.popover.note);
		this.popover.container.attr('data-has-note', true);
	}
	this.noteText = txt;
	
	// this.note.attr({href:"javascript:showNoteAction();"});
	this.popover.note.attr({ href:"javascript:showNoteAction('"+this.id+"');"});
	//this.note.attr({href:"#", target:"blank", onclick:"alert('aa');"});
	//this.note.addEventListener("click", function() {
	//    alert("aaa");         
	//}, true);
	
	this.CalcBodySize();
	
	jMap.resolveRendering();
	
}

jZoomableTreemapNode.prototype.setImage = function(url, width, height) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}

	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);

	this.setImageExecute(url, width, height, function() {
		var redo = history && history.extractNode(this);
		history && history.addToHistory(undo, redo);

		jMap.saveAction.editAction(this);
		jMap.fireActionListener(ACTIONS.ACTION_NODE_IMAGE, this.id, url, width, height);
		jMap.setSaved(false);
	});
};

jZoomableTreemapNode.prototype.setImageExecute = function(url, width, height, _callback) {
	if (url == null || url == "") {
		if (this.img) {
			this.img = null;
			this.imgInfo = {};

			this.popover.img.remove();
			this.popover.img = null;

			this.CalcBodySize();

			_callback && _callback.call(this);
		}
		return false;
	}

	var node = this;
	checkGifNotiStatus(url);
	// Preload
	var $img = $('<img />')
		.attr('src', url)
		.load(function() {
			var defaultSize = jMap.cfg.default_img_size;
			var imgSize = {
				width : 0,
				height : 0
			};

			// 크기가 디폴드값 보다 큰 것만 크기를 조정한다.
			if (this.width > defaultSize) {
				imgSize.width = defaultSize;
				imgSize.height = (this.height * defaultSize) / this.width;
			} else {
				imgSize.width = this.width;
				imgSize.height = this.height;
			}


			if (width)
				imgSize.width = width;
			if (height)
				imgSize.height = height;

			imgSize.width = parseInt(imgSize.width);
			imgSize.height = parseInt(imgSize.height);

			// 이미지 중복 방지
			if (node.img) {
				node.img.attr({
					src : this.src,
					width : imgSize.width,
					height : imgSize.height
				});
				node.imgInfo.href = this.src;
				node.imgInfo.width = imgSize.width;
				node.imgInfo.height = imgSize.height;

				node.popover.img
					.attr('src', this.src)
					.width(imgSize.width)
					.height(imgSize.height);
			} else {
				node.img = RAPHAEL.image(this.src, 0, 0, imgSize.width, imgSize.height);
				node.imgInfo.href = this.src;
				node.imgInfo.width = imgSize.width;
				node.imgInfo.height = imgSize.height;

				node.popover.img = $('<img />')
					.attr('class', 'jpopover-img')
					.attr('src', this.src)
					.width(imgSize.width)
					.height(imgSize.height)
					.appendTo(node.popover.body);
			}

			jMap.loadManager.updateImageLoading(this);

			_callback && _callback.call(node);
			return true; // 의미 없음
		}).error(function() {
		var imgBrokenPath = jMap.cfg.contextPath + '/images/image_broken.png';

		// 이미지 중복 방지
		if (node.img) {
			node.img.attr({
				src : imgBrokenPath,
				width : 64,
				height : 64
			});
			node.imgInfo.href = url;
			node.imgInfo.width = width && width;
			node.imgInfo.height = height && height;

			node.popover.img
				.attr('src', imgBrokenPath)
				.width(64)
				.height(64);
		} else {
			node.img = RAPHAEL.image(jMap.cfg.contextPath + '/images/image_broken.png', 0, 0, 64, 64);
			node.imgInfo.href = url;
			node.imgInfo.width = width && width;
			node.imgInfo.height = height && height;

			node.popover.img = $('<img />')
				.attr('class', 'jpopover-img')
				.attr('src', imgBrokenPath)
				.width(64)
				.height(64)
				.appendTo(node.popover.body);
		}

		jMap.loadManager.updateImageLoading(this);

		_callback && _callback.call(node);
	});

	jMap.loadManager.updateImageLoading($img[0]);
};

jZoomableTreemapNode.prototype.imageResize = function(width, height) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}

	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);

	this.imageResizeExecute(width, height);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);

	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_IMAGE, this.id, null, width, height);
	jMap.setSaved(false);
};

jZoomableTreemapNode.prototype.imageResizeExecute = function(width, height) {
	this.img && this.img.attr({
		width : width,
		height : height
	});
	this.imgInfo.width = width;
	this.imgInfo.height = height;

	this.popover.img.width(width).height(height);
};

jZoomableTreemapNode.prototype.setForeignObject = function(html, width, height) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}

	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);

	this.setForeignObjectExecute(html, width, height);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);

	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_FOREIGNOBJECT, this, html, width, height);
	jMap.setSaved(false);
};

jZoomableTreemapNode.prototype.setForeignObjectExecute = function(html, width, height) {
	if (!Raphael.svg) return false;

	if (html == null || html == "") {
		this.foreignObjEl = null;
		if(this.popover.foreignObjEl) this.popover.foreignObjEl.remove();
		this.popover.foreignObjEl = null;

		this.CalcBodySize();

		return false;
	}

	html = convertXML2Char(html);

	if (!this.foreignObjEl) {
		this.foreignObjEl = document.createElementNS("http://www.w3.org/2000/svg", "foreignObject");
		this.foreignObjEl.bodyEl = document.createElementNS("http://www.w3.org/1999/xhtml", "body");
		this.foreignObjEl.appendChild(this.foreignObjEl.bodyEl);

		this.popover.foreignObjEl = $('<div></div>')
			.attr('class', 'jpopover-foreignObjEl')
			.appendTo(this.popover.body);
	}

	width = width || 150;
	height = height || 150;

	this.foreignObjEl.setAttribute("width", width);
	this.foreignObjEl.setAttribute("height", height);

	this.popover.foreignObjEl.width(width);
	this.popover.foreignObjEl.height(height);

	// 사용자가 정의한 html은 저장이나 다른 곳에서 사용해야 하는데
	// innerHTML에 html 코드를 넣으면 몇몇 정보가 바뀌어 버리는것이 있다. (태그를 삭제한다든가 하는..)
	// 그래서 plainHtml에 순수한 html 문자열을 갖고 있는다.
	this.foreignObjEl.bodyEl.innerHTML = html;
	this.foreignObjEl.plainHtml = html;

	this.popover.foreignObjEl.html(html);

	// 몇몇 브라우저에서는 유투브 동영상이 지원하지 않아서 그림을 대처하는데,
	// 그 방법으로 html 내용에 youtube.com있으면 유투브 동영상이라 판단하고 처리한다.
	// 문자열에 youtube.com이 있을수도 있기 떄문에 다음과 같이 처리하는것은 좋지 않다.
	if ( /*BrowserDetect.browser == "Firefox" || */ BrowserDetect.browser == "MSIE") {
		var pos = html.search(/youtube\.com/);
		if (pos != -1) {
			var imgVideoNotSupport = '<img src="' + jMap.cfg.contextPath + '/images/video_not_support.png" width="300" height="300"/>';
			this.foreignObjEl.bodyEl.innerHTML = imgVideoNotSupport;
			this.popover.foreignObjEl.html(imgVideoNotSupport);
		}
	}

	this.CalcBodySize();
};

jZoomableTreemapNode.prototype.foreignObjectResize = function(width, height) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}

	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);

	this.foreignObjectResizeExecute(width, height);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);

	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_FOREIGNOBJECT, this, null, width, height);
	jMap.setSaved(false);
};

jZoomableTreemapNode.prototype.foreignObjectResizeExecute = function(width, height) {
	width && this.foreignObjEl.setAttribute("width", width);
	height && this.foreignObjEl.setAttribute("height", height);

	width && this.popover.foreignObjEl.width(width);
	height && this.popover.foreignObjEl.height(height);

	var html = this.foreignObjEl.plainHtml;
	html = html.replace(/(width=")([^"]*)/ig, "$1" + width);
	html = html.replace(/(height=")([^"]*)/ig, "$1" + height);

	this.foreignObjEl.bodyEl.innerHTML = html;
	this.foreignObjEl.plainHtml = html;
	this.popover.foreignObjEl.html(html);
	this.CalcBodySize();
	jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(this);
	jMap.layoutManager.layout(true);
};

jZoomableTreemapNode.prototype.setEmbedVideo = function(code) {
	var widthRe = /width?=?["']([^"']*)/gi;
	var width = widthRe.exec(code)[1];
	var heightRe = /height?=?["']([^"']*)/gi;
	var height = heightRe.exec(code)[1];
	this.setForeignObject(code, width, height);
};

jZoomableTreemapNode.prototype.setVideo = function(playUrl, width, height) {
	var defaultSize = jMap.cfg.default_video_size;

	var html = '<embed src="' + playUrl + '" width="' + width + '"  height="' + height + '"></embed>';
	this.setHyperlink(playUrl);
	this.setForeignObject(html, width, height);
};

jZoomableTreemapNode.prototype.setYoutubeVideo = function(playUrl, width, height) {
	var defaultSize = jMap.cfg.default_video_size;

	if (width == null) {
		width = defaultSize;
	}
	if (height == null) {
		height = defaultSize;
	}
	var re = /v[=\/]([^&]*)/ig;
	var match = re.exec(playUrl);
	if (match) {
		var url = 'https://www.youtube.com/embed/' + match[1];

		var html = '<iframe src="' + url + '" frameborder="0" allowtransparency="true" width="' + width + '"  height="' + height + '" scrolling="no"></iframe>';
		this.setHyperlink(playUrl);
		this.setForeignObject(html, width, height);
	}
};

jZoomableTreemapNode.prototype.zoomExecute = function(duration) {
	var layout = jMap.layoutManager;
	var centerLocation = layout.getCenterLocation();
	var node = this;
	duration = (duration == undefined ? layout.duration : duration);

	layout.hideAllPopover();
	jMap.arcTweenNode = node;

	var kx = layout.width / node.dx,
		ky = layout.height / node.dy;

	layout.x.domain([ node.x, node.x + node.dx ]);
	layout.y.domain([ node.y, node.y + node.dy ]);

	var cell = d3.selectAll('g[data-node-type="' + jMap.cfg.nodeStyle + '"][data-node-leaf="true"]')
		.transition()
		.duration(duration)
		.attr('transform', function(d) {
			return 'translate(' + [ centerLocation.x + layout.x(d.x), centerLocation.y + layout.y(d.y) ] + ')';
		});

	cell.select('rect')
		.attr('width', function(d) {
			return kx * d.dx - 1;
		})
		.attr('height', function(d) {
			jMap.nodes[d.id].pWidth = kx * d.dx - 1;
			jMap.nodes[d.id].pHeight = ky * d.dy - 1;
			return ky * d.dy - 1;
		});
	
	/*
	cell.select('text')
		.attr('x', function(d) {
			return kx * d.dx / 2;
		})
		.attr('y', function(d) {
			return ky * d.dy / 2;
		})
		.style('opacity', function(d) {
			return kx * d.dx > jMap.nodes[d.id].w ? 1 : 0;
		});
	*/
	cell.select('text')
		.style('opacity', function(d){
			var lines = jMap.nodes[d.id].plainText.split(/\r\n|\n|\r/);
			return (ky * d.dy - 1) < (lines.length * jMap.cfg.nodeFontSizes[1]) ? 0:1;
		})
        .attr('transform', function(d) {
			setTimeout(function() {
				jMap.nodes[d.id].computedTextExecute();
			}, duration);
			return 'translate(' + (kx * d.dx / 2) + ',' + (ky * d.dy / 2) + ')';
		});

	return {
		end : function(callback) {
			setTimeout(function() {
				callback();
			}, duration);
		}
	};
};

jZoomableTreemapNode.prototype.getChildren = function() {
	return this.children || [];
};

jZoomableTreemapNode.prototype.screenFocus = function() {
	this.zoomExecute();
};

jZoomableTreemapNode.prototype.showPopover = function() {
	var offset = this.getPopoverLocation();

	this.popover.container.attr('style', 'top: ' + (offset.top) + 'px; left: ' + (offset.left) + 'px;');
	this.popover.container.addClass('active');
	this.popover.container.attr('data-placement', 'right');
};

jZoomableTreemapNode.prototype.hidePopover = function() {
	this.popover.container.removeClass('active');
};

jZoomableTreemapNode.prototype.getPopoverLocation = function() {
	var groupEl = this.groupEl.getBBox();
	var offset = $(this.groupEl).offset();
	offset.top += (groupEl.height / 2) * jMap.cfg.scale;
	offset.left += (groupEl.width / 2) * jMap.cfg.scale;
	
	var ribbon_h = $('#ribbon').height() + 10;
	var popover_w = this.popover.container.width();
	var popover_h = this.popover.container.height();
	var window_w = $(window).width();
	var window_h = $(window).height();
	var padding = 5;
	
	// top
	if(offset.top < ribbon_h + padding){
		offset.top = ribbon_h + padding;
	}else if(offset.top + popover_h > window_h - padding){
		offset.top = window_h - popover_h - padding;
	}
	
	//left
	if(this.angle > 90){
		if(offset.left - popover_w < padding){
			offset.left = padding + popover_w;
		}
	}else{
		if(offset.left < padding){
			offset.left = padding;
		}else if(offset.left + popover_w > window_w - padding){
			offset.left = window_w - padding - popover_w;
		}
	}
	
	return offset;
};

jSunburstNode.prototype.hidePopover = function() {
	this.popover.container.removeClass('active');
};

jZoomableTreemapNode.prototype.getPartitionTreeData = function() {
	var treeData = {};
	treeData.id = this.id;

	if (this.children.length) {
		treeData.children = [];
		this.children.forEach(function(node) {
			treeData.children.push(node.getPartitionTreeData());
		});
	}

	return treeData;
};

jZoomableTreemapNode.prototype.getText = function() {
	return this.plainText;
};

jZoomableTreemapNode.prototype.computedTextExecute = function() {
	var node = this;
	var width = node.pWidth;

	var limit = Math.floor((width - 2 * jMap.layoutManager.padding) / (parseFloat(jMap.cfg.nodeFontSizes[1]) / 2)) - 4;

	var attr = {
		text: node.plainText
	};
	if (node.plainText.length > limit) {
		var text = node.plainText.slice(0, limit);
		attr.text = text == '' ? '':text + '...';
	}
	this.text.attr(attr);
};

jZoomableTreemapNode.prototype.toXML = function(alone) {
	var buffer = new StringBuffer();

	var isrichcontent = false;
	if (this.img != null || (this.text.attrs['text'] != null && this.text.attrs['text'].indexOf("\n") != -1)) {
		isrichcontent = true;
	}

	var buf = new StringBuffer();
	buf.add("<node");
	buf.add("CREATED=\"" + this.created + "\"");
	buf.add("ID=\"" + this.id + "\"");
	buf.add("MODIFIED=\"" + this.modified + "\"");

	buf.add("CREATOR=\"" + this.creator + "\"");
	buf.add("CLIENT_ID=\"" + this.client_id + "\"");

	if (!isrichcontent) {
		buf.add("TEXT=\"" + convertCharStr2SelectiveCPs(convertCharStr2XML(this.plainText, true, true), 'ascii', true, '&#x', ';', 'hex') + "\"");
	}

	buf.add("FOLDED=\"" + this.folded + "\"");
	if (this.background_color != "") {
		buf.add("BACKGROUND_COLOR=\"" + this.background_color + "\"");
	}
	if (this.color != "") {
		buf.add("COLOR=\"" + this.color + "\"");
	}

	if (this.hyperlink != null) {
		buf.add("LINK=\"" + convertCharStr2XML(this.hyperlink.attr().href) + "\"");
	}
	if (this.file != null) {
		buf.add("FILE=\"" + convertCharStr2XML(this.file.attr().href) + "\"");		
	}
	if (this.noteText != null) {
		buf.add("NOTE=\"" + convertCharStr2XML(this.noteText) + "\"");		
	}
	if (this.position != "" && this.position != "undefined") {
		buf.add("POSITION=\"" + this.position + "\"");
	}
	if (this.style != "") {
		buf.add("STYLE=\"" + this.style + "\"");
	}
	if (this.hgap) {
		buf.add("HGAP=\"" + this.hgap + "\"");
	}
	if (this.vgap) {
		buf.add("VGAP=\"" + this.vgap + "\"");
	}
	if (this.vshift) {
		buf.add("VSHIFT=\"" + this.vshift + "\"");
	}

	if (this.numofchildren != null) {
		buf.add("NUMOFCHILDREN=\"" + this.numofchildren + "\"");
	}

	buf.add(">");
	buffer.add(buf.toString(" "));

	if (isrichcontent) {
		var richcontent = new StringBuffer();
		richcontent.add("<richcontent TYPE=\"NODE\"><html>\n");
		richcontent.add("  <head>\n");
		richcontent.add("\n");
		richcontent.add("  </head>\n");
		richcontent.add("  <body>\n");

		if (this.img != null) {
			richcontent.add("    <p>\n");
			richcontent.add("      <img src=\"" + this.imgInfo.href + "\" width=\"" + this.imgInfo.width + "\" height=\"" + this.imgInfo.height + "\" />\n");
			richcontent.add("    </p>\n");
		}

		if (this.text.attrs['text'] != null) {
			var textArr = JinoUtil.trimStr(this.text.attrs['text']).split("\n");
			for (var i = 0; i < textArr.length; i++) {
				richcontent.add("<p>" + convertCharStr2SelectiveCPs(convertCharStr2XML(textArr[i], true, true), 'ascii', true, '&#x', ';', 'hex') + "</p>\n");
			}
		}

		richcontent.add("  </body>\n");
		richcontent.add("</html>\n");
		richcontent.add("</richcontent>");

		buffer.add(richcontent.toString(" "));
	}

	// ArrowLink
	if (this.arrowlinks.length > 0) {
		for (var i = 0; i < this.arrowlinks.length; i++) {
			buffer.add(this.arrowlinks[i].toXML());
		}
	}

	// foreignObject
	if (this.foreignObjEl) {
		var foreignObject = new StringBuffer();
		foreignObject.add("<foreignObject WIDTH=\"" + this.foreignObjEl.getAttribute("width") + "\" HEIGHT=\"" + this.foreignObjEl.getAttribute("height") + "\">");
		var foreignObjElPlainHtml = this.foreignObjEl.plainHtml;
		foreignObjElPlainHtml = foreignObjElPlainHtml.split('class="lazy-load"').join('');
		foreignObjElPlainHtml = foreignObjElPlainHtml.replace(" data-src=", " src=");
		foreignObject.add(convertCharStr2SelectiveCPs(foreignObjElPlainHtml, 'ascii', true, '&#x', ';', 'hex'));
		foreignObject.add("</foreignObject>");

		buffer.add(foreignObject.toString(" "));
	}

	for (var attr_name in this.attributes)
		buffer.add("<attribute NAME='" + attr_name + "' VALUE='" +
			convertCharStr2SelectiveCPs(convertCharStr2XML(String(this.attributes[attr_name]), true, true),
				'ascii', true, '&#x', ';', 'hex') + "'/>");
	var exInfo = new StringBuffer();
	exInfo.add("<info");
	if (this.lazycomplete) {
		exInfo.add('LAZYCOMPLETE="' + this.lazycomplete + '"');
	}
	exInfo.add("/>");
	buffer.add(exInfo.toString(" "));

	var children = this.getChildren();
	if (children.length > 0 && alone == null) {
		for (var i = 0; i < children.length; i++) {
			buffer.add(children[i].toXML());
		}
	}
	buffer.add("</node>");
	return buffer.toString("\n");
};

jZoomableTreemapNode.prototype.setFolding = function(folded) {
	if (jMap.jDebug) console.log('setFolding');
};
jZoomableTreemapNode.prototype.hideChildren = function(node) {
	if (jMap.jDebug) console.log('hideChildren');
};
jZoomableTreemapNode.prototype.relativeCoordinate = function(dx, dy) {
	if (jMap.jDebug) console.log('relativeCoordinate');
};
jZoomableTreemapNode.prototype.relativeCoordinateExecute = function(dx, dy) {
	if (jMap.jDebug) console.log('relativeCoordinateExecute');
};

jZoomableTreemapNode.prototype.getLocation = function(){
	var popover = this.getPopoverLocation();
	return {x:popover.top, y: popover.left};
}

jZoomableTreemapNode.prototype.setFontSizeExecute = function(size) {
	//
};
jZoomableTreemapNode.prototype.setEdgeColorExecute = function(color, width){
	if (color) {
		this.edge.color = color;
		this.body.attr({stroke: color});
		this.folderShape && this.folderShape.attr({stroke: color});		
	}
	if (width) {
		// this.edge.width = width;
		// this.body.attr({"stroke-width": width});		
	}
}