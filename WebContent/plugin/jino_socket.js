/**
 * 
 */

var SOCKET_LISTENERS = [];
var ACTION_QUEUE = [];
var ISRUNNING = false;

async function RUN_ACTION_QUEUE() {
 	if (ISRUNNING) return true;
 	ISRUNNING = true;
 	ASYNCACTION = true;
 	while (ACTION_QUEUE.length > 0) {
 		if(ACTION_QUEUE.length > 1) NEWACTIONASYNC = true;
 		var action = ACTION_QUEUE.shift();
 		if (typeof window[action.functionName] == "function") {
			window[action.functionName].apply(null, action.arguments);
		}
		if(jMap.layoutManager.type === 'jMindMapLayout'){
			redrawNodeAsync();
		}
 	}
 	ACTION_QUEUE = [];
 	ISRUNNING = false;
 	NEWACTIONASYNC = false;
 	ASYNCACTION = false;
}

function SET_SOCKET(isSet) {

	if (isSet) {
		if (SOCKET_LISTENERS.length != 0) return;

		var fire_socket_action = function (fn, args) {
			if (window.mindmapIO !== undefined) mindmapIO.emit('DWR', {
				mapKey: jMap.cfg.mapKey,
				functionName: fn,
				arguments: args
			});
		}

		if (window.mindmapIO !== undefined) mindmapIO.on(jMap.cfg.mapKey + '.DWR', function (msg) {
			// if (ACTION_QUEUE === null) {
			if (typeof window[msg.functionName] == "function") {
//				window[msg.functionName].apply(null, msg.arguments);
				ACTION_QUEUE.push(msg);
				RUN_ACTION_QUEUE();
			}

			// if (jMap.getSelected()) jMap.fireActionListener("action_NodeSelected", jMap.getSelected());
			// } else {
			// 	ACTION_QUEUE.push(msg);
			// }
		});

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NEW_NODE, function () {
			var node = arguments[0];
			var index = arguments[1].index ? arguments[1].index : null;
			var isleft = null;
			if (node.isLeft && node.getParent() && node.getParent().isRootNode()) {
				isleft = node.isLeft() ? "left" : "right";
			}

			var data = "<paste>";
			data += node.toXML();
			data += "</paste>";

			fire_socket_action('afterDWR_sendNodeInsert', [node.getParent().id, data, index, isleft]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'insert',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': node.getParent().id,
						'data': data,
						'index': index,
						'isLeft': isleft
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_REMOVE, function () {
			var node = arguments[0];
			fire_socket_action('afterDWR_sendNodeRemove', [node.id]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'delete',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': node.id
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_EDITED, function () {
			var node = arguments[0];
			fire_socket_action('receiveDWR_sendNodeEdit', [node.id, node.getText()]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'edit',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': node.id,
						'data': node.getText()
					}
				});
			}
		}));

		// Folding은 문제점이 많아 잠시 막아 둡니다.
		//		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_FOLDING, function(){
		//			var node = arguments[0];
		//			(typeof DWR_sendNodeFolding != "undefined")
		//				&& DWR_sendNodeFolding(node.id, node.folded);
		//		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_COORDMOVED, function () {
			var node = arguments[0];
			fire_socket_action('afterDWR_sendNodeCoordMove', [node.id, arguments[1], arguments[2]]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'NodeCoordMove',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': node.id,
						'dx': arguments[1],
						'dy': arguments[2]
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_HYPER, function () {
			var node = arguments[0];
			var hyperURL = (node.hyperlink) ? node.hyperlink.attr().href : null;
			fire_socket_action('DWR_afterNodeHyper', [node.id, hyperURL]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'hyper',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': node.id,
						'data': hyperURL
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_IMAGE, function () {
			var nodeid = arguments[0];
			var img_url = arguments[1];
			var width = arguments[2];
			var height = arguments[3];
			fire_socket_action('DWR_afterNodeImage', [nodeid, img_url, width, height]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'image',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': nodeid,
						'data': img_url
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_PASTE, function () {
			var node = arguments[0];
			fire_socket_action('afterDWR_sendNodePaste', [node.id, arguments[1], arguments[2]]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'paste',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': node.id,
						'data': arguments[1],
						'index': arguments[2]
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_MOVED, function () {
			var parent = arguments[0],
				pasteNodes = arguments[1],
				position = arguments[2],
				targNode = arguments[3];

			var parentNodeID = parent.getID();
			var pasteNodeIDs = [];
			for (var i = 0; i < pasteNodes.length; i++) {
				pasteNodeIDs.push(pasteNodes[i].getID());
			}
			var targNodeID = (targNode) ? targNode.getID() : null;

			fire_socket_action('afterDWR_sendNodeMoved', [parentNodeID, pasteNodeIDs, position, targNodeID]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'Node Move',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'parentNodeID': parentNodeID,
						'position': position,
						'targNodeID': targNodeID
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_UNDO, function () {
			var id = arguments[0];
			var data = arguments[1];
			var jsonCopyData = JSON.stringify(data);
			fire_socket_action('DWR_afterRecoveryNode', [id, jsonCopyData]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'recovery',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': id,
						'data': jsonCopyData
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_REDO, function () {
			var id = arguments[0];
			var data = arguments[1];
			var jsonCopyData = JSON.stringify(data);
			fire_socket_action('DWR_afterRecoveryNode', [id, jsonCopyData]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_FOREIGNOBJECT, function () {
			var id = arguments[0].id;
			var html = arguments[1];
			var width = arguments[2];
			var height = arguments[3];
			fire_socket_action('afterDWR_sendNodeForeignObject', [id, html, width, height]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'foreign',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'nodeId': id,
						'html': html,
						'width': width,
						'height': height
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_ATTRS, function () {
			var node = arguments[0];
			var xml = node.toXML(true);
			fire_socket_action('afterDWR_sendNodeAttrs', [xml]);

			if (jMap.cfg.queueing) {
				$.ajax({
					type: 'post',
					url: jMap.cfg.contextPath + '/mindmap/queue.do',
					data: {
						'action': 'attrs',
						'sender': mindmapIO ? mindmapIO.io.engine.id : '',
						'mapKey': jMap.cfg.mapKey,
						'xml': xml
					}
				});
			}
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_BRANCH_TEXT, function () {
			var node = arguments[0];
			var branchText = node.attributes.branchText || "";
			fire_socket_action('afterNodeBranchText', [node.id, branchText]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_NOTE, function () {
			var node = arguments[0];
			var noteText = node.noteText || "";
			fire_socket_action('afterNodeNote', [node.id, noteText]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_FILE, function () {
			var node = arguments[0];
			var url = "";
			if (node.file != null) {
				url = node.file.attr().href || "";
			}
			fire_socket_action('afterNodeFile', [node.id, url]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_ARROWLINK, function () {
			var node = arguments[0];
			var arrowlink = arguments[1];
			fire_socket_action('afterNodeArrowLink', [node.id, arrowlink.toXML()]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_FONTSIZE, function () {
			var node = arguments[0];
			var size = node.getFontSize();
			fire_socket_action('afterNodeFontSize', [node.id, size]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_EDGECOLOR, function () {
			var node = arguments[0];
			fire_socket_action('afterNodeEdgeColor', [node.id, node.edge.color, node.edge.width]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_NODE_BRANCH, function () {
			var node = arguments[0];
			fire_socket_action('afterNodeBranch', [node.id, node.branch.color, node.branch.width, node.branch.style]);
		}));

		// Presentation
		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_PRESENTATION_INSERT, function () {
			var node = arguments[0];
			fire_socket_action('EditorManager_addSlide', [node.id]);
		}));
		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_PRESENTATION_DELETE, function () {
			var sortOrder = arguments[0];
			fire_socket_action('EditorManager_deleteSlide', [sortOrder]);
		}));
		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_PRESENTATION_UPDATE, function () {
			var sortOrder = arguments[0];
			var depth = arguments[1];
			fire_socket_action('EditorManager_updateSlide', [sortOrder, depth]);
		}));
		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_PRESENTATION_MOVE, function () {
			var from = arguments[0];
			var to = arguments[1];
			fire_socket_action('EditorManager_moveSlide', [from, to]);
		}));

		// Chat
		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_CHAT_SEND_MESSAGE, function () {
			var username = arguments[0];
			var messages = arguments[1];
			var roomNumber = arguments[2];
			var userId = arguments[3];
			var timecreated = arguments[4];

			fire_socket_action('OKMChat_receiveMessages', [username, messages, roomNumber, userId, timecreated]);
		}));
		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_CHAT_ON_TYPING, function () {
			fire_socket_action('OKMChat_onTyping', []);
		}));
		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_CHAT_OFF_TYPING, function () {
			fire_socket_action('OKMChat_offTyping', []);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_MAP_RESTRICT_EDITING, function () {
			var restricting = arguments[0];

			fire_socket_action('afterDWR_setRestrictEditing', [restricting]);
		}));

		SOCKET_LISTENERS.push(jMap.addActionListener(ACTIONS.ACTION_ASYNCHRONOUS, function () {
			afterDWR_Asynchronous();
			fire_socket_action('afterDWR_Asynchronous', []);
		}));
	}
	else {
		var l = null;
		while (l = SOCKET_LISTENERS.pop())
			jMap.removeActionListener(l);
	}
}


function CREATE_NODE(node,num, idx,time,old,RANODE, start){
	if(num == idx) return;
	
	setTimeout(() => {
		idx++;
		var txt = start + ": " + idx;
		if(idx % 2 == 0 || node.children.length < 10){
			J_NODE_CREATING = node;
			node.folded && node.setFolding(false);
			var param = {parent: node,
					text: txt};
			if (node.children.length > 0)
				param.sibling = node.children[node.children.length - 1];
			
		}else{
			J_NODE_CREATING = node;
			var nod = node && node.parent;
			var index = node.getIndexPos() + 1;
			var position = null;
			if (node.position && node.getParent().isRootNode()) 
				position = node.position;
			
			var param = {parent: nod,				
					index: index,
					position: position,
					sibling: node,
					text: txt};
		}
		
		var newNode = jMap.createNodeWithCtrl(param);
		newNode.focus(true);
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors(newNode.parent);
		jMap.layoutManager.layout(true);

		if(idx%3 == 0 || idx < 6) RANODE.push(newNode);
		var gets = Math.floor(Math.random() * RANODE.length); 
		while(old == gets) gets = Math.floor(Math.random() * RANODE.length); 
		CREATE_NODE(RANODE[gets],num, idx, time, gets,RANODE,start);
	}, time);
}

async function AUTO_CREATE_NODE(num,time,start) {
	var RANODE = [];
	var node = jMap.getSelecteds().getLastElement();
	CREATE_NODE(node,num, 1,time, -1,RANODE,start);
}

function ASYNC_DEMO(interval) {
	setTimeout(() => {
		AUTO_CREATE_NODE(60,interval,'node')
	}, 60000);
}

function drawNodeAsync() {
  return new Promise(resolve => {
	  if(jMap.layoutManager.type === 'jMindMapLayout'){
		  jMap.layoutManager.svgRedraw(jMap.rootNode);
	  }
  });
}

async function redrawNodeAsync() {
  const run = await drawNodeAsync();
}