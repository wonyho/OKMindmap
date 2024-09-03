
/**
 *  
 *  실시간 저장을 하기위해 필요한 Action들을 정의한 곳.
 *  
 * @author Hahm Myung Sun (hms1475@gmail.com)
 * @created 2011-07-01
 * 
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com)
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */
	
///////////////////////////////////////////////////////////////////////////////
///////////////////////////// jSaveAction ///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

jSaveAction = function(map){
	this.map = map;
	this.actionList = [];
	this.saveThumbnail = false;
	this.readyPost = true;
}

jSaveAction.prototype.type= "jSaveAction";

jSaveAction.prototype.cfg = {
		async: true,
		type:'post'
};

jSaveAction.prototype.newAction = function(node, async) {
	if(hasTranslated){
//		alert("You map was translated, can not be saved. \nPlease save as...");
		return;
	}
	if(this.map.cfg.realtimeSave) {
		var xml = node.toXML();	
		var mapid = ' mapid="'+mapId+'"';	
		var parentid = '';
		if(node.getParent())
			parentid = ' parent="'+node.getParent().getID()+'"';	
		var nextid = '';
		if(node.nextSibling())
			nextid = ' next="'+node.nextSibling().getID()+'"';
		
		var action = '<new'+mapid+parentid+nextid+'>' + xml + '</new>';
		
		action = Base64.encode( escape(action) );
		
		if(async == null || async == undefined) async = this.cfg.async;
		var that = this;
		$.ajax({
			type: this.cfg.type,
			async: async,
			url: this.map.cfg.contextPath+'/mindmap/save.do',
			data: {'action': action},
			dataType: "json",
			beforeSend: function() {},
			success: function(data, textStatus, jqXHR) {	
				// -1이면 오류
				if(data.status == -1) {
					// 에러처리로 노드 삭제
					if(J_NODE_CREATING){
						console.log('err');
						var node = null;	
						var parentNode = null;		
						while (node = that.map.getSelecteds().pop()) {
							parentNode = node.getParent();								
							node.remove();
						}
						J_NODE_CREATING.focus(true);
						
						that.map.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(parentNode);
						that.map.layoutManager.layout(true);
					}
					that.map.controller.stopNodeEdit(false);
				} else {
					if(node && (node.isRootNode() || node.getParent().isRootNode())){
						thumbnail();
					}
				}
			},
			error: function(data, status, err) {
				console.log(err);
				jMap.fireActionListener(ACTIONS.ACTION_ASYNCHRONOUS);
			},			
			complete: function() {}
	    });
	}
}

jSaveAction.prototype.editAction = function(node, async, callback) {
	if(hasTranslated){
//		alert("You map was translated, can not be saved. \nPlease save as...");
		return;
	}
	if(this.map.cfg.realtimeSave) {
		if(node.removed) return;
		
		var xml = node.toXML(true);	
		var mapid = ' mapid="'+mapId+'"';	
		var action = '<edit'+mapid+'>' + xml + '</edit>';
		
		action = Base64.encode( escape(action) );
		
		if(async == null || async == undefined) async = this.cfg.async;
		this.actionList.push(action);
//		csedung turn off this code to improve async action
//		$.ajax({
//			type: this.cfg.type,
//			async: async,
//			url: this.map.cfg.contextPath+'/mindmap/save.do',
//			data: {'action': action},
//			dataType: "json",
//			success: function(data){
//				if(data.status == 1) {
//					thumbnail();
//				}
//			},
//			error: function(data, status, err) {
//				jMap.fireActionListener(ACTIONS.ACTION_ASYNCHRONOUS);
//			}
//		});
		this.postAction(callback);
		if(node.isRootNode() || node.getParent().isRootNode()){
			this.saveThumbnail = true;
		}
	}
}

jSaveAction.prototype.postAction = function(callback) {
	if(hasTranslated){
//		alert("You map was translated, can not be saved. \nPlease save as...");
		return;
	}
	if((this.actionList.length > 0 && this.readyPost) /*|| this.actionList.length > 1000*/){
		this.readyPost = false;
		async = this.cfg.async;
		var json = JSON.stringify(this.actionList);
		this.actionList = [];
		$.ajax({
		type: this.cfg.type,
		async: async,
		url: this.map.cfg.contextPath+'/mindmap/save.do',
		data: {'action': json, 'actionList':'hasList'},
		dataType: "json",
		success: function(data){
			jMap.saveAction.readyPost = true;
			if(this.actionList.length > 0 && this.readyPost) {
				this.postAction(callback);
			} else {
				if(this.saveThumbnail) {
					thumbnail();
					this.saveThumbnail = false;
				}
				if((typeof callback) == 'function') {
					callback();
				}
			}
		}.bind(this),
		error: function(data, status, err) {
			jMap.fireActionListener(ACTIONS.ACTION_ASYNCHRONOUS);
		}
	});
	}
}

jSaveAction.prototype.deleteAction = function(node, async) {
	if(hasTranslated){
//		alert("You map was translated, can not be saved. \nPlease use save as...");
		return;
	}
	if(this.map.cfg.realtimeSave) {
		if(node.removed) return;
		
		var xml = node.toXML();	
		var mapid = ' mapid="'+mapId+'"';	
		var action = '<delete'+mapid+'>' + xml + '</delete>';
		
		action = Base64.encode( escape(action) );
		
		if(async == null || async == undefined) async = this.cfg.async;
		$.ajax({
			type: this.cfg.type,
			async: async,
			url: this.map.cfg.contextPath+'/mindmap/save.do',
			data: {'action': action},
			dataType: "json",
			success: function(data){
				if(data.status == 1) {
					if(node.isRootNode() || node.getParent().isRootNode()){
						thumbnail();  // Create Map thumbnail
					}
				}
			},
			error: function(data, status, err) {
				jMap.fireActionListener(ACTIONS.ACTION_ASYNCHRONOUS);
			}
	    });
	}
}

jSaveAction.prototype.moveAction = function(node, parent, nextSibling, async) {
	if(hasTranslated){
//		alert("You map was translated, can not be saved. \nPlease save as...");
		return;
	}
	if(this.map.cfg.realtimeSave) {
		var xml = node.toXML(true);	
		var mapid = ' mapid="'+mapId+'"';
		var parentid = ' parent="'+parent.getID()+'"';
		var nextid = (nextSibling)?' next="'+nextSibling.getID()+'"':'';
		
		var action = '<move'+mapid+parentid+nextid+'>' + xml + '</move>';
		
		action = Base64.encode( escape(action) );
		
		if(async == null || async == undefined) async = this.cfg.async;
		$.ajax({
			type: this.cfg.type,
			async: async,
			url: this.map.cfg.contextPath+'/mindmap/save.do',
			data: {'action': action},
			dataType: "json",
			success: function(data) {
				if(data.status == 1) {
					if(node.isRootNode() || node.getParent().isRootNode()){
						thumbnail();
					}
				}
			},
			error: function(data, status, err) {
				jMap.fireActionListener(ACTIONS.ACTION_ASYNCHRONOUS);
			}
	    });
	}
}

jSaveAction.prototype.pasteAction = function(node, async) {	
	if(hasTranslated){
//		alert("You map was translated, can not be saved. \nPlease save as...");
		return;
	}
	if(this.map.cfg.realtimeSave) {
		var xml = node.toXML();
		var mapid = ' mapid="'+mapId+'"';	
		var parentid = '';
		if(node.getParent())
			parentid = ' parent="'+node.getParent().getID()+'"';	
		var nextid = '';
		
		var action = '<new'+mapid+parentid+nextid+'>' + xml + '</new>';
		
		action = Base64.encode( escape(action) );
		
		if(async == null || async == undefined) async = this.cfg.async;
		$.ajax({
			type: this.cfg.type,
			async: async,
			url: this.map.cfg.contextPath+'/mindmap/save.do',
			data: {'action': action},
			dataType: "json",
			success: function(data){
				if(data.status == 1) {
					if(node.isRootNode() || node.getParent().isRootNode()){
						thumbnail();
					}
				}
			},
			error: function(data, status, err) {
				jMap.fireActionListener(ACTIONS.ACTION_ASYNCHRONOUS);
			}
	    });
	}
}

jSaveAction.prototype.isAlive = function() {

	// var url = this.map.cfg.contextPath+'/user/logout.do';
	
	// if(jMap.cfg.isShrdGuest){
	// 	jMap.commonAlertAction("토픽에 대한 편집이 불가능 합니다.");	
	// 	return false;
	// }

	// // 앱이 아닌 경우
	// if(!(ISMOBILE || supportsTouch)
	// 	&& jMap.cfg.sessionCheckUrl != "") {
	// 	var memberNo = this.getSessionID(jMap.cfg.sessionCheckUrl);
		
	// 	if(jMap.cfg.userNo === "" || memberNo === "" || jMap.cfg.userNo != memberNo) {
	// 		jMap.commonAlertAction("로그인 후 이용해 주세요. </br> 메인 페이지로 이동합니다.", url);
	// 		// alert("로그아웃 되었습니다.");
	// 		// document.location.href = this.map.cfg.contextPath+'/user/logout.do';
	// 		return false;
	// 	}
	// }
	
	return true;
}

// jSaveAction.prototype.getSessionID = function(url) {
// 	var memberNo = "";
	
// 	$.ajax({
// 		type: 'get',
// 		async: false,
// 		url: url,
// 		dataType: 'json',
// 		success: function(data, status, err) {
// 			memberNo = data.memberNo
// 		}
//     });
	
// 	return memberNo;
// }
