
/**
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */


CurveArrowLink = function(endNode){	
	CurveArrowLink.superclass.call(this, endNode);	
}

extend(CurveArrowLink, ArrowLink);
CurveArrowLink.prototype.type = "CurveArrowLink";

CurveArrowLink.prototype.draw = function() {
	if (this.removed) return false;
	
	var destNode = jMap.getNodeById(this.destination);
	
	// 대상 노드가 안보이는 경우는 그리지 않는다.
	if(destNode == null || destNode.hided) {
		return false;
	}
	
	var color = this.getColor();
	
	var startPort = this.startNode.getOutputPort();
	var endPort = destNode.getOutputPort();
	
	var startInclinations = this.startInclination.split(";");
	var endInclinations = this.endInclination.split(";");
	
	var x1 = startPort.x,
	    y1 = startPort.y,
	    x2 = endPort.x,
	    y2 = endPort.y,
	    cx1 = parseFloat(startPort.x) + parseFloat(startInclinations[0]),
	    cy1 = parseFloat(startPort.y) + parseFloat(startInclinations[1]),
	    cx2 = parseFloat(endPort.x) + parseFloat(endInclinations[0]),
	    cy2 = parseFloat(endPort.y) + parseFloat(endInclinations[1]);
	
	if(this.startNode.isLeft && this.startNode.isLeft()) {
		cx1 = parseFloat(startPort.x) - parseFloat(startInclinations[0]);
	}
	if(destNode.isLeft && destNode.isLeft()) {
		cx2 = parseFloat(endPort.x) - parseFloat(endInclinations[0]);
	}
	
	//<path class="SamplePath" d="M100,200 C100,100 250,100 250,200" />
	var path = ["M", x1.toFixed(3), y1.toFixed(3),
				"C", cx1, cy1, cx2, cy2, x2.toFixed(3), y2.toFixed(3)
				].join(",");
	
	this.line && this.line.attr({path: path, stroke: color});
	
	if(this.line){
		this.line.attr("stroke-dasharray", "20");
		this.line.attr("stroke-width", this.lineness);
		
//		this.line.attr("stroke", color);
	}
//	console.log(color);
	
	//Khang , id: this.id
	this.line && (this.line.node.id = this.id);	
	
	if(this.endArrow != "None") {
		var path2 = ["M", x2.toFixed(3), y2.toFixed(3),
		             "L", x2 + this.arrowWidth, y2 + this.arrowHeight, 
		             "L", x2 + this.arrowWidth, y2 - this.arrowHeight,
		             "L", x2, y2].join(",");
		
		if(destNode.isLeft && destNode.isLeft()) {
			path2 = ["M", x2.toFixed(3), y2.toFixed(3),
		             "L", x2 - this.arrowWidth, y2 + this.arrowHeight, 
		             "L", x2 - this.arrowWidth, y2 - this.arrowHeight,
		             "L", x2, y2].join(",");
		}
		
		this.arrowEnd && this.arrowEnd.attr({path: path2, stroke: color, fill: color});
	}
	
	if(this.startArrow != "None") {
		var path1 = ["M", x1.toFixed(3), y1.toFixed(3),
		             "L", x1 + this.arrowWidth, y1 + this.arrowHeight, 
		             "L", x1 + this.arrowWidth, y1 - this.arrowHeight,
		             "L", x1, y1].join(",");
		
		if(destNode.isLeft && destNode.isLeft()) {
			path1 = ["M", x1.toFixed(3), y1.toFixed(3),
		             "L", x1 - this.arrowWidth, y1 + this.arrowHeight, 
		             "L", x1 - this.arrowWidth, y1 - this.arrowHeight,
		             "L", x1, y1].join(",");
		}
		this.arrowStart && this.arrowStart.attr({path: path1, stroke: color, fill: color});
	}
	
	// branch Text
	
	if (!this.hided && this.text != "" && this.text != null && this.text.node != undefined) {
		this.text.show();
		this.text.attr({"text-anchor": "middle"});
		var x3 = cx1;
		var x4 = cx2;
		var y3 = cy1;
		var y4 = cx2;
	    var text_path;
	    var offset = 50;
	    var dx = (y4 - y1);
	    var dy = -(x4 - x1);
	    var norm = Math.sqrt(dx*dx + dy*dy);
	    if (norm === 0.0)
	    	norm = 1;
	    dx *= 5.0/norm;
	    dy *= 5.0/norm;

	    var isTop = y1 > y2;
	    var isLeft = x1 > x2;
		if (isTop) {
			if(isLeft){
				text_path = ["M", x1.toFixed(3), y1.toFixed(3),
					"C", cx1, cy1, cx2, cy2, x2.toFixed(3), y2.toFixed(3)
					].join(",");
		    	dx = -dx;
//		    	dy = -dy;
			}else{
				text_path = ["M", x1.toFixed(3), y1.toFixed(3),
					"C", cx1, cy1, cx2, cy2, x2.toFixed(3), y2.toFixed(3)
					].join(",");
		    	dx = -dx;
		    	dy = -dy;
			}

	    } else {
	    	if(isLeft){
	    		text_path = ["M", x1.toFixed(3), y1.toFixed(3),
					"C", cx1, cy1, cx2, cy2, x2.toFixed(3), y2.toFixed(3)
					].join(",");
	    	}else{
	    		text_path = ["M", x1.toFixed(3), y1.toFixed(3),
					"C", cx1, cy1, cx2, cy2, x2.toFixed(3), y2.toFixed(3)
					].join(",");
	    	}
	    }
		
	    this.text_line.attr({path: text_path, transform: "t" + dx.toFixed(3) + "," + dy.toFixed(3)});
		this.text.node.innerHTML = '<textPath startOffset="' + offset + '%" xlink:href="#' + this.text_line.node.id + '">' + this.txt + '</textPath>';
	}
}