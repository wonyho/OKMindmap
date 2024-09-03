/**
 * 
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */

jHTreeLayout = function (map){
	this.map = map;
	this.HGAP = 20; 
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

jHTreeLayout.prototype.type = "jHTreeLayout";
jHTreeLayout.prototype.defaultBranchStyle = "jLinePolygonal2";

jHTreeLayout.prototype.layoutNode = function(/*jNode*/ node) {
	var y = 0;
	var hgap = node.hgap;
	if (isNaN(hgap)) hgap = 0;
	if(node.isRootNode()) {
		y = 0;
	} else {
		y = parseFloat(hgap);
	}


	this.placeNode(node, node.vshift, y);
	
	// ArrowLink Update
	node.connectArrowLink();
	//나를 가르키는 arrowlink들에 대해 connect를 다시 한다.
	var alinks = jMap.getArrowLinks(node);
	for(var i = 0; i < alinks.length; i++) {
		alinks[i].draw();
	}
	
	if(node.folded == "false" || node.folded == false) {
		//var children = node.getUnChildren();
		var children = node.getChildren();
		if (children != null && children.length > 0) {
			for (var i = 0; i < children.length; i++) {
				this.layoutNode(children[i]);
			}
		}
	}
}

jHTreeLayout.prototype.layout = function(/*boolean*/ holdSelected) {
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
	
	this.resizeMap(rootNode.treeWidth, rootNode.treeHeight);
	this.layoutNode(this.getRoot());
}

jHTreeLayout.prototype.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors = function(/*jNode*/ node) {

	this.updateTreeHeightsAndRelativeYOfDescendants(node);
	if (! node.isRootNode()) {
       this.updateTreeHeightsAndRelativeYOfAncestors(node.getParent());
	}
}

jHTreeLayout.prototype.updateTreeHeightsAndRelativeYOfAncestors = function(/*jNode*/ node) {
	this.updateTreeGeometry(node);

	if (!node.isRootNode()) {
		this.updateTreeHeightsAndRelativeYOfAncestors(node.getParent());
	}
}

jHTreeLayout.prototype.updateTreeHeightsAndRelativeYOfWholeMap = function() {
	this.updateTreeHeightsAndRelativeYOfDescendants(this.getRoot()); 
	this.layout(false);
}

jHTreeLayout.prototype.updateTreeHeightsAndRelativeYOfDescendants = function(/*jNode*/ node) {
	var children = node.getUnChildren();
	if(children != null && children.length > 0){
		for(var i=0; i<children.length; i++) {
			this.updateTreeHeightsAndRelativeYOfDescendants(children[i]);
		}
	}
	
	this.updateTreeGeometry(node);
}


jHTreeLayout.prototype.updateTreeGeometry = function(/*jNode*/ node) {
	if (node == null || node == undefined || node.removed) return false;
	
	var children = node.getUnChildren();
	
	// width
	var treeWidth = this.calcTreeWidth(node, children);
	node.setTreeWidth(treeWidth);

	// height
	var treeHeight = this.calcTreeHeight(node, children);
	node.setTreeHeight(treeHeight);	
}

jHTreeLayout.prototype.calcTreeWidth = function(/*jNode*/ parent, /*array*/ children) {
	// (children의 width + hgap) + this.HGAP * (children.length - 1) 와 parent.width 비교해서 큰 값

	var parentWidth = parent.getSize().width;
	if(children == null || children.length == 0) {
		return parentWidth;
	}

	var child = null;
	var treeWidth = 0;
	for(var i = 0; i < children.length; i++) {
		child = children[i];
		treeWidth += parseInt(child.getTreeWidth()) + parseInt(child.vshift);
	}
	treeWidth += parseInt(this.HGAP) * parseInt(children.length -1);

	return Math.max(parentWidth, treeWidth);
}

jHTreeLayout.prototype.calcTreeHeight = function(/*jNode*/ parent, /*array*/ children) {
	// leaf 노드까지 높이를 계산한다.
	if(children == null || children.length == 0) {
		return parent.getLayoutSize().height;
	}

	var treeHeight = parent.getLayoutSize().height;
	for(var i = 0; i < children.length; i++) {
		treeHeight += this.calcTreeHeight(children[i], children[i].getUnChildren()) + parseInt(children[i].hgap) + parseInt(this.VGAP);
	}

	return treeHeight;
}


jHTreeLayout.prototype.placeNode = function(/*jNode*/ node, /*int*/relativeX, /*int*/relativeY) {
	
	if (node.isRootNode()) {
		node.setLocation(this.getRootX(), this.getRootY());
	} else {

		var x = 0;
		var y = 0;

		var prevNode = this.getPrevSibling(node);
		var parent = node.getParent();
		x = parseInt(parent.getLocation().x) + parseInt(parent.getSize().width/2) + parseFloat(this.HGAP) + parseFloat(relativeX);
		
		var dy = 0;
		if(prevNode == null) {
			dy = (parseInt(node.parent.getLayoutSize().height) - parseInt(node.parent.getSize().height))/2;
			y = parseFloat(node.parent.getLocation().y - dy) + parseFloat(node.parent.getLayoutSize().height) + parseFloat(relativeY) + parseFloat(this.VGAP);
		} else {
			dy = (parseInt(prevNode.getLayoutSize().height) - parseInt(prevNode.getSize().height))/2;
			y = parseInt(prevNode.getLocation().y - dy) + parseInt(prevNode.getTreeHeight())  + parseFloat(relativeY) + parseInt(this.VGAP);//;
		}
		
		node.setLocation(x, y);
	}
	
}

jHTreeLayout.prototype.resizeMap = function(/*int*/width, /*int*/height){
	var bResized = false;

	height += 80;	// .jino-menus-wrap offset
	
	var oldXSize = RAPHAEL.getSize().width;
	var oldYSize = RAPHAEL.getSize().height;
	
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
		
		this.placeNode(this.getRoot());
	}

	//보이는 위치를 바꿔준다.
	if(bResized) {
		RAPHAEL.setSize(newXSize, newYSize);
		this.placeNode(this.getRoot(), this.getRootX(), this.getRootY());
		
		this.map.work.scrollLeft += (newXSize - oldXSize)/2;
		this.map.work.scrollTop += (newYSize - oldYSize)/2;
	}
}

jHTreeLayout.prototype.getRootY = function() {
	var canvasSize = RAPHAEL.getSize();
	
	return Math.round( parseInt(canvasSize.height)*0.5) - parseInt(this.getRoot().body.getBBox().height)/2;
}

jHTreeLayout.prototype.getRootX = function() {
	var canvasSize = RAPHAEL.getSize();
	
	return Math.round( parseInt(canvasSize.width)*0.5) - parseInt(this.getRoot().body.getBBox().width)/2;
}

jHTreeLayout.prototype.getRoot = function() {
	return this.map.rootNode;
}


jHTreeLayout.prototype.getPrevSibling = function(node) {
	if(node.isRootNode()) {
		return null;
	}

	var index = node.parent.children.indexOf(node);

	if(index < 1) return null;

	return node.parent.children[index - 1];
}
