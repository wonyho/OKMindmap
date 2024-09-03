/**
 * @author Jinhoon
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */
var NEWACTIONASYNC = false;
var STARTWAITASYNC = Date.now();
var MUSTTORUN = false;
var ASYNCACTION = false;
jMindMapLayout = function (map){
	this.map = map;
	this.HGAP = 30;
	this.VGAP = 10;
	
	this.xSize = 0;
	this.ySize = 0;
	
	// 가운데가 보이게...
	var work = this.map.work;
	work.scrollLeft = Math.round( (work.scrollWidth - work.offsetWidth)/2 );
	work.scrollTop = Math.round( (work.scrollHeight - work.offsetHeight)/2 );
	
	this.map.cfg.nodeFontSizes = ['22', '18', '12'];
	this.map.cfg.nodeStyle = "jRect";
}

jMindMapLayout.prototype.type = "jMindMapLayout";
jMindMapLayout.prototype.defaultBranchStyle = "jLineBezier";

jMindMapLayout.prototype.svgCompute = function(node) {
	
	var x = 0;
	var hgap = node.hgap;
	if (isNaN(hgap)) hgap = 0;
	if(node.isRootNode()) {
		x = 0;
	} else if(node.isLeft()) {
		x = -hgap - parseInt(node.body.getBBox().width) - parseInt(this.HGAP);
	} else {
		x = parseFloat(node.parent.body.getBBox().width) + parseFloat(hgap) + parseInt(this.HGAP);
	}
	
	this.computeNode(node, x, node.relYPos);
	node.changedYPos = false;
	node.loadingNode = false;
	
	if(node.folded == "false" || node.folded == false) {
		var children = node.getChildren();
		if (children != null && children.length > 0) {
			for (var i = 0; i < children.length; i++) {
				this.svgCompute(children[i]);
			}
		}
	}
}

jMindMapLayout.prototype.svgRedraw = function(node) {
	this.placeNode(node);
	if(node.folded == "false" || node.folded == false) {
		var children = node.getChildren();
		if (children != null && children.length > 0) {
			for (var i = 0; i < children.length; i++) {
				if(NEWACTIONASYNC && !MUSTTORUN) break;
				this.svgRedraw(children[i]);
				// ArrowLink Update
				children[i].connectArrowLink();
				var alinks = jMap.getArrowLinks(children[i]);
				for(var j = 0; j < alinks.length; j++) {
					 if(alinks[j] != undefined) alinks[j].draw();
				}
			}
		}
	}
	this.updateEditorPosition(node);
}

//jMindMapLayout.prototype.svgRedrawAsync = function(){
//	return new Promise((resolve) => {
//		this.svgRedraw(this.getRoot());
//	  });
//}
jMindMapLayout.prototype.updateEditorPosition = function(node){
	if($("#nodeEditor").css("display") == "none") return;
	var selected = this.map.selectedNodes.getLastElement();
	var oInput = $("#nodeEditor");
	if(selected != undefined && oInput != undefined && node.body.getBBox() != null){
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
		var left = (selected.body.getBBox().x - viewBox.x) * RAPHAEL.getSize().width / viewBox.width + 1;
		if(node.isLeft() == selected.isLeft()){
			var top = (selected.body.getBBox().y - viewBox.y) * RAPHAEL.getSize().height / viewBox.height - 1;
		}else{
			var top = (selected.body.getBBox().y - viewBox.y) * RAPHAEL.getSize().height / viewBox.height + 1;
		}
		
		$("#nodeEditor").css("left", left + "px");
		$("#nodeEditor").css("top", top + "px");
	}
}

jMindMapLayout.prototype.layoutNode = function(node) {
//	var start = Date.now();
	this.svgCompute(node);
//	var end = Date.now();
//	console.log('svg-compute: ' + (end-start) + ' ms');
	
//	only run when active user have active actions
	if(!ASYNCACTION){
//		start = Date.now();
		this.svgRedraw(node);
//		end = Date.now();
//		console.log('svg-paint: ' + (end-start) + ' ms');
	}
}

jMindMapLayout.prototype.layout = function(/*boolean*/ holdSelected) {
	var selected = this.map.selectedNodes.getLastElement();

	holdSelected = holdSelected &&
	 (selected != null &&
			 selected != undefined &&
			 !selected.removed &&
			 selected.px != null &&
			 selected.px != undefined &&
			 selected.px != 0 &&
			 selected.py != 0);
	
	var rootNode = this.getRoot();
	var oldRootX = rootNode.px;
	var oldRootY = rootNode.py;
	if(holdSelected) {
		oldRootY = selected.py;
	}
	
//	var start = Date.now();
	this.resizeMap(rootNode.treeWidth, rootNode.treeHeight);
//	var end = Date.now();
//	console.log('resize-map: ' + (end-start) + ' ms');

	var ENDWAITASYNC = Date.now();
	if(ENDWAITASYNC - STARTWAITASYNC > 3000) {
		MUSTTORUN = true;
		this.layoutNode(rootNode);
		STARTWAITASYNC = Date.now();
		MUSTTORUN = false;
	}else{
		this.layoutNode(rootNode);
	}
	
	
//	console.log('========================='); 
}

jMindMapLayout.prototype.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors = function(/*jNode*/ node) {
	var start = Date.now();
	this.updateTreeHeightsAndRelativeYOfDescendants(node);
	if (! node.isRootNode())
       this.updateTreeHeightsAndRelativeYOfAncestors(node.getParent()); 
	var end = Date.now();
//	console.log('update-node: ' + (end-start) + ' ms');
}

jMindMapLayout.prototype.updateTreeHeightsAndRelativeYOfAncestors = function(/*jNode*/ node) {
	this.updateTreeGeometry(node);
	if (!node.isRootNode()) {
		this.updateTreeHeightsAndRelativeYOfAncestors(node.getParent());
	}
}

jMindMapLayout.prototype.updateTreeHeightsAndRelativeYOfWholeMap = function() {
	this.updateTreeHeightsAndRelativeYOfDescendants(this.getRoot()); 
	this.layout(false);
}

jMindMapLayout.prototype.updateTreeHeightsAndRelativeYOfDescendants = function(/*jNode*/ node) {
	var children = node.getUnChildren();
	if(children != null && children.length > 0){
		for(var i=0; i<children.length; i++) {
			this.updateTreeHeightsAndRelativeYOfDescendants(children[i]);
		}
	}
	
	this.updateTreeGeometry(node);
}

jMindMapLayout.prototype.updateRelativeYOfChildren = function(/*jNode*/ node, /*Array*/ children) {
	if(children == null || children.length == 0)
		return;
	
	var vgap = node.vgap;
	var child = children[0];
	var pointer = 0;
	var upperShift = 0;
	for(var i = 0; i < children.length; i++) {
		child = children[i];
		var shiftUp = this.getShiftUp(child);
		var shiftDown = this.getShiftDown(child);
		var upperChildShift = child.getUpperChildShift();
		
		var newYPos = parseInt(pointer) + parseInt(upperChildShift) + parseInt(shiftDown);
		if(newYPos != child.relYPos || child.loadingNode || child.isRootNode()){
			child.relYPos = parseInt(pointer) + parseInt(upperChildShift) + parseInt(shiftDown);
			child.changedYPos = true;
		}
		
		upperShift += parseInt(upperChildShift) + parseInt(shiftUp);
		
		pointer +=  parseInt(child.getTreeHeight())+ parseInt(shiftUp)
				+ parseInt(shiftDown) + parseInt(vgap) + this.VGAP;
	}
	upperShift += parseInt(this.calcStandardTreeShift(node, children));
	for (var i = 0; i < children.length; i++) {
		child = children[i];
		child.relYPos -= upperShift;
		if(upperShift != 0 || child.loadingNode || child.isRootNode()) child.changedYPos = true;
	}
	
}

jMindMapLayout.prototype.getShiftUp = function(/*jNode*/ node) {
	var shift = node.getShift();
	if(shift < 0) {
		return -shift;
	} else {
		return 0;
	}
}

jMindMapLayout.prototype.getShiftDown = function(/*jNode*/ node) {
	var shift = node.getShift();
	if(shift > 0) {
		return shift;
	} else {
		return 0;
	}
}

jMindMapLayout.prototype.updateTreeGeometry = function(/*jNode*/ node) {
	if (node == null || node == undefined || node.removed) return false;
	
	if(node.isRootNode()) {
		var leftNodes = this.getRoot().getLeftChildren();
		var rightNodes = this.getRoot().getRightChildren();
		
		var leftWidth = this.calcTreeWidth(node, leftNodes);
		var rightWidth = this.calcTreeWidth(node, rightNodes);
		
		this.getRoot().setRootTreeWidths(leftWidth, rightWidth);
		
		this.updateRelativeYOfChildren(node, leftNodes);
		this.updateRelativeYOfChildren(node, rightNodes);
		
		var leftTreeShift = this.calcUpperChildShift(node, leftNodes);
		var rightTreeShift = this.calcUpperChildShift(node, rightNodes);
		
		this.getRoot().setRootUpperChildShift(leftTreeShift, rightTreeShift);
		
		var leftTreeHeight = this.calcTreeHeight(node, leftTreeShift, leftNodes);
		var rightTreeHeight = this.calcTreeHeight(node, rightTreeShift, rightNodes);
		
		this.getRoot().setRootTreeHeights(leftTreeHeight, rightTreeHeight);
	} else {
		var children = node.getUnChildren();
		
		var treeWidth = this.calcTreeWidth(node, children);
		node.setTreeWidth(treeWidth);
		
		this.updateRelativeYOfChildren(node, children);
		
		var treeShift = this.calcUpperChildShift(node, children);
		node.setUpperChildShift(treeShift);
		
		var treeHeight = this.calcTreeHeight(node, treeShift, children);
		node.setTreeHeight(treeHeight);
	}
}

jMindMapLayout.prototype.calcTreeWidth = function(/*jNode*/ parent, /*array*/ children) {
	var treeWidth = 0;
	if (children != null && children.length > 0) {
		for (var i = 0; i < children.length; i++) {
			var childNode = children[i];
			if (childNode != null) { 
				var childWidth = parseInt(childNode.getTreeWidth()) + parseInt(childNode.hgap) + this.HGAP;
				if (childWidth > treeWidth) {
					treeWidth = childWidth;
				}
			}
		}
	}
	return parent.getLayoutSize().width + treeWidth;
}

jMindMapLayout.prototype.calcTreeHeight = function(/*jNode*/ parent, /*int*/ treeShift, /*array*/ children) {
	var parentHeight = parent.getLayoutSize().height;
	try {
		var firstChild = children[0];
		var lastChild = children[children.length - 1];
		
		var minY = Math.min(firstChild.relYPos - firstChild.getUpperChildShift(), 0);
		var maxY = Math.max(lastChild.relYPos - lastChild.getUpperChildShift() + lastChild.getTreeHeight(), parentHeight);
		
		return maxY - minY;
	} catch (err) {
		return parentHeight;
	}
}

jMindMapLayout.prototype.calcUpperChildShift = function(/*jNode*/ node, /*Array*/ children) {
	try {
		var firstChild = children[0];
		
		var childShift = -firstChild.relYPos + parseInt(firstChild.getUpperChildShift());
		if(childShift > 0) {
			return childShift;
		} else {
			return 0;
		}
	} catch (err) {
		return 0;
	}
}

jMindMapLayout.prototype.calcStandardTreeShift = function(/*jNode*/parent, /*Array*/ children){
	var parentHeight = parent.getLayoutSize().height;
	if(children.length == 0) {
		return 0;
	}
	
	var height = 0;
	var vgap = parent.vgap;
	for(var i = 0; i < children.length; i++) {
		var node = children[i];
		if(node != null) {
			height += parseInt(node.getLayoutSize().height) + parseInt(vgap);
		}
	}
	
	return Math.max(parseInt(height) - parseInt(vgap) - parseInt(parentHeight), 0)/2;
	//return (parseInt(height) - parseInt(vgap) - parseInt(parentHeight) + this.VGAP * (children.length -1))/2;
}

jMindMapLayout.prototype.computeNode = function(/*jNode*/ node, /*int*/relativeX, /*int*/relativeY) {
	if (node.isRootNode()) {
		node.px = this.getRootX();
		node.py = this.getRootY();
	} else {
		node.px = parseFloat(node.parent.px) + parseFloat(relativeX);
		node.py = parseFloat(node.parent.py) + parseFloat(relativeY);
	}
	
}

jMindMapLayout.prototype.placeNode = function(node) {
//	if(node.px != node.getLocation().x || node.py != node.getLocation().y){
		node.setLocation(node.px, node.py);
//	}
}

//jMindMapLayout.prototype.placeNode = function(/*jNode*/ node, /*int*/relativeX, /*int*/relativeY) {
//	if (node.isRootNode()) {
//		node.setLocation(this.getRootX(), this.getRootY());
//	} else {
//		var x = parseFloat(node.parent.getLocation().x) + parseFloat(relativeX);
//		var y = parseFloat(node.parent.getLocation().y) + parseFloat(relativeY);
//		node.setLocation(x, y);
//	}
//}

jMindMapLayout.prototype.resizeMap = function(/*int*/width, /*int*/height){
	height += 80;	// .jino-menus-wrap offset	
	var oldXSize = RAPHAEL.getSize().width;
	var oldYSize = RAPHAEL.getSize().height;

	var bResized = false;
	var hasChanged = false;
	
	
	var newXSize = 0;
	var newYSize = 0;
	
	var locRoot = this.getRoot().getLocation();
	
	if(oldXSize < width * 2) {
		newXSize = width * 2;
		newYSize = oldYSize;
		bResized = true;
	}
	
	if(oldYSize < height * 2) {
		newXSize = oldXSize;
		newYSize = height * 2;
		bResized = true;
		hasChanged = true;
		this.computeNode(this.getRoot());
	}
	//보이는 위치를 바꿔준다.
	if(bResized) {
		RAPHAEL.setSize(newXSize, newYSize);
		this.computeNode(this.getRoot(), this.getRootX(), this.getRootY());
		
		this.map.work.scrollLeft += (newXSize - oldXSize)/2;
		this.map.work.scrollTop += (newYSize - oldYSize)/2;
	}
	
	return hasChanged;
}

jMindMapLayout.prototype.getRootY = function() {
	var canvasSize = RAPHAEL.getSize();
	
	return Math.round( parseInt(canvasSize.height)*0.5) - parseInt(this.getRoot().body.getBBox().height)/2;
}

jMindMapLayout.prototype.getRootX = function() {
	var canvasSize = RAPHAEL.getSize();
	
	return Math.round( parseInt(canvasSize.width)*0.5) - parseInt(this.getRoot().body.getBBox().width)/2;
}

jMindMapLayout.prototype.getRoot = function() {
	return this.map.rootNode;
}

