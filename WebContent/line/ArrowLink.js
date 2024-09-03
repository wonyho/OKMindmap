
/**
 *
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */

///////////////////////////////////////////////////////////////////////////////
/////////////////////////// ArrowLink ///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

ArrowLink = function (endNode) {
	this.startNode = null;

	this.color = "#006600";
	this.destination = endNode?endNode.id:null;
	this.destinationNode = endNode?endNode:null;
	this.endArrow = "Default";
	this.endInclination = "129;0;";
	this.id = this.createID();
	this.startArrow = "None";
	this.startInclination = "129;0;";
	
	//화살표 크기
	this.arrowWidth = 15;
	this.arrowHeight = 8;
	this.defaultColor = "#ff0000";
	
	
	this.line = RAPHAEL.path().attr({stroke: this.color, fill: "none"});
    this.arrowEnd = RAPHAEL.path().attr({stroke: this.color, fill: this.defaultColor});
    this.arrowStart = RAPHAEL.path().attr({stroke: this.color, fill: this.defaultColor});

	//this.line.toBack();
	
	this.hided = false;
	this.lineness = 4;
	this.txt = "";
	this.text_line = RAPHAEL.path().attr({stroke: "transparent", fill: "transparent"});
    this.text_line.node.id = "line_" + this.id;
    this.text = RAPHAEL.text();
    this.style = "";
}

ArrowLink.prototype.type= "ArrowLink";
/*
ArrowLink function (node1, node2){
	ArrowLink.superclass.call(this, node1, node2);
	
	this.color = null;
	this.destination = null;
	this.endArrow = null;
	this.endInclination = null;
	this.id = null;
	this.startArrow = null;
	this.startInclination = null;
}

extend(ArrowLink, jLine);
ArrowLink.prototype.type= "ArrowLink";
*/

ArrowLink.prototype.remove = function() {
	if (this.removed) return false;
	
	this.line.remove();
	this.arrowEnd.remove();
	this.arrowStart.remove();
		
	this.removed = true;
	
	return true;
}

ArrowLink.prototype.hide = function() {
	this.line.hide();
	this.arrowEnd.hide();
	this.arrowStart.hide();
	
	this.hided = true;
}

ArrowLink.prototype.show = function() {
	this.line.show();
	this.arrowEnd.show();
	this.arrowStart.show();
		
	this.hided = false;
}

ArrowLink.prototype.getColor = function() {
	if(this.color != null) {
		return this.color;
	} else {
		return this.defaultColor;
	}
}

ArrowLink.prototype.setColor = function(color) {
	this.color = color;
}

ArrowLink.prototype.setLineWidth = function(width) {
	width == null ? this.lineness = 4 : this.lineness = width;
	console.log(width);
}

ArrowLink.prototype.getLineWidth = function() {
	return this.lineness;
}

ArrowLink.prototype.setText = function(t) {
	t == null ? this.txt = "" : this.txt = t;
}

ArrowLink.prototype.getText = function() {
	return this.txt;
}

ArrowLink.prototype.setStyle = function(t) {
	if(t=="1") this.style = "line";
	else if(t=="2") this.style = "dask";
}

ArrowLink.prototype.getStyle = function() {
	if(this.style="line") return 1;
	return 2;
}

ArrowLink.prototype.setStart = function(start) {
	if(start){
		this.startArrow = "Default";
	}else{
		this.startArrow = "None";
	}
}

ArrowLink.prototype.getStart = function() {
	if(this.startArrow == "None") return 1;
	return 2;
}

ArrowLink.prototype.setEnd = function(end) {
	if(end){
		this.endArrow = "Default";
	}else{
		this.endArrow = "None";
	}
}

ArrowLink.prototype.getEnd = function() {
	if(this.endArrow == "None") return 1;
	return 2;
}


ArrowLink.prototype.createID = function(){
	var id = "";
	while(!jMap.checkID(id)) id = "Arrow_ID_" + parseInt(Math.random()*2000000000);
	return id;
}

// <arrowlink DESTINATION="ID_389929301" ENDARROW="Default" ENDINCLINATION="129;0;" ID="Arrow_ID_1225745029" STARTARROW="None" STARTINCLINATION="129;0;"/>
ArrowLink.prototype.toXML = function(){
	var buffer = new StringBuffer();
	buffer.add("<arrowlink");
	buffer.add(" DESTINATION=\"" + this.destination +"\"");
	if(this.color != null) {
		buffer.add("COLOR=\"" + this.color +"\"");
	}
	if(this.endArrow != null) {
		buffer.add(" ENDARROW=\"" + this.endArrow +"\"");
	}
	if(this.endInclination != null) {
		buffer.add(" ENDINCLINATION=\"" + this.endInclination +"\"");
	}
	if(this.id != null) {
		buffer.add(" ID=\"" + this.id +"\"");
	}
	if(this.startArrow != null) {
		buffer.add(" STARTARROW=\"" + this.startArrow +"\"");
	}
	if(this.startInclination != null) {
		buffer.add(" STARTINCLINATION=\"" + this.startInclination +"\"");
	}
	if(this.lineness != null) {
		buffer.add(" LINEWIDTH=\"" + this.lineness +"\"");
	}
	if(this.text != "") {
		buffer.add(" TEXT=\"" + this.txt +"\"");
	}
	if(this.style != "") {
		buffer.add(" STYLE=\"" + this.style +"\"");
	}
	buffer.add("/>")
	return buffer.toString("\n");
}

//interface
ArrowLink.prototype.draw = function() {}

