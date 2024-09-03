/**
 * 
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */

if(jQuery) {
	jQuery.fn.onPositionChanged = function (trigger) {
		var o = $(this[0]); // our jquery object
		if (o.length < 1) return o;
	
		var lastPos = null;
		var lastOff = null;

		var step = function() {
			if (o == null || o.length < 1) return o; // abort if element is non existend eny more
			if (lastPos == null) lastPos = o.position();
			if (lastOff == null) lastOff = o.offset();
			var newPos = o.position();
			var newOff = o.offset();
			if (lastPos.top != newPos.top || lastPos.left != newPos.left) {
				$(this).trigger('onPositionChanged', { lastPos: lastPos, newPos: newPos });
				if (typeof (trigger) == "function") trigger(lastPos, newPos);
				lastPos = o.position();
			}
			if (lastOff.top != newOff.top || lastOff.left != newOff.left) {
				$(this).trigger('onOffsetChanged', { lastOff: lastOff, newOff: newOff});
				if (typeof (trigger) == "function") trigger(lastOff, newOff);
				lastOff= o.offset();
			}
			
			window.requestAnimationFrame(step);
		}
		window.requestAnimationFrame(step);

		return o;
	};
}

///////////////////////////////////////////////////////////////////////////////
//////////////////////////////// jRect ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

jRect = function(param){
	var parentNode = param.parent;
	var text = param.text;
	var id = param.id;
	var index = param.index;
	var position = param.position;
	
	jRect.superclass.call(this, parentNode, text, id, index, position);
}

extend(jRect, jMindMapNode);
jRect.prototype.type = "jRect";

/**
 * 필요한 Raphael Element를 만든다.
 */
jRect.prototype.initElements = function() {
	this.body = RAPHAEL.rect();		
	this.text = RAPHAEL.text();
	this.folderShape = RAPHAEL.circle(0, 0, FOLDER_RADIUS);
	
	// 그룹화하기 위해 반드시 불러야 한다. (인자 : 그룹화할 Element)
	this.wrapElements(this.body, this.text, this.folderShape);		
}

jRect.prototype.create = function(){
	// 노드와 노드를 잇는 선 생성
	var style = null;
	
	switch(jMap.layoutManager.type) {
		case "jMindMapLayout" :
			if(this.parent && !this.parent.isRootNode()) {
				style = this.parent.branch.style;
			}
			if(style == null || style == undefined) {
				style = "jLineBezier";
			}
			break;
		case "jTreeLayout" :
			style = "jLinePolygonal";
			break;
		case "jHTreeLayout" :
			style = "jLinePolygonal2";
			break;
		case "jTableLayout" :
			break;
		case "jFishboneLayout" :
			//this.connection = this.parent && new jLineBezier(this.parent, this);
			break;
		default :
			style = "jLineBezier";
			break;
	}
	
	this.connection = null;
	if(style != null && style != undefined) {
		var jsCode = "this.connection = this.parent && new " + style + "(this.parent, this)";
		eval (jsCode);
	}
	
//	this.connection = this.parent && jMap.layoutManager.connection(this.parent.body, this.body, "#000", this.isLeft());	
	/*
	this.connection = null;
	switch(jMap.layoutManager.type) {
		case "jMindMapLayout" :
			this.connection = this.parent && new jLineBezier(this.parent, this);
			break;
		case "jTreeLayout" :
			this.connection = this.parent && new jLinePolygonal(this.parent, this);
			break;
		case "jTableLayout" :
			break;
		case "jFishboneLayout" :
			//this.connection = this.parent && new jLineBezier(this.parent, this);
			break;
		default :
			this.connection = this.parent && new jLineBezier(this.parent, this);
			break;
	}
	*/
	
	///////////////////////////////////////////////////
	// 노드 초기화	 : 노드 색상, 폰트 설정 등등
	var body = this.body;
	var text = this.text;
	var folderShape = this.folderShape;
	
	// 노드 모서리 둥글게
	body.attr({r: NODE_CORNER_ROUND, rx: NODE_CORNER_ROUND, ry: NODE_CORNER_ROUND});
	
	// 초기 위치
	if(this.getParent()){
		var pl = this.getParent().getLocation();
		this.setLocation(pl.x, pl.y)
	}
	
	// 초기 색상 입히기..		
	this.setBackgroundColorExecute(jMap.cfg.nodeDefalutColor);
	this.setTextColorExecute(jMap.cfg.textDefalutColor);
	this.setEdgeColorExecute(jMap.cfg.edgeDefalutColor, jMap.cfg.edgeDefalutWidth);
	var branchWidth = jMap.cfg.branchDefalutWidth;
	if(this.getDepth()==1) branchWidth = 8;
	this.setBranchExecute(jMap.cfg.branchDefalutColor, branchWidth, null);
	
	// 노드에 색상 입히기
//	if(typeof NodeTheme !== 'undefined'){
//		NodeTheme.wear(this);
//	}
	if(typeof NodeColorMix !== 'undefined'){
		NodeColorMix.rawDressColor(this);
	}
	
	// 폰트 설정
	//var fontSize = this.fontSize;
	var fontWeight = 400;
	var fontFamily = 'Malgun Gothic, 맑은고딕, Gulim, 굴림, Arial, sans-serif';
//	var fontColor = '#000';
	if(!this.getParent()) {
		this.fontSize = jMap.cfg.nodeFontSizes[0];
		fontWeight = '700';
	} else if(this.getParent() && this.getParent().isRootNode()) {
		this.fontSize = jMap.cfg.nodeFontSizes[1];
		fontWeight = '700';
	} else {
		this.fontSize = jMap.cfg.nodeFontSizes[2];
		fontWeight = '400';	
	}
	
	if(this.isRootNode()) {
		text.attr({'font-family': fontFamily, 'font-size': this.fontSize, "font-weight": fontWeight});
		text.attr({'font': this.fontSize + "px " + fontFamily});
	} else {
		text.attr({'font-family': fontFamily, 'font-size': this.fontSize, "font-weight": fontWeight, 'text-anchor': 'start'});
		text.attr({'font': this.fontSize + "px " + fontFamily});
	}

	this.setTextExecute(this.plainText);
	///////////////////////////////////////////////////
}

// jRect.prototype.setTextExecute = function(text){
// 	this.plainText = text;
// 	this.text.attr({ text: text });	

// 	var maxWidth = 400;
// 	if(this.text.getBBox().width > maxWidth) {
// 		this.plainText = this.wrapText(text, maxWidth);
// 		this.text.attr({ text: this.plainText });
// 	}
	
// 	this.CalcBodySize();
// 	if(isNodeSelect && this.id == jMap.getSelected().id) {
// 		jMap.fireActionListener("action_NodeSelected", this);
// 	}
// }


jRect.prototype.getSize = function(){
	return {width:this.body.getBBox().width, height:this.body.getBBox().height};
}

jRect.prototype.setSize = function(width, height){
	this.body.attr({
		width: width,
		height: height
	});
}

jRect.prototype.getLayoutSize = function() {
	var size = this.getSize();
	
	// 편집, 추가 메뉴 크기 만큼 height를 늘려준다.
	// if(!this.isRootNode()) {
	// 	var selectedNodes = jMap.getSelecteds();
	// 	if(selectedNodes.indexOf(this) == 0) {
	// 		size.height += 50;
	// 	}
	// }
	
	return size;
}

/**
 * 노도의 좌표를 반환
 */
jRect.prototype.getLocation = function(){
	return {x:this.body.getBBox().x, y:this.body.getBBox().y};
}

jRect.prototype.setLocation = function(x, y){
	var body = this.body;
	
	// var layoutSize = this.getLayoutSize();
	// var size = this.getSize();
	
	// var dy = (layoutSize.height - size.height)/2;
	
	// if(x && !y){
	// 	body.attr({x: x, y : dy});
	// } else if(!x && y) {
	// 	body.attr({y: y + dy});
	// } else {
	// 	body.attr({x: x, y: y + dy});
	// }

	if(x && !y){
		body.attr({x: x});
	} else if(!x && y) {
		body.attr({y: y});
	} else {
		body.attr({x: x, y: y});
	}
	
	this.updateNodeShapesPos();
}

/**
 * 노드의 크기를 계산한다.
 */
jRect.prototype.CalcBodySize = function(){
	if(jMap.getNodeById(this.id) == undefined || this.text.getBBox() == undefined) return true;
	this.updateNodeShapesPos();
	
	var width = 0;
	var height = 0;
	var hGap = TEXT_HGAP;
	var vGap = TEXT_VGAP;
		
	// Text 계산
	// 노드에 텍스트가 없으면 노드의 크기를 정할수 없다.
	if (this.getText() != "") {
		width += this.text.getBBox().width;
		height += this.text.getBBox().height;
	}
//	var tempText = false;
//	if (this.getText() == "") {
//		this.text.attr({
//			text: "_"
//		});
//		var tempText = true;
//	}
//	width += this.text.getBBox().width;
//	height += this.text.getBBox().height;	
//	if (tempText) {
//		this.text.attr({
//			text: ""
//		});		
//	}
	// img 계산
	if (this.img) {		
		width = (width < this.img.getBBox().width) ? this.img.getBBox().width : width;
		height += this.img.getBBox().height;
	}
	// foreignObj 계산
	if (this.foreignObjEl) {
		var foWidth = parseInt(this.foreignObjEl.getAttribute("width"));
		var foHeight = parseInt(this.foreignObjEl.getAttribute("height"));
		width = (width < foWidth) ? foWidth : width;
		height += foHeight;
	}
	// hyperlink 계산
	if(this.hyperlink)
		width += this.hyperlink.getBBox().width + hGap/2 ;
	
	// file 계산
	if(this.file)
		width += this.file.getBBox().width + hGap/2 ;
	
	// note 계산
	if(this.note)
		width += this.note.getBBox().width + hGap/2 ;

	// 만약 노드에 아무런 컨텐츠가 없다면. 글자를 임의로 넣어 크기수정
	if(width == 0 || height == 0) {
		this.text.attr({
			text: "_"
		});
		width += this.text.getBBox().width;
		height += this.text.getBBox().height;	
		this.text.attr({
			text: ""
		});
	}
	
	if(width < parseInt(jMap.cfg.default_node_size)) {
		width = parseInt(jMap.cfg.default_node_size);
	}
	
	this.setSize(
		width + hGap,	// 넓이
		height + vGap	// 높이
	);
	
	this.updateNodeShapesPos();
}

/**
 * 노드가 갖고 있는 여러 도형들(body, text, folderShape...)의 위치를 재정렬 한다.
 */
jRect.prototype.updateNodeShapesPos = function(){
	if(jMap.getNodeById(this.id) == undefined) return true;

	var hGap = TEXT_HGAP;
	var vGap = TEXT_VGAP;
	var currentHeightPos = 0;	// 0에서 부터 요소들의 height따라 위치를 계산에 필요한 변수
	
	var body = this.body;
	var text = this.text;
	var folderShape = this.folderShape;
	var img = this.img;
	var hyperlink = this.hyperlink;
	var note = this.note;
	var file = this.file;
	var foreignObj = this.foreignObjEl;	
	var moodleIcon = this.moodleIcon;
	var score = this.score;

	// body의 x, y
	if(body.getBBox() == undefined) return true;
	var x = body.getBBox().x;
	var y = body.getBBox().y;
	
	// folder표시 위치
	var fold_x = 0
	var fold_y = 0;
	switch(jMap.layoutManager.type) {
		case "jMindMapLayout" :
			if(this.parent && !this.parent.isRootNode() && this.position != this.parent.position) {
				this.position = this.parent.position;
			}
			fold_x = this.isLeft()? x : x + body.getBBox().width;
			fold_y = y + body.getBBox().height / 2;
			break;
		case "jTreeLayout" :
			fold_x = x + body.getBBox().width / 2;
			fold_y = y + body.getBBox().height;
			break;
		case "jHTreeLayout" :
			fold_x = x + body.getBBox().width / 2;
			fold_y = y + body.getBBox().height;
			break;
		case "jFishboneLayout" :
			fold_x = this.isLeft()? x : x + body.getBBox().width;
			fold_y = y + body.getBBox().height / 2;
			break;
		default :
			fold_x = x;
			fold_y = y;
			break;
	}
	this.folderShape.attr({cx: fold_x, cy: fold_y});
	
	// img 위치
	if (img) {
		var img_x = x + hGap/2;
		var img_y = y + vGap/2;
		
		if(this.isRootNode()) {
			img_x += (body.getBBox().width / 2) - (img.getBBox().width / 2) - hGap / 2;
		}
		
		img.attr({x: img_x, y: img_y});
		currentHeightPos += img.getBBox().height;
	}
	// foreignObj
	if (foreignObj) {
		var ob_x = x + hGap/2;
		var ob_y = y + currentHeightPos + vGap/2;		
		currentHeightPos += parseInt(foreignObj.getAttribute("height"));
		foreignObj.setAttribute("x", ob_x);
		foreignObj.setAttribute("y", ob_y);
	}
	// 텍스트 위치
	if (text) {
		var text_x = x + hGap/2;
		var text_y = y + (vGap + text.getBBox().height) / 2; //this.body.getBBox().height / 2;
		if(this.isRootNode()) {
			text_x += body.getBBox().width / 2 - hGap / 2;
		}
		text_y += currentHeightPos;	
		text.attr({x: text_x, y: text_y});
	}
	
	
	// 첨부들 위치
	var attach_x = this.getLocation().x + this.getSize().width;
	if (note) {
		attach_x = attach_x - note.getBBox().width - 3;
		var note_y = this.getLocation().y + (this.getSize().height - note.getBBox().height) / 2;		
		note && note.attr({x: attach_x, y: note_y});
	}
	if (file) {
		attach_x = attach_x - file.getBBox().width - 3;
		var file_y = this.getLocation().y + (this.getSize().height - file.getBBox().height) / 2;		
		file && file.attr({x: attach_x, y: file_y});
	}
	if (hyperlink) {
		attach_x = attach_x - hyperlink.getBBox().width - 3;
		var hyper_y = this.getLocation().y + (this.getSize().height - hyperlink.getBBox().height) / 2;		
		hyperlink && hyperlink.attr({x: attach_x, y: hyper_y});
	}
	
	if (moodleIcon) {
		var moodleIcon_x = this.getLocation().x - 6;
		var moodleIcon_y = this.getLocation().y - 12;		
		moodleIcon && moodleIcon.attr({x: moodleIcon_x, y: moodleIcon_y});
	}
	
	if (score) {
		var c_y = this.getLocation().y + 10;
		c_y += this.getSize().height;	
		
		if(this.isLeft()){
			var c_x = this.getLocation().x ;
			score && score.attr({x: c_x - 20, y: c_y});
			score && this.procOne.attr({x: c_x, y: c_y - 5});
			score && this.procTwo.attr({x: c_x, y: c_y - 5});
		}else{
			var c_x = this.getLocation().x;
			score && score.attr({x: c_x + this.getSize().width + 20, y: c_y});
			score && this.procOne.attr({x: c_x , y: c_y - 5});
			score && this.procTwo.attr({x: c_x, y: c_y - 5});
		}
	}
	
//	this.connection && jMap.layoutManager.connection(this.connection, null, null, this.isLeft());
	this.connection && this.connection.updateLine();
}

jRect.prototype.getInputPort = function(){
	var body = this.body.getBBox();    
	
	var body_width = 0;
	var body_height = 0;
	if(isFinite(body.width) && !isNaN(body.width)){
		body_width = body.width;
	}
	if(isFinite(body.height) && !isNaN(body.height)){
		body_height = body.height;
	}
	
	switch(jMap.layoutManager.type) {
		case "jMindMapLayout" :
			if(this.isRootNode()) {
				return {x: body.x + body_width / 2, y: body.y + body_height / 2};
			}
			
			if (this.isLeft && this.isLeft()) {
				return {x: body.x + body_width + 1, y: body.y + body_height / 2};
			} else {
				return {x: body.x - 1, y: body.y + body_height / 2};
			}
			break;	// 의미없는 break
		case "jTreeLayout" :
			if(this.isRootNode()) return {x: body.x + body_width / 2, y: body.y + body_height};
			return {x: body.x + body_width / 2, y: body.y};
			break;	// 의미없는 break
		case "jHTreeLayout" :
			if(this.isRootNode()) return {x: body.x + body_width / 2, y: body.y + body_height};
			return {x: body.x, y: body.y + body_height / 2};
			break;	// 의미없는 break
		case "jRotateLayout" :
			if(this.isRootNode()) {
				return {x: body.x + body_width / 2, y: body.y + body_height / 2};
			}
			
			if (this.isLeft && this.isLeft()) {
				return {x: body.x - 1, y: body.y + body_height / 2};
			} else {
				return {x: body.x - 1, y: body.y + body_height / 2};
			}
			break;	// 의미없는 break
		case "jTableLayout" :
			if(this.isRootNode()) return {x: body.x + body_width / 2, y: body.y + body_height};
			return {x: body.x + body_width / 2, y: body.y};
			break;	// 의미없는 break
		case "jFishboneLayout" :
			if(this.isRootNode()) {
				return {x: body.x + body_width / 2, y: body.y + body_height / 2};
			}
			
			if (this.isLeft && this.isLeft()) {
				return {x: body.x + body_width + 1, y: body.y + body_height / 2};
			} else {
				return {x: body.x - 1, y: body.y + body_height / 2};
			}
			break;	// 의미없는 break
		default :
			return {x: body.x, y: body.y};
			break;	// 의미없는 break
	}
}

jRect.prototype.getOutputPort = function(){
	var body = this.body.getBBox();    
	
	var body_width = 0;
	var body_height = 0;
	if(isFinite(body.width) && !isNaN(body.width)){
		body_width = body.width;
	}
	if(isFinite(body.height) && !isNaN(body.height)){
		body_height = body.height;
	}
	
	switch(jMap.layoutManager.type) {
		case "jMindMapLayout" :
			if(this.isRootNode()) {
				return {x: body.x + body_width / 2, y: body.y + body_height / 2};
			}
			
			if (this.isLeft()) {
				return {x: body.x - 1, y: body.y + body_height / 2};
			} else {
				return {x: body.x + body_width + 1, y: body.y + body_height / 2};
			}
			break;	// 의미없는 break
		case "jTreeLayout" :
			return {x: body.x + body_width / 2, y: body.y + body_height};
			break;	// 의미없는 break
		case "jHTreeLayout" :
			return {x: body.x + body_width / 2, y: body.y + body_height};
			break;	// 의미없는 break
		case "jRotateLayout" :
			if(this.isRootNode()) {
				return {x: body.x + body_width / 2, y: body.y + body_height / 2};
			}
			
			if (this.isLeft && this.isLeft()) {
				return {x: body.x + body_width + 1, y: body.y + body_height / 2};
			} else {
				return {x: body.x + body_width + 1, y: body.y + body_height / 2};
			}
			break;	// 의미없는 break	
		case "jTableLayout" :
			return {x: body.x + body_width / 2, y: body.y + body_height};
			break;	// 의미없는 break
		case "jFishboneLayout" :
			if(this.isRootNode()) {
				return {x: body.x + body_width / 2, y: body.y + body_height / 2};
			}
			
			if (this.isLeft()) {
				return {x: body.x - 1, y: body.y + body_height / 2};
			} else {
				return {x: body.x + body_width + 1, y: body.y + body_height / 2};
			}
			break;	// 의미없는 break
		default :
			return {x: body.x, y: body.y};
			break;	// 의미없는 break
	}
}

jRect.prototype.toString = function () {
    return "jRect";
}

// render it outside with html tags
jRect.prototype.setForeignObjectExecute = function (html, width, height) {
	if(!Raphael.svg) return false;

	if (html == null || html == "") {
		if(this.foreignObjEl && this.foreignObjEl.iframeEl) {
			this.foreignObjEl.iframeEl.remove();
			delete this.foreignObjEl.iframeEl;
		}

		if(this.foreignObjEl) this.groupEl.removeChild(this.foreignObjEl);
		this.foreignObjEl = null;
		this.CalcBodySize();
		
		return false;
	}
	
	html = convertXML2Char(html);
	
	if(!this.foreignObjEl) {
		var d = document;
		this.foreignObjEl = d.createElementNS("http://www.w3.org/2000/svg", "foreignObject");
		this.foreignObjEl.bodyEl = d.createElementNS("http://www.w3.org/1999/xhtml", "body");
		//this.bodyEl.setAttribute("xmlns", "http://www.w3.org/1999/xhtml");
		this.foreignObjEl.appendChild(this.foreignObjEl.bodyEl);
		this.groupEl.appendChild(this.foreignObjEl);
		
		this.foreignObjEl.setAttribute("x", this.body.getBBox().x);
		this.foreignObjEl.setAttribute("y", this.body.getBBox().y);
	}	
	
	width = width || 150;
	height = height || 150;
	this.foreignObjEl.setAttribute("width", width);
	this.foreignObjEl.setAttribute("height", height);
	
	// 사용자가 정의한 html은 저장이나 다른 곳에서 사용해야 하는데
	// innerHTML에 html 코드를 넣으면 몇몇 정보가 바뀌어 버리는것이 있다. (태그를 삭제한다든가 하는..)
	// 그래서 plainHtml에 순수한 html 문자열을 갖고 있는다.

	// issue fix - youtube iframe not show in android 4.4 && ios safari
	// if(AppUtil.getBrowserIsIE() || true){
		var hasIframe = (html || "").indexOf('<iframe') >= 0;

		if(this.foreignObjEl.iframeEl) {
			if(hasIframe) {
				this.foreignObjEl.bodyEl.innerHTML = "";
				this.foreignObjEl.iframeEl = $('<div class="jRect-foreignObjEl jRect-'+this.id+'" style="position: absolute;z-index: 0;outline: none; margin-left: 5px; margin-top: 5px; transform-origin: top left;"></div>').appendTo('body');
			}else{
				this.foreignObjEl.iframeEl.remove();
				delete this.foreignObjEl.iframeEl;
			}
		} 
		//csedung fix error in display
//		else if(hasIframe){
//			this.foreignObjEl.bodyEl.innerHTML = "";
//			this.foreignObjEl.iframeEl = $('<div class="jRect-foreignObjEl jRect-'+this.id+'" style="position: absolute;z-index: 0;outline: none; margin-left: 5px; margin-top: 5px; transform-origin: top left;"></div>').appendTo('body');
//		}

		var node = this;
		var hasImage = false;
		
		var setPosition = function() {
			if(!node.foreignObjEl || !node.foreignObjEl.iframeEl) return true;
			var offset = $(node.body.node).offset();
			var offsetYGap = 0;
			if(node.img != null) {
				offsetYGap = jMap.cfg.scale * node.img.getBBox().height;
			}
			var iframeEl = node.foreignObjEl.iframeEl;
			$(iframeEl).css("top", offset.top + offsetYGap);
			$(iframeEl).css("left", offset.left);
			$(iframeEl).css("margin-left", 5 * jMap.cfg.scale);
			$(iframeEl).css("margin-top", 5 * jMap.cfg.scale);
			$(iframeEl).css("transform", 'scale('+jMap.cfg.scale+')');
			$(iframeEl).css("-webkit-transform", 'scale('+jMap.cfg.scale+')');
			$(iframeEl).css("-ms-transform", 'scale('+jMap.cfg.scale+')');
			$(iframeEl).css("-moz-transform", 'scale('+jMap.cfg.scale+')');
		};

		if(hasIframe) {
			var iframeEl = this.foreignObjEl.iframeEl;
			$(iframeEl).html(html);
			$(iframeEl).css("width", width);
			$(iframeEl).css("height", height);

			setTimeout(function(){ setPosition(); });
			$(window).on("load", setPosition);
			$(this.groupEl).onPositionChanged(setPosition);
		} else {
			this.foreignObjEl.bodyEl.innerHTML = html;
		}
	// }else{
	// 	this.foreignObjEl.bodyEl.innerHTML = html;
	// }
	this.foreignObjEl.bodyEl.innerHTML = html;
	
	this.foreignObjEl.plainHtml = html;
	
	// 몇몇 브라우저에서는 유투브 동영상이 지원하지 않아서 그림을 대처하는데,
	// 그 방법으로 html 내용에 youtube.com있으면 유투브 동영상이라 판단하고 처리한다.
	// 문자열에 youtube.com이 있을수도 있기 떄문에 다음과 같이 처리하는것은 좋지 않다.
	if(/*BrowserDetect.browser == "Firefox" || */BrowserDetect.browser == "MSIE"){
		
		var pos = html.search (/youtube\.com/);
		if(pos != -1) {
//			var re = /embed src="([^"]*)"/g;
//			var match = re.exec(html);
//			if (match) {
//				console.log(match[1]);				
//			}			
			this.foreignObjEl.bodyEl.innerHTML = '<img src="'+jMap.cfg.contextPath+'/images/video_not_support.png" width="300" height="300"/>';			
		}				
	}
	this.CalcBodySize();
	
	//this.fix_flash(this.foreignObjEl.bodyEl);
}

jRect.prototype.foreignObjectResizeExecute = function(width, height){
	// csedung add 2020.08.04 to keep video api live;
	if(!this.foreignObjEl) return;
	// end fix 2020.08.04
	
	width && this.foreignObjEl.setAttribute("width", width);
	height && this.foreignObjEl.setAttribute("height", height);
	
	var html = this.foreignObjEl.plainHtml;
	html = html.replace(/(width=")([^"]*)/ig, "$1"+width);
	html = html.replace(/(height=")([^"]*)/ig, "$1"+height);
	
	if(this.foreignObjEl.iframeEl) {
		var iframeEl = this.foreignObjEl.iframeEl;
		$(iframeEl).html(html);
		$(iframeEl).css("width", width);
		$(iframeEl).css("height", height);
	} else {
		this.foreignObjEl.bodyEl.innerHTML = html;
	}
	
	this.foreignObjEl.plainHtml = html;
	this.CalcBodySize();
	jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(this);
	jMap.layoutManager.layout(true);
}

jRect.prototype.removeExecute = function(force){
	if (this.removed) return false;
	if (!force && this.isRootNode()) return false;	
	if(!this.getChildren().isEmpty()){		
		var children = this.getChildren();
		var length = children.length-1
		for(var i = length; i >= 0; i--) {			
			children[i].removeExecute();
		}
	}	

	if(this.foreignObjEl && this.foreignObjEl.iframeEl) {
		this.foreignObjEl.iframeEl.remove();
	}

	jMap.deleteNodeById(this.id);
//	this.connection && this.connection.line.remove();		// 화면의 라인삭제
	this.connection && this.connection.remove();			// 화면의 라인삭제
	
	// arrowlink
	// this가 가르키는 arrowlink
	while(this.arrowlinks.length != 0){
		this.removeArrowLink(this.arrowlinks[0]);
	}
	// this를 가르키는 arrowlink
	var alinks = jMap.getArrowLinks(this);
	var alinksLength = alinks.length;
	for(var i = 0; i < alinksLength; i++) {
		this.removeArrowLink(alinks[i]);
	}
	
//	this.body.remove();						// 화면에 노드 삭제 (body)
//	this.text.remove();						// 화면에 노드 삭제 (text)
//	this.folderShape.remove();				// 화면에 노드 삭제 (folderShape)
	
	for( e in this){
		if(this[e] && this[e].toString){
			if(this[e].toString() == "Rapha\xebl\u2019s object")
				this[e].remove();
		}		
	}
	
	this.groupEl.parentNode.removeChild(this.groupEl);	// group DOMElement 삭제
	this.parent && this.parent.getChildren().remove(this);	// 모델에서 삭제
	this.removed = true;
	
	// lazyloading에 필요한 변수 numofchildren 업데이트
	this.parent.numofchildren = this.parent.getChildren().length;
	
	return true;
}

// IOT // 

jRect.prototype.setDHTEmitter = function(attr) {
	if(jMap.cfg.realtimeSave) {
		var isAlive = jMap.saveAction.isAlive();	
		if(!isAlive) return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	var node = this;
	node.attributes['iot'] = encodeURI(JSON.stringify(attr));
	this.setDHTEmitterExecute(attr);
	
	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);

	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_ATTRS, this);
	jMap.setSaved(false);
}

jRect.prototype.setDHTEmitterExecute = function(attr){
	var id = attr.id;
	var node = this;
	var width = 200;
	var height = 80;
	var t = 0;
	var h = 0;
	var setWidget = function(_t, _h, status){
		if(!jMap.getNodeById(node.id) || jMap.getNodeById(node.id).attributes.iot == undefined) {
			mindmapIO.removeListener(id);
			return true;
		}
		t = _t;
		h = _h;
		var temp = '<svg style="width: 200px; background-color: white;" id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 80"><path d="M22.84,61.26a3,3,0,1,1-3-2.92A3,3,0,0,1,22.84,61.26Zm1.52-3.86a5.71,5.71,0,0,1,1.52,3.86,6,6,0,0,1-6.08,5.85h0a6,6,0,0,1-6-5.88,5.68,5.68,0,0,1,1.51-3.83V48.1a4.56,4.56,0,0,1,9.12,0Zm-.76,3.86a4.2,4.2,0,0,0-1.52-3V48.1a2.28,2.28,0,0,0-4.56,0V58.22a4.23,4.23,0,0,0-1.52,3,3.75,3.75,0,0,0,3.77,3.68h0A3.73,3.73,0,0,0,23.6,61.26Z" fill="#727374"/><circle cx="9.19" cy="6.57" r="3.98" fill="'+(status ? '#6EC5A4':'#F26D6D')+'"/><text transform="translate(31.19 67.11)" font-size="40" fill="#333" font-family="ArialMT, Arial">'+t+'</text><text transform="translate(75.68 51.12) scale(0.58)" font-size="30" fill="#333" font-family="ArialMT, Arial">°C</text><text transform="translate(20.62 25.39)" font-size="11" fill="#727373" font-family="ArialMT, Arial"><tspan x="5.5" y="0">Temperature</tspan></text><text transform="translate(15.53 9.55)" font-size="8" fill="'+(status ? '#6EC5A4':'#F26D6D')+'" font-family="ArialMT, Arial">'+(status ? 'Online':'Offline')+'</text><text transform="translate(131.26 66.77)" font-size="40" fill="#333" font-family="ArialMT, Arial">'+h+'</text><text transform="translate(175.75 50.78) scale(0.58)" font-size="30" fill="#333" font-family="ArialMT, Arial">%</text><text transform="translate(130.18 25.05)" font-size="11" fill="#727373" font-family="ArialMT, Arial">Humidity</text><path d="M127.37,55.26c0-2.1-3-5.6-3.65-6.28a.8.8,0,0,0-1.12,0l0,0a25.81,25.81,0,0,0-2.85,3.88c-.49-.61-.88-1-1-1.19a.78.78,0,0,0-1.11,0l0,0a39.14,39.14,0,0,0-2.91,3.75c-.35-.6-.69-1.1-.88-1.37a.76.76,0,0,0-1.06-.19.73.73,0,0,0-.2.19c-.46.7-2,3.07-2,4.28A2.69,2.69,0,0,0,112.91,61a5.37,5.37,0,0,0,10.62-1.16,2.53,2.53,0,0,0,0-.38A4.22,4.22,0,0,0,127.37,55.26Zm-14.21,4.22A1.15,1.15,0,0,1,112,58.33a8,8,0,0,1,1.15-2.43,7.85,7.85,0,0,1,1.16,2.43A1.15,1.15,0,0,1,113.16,59.48Zm5,4.22a3.86,3.86,0,0,1-3.74-3,2.68,2.68,0,0,0,1.44-2.38,3.6,3.6,0,0,0-.32-1.25,1.16,1.16,0,0,1,.2-.47,34.66,34.66,0,0,1,2.42-3.25c1.69,2,3.84,5,3.84,6.5A3.84,3.84,0,0,1,118.15,63.7Zm5-5.75h-.1a19.19,19.19,0,0,0-2.27-3.76.75.75,0,0,1,.06-.13,19.42,19.42,0,0,1,2.31-3.38c1.25,1.54,2.68,3.62,2.68,4.58A2.69,2.69,0,0,1,123.15,58Z" fill="#727374"/><path d="M125.13,54.38l0-.05-.2-.41a.39.39,0,0,0-.53-.12.37.37,0,0,0-.14.49c.06.12.12.24.17.36a.38.38,0,0,0,.5.22A.37.37,0,0,0,125.13,54.38Z" fill="#727374"/><path d="M124.42,53.12c-.32-.47-.66-.9-.89-1.18a.38.38,0,0,0-.53-.08.4.4,0,0,0-.09.54l0,0c.22.27.54.68.84,1.12a.38.38,0,0,0,.53.11A.4.4,0,0,0,124.42,53.12Z" fill="#727374"/><path d="M119.29,62.33a.39.39,0,0,0-.48-.26,2.07,2.07,0,0,1-.66.1.38.38,0,0,0-.38.38.39.39,0,0,0,.38.39,3.23,3.23,0,0,0,.88-.13A.38.38,0,0,0,119.29,62.33Z" fill="#727374"/><path d="M121.11,59a.38.38,0,1,0-.73.22,2.32,2.32,0,0,1-.56,2.27.38.38,0,0,0,0,.54.36.36,0,0,0,.25.11.38.38,0,0,0,.28-.12A3.06,3.06,0,0,0,121.11,59Z" fill="#727374"/></svg>';
		node.setForeignObjectExecute(temp, width, height);
	};

	if (id == null || id == "") {
		node.setForeignObjectExecute(null);
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
		jMap.layoutManager.layout(true);
	} else {
		var status = false;
		if(mindmapIO) {
			status = mindmapIO.connected;
			mindmapIO.on(id, function(msg) {
				setWidget(msg.t, msg.h, true);
			});
			mindmapIO.on('disconnect', function(){
				setWidget(t, h, false);
			});
		}
		setWidget(t, h, status);
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
		jMap.layoutManager.layout(true);
	}
}

jRect.prototype.setCameraEmitter = function(attr) {
	if(jMap.cfg.realtimeSave) {
		var isAlive = jMap.saveAction.isAlive();	
		if(!isAlive) return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	var node = this;
	node.attributes['iot'] = encodeURI(JSON.stringify(attr));
	this.setCameraEmitterExecute(attr);
	
	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);

	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_ATTRS, this);
	jMap.setSaved(false);
}

jRect.prototype.setCameraEmitterExecute = function(attr){
	var node = this;
	var width = 320;
	var height = 240;
	var html = '<iframe src="'+attr.url+'" frameborder="0" allowtransparency="true" width="'+width+'"  height="'+height+'" scrolling="no"></iframe>';
	node.setHyperlink(attr.url);
	node.setForeignObject(html, width, height);	
	jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
	jMap.layoutManager.layout(true);
}


//IoT set listeners
jRect.prototype.setSwitchListener = function(attr) {
	if(jMap.cfg.realtimeSave) {
		var isAlive = jMap.saveAction.isAlive();	
		if(!isAlive) return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	var node = this;
	node.attributes['iot'] = encodeURI(JSON.stringify(attr));
	this.setSwitchListenerExecute(attr, null);
	
	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);

	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_ATTRS, this);
	jMap.setSaved(false);
}

jRect.prototype.setSwitchListenerExecute = function(attr, status, id){
	id = id || attr.id;
	var node = this;
	var width = 100;
	var height = 80;
	var setWidget = function(value){
		var tempOff = '<svg onclick="jMap.getSelected().setSwitchListenerExecute(null, true, \''+id+'\')" style="width: 100px;" id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 80"><title>switch-off</title><path d="M69.83,18.31H30.17a23.44,23.44,0,0,0,0,46.88H69.83a23.44,23.44,0,0,0,0-46.88Z" fill="#cfd8dc"/><circle cx="30.6" cy="41.75" r="15.88" fill="#ef4438"/><path d="M55.29,50.57A5.29,5.29,0,0,1,50,45.28V38.22a5.29,5.29,0,0,1,10.58,0v7.06A5.29,5.29,0,0,1,55.29,50.57Zm0-14.11a1.76,1.76,0,0,0-1.76,1.76v7.06a1.77,1.77,0,0,0,3.53,0V38.22A1.76,1.76,0,0,0,55.29,36.46Z" fill="#455b64"/><path d="M65.88,50.57a1.77,1.77,0,0,1-1.77-1.77V34.69a1.76,1.76,0,0,1,1.77-1.76h5.29a1.77,1.77,0,0,1,0,3.53H67.64V48.81A1.76,1.76,0,0,1,65.88,50.57Z" fill="#455b64"/><path d="M69.4,43.51H65.88a1.77,1.77,0,1,1,0-3.53H69.4a1.77,1.77,0,1,1,0,3.53Z" fill="#455b64"/><path d="M76.46,50.57A1.76,1.76,0,0,1,74.7,48.8V34.69a1.76,1.76,0,0,1,1.76-1.76h5.29a1.77,1.77,0,1,1,0,3.53H78.22V48.81A1.76,1.76,0,0,1,76.46,50.57Z" fill="#455b64"/><path d="M80,43.51H76.46a1.77,1.77,0,0,1,0-3.53H80a1.77,1.77,0,0,1,0,3.53Z" fill="#455b64"/></svg>';
		var tempOn = '<svg onclick="jMap.getSelected().setSwitchListenerExecute(null, false, \''+id+'\')" style="width: 100px;" id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 80"><title>switch-on</title><path d="M69.83,18.31H30.17a23.44,23.44,0,0,0,0,46.88H69.83a23.44,23.44,0,0,0,0-46.88Z" fill="#cfd8dc"/><circle cx="69.83" cy="41.75" r="16.23" fill="#4daf4e"/><path d="M26.56,50.76a5.41,5.41,0,0,1-5.41-5.41V38.14a5.41,5.41,0,0,1,10.82,0v7.21A5.41,5.41,0,0,1,26.56,50.76Zm0-14.42a1.81,1.81,0,0,0-1.8,1.8v7.21a1.8,1.8,0,1,0,3.6,0V38.14A1.8,1.8,0,0,0,26.56,36.34Z" fill="#455b64"/><path d="M44.59,50.76a1.79,1.79,0,0,1-1.61-1l-3.8-7.6V49a1.8,1.8,0,1,1-3.6,0V34.54A1.81,1.81,0,0,1,37,32.78a1.79,1.79,0,0,1,2,.95l3.8,7.59V34.54a1.8,1.8,0,1,1,3.6,0V49A1.79,1.79,0,0,1,45,50.71,1.51,1.51,0,0,1,44.59,50.76Z" fill="#455b64"/></svg>';
		node.setForeignObjectExecute(value == true ? tempOn : tempOff, width, height);
	};

	var saveStatus = function(v){
		var n = jMap.getNodeById(node.id);
		if(n && n.attributes.iot) {
			var _attr = JSON.parse(decodeURI(n.attributes.iot));
			_attr.status = v;
			n.attributes.iot = encodeURI(JSON.stringify(_attr));
			parent.jMap.saveAction.editAction(n);
			parent.jMap.setSaved(false);
		}
	};

	if (id == null || id == "") {
		node.setForeignObjectExecute(null);
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
		jMap.layoutManager.layout(true);
	} else {
		switch (status) {
			case true:
				setWidget(true);
				$.get(jMap.cfg.contextPath + '/iot/ctrl.do', { id: id, params: encodeURI(JSON.stringify(1)) }, function(res){ saveStatus(true); });
				break;
			case false:
				setWidget(false);
				$.get(jMap.cfg.contextPath + '/iot/ctrl.do', { id: id, params: encodeURI(JSON.stringify(0)) }, function(res){ saveStatus(false); });
				break;
			default:
				if(mindmapIO) {
					mindmapIO.on(id, function(msg) {
						if(!jMap.getNodeById(node.id) || jMap.getNodeById(node.id).attributes.iot == undefined) {
							mindmapIO.removeListener(id);
							return true;
						}else {
							setWidget(msg == 1);
						}
					});
				}
				setWidget(attr.status);
				jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
				jMap.layoutManager.layout(true);
				break;
		}
	}
}
