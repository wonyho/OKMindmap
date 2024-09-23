/////////////////////menu_list///////////////////////////////
var isOwner_menu_list = new Array(
	"changeMapName",
	"delMap",
	"shareManage",
	"courseEnrolment",
	"okmPreference",
	"usrPreference",
	"activityMonitoring",
	"remixActions",
	"mapOfRemixes"
);

var canEdit_menu_list = new Array(
	"saveMap",
	"saveAsMap",
	"nodeColorMix",
	"changeMapBackgroundAction",
	"groupManage",
	"createEmbedTag",
	// "FacebookGetFeedAction",
	"presentationEditMode",
	"foldingall",
	"CtrlRAction",
	"changeToMindmap",
	"changeToCard",
	"changeToTree",
	"changeToHTree",
	"changeToFishbone",
	"changeToSunburst",
	"changeToZoomableTreemap",
	"changeToPadlet",
	"changeToPartition",
	"googleSearch",
	"changeNodeAllColorAction",
	"timelineMode",
	"splitMap"
);

var canCopyNode_menu_list = new Array(
	"exportFile",
	"clipBoard",
	"exportToFreemind",
	"remixMap",
	"remixActions",
	"mapOfRemixes"
);

var selected_menu_list = new Array(
	"insertAction",
	"addMoodleActivityAction",
	"insertSiblingAction",
	"imageProviderAction",
	"videoProviderAction",
	"insertHyperAction",
	"insertIFrameAction",
	"fileProviderAction",
	"insertNoteAction",
	"insertWebPageAction",
	"insertLTIAction",
	"iotProvidersAction",
	"iotControlAction",
	"increaseFontSizeAction",
	"decreaseFontSizeAction",
	"nodeTextColorAction",
	"nodeBGColorAction",
	"foldingAction",
	"ShiftenterAction",
	"editNodeAction",
	"cutAction",
	"copyAction",
	"pasteAction",
	"deleteAction",
	"nodeEdgeWidthAction1",
	"nodeEdgeWidthAction2",
	"nodeEdgeWidthAction4",
	"nodeEdgeWidthAction6",
	"nodeEdgeWidthAction8",
	"nodeEdgeColorAction",
	"insertTextOnBranchAction",
	"sessionMenuSetting",
	"testRobotTool",
	"nodeStructureToXml",
	"nodeStructureFromXml",
	"nodeStructureToText",
	"nodeStructureFromText",
	"nodeToNodeAction",
	"removeArrowLink",
	"settingArrowLink"
);

var canGuestEdit_menu_list = new Array(
	"newMap",
	"openMap",
	"presentationStartMode",
	"importMap",
//	"importZipMap",
	"rightPanelFolding",
	"createMoodle",
	"zoominAction",
	"zoomoutAction",
	"zoomnotAction",
	"okmNoticeAction",
	"requestFunction",
	"howtoUse",
	"openHotKeys",
	"aboutJinoTech",
	"insertAction",
	"insertSiblingAction",
	"imageProviderAction",
	"cutAction",
	"copyAction",
	"pasteAction",
	"deleteAction",
	"editNodeAction"
);

var defaultNodeMenu = new Array(
	"menu.edit.siblingnode",
	"menu.edit.childnode",
	"menu.view.folding",
	"menu.insertTextOnBranchAction",
	"menu.edit.hyperlink",
	"menu.edit.imageurl",
	"video.video_upload",
	"menu.edit.webpage",
	"menu.edit.iframe",
	"menu.fileProviderAction",
	"menu.insertNoteAction"
//	"menu.edit.lti",
//	"menu.plugin.iot_providers",
//	"menu.plugin.iot_control"
);

var defaultNodeMenuGuest = new Array(
		"menu.edit.siblingnode",
		"menu.edit.childnode",
		"menu.edit.imageurl",
		"menu.edit",
		"menu.edit.cut",
		"menu.edit.copy",
		"menu.edit.paste",
		"menu.edit.delete"
	);

const tierpolicy = {
	// presentation
	'tierpolicy-presentationbox': 'presentation_box',
	'tierpolicy-presentationdynamic': 'presentation_dynamic',
	'tierpolicy-presentationaero': 'presentation_aero',
	'tierpolicy-presentationlinear': 'presentation_linear',
	'tierpolicy-presentationmindmapbasic': 'presentation_mindmapbasic',
	'tierpolicy-presentationmindmapzoom': 'presentation_mindmapzoom',

	// map tyles
	'menu-changeToMindmap': 'mapstyle_mindmap',
	'menu-changeToCard': 'mapstyle_card',
	'menu-changeToSunburst': 'mapstyle_sunburst',
	'menu-changeToTree': 'mapstyle_tree',
	'menu-changeToHTree': 'mapstyle_project',
	'menu-changeToPadlet': 'mapstyle_padlet',
	'menu-changeToPartition': 'mapstyle_partition',
	'menu-changeToFishbone': 'mapstyle_fishbone',
	'menu-changeToZoomableTreemap': 'mapstyle_rect',

	// export - import
	'tierpolicy-exportToPPT': 'export_ppt',
	'menu-nodeStructureToXml': 'nodeStructureToXml',
	'menu-nodeStructureFromXml':'nodeStructureFromXml',
	'menu-nodeStructureToText':'nodeStructureToText',
	'menu-nodeStructureFromText':'nodeStructureFromText'
};

function getUserPolicy() {
	return USER_POLICY == '' ? {} : JSON.parse(Base64.decode(USER_POLICY));
}

function requiredTierPolicy(policy_key, callback) {
	// callback();
	var policy = getUserPolicy();
	if(policy[policy_key] == undefined) {
		showUpgradeTierDialog();
	} else {
		callback();
	}
}

function showUpgradeTierDialog(){
	JinoUtil.showDialog({
		url: jMap.cfg.contextPath + "/jsp/fn/upgradeTier.jsp",
		size: 'modal-xl',
		nopadding: true
	});
}

function setTierPolicy() {
	var policy_class = Object.keys(tierpolicy);
	for(var i = 0, len = policy_class.length; i<len; i++){
		var el = $('.'+policy_class[i]);
		var policy_key = tierpolicy[policy_class[i]];
		var policy = getUserPolicy();
		if(policy[policy_key] == undefined) {
			el.addClass('need-upgrade');
			if(el.attr('onclick') == undefined) {
				el.click(function(){
					showUpgradeTierDialog();
				});
			}
		}
	}
}

var showNavMenu = function () {
	if ($("#collapseMenuNav").hasClass('show')) {
		$.cookie('navMenuState', "", { path: '/' });
	} else {
		$.cookie('navMenuState', "show", { path: '/' });
	}
}

var selectedMenu = function (group) {
	$('.jino-menus .jino-menu-item').removeClass('show');
	if (group) {
		$('.jino-menus .jino-menu-item[data-group="' + group + '"]').addClass('show');
		$.cookie('currentSessionMenu', group, { path: '/' });
	} else {
		$('.jino-menus .jino-menu-item-txt').addClass('show');
	}
	if (jinoMenus) jinoMenus.update();
	jMap.work.focus();
	if(group ==  "node"){
		$("#menusettingArrowLink").removeClass("show");
	}
};


var setMenuActions = function (can_action, menu_list) {
	if (can_action) {
		for (var i = 0; i < menu_list.length; i++) {
			$(".menu-" + menu_list[i]).prop('disabled', false);
			$(".menu-" + menu_list[i]).attr('onclick', menu_list[i] + "()");
		}
	} else {
		for (var i = 0; i < menu_list.length; i++) {
			$(".menu-" + menu_list[i]).prop('disabled', true);
			$(".menu-" + menu_list[i]).attr('onclick', null);
		}
	}
}

var jinoMenus = null;
$(document).ready(function () {
	setMenuActions(false, selected_menu_list);
	setMenuActions(true, canGuestEdit_menu_list);
	setMenuActions(menu_canCopyNode, canCopyNode_menu_list);
	setMenuActions(menu_canEdit, canEdit_menu_list);
	setMenuActions(menu_isOwner, isOwner_menu_list);
	setMenuActions(!jMap.cfg.isShrdGuest, new Array('exportMyData'));

	if (!menu_isOwner) {
		$("#restrict_editing").prop("disabled", true);
	}

	if (jMap.cfg.mapKey == '') {	// only for /index.do page
		setMenuActions(false, new Array("presentationStartMode", "rightPanelFolding"));
	}

	if (!ISMOBILE && $('.jino-menus').length) {
		jinoMenus = new PerfectScrollbar('.jino-menus');
	}

	if (menu_canEdit) {
		//노드 선택 되었을 때 메뉴 활성화
		jMap.addActionListener(ACTIONS.ACTION_NODE_SELECTED, function () {
			var node = arguments[0];
			setMenuActions(jMap.isAllowNodeEdit(node), selected_menu_list);
			if (!jMap.isAllowNodeEdit(node) && jMap.cfg.restrictEditing) {
				setMenuActions(true, new Array("insertSiblingAction", "insertAction", "foldingAction"));
			}
			if (node.isRootNode()) {
				setMenuActions(false, new Array("insertSiblingAction", "foldingAction", "insertTextOnBranchAction", "cutAction", "copyAction", "deleteAction"));
				if (node.attributes['remixMap'] != undefined || jMap.rootNode.attributes["remixesOfMap"] != undefined) {
					setMenuActions(false, new Array("insertHyperAction"));
				}
			}
			
			if (node.moodleIcon != null && !node.isRootNode()) {
				//setMenuActions(false, new Array("insertSiblingAction", "insertAction", "insertTextOnBranchAction", "cutAction", "copyAction", "pasteAction"));
				setMenuActions(false, new Array("insertTextOnBranchAction", "cutAction", "copyAction"));
			}

			switch (jMap.layoutManager.type) {
				case 'jCardLayout':
					setMenuActions(false, new Array("foldingAction", "insertTextOnBranchAction", "iotProvidersAction", "iotControlAction"));
					break;
				case 'jSunburstLayout':
					setMenuActions(false, new Array("foldingAction", "insertTextOnBranchAction", "iotProvidersAction", "iotControlAction", "increaseFontSizeAction", "decreaseFontSizeAction", "nodeEdgeWidthAction1", "nodeEdgeWidthAction2", "nodeEdgeWidthAction4", "nodeEdgeWidthAction6", "nodeEdgeWidthAction8"));
					break;
				case 'jTreeLayout':
					setMenuActions(false, new Array("insertTextOnBranchAction"));
					break;
				case 'jHTreeLayout':
					setMenuActions(false, new Array("insertTextOnBranchAction"));
					break;
				case 'jPadletLayout':
					setMenuActions(false, new Array("foldingAction", "insertTextOnBranchAction"));
					break;
				case 'jPartitionLayout':
					setMenuActions(false, new Array("foldingAction", "insertTextOnBranchAction", "iotProvidersAction", "iotControlAction", "increaseFontSizeAction", "decreaseFontSizeAction", "nodeEdgeWidthAction1", "nodeEdgeWidthAction2", "nodeEdgeWidthAction4", "nodeEdgeWidthAction6", "nodeEdgeWidthAction8"));
					break;
				case 'jFishboneLayout':
					setMenuActions(false, new Array("insertTextOnBranchAction", "iotProvidersAction", "iotControlAction"));
					break;
				case 'jZoomableTreemapLayout':
					setMenuActions(false, new Array("foldingAction", "insertTextOnBranchAction", "iotProvidersAction", "iotControlAction", "increaseFontSizeAction", "decreaseFontSizeAction", "nodeEdgeWidthAction1", "nodeEdgeWidthAction2", "nodeEdgeWidthAction4", "nodeEdgeWidthAction6", "nodeEdgeWidthAction8"));
					break;
			}

			selectedMenu('node');
			// Save this node to cookie csedung
			$.cookie('selectedNodeID', node.id, { path: '/' });
		});
		//노드 선택이 해제 되었을 때 비활성화
		jMap.addActionListener(ACTIONS.ACTION_NODE_UNSELECTED, function () {
			setMenuActions(false, selected_menu_list);
			selectedMenu($.cookie('currentSessionMenu'));
		});

		// only for test
		if (jMap.cfg.userId == 1) {
			$('.menu-testRobotTool').attr('style', '');
			setTimeout(function () {
				var num = (new URLSearchParams(window.location.search)).get('testRobot');
				if (num != null) {
					TestRobot.createStart(1000, parseInt(num));
				}
			}, 3000);
		}
	}

	if ($(window).width() < 1200) navbarMenusToggle($.cookie('toggleMenus') == 'true');
	else navbarMenusToggle($.cookie('toggleMenus') ? $.cookie('toggleMenus') == 'true':true);
	$( window ).resize(function() {
		if($(window).width() >= 1200) navbarMenusToggle(true);
	});

	$("#collapseMenuNav").addClass($.cookie('navMenuState'));
	$('.node-menu').attr('style', 'display: none !important;');
	var group = $.cookie('currentSessionMenu');
	if (group != null && group != "") {
		selectedMenu(group);
	} else {
		selectedMenu("file");
	}

	setTierPolicy();
	setTimeout(function(){setMenuActions(menu_canCopyNode, canCopyNode_menu_list); console.log("menu_canCopyNode ", menu_canCopyNode);}, 3000);
	
	// navbarMenusToggle(($.cookie('toggleMenus') == 'true'), true);
});

//CSEDUNG
var checkSession = function () {
	if(jMap.cfg.contextPath == undefined) return;
	$.ajax({
		type: 'post',
		async: false,
		url: jMap.cfg.contextPath + '/user/checkusersession.do',
		success: function (data) {
			if(jMap.cfg.userId != data && data != ""){
				location.reload();
			}
		}, error: function (data, status, err) {

		}
	});
}

//CSEDUNG
var reloadViewAction = function (nodeID) {
	//window.alert("get: "+node.id);
	if (jMap.getLayoutManager().type === "jMindMapLayout" ||
		jMap.getLayoutManager().type === "jTreeLayout" ||
		jMap.getLayoutManager().type === "jHTreeLayout") {
		var node = jMap.getNodeById(nodeID);
		if (node) {
			var currentNode = node;
			while (!currentNode.isRootNode()) {
				currentNode = currentNode.getParent();
				currentNode.folded && currentNode.setFoldingExecute(false);
			}
			//window.alert("HERE");
			node.focus(true, false);
			jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
			jMap.layoutManager.layout(true);
			screenFocusAction(node);
		}
	}
}