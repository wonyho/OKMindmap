/**
 * 
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */

NodeColorMix = (function () {	
	var indexColor = 0;
	// var iColor = ["#FFF2F2","#FFFAF2","#FAFAED","#F5FFF2","#F2FFF8","#F2FFFF","#F2F8FF","#F5F2FF","#FAF2FF","#FFF2FD"];
	var iColor = ["#c4a0b3","#829ddb","#8ee583","#b99688","#87bdf9","#f2c398","#9287c2","#d886bf","#a88490","#bcf3b0"];
	var eColor = ["#FF6666","#FFAC33","#BEBE02","#6DB847","#00CC52","#22DDDD","#4D95FF","#9880FF","#CD80FF","#FF66E5"];
	var rootColor = "#660000",
	    rootEdgeColor = "#4C0000",
		rootTextColor = "#ffffff";
	//var iColor = ["#fbcd32","#3174bd","#88c0a5","#dc345d","#f99c0a","#f9793f","#f64944","#aa4f73","#775d95","#83b243","#d8e037","#fdf446"];
	var fadeFactor = 0.1,	// 단계마다 색상이 옅어지는 정도
		darkFactor = 0.25,	// 색상이 짙어지는 정도: 마디의 외곽선을 그릴 때 사용
		randFactor = 30;  // 형제끼리 서로 다른 색상을 random 화하게되는 정도
	var colorListSize = 0;

	var branchWidths = [3, 3, 2, 1];
	
	function NodeColorMix(node, color){
		
		if(!jMap.isAllowNodeEdit(node)) {
			return false;
		}
		
		
		if(color != undefined){
			colorListSize = color.length;
			jMap.indexColor = 0;
			setAllDressColor(node, color);
		}else{
			dressColor(node);
		}
		
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
		jMap.layoutManager.layout(true);
		/*(typeof DWR_sendForceRefresh != "undefined")&& DWR_sendForceRefresh(jMap.cfg.userId);*/
	}
	
	// 노드에 색상 입히기
	function dressColor(node){
		//var fontSize = '10';
		var fontWeight = 400;
		if (node.isRootNode()) {		// 루트
			node.setBackgroundColor(rootColor);
			node.setEdgeColor(rootEdgeColor);
			node.setTextColor(rootTextColor);
			
			// node.fontSize = jMap.cfg.nodeFontSizes[0];
			// fontWeight = 'bold';
		} else if (node.getParent().isRootNode()) {		// 깊이 1
			// jMap.indexColor = jMap.indexColor % iColor.length;
			// color = iColor[jMap.indexColor];
			// jMap.indexColor++;		
			color = iColor[Math.floor(Math.random() * iColor.length)];
			node.setBackgroundColor(color);
			node.setEdgeColor(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor));
			node.setBranch(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor));
			
			// node.fontSize = jMap.cfg.nodeFontSizes[1];
			// fontWeight = 'bold';
		}
		else {		// 나머지
			var parentColor = Raphael.getRGB(node.getParent().background_color);
			var color = NodeColorUtil.randomer(Raphael.getRGB(NodeColorUtil.brighter(parentColor, fadeFactor)), randFactor);
			node.setBackgroundColor(color);
			node.setEdgeColor(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor));
			node.setBranch(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor));
			
			// node.fontSize = jMap.cfg.nodeFontSizes[2];
			// fontWeight = 'normal';
		}
		
		// node.text.attr({'font-size': node.fontSize, "font-weight": fontWeight});
		// node.CalcBodySize();
		
		if(node.getChildren().length > 0) {
			var children = node.getChildren();
			for(var i = 0; i < children.length; i++) {
				if(!node.folded) dressColor(children[i]);			
			}
		}
	}
	
	function setAllDressColor(node, color){
		//var fontSize = '10';
		var fontWeight = 400;
		
		if (node.isRootNode()) {	// 루트			
			node.setEdgeColor(rootEdgeColor);
			node.setBackgroundColor(rootColor);
			node.setTextColor(rootTextColor);
			
			// node.fontSize = jMap.cfg.nodeFontSizes[0];
			// fontWeight = 'bold';
			
		} else if (node.getParent().isRootNode()) {		// 깊이 1
			
			// edgeColor = color[jMap.indexColor]; // 전달받은 테마색상
			// backColor = iColor[jMap.indexColor]; // jmap의 기본 배경색
			// jMap.indexColor++;	
			
			// if(jMap.indexColor > colorListSize ){ // 노드가 10개이상일 경우 색상배열 위치 초기화
			// 	jMap.indexColor = 0;
			// }
			
			// node.setBackgroundColor(backColor);
			// node.setEdgeColor(edgeColor);
			// node.setBranch(edgeColor);

			jMap.indexColor = jMap.indexColor % iColor.length;
			var bgcolor = color[jMap.indexColor];
			jMap.indexColor++;
			node.setBackgroundColor(bgcolor);
			node.setEdgeColor(NodeColorUtil.darker(Raphael.getRGB(bgcolor), darkFactor));
			node.setBranch(NodeColorUtil.darker(Raphael.getRGB(bgcolor), darkFactor));
			
			// node.fontSize = jMap.cfg.nodeFontSizes[1];
			// fontWeight = 'bold';
			
		} else {	// 나머지
			// node.setBackgroundColor(node.getParent().background_color);
			// node.setEdgeColor(node.getParent().edge.color);
			// node.setBranch(node.getParent().edge.color);

			var parentColor = Raphael.getRGB(node.getParent().background_color);
			var bgcolor = NodeColorUtil.randomer(Raphael.getRGB(NodeColorUtil.brighter(parentColor, fadeFactor)), randFactor);
			node.setBackgroundColor(bgcolor);
			node.setEdgeColor(NodeColorUtil.darker(Raphael.getRGB(bgcolor), darkFactor));
			node.setBranch(NodeColorUtil.darker(Raphael.getRGB(bgcolor), darkFactor));
			
			// node.fontSize = jMap.cfg.nodeFontSizes[2];
			// fontWeight = 'normal';
		}
		
		// node.text.attr({'font-size': node.fontSize, "font-weight": fontWeight});
		// node.CalcBodySize();
		
		var isEnd = true;
		
		if(node.getChildren().length > 0) {
			var children = node.getChildren();	
			isEnd = false;
			for(var i = 0; i < children.length; i++) {
				if(!node.folded) setAllDressColor(children[i], color);
			}			
		}
		if(isEnd){
			//JinoUtil.waitingDialogClose();
		}
	}
	
	NodeColorMix.rawDressColor = function(node) {
		if (node.isRootNode()) {
			node.setBackgroundColorExecute(rootColor);
			node.setEdgeColorExecute(rootEdgeColor, 2);
			node.setTextColorExecute(rootTextColor);
		} else if (node.getParent().isRootNode()) {
			indexColor = indexColor % iColor.length;
			color = iColor[indexColor];
			indexColor++;			
			node.setBackgroundColorExecute(color);
			node.setEdgeColorExecute(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor), 2);
			node.setBranchExecute(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor), branchWidths[node.getDepth()], null);
		}
		else {
			var depth = node.getDepth();
			var branchWidth = depth < branchWidths.length ? branchWidths[depth] : branchWidths[branchWidths.length-1];
			var parentColor = Raphael.getRGB(node.getParent().background_color);
			var color = NodeColorUtil.randomer(Raphael.getRGB(NodeColorUtil.brighter(parentColor, fadeFactor)), randFactor);
			node.setBackgroundColorExecute(color);
			node.setEdgeColorExecute(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor), 2);
			node.setBranchExecute(NodeColorUtil.darker(Raphael.getRGB(color), darkFactor), branchWidth, null);
		}
	}
	
	return NodeColorMix;
})();
