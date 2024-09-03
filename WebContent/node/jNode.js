/**
 * 
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */
	
///////////////////////////////////////////////////////////////////////////////
///////////////////////////// jNode ///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

jNode = function(parentNode, text, id){
	/////////////////// var ////////////////////////////
	this.groupEl = null;
	this.body = null;
	this.text = null;
	this.folderShape = null;
	this.img = null;
	this.hyperlink = null;
	this.file = null;
	this.note =  null;
	this.noteText = null;
	this.moodleIcon = null;
//	this.moodleIconInfo = {};
	//this.icons = new Array();
	
	this.arrowlinks = new Array();
	
	this.note = "";
	
	if(id && id != null && id != "" && id != "null" && jMap.checkID(id)) this.id = id;	// id를 준경우 id를 체크해서 유효하면 적용
	else this.id = this.CreateID();
	// 위와 같이 하면 안되는 이유가 뭘까...?
	// 2010.12.16
	// id 중복 검사를 위해서 다시 위와 같이 했는데,
	// 왜 위와 같이 하면 안되는거지? 당시 이유를 안적어 놔서..ㅠㅠ
	// 필요해서 다시 위와 같이 했음.
//	this.id = id?id:this.CreateID();

	this.plainText = text || "";
	this.folded = false;	// true, false
	this.background_color = "";
	this.color = "";
	
	this.controller = null;
	this.layoutHeight = 0;
	this.connection = null;
	this.children = new Array();
	this.parent = null;
	
	// OKM 속성
	// 테두리
	this.edge = {};
	// 연결선(가지)
	this.branch = {};
	
	// 기타 속성
	this.fontSize = 10;
	this.hided = false;		// 노드 show/hide
	this.imgInfo = {};
	this.numofchildren = 0;
	
	// 자기가 생성한 노드만 편집 가능하게 하기 위해 추가. 
	// jinhoon. 201216
	this.client_id = jMap.getClientId();
	
	this.creator = jMap.cfg.userId;
	this.userfullname = jMap.cfg.userName;
	this.userportrait = jMap.cfg.portrait;
	// this.userNo = jMap.cfg.userNo;
	this.created = 0;
	
	/////////////////// var 끝 ////////////////////////////
	this.createAbstract(parentNode);
	
	this.score = RAPHAEL.text();
	this.scoreValue = -1.0;
	this.score.attr({ text: "" });
	this.procOne = RAPHAEL.rect();
	this.procTwo = RAPHAEL.rect();
	
	this.iotId = 0;
}

jNode.prototype.type= "jNode";

// jNode Events
//for (var i = events.length; i--;) {
//    (function (eventName) {
//        jNode.prototype[eventName] = function (fn) {
//            if (Raphael.is(fn, "function")) {
//                this.events = this.events || [];				
//                this.events.push({name: eventName, f: fn, unbind: addEvent(this.groupEl, eventName, fn, this)});
//            }
//            return this;
//        };
//        jNode.prototype["un" + eventName] = function (fn) {
//            var events = this.events,
//                l = events.length;
//            while (l--) if (events[l].name == eventName && events[l].f == fn) {
//                events[l].unbind();
//                events.splice(l, 1);
//                !events.length && delete this.events;
//                return this;
//            }
//            return this;
//        };
//    })(events[i]);
//}

if (Raphael.vml) {
	var createNode;
	var d = document;
	d.createStyleSheet().addRule(".rvml", "behavior:url(#default#VML)");
	try {
		!d.namespaces.rvml && d.namespaces.add("rvml", "urn:schemas-microsoft-com:vml");
		createNode = function(tagName){
			return d.createElement('<rvml:' + tagName + ' class="rvml">');
		};
	} 
	catch (e) {
		createNode = function(tagName){
			return d.createElement('<' + tagName + ' xmlns="urn:schemas-microsoft.com:vml" class="rvml">');
		};
	}
}

/**
 * Layout에서 update하기 위해서..
 */
jNode.prototype.connectArrowLink = function() {
	for (var i = 0; i < this.arrowlinks.length; i++) {
		this.arrowlinks[i].draw();
	}
}

/**
 * 노드에 ArrowLink를 추가.
 */
jNode.prototype.addArrowLink = function(/*ArrowLink*/arrowlink) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	var arrows = this.arrowlinks;
	for (var i = 0; i < arrows.length; i++) {
		if( this.arrowlinks[i].destination == arrowlink.destination){
			return;
		}
    }
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.addArrowLinkExecute(arrowlink);
	
	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	

	jMap.fireActionListener(ACTIONS.ACTION_NODE_ARROWLINK, this, arrowlink);	
	jMap.setSaved(false);
	
	// selectedNodeMenu(true, this);
	
}

jNode.prototype.addArrowLinkExecute = function(/*ArrowLink*/arrowlink) {
	arrowlink.startNode = this;
	
	this.arrowlinks.push(arrowlink);
	
	jMap.addArrowLink(arrowlink);
}

/**
 * 노드에서 ArrowLink 삭제
 */
jNode.prototype.removeArrowLink = function(arrowlink) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.removeArrowLinkExecute(arrowlink);
	
	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	

	jMap.fireActionListener(ACTIONS.ACTION_NODE_EDITED, this);	
	jMap.setSaved(false);
	
	// selectedNodeMenu(true, this);
}

jNode.prototype.removeArrowLinkExecute = function(arrowlink) {
	arrowlink.remove();
	this.arrowlinks.remove(arrowlink);
	jMap.removeArrowLink(arrowlink);
}

jNode.prototype.settingArrowLink = function(color, width, style, start, end){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.settingArrowLinkExecute(color, width, style, start, end);
	
	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	

	jMap.fireActionListener(ACTIONS.ACTION_NODE_EDITED, this);	
	jMap.setSaved(false);
}

jNode.prototype.settingArrowLinkText = function(id, text){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.settingArrowLinkTextExecute(id, text);
	
	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	

	jMap.fireActionListener(ACTIONS.ACTION_NODE_EDITED, this);	
	jMap.setSaved(false);
}

jNode.prototype.settingArrowLinkAttr = function(id,color, width, style, start, end){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.settingArrowLinkAttrExecute(id,color, width, style, start, end);
	
	var redo = history && history.extractNode(this);

	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	

	jMap.fireActionListener(ACTIONS.ACTION_NODE_EDITED, this);	
	jMap.setSaved(false);
}

jNode.prototype.settingArrowLinkExecute = function(color, width, style, start, end){
	var arrows = this.arrowlinks;
	for (var i = 0; i < arrows.length; i++) {
        this.arrowlinks[i].setColor(color);
        this.arrowlinks[i].setLineWidth(width);
        this.arrowlinks[i].setStart(start);
        this.arrowlinks[i].setEnd(end);
        this.arrowlinks[i].setStyle(style);
    }
}

jNode.prototype.settingArrowLinkTextExecute = function(id, text){
	var arrows = this.arrowlinks;
	for (var i = 0; i < arrows.length; i++) {
		if( this.arrowlinks[i].id == id){
			this.arrowlinks[i].setText(text);
			break;
		}
    }
}

jNode.prototype.settingArrowLinkAttrExecute = function(id, color, width, style, start, end){
	var arrows = this.arrowlinks;
	for (var i = 0; i < arrows.length; i++) {
		if( this.arrowlinks[i].id == id){
			this.arrowlinks[i].setColor(color);
	        this.arrowlinks[i].setLineWidth(width);
	        this.arrowlinks[i].setStart(start);
	        this.arrowlinks[i].setEnd(end);
	        this.arrowlinks[i].setStyle(style);
			break;
		}
    }
}


// private
jNode.prototype.CreateID = function(){
	// jNode에서는 group, body, text 3개의 Element (라파엘 확장)을 사용하는데,
	// 라파엘에서는 Element가 만들어질때마다 0번부터 id를 부여한다.
	// 3개의 Element를 사용하기 때문에 group.id == 0, body.id == 1, text.id == 2
	// 같은 형식으로 갖으며, 결국 각각의 노드의 아이디는 n*3 의 아이디를 갖는다.
	// jNode는 FreeMind가 사용하는 방식의 ID를 쓴다.
	var id = "";
	while(!jMap.checkID(id)) id = "ID_" + parseInt(Math.random()*2000000000);
	return id;
}

jNode.prototype.createAbstract = function(parentNode){
	// Element들 생성
	this.initElements();

	this.parent = parentNode;	
	jMap.nodes[this.id] = this;
	
	if (this.getParent()) {
		// index를 준경우 노드를 index번째에 노드를 만들기
		if(this.index != null) this.getParent().insertChild(this, this.index);
		else this.getParent().appendChild(this);
		
		// lazyloading에 필요한 변수 numofchildren 업데이트
		this.getParent().numofchildren = this.getParent().getChildren().length;
	}
	
	this.initCreate();
	this.create();
}

/**
 * 인자로 들어온 모든 Element를 Group으로 감싼다.
 * Element는 모두 Raphael로 만들어진 도형이어야 한다.
 * 
 * @param {arguments} : 인자를 넘기면 자동으로 들어오는 인자 배열이다.
 */
jNode.prototype.wrapElements = function(/*arguments*/){
	this.groupEl = null;
	var d = document;
	if(Raphael.svg){
		this.groupEl = d.createElementNS("http://www.w3.org/2000/svg", "g");
    	this.groupEl.style.webkitTapHighlightColor = "rgba(0,0,0,0)";
		
		// 전역 그룹이 설정되어 있다면
		if(jMap.groupEl){
			jMap.groupEl.appendChild(this.groupEl);
		} else {
			RAPHAEL.canvas && RAPHAEL.canvas.appendChild(this.groupEl);
		}
	
		var agLength = arguments.length;
		for (var i = 0; i < agLength; i++) {
			this.groupEl.appendChild(arguments[i].node);
		}
	}
	
	if(Raphael.vml){
		this.groupEl = createNode("group");		
//		this.groupEl.style.cssText = "position:absolute;left:0;top:0;width:" + RAPHAEL.width + "px;height:" + RAPHAEL.height + "px";
//    	this.groupEl.coordsize = RAPHAEL.coordsize;
//    	this.groupEl.coordorigin = RAPHAEL.coordorigin;
		
		// 전역 그룹이 설정되어 있다면
		if(jMap.groupEl){
			jMap.groupEl.appendChild(this.groupEl);
		} else {
			RAPHAEL.canvas.appendChild(this.groupEl);
		}		
		
		var agLength = arguments.length;
		for (var i = 0; i < agLength; i++) {
			this.groupEl.appendChild(arguments[i].Group);
		}
	}
	
	this.groupEl.node = this;
}

/**
 * id를 반환
 */
jNode.prototype.getID = function() {
	return this.id;
}

/**
 * 현재노드에 node를 자식으로 추가한다.
 * @param {jNode} node
 */
jNode.prototype.appendChild = function(node) {
	this.children.push(node);
}

/**
 * 현재노드에 node를 index번째 자식으로 추가한다.
 * @param {jNode} node
 * @param {int} index
 */
jNode.prototype.insertChild = function(node, index) {
	this.index = index;
	this.children.insert(index, node);
}

/**
 * 노드가 부모 노드의 몇번째 자식 인가를 리턴
 */
jNode.prototype.getIndexPos = function() {	
	if(!this.parent)
		return -1;
	return this.parent.children.indexOf(this);
}

jNode.prototype.getParent = function() {
	return this.parent;
}

jNode.prototype.setParent = function(parentNode) {
	this.parent = parentNode;
}

jNode.prototype.getChildren = function() {
	return this.children;
}

jNode.prototype.getUnChildren = function() {
	//if( new Boolean( this.folded ).valueOf() ) {
	if( this.folded == true || this.folded == "true") {
		return null;
	} else {
		return this.getChildren();
	}
}

jNode.prototype.isRootNode = function() {
	return this.parent == null;
	//return (this.parent)? false : true;
}

jNode.prototype.getText = function(){
	return this.text.attr() ? this.text.attr().text : '';
}

jNode.prototype.setText = function(text){
	// 중심 토픽은 빈값을 입력하지 못하게 처리
	if(this.isRootNode() && text.trim().length == 0) {
		// alert("중심 토픽은 빈 텍스트를 입력할 수 없습니다.");
		JinoUtil.toast({type: 'warning', text: "중심 토픽은 빈 텍스트를 입력할 수 없습니다."})
		return null;
	}
	
	// 이모지 체크
	var pattern = eval('/[\uD800-\uF8FF]/');
	if(pattern.test(text)){
		// alert("이모티콘은 등록할 수 없습니다.");
		JinoUtil.toast({type: 'warning', text: "이모티콘은 등록할 수 없습니다."})
		// 이모지는 제거, 나머지 텍스트는 유지
		text = text.replace(new RegExp(pattern, 'g'), '');
		// return 하면 수정된 텍스트가 반영이 안됨.
		//return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setTextExecute(text);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	
	jMap.fireActionListener(ACTIONS.ACTION_NODE_EDITED, this);	
	jMap.setSaved(false);
}

jNode.prototype.setTranslatedText = function(text){
	if(text == undefined) return null;
	if(this.isRootNode() && text.trim().length == 0) {
		return null;
	}else{
		text = text.trim();
	}
	
	var pattern = eval('/[\uD800-\uF8FF]/');
	if(pattern.test(text)){
		text = text.replace(new RegExp(pattern, 'g'), '');
	}
	text = text.replace("&#39;","'");
	
	this.setTextExecute(text);
}

jNode.prototype.setTextExecute = function(text){
	this.plainText = text;
	this.text.attr({ text: text });	
	this.CalcBodySize();
	this.setScoreExecute();
}

jNode.prototype.setScore = function(text){
	this.scoreValue = text;
	this.setScoreExecute();
}

jNode.prototype.setScoreExecute = function(){
	if(this.scoreValue == -1.0 ) return;
	if(this.score == undefined) return;
	if(this.procOne == undefined) return;
	if(this.procTwo == undefined) return;
	this.score.attr({ text: this.scoreValue });	
	this.score.attr({ 'font-size': 12 });
	this.score.attr({ 'font': 12+"px " + this.text.attr("font-family") });
	this.score.attr({fill: "#000000"});
	this.procOne.attr({height: 10});
	this.procTwo.attr({height: 10});
	this.procTwo.attr({fill: "#000000"});
	var nodeWid = this.getSize().width;
	this.procOne.attr({width: nodeWid});
	if(this.isLeft()){
		var wid = nodeWid / 100 * this.scoreValue;
		this.procTwo.attr({width: wid > 0 ? wid : 0});
	}else{
		var wid = nodeWid / 100 * this.scoreValue;
		this.procTwo.attr({width: wid > 0 ? wid : 0});
	}
}

jNode.prototype.wrapText = function(str, maxWidth) {
	var newLineStr = "\n";
	
	// 빈칸을 마지막으로 발견한 위치, 여기를 자른다.
	var lastFound = 0;
	
	var strLength = str.length;
	for(var i = 0; i < strLength; i++) {
		if(str[i] == " " || str[i] == newLineStr) {
			this.text.attr({ text: str.substring(0, i)});
			if(this.text.getBBox().width >= maxWidth) {
				if(lastFound == 0) {
					return this.wrapTextForce(str, maxWidth);
				}
				return str.substring(0, lastFound) + newLineStr + this.wrapText(str.substring(lastFound + 1), maxWidth);
			}
			lastFound = i;
		}
	}
	
	// 길이를 다시 한번 체크
	this.text.attr({ text: str.substring(0, i)});
	if(this.text.getBBox().width >= maxWidth) {
		return this.wrapTextForce(str, maxWidth);
	}

    return str;
}

jNode.prototype.wrapTextForce = function(str, maxWidth) {
	var newLineStr = "\n";
	
	for(var i = 0; i < str.length; i++) {
		if(str[i] == newLineStr) {
			return str.substring(0, i) + newLineStr + this.wrapText(str.substring(i + 1), maxWidth);
		}
		
		this.text.attr({ text: str.substring(0, i)});
		if(this.text.getBBox().width >= maxWidth) {
			return str.substring(0, i) + newLineStr + this.wrapText(str.substring(i + 1), maxWidth);
		}
	}

    return str;
}

jNode.prototype.renderedTextSize = function(string) {
	var paper = Raphael(0, 0, 0, 0);
	paper.canvas.style.visibility = 'hidden';
	
	var el = paper.text(0, 0, string);
	el.attr({
		'font-family' : this.text.attr("font-family"),
		'font-size' : this.text.attr("font-size"),
		'font-weight' : this.text.attr("font-weight"),
		'text-anchor' : null
	});
	
	var bBox = el.getBBox();
	paper.remove();
	
	return {
		width: bBox.width,
	    height: bBox.height
	};
}

jNode.prototype.getFontSize = function(){
	return this.fontSize;
}

/**
 * @param {int}	size : 폰트 크기
 */
jNode.prototype.setFontSize = function(size){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setFontSizeExecute(size);
	
	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_FONTSIZE, this);	
	jMap.setSaved(false);
}

jNode.prototype.setFontSizeExecute = function(size){
	this.fontSize = size;	
	this.text.attr({ 'font-size': size });
	this.text.attr({ 'font': size+"px " + this.text.attr("font-family") });	
	this.CalcBodySize();
	jMap.resolveRendering();
}

/**
 * @param {String}	textColor : 글자 색상
 */
jNode.prototype.setTextColor = function(textColor){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setTextColorExecute(textColor);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_ATTRS, this);
	jMap.setSaved(false);
}

jNode.prototype.setTextColorExecute = function(textColor){
	this.color = textColor;
	this.text.attr({fill: textColor});
}

jNode.prototype.getTextColor = function(){
	return this.color;
	//return this.color;
}

/**
 * @param {String}	background : 배경 색상
 */
jNode.prototype.setBackgroundColor = function(background){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setBackgroundColorExecute(background);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);
	jMap.fireActionListener(ACTIONS.ACTION_NODE_ATTRS, this);
	jMap.setSaved(false);
}

jNode.prototype.setBackgroundColorExecute = function(background){
	if (background) {
		this.background_color = background;
		this.body.attr({fill: background});
		this.folderShape && this.folderShape.attr({fill: background});
	}
}

jNode.prototype.getBackgroundColor = function(){
	return this.background_color;
}

/**
 * 노드 테두리의 색상 및 굵기
 * @param {String} color
 * @param {int} width
 */
jNode.prototype.setEdgeColor = function(color, width){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setEdgeColorExecute(color, width);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	
	jMap.fireActionListener(ACTIONS.ACTION_NODE_EDGECOLOR, this);	
	jMap.setSaved(false);
}

jNode.prototype.setEdgeColorExecute = function(color, width){
	if (color) {
		this.edge.color = color;
		this.body.attr({stroke: color});
		this.folderShape && this.folderShape.attr({stroke: color});		
	}
	if (width) {
		this.edge.width = width;
		this.body.attr({"stroke-width": width});		
	}
}

jNode.prototype.getEdgeColor = function(){
	return this.edge.color;
}

jNode.prototype.setBranch = function(color, width, style){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setBranchExecute(color, width, style);

	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);	
	jMap.fireActionListener(ACTIONS.ACTION_NODE_BRANCH, this);	
	jMap.setSaved(false);
}

jNode.prototype.setBranchExecute = function(color, width, style){
	if(!this.connection) {
		return false;
	}
	
	if(style == null || style == "undefined" || style.trim() == "") {
		if(this.branch.style != null && this.branch.style != "undefined" && this.branch.style.trim() != "") {
			style = this.branch.style;
		} else {
			style = jMap.layoutManager.defaultBranchStyle;
		}
	}
	
	this.branch.style = style;
	this.connection.remove();
	
	var jsCode = "this.connection = this.parent && new " + style + "(this.parent, this)";
	eval (jsCode);
	
	if(this.branch.color == null || this.branch.color == "undefined" || this.branch.color == "") {
		this.branch.color = this.edge.color;
	}
	if(this.branch.width == null || this.branch.width == "undefined" || this.branch.width == "") {
		this.branch.width = "" + this.edge.width;
	}
	
	this.connection && this.connection.line.attr({stroke: this.branch.color, fill: this.branch.color});
	this.connection && this.connection.line.attr({"stroke-width": this.branch.width});
	
	
	if (color != null && color != "undefined" && color != "") {
		this.branch.color = color;
		this.connection && this.connection.line.attr({stroke: color, fill: color});
		// 아오.. 이거 어떻게 해결해야대...
		if(jMap.layoutManager.type == "jTreeLayout") {
			this.connection && this.connection.line.attr({stroke: color, fill: 'none'});
		}
	}
	
	if (width != null && width != "undefined" && width != "") {
		this.branch.width = width;
		this.connection && this.connection.line.attr({"stroke-width": width});
	}
}

jNode.prototype.getBranchColor = function(){
	return this.branch.color;
}
/**
 * 현재 노드에서 부터 루트까지의 패스를 배열로 반환한다.
 * @param {int} depth
 */
jNode.prototype.getPathToRoot = function(depth){
	var ar = new Array();
	var currentNode = this;
	ar.push(currentNode.getText());
	while (currentNode = currentNode.parent) {
		if(depth != null && depth-- == 0) break;
		ar.push(currentNode.getText());	
	}
	return ar;
}

/**
 * getPathToRoot와 같으면 배열대신 문자열을 반환하며 구분자를 설정할 수 있다.
 * @param {int} depth
 * @param {String} delimiter
 */
jNode.prototype.getPathToRootText = function(depth, delimiter){
	var textPath = this.getPathToRoot(depth);
	return textPath.join(delimiter);
}

/**
 * 노드의 깊이를 구한다.
 */
jNode.prototype.getDepth = function(){
	var depth = 0;
	var currentNode = this;	
	while (currentNode = currentNode.parent) {
		depth++;
	}
	return depth;
}

/**
 * @param {boolean} only : 다중 선택시
 */
jNode.prototype.focus = function(only, fireAction){
	var selectedNodes = jMap.getSelecteds();
	
	if(only) {
		// 이전에 선택된 노드의 하일라이팅 없애기 & selectedNodes 비우기
		var nodeLength = selectedNodes.length-1;
		for(var i = nodeLength; i >= 0; i--) {
			selectedNodes[i].CalcBodySize();
			selectedNodes[i].blur();
		}
	}
	if (!selectedNodes.contains(this)) {
		this.CalcBodySize();
		selectedNodes.push(this);	// selectedNodes에 선택된 노드 추가
		// 하일라이딩 주기
//		this.body.animate({fill: jMap.cfg.nodeSelectedColor}, 500);		
		this.body.animate({stroke: jMap.cfg.nodeSelectedColor, "stroke-width": 3}, 300);
	}
	
	if(fireAction == null || fireAction == undefined) fireAction = true;
	if(fireAction) jMap.fireActionListener(ACTIONS.ACTION_NODE_SELECTED, this);
	
	jMap.work.focus();
}

/**
 * 포커스 없애기
 */
jNode.prototype.blur = function(){
	var selectedNodes = jMap.getSelecteds();
	if (selectedNodes.contains(this)) {
		selectedNodes.remove(this);
		this.body.animate({fill: this.background_color,
								stroke: this.edge.color,
								"stroke-width": this.edge.width}, 300);
	}
	
	jMap.fireActionListener(ACTIONS.ACTION_NODE_UNSELECTED, this);
}

/**
 * 화면을 노드 중심으로 움직인다.
 */
jNode.prototype.screenFocus = function(){
	var work = jMap.work;
	work.scrollLeft = Math.round( this.getLocation().x - 
									work.offsetWidth / 2 +
									this.getSize().width / 2);
	work.scrollTop = Math.round( this.getLocation().y -
									work.offsetHeight / 2 +
									this.getSize().height / 2);
}

jNode.prototype.setNote = function(str){
	this.note = str;
}

jNode.prototype.setFolding = function(folded){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	var isChild = (this.numofchildren > 0 || this.getChildren().length > 0);
	if(!isChild || this.isRootNode()) return;
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this);
	
	this.setFoldingExecute(folded);
	
	var redo = history && history.extractNode(this);
	history && history.addToHistory(undo, redo);
	
	jMap.saveAction.editAction(this);
	jMap.setSaved(false);
}

jNode.prototype.setFoldingExecute = function(folded){
	var isChild = (this.numofchildren > 0 || this.getChildren().length > 0); 
	if(!isChild || this.isRootNode()) return;
	
	jMap.fireActionListener(ACTIONS.ACTION_NODE_FOLDING, this);
	
	// numofchildren에 실제 자식수 업뎃 
	this.numofchildren = this.getChildren().length;
	if(this.numofchildren > 0){
		if(folded){
			this.hideChildren(this);
			this.folderShape && this.folderShape.show();
			this.folded = true;				
		} else {
	
			this.showChildren(this);
			this.folderShape && this.folderShape.hide();
			this.folded = false;
		}
	}
	
	jMap.resolveRendering();
}

jNode.prototype.setFoldingAll = function(folded){
	this.__FoldingAll(folded, this);
	
	if(this.isRootNode()){
		var children = this.getChildren();
		var cldLength = children.length;
		for(var i = 0; i < cldLength; i++) {
			children[i].setFoldingExecute(folded);
		}
	} else {this.setFoldingExecute(folded);}	
}

jNode.prototype.__FoldingAll = function(folded, node){
	
	if(!node.getChildren().isEmpty() && !node.isRootNode())
		node.folded = folded;
	
	if(node.getChildren().length > 0) {
		var children = node.getChildren();
		var cldLength = children.length;
		for(var i = 0; i < cldLength; i++) {
			this.__FoldingAll(folded, children[i]);			
		}
	}
}

/**
 * 노드의 끝쪽의 PERCEIVE_WIDTH 넓이 부분을 클릭하였는가 검사
 * @param {MouseEvent} e 
 * @return true / false
 */
jNode.prototype.isFoldingHit = function(e){
	var pos = false;
	
	switch(jMap.layoutManager.type) {
		case "jMindMapLayout" :
			var offsetX = (e.offsetX)? e.offsetX : e.layerX - this.getLocation().x;
			
			pos = (this.isLeft())? (offsetX < PERCEIVE_WIDTH) : (offsetX > this.body.getBBox().width - PERCEIVE_WIDTH);
			break;
		case "jTreeLayout" :
			var offsetY = (e.offsetY)? e.offsetY : e.layerY - this.getLocation().y;
			pos = (offsetY > this.body.getBBox().height - PERCEIVE_WIDTH/2);			
			break;
		case "jHTreeLayout" :
			var offsetY = (e.offsetY)? e.offsetY : e.layerY - this.getLocation().y;
			pos = (offsetY > this.body.getBBox().height - PERCEIVE_WIDTH/2);			
			break;
		case "jFishboneLayout" :
			var rotate = jMap.layoutManager.getTransformations(this.groupEl.getAttribute("transform")).rotate;
			
			if(rotate == null) {
				var offsetY = (e.offsetY)? e.offsetY : e.layerY - this.getLocation().y;
				pos = (offsetY > this.body.getBBox().height - PERCEIVE_WIDTH/2);
			} else {
				var offsetX = (e.offsetX)? e.offsetX : e.layerX - this.getLocation().x;
				pos = (offsetX > this.body.getBBox().height - PERCEIVE_WIDTH/2);
			}
			// var offsetX = (e.offsetX)? e.offsetX : e.layerX - this.getLocation().x;
			// pos = (this.isLeft())? (offsetX < PERCEIVE_WIDTH) : (offsetX > this.body.getBBox().width - PERCEIVE_WIDTH);
			break;
		default :
	}
	
	return pos;
}

jNode.prototype.hideChildren = function(node){	
	if(node.getChildren().length > 0) {
		var children = node.getChildren();
		var cldLength = children.length;
		for(var i = 0; i < cldLength; i++) {
			this.hideChildren(children[i]);			
			children[i].hide();
		}
	}
}

jNode.prototype.hide = function(){	
	this.body.hide();
	this.text.hide();
	this.folderShape && this.folderShape.hide();
	this.img && this.img.hide();
	this.hyperlink && this.hyperlink.hide();
	this.file && this.file.hide();
	this.note && this.note.hide();
//	this.connection && this.connection.line.hide();
	this.connection && this.connection.hide();
	this.moodleIcon && this.moodleIcon.hide();
	this.score.hide();
	
	if(this.foreignObjEl && this.foreignObjEl.style) this.foreignObjEl.style.display = "none";
	
	// this가 가르키는 arrowlink
	for (var i = 0; i < this.arrowlinks.length; i++) {
		this.arrowlinks[i].hide();		
	}
	// this를 가르키는 arrowlink
	var alinks = jMap.getArrowLinks(this);
//	console.log(alinks.length);
	for(var i = 0; i < alinks.length; i++) {
		if(alinks[i] != undefined){
			alinks[i].text.hide();
			alinks[i].hide();
		}
	}
	
	this.hided = true;
}

jNode.prototype.showChildren = function(node){	
	if(node.numofchildren > 0 /*node.getChildren().length > 0*/) {
		var children = node.getChildren();
		for(var i = 0; i < children.length; i++) {
			children[i].show();
			
			if(!children[i].folded) this.showChildren(children[i]);
		}
	}
}

jNode.prototype.show = function(){
	this.body.show();
	this.text.show();
	this.folded && this.folderShape.show();
	this.img && this.img.show();
	this.hyperlink && this.hyperlink.show();
	this.file && this.file.show();
	this.note && this.note.show();
//	this.connection && this.connection.line.show();
	this.connection && this.connection.show();
	this.moodleIcon && this.moodleIcon.show();
	this.score.show();
	
	if(this.foreignObjEl && this.foreignObjEl.style) this.foreignObjEl.style.display = "block";
	
	/*
	// this가 가르키는 arrowlink
	for (var i = 0; i < this.arrowlinks.length; i++) {
		this.arrowlinks[i].show();		
	}
	// this를 가르키는 arrowlink
		*/
	var alinks = jMap.getArrowLinks(this);
	for(var i = 0; i < alinks.length; i++) {
		if(alinks[i] != undefined){
			alinks[i].text.show()
			alinks[i].show();
		}
	}

	
	this.hided = false;
}

jNode.prototype.hadChildren = function(node){	
	if(this.getChildren().length > 0) {
		var children = this.getChildren();
		for(var i = 0; i < children.length; i++) {
			if(node == children[i]) return true;
			if(children[i].hadChildren(node)) return true;
		}
	}
	
	return false;
}

jNode.prototype.remove = function(force){
	if(!jMap.saveAction.isAlive()) {
		return null;
	}
	
	if (this.removed) return false;
	if (!force && this.isRootNode()) return false;

  if(this.attributes && (this.attributes.moodleModule || this.attributes.moodleCourseSection) && !confirm("This node is connected to Moodle. This action will also delete the Moodle activity. Are you sure you want to continue?")) {
    return null;
  }
	
	// 지우기전 타임라인에 기록
	saveMap(true, true);
	
	jMap.saveAction.deleteAction(this);
	
	var history = jMap.historyManager;
	var undo = history && history.extractNode(this, true);
	
	this.removeExecute(force);
	
	var redo = null;
	history && history.addToHistory(undo, redo);
	
	jMap.fireActionListener(ACTIONS.ACTION_NODE_REMOVE, this);	
	jMap.setSaved(false);
}

jNode.prototype.removeExecute = function(force){
	if (this.removed) return false;
	if (!force && this.isRootNode()) return false;	
	if(!this.getChildren().isEmpty()){		
		var children = this.getChildren();
		for(var i = children.length-1; i >= 0; i--) {			
			children[i].removeExecute();
		}
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
	
	var selectedNodes = jMap.getSelecteds();
	if (selectedNodes.contains(this)) {
		selectedNodes.remove(this);
		// selectedNodeMenu(false);
	}
	
	// lazyloading에 필요한 변수 numofchildren 업데이트
	this.parent.numofchildren = this.parent.getChildren().length;
	
	return true;
}

/**
 * @includeCousin {boolean}	: 한쪽 끝의 노드가 다음 형제를 찾을 때, 부모의 형제의 자식을 선택할 것인가
 */
jNode.prototype.nextSibling = function(includeCousin){
	if(this.isRootNode()) return null;
	
	var index = this.getIndexPos();
	var children = this.getParent().getChildren();
	var checkLength = children.length-1;
	
	if(jMap.layoutManager.type == "jMindMapLayout") {
		// 깊이가 1인 노드일 경우
		if (this.getParent().isRootNode()) {
			var position = this.position;		
			for(var i = index; i < checkLength; i++){
				if(children[i + 1].position == position)
					return children[i + 1];
			}	
			return null;
		}
	}
	
	// 한쪽 끝의 다음 형제를 처리
	// 부모의 형제 노드의 첫번째 자식으로 선택
	// ** 이것은 경우에 따라 형제로 볼수도 아니면 안볼수도 있다.
	// ** 따라서 옵션으로 선택하게 끔 한다.
	if (includeCousin && index == checkLength && this.getParent().nextSibling(includeCousin)) {
		var nch = this.getParent().nextSibling(includeCousin).getChildren();		
		if(nch.length > 0) return nch[0];
	}
	if (index < checkLength) {
		return children[index + 1];
	}
	
	return null;
}

/**
 * @includeCousin {boolean}	: 한쪽 끝의 노드가 다음 형제를 찾을 때, 부모의 형제의 자식을 선택할 것인가
 */
jNode.prototype.prevSibling = function(includeCousin){	
	if(this.isRootNode()) return null;
	
	var index = this.getIndexPos();
	var children = this.getParent().getChildren();
	
	if(jMap.layoutManager.type == "jMindMapLayout") {
		// 깊이가 1인 노드일 경우
		if (this.getParent().isRootNode()) {
			var position = this.position;		
			for(var i = index; i > 0; i--){
				if(children[i - 1].position == position)
					return children[i - 1];
			}	
			return null;
		}
	}
	
	// nextSibling에서와 같은 역할
	if (includeCousin && index == 0 && this.getParent().prevSibling(includeCousin)) {
		var pch = this.getParent().prevSibling(includeCousin).getChildren();		
		if(pch.length > 0) return pch[pch.length-1];
	}
	if (index > 0) {
		return children[index - 1];
	}
	
	return null;
}

jNode.prototype.addEventController = function(c){
	this.controller = c;
	
	$(this.groupEl).on( "vmousedown", c.mousedown );
	$(this.groupEl).on( "vmousemove", c.mousemove );
	$(this.groupEl).on( "vmouseup", c.mouseup );
	
	$(this.groupEl).on( "vmouseover", c.mouseover );
	$(this.groupEl).on( "vmouseout", c.mouseout );
//	$(this.groupEl).on( "touchmove", c.touchmove );
	
	$(this.groupEl).on( "taphold", c.taphold );
	
	$(this.groupEl).on( "vclick", c.click );
	
	//$(this.groupEl).on( "dblclick", c.dblclick );
	
	$(this.groupEl).on( "dragenter", c.dragenter );
	$(this.groupEl).on( "dragleave", c.dragexit );
	$(this.groupEl).on( "drop", c.drop );
	
	//KHANG: handle context menu for node edition 
	// Disable the contextmenu on mobile. The short cut menu will be used.
	//if(!(ISMOBILE || supportsTouch)) $(this.groupEl).on( "contextmenu", c.contextmenu );
	
//	this.drag(c.move, c.dragger, c.up);
	
//	this.mousedown(c.mousedown);
//	this.mouseup(c.mouseup);
//	this.mousemove(c.mousemove);

//	this.mouseover(c.mouseover);	
//	this.mouseout(c.mouseout);
	
//	this.click(c.click);
//	this.dblclick(c.dblclick);
			
//	this.dragstart(c.dragstart);	
//	this.dragenter(c.dragenter);
//	this.dragexit(c.dragexit);
//	this.drop(c.drop);
}

// 작동되지 않는 함수.
// 컨트롤 해제를 구현체가 필요하다면 addEventController를 참고하여 해제 한다.
jNode.prototype.removeEventController = function(c){
//	this.unmousedown(c.mousedown);
//	this.unmouseup(c.mouseup);
//	this.unmousemove(c.mousemove);
//
//	this.unmouseover(c.mouseover);	
//	this.unmouseout(c.mouseout);
//	
//	this.unclick(c.click);	
//	this.undblclick(c.dblclick);
//			
//	this.undragstart(c.dragstart);	
//	this.undragenter(c.dragenter);
//	this.undragexit(c.dragexit);
//	this.undrop(c.drop);
	
	this.controller = null;
}

/*
jNode.prototype.drag = function (onmove, onstart, onend) {
    this._drag = {};
    var el = this.mousedown(function (e) {
        (e.originalEvent ? e.originalEvent : e).preventDefault();
        this._drag.x = e.clientX;
        this._drag.y = e.clientY;
        this._drag.id = e.identifier;
        onstart && onstart.call(this, e.clientX, e.clientY);
        Raphael.mousemove(move).mouseup(up);
    }),
        move = function (e) {
            var x = e.clientX,
                y = e.clientY;
            if (ISMOBILE && supportsTouch) {
                var i = e.touches.length,
                    touch;
                while (i--) {
                    touch = e.touches[i];
                    if (touch.identifier == el._drag.id) {
                        x = touch.clientX;
                        y = touch.clientY;
                        (e.originalEvent ? e.originalEvent : e).preventDefault();
                        break;
                    }
                }
            } else {
                e.preventDefault();
            }
            onmove && onmove.call(el, x - el._drag.x, y - el._drag.y, x, y);
        },
        up = function (e) {
			var x = e.clientX,
                y = e.clientY;
            Raphael.unmousemove(move).unmouseup(up);
            onend && onend.call(el, x - el._drag.x, y - el._drag.y, x, y);
			el._drag = {};
        };
    return this;
};
*/


//var drag = [],
//	dragMove = function (e) {
//	    var x = e.clientX,
//	        y = e.clientY,
//	        scrollY = document.documentElement.scrollTop || document.body.scrollTop,
//	        scrollX = document.documentElement.scrollLeft || document.body.scrollLeft,
//	        dragi,
//	        j = drag.length;
//	    while (j--) {
//	        dragi = drag[j];
//	        if (ISMOBILE && supportsTouch) {
//	            var i = e.touches.length,
//	                touch;
//	            while (i--) {
//	                touch = e.touches[i];
//	                if (touch.identifier == dragi.el._drag.id) {
//	                    x = touch.clientX;
//	                    y = touch.clientY;
//	                    (e.originalEvent ? e.originalEvent : e).preventDefault();
//	                    break;
//	                }
//	            }
//	        } else {
//	            e.preventDefault();
//	        }
//	        x += scrollX;
//	        y += scrollY;
//	        dragi.el.exception_x = x;
//	        dragi.el.exception_y = y;
//	        dragi.move && dragi.move.call(dragi.el, x - dragi.el._drag.x, y - dragi.el._drag.y, x, y);
//	    }
//	},
//	dragUp = function (e) {
//		Raphael.unmousemove(dragMove).unmouseup(dragUp);
//		var x = e.clientX,
//	        y = e.clientY,
//	        scrollY = document.documentElement.scrollTop || document.body.scrollTop,
//	        scrollX = document.documentElement.scrollLeft || document.body.scrollLeft,
//	        j = drag.length,
//	        dragi;
//	    while (j--) {
//	        dragi = drag[j];
//	        if (ISMOBILE && supportsTouch) {
//	            var i = e.touches.length,
//	                touch;
//	            while (i--) {
//	                touch = e.touches[i];
//	                if (touch.identifier == dragi.el._drag.id) {
//	                    x = touch.clientX;
//	                    y = touch.clientY;
//	                    (e.originalEvent ? e.originalEvent : e).preventDefault();
//	                    break;
//	                }
//	            }
//	        } else {
//	            e.preventDefault();
//	        }
//	        if(!isNaN(x) && !isNaN(y)) {
//	        	x += scrollX;
//		        y += scrollY;
//	        } else {
//	        	x = dragi.el.exception_x;
//	        	y = dragi.el.exception_y;
//	        }
//	        
//	        dragi.end && dragi.end.call(dragi.el, e, x - dragi.el._drag.x, y - dragi.el._drag.y, x, y);
//	        dragi.el._drag = {};
//	    }
//	    drag = [];
//	};
//
//jNode.prototype.drag = function (onmove, onstart, onend) {
//    this.groupEl._drag = {};
//    $(this.groupEl).on( "vmousedown", function (e) {
//        (e.originalEvent || e).preventDefault();
//        var scrollY = document.documentElement.scrollTop || document.body.scrollTop,
//            scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
//        this._drag.x = e.clientX + scrollX;
//        this._drag.y = e.clientY + scrollY;
//        this._drag.id = e.identifier;	// 모바일시 사용되는 아이디인데 값을 구하지 못한다. 구할 방법을 찾을시 위 move, up에서 체크하는 부분 주석 풀기
//        this._drag.exception_x = 0;		// drag시 x, y 좌표를 구하지 못할 경우를 대비
//        this._drag.exception_y = 0;
//        onstart && onstart.call(this, e.clientX + scrollX, e.clientY + scrollY);
//        !drag.length && Raphael.mousemove(dragMove).mouseup(dragUp);
//        drag.push({el: this, move: onmove, end: onend});
//    });
//    return this;
//};
//
//jNode.prototype.undrag = function (onmove, onstart, onend) {
//    var i = drag.length;
//    while (i--) {
//        drag[i].el == this.groupEl && (drag[i].move == onmove && drag[i].end == onend) && drag.splice(i, 1);
//        !drag.length && R.unmousemove(dragMove).unmouseup(dragUp);
//    }
//};


jNode.prototype.toString = function () {
    return "jNode";
};

jNode.prototype.getLayoutSize = function() {
	return this.getSize();
}

// abstract

// interface
jNode.prototype.initCreate = function(){}
jNode.prototype.initElements = function(){}
jNode.prototype.create = function(){}
jNode.prototype.translate = function(x, y){}

jNode.prototype.getSize = function(){}
jNode.prototype.setSize = function(width, height){}
jNode.prototype.getLocation = function(){}
jNode.prototype.setLocation = function(x, y){}

jNode.prototype.CalcBodySize = function(){}
jNode.prototype.updateNodeShapesPos = function(){}

jNode.prototype.getInputPort = function(){}
jNode.prototype.getOutputPort = function(){}

jNode.prototype.toXML = function(alone){}

jNode.prototype.setCreator = function(portrait, name, created){
	if(created == 0) {
		created = Math.floor(new Date().getTime() / 1000);
	} else {
		created = parseInt(created / 1000);
	}
	
	this.userfullname = name;
	this.userportrait = portrait;
	this.created = created;
}


