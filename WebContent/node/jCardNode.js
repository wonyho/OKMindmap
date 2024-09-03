/**
 *
 * @author Nguyen Van Hoang (nvhoangag@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com)
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */
///////////////////////////////////////////////////////////////////////////////
///////////////////    jCardNodeController    //////////////////////
///////////////////////////////////////////////////////////////////////////////
jCardNodeController = function() {
	jCardNodeController.superclass.call(this);
};
extend(jCardNodeController, jNodeController);

jCardNodeController.prototype.type = "jCardNodeController";

jCardNodeController.prototype.dblclick = function(e) {
	var targ;
	var originalEvent;
	if (!e) var e = window.event;
	originalEvent = e.originalEvent.originalEvent || e.originalEvent || e;
	if (originalEvent.target) targ = originalEvent.target;
	else if (originalEvent.srcElement) targ = originalEvent.srcElement;
	if (targ.nodeType == 3) // defeat Safari bug
		targ = targ.parentNode;
	
	if (originalEvent.preventDefault)
		originalEvent.preventDefault();
	else
		originalEvent.returnValue= false;
	
	// if(!(ISMOBILE || supportsTouch)){
		jMap.controller.startNodeEdit(jMap.getSelected());
	// }
};


jCardNodeController.prototype.mouseenter = function(e) {};
jCardNodeController.prototype.mouseleave = function(e) {};
jCardNodeController.prototype.mouseup = function(e) {};
jCardNodeController.prototype.mousedown = function(e) {
	var targ;
	var originalEvent;
	if (!e) var e = window.event;
	originalEvent = e.originalEvent.originalEvent || e.originalEvent || e;
	if (originalEvent.target) targ = originalEvent.target;
	else if (originalEvent.srcElement) targ = originalEvent.srcElement;
	if (targ.nodeType == 3) // defeat Safari bug
		targ = targ.parentNode;
	
	if (originalEvent.preventDefault)
		originalEvent.preventDefault();
	else
		originalEvent.returnValue= false;
	
	var selectedNodes = jMap.getSelecteds();
	
	// 마우스 오른쪽 버튼
	// IE : e.button == 2
	// FF : e.button == 2, e.which == 3
	// Mac : e.button == 2, e.which == 3
	if(e.button == 2) {
		// jMap.mouseRightClicked = true;
		// jMap.mouseRightSelectedNode = this.node;
		return; //KHANG prevent moving by right click
	}
	
	// 노드 하일라이팅
	if (e.shiftKey || e.ctrlKey) { //ctrlKey
		if(selectedNodes.contains(this.node))
			this.node.blur();
		else this.node.focus(false);	// control키 조합시 중복 선택
	} 
	else{
		if(!selectedNodes.contains(this.node)) {
			this.node.focus(true);
			// changeNodeGifFormat(this.node, true);
		}
	}

	var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
    var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
    this._drag = {};
    this._drag.x = e.clientX + scrollX;
    this._drag.y = e.clientY + scrollY;
    this._drag.id = e.identifier;
    jMap.dragEl = this;
};
jCardNodeController.prototype.mousemove = function(e) {};
jCardNodeController.prototype.mouseover = function(e){};
jCardNodeController.prototype.mouseout = function(e){};
jCardNodeController.prototype.dragstart = function(e){};
jCardNodeController.prototype.dragenter = function(e){};
jCardNodeController.prototype.dragexit = function(e){};
jCardNodeController.prototype.drop = function(e){};

///////////////////////////////////////////////////////////////////////////////
////////////////// jCardNodeControllerGuest    /////////////////////
///////////////////////////////////////////////////////////////////////////////
jCardNodeControllerGuest = function() {
	jCardNodeControllerGuest.superclass.call(this);
};
extend(jCardNodeControllerGuest, jNodeControllerGuest);

jCardNodeControllerGuest.prototype.type = "jCardNodeControllerGuest";

jCardNodeControllerGuest.prototype.mouseenter = function(e) {
};

jCardNodeControllerGuest.prototype.mouseleave = function(e) {
};


/**
 * 
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */

///////////////////////////////////////////////////////////////////////////////
//////////////////////////////// jCardNode ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

jCardNode = function(param){
	var parentNode = param.parent;
	var text = param.text;
	var id = param.id;
	var index = param.index;
	var position = param.position;
	
	// 작성자 사진
	this.portrait = null;
	// 작성자 이름
	this.nodeCreator = null;
	//  작성일
	this.nodeCreated = null;
	
	this.portraitRadius = 12;
	
	jCardNode.superclass.call(this, parentNode, text, id, index, position);
}

extend(jCardNode, jMindMapNode);
jCardNode.prototype.type = "jCardNode";

/**
 * 필요한 Raphael Element를 만든다.
 */
jCardNode.prototype.initElements = function() {
	if(this.isRootNode() && jMap.layoutManager.topic == null) {
		jMap.layoutManager.topic = new jCardTopic();
	}

	this.body = RAPHAEL.rect();		
	this.text = RAPHAEL.text();
	this.folderShape = RAPHAEL.circle(0, 0, FOLDER_RADIUS);
	
	this.nodeCreator = RAPHAEL.text();
	this.nodeCreated = RAPHAEL.text();
	
	// 그룹화하기 위해 반드시 불러야 한다. (인자 : 그룹화할 Element)
	this.wrapElements(this.body, this.text, this.folderShape, this.nodeCreator, this.nodeCreated);		
}

jCardNode.prototype.create = function(){
	///////////////////////////////////////////////////
	// 노드 초기화	 : 노드 색상, 폰트 설정 등등
	var body = this.body;
	var text = this.text;
	var folderShape = this.folderShape;
	
	// 초기 위치
	if(this.getParent()){
		var pl = this.getParent().getLocation();
		this.setLocation(pl.x, pl.y)
	}
	
	// 초기 색상 입히기..		
	this.setBackgroundColorExecute(jMap.cfg.nodeDefalutColor);
	this.setTextColorExecute(jMap.cfg.textDefalutColor);
	this.setEdgeColorExecute(jMap.cfg.edgeDefalutColor, 1);
	
	// 노드에 색상 입히기
//	if(typeof NodeTheme !== 'undefined'){
//		NodeTheme.wear(this);
//	}
	if(typeof NodeColorMix !== 'undefined'){
		NodeColorMix.rawDressColor(this);
	}
	
	// 폰트 설정
	var fontWeight = 400;
	var fontFamily = 'Malgun Gothic, 맑은고딕, Gulim, 굴림, Arial, sans-serif';
	this.fontSize = jMap.cfg.nodeFontSizes[2];
	
	text.attr({'font-family': fontFamily, 'font-size': this.fontSize, "font-weight": fontWeight, 'text-anchor': 'start'});
	
	this.nodeCreator.attr({'font-family': fontFamily, 'font-size': this.fontSize, "font-weight": fontWeight, 'text-anchor': 'start'});
	this.nodeCreated.attr({'font-family': fontFamily, 'font-size': this.fontSize, "font-weight": fontWeight, 'text-anchor': 'start'});

	this.setTextExecute(this.plainText);
	///////////////////////////////////////////////////
	
	this.setCreator(jMap.cfg.portrait, jMap.cfg.userName, 0);
}

jCardNode.prototype.setEdgeColorExecute = function(color, width){
	if (color) {
		this.edge.color = color;
		this.body.attr({stroke: color});
		this.folderShape && this.folderShape.attr({stroke: color});		
	}
	
	// 테두리 두께는 무조건 1로 한다.
	this.edge.width = 1;
	this.body.attr({"stroke-width": 1});
}

jCardNode.prototype.getSize = function(){
	return {width:this.body.getBBox().width, height:this.body.getBBox().height};
}

jCardNode.prototype.setSize = function(width, height){
	this.body.attr({
		width: width,
		height: height
	});
}

jCardNode.prototype.getLayoutSize = function() {
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
jCardNode.prototype.getLocation = function(){
	return {x:this.body.getBBox().x, y:this.body.getBBox().y};
}

jCardNode.prototype.setLocation = function(x, y){
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
	
	// this.updateNodeShapesPos();

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
jCardNode.prototype.CalcBodySize = function(){
	if(this.text.getBBox() == undefined) return;

	this.updateNodeShapesPos();
	
	var width = 0;
	var height = 0;
	var hGap = TEXT_HGAP;
	var vGap = TEXT_VGAP;
	
	// 작성자
	if (this.portrait) {
		height += 40;
	}
		
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
	
	// hyperlink 계산
	if(this.hyperlink) {
		var aa = this.body.getBBox().y + height;
		var bb = this.hyperlink.getBBox().y + this.hyperlink.getBBox().height;
		
		if(aa < bb) {
			height = this.hyperlink.getBBox().y + this.hyperlink.getBBox().height - this.body.getBBox().y;
		}
	}
		
	
	// file 계산
	if(this.file) {
		var aa = this.body.getBBox().y + height;
		var bb = this.file.getBBox().y + this.file.getBBox().height;
		
		if(aa < bb) {
			height = this.file.getBBox().y + this.file.getBBox().height - this.body.getBBox().y;
		}
	}
	
	// note 계산
	if(this.note) {
		var aa = this.body.getBBox().y + height;
		var bb = this.note.getBBox().y + this.note.getBBox().height;
		
		if(aa < bb) {
			height = this.note.getBBox().y + this.note.getBBox().height - this.body.getBBox().y;
		}
	}
	
	this.setSize(
		jMap.layoutManager.columnWidth,	// 넓이
		height + vGap	// 높이
	);
	
	//this.updateNodeShapesPos();
}

/**
 * 노드가 갖고 있는 여러 도형들(body, text, folderShape...)의 위치를 재정렬 한다.
 */
jCardNode.prototype.updateNodeShapesPos = function(){
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
	// body의 x, y
	var x = body.getBBox().x;
	var y = body.getBBox().y;
	
	// folder표시 위치
	var fold_x = 0
	var fold_y = 0;
	switch(jMap.layoutManager.type) {
		case "jMindMapLayout" :
			fold_x = this.isLeft()? x : x + this.body.getBBox().width;
			fold_y = y + this.body.getBBox().height / 2;
			break;
		case "jTreeLayout" :
			fold_x = x + this.body.getBBox().width / 2;
			fold_y = y + this.body.getBBox().height;
			break;
		case "jHTreeLayout" :
			fold_x = x + this.body.getBBox().width / 2;
			fold_y = y + this.body.getBBox().height;
			break;
		case "jFishboneLayout" :
			fold_x = this.isLeft()? x : x + this.body.getBBox().width;
			fold_y = y + this.body.getBBox().height / 2;
			break;
		default :
			fold_x = x;
			fold_y = y;
			break;
	}
	this.folderShape.attr({cx: fold_x, cy: fold_y});
	
	// 작성자 사진 위치
	if (this.portrait) {
		this.portrait.attr({cx: x + this.portraitRadius + hGap/2, cy: y + this.portraitRadius + vGap/2});
		
		// 작성자 이름 위치
		if (this.nodeCreator) {
			this.nodeCreator.attr({
				x: this.portrait.getBBox().x + this.portrait.getBBox().width + hGap, 
				y: y + this.portraitRadius + (this.portraitRadius * 2 - this.nodeCreator.getBBox().height) / 2
			});
		}
		
		// 작성일 위치
		if (this.nodeCreated) {
			this.nodeCreated.attr({
				x: this.nodeCreator.getBBox().x + this.nodeCreator.getBBox().width + hGap, 
				y: y + this.portraitRadius + (this.portraitRadius * 2 - this.nodeCreated.getBBox().height) / 2
			});
		}
		
		currentHeightPos += this.portraitRadius * 2 + vGap;
	}
	
	// img 위치
	if (img) {
		var img_x = x + 1;
		var img_y = y + currentHeightPos + 1;
		
		if(this.isRootNode()) {
			img_x += (body.getBBox().width / 2) - (img.getBBox().width / 2) - hGap / 2;
		}
		
		img.attr({x: img_x, y: img_y});
		currentHeightPos += parseInt(img.getBBox().height);
	}
	// foreignObj
	if (foreignObj) {
		var ob_x = x + 1;
		var ob_y = y + currentHeightPos + 1;		
		
		foreignObj.setAttribute("x", ob_x);
		foreignObj.setAttribute("y", ob_y);
		
		currentHeightPos += parseInt(foreignObj.getAttribute("height"));
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
	//var indexOfLastLine = text.node.childNodes.length - 1;
	//var textOfLastLine = $(text.node.childNodes[indexOfLastLine])[0].textContent;
	//var sizeOfLastText = this.renderedTextSize(textOfLastLine);
	var attach_y = y + currentHeightPos + text.getBBox().height + 10;// - sizeOfLastText.height;
	
	var attach_x = x + hGap/2;//text.getBBox().x + sizeOfLastText.width + 5;

	if (hyperlink) {
		if((attach_x + hyperlink.getBBox().width) > x + (body.getBBox().width)) {
			attach_x = text.getBBox().x;
			attach_y += parseFloat(text.node.childNodes[indexOfLastLine].getAttribute("dy")) + 5;
		}
		hyperlink && hyperlink.attr({x: attach_x, y: attach_y + 6});
		attach_x = attach_x + hyperlink.getBBox().width + 3;
	}

	if (file) {
		if((attach_x + file.getBBox().width) > x + (body.getBBox().width)) {
			attach_x = text.getBBox().x;
			attach_y += parseFloat(text.node.childNodes[indexOfLastLine].getAttribute("dy")) + 5;
		}
		file && file.attr({x: attach_x, y: attach_y});
		attach_x = attach_x + file.getBBox().width + 3;
	}
	
	if (note) {
		if((attach_x + note.getBBox().width) > x + (body.getBBox().width)) {
			attach_x = text.getBBox().x;
			attach_y += parseFloat(text.node.childNodes[indexOfLastLine].getAttribute("dy")) + 5;
		}
		note && note.attr({x: attach_x, y: attach_y});
		attach_x = attach_x + note.getBBox().width + 3;
	}
	
	//this.connection && this.connection.updateLine();
}

//
// portrait: 사진 url
// name: 작성자 이름
// created: 작성일
jCardNode.prototype.setCreator = function(url, name, created){
	if(created == 0) {
		this.created = new Date().getTime();
		created = Math.floor(this.created / 1000);
	} else {
		created = parseInt(created / 1000);
	}
	
	this.userfullname = name;
	this.userportrait = url;
	
	var node = this;
	// Preload
	if(url) {
		var $portrait = $('<img />')
	    	.attr('src', url)
	    	.load(function(){
	    		if(node.portrait) {
	    			node.portrait.remove();
	    			node.portrait = null;
	    		}
	    		
				node.setPortrait(url, node.portraitRadius);
				if(Raphael.svg) node.groupEl.appendChild(node.portrait.node);
				if(Raphael.vml) node.groupEl.appendChild(node.portrait.Group);
	    		
	    		node.getParent() && node.getParent().folded && node.portrait.hide();
	    		node.CalcBodySize();				
	    		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();		
	    		
	    		jMap.loadManager.updateImageLoading(this);
	    	});
		jMap.loadManager.updateImageLoading($portrait[0]);
	}
	
	node.nodeCreator.attr({text : name});
	
	var formatedCreated = node.formatCreated(new Date(created * 1000), 'yyyy.MM.dd HH:mm:ss');
	node.nodeCreated.attr({text : formatedCreated});
}

jCardNode.prototype.setPortrait = function(url, radius) {
	var w = radius * 2;
	var h = radius * 2;
	
	this.portrait = RAPHAEL.circle(0, 0, radius);
    var uuid = Raphael.createUUID();
    var pattern = document.createElementNS("http://www.w3.org/2000/svg", "pattern");
    var backgroundImage = RAPHAEL.image(url, 0, 0, w, h);
    pattern.setAttribute("id", uuid);
    pattern.setAttribute("x", 0);
    pattern.setAttribute("y", 0);
    pattern.setAttribute("height", w);
    pattern.setAttribute("width", h);

    $(backgroundImage.node).appendTo(pattern);

    $(pattern).appendTo(RAPHAEL.defs);
    $(this.portrait.node).attr("fill", "url(#" + pattern.id + ")");
    this.portrait.attr({"stroke-width":0} );
}

jCardNode.prototype.formatCreated = function(date, format) {
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    
    var node = this;
    
    return format.replace(/(yyyy|yy|MM|M|dd|d|E|HH|H|hh|h|mm|m|ss|s|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return date.getFullYear();
            case "yy": return node.padZero(date.getFullYear() % 1000, 2);
            case "MM": return node.padZero(date.getMonth() + 1, 2);
            case "M": return date.getMonth() + 1;
            case "dd": return node.padZero(date.getDate(), 2);
            case "d": return date.getDate();
            case "E": return weekName[date.getDay()];
            case "HH": return node.padZero(date.getHours(), 2);
            case "H": return date.getHours();
            case "hh": return node.padZero((h = date.getHours() % 12) ? h : 12, 2);
            case "h": return (h = date.getHours() % 12) ? h : 12;
            case "mm": return node.padZero(date.getMinutes(), 2);
            case "m": return date.getMinutes();
            case "ss": return node.padZero(date.getSeconds(), 2);
            case "s": return date.getSeconds();
            case "a/p": return date.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};

jCardNode.prototype.padZero = function(str, length) {
	var strPad = "";
	
	str = str.toString();
	
	var ii = length - str.length;
	for(var i = 0; i < ii; i++) {
		strPad += "0";
	}
	
	return strPad + str;
}

jCardNode.prototype.setTextExecute = function(text){
	this.plainText = text;
	//var fontSize = this.parent && this.parent.isRootNode() && parseInt(this.fontSize) == parseInt(jMap.cfg.nodeFontSizes[2]) ? jMap.cfg.nodeFontSizes[1] : this.fontSize;
	var fontSize = this.fontSize;
	this.text.attr({ text: text, 'font-size': fontSize });
	
	if(this.text.getBBox().width > jMap.layoutManager.columnWidth - TEXT_HGAP) {
		this.plainText = this.wrapText(text, jMap.layoutManager.columnWidth - TEXT_HGAP * 2);
		this.text.attr({ text: this.plainText });
	}
	
	this.CalcBodySize();
}

jCardNode.prototype.wrapText = function(str, maxWidth) {
	var formatTextWrap = function(text, width) {
		var newline = '\n';
		var regexString = '.{1,' + width + '}';

		var re = new RegExp(regexString, 'g');
		var lines = text.match(re) || [];
		var result = lines.map(function(line) {
			if (line.slice(-1) === '\n') {
				line = line.slice(0, line.length - 1);
			}
			return line;
		}).join(newline);

		return result;
	};
	var txt = str.replace(/\r?\n|\r/g, "");
	var fontSize = this.parent && this.parent.isRootNode() && parseInt(this.fontSize) == parseInt(jMap.cfg.nodeFontSizes[2]) ? jMap.cfg.nodeFontSizes[1] : this.fontSize;
	// this.text.attr({ text: txt, 'font-size': fontSize});
	// return formatTextWrap(str, Math.floor(((maxWidth - jMap.layoutManager.padding*1.5)*txt.length) / this.text.getBBox().width));
	return formatTextWrap(str, Math.floor(((maxWidth - jMap.layoutManager.padding*1.5)*txt.length) / (txt.length*0.75*fontSize)));
}

jCardNode.prototype.setImageExecute = function(url, width, height, _callback){
	if (url == null || url == "") {
		if(this.img){
			this.img.remove();			
			this.img = null;
			this.imgInfo = {};
			
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
    	.load(function(){
    		var defaultWidth = jMap.layoutManager.columnWidth - 2;
    		var imgSize = {width:0, height:0};
    		
    		// 크기를 노드에 꽉 차도록 한다.
    		imgSize.width = defaultWidth;
    		var ratio = this.width / defaultWidth;
    		if(width) {
    			ratio = width / defaultWidth;
    		}
    		if(height) {
    			imgSize.height = height / ratio;
    		} else {
    			imgSize.height = this.height / ratio;
    		}
    		
    		imgSize.width = parseInt(imgSize.width);		
    		imgSize.height = parseInt(imgSize.height);
    		
    		// 이미지 중복 방지
    		if(node.img){
    			node.img.attr({src: this.src, width: imgSize.width, height: imgSize.height});
    			node.imgInfo.href = this.src;
    			node.imgInfo.width = imgSize.width;
    			node.imgInfo.height = imgSize.height;
    		} else {
    			node.img = RAPHAEL.image(this.src, 0, 0, imgSize.width, imgSize.height);
    			node.imgInfo.href = this.src;
    			node.imgInfo.width = imgSize.width;
    			node.imgInfo.height = imgSize.height;
    			if(Raphael.svg) node.groupEl.appendChild(node.img.node);
    			if(Raphael.vml) node.groupEl.appendChild(node.img.Group);
    		}		
    		
    		node.getParent() && node.getParent().folded && node.img.hide();
    		node.CalcBodySize();				
    		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();		
    		
    		jMap.loadManager.updateImageLoading(this);
    		
    		_callback && _callback.call(node);
    		return true;	// 의미 없음
    	}).error(function() {
    		// 이미지 중복 방지
    		if(node.img){
    			node.img.attr({src: jMap.cfg.contextPath+'/images/image_broken.png', width: 64, height: 64});
    			node.imgInfo.href = url;
    			node.imgInfo.width = width && width;
    			node.imgInfo.height = height && height;
    		} else {
    			node.img = RAPHAEL.image(jMap.cfg.contextPath+'/images/image_broken.png', 0, 0, 64, 64);
    			node.imgInfo.href = url;
    			node.imgInfo.width = width && width;
    			node.imgInfo.height = height && height;
    			if(Raphael.svg) node.groupEl.appendChild(node.img.node);
    			if(Raphael.vml) node.groupEl.appendChild(node.img.Group);
    		}		
    		
    		node.getParent() && node.getParent().folded && node.img.hide();
    		node.CalcBodySize();				
    		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();		
    		
    		jMap.loadManager.updateImageLoading(this);
    		
    		_callback && _callback.call(node);
    	});
	
	jMap.loadManager.updateImageLoading($img[0]);
}

// render it outside with html tags
jCardNode.prototype.setForeignObjectExecute = function (html, width, height) {
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
		this.foreignObjEl = document.createElementNS("http://www.w3.org/2000/svg", "foreignObject");
		this.foreignObjEl.bodyEl = document.createElementNS("http://www.w3.org/1999/xhtml", "body");
		//this.bodyEl.setAttribute("xmlns", "http://www.w3.org/1999/xhtml");
		this.foreignObjEl.appendChild(this.foreignObjEl.bodyEl);
		this.groupEl.appendChild(this.foreignObjEl);
		
		this.foreignObjEl.setAttribute("x", this.body.getBBox().x);
		this.foreignObjEl.setAttribute("y", this.body.getBBox().y);
	}
	
	width = width || 150;
	height = height || 150;

	var defaultWidth = jMap.layoutManager.columnWidth - 2;
	var ratio = 1;
	if(width) {
		ratio = defaultWidth / width;
		width = defaultWidth;
	}
	if(height) {
		height = parseInt(height * ratio);
	}

	this.foreignObjEl.setAttribute("width", width);
	this.foreignObjEl.setAttribute("height", height);
	
	// 사용자가 정의한 html은 저장이나 다른 곳에서 사용해야 하는데
	// innerHTML에 html 코드를 넣으면 몇몇 정보가 바뀌어 버리는것이 있다. (태그를 삭제한다든가 하는..)
	// 그래서 plainHtml에 순수한 html 문자열을 갖고 있는다.

	// issue fix - youtube iframe not show in android 4.4 && ios safari
	// if(AppUtil.getBrowserIsIE()){
		var hasIframe = (html || "").indexOf('<iframe') >= 0;

		if(this.foreignObjEl.iframeEl) {
			if(!hasIframe) {
				this.foreignObjEl.iframeEl.remove();
				delete this.foreignObjEl.iframeEl;
			} 
		} else if(hasIframe){
			this.foreignObjEl.bodyEl.innerHTML = "";
			this.foreignObjEl.iframeEl = $('<div class="jCard-foreignObjEl jCard-'+this.id+'" style="position: absolute;z-index: 1;outline: none; margin-left: 0px; margin-top: 0px; transform-origin: top left;"></div>').appendTo('body');
		}

		var node = this;
		var setPosition = function() {
			if(!node.foreignObjEl || !node.foreignObjEl.iframeEl) return true;
			var offset = $(node.body.node).offset();
			var offsetYGap = 0;
			// var offsetYGap = 35;
			// if(node.img != null) {
			// 	offsetYGap += jMap.cfg.scale * node.img.getBBox().height;
			// }
			$(node.foreignObjEl.iframeEl).css("top", offset.top + offsetYGap);
			$(node.foreignObjEl.iframeEl).css("left", offset.left + 1);
			// $(node.foreignObjEl.iframeEl).css("margin-left", 5 * jMap.cfg.scale);
			$(node.foreignObjEl.iframeEl).css("margin-top", 5 * jMap.cfg.scale);
			$(node.foreignObjEl.iframeEl).css("transform", 'scale('+jMap.cfg.scale+')');
			$(node.foreignObjEl.iframeEl).css("-webkit-transform", 'scale('+jMap.cfg.scale+')');
			$(node.foreignObjEl.iframeEl).css("-ms-transform", 'scale('+jMap.cfg.scale+')');
			$(node.foreignObjEl.iframeEl).css("-moz-transform", 'scale('+jMap.cfg.scale+')');
		};

		if(hasIframe) {
			$(this.foreignObjEl.iframeEl).html(html);
			$(this.foreignObjEl.iframeEl).css("width", width);
			$(this.foreignObjEl.iframeEl).css("height", height);

			$(this.foreignObjEl.iframeEl).find('iframe').attr("width", width);
			$(this.foreignObjEl.iframeEl).find('iframe').attr("height", height);

			setTimeout(function(){ setPosition(); });
			$(window).on("load", setPosition);
			$(this.groupEl).onPositionChanged(setPosition);
		} else {
			this.foreignObjEl.bodyEl.innerHTML = html;
		}
	// }else{
	// 	this.foreignObjEl.bodyEl.innerHTML = html;
	// }
	// this.foreignObjEl.bodyEl.innerHTML = '<!-- '+html+' -->';
	
	this.foreignObjEl.plainHtml = html;
	
	// 몇몇 브라우저에서는 유투브 동영상이 지원하지 않아서 그림을 대처하는데,
	// 그 방법으로 html 내용에 youtube.com있으면 유투브 동영상이라 판단하고 처리한다.
	// 문자열에 youtube.com이 있을수도 있기 떄문에 다음과 같이 처리하는것은 좋지 않다.
	if(/*BrowserDetect.browser == "Firefox" || */BrowserDetect.browser == "MSIE"){
		
		var pos = html.search (/youtube\.com/);
		if(pos != -1) {
			this.foreignObjEl.bodyEl.innerHTML = '<img src="'+jMap.cfg.contextPath+'/images/video_not_support.png" width="300" height="300"/>';			
		}				
	}
	this.CalcBodySize();
	
	//this.fix_flash(this.foreignObjEl.bodyEl);
}

jCardNode.prototype.foreignObjectResizeExecute = function(width, height){
	var defaultWidth = jMap.layoutManager.columnWidth - 2;
	var ratio = 1;
	if(width) {
		ratio = defaultWidth / width;
		width = defaultWidth;
	}
	if(height) {
		height = parseInt(height * ratio);
	}

	width && this.foreignObjEl.setAttribute("width", width);
	height && this.foreignObjEl.setAttribute("height", height);
	
	var html = this.foreignObjEl.plainHtml;
	html = html.replace(/(width=")([^"]*)/ig, "$1"+width);
	html = html.replace(/(height=")([^"]*)/ig, "$1"+height);
	
	if(this.foreignObjEl.iframeEl) {
		$(this.foreignObjEl.iframeEl).html(html);
		$(this.foreignObjEl.iframeEl).css("width", width);
		$(this.foreignObjEl.iframeEl).css("height", height);
	} else {
		this.foreignObjEl.bodyEl.innerHTML = html;
	}
	
	this.foreignObjEl.plainHtml = html;
	this.CalcBodySize();
	jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(this);
	jMap.layoutManager.layout(true);
}

jCardNode.prototype.removeExecute = function(force){
	if (this.removed) return false;
	if (!force && this.isRootNode()) return false;	
	if(!this.getChildren().isEmpty()){		
		var children = this.getChildren();
		for(var i = children.length-1; i >= 0; i--) {			
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
	for(var i = 0; i < alinks.length; i++) {
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

jCardNode.prototype.getInputPort = function(){
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

jCardNode.prototype.getOutputPort = function(){
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

jCardNode.prototype.toString = function () {
    return "jCardNode";
}

jCardNode.prototype.addEventController = function(c) {
	c = jMap.mode ? new jCardNodeController() : new jCardNodeControllerGuest();
	this.controller = c;

	$(this.groupEl).on("vmousedown", c.mousedown);
	$(this.groupEl).on("vmousemove", c.mousemove);
	$(this.groupEl).on("vmouseup", c.mouseup);

	//	$(this.groupEl).on("vmouseover", c.mouseover);
	//	$(this.groupEl).on("vmouseout", c.mouseout);

	$(this.groupEl).on("taphold", c.taphold);

	$(this.groupEl).on("vclick", c.click);

	//$(this.groupEl).on("dblclick", c.dblclick);

	//	$(this.groupEl).on("dragenter", c.dragenter);
	//	$(this.groupEl).on("dragleave", c.dragexit);
	//	$(this.groupEl).on("drop", c.drop);

	// Disable the contextmenu on mobile. The short cut menu will be used.
	//if(!(ISMOBILE || supportsTouch)) $(this.groupEl).on("contextmenu", c.contextmenu);
};


///////////////////////////////////////////////////////////////////////////////
//////////////////////////////// jCardTopic ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

jCardTopic = function() {
	jCardTopic.superclass.call(this, null, jMap.cfg.mapName);
}

extend(jCardTopic, jNode);
jCardTopic.prototype.type = "jCardTopic";

jCardTopic.prototype.initElements = function() {
	this.body = RAPHAEL.rect();		
	this.text = RAPHAEL.text();

	this.wrapElements(this.body, this.text);		
}

jCardTopic.prototype.create = function(){
	var body = this.body;
	var text = this.text;
		
	this.setBackgroundColorExecute("#ffffff");
	this.setTextColorExecute(jMap.cfg.textDefalutColor);
	this.setEdgeColorExecute(jMap.cfg.edgeDefalutColor, 1);
	
	var fontWeight = 700;
	var fontFamily = 'Malgun Gothic, 맑은고딕, Gulim, 굴림, Arial, sans-serif';
	var plainText = $('<textarea />').html(this.plainText).text();
	this.fontSize = jMap.cfg.nodeFontSizes[0];
	
	text.attr({'font-family': fontFamily, 'font-size': this.fontSize, "font-weight": fontWeight, 'text-anchor': 'start'});
	this.setTextExecute(plainText);
}

jCardTopic.prototype.getCenterLocation = function() {
	return {
		x : (RAPHAEL.getSize().width / 2) - (jMap.layoutManager.columns.length * jMap.layoutManager.columnWidth + (jMap.layoutManager.columns.length - 1) * jMap.layoutManager.HGAP) / 2,
		y : 70
	};
};

jCardTopic.prototype.CalcBodySize = function(){
	var padding = 10;
	var text = this.text;
	var body = this.body;

	var center = this.getCenterLocation();
	var x = center.x;
	var y = center.y;

	var menu_w = $("#main-menu").width() + 10;
	// var menu_h = $("#main-menu").height() + 15;
	var menu_h = 0;
	var box_w = $(window).width() - menu_w;

	// check gif alert message height
	// if(isGifIncluded){
	// 	y += $(".gif_noti").height();
	// }
	
	if($(window).width() < 1024) {
		y += menu_h
		box_w = $(window).width();
	}

	var plainText = $('<textarea />').html(this.plainText).text();
	text.attr({text: plainText});
	if(text.getBBox().width + padding*2 > box_w) {
		this.text.attr({ text: this.wrapText(plainText, box_w - padding*2) });
	}

	text.attr({x: x, y: y});
	text.node.firstChild.setAttribute("dy", this.fontSize*0.9);
	body.attr({x: x, y: y, width: box_w - padding*2, height: text.getBBox().height});

	jMap.layoutManager.marginTop = y + text.getBBox().height + 45;
	if(jMap.layoutManager.topic != null) {
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
	}

	this.updateNodeShapesPos();
}

jCardTopic.prototype.updateNodeShapesPos = function(){
	var padding = 10;
	var text = this.text;
	var body = this.body;

	var x = body.getBBox().x + padding;
	var y = body.getBBox().y;

	var menu_w = $("#main-menu").width() + 10;
	// var menu_h = $("#main-menu").height() + 10;
	var menu_h = 0;

	if($(window).width() < 1024) {
		x -= $(this.groupEl).offset().left;
		this.body.attr({ x: x, y: y, height: body.getBBox().height+padding });
	} else {
		x += $("#main-menu").width() + 10 - $(this.groupEl).offset().left;
		this.body.attr({ x: x, y: y, width: Math.min(body.getBBox().width, text.getBBox().width + padding*4), height: body.getBBox().height+padding });
	}

	this.text.attr({ x: x + (body.getBBox().width - text.getBBox().width)/2, y: y });
	text.node.firstChild.setAttribute("dy", this.fontSize*0.9 + padding/2);
}

jCardTopic.prototype.wrapText = function(str, maxWidth) {
	var formatTextWrap = function(text, width) {
		var newline = '\n';
		var regexString = '.{1,' + width + '}';

		var re = new RegExp(regexString, 'g');
		var lines = text.match(re) || [];
		var result = lines.map(function(line) {
			if (line.slice(-1) === '\n') {
				line = line.slice(0, line.length - 1);
			}
			return line;
		}).join(newline);

		return result;
	};
	var txt = str.replace(/\r?\n|\r/g, "");
	this.text.attr({ text: txt});
	return formatTextWrap(str, Math.floor((maxWidth*txt.length) / this.text.getBBox().width));
}

jCardTopic.prototype.toString = function () {
    return "jCardTopic";
}
