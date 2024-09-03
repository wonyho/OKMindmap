/**
 *
 * @author Nguyen Van Hoang (nvhoangag@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com)
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */

///////////////////////////////////////////////////////////////////////////////
/////////////////////    jCardController    ////////////////////////
///////////////////////////////////////////////////////////////////////////////
jCardController = function(map) {
	jCardController.superclass.call(this, map);
};
extend(jCardController, JinoController);

jCardController.prototype.type = "jCardController";

jCardController.prototype.startNodeEdit = function(node) {
	if (this.nodeEditor == undefined || this.nodeEditor == null || node.removed) {
		return false;
	}

	if (!jMap.isAllowNodeEdit(node)) {
		return false;
	}

	if (STAT_NODEEDIT) this.stopNodeEdit(true);

	//var hGap = TEXT_HGAP;
	//var vGap = TEXT_VGAP;

	if(ISMOBILE) navbarMenusToggle(false);
	
	STAT_NODEEDIT = true;

	this.nodeEditor.setAttribute("nodeID", node.id);

	var oInput = this.nodeEditor;
	var centerLocation = jMap.layoutManager.getCenterLocation();

	oInput.style.fontFamily = node.text.attr()['font-family'];
	oInput.style.fontSize = jMap.cfg.nodeFontSizes[2] * this.map.cfg.scale + "px";
	oInput.style.textAlign = 'left';
	
	var viewBox = [];
	viewBox.x = 0;
	viewBox.y = 0;
	viewBox.width = RAPHAEL.getSize().width;
	viewBox.height = RAPHAEL.getSize().height;
	if(RAPHAEL.canvas.getAttribute("viewBox")){
		var vb = RAPHAEL.canvas.getAttribute("viewBox").split(" ");
		viewBox.x = vb[0];
		viewBox.y = vb[1];
		viewBox.width = vb[2];
		viewBox.height = vb[3];		
	}
	

	var width = node.body.getBBox().width * jMap.cfg.scale;
	var height = node.body.getBBox().height * this.map.cfg.scale;	
	var left = (node.body.getBBox().x - viewBox.x) * RAPHAEL.getSize().width / viewBox.width + 1;
	var top = (node.body.getBBox().y - viewBox.y) * RAPHAEL.getSize().height / viewBox.height + 1;
	
	oInput.style.display = "";
	oInput.style.minWidth = width + "px";
	oInput.style.height = height + "px";
	oInput.style.left = left + "px";
	oInput.style.top = top + "px";
	oInput.style.zIndex = 999;

	oInput.value = node.getText();
	oInput.focus();

	return true;
};

jCardController.prototype.foldingAction = function(node) {
};

jCardController.prototype.resetCoordinateAction = function(node) {
};

jCardController.prototype.foldingAllAction = function() {
};

jCardController.prototype.unfoldingAllAction = function() {
};

jCardController.prototype.pasteAction = function(selected) {
	if(!jMap.saveAction.isAlive()) {
		return null;
	}

	if (!selected)
		selected = jMap.getSelected();

	var node = jMap.getSelecteds().getLastElement();
	if(!node) {
		node = jMap.getRootNode();
	}
	
	// 1단계까지만 붙여넣기 할 수 있도록 한다.
	var depth = node.getDepth();
	if(depth > 1) {
		alert("카드형 팝에서는 1단계 부모 토픽에서만 붙여넣기 할 수 있습니다.");
		return false;
	}
	
	// 선택한 노드에 클립보드에 있는 노드들을 붙인다.
	var pasteNodes = jMap.loadManager.pasteNode(selected, jMap.clipboardManager.getClipboardText());

	var postPasteProcess = function() {
		// 붙여넣기한 노드를 저장
		// 붙여넣기는 이미 데이터가 있기 때문에 저장후에 화면에 렌더링 할 수 있지만
		// 붙여넣기 하는 과정중에 POSITION 속성은 새로 만들어 지기 때문에 (다른 속성도?)
		// 렌더링된 후에 저장하는 것이다.
		for (var i = 0; i < pasteNodes.length; i++) {
			jMap.saveAction.pasteAction(pasteNodes[i]);
		}

		// 레이지 로딩일 경우, 자식들을 모두 삭제 한다.
		// 위에서 이미 서버에 저장되어 있고,
		// 붙여넣은 노드의 로딩은 모두 레이지로딩으로 한다.
		if (jMap.cfg.lazyLoading) {
			for (var i = 0; i < pasteNodes.length; i++) {
				var children = pasteNodes[i].getChildren();
				for (var c = children.length - 1; c >= 0; c--) {
					children[c].removeExecute();
				}
			}
		}

		// 이벤트 리스너를 위한 데이터
		// copy&paste의 경우 노드 아이디가 다시 만들어지기 때문에
		var sendXml = "<clipboard>";
		for (var i = 0; i < pasteNodes.length; i++) {
			var xml = pasteNodes[i].toXML();
			sendXml += xml;
		}
		sendXml += "</clipboard>";

		// 이벤트 리스너 호출
		jMap.fireActionListener(ACTIONS.ACTION_NODE_PASTE, selected, sendXml);

		jMap.layoutManager.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors(selected);
		jMap.layoutManager.layout(true);
	}

	if (jMap.loadManager.imageLoading.length == 0) {
		postPasteProcess();
	} else {
		var loaded = jMap.addActionListener(ACTIONS.ACTION_NODE_IMAGELOADED, function() {
			postPasteProcess();
			// 이미지로더 리스너는 삭제!!! 중요.
			jMap.removeActionListener(loaded);
		});
	}
};

jCardController.prototype.deleteAction = function() {
	// var result = confirm("선택한 토픽을 삭제하시겠습니까?");
	
	// if(result){
		var selectedNodes = jMap.getSelecteds();
		for (var i = 0; i < selectedNodes.length; i++) {
			if(!jMap.isAllowNodeEdit(selectedNodes[i])) {
				return false;
			}
		}
		
		var node = null;
		var parentNode = null;
		var indexPos = -1;
		while (node = jMap.getSelecteds().pop()) {
			parentNode = node.getParent();
			indexPos = node.getIndexPos();
			
			if(node.getDepth() == 1) {
				columns = jMap.layoutManager.columns;
				var index = columns[i].indexOf(node);
				columns[node.column].remove(node);
				jMap.layoutManager.initColumns(this.columnCount);
				//this.columns[node.column].remove(node);
				jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
			}
			
			node.remove();
		}
		
		if (parentNode) {
			jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(parentNode);
			jMap.layoutManager.layout(true);
			
			// 노드를 삭제후 적정한 노드위치로 포커싱
			if (indexPos != -1) {
				if (parentNode.getChildren().length <= 0) {
					parentNode.focus();
				} else {
					if (parentNode.getChildren().length > indexPos) {
						parentNode.getChildren()[indexPos].focus();
					} else {
						parentNode.getChildren()[parentNode.getChildren().length - 1].focus();
					}
				}
				
			}
		} else {
			jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
			jMap.getRootNode().screenFocus();
		}
	// }else{
	// 	return false;
	// }
};

jCardController.prototype.insertSiblingAction = function(){
	// FireFox의 엔터키 버그?? 다른 이벤트에서 기대하지 않은 이벤트 발생...
	if (BrowserDetect.browser == "Firefox") {
		jMap.keyEnterHit = 0;
	}
	
	var selectedNode = jMap.getSelecteds().getLastElement();
	var node = selectedNode && selectedNode.parent;
	// changeNodeGifFormat(selectedNode, false); // gif 동작 멈춤
	if (node) {
		J_NODE_CREATING = selectedNode;
		// 폴딩 필요할까? 필요없음.
//		node.folded && node.setFolding(false);
		var index = selectedNode.getIndexPos() + 1;
		var position = null;
		// Root노드 자식에서 추가될 경우 왼쪽 오른쪽 고려
		if (selectedNode.position && selectedNode.getParent().isRootNode()) 
			position = selectedNode.position;
		var param = {parent: node,				
				index: index,
				position: position,
				sibling: selectedNode}; //KHANG add sibling for handling location
		var newNode = jMap.createNodeWithCtrl(param);
		newNode.focus(true);

		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();

		newNode.setTextExecute("");
		jMap.controller.startNodeEdit(newNode);
	}
};

jCardController.prototype.insertAction = function() {
	var node = jMap.getSelecteds().getLastElement();
	if(!node) {
		node = jMap.getRootNode();
	}
	
	// changeNodeGifFormat(node, false); // gif 동작 멈춤
	
	// 2단계까지만 추가할 수 있도록 한다.
	var depth = node.getDepth();
	if(depth > 1) {
		JinoUtil.waitingDialogClose();
		alert("카드형 팝에서는 2단계 하위 토픽까지만 추가, 조회할 수 있습니다.\n형제(상위) 토픽을 추가해주세요.");
		return false;
	}
	
	if (node) {
		J_NODE_CREATING = node;
		node.folded && node.setFolding(false);
		var param = {parent: node};
		
		//KHANG
		if (node.children.length > 0)
			param.sibling = node.children[node.children.length - 1];
		//KHANG
		
		var newNode = jMap.createNodeWithCtrl(param);

		newNode.focus(true);

		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();

		newNode.setTextExecute("");
		jMap.controller.startNodeEdit(newNode);
	}
};


///////////////////////////////////////////////////////////////////////////////
////////////////////    jCardControllerGuest    ////////////////////
///////////////////////////////////////////////////////////////////////////////
jCardControllerGuest = function(map) {
	jCardControllerGuest.superclass.call(this, map);
};
extend(jCardControllerGuest, JinoControllerGuest);

jCardControllerGuest.prototype.type = "jCardControllerGuest";

jCardControllerGuest.prototype.foldingAction = function(node) {
};

jCardControllerGuest.prototype.resetCoordinateAction = function(node) {
};

jCardControllerGuest.prototype.foldingAllAction = function() {
};

jCardControllerGuest.prototype.unfoldingAllAction = function() {
};









///////////////////////////////////////////////////////////////////////////////
///////////////////////    jCardLayout    //////////////////////////
///////////////////////////////////////////////////////////////////////////////
jCardLayout = function(map) {
	var self = this;

	map.controller = map.mode ? new jCardController(map) : new jCardControllerGuest(map);

	self.map = map;
	self.HGAP = 20;
	self.VGAP = 20;
	self.CHILD_VGAP = 10; // default 2

	self.xSize = 0;
	self.ySize = 0;

	var work = self.map.work;
	work.scrollLeft = Math.round((work.scrollWidth - work.offsetWidth) / 2);
	work.scrollTop = 0;

	self.map.cfg.nodeFontSizes = [ '22', '18', '12', '9' ];
	self.map.cfg.nodeStyle = 'jCardNode';

	self.marginTop = 150;
	self.width = work.offsetWidth - 60;
	self.height = work.offsetHeight - 200;

	self.padding = 10;
	self.duration = 800;
	
	self.columns = [];
	self.columnWidth = 250;
	self.maxColumns = 4;
	
	// 맵의 크기
	self.width = RAPHAEL.getSize().width;
	self.height = RAPHAEL.getSize().height;

	self.columnCount = self.calColumnCount();

	// Card view topic
	self.topic = null;
	
	$(window).resize(self.resizedWindow);
};

jCardLayout.prototype.type = 'jCardLayout';

jCardLayout.prototype.resizedWindow = function() {
	if(jMap.layoutManager.type == 'jCardLayout') {
		if(jMap.layoutManager.topic != null) {
			jMap.layoutManager.topic.CalcBodySize();
		}

		var columnCount = jMap.layoutManager.calColumnCount();
		if(jMap.layoutManager.columnCount != columnCount) {
			jMap.layoutManager.columnCount = columnCount;
			jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
			
			var work = jMap.layoutManager.map.work;
			work.scrollLeft = Math.round((work.scrollWidth - work.offsetWidth) / 2);
		}
	}
}

jCardLayout.prototype.updateTreeHeightsAndRelativeYOfWholeMap = function() {
	this.initColumns(this.columnCount);
	
	for(var i = 0; i < this.columns.length; i++) {
		for (var j = 0; j < this.columns[i].length; j++) {
			this.updateTreeHeightsAndRelativeYOfDescendants(this.columns[i][j]);
		}
	}
	 
	this.layout(false);
};

// 화면에 들어갈 수 있는 컬럼 수를 계산한다.
jCardLayout.prototype.calColumnCount = function() {
	var windowWidth = $(window).width();
	var columnCount = parseInt(windowWidth / (this.columnWidth + this.HGAP));
	
	return Math.min(this.maxColumns, Math.max(columnCount, 1));
}

//root의 자식 노드들을 colums 배열에 넣는다.
jCardLayout.prototype.initColumns = function(columnCount) {
	this.columns = [];
	for(var i = 0; i < columnCount; i++) {
		this.columns[i] = [];
	}
	
	var column = 0;
	var rootNode = this.getRoot();
	var children = rootNode.getChildren();
	for (var i = 0; i < children.length; i++) {
		column = i % this.columns.length;
		children[i].column = column;
		if(this.columns[column])this.columns[column].push(children[i]);
			
	}
}

jCardLayout.prototype.updateTreeHeightsAndRelativeYOfDescendants = function(/*jNode*/ node) {
	// 루트로부터 깊이 2 까지만 표시하면 되므로 그 이하는 계산하지 않는다.
	if(node.getDepth() > 2) {
		return false;
	}
	var children = node.getUnChildren();
	if(children != null && children.length > 0){
		for(var i=0; i<children.length; i++) {
			this.updateTreeHeightsAndRelativeYOfDescendants(children[i]);
		}
	}
	
	this.updateTreeGeometry(node);
}

jCardLayout.prototype.updateTreeGeometry = function(/*jNode*/ node) {
	if (node == null || node == undefined || node.removed) return false;
	
	var children = node.getUnChildren();
	
	var treeWidth = this.calcTreeWidth(node, children);
	node.setTreeWidth(treeWidth);
	
	var treeHeight = this.calcTreeHeight(node, children);
	node.setTreeHeight(treeHeight);
}

jCardLayout.prototype.calcTreeWidth = function(/*jNode*/ parent, /*array*/ children) {
	return this.columnWidth;
}

jCardLayout.prototype.calcTreeHeight = function(/*jNode*/ node, /*array*/ children) {
	if(children == null || children.length == 0) {
		return node.getLayoutSize().height;
	}
	
	// 깊이 2인건 자기것만.. 자식은 계산 안함.
	if(node.getDepth() == 2) {
		return node.getLayoutSize().height;
	}

	var treeHeight = node.getLayoutSize().height;
	for(var i = 0; i < children.length; i++) {
		treeHeight += this.calcTreeHeight(children[i], children[i].getUnChildren()) + parseInt(this.CHILD_VGAP);
	}

	return treeHeight;
}

jCardLayout.prototype.updateTreeHeightsAndRelativeYOfAncestors = function( /*jNode*/ node) {
	this.updateTreeHeightsAndRelativeYOfDescendants(node);
};

jCardLayout.prototype.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors = function( /*jNode*/ node) {
	this.updateTreeHeightsAndRelativeYOfDescendants(node);
}

jCardLayout.prototype.layoutNode = function(/*jNode*/ node) {
	var centerLocation = jMap.layoutManager.getCenterLocation();
	var x = 0;
	var y = 0;
	
	if(node.getDepth() == 1) {
		x = centerLocation.x + node.column * this.columnWidth + node.column * this.HGAP;
		
		var prevNode = this.getPrevNodeInColumn(node, node.column);
		if(prevNode == null) {
			y = centerLocation.y;
		} else {
			y = prevNode.getLocation().y + prevNode.treeHeight + this.VGAP;
		}
	} else if(node.getDepth() == 2) {
		var prevNode = this.getPrevSibling(node);
		if(prevNode == null) {
			x = node.parent.getLocation().x;
			y = node.parent.getLocation().y + node.parent.getLayoutSize().height + this.CHILD_VGAP;
		} else {
			x = prevNode.getLocation().x;
			y = prevNode.getLocation().y + prevNode.treeHeight + this.CHILD_VGAP;
		}
	} else { // 나머지는 안보이게...
		x = -10000;
		y = -10000;
		node.hide();
		$(".jCard-"+node.getID()).hide();
	}

	node.setLocation(x, y);
	
	if((node.folded == "false" || node.folded == false)) {
		//var children = node.getUnChildren();
		var children = node.getChildren();
		if (children != null && children.length > 0) {
			for (var i = 0; i < children.length; i++) {
				this.layoutNode(children[i]);
			}
		}
	}
	
	// 맵 높이 계산...
	if(y + node.treeHeight > this.height) {
		this.height = y + node.treeHeight;
	}
}

jCardLayout.prototype.layout = function( /*boolean*/ holdSelected) {
	var selected = this.map.selectedNodes.getLastElement();
	
	holdSelected = holdSelected &&
	 (selected != null &&
			 selected != undefined &&
			 !selected.removed &&
			 selected.getLocation().x != null &&
			 selected.getLocation().x != undefined &&
			 selected.getLocation().x != 0 &&
			 selected.getLocation().y != 0);
	 
	var rootNode = this.getRoot();
	var oldRootX = rootNode.getLocation().x;
	var oldRootY = rootNode.getLocation().y;
	if(holdSelected) {
		oldRootY = selected.getLocation().y;
	}
	
	var children = this.getRoot().getUnChildren();
	if(children != null && children.length > 0){
		for(var i=0; i<children.length; i++) {
			this.layoutNode(children[i]);
		}
	}
	
	this.resizeMap(this.width, this.height);
	
	rootNode.setLocation(-10000, -10000);
	//rootNode.hide();
};

jCardLayout.prototype.getRoot = function() {
	return this.map.rootNode;
};



jCardLayout.prototype.resizeMap = function(/*int*/width, /*int*/height){
	var bResized = false;

	height += 80;	// .jino-menus-wrap offset
	
	var oldXSize = RAPHAEL.getSize().width;
	var oldYSize = RAPHAEL.getSize().height;
	
	var newXSize = 0;
	var newYSize = 0;
	
	//var locRoot = this.getRoot().getLocation();
	
	if(oldXSize < width) {
		newXSize = width * 2;
		bResized = true;
	}
	
	if(oldYSize < height) {
		newYSize = height * 2;
		bResized = true;
	}
	
	if(bResized) {
		if(newXSize == 0) {
			newXSize = oldXSize;
		}
		if(newYSize == 0) {
			newYSize = oldYSize;
		}
		RAPHAEL.setSize(newXSize, newYSize);
	}
}

jCardLayout.prototype.getPrevSibling = function(node) {
	if(node.isRootNode()) {
		return null;
	}

	var index = node.parent.children.indexOf(node);

	if(index < 1) return null;

	return node.parent.children[index - 1];
}

//
jCardLayout.prototype.getPrevNodeInColumn = function(node, i) {
	if(i === undefined) return null;
	var index = this.columns[i].indexOf(node);
	if(index < 1) return null;

	return this.columns[i][index - 1];
}

jCardLayout.prototype.getRootY = function() {
	var canvasSize = RAPHAEL.getSize();
	
	return Math.round( parseInt(canvasSize.height)*0.5) - parseInt(this.getRoot().body.getBBox().height)/2;
}

jCardLayout.prototype.getRootX = function() {
	var canvasSize = RAPHAEL.getSize();
	
	return Math.round( parseInt(canvasSize.width)*0.5) - parseInt(this.getRoot().body.getBBox().width)/2;
}

jCardLayout.prototype.getCenterLocation = function() {
	return {
		x : (RAPHAEL.getSize().width / 2) - (this.columns.length * this.columnWidth + (this.columns.length - 1) * this.HGAP) / 2,
		y : this.marginTop //(RAPHAEL.getSize().height / 2) - (this.height / 2) + this.marginTop
	};
};
