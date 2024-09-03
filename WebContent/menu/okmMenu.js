var selectedMenu = -1;
var selectedMainMenu = -1;
var isNodeSelect = false;
var isShowEditPopup = true;
var isStartEditNodeMobile = false;
var isGifIncluded = false;
var isGifImgSelect = false;

$( document ).ready(function() {
	$( "div#main-menu div#header ul li.menu" ).each(function( index ) {
	  $(this).css( 'cursor', 'pointer' );
	  
	  $(this).click(function() {
	  	if(selectedMainMenu >= 0) {
	  		$( "div#main-menu div#header ul li.menu:eq(" + selectedMainMenu + ")" ).removeClass( "on");
	  	}
		  $("div#main-menu div#content").css("display", "none");
		  $("div#main-menu div#content_fixed").css("display", "block");
		  
		  var i = $(this).index();
		  var action = $(this).attr("data-action");
		  if(i != selectedMainMenu && action != undefined) {
		  	selectedMainMenu = i;
		  	var position = $(this).position();
		  	
		  	//$(this).addClass("on");
		  	$("div#main-menu div#content[data-action="+ action +"]").css("display", "inline-block");
		  	$("div#main-menu div#content_fixed").css("display", "none");
		  	$("div#main-menu div#content[data-action="+ action +"]").css("margin-left", (position.left + 36) + "px");
		  } else {
		  	selectedMainMenu = -1;
		  }
		});
	});
	
	$( "div#edit-menu div#header ul li.menu" ).each(function( index ) {
		$(this).css( 'cursor', 'pointer' );
	  
	  	$(this).click(function() {
	  		
	  		if($("#nodePopupEditBox").css("display") == "block"){
	  			$("#nodePopupEditBox").hide();
	  		}
	  		
		  	if(selectedMenu >= 0) {
		  		$( "div#edit-menu div#header ul li.menu:eq(" + selectedMenu + ")" ).removeClass( "on");
		  	}
		  	
			$("div#edit-menu div#content").css("display", "none");		  
			$("div#edit-menu div#text_space").css("display", "none");
			  	
		  	var i = $(this).index();
		  	var action = $(this).attr("data-action");
		  	
		  	if(i != selectedMenu && action != undefined) {
			  	selectedMenu = i;
			  	//$(this).addClass("on");
			  	$("div#edit-menu div#content[data-action="+ action +"]").css("display", "block");		  	
			  	$("div#edit-menu div#text_space").css("display", "block");
			} else {
				selectedMenu = -1;
			}
		});
	});
	
	//꾸미기 상자 이벤트
	$(".menu-item").click(function(){
		$(this).siblings().removeClass("on")
		$(this).toggleClass("on");
	});
	
	// 하단 편집박스 가운데 정렬
	$("div#edit-menu").css("left",($(window).width()/2)-$("div#edit-menu").width()/2);
	$("div#edge-menu").css("left",($(window).width()/2)-$("div#edge-menu").width()/2);
});


var isOwnerMenu = function(isOwner){

}

var canEditMenu = function(canEdit){
	
}

var getNodeBoxSize = function(node) {
	var hGap = TEXT_HGAP;
	var vGap = TEXT_VGAP;
	
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
	
	if(!(jMap.layoutManager.type == "jSunburstLayout" || jMap.layoutManager.type == "jZoomableTreemapLayout" || jMap.layoutManager.type == "jPartitionLayout")) {
		node.CalcBodySize();
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
	}
	
	var width = node.body.getBBox().width * jMap.cfg.scale;
	var height = node.body.getBBox().height * jMap.cfg.scale - vGap;	
	var left = (node.body.getBBox().x - viewBox.x) * RAPHAEL.getSize().width / viewBox.width + hGap / 4;
	var top = (node.body.getBBox().y - viewBox.y) * RAPHAEL.getSize().height / viewBox.height + vGap / 4;
	
	return {left: left, top: top, width: width, height: height};
}

var showNodeDeleteMenu = function() {
	var node = jMap.getSelecteds().getFirstElement();
	if(node == undefined) {
		return false;
	}
	
	var nodeDelete = jMap.nodeDeleteMenu[0];
	var nodeEdit = jMap.nodeEditMenu[0];
	var nodeEdit2 = jMap.nodeEditMenu[1];
	var edgeMenu = jMap.edgeMenu[0];
	var box = getNodeBoxSize(node);
	
	// 모두 숨기기.
	$(nodeDelete).find( "a" ).each(function() {
		if($(this).attr("action") != "showNodeEditMenu") {
			$(this).css('display', 'none');
		}
	});
	
	// 추가된 항목만 보이기..
	if(!node.isRootNode()) {
		$(nodeDelete).find( "a[action='deleteAction']").css('display', '');
	}
	if(node.img) {
		$(nodeDelete).find( "a[action='imageRemoveAction']").css('display', '');
	}
	if(node.file) {
		$(nodeDelete).find( "a[action='fileRemoveAction']").css('display', '');
	}
	if(node.foreignObjEl) {
		$(nodeDelete).find( "a[action='videoRemoveAction']").css('display', '');
	}
	if(node.hyperlink) {
		$(nodeDelete).find( "a[action='deleteHyperAction']").css('display', '');
	}
	if(node.note) {
		$(nodeDelete).find( "a[action='deleteNoteAction']").css('display', '');
	}
	if(node.attributes && node.attributes['branchText']) {
		$(nodeDelete).find( "a[action='deleteTextOnBranchAction']").css('display', '');
	}
	//if(node.arrowlinks.length > 0) {
	//	$(nodeDelete).find( "a[action='deleteArrowlinkAction']").css('display', '');
	//}
	
	nodeEdit.style.display = "none";
	nodeEdit2.style.display = "none";
	edgeMenu.style.display = "none";
	
	nodeDelete.style.display = "block";
	nodeDelete.style.left = (box.width - $(nodeDelete).width()) + box.left + "px";
	nodeDelete.style.top = box.top - 29 + "px";
}

var showNodeEditMenu = function() {
	var node = jMap.getSelecteds().getFirstElement();
	if(node == undefined) {
		return false;
	}
	
	var nodeDelete = jMap.nodeDeleteMenu[0];
	var nodeEdit = jMap.nodeEditMenu[0];
	var nodeEdit2 = jMap.nodeEditMenu[1];
	var edgeMenu = jMap.edgeMenu[0];
	
	var box = getNodeBoxSize(node);
	
	nodeDelete.style.display = "none";
	
	nodeEdit.style.display = "block";
	nodeEdit.style.left = (box.width - $(nodeEdit).width()) + box.left + "px";
	nodeEdit.style.top = box.top - 34 + "px";
	
	nodeEdit2.style.display = "none";
	nodeEdit2.style.left = (box.width - $(nodeEdit).width()) + box.left + "px";
	nodeEdit2.style.top = box.top - 34 + "px";
	
	edgeMenu.style.top = box.top - 184 + "px";
	
	if(node.isRootNode()) { // root node 잘라내기 display none
		$(nodeEdit2).find( "a[action='cutAction']").css('display', 'none');
	}else{
		$(nodeEdit2).find( "a[action='cutAction']").css('display', '');
	}
}

var selectedNodeMenu = function (sel, selNode, menu_canEdit) {
	var nodeDelete = jMap.nodeDeleteMenu[0];
	var nodeEdit = jMap.nodeEditMenu[0];
	var nodeEdit2 = jMap.nodeEditMenu[1];
	var nodeAttach = jMap.nodeAttachMenu[0];
	var nodeAttach2 = jMap.nodeAttachMenu[1];
	var edgeMenu = jMap.edgeMenu[0];
	//var nodeRelation = jMap.nodeRelationMenu[0];
	//var nodeBranchText = jMap.nodeBranchTextMenu[0]; // 20190422 위두랑 요청으로 연결선 텍스트 편집 제거
	var nodePopupTipBox = jMap.nodePopupTipBox[0];
	var nodeUsernameTipBox = jMap.nodeUsernameTipBox[0];
	
	var node = jMap.getSelecteds().getLastElement();
	if(node == undefined) {
		if(selNode && selNode != undefined) {
			node = selNode;
		} else {
			nodeDelete.style.display = "none";
			nodeEdit.style.display = "none";
			nodeEdit2.style.display = "none";
			nodeAttach.style.display = "none";
			nodeAttach2.style.display = "none";
			//nodeRelation.style.display = "none";
			//nodeBranchText.style.display = "none";
			nodePopupTipBox.style.display = "none";
			nodeUsernameTipBox.style.display = "none";
			
			return false;
		}
	}
	
	if(!node.body.getBBox()) return false;
	var box = getNodeBoxSize(node);

	if(ISMOBILE) {
		$('#edit-menu').css('display', sel ? 'none':'block');
	}
	
	if(sel && node.type != "jCardNode" && !jMap.cfg.presentationMode) {
		// 이름 표시창.
		nodeUsernameTipBox.style.display = "block";
		nodeUsernameTipBox.style.left = (box.left - 5) + "px";
		nodeUsernameTipBox.style.top = (box.top - 26) + "px";
		nodeUsernameTipBox.innerHTML = node.userfullname;
	} else {
		nodeUsernameTipBox.style.display = "none";
	}
	
	if(!jMap.isAllowNodeEdit(node)) {
		return false;
	}
	
	if(node.isRootNode()) { // root node 잘라내기 display none
		$(nodeEdit2).find( "a[action='cutAction']").css('display', 'none');
	}else{
		$(nodeEdit2).find( "a[action='cutAction']").css('display', '');
	}

	if($('#presentation_editor').is(":visible")) {
		$(nodeEdit).find( "a[action='addPTEditorAction']").css('display', '');
	} else $(nodeEdit).find( "a[action='addPTEditorAction']").css('display', 'none');
	
	if(sel && !jMap.cfg.presentationMode) {
		
		/*if($("div#edit-menu div#content").css("display") == "block"){
			$("div#edit-menu div#text_space").hide();
			$("div#edit-menu div#content").hide();
		}*/
		
		nodeDelete.style.display = "none";
		nodeEdit.style.display = "block";
		nodeEdit2.style.display = "none";
		nodeAttach.style.display = "inline-block";
		nodeAttach2.style.display = "none";
//		nodePopupTipBox.style.display = "inline-block";
		
		// if(ISMOBILE || supportsTouch){
		// 	// node 팝업 안내창
		// 	nodePopupTipBox.style.left = box.left + "px";
		// 	nodePopupTipBox.style.top = box.top + box.height + 12 + "px";
			
	    //     $("#nodePopupTipBox_div #nodeTip_m").css("display","block");
		// 	$("#nodePopupTipBox_div #nodeTip_w").css("display","none");
		// }else{
			nodeEdit.style.left = (box.width - $(nodeEdit).width()) + box.left + "px";
			nodeEdit.style.top = box.top - 34 + "px";
			nodeEdit2.style.left = (box.width - $(nodeEdit).width()) + box.left + "px";
			nodeEdit2.style.top = box.top - 34 + "px";
			edgeMenu.style.left = (box.width - $(nodeEdit).width()) + box.left + "px";
			edgeMenu.style.top = box.top - 184 + "px";
			
			nodeAttach.style.left = (box.width - $(nodeEdit).width()) + box.left + "px";
			nodeAttach.style.top = box.top + box.height + 10 + "px";
			nodeAttach2.style.left =(box.width - $(nodeEdit).width()) + box.left + "px";
			nodeAttach2.style.top = box.top + box.height + 10 + "px";
			
			// node 팝업 안내창
//			nodePopupTipBox.style.left = box.left + "px";
//			nodePopupTipBox.style.top = box.top + box.height + 37 + "px";
			
//			$("#nodePopupTipBox_div #nodeTip_m").css("display","none");
//			$("#nodePopupTipBox_div #nodeTip_w").css("display","block");
		// }
		
		if(!node.isRootNode() && jMap.layoutManager.type == "jMindMapLayout") {
			//nodeRelation.style.display = "block";
			//nodeBranchText.style.display = "block";
			if(node.isLeft()) {
				//nodeRelation.style.left = (box.left - $(nodeRelation).width() + 8) + "px";
				//nodeRelation.style.top = (box.top - $(nodeRelation).height()/2) + "px";
				
				
				//nodeBranchText.style.left = (box.left + box.width) + "px";
				//nodeBranchText.style.top = (box.top + box.height/2 - $(nodeBranchText).height()/2) + "px";
			} else {
				//nodeRelation.style.left = (box.width - $(nodeRelation).width()/2 - 3) + box.left + "px";
				//nodeRelation.style.top = (box.top + box.height - 5) + "px";
				
				
				//nodeBranchText.style.left = (box.left - $(nodeRelation).width() - 5) + "px";
				//nodeBranchText.style.left = (box.left - $(nodeBranchText).width() - 5) + "px";
				//nodeBranchText.style.top = (box.top + box.height/2 - $(nodeBranchText).height()/2) + "px";
			}
			
			/*$("#node_relation").on("mousedown", function(e) {
				jMap.mouseRightSelectedNode = node;
				jMap.startedArrowLink = true;
			});*/
		}
		
		// 햇살맵이고 모바일 아닐때
		// if(jMap.layoutManager.type == "jSunburstLayout"){  //|| ISMOBILE
			
		// 	changeNodeEditBox(node, jMap.layoutManager.type);
			
			//   $("g").off('click');
			//   $("g").off('touchstart');
			//   $("g").on('click touchstart', function (e) {
				
			//   	if($("div#edit-menu div#content").css("display") == "block"){
			//   		$("div#edit-menu div#text_space").hide();
			//   		$("div#edit-menu div#content").hide();
			//   	}
				
			//   	$("#popupEditBox_text").val("");
			//   	$("#popupEditBox_text").val(selNode.plainText);
				
			//   	// 햇살맵이고 모바일 아닐때
			//   	if(isNodeSelect && jMap.layoutManager.type == "jSunburstLayout" && !(ISMOBILE || supportsTouch)){
			//   		if(selNode != undefined && selNode == jMap.getSelecteds().getFirstElement()){
			//   			$("#nodePopupEditBox").css({
			//   				'display' : 'block',
			//   				'left' : e.clientX,
			//   				'top' : e.clientY,
			//   				'width' : 300 + "px",
			//   				'bottom' : "auto"
			//   			})
			//   			nodeAttach.style.display = "inline-block";
			//   			nodeAttach2.style.display = "inline-block";
			//   		}
			//   	}else {
			// 		$("#nodePopupEditBox").css('display','none');
			//   	}
			//   });

			// $("#nodePopupEditBox").on('click touchstart', function (event) {
			// 	if(event.target.classList[1] == "popEditBtn"){ // 팝업에딧박스 닫기 버튼	
			// 		if(jMap.getSelecteds().getFirstElement()) {
			// 			selectedNodeMenu(false, jMap.getSelecteds().getFirstElement());
			// 			savePopEditText(jMap.getSelecteds().getFirstElement());
			// 		}
			// 	}
			// })
		// }

		if(jMap.layoutManager.type == "jSunburstLayout" || jMap.layoutManager.type == "jZoomableTreemapLayout" || jMap.layoutManager.type == "jPartitionLayout") {
			changeNodeEditBox(node, jMap.layoutManager.type);
		}
		
		// 모든 모바일 화면에서
		// if(ISMOBILE || supportsTouch){  //|| ISMOBILE
		// 	changeNodeEditBox(node, jMap.layoutManager.type);
			
		// 	$("#nodePopupEditBox").off('click');
		// 	$("#nodePopupEditBox").off('touchstart');
		// 	$("#nodePopupEditBox").on('click touchstart', function (event) {
		// 		if(event.target.classList[1] == "popEditBtn"){ // 팝업에딧박스 닫기 버튼
		// 			// 이것만 해도 텍스트 업데이트 됨. 왜지??
		// 			// savePopEditText를 호출하면 텍스트에 이모지 아이콘이 있을 경우 alert이 두번 뜸.
		// 			jMap.controller.blurAll();
		// 		}
		// 	})
			
		// 	if(jMap.layoutManager.type != "jSunburstLayout") {
		// 		$("g").off('click');
		// 		$("g").off('touchstart');
		// 	}

		// 	$("g").on('click touchstart', function (e) {
		// 		if($("div#edit-menu div#content").css("display") == "block"){
		// 			$("div#edit-menu div#text_space").hide();
		// 			$("div#edit-menu div#content").hide();
		// 		}
				
		// 		$("#popupEditBox_text").val("");
		// 		$("#popupEditBox_text").val(selNode.plainText);
				
		// 		// 모든 모바일 화면에서
		// 		if(isNodeSelect && (ISMOBILE || supportsTouch)){
					
		// 		    $("#nodePopupEditBox .popEditBtn").css("display","inline-block");
					
		// 		    var popLeft = 0;
		// 		    var popTop = 0;
		// 		    var popWidth = 100 + "%";
		// 		    var popBot = "auto";
				    
		// 		    if($(window).width() > 500){
		// 		    	popTop = "auto";
		// 		    	popLeft = ($(window).width()/2) - ($("#nodePopupEditBox").width()/2);
		// 		    	popWidth = 300 + "px";
		// 		    	popBot = 100 + "px";
		// 		    }
				    
		// 			if(selNode != undefined && selNode == jMap.getSelecteds().getFirstElement()){
		// 				isStartEditNodeMobile = true;
						
		// 				$("#nodePopupEditBox").css({
		// 					'display' : 'block',
		// 					'left' : popLeft,
		// 					'top' : popTop,
		// 					'width' : popWidth,
		// 					'bottom' : popBot
		// 				})
		// 				nodeAttach.style.display = "inline-block";
		// 				nodeAttach2.style.display = "inline-block";
		// 			}
		// 		}else{
		// 			$("#nodePopupEditBox").css('display','none');
		// 			$("#nodePopupEditBox .popEditBtn").css("display","none");
		// 		}
		// 	});
		// }
		
		//ACTION_QUEUE = [];
	} else {
		$("#node_relation").off( "mousedown" );
		
		nodeDelete.style.display = "none";
		nodeEdit.style.display = "none";
		nodeEdit2.style.display = "none";
		nodeAttach.style.display = "none";
		nodeAttach2.style.display = "none";
		//nodeRelation.style.display = "none";
		//nodeBranchText.style.display = "none";
		nodePopupTipBox.style.display = "none";
		nodeUsernameTipBox.style.display = "none";
		
		// if(jMap.layoutManager.type == "jSunburstLayout" || (ISMOBILE || supportsTouch)){
		// 	$("#nodePopupEditBox").css('display','none');
			
		// 	if((ISMOBILE || supportsTouch) && !isStartEditNodeMobile) return false;
			
		// 	savePopEditText(node);
			
		// 	isStartEditNodeMobile = false;
		// }

		//RUN_ACTION_QUEUE();
	}
};

var changeNodeEditBox = function (node, map) {
	
	$("#nodeDeleteMenu").prependTo("#popupEditBox_div");
	$("#nodeEditMenu").prependTo("#popupEditBox_div");
	$("#nodeEditMenu-2").prependTo("#popupEditBox_div");
	$("#nodeAttachMenu").appendTo("#popupEditBox_div");
	$("#nodeAttachMenu-2").appendTo("#popupEditBox_div");
	
	$("#nodeEditMenu").addClass("nodePopup_EditMenu");
	$("#nodeEditMenu-2").addClass("nodePopup_EditMenu");
	$("#nodeAttachMenu").addClass("nodePopup_AttachMenu");
	$("#nodeAttachMenu-2").addClass("nodePopup_AttachMenu");
	$("#nodeDeleteMenu").addClass("nodePopup_DeleteMenu");			
	
	$("#popupEditBox_div textarea").css({
		'border': '1px solid' + node.getEdgeColor()
	})
	
	if(!(map == "jSunburstLayout")){
		// $("#nodeBranchTextMenu a").appendTo("#nodeAttachMenu");
	}
}

var changeMapAction = function(){
	
	var mapType = jMap.layoutManager.type;
	
	switch( mapType ) {
		case "jMindMapLayout":
			changeToCard();
			break;
		case "jCardLayout":
			changeToMindmap();
			break;
		/*case "jSunburstLayout":
			changeToTree();
			break;
		case "jTreeLayout":
			changeToHTree();
			break;
		case "jHTreeLayout":
			changeToMindmap();
			break;*/
	}
}

var returnMapAction = function(obj){
	
	var txt = "";
	
	if(obj != undefined && obj == true){
		txt = '<div class="dialog_content" ><div><span>원형, 트리형, 프로젝트형 맵은 준비중입니다.</br>방사형 맵으로 이동합니다.</span></div></div>';
		
		$("#dialog").append(txt);
		
		$("#dialog").dialog({
			autoOpen:false,
			closeOnEscape: true,	//esc키로 창을 닫는다.
			modal:true,		//modal 창으로 설정
			resizable:false,	//사이즈 변경
			close: function( event, ui ) {
				$("#dialog").dialog("close");
			  	$("#dialog .dialog_content").remove();
				$("#dialog").dialog("destroy");
			}
	    });
		$("#dialog").dialog("option", "width", "300px" );
		$("#dialog").dialog( "option", "buttons", [
			{
				text: "확인",
				click: function() {
					$("#dialog").dialog("close");
				}
	       }
		]);
		$("#dialog").dialog("option","dialogClass","returnMapAction");  		  
		$("#dialog").dialog( "option", "title", "알림");
		$("#dialog").dialog("open");
	}
}

var savePopEditText = function(node){
	var val = JinoUtil.trimStr($("#popupEditBox_text").val());
	if ( val == node.getText() ) return null;
	
	node.setText(val);
	$("#popupEditBox_text").val('');
	jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
	jMap.layoutManager.layout(true);
}

var changeNodeGifFormat = function(node, sel, obj){
	if(jMap.getNodeById(node.id) == undefined) return true;

	var imgSrc;
	var type;
	
	if(node != null && node.img != null){
		imgSrc = node.img.attrs.src;
		type = 0;
	}
	if(obj != undefined && obj != null){
		imgSrc = obj.src;
		type = 1;
	}
	if(imgSrc != null){
		if(checkNodeImgFormat(imgSrc) == "gif"){
			var gifSrc = imgSrc;
			if(sel){
				gifSrc = gifSrc.replace("/map/file/", "/map/gif/");
			}else{
				gifSrc = gifSrc.replace("/map/gif/", "/map/file/");
			}
			if(type === 0){
				node.setImage(gifSrc);
				//console.log("node image");
			}else{
				obj.src = gifSrc;
				//console.log("obj image");
			}
			checkGifNotiStatus(gifSrc);
			isGifImgSelect = sel;
		}
	}	
}

var checkNodeImgFormat = function(url){
	var fileLen = url.length;
	var lastDot = url.lastIndexOf('.');
	var fileExt = url.substring(lastDot+1, fileLen).toLowerCase();
	
	return fileExt;
}

var checkGifNotiStatus = function(url){
	if(checkNodeImgFormat(url) == "gif"){
		if(!isGifIncluded) isGifIncluded = true;
		if($(".gif_noti").css("display") == "none"){
			$(".gif_noti").show();
			if(jMap.layoutManager.type == 'jCardLayout') {
				if(jMap.layoutManager.topic != null) {
					jMap.layoutManager.topic.CalcBodySize();
				}
			}	
		}
	}
}