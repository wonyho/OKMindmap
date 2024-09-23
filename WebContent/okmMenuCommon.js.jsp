<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>

<script defer type="text/javascript">
	var navbarMenusToggle = function (show, save_status) {
		var checked = show === true;
		$('#toggleMenus').prop('checked', checked);
		$('#toggleMenus2').prop('checked', checked);
		if (checked) $('body').removeClass('hide-navbar-menus');
		else $('body').addClass('hide-navbar-menus');

		if (save_status) {
			$.cookie('toggleMenus', checked, { path: '/' });
		}
	};

	var navbarModalToggle = function (target) {
		if (target) {
			$('.navbar-modal').removeClass('show');
			$(target).addClass('show');
			navbarMenusToggle(false);
		} else {
			$('.navbar-modal').removeClass('show');
			navbarMenusToggle($.cookie('toggleMenus') == 'true');
		}
	};

	/* Scale */
	var zoominAction = function (times) {
		times = parseFloat(times);
		if (!times || isNaN(times)) times = 0.1;
		jMap.scale(jMap.scaleTimes + times);
	}
	var zoomoutAction = function (times) {
		times = parseFloat(times);
		if (!times || isNaN(times)) times = 0.1;
		jMap.scale(jMap.scaleTimes - times);
	}
	var zoomnotAction = function () {
		jMap.scale(1);
	}

	function changeLanguage(lang) {
		document.location.href = "${pageContext.request.contextPath}/language.do?locale=" + lang + "&page=" + document.location.href;
	}

	var screenFocusAction = function () {
		jMap.controller.screenFocusAction();
	};

	var okmLogin = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/user/login.do"
		});
	}

	var editProfile = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/user/update.do",
			title: "<spring:message code='user.edit_information' />"
		});
	}

	var okmLogout = function () {
		$.cookie('currentTab', 0);
		document.location.href = "${pageContext.request.contextPath}/user/logout.do";
	}

	var newMap = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/mindmap/new.do",
			title: "<spring:message code='message.newmap'/>"
		});
	};

	var createMoodle = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/mindmap/new.do?type=moodle",
			title: "<spring:message code='message.moodle.new'/>",
			size: "modal-lg",
			nopadding: true
		});
	};

	var openMap = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/mindmap/list.do",
			title: "<spring:message code='menu.mindmap_open'/>",
			size: "modal-full modal-dialog-scrollable",
			nopadding: true
		});
	};

	// search nodes
 	var initFindNodeAction = function (frm) {
		/* $(frm).submit(function (event) {
			event.preventDefault();
			jMap.controller.executeFindNodeAction(frm);
		});
		$(frm).find('#jino_input_search_text').keydown(function () {
			if (jMap.findForm) {
				jMap.findForm.find('#jino_form_search_results').addClass('d-none');
				jMap.findForm.find('#jino_form_search_prev').addClass('d-none');
				jMap.findForm.find('#jino_form_search_next').addClass('d-none');
				jMap.findForm.find('#jino_form_search_action').removeClass('d-none');
				jMap.findForm = null;
			}
		}); */
	}; 

	var shorturlFunction = function () {
		JinoUtil.showDialog({
			url: "../jsp/short_url.jsp?short_url=${data.short_url}",
			title: "${data.map.name}"
		});
	};

	var checkGifNotiStatus = function (url) { };
	var changeNodeGifFormat = function (node, sel, obj) { };

	var okmNotices = [];
	var okmNoticeAction = function (check) {
		check = typeof check !== 'undefined' ? check : true;
		$.ajax({
			url: '${pageContext.request.contextPath}/mindmap/admin/notice/okmNotice.do?func=view',
			dataType: "json",
			cache: false,
			async: false,
			success: function (data) {
				okmNotices = data[0].notices;
				var ck_name = "okm_notice";
				var updated = new Date(data[0].updated).getTime();
				var lastChecked = PopupExpiredays.getCookie(ck_name);
				if (typeof lastChecked == 'undefined') lastChecked = 0;
				lastChecked = parseInt(lastChecked);

				if (check == true || lastChecked < updated) {
					JinoUtil.showDialog({
						url: "${pageContext.request.contextPath}/jsp/fn/okmNoticeAction.jsp",
						size: "modal-lg",
						nopadding: true
					});
				}
			}
		});
	};
	var closeNotice = function () {
		var ck_name = "okm_notice";
		var expire_date = new Date();
		var value = new Date().getTime();
		expire_date.setDate(expire_date.getDate() + 99);
		document.cookie = ck_name + "=" + escape(value) + "; expires=" + expire_date.toGMTString() + "; path=/";
		JinoUtil.closeDialog();
	};

	var requestFunction = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/board/list.do?boardType=3&lang=${locale.language}",
			title: "<spring:message code='menu.cs.qna'/>",
			size: "modal-lg",
			nopadding: true
		});
	};

	var howtoUse = function () {
		window.open("<spring:message code='menu.help.usage.url'/>", 'new', 'left=50, top=50, width=1050, height=600, scrollbars=yes');
	};
	var aboutOKMindmap = function () {
		window.open("<spring:message code='menu.help.intromindmap.url'/>", 'new', 'left=50, top=50, width=1050, height=600, scrollbars=yes');
	};
	var aboutJinoTech = function () {
		window.open("<spring:message code='menu.help.introjino.url'/>", 'new', 'left=50, top=50, width=1050, height=600, scrollbars=yes');
	};

	var presentationStartMode = function () {
		var presentation = $('#presentation');
		presentation.addClass('skeleton-loading')
			.attr('src', presentation.data('src'))
			.removeClass('d-none');
	};
	var presentationClose = function () {
		var presentation = $('#presentation');
		presentation.attr('src', null)
			.addClass('d-none');

		presentationEdit = null;
	};

	var presentationEditMode = function () {
		if (jMap.cfg.canEdit) {
			var editor = $('#presentation_editor');
			if (editor.hasClass('closed')) {
				EditorManager.show();
				editor.removeClass('closed');
				$('.tooltip').not(this).hide();
			} else {
				editor.addClass('closed');
				EditorManager.hide();
				$('.tooltip').not(this).show();
			}
		}
	};

	var setMenuOpacity = function (active) {
		if (active) $('body').addClass('menu-opacity-active');
		else $('body').removeClass('menu-opacity-active');
	};

	var rightPanelFolding = function () {
		var panel = $('#rightPanelFolding');
		if (!panel.hasClass('loaded')) {
			panel.addClass('loaded');
			OKMChat.getMessages(1);
		}
		if (panel.hasClass('closed')) {
			panel.removeClass('closed');
			$.cookie('rightPanelFolding', 1, { path: '/' });
		} else {
			panel.addClass('closed');
			$.cookie('rightPanelFolding', 0, { path: '/' });
		}
		$('#chatUnread').html('').addClass('d-none');
	};

	var pleaseLoginModal = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/jsp/fn/pleaseLoginModal.jsp"
		});
	};

	var openHotKeys = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/jsp/help/hotkey.jsp"
		});
	}

	var sessionMenuSetting = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/user/usernodesetting.do",
			title: "<spring:message code='menu.usrsetting'/>",
			size: "modal-full modal-dialog-scrollable",
			nopadding: true
		});
	}
	
	var moodleDisconnectDetection = function(){
		var root = jMap.getRootNode();
		if (root.attributes == undefined) root.attributes = {};

		if(root.attributes['moodleUrl'] && root.attributes['moodleCourseId']) {
			
		
			if($('#title_icon') != null && $('#title_icon') != undefined){
				$('#title_icon').attr('src', "${pageContext.request.contextPath}/menu/icons/moodle.png");
				$('#title_icon').attr('style', 'margin-top: 6px; width: 24px; height: 24px;');
			}

			root.setHasMoodleExecute();
			root.setHyperlink(root.attributes['moodleUrl'] + "course/view.php?id=" + root.attributes['moodleCourseId']);
		}else{
			// root.setHyperlink(null); 
			if(root.hyperlink != null)
			if(root.hyperlink.attr().href.indexOf("/map/") < 0 ){
				root.setHyperlink(null);
			}
		}
		
		setNodeMoodleIcon(root.getChildren());
		jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
		jMap.layoutManager.layout(true);

		if (!jMap.cfg.mapOwner) return;
		if(root.attributes['moodleUrl'] && !root.attributes['moodleCourseId']) {
			alert('This map has lost connection to Moodle. Please restore your connection!');
		}
	}
	
	var setNodeMoodleIcon = function(nodes){
		for(var i=0;i < nodes.length; i++){
			var n = nodes[i];
			var is_moodle = Object.keys(n.attributes).join('_').indexOf('moodle');
			if(is_moodle >= 0) {
				n.setHasMoodleExecute();
			}	
			var ns = nodes[i].getChildren();
			if(ns.length > 0){
				setNodeMoodleIcon(ns);
			}
		}  
	}
	
	var getNodeLisScore = function(nodes){
		for(var i=0;i < nodes.length; i++){
			var n = nodes[i];
			if(n.hyperlink != null){
				var is_lti = n.hyperlink.attr().href.indexOf('launch.do');
				if(is_lti >= 0) {
					$.ajax({
					      type: 'POST',
					      url: jMap.cfg.contextPath + '/mindmap/lisScore.do',
					      data: {node : n.getID(), map : mapId},
					      dataType: "text",
					      success: function(data) { 
					    	  var arr = data.split('::');
					    	  if(arr[1] != "-1.0"){
					    		  var node = jMap.getNodeById(arr[0]);
						    	  node.setScore(arr[1]);
					    	  }
					      }
					});
				}
			}
				
			var ns = nodes[i].getChildren();
			if(ns.length > 0){
				getNodeLisScore(ns);
			}
		}
	}
</script>