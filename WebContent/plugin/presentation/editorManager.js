/**
 * 
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com) 
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */


PresentationElement = function(node, $el, sortOrder){
	this.$el =  $el;
	this.node = node;	
	this.id = this.generateId();//node.getID();
	
	// 속성
	this.sortOrder = sortOrder;
	this.position = {x: 0, y: 0, z: 0};
	this.scale = {scaleX: 1, scaleY: 1};
	this.rotate = 0;	
	this.showDepths = Math.min(3, this.getDepths(node));
}

PresentationElement.prototype.getDepths = function(node) {
	var children = node.getChildren();
	var depth = 0;
	for (var i = 0; i < children.length; i++) {
		depth = Math.max(depth, 1 + this.getDepths(children[i]));
	}
	return depth;
}

PresentationElement.prototype.generateId = function() {
	var id = "ID_";
	var length = 10;
	
	var timestamp = +new Date;
	var ts = timestamp.toString();
	var parts = ts.split( "" ).reverse();
	
	for( var i = 0; i < length; ++i ) {
		var index = Math.floor( Math.random() * ( parts.length ) );
		id += parts[index];	
	}
	
	return id;
}
//PresentationElement.prototype.type= "PresentationElement";
//
//PresentationElement.prototype.getPosition = function() {
//	return this.position;	
//}
//
//PresentationElement.prototype.setPosition = function() {
//	return this.position;	
//}



EditorManager = (function () {
	
	var editor = null;					// editor 레이아웃
	var editorContainer = null;					// editor에 요소를 담는곳
	var nodeRemovedListener = null;	// 노드 삭제 리스너
	var nodeEditedListener = null;	// 노드 편집 리스너
	var nodeImageListener = null;
	var nodeFileListener = null;
	var nodeVideoListener = null;
	var nodeHyperlinkListener = null;
	var nodeNoteListener = null;
	
	var Elements = Array();
	var Sequence = Array();
	
	// var themes = [
	// 	['BlackLabel', _presenTheme1, 'BlackLabel/preview.jpg'],
	// 	['Basic', _presenTheme2, 'Basic/preview.jpg'],
	// 	['Sunshine', _presenTheme3, 'Sunshine/preview.jpg'],
	// 	['Sky', _presenTheme4, 'Sky/preview.jpg'],
	// 	['BlueLabel', _presenTheme5, 'BlueLabel/preview.jpg']
	// ];
	// var Types = {Slide: 'slide', Mindmap: 'mindmap', Dynamic: 'Dynamic'}; 
	
	var cfg = {
			editorID : 'presentation_editor'
	};

	function EditorManager(){};
	
	
	var updateSequence = function(){
		var children = editorContainer.children();
		
		Sequence = [];
		for(var i = 0; i < children.length; i++) {
			var ptid = $(children[i]).data('ptid');
			var pt = EditorManager.getPresentationElementById(ptid);
			Sequence.push(pt.node.getID());
		}
		
		var sequence = Sequence.join(' ');
		$.ajax({
			type: 'post',
			async: false,
			url: parent.jMap.cfg.contextPath+'/mindmap/changeMap.do',
			data: {'mapId': parent.mapId,
						'pt_sequence': sequence },
			error: function(data, status, err) {
				alert("pt_sequence : " + status);
			}
		});
		
		Presentation.saveSlide();
		updateEditor();
	}
	
	var setEllipsisText = function(text, width) {
		var line = $('<span style="white-space:nowrap">'+text+'</span>');
		editor.append(line);
		
		var ellipsis = false;
		width = width - 10;
		while(line.width() > width) {
			var t = line.text();
			t = t.substring(0, t.length-1);
			line.text(t);
			ellipsis = true;
		}
		if(ellipsis) {
			text = line.text()+'...';
		}
		line.remove();
		
		return text;
	}

	var updateNode = function(node) {
		if(node) {
			var ptElements = EditorManager.getPresentationElementByNodeId(node.getID());
			for(var i = 0; i < ptElements.length; ++i) {
				var pt = ptElements[i];//EditorManager.getPresentationElementById(node.getID());
				var $el = pt.$el;
				// $el.find('.editor_text_content').text(setEllipsisText(node.plainText, 150));
				$el.find('.editor_text_content').text(node.plainText);
				var textColor = node.getBackgroundColor();
				$el.find('.editor_text_content').css('background', textColor);
				pt.showDepths = Math.min(pt.showDepths, 3, pt.getDepths(pt.node));
				$el.find('.editor_depths_content').text(pt.showDepths);

				var menu = '';
				if(node.img) menu += '<a href="#" onclick="EditorManager.attachMenuAction(\'imageProviderAction\', \'' + node.id + '\');"><img src="' + jMap.cfg.contextPath + '/menu/icons/icon_image.png" class="node-menu"/></a>';
				if(node.file) menu += '<a href="#" onclick="EditorManager.attachMenuAction(\'fileProviderAction\', \'' + node.id + '\');"><img src="' + jMap.cfg.contextPath + '/menu/icons/icon_file.png" class="node-menu"/></a>';
				if(node.foreignObjEl) menu += '<a href="#" onclick="EditorManager.attachMenuAction(\'videoProviderAction\', \'' + node.id + '\');"><img src="' + jMap.cfg.contextPath + '/menu/icons/icon_youtube.png" class="node-menu"/></a>';
				if(node.hyperlink) menu += '<a href="#" onclick="EditorManager.attachMenuAction(\'insertHyperAction\', \'' + node.id + '\');"><img src="' + jMap.cfg.contextPath + '/menu/icons/icon_link.png" class="node-menu"/></a>';
				if(node.note) menu += '<a href="#" onclick="EditorManager.attachMenuAction(\'insertNoteAction\', \'' + node.id + '\');"><img src="' + jMap.cfg.contextPath + '/menu/icons/icon_note.png" class="node-menu"/></a>';
				
				// $el.find('.editor_attach_menu').html(menu);
			}
		}
	}
	var updateEditor = function(){
		var children = editorContainer.children();
		for(var i = 0; i < children.length; i++) {
			var id = $(children[i]).data('ptid');
			var pt = EditorManager.getPresentationElementById(id);
			var node = jMap.getNodeById(pt.node.getID());
			if(node) {
				$(children[i]).find('.editor_order_content').text(i+1);
				pt.sortOrder = i+1;
			} else {
				Elements.remove(pt);
				$(children[i]).remove();
			}
		}
	}
	
	var insertSlide = function(node) {
		var nodeid = node.getID();
		// div를 생성해 마지막에 붙인다.
		var $el = $('<div class="pt-element d-flex border rounded"></div>');
		
		var $order = $('<div class="editor_order"><div class="editor_order_content">0</div></div>');		
		$el.append($order);
		
		var $text = $('<div class="editor_text flex-grow-1"><div class="editor_text_content text-truncate"></div><div class="editor_attach_menu"></div></div>');
		$el.append($text);
		
		var $depths = $('<div class="editor_depths"><div class="editor_depths_content">0</div></div>');
		$depths.click(function(){
			updateSlide($(this).parent());
		});
		$el.append($depths);
				
		var $remove = $('<div class="editor_remove"><div class="editor_remove_content"></div></div>');
		$remove.click(function(){	// 삭제 클릭시 지워지도록
			deleteSlide($(this).parent());
		});
		$el.append($remove);
		
		var element = new PresentationElement(node, $el, Elements.length + 1);
		
		$el.data('ptid', element.id);
		editorContainer.append($el);
		Sequence.push(nodeid);
		
		// 서버에서 해당 노드가 갖고 있는 슬라이드 정보를 가져온다.
		$.ajax({
			type: 'post',
			async: false,
			url: parent.jMap.cfg.contextPath+'/presentation/slide.do',
			data: { 'method': 'get',
					'mapid': jMap.cfg.mapId,
					'nodeid': element.node.getID(),
					'sortOrder': element.sortOrder
					},
			success: function(data, textStatus, jqXHR) {
				if(jqXHR.responseText != "") {
					var slide = JSON.parse(jqXHR.responseText);			
					element.position = {x: slide.x, y: slide.y};
					element.scale = {scaleX: slide.scalex, scaleY: slide.scaley};
					element.rotate = slide.rotate;
					if(slide.showdepths) element.showDepths = slide.showdepths;
				}
			},
			error: function(data, status, err) {
				alert("Slides load error: " + status);
			}
		});
		
		Elements.push(element);
		
		updateNode(node);

		// 스크롤 가장 아래로..
		var bottom = editorContainer[0].scrollHeight - editorContainer.outerHeight();
		editorContainer.scrollTop(bottom);
		// $('.slimScrollBar').css({ top: bottom + 'px' });
		
	}
	
	var deleteSlide = function(slide) {
		var pt = EditorManager.getPresentationElementById(slide.data('ptid'));
		var sortOrder = pt.sortOrder;
		
		deleteSlideExecute(slide, pt);
		updateSequence();
		
		jMap.fireActionListener(ACTIONS.ACTION_PRESENTATION_DELETE, sortOrder);
	}
	
	var deleteSlideExecute = function(slide, pt) {
		Elements.remove(pt);
		slide.remove();
	}
	
	var updateSlide = function(slide) {
		var pt = EditorManager.getPresentationElementById(slide.data('ptid'));
		var depth = pt.getDepths(pt.node);
		if(depth > 0) {
			depth = (pt.showDepths % Math.min(3, depth)) + 1;
		}
		
		updateSlideExecute(slide, pt, depth);
		Presentation.saveSlide();
		
		jMap.fireActionListener(ACTIONS.ACTION_PRESENTATION_UPDATE, pt.sortOrder, depth);
	}
	
	var updateSlideExecute = function(slide, pt, depth) {
		pt.showDepths = depth;
		$(slide).find('.editor_depths_content').text(pt.showDepths);
	}
	
	/**
	 * editor 생성 함수
	 */
	var createEditor = function() {
		// var left = 40;
		// var top = 40;
		
		// var slideBoxResize = function() {
		// 	var width = 354;
		// 	var height = 0;			
		// 	var mapDiv = document.getElementById("main");
		// 	height = mapDiv.offsetHeight - 40;
			
		// 	if(height <= 450)return; // 450이하 축소 방지
			
		// 	editor.height(height);
			
		// 	if(editorContainer) {
				
		// 		if(height <= 450)return; // 450이하 축소 방지
				
		// 		var h = height - 320;
		// 		editorContainer.height(h);
		// 		editorContainer.parent().height(h);
								
		// 	}			
		// }
		
//		var topDiv = document.getElementById("top");
//		if(!topDiv) topDiv = 0;
//		top = topDiv.offsetHeight;
		// presentation_editor
		// var pos = "left: "+left+"px; top: "+top+"px;";
		// editor = $('<div id="'+cfg.editorID+'" class="presentation-editor" style="position:absolute; '+pos+'"></div>').appendTo($(jMap.work).parent());
		
		// slideBoxResize();
		// $(window).bind('resize', slideBoxResize);
		
		// Bar
		// editor.append('<div class="pt-editor-bar"><div id="pt-editor-bar-title">'+_presenAlert+'</div><div id="pt-editor-bar-close"></div></div>');
		
		// Slide Box
		// var slideBox = $('<div class="pt-editor-box"><div class="pt-editor-box-title">'+_presenSlide+'</div><div class="pt-element-header"><div class="editor_order">'+_presenRow+'</div><div class="editor_text">'+_presenTopic+'</div><div class="editor_depths">'+_presenChild+'</div><div class="editor_remove">'+_presenRemove+'</div></div></div>');
		// editor.append(slideBox);
		// editorContainer = $('<div div id="'+cfg.editorID+'-container" class="presentation-editor-container"></div>');		
		// slideBox.append(editorContainer);
		
		// 노드가 들어왔을때 하일라이트
		var orgBackgroundColor = null;
		var slideBox = $('#presentation_editor-container');
		editorContainer = $('#presentation_editor-container');
		slideBox.bind('mouseenter', function() {
			if(jMap.movingNode) {
				jMap.movingNode.hide();
			}
			
			if(jMap.movingNode && !jMap.movingNode.removed) {
				orgBackgroundColor = $(this).css('background-color');
				$(this).animate({
					'background-color': '#e9ecef'
				}, 500);
			}
		});
		slideBox.bind('mouseleave', function() {
			if(jMap.movingNode) {
				jMap.movingNode.show();
			}
			
			if(orgBackgroundColor) {
				$(this).animate({
					'background-color': orgBackgroundColor
				}, 500);
				orgBackgroundColor = null;
			}			
		}).bind('mouseup', function(e) {
			if(orgBackgroundColor) {
				$(this).animate({
					'background-color': orgBackgroundColor
				}, 500);
				orgBackgroundColor = null;
			}
			
			jMap.DragPaper = false;
			jMap.positionChangeNodes = false;

			if(jMap.movingNode && !jMap.movingNode.removed) {
			    jMap.movingNode.connection && jMap.movingNode.connection.line.remove();
				jMap.movingNode.remove();
				delete jMap.movingNode;
				
				jMap.dragEl._drag = null;
				delete jMap.dragEl._drag;
				
				EditorManager.addSlide(jMap.dragEl.node);
				
				jMap.dragEl = null;
				delete jMap.dragEl;
			} else {
				if(jMap.dragEl) {
					jMap.dragEl._drag = null;
					delete jMap.dragEl._drag;
				}
				jMap.dragEl = null;
				delete jMap.dragEl;
			}
		});
		
		// var mapDiv = document.getElementById("main");
		// height = mapDiv.offsetHeight - 130;
		// editorContainer.slimScroll({
		// 	height: height-320,
		// 	alwaysVisible: true
		// });
		
		
		// var selectedType = null;
		// var selectedTheme = null;
		// var typeBox = null;
		// var styleBox = null;
		// var ptTypeSelecter = null;		
		// var ptStyleSelecter = null;
		
		// Presentation Type Box
		// typeBox = $('<div class="pt-editor-box"><div class="pt-editor-box-title">'+_presenType+'</div><div class="pt-frame"><div id="pttype-selected"></div><div class="pt-buttons"><span id="pttype-selecter-img"></span><span id="pttype-selecter-arrow"><div id="pttype-selecter" class="pt-selecter"></div></span></div></div></div>');
		// editor.append(typeBox);
		// ptTypeSelecter = typeBox.find('#pttype-selecter');
		// var selectedTypeName = typeBox.find('#pttype-selected').text();
		// var addType = function(type, typeName, displayName, previewUrl, select) {
		// 	var ptelement = $('<div class="pt-preview-container"><div class="pt-preview-name">'+displayName+'</div><div class="pt-preview"><img width="120px" height="95px" /></div></div>');
		// 	ptelement.find('img').attr('src', previewUrl);
		// 	ptelement.data('type', type);
		// 	ptelement.data('typeName', typeName);
		// 	ptelement.data('displayName', displayName);
		// 	ptTypeSelecter.append(ptelement);
			
		// 	ptelement.bind('click', function() {
		// 		var el = $(this);
		// 		typeBox.find('#pttype-selected').text(el.data('displayName'));
		// 		selectedType.removeClass('selected');
		// 		el.addClass('selected');
		// 		selectedType = el;				
		// 	});
			
		// 	if(select) {
		// 		typeBox.find('#pttype-selected').text(ptelement.data('displayName'));
		// 		ptelement.addClass('selected');
		// 		selectedType = ptelement;
		// 	}
		// }
		// 'Dynamic' 'Box' 'Aero' 'Linear' 'Mindmap - Basic' 'Mindmap - Zoom'
		// addType(Types.Dynamic, 'Dynamic', _presenDynamic, jMap.cfg.contextPath+'/plugin/presentation/images/types/prezilike.png', true);
		// addType(Types.Slide, 'Box', _presenBox, jMap.cfg.contextPath+'/plugin/presentation/images/types/box.png');
		// addType(Types.Slide, 'Aero', _presenAero, jMap.cfg.contextPath+'/plugin/presentation/images/types/aero.png');
		// addType(Types.Slide, 'Linear', _presenLinear, jMap.cfg.contextPath+'/plugin/presentation/images/types/linear.png');
		// addType(Types.Mindmap, 'Mindmap - Basic', _presenBasic, jMap.cfg.contextPath+'/plugin/presentation/images/types/mindmap_basic.png');
		// addType(Types.Mindmap, 'Mindmap - Zoom', _presenZoom, jMap.cfg.contextPath+'/plugin/presentation/images/types/mindmap_zoom.png');		
		
		// typeBox.find('.pt-buttons').bind('click', function() {
		// 	if(ptTypeSelecter.css('display') == 'none') {
		// 		ptStyleSelecter.fadeOut("slow");
		// 		ptTypeSelecter.fadeIn("slow");
		// 	}else {
		// 		ptTypeSelecter.fadeOut("slow");
		// 	}
		// }); 
		
		// Presentation Style Box
		// styleBox = $('<div class="pt-editor-box"><div class="pt-editor-box-title">'+_presenBackground+'</div><div class="pt-frame"><div id="ptstyle-selected"></div><div class="pt-buttons"><span id="ptstyle-selecter-img"></span><span id="ptstyle-selecter-arrow"><div id="ptstyle-selecter" class="pt-selecter"></div></span></div></div></div>');
		// editor.append(styleBox);
		// ptStyleSelecter = styleBox.find('#ptstyle-selecter');
		// for(var t = 0; t < themes.length; t++) {
		// 	var theme = themes[t];			
		// 	var ptelement = $('<div class="pt-preview-container"><div class="pt-preview-name">'+theme[1]+'</div><div class="pt-preview"><img width="120px" height="95px" /></div></div>');

		// 	var previewUrl = jMap.cfg.contextPath+'/plugin/presentation/theme/'+theme[2];	
		// 	ptelement.find('img').attr('src', previewUrl);
		// 	ptelement.data('theme', theme[0]);
		// 	ptelement.data('themeName', theme[1]);
		// 	ptStyleSelecter.append(ptelement);
			
		// 	ptelement.bind('click', function() {
		// 		var el = $(this);
		// 		styleBox.find('#ptstyle-selected').text(el.data('themeName'));
		// 		selectedTheme.removeClass('selected');
		// 		el.addClass('selected');
		// 		selectedTheme = el;
		// 	});
			
		// 	if(t == 0) {
		// 		styleBox.find('#ptstyle-selected').text(ptelement.data('themeName'));
		// 		ptelement.addClass('selected');
		// 		selectedTheme = ptelement;
		// 	}
		// }
		
		// styleBox.find('.pt-buttons').bind('click', function() {
		// 	if(ptStyleSelecter.css('display') == 'none'){				
		// 		if(Types.Slide == selectedType.data('type') ||
		// 				Types.Dynamic == selectedType.data('type')) {
		// 			ptTypeSelecter.fadeOut("slow");
		// 			ptStyleSelecter.fadeIn("slow");
		// 		}
		// 	} else {
		// 		ptStyleSelecter.fadeOut("slow");
		// 	}
		// });
		
		// Start Box
		// var startBox = $('<div class="pt-start">'+_presenStart+'</div>');
		var startBox = $('#pt-start');
		// editor.append(startBox);
		if(startBox.length) startBox.click(function() {
			// var theme = selectedTheme.data('theme');
			// var typeName = selectedType.data('typeName');
			// var type = selectedType.data('type');
			var type = $('input[name=pt-type]:checked').val();
			var style = $('input[name=pt-style]:checked').val();
			
			jMap.cfg.presentationMode = true;
				
			// if(type == Types.Mindmap) {
			// 	if(typeName == 'Mindmap - Zoom') {
			// 		ScaleAnimate.showStyle = ScaleAnimate.scaleToScreenFitWithZoomInOut;
			// 		ScaleAnimate.startShowMode(30, 20, true);
			// 	} else {
			// 		ScaleAnimate.showStyle = ScaleAnimate.scaleToScreenFit;
			// 		ScaleAnimate.startShowMode(30, 20, true);
			// 	}
			// } else {
			// 	Presentation.setEffect(typeName);
			// 	Presentation.setStyle(theme);
			// 	Presentation.start();
			// }
			if(type == 'Mindmap - Basic') {
				navbarMenusToggle(false);

				ScaleAnimate.showStyle = ScaleAnimate.scaleToScreenFitWithZoomInOut;
				ScaleAnimate.startShowMode(30, 20, true);
			} else if(type == 'Mindmap - Zoom') {
				navbarMenusToggle(false);
				
				ScaleAnimate.showStyle = ScaleAnimate.scaleToScreenFit;
				ScaleAnimate.startShowMode(30, 20, true);
			} else {
				presentationEdit = {
					type: type,
					style: style
				};
				presentationStartMode();
			}
		});
		
		// editor.find('#pt-editor-bar-close').click(function() {
		// 	EditorManager.hide();
		// })
		
		editorContainer.sortable({
			start: function(e, ui) {
		        $(this).attr('data-previndex', ui.item.index());
		    },
		   update: function(event, ui) {
			   var oldIndex = $(this).attr('data-previndex');
			   var newIndex = ui.item.index();
			   $(this).removeAttr('data-previndex');
			   
			   updateSequence();
			   
			   jMap.fireActionListener(ACTIONS.ACTION_PRESENTATION_MOVE, oldIndex, newIndex);
		   }
		});
		editorContainer.disableSelection();
		return editor;
	}
	
	/**
	 * 편집창에 깊이1인 자식들을 자동으로 추가한다.
	 */
	var createGeneralEditor = function(){
		editor = $('#'+cfg.editorID);
		// if(!editor[0]){
		// 	createEditor();
		// }
		createEditor();
		
		$.ajax({
			type: 'post',
			dataType: 'json',
			async: false,
			url: jMap.cfg.contextPath+'/mindmap/mappreference.do',
			data: {	'mapid': jMap.cfg.mapId,
						'returntype': 'json'
			},
			success: function(data) {
				var configs = data[0];
				var pt_sequence = configs.pt_sequence;
				
				if(pt_sequence == null || pt_sequence == "") {
//					var children = jMap.getRootNode().getChildren();
//					for(var i = 0; i < children.length; i++){
//						var node = children[i];						
//						if(node.position == 'right') insertSlide(node);
//					}
//					for(var i = 0; i < children.length; i++){
//						var node = children[i];						
//						if(node.position == 'left') insertSlide(node);
//					}
//					
//					updateSequence();
//					Presentation.saveSlide();
				} else {
					var sequence = pt_sequence.split(' ');
					for(var i = 0; i < sequence.length; i++) {
						var id = sequence[i];					
						if(id != null && id != '') {
							var node = jMap.getNodeById(id);
							if(node) insertSlide(node);						
						}						
					}
					
				}
				
				updateEditor();
				editorContainer.sortable( "refresh" );
				
				EditorManager.triggerListener();

				editor.addClass('loaded');
			},
			error: function(data, status, err) {
				alert("pt sequence : " + status);
			}
		});
	}
	
	EditorManager_addSlide = function(id) {
		var node = jMap.getNodeById(id);
		EditorManager.addSlideExecute(node);
		
		updateEditor();
	}
	
	EditorManager_deleteSlide = function(sortOrder) {
		var children = editorContainer.children();
		
		var slide = $(children[sortOrder - 1]);
		var pt = EditorManager.getPresentationElementById(slide.data('ptid'));
		
		deleteSlideExecute(slide, pt);
		
		updateEditor();
	}
	
	EditorManager_updateSlide = function(sortOrder, depth) {
		var children = editorContainer.children();
		
		var slide = $(children[sortOrder - 1]);
		var pt = EditorManager.getPresentationElementById(slide.data('ptid'));
		
		updateSlideExecute(slide, pt, depth);
		
		updateEditor();
	}
	
	EditorManager_moveSlide = function(from, to) {
		var slides = editorContainer.children();
		var slide = slides.splice(from, 1).shift();
		var element = Elements.splice(from, 1).shift();
		
		slides.splice(to, 0, slide);
		Elements.splice(to, 0, element);
		
		editorContainer.empty();
		for(var i = 0; i < slides.length; ++i) {
			var $el = $(slides[i]);
			$el.data('ptid', Elements[i].id);
			editorContainer.append($el);
		}
		
		editorContainer.sortable( "refresh" );
		updateEditor();
	}
	
	
	
	EditorManager.start = function(){
		Presentation.setEffect("Box");
		Presentation.setStyle("BlackLabel");
		Presentation.start();
	}
	
	EditorManager.show = function () {
		editor = $('#'+cfg.editorID);
		// if(editor[0]){
		// 	// 이미 생성되어 있으면 보이기
		// 	editor.show();
		// } else {
		// 	// 에디터 생성						
		// 	createGeneralEditor();
		// }
		if(!editor.hasClass('loaded')) {
			createGeneralEditor();
		}
		if(editorContainer.html() == ""){
			this.setDefaultSlide();
		}
	}
	
	EditorManager.hide = function () {		
		// editor && editor.hide();
	}
	
	EditorManager.setDefaultSlide = function () {
		var children = editorContainer.children();
		for(var i = 0; i < children.length; i++ ){
			var slide = $(children[i]);
			var pt = EditorManager.getPresentationElementById(slide.data('ptid'));
			deleteSlideExecute(slide, pt);
			updateEditor();
		}
		
		
		var children = jMap.getRootNode().getChildren();
//		for(var i = 0; i < children.length; i++){
//			var node = children[i];						
//			if(node.position == 'right'){
//				insertSlide(node);
//				updateEditor();
//			}
//		}
//		for(var i = 0; i < children.length; i++){
//			var node = children[i];						
//			if(node.position == 'left'){
//				insertSlide(node);
//				updateEditor();
//			}
//		}
		for(var i = 0; i < children.length; i++){
			var node = children[i];						
			insertSlide(node);
			updateEditor();
		}
	}
	
	EditorManager.getConfig = function () {
		return cfg;
	}
	
	EditorManager.getPresentationElements = function () {
		return Elements;
	}
	
	EditorManager.getPresentationElement = function (pos) {
		if(pos > EditorManager.getSequenceSize()) return null;
		
		return Elements[pos]; 
	}
	
	EditorManager.getPresentationElementById = function (id) {
		for(var i = 0; i < Elements.length; i++) {
			if(Elements[i].id == id) {
				return Elements[i];
			}
		}
		
		return null;
	}
	
	EditorManager.getPresentationElementByNodeId = function (id) {
		var ptElements = Array();
		
		for(var i = 0; i < Elements.length; i++) {
			if(Elements[i].node.getID() == id) {
				ptElements.push(Elements[i]);
			}
		}
		
		return ptElements;
	}
	
	EditorManager.getPresentationElementSize = function () {
		//return Object.keys(Elements).length;
		return Elements.length;
	}
	
	EditorManager.getSequenceSize = function () {
		return Sequence.length;		
	}
	
	EditorManager.addSlide = function (node) {
		this.addSlideExecute(node);
		updateSequence();
		Presentation.saveSlide();
		
		jMap.fireActionListener(ACTIONS.ACTION_PRESENTATION_INSERT, node);
	}
	
	EditorManager.addSlideExecute = function (node) {
		insertSlide(node);
		editorContainer.sortable( "refresh" );
	}
	
	EditorManager.triggerListener = function () {
		nodeRemovedListener = jMap.addActionListener(ACTIONS.ACTION_NODE_REMOVE, function(){
			var node = arguments[0];
			editorContainer.sortable( "refresh" );
//			updateEditor();
			// while (!node.isRootNode() && EditorManager.getPresentationElementById(node.getID()) == undefined) {
			// 	node = node.getParent();
			// }
			// updateNode(node);
			updateSequence();
		});
		nodeEditedListener = jMap.addActionListener(ACTIONS.ACTION_NODE_EDITED, function(){
			var node = arguments[0];
//			updateEditor();
			// while (!node.isRootNode() && EditorManager.getPresentationElementById(node.getID()) == undefined) {
			// 	node = node.getParent();
			// }
			if(EditorManager.getPresentationElementByNodeId(node.id).length) updateNode(node);
		});
		nodeImageListener = jMap.addActionListener(ACTIONS.ACTION_NODE_IMAGE, function(){
			var nodeid = arguments[0];
			if(EditorManager.getPresentationElementByNodeId(nodeid).length) updateNode(jMap.getNodeById(nodeid));
		});
		nodeFileListener = jMap.addActionListener(ACTIONS.ACTION_NODE_FILE, function(){
			var node = arguments[0];
			if(EditorManager.getPresentationElementByNodeId(node.id).length) updateNode(node);
		});
		nodeVideoListener = jMap.addActionListener(ACTIONS.ACTION_NODE_FOREIGNOBJECT, function(){
			var node = arguments[0];
			if(EditorManager.getPresentationElementByNodeId(node.id).length) updateNode(node);
		});
		nodeHyperlinkListener = jMap.addActionListener(ACTIONS.ACTION_NODE_HYPER, function(){
			var node = arguments[0];
			if(EditorManager.getPresentationElementByNodeId(node.id).length) updateNode(node);
		});
		nodeNoteListener = jMap.addActionListener(ACTIONS.ACTION_NODE_NOTE, function(){
			var node = arguments[0];
			if(EditorManager.getPresentationElementByNodeId(node.id).length) updateNode(node);
		});
	}
	
	EditorManager.destroyListener = function () {
		jMap.removeActionListener(nodeRemovedListener);	// 노드 삭제 리스너 해제
		nodeRemovedListener = null;
		jMap.removeActionListener(nodeEditedListener);	// 노드 편집 리스너 해제
		nodeEditedListener = null;
		jMap.removeActionListener(nodeImageListener);
		nodeImageListener = null;
		jMap.removeActionListener(nodeFileListener);
		nodeFileListener = null;
		jMap.removeActionListener(nodeVideoListener);
		nodeVideoListener = null;
		jMap.removeActionListener(nodeHyperlinkListener);
		nodeHyperlinkListener = null;
		jMap.removeActionListener(nodeNoteListener);
		nodeNoteListener = null;
	}
	
	EditorManager.temporarily = function () {
		Presentation.setEffect("Dynamic");
		Presentation.setStyle("BlackLabel");
		Presentation.start();
	}

	EditorManager.attachMenuAction = function(fn, id) {
		var node = jMap.getNodeById(id);
		if(node && window[fn]) {
			node.focus(true);
			window[fn]();
		}
	};
	
	return EditorManager;
})();



