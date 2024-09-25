<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>

<script defer type="text/javascript">
	// =============================================================================
	// MINDMAP
	// =============================================================================
	var thumbnail = function () {
		function savePNG() {
			var dx = 0;
			var dy = 0;

			var layoutType = jMap.getLayoutManager().type;
			if (layoutType == "jMindMapLayout" ||
				layoutType == "jTreeLayout" ||
				layoutType == "jHTreeLayout") {
				var node = jMap.getRootNode();
				var location = node.getLocation();
				var size = node.getSize();

				var svg = $(jMap.work).find('svg')[0];
				var bbox = getBBox(svg);

				// Center of svg
				var cx = bbox.x + bbox.width / 2;
				var cy = bbox.y + bbox.height / 2;

				// Center of root node
				var ncx = location.x + size.width / 2;
				var ncy = location.y + size.height / 2;

				dx = cx - ncx;
				dy = cy - ncy;
			}

			var cnvs = document.getElementById('svgcanvas');
			if (!cnvs) return;

			var dataURL = cnvs.toDataURL('image/png');

			var params = {
				"id": mapId,
				"base64": dataURL,
				"dx": parseInt(dx),
				"dy": parseInt(dy)
			};
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/thumb.do',
				data: params,
				success: function () { },
				error: function (data, status, err) {
				}
			});
		}

		//export to SVG and then render SVG on a canvas. Finally export to PNG.
		toSVGString(function (svgText, width, height) {
			var w = width * jMap.cfg.scale;
			var h = height * jMap.cfg.scale;
			var width =  w;// > 500 ? 500 : w;
			var height = h;// > 300 ? 300 : h;

			svgText = svgText.replace(/(<svg.*? width=")(.*?)(")/i, "$1" + width + "$3");
			svgText = svgText.replace(/(<svg.*? height=")(.*?)(")/i, "$1" + height + "$3");

			canvg(document.getElementById('svgcanvas'), svgText, {
				ignoreMouse: true,
				ignoreAnimation: true,
				offsetX: 0,
				offsetY: 0,
				useCORS: true,
				renderCallback: savePNG,
				log: false
			});
		});
		
	};

	var getBBox = function (svg) {
		var bbox = { x: svg.getBBox().x, y: svg.getBBox().y };
		//alert('after1: ' + bbox.x + ' ' + bbox.y);

		//FIX for SAFARI
		var bounds = {
			minX: Number.MAX_VALUE, minY: Number.MAX_VALUE,
			maxX: Number.MIN_VALUE, maxY: Number.MIN_VALUE,
			expandBy: function (box) {
				this.minX = Math.min(this.minX, box.x);
				this.minY = Math.min(this.minY, box.y);
				this.maxX = Math.max(this.maxX, box.x + box.width);
				this.maxY = Math.max(this.maxY, box.y + box.height);
			},
			width: function () { return this.maxX - this.minX; },
			height: function () { return this.maxY - this.minY; }
		};

		RAPHAEL.forEach(function (el) {
			if (el.node.style.display != "none") {
				var bb = el.getBBox();
				if (bb.x > 8 && bb.y > 8 && bb.width > 0 && bb.height > 0)
					bounds.expandBy(bb);
			}
		});

		//alert('after2: ' + bounds.minX + ' ' + bounds.minY);
		switch (jMap.cfg.nodeStyle) {
			case 'jSunburstNode':
				var radius = jMap.layoutManager.radius;
				bbox.x = jMap.layoutManager.getCenterLocation().x - radius;
				bbox.y = jMap.layoutManager.getCenterLocation().y - radius;
				bbox.width = radius * 2;
				bbox.height = radius * 2;
				break;
			case 'jZoomableTreemapNode':
				bbox.x = jMap.layoutManager.getCenterLocation().x;
				bbox.y = jMap.layoutManager.getCenterLocation().y;
				bbox.width = jMap.layoutManager.width;
				bbox.height = jMap.layoutManager.height;
				break;
			case 'jPartitionNode':
				bbox.x = jMap.layoutManager.getCenterLocation().x;
				bbox.y = jMap.layoutManager.getCenterLocation().y;
				bbox.width = jMap.layoutManager.width;
				bbox.height = jMap.layoutManager.height;
				break;
			default:
				bbox.x = bounds.minX;
				bbox.y = bounds.minY;
				bbox.width = bounds.width();
				bbox.height = bounds.height();
		}
		//END FIXED For SAFARI

		return bbox;
	};

	var toSVGString = function (callback) {
		//				var myRe = /(<svg[^>]*[>])(.*)([<]\/svg[>])/gi;
		//				var myArray = myRe.exec(jMap.work.innerHTML);
		//				// 0 : 전체
		//				// 1 : <svg id="paper_mapview" height="3000" width="5000" version="1.1" xmlns="http://www.w3.org/2000/svg">
		//				// 2 : <svg> 태그 안에 내용
		//				// 3 : </svg>
		//				
		//				var svgText = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.0//EN' 'http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd'>";
		//				svgText += myArray[1];
		//				svgText += myArray[2];
		//				svgText += myArray[3];
		RAPHAEL.safari();

		var re = /(<svg[^]*?svg>)/gi; //[^] match everything, even line terminators

		var found = re.exec(jMap.work.innerHTML);

		var svgText = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">";
		svgText += found[1];

		svgText = svgText.replace('<body><!-- ', '<body>');
		svgText = svgText.replace(' --></body>', '</body>');
		svgText = svgText.replace('data-src=', 'src=');

		// 추가정보
		var re_xlink = /(xmlns=["]http[:][/]+www[.]w3[.]org[/]2000[/]svg["])/gi;
		svgText = svgText.replace(re_xlink, '$1 xmlns:xlink="http://www.w3.org/1999/xlink"');

		// 이미지 태그의 href에 xlink
		var re_href = /( href=)/gi;
		svgText = svgText.replace(re_href, ' xlink:href=');

		// Safari export namespace by NS1, NS2, ...
		svgText = svgText.replace(/ NS[0-9]+:(.*?=)/gi, ' xlink:$1');

		// closing Tag가 없는것들..
		var re_param = /(<param[^>]*)/gi;
		svgText = svgText.replace(re_param, "$1/");

		var re_embed = /(<embed[^>]*)/gi;
		svgText = svgText.replace(re_embed, "$1/");

		/*
		if (BrowserDetect.browser == "Firefox"){
			var re_image = /(<image[^>]*)/gi;
			svgText = svgText.replace(re_image, "$1/");
		}*/

		//var iframe_reg = /<foreignObject.*?<body.*?<iframe.*?<\/iframe><\/body><\/foreignObject>/gi;
		var iframe_reg = /<foreignObject[^]*?<\/foreignObject>/gi;
		var array_iframe = svgText.match(iframe_reg);

		var all_images = {};
		var all_foreigns = {};
		var all_sources = {};
		var youtubeCheck = /youtube.com\/embed\/.*?\"/g;

		if (array_iframe != null) {
			var aiLength = array_iframe.length;
			//for (var key = 0; key < array_iframe.length; key++ ){
			for (var key = 0; key < aiLength; key++) {
				var foreign = array_iframe[key];
				// alert('found: ' + foreign);
				var if_reg = /<iframe/i;
				var imageUrl = '';
				if (if_reg.test(foreign)) {
					var src = foreign.replace(/[^]*?<iframe.*?src="(.*?)"[^]*/i, "$1");
					if (youtubeCheck.test(foreign)) {
						var youtybeUrl = foreign.match(youtubeCheck)[0];
						foreign = foreign.replace("data-src=\"" + youtybeUrl + "\"", " ");
						var youtubeId = youtybeUrl.replace(/(youtube.com\/embed\/)(.*?)\"/g, "$2");
						imageUrl = "http://img.youtube.com/vi/" + youtubeId + "/0.jpg";
					} else {
						imageUrl = jMap.cfg.contextPath + "/images/iframeimage.png";
					}

					foreign_width = foreign.match(/<foreignObject.*?width\=".*?\"/g)[0].match(/width\=".*?\"/g)[0];

					foreign = foreign.replace(/(<iframe.*?)(width\=\".*?\")(.*?)/g, "$1" + foreign_width + "$3");

					foreign_height = foreign.match(/<foreignObject.*?height\=".*?\"/g)[0].match(/height\=".*?\"/g)[0];

					foreign = foreign.replace(/(<iframe.*?)(height\=\".*?\")(.*?)/g, "$1" + foreign_height + "$3");

					foreign = foreign.replace(/margin-left:.*?px;margin-top:.*?px;/g, '');

					foreign = foreign.replace(/<body.*?>(.*?)<\/body>/g, "$1");

					foreign = foreign.replace(/(<iframe)(.*?<\/iframe>)/g, "$1 xmlns=\"http://www.w3.org/1999/xhtml\"$2");

					svgText = svgText.replace(array_iframe[key], foreign);

					all_sources[foreign] = imageUrl;
					all_images[imageUrl] = { el: '', data: '' };

				} else {
					//alert('webpage:' + foreign);
					all_foreigns[foreign] = { el: '', data: '' };
				}
			}
		}

		var svg = $(jMap.work).find('svg')[0];

		var bbox = getBBox(svg);

		var margin = 10;
		svgText = svgText.replace(/(<svg.*? width=")(.*?)(")/i, "$1" + (bbox.width + 2 * margin) + "$3");
		svgText = svgText.replace(/(<svg.*? height=")(.*?)(")/i, "$1" + (bbox.height + 2 * margin) + "$3");

		//remove old viewBox
		svgText = svgText.replace(/(<svg.*? )(viewBox=".*?")/i, "$1");

		svgText = svgText.replace(/(<svg.*?)>/i, '$1 viewBox="' + (bbox.x - margin) + " " + (bbox.y - margin) + " " + (bbox.width + 2 * margin) + " " + (bbox.height + 2 * margin) + '">');

		$.each($(svg).find('image'), function (k, img) {
			var src = $(img).attr('href');
			all_images[src] = { el: '', data: '' };
		});

		$.each($(svg).find('img'), function (k, img) {
			var src = $(img).attr('src');
			all_images[src] = { el: '', data: '' };
		});

		var webpage_reg = /<foreignObject.*?<body.*?<div[^]*?<\/div><\/body><\/foreignObject>/gi;;
		var array_webpage = svgText.match(webpage_reg);

		//Convert image to DataURL
		var full = location.protocol + '//' + location.hostname + (location.port ? ':' + location.port : '');
		function toDataUrl(url, callback) {
			var dfd = $.Deferred();

			var image_url = url;

			var regex = /.*(\.bmp|\.jpeg|\.wbmp|.\gif|\.png|\.jpg)$/i;
			if (!regex.test(image_url)) { //image format is not support by Java ImageIO
				image_url = jMap.cfg.contextPath + "/images/image_broken.png";
			}

			if (!image_url.startsWith("http")) {
				image_url = full + image_url;
			}

			var dfd = $.Deferred();
			var xhr = new XMLHttpRequest();
			xhr.onload = function () {
				var reader = new FileReader();
				reader.onloadend = function () {
					callback(reader.result, url, dfd);
					return dfd.promise();
				}
				reader.readAsDataURL(xhr.response);
			};

			var proxyUrl = image_url.startsWith(jMap.cfg.baseUrl) ? '' : 'https://cors-anywhere.herokuapp.com/';
//			xhr.open('GET', proxyUrl + image_url);
			xhr.open('GET', image_url);
			xhr.responseType = 'blob';
			xhr.send();

			return dfd.promise();
		}

		function getDataUri(url, el) {
			var dfd = $.Deferred();
			var image_url = url;
			var get_url = '';

			var regex = /.*(\.bmp|\.jpeg|\.wbmp|.\gif|\.png|\.jpg)$/i;
			if (!regex.test(image_url)) { //image format is not support by Java ImageIO
				image_url = jMap.cfg.contextPath + "/images/image_broken.png";
			}

			if (!image_url.startsWith("http")) {
				image_url = full + image_url;
				//alert(image_url);
			}

			get_url = jMap.cfg.contextPath + "/mindmap/convert.do?url=" + image_url;
			$.get(get_url, function (data) {
				all_images[url].data = "data:image/png;base64," + data;
				dfd.resolve('ok');
			});
			return dfd.promise();
		}

		function getSnapshot(fobj) {
			var dfd = $.Deferred();
			//alert('get ' + fobj);
			var src = fobj;

			var foreign_width = fobj.replace(/<foreignObject.*?width="(.*?)"[^]*/i, "$1");
			var foreign_height = fobj.replace(/<foreignObject.*?height="(.*?)"[^]*/i, "$1");

			var div_scale = fobj.replace(/[^]*?<div.*?scale\((.*?)\)[^]*/gi, "$1");
			div_scale = parseFloat(div_scale);
			if (isNaN(div_scale))
				div_scale = 1.0;

			//remove foreignobject, body
			fobj = fobj.replace(/<foreignObject.*?>/gi, "");
			fobj = fobj.replace(/<\/foreignObject>/gi, "");

			fobj = fobj.replace(/<body.*?>/gi, "");
			fobj = fobj.replace(/<\/body>/gi, "");

			fobj = fobj.replace(/scale\(.*?\)/gi, "scale(1)");


			fobj = fobj.replace(/(<img[^]*? src=")(.*?)(")/i, function (m, p1, p2, p3) {
				if (p2.startsWith("data:"))
					return m;

				return p1 + all_images[p2].data + p3;
			});

			var div = document.createElement("div");
			div.innerHTML = fobj;
			$(div).css("width", foreign_width / div_scale);
			$(div).css("height", foreign_height / div_scale);
			document.body.appendChild(div);

			//alert('before render:' + fobj);

			html2canvas([div], {
				onrendered: function (canvas) {
					try {
						//alert('render ' + src);
						//alert(all_foreigns[src].data);

						all_foreigns[src].data = canvas.toDataURL("image/png");

						document.body.removeChild(div);

						dfd.resolve();

					} catch (e) {
						alert(e.message);
					}
				}
			});
			//alert('dfd');
			return dfd.promise();
		}

		// IE11
		if (!String.prototype.startsWith) {
			String.prototype.startsWith = function (searchString, position) {
				position = position || 0;
				return this.indexOf(searchString, position) === position;
			};
		}

		var defers = [];
		for (var src in all_images) {
			if (!src.startsWith("data:")) {
				//defers.push(getDataUri(src, all_images[src].el));
				defers.push(toDataUrl(src, function (data, url, dfd) {
					all_images[url].data = data;//"data:image/png;base64," + data;

					dfd.resolve('ok');
				}));
			}
		}

		//image embeded
		var image_reg = /<image[^]*?<\/image>/gi;

		$.when.apply($, defers).done(function () { //all images are loaded
			svgText = svgText.replace(image_reg, function (match) {
				var image = match;
				//resolve src of image tag.
				image = image.replace(/(<image[^]*? xlink:href=")(.*?)("[^]*?>)/i, function (m, p1, p2, p3) {
					if (p2.startsWith("data:"))
						return m;

					return p1 + all_images[p2].data + p3;
				});

				return image;
			});

			var snapshot_defers = [];
			for (var fobj in all_foreigns) {
				//csedung only snaphsot display fobj
				if (fobj.includes("display: none;") == false) {
					snapshot_defers.push(getSnapshot(fobj));
				}
			}

			$.when.apply($, snapshot_defers).done(function () { //all snaphot are taken
				svgText = svgText.replace(iframe_reg, function (match) {
					var foreign = match;
					var foreign_width = foreign.match(/<foreignObject.*?width\=".*?\"/gi)[0].match(/width\=".*?\"/gi)[0];
					var foreign_height = foreign.match(/<foreignObject.*?height\=".*?\"/gi)[0].match(/height\=".*?\"/gi)[0];
					var foreign_x = foreign.match(/<foreignObject.*?x\=".*?\"/gi)[0].match(/x\=".*?\"/gi)[0];
					var foreign_y = foreign.match(/<foreignObject.*?y\=".*?\"/gi)[0].match(/y\=".*?\"/gi)[0];

					if (all_foreigns[match] === undefined) {
						var src = all_sources[foreign];
						if (src === undefined || all_images[src] === undefined)
							return match;
						var ifr_img = '<image ' + foreign_x + ' ' + foreign_y + ' ' + foreign_width + ' ' + foreign_height +
							' preserveAspectRatio="none" xlink:href="' + all_images[src].data + '" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); cursor: pointer;"></image>' +
							match;
						return ifr_img;
					}

					img_data = all_foreigns[match].data;
					var img = '<image ' + foreign_x + ' ' + foreign_y + ' ' + foreign_width + ' ' + foreign_height +
						' preserveAspectRatio="none" xlink:href="' + img_data + '" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); cursor: pointer;"></image>';

					return img;
				});

				callback(svgText, bbox.width, bbox.height); //callback
			});
		});
	};

	var runPNG = false;
	var exportToPNG = function () {
		requiredTierPolicy('export_png', function() {
			runPNG = true;
			function savePNG() {
				var cnvs = document.getElementById('svgcanvas');
				if (!cnvs) return;
				var a = document.createElement("a");
				a.download = "<c:out value='${data.map.name}'/>" + ".png";
				a.href = cnvs.toDataURL("image/png");
				a.click();
			}
	
			//export to SVG and then render SVG on a canvas. Finally export to PNG.
			toSVGString(function (svgText, width, height) {
				width = width * jMap.cfg.scale;
				height = height * jMap.cfg.scale;
	
				svgText = svgText.replace(/(<svg.*? width=")(.*?)(")/i, "$1" + width + "$3");
				svgText = svgText.replace(/(<svg.*? height=")(.*?)(")/i, "$1" + height + "$3");
				if (width > 32000 || height > 32000 || width * height > 10000000) {
					window.alert("<spring:message code='alert.bigPng'/>");
					return;
				}
				canvg(document.getElementById('svgcanvas'), svgText, {
					ignoreMouse: true,
					ignoreAnimation: true,
					offsetX: 0,
					offsetY: 0,
					useCORS: true,
					renderCallback: savePNG,
					log: false
				});
			});
		});
	};

	var runSVG = false;
	var exportToSVG = function () {
		requiredTierPolicy('export_svg', function() {
			runSVG = true;
			toSVGString(function (svgText) {
				var frm = document.getElementById("svg_export");
				frm.id.value = mapId,
					frm.type.value = "svg",
					frm.svg.value = escape(svgText);
				frm.submit();
			});
		});
	};

	function saveMap(bAsync, bSilent) {
		if (jMap.isSaved() && !shouldSave) {
			return;
		}

		if (menu_canEdit) {
			if (bSilent == null || bSilent == false) JinoUtil.waitingDialog("Saving Map");
			$.post("${pageContext.request.contextPath}/mindmap/timeline.do", { "mapId": mapId }, function (data) {
				JinoUtil.waitingDialogClose();
				jMap.setSaved(true);
			});
		}
	};

	// =============================================================================
	// NODE EDIT
	// =============================================================================
	var ShiftenterAction = function () {
		jMap.controller.ShiftenterAction();
	};
	var insertAction = function () {
		jMap.controller.insertAction();
	};
	var insertSiblingAction = function () {
		jMap.controller.insertSiblingAction();
	};
	var foldingAction = function () {
		jMap.controller.foldingAction();
	};
	var foldingAllAction = function () {
		jMap.controller.foldingAllAction();
	};
	var unfoldingAllAction = function () {
		jMap.controller.unfoldingAllAction();
	};
	var fold = true;
	var foldingall = function () {
		if (fold) {
			foldingAllAction();
			fold = false;
		} else {
			unfoldingAllAction();
			fold = true;
		}
	};

	var insertTextOnBranchAction = function () {
		jMap.controller.insertTextOnBranch();
	};
	var cutAction = function () {
		jMap.controller.cutAction();
	};
	var copyAction = function () {
		jMap.controller.copyAction();
	};
	var pasteAction = function () {
		jMap.controller.pasteAction();
	};
	var deleteAction = function () {
		jMap.controller.deleteAction();
	};
	var editNodeAction = function () {
		jMap.controller.editNodeAction();
	};
	var insertHyperAction = function () {
		jMap.controller.insertHyperAction();
	};
	var nodeToNodeAction = function(){
		jMap.controller.nodeToNodeAction();
		//settingArrowLink();
	};
	var doNodeToNodeAction = function(){
		//jMap.controller.doNodeToNodeAction();
		settingArrowLink();
	};
	var removeArrowLink = function(){
		jMap.controller.removeArrowLink();
	};
	var settingArrowLink = function(){
		var selectedNodes = jMap.getSelecteds();
		if (selectedNodes.length == 0) return false;
		for (var i = 0; i < selectedNodes.length; i++) {
			if (!jMap.isAllowNodeEdit(selectedNodes[i])) {
				return false;
			}
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/arrowSetting.jsp",
			title: "<spring:message code='menu.settingArrowLink'/>",
			nopadding: true
		});
	};
	
	
	var imageProviderAction = function () {
		var selected = jMap.getSelected();
		if (!jMap.isAllowNodeEdit(selected)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/media/image.do",
			title: "<spring:message code='image.image_add'/>",
			size: "modal-lg",
			nopadding: true
		});
	};

	var videoProviderAction = function () {
		var selected = jMap.getSelected();
		if (!jMap.isAllowNodeEdit(selected)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/media/video.do",
			title: "<spring:message code='menu.media.video'/>",
			nopadding: true
		});
	};

	var insertWebPageAction = function () {
		var node = jMap.getSelected();

		if (!node || !jMap.isAllowNodeEdit(node)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/insertWebPageAction.jsp",
			title: "<spring:message code='menu.edit.webpage'/>",
			size: "modal-lg",
			nopadding: true
		});
	};

	var insertIFrameAction = function () {
		var node = jMap.getSelected();

		if (!node || !jMap.isAllowNodeEdit(node)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/insertIFrameAction.jsp",
			title: "<spring:message code='menu.edit.iframe'/>"
		});
	};

	var fileProviderAction = function () {
		var node = jMap.getSelected();

		if (!node || !jMap.isAllowNodeEdit(node)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/media/file.do",
			title: "<spring:message code='menu.fileProviderAction'/>",
			nopadding: true
		});
	};

	var insertNoteAction = function () {
		var node = jMap.getSelected();

		if (!node || !jMap.isAllowNodeEdit(node)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/insertNoteAction.jsp",
			title: "<spring:message code='menu.insertNoteAction'/>",
			nopadding: true
		});
	};

	var showNoteAction = function (id) {
		var node = jMap.getSelected();

		if (!node || !jMap.isAllowNodeEdit(node)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/insertNoteAction.jsp?show=true",
			title: "<spring:message code='menu.insertNoteAction'/>",
			nopadding: true
		});
	};

	var insertLTIAction = function () {
		var node = jMap.getSelected();

		if (!node || !jMap.isAllowNodeEdit(node)) {
			return false;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/insertLTIAction.jsp",
			title: "<spring:message code='menu.insertLTIAction'/>"
		});
	};

	var iotProvidersAction = function (control) {
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/iot/providers.do?control=" + (control ? "1" : "0"),
			title: "<spring:message code='menu.iotProvidersAction'/>"
		});
	};
	var iotControlAction = function () {
		iotProvidersAction(true);
		//iotInsertDeviceAction();
	};

	var increaseFontSizeAction = function () {
		var selected = jMap.getSelected();
		if (!selected || !jMap.isAllowNodeEdit(selected)) {
			return false;
		}

		var fontSize = selected.getFontSize();
		fontSize = parseInt(fontSize) + 1;
		if (fontSize > jMap.cfg.nodeMaxFontSize) {
			fontSize = jMap.cfg.nodeMaxFontSize;
		}

		selected.setFontSize(fontSize);
	};

	var decreaseFontSizeAction = function () {
		var selected = jMap.getSelected();
		if (!selected || !jMap.isAllowNodeEdit(selected)) {
			return false;
		}

		var fontSize = selected.getFontSize();
		fontSize = parseInt(fontSize) - 1;
		if (fontSize < jMap.cfg.nodeMinFontSize) {
			fontSize = jMap.cfg.nodeMinFontSize;
		}

		selected.setFontSize(fontSize);
	};
	
	var setNodeFontSize = function(fontSize){
		var selected = jMap.getSelected();
		if (!selected || !jMap.isAllowNodeEdit(selected)) {
			return false;
		}

		if (fontSize < jMap.cfg.nodeMinFontSize) {
			fontSize = jMap.cfg.nodeMinFontSize;
		}

		selected.setFontSize(fontSize);
	}
	
	var getNodeFontSize = function(){
		var selected = jMap.getSelected();
		if (!selected || !jMap.isAllowNodeEdit(selected)) {
			return 1;
		}
		return selected.getFontSize();
	}

	var nodeTextColorAction = function () {
		var selectedNodes = jMap.getSelecteds();
		if (selectedNodes.length == 0) return false;
		for (var i = 0; i < selectedNodes.length; i++) {
			if (!jMap.isAllowNodeEdit(selectedNodes[i])) {
				return false;
			}
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/nodeTextColorAction.jsp",
			title: "<spring:message code='menu.nodeTextColorAction'/>",
			nopadding: true
		});
	};

	var nodeEdgeColorAction = function () {
		var selectedNodes = jMap.getSelecteds();
		if (selectedNodes.length == 0) return false;
		for (var i = 0; i < selectedNodes.length; i++) {
			if (!jMap.isAllowNodeEdit(selectedNodes[i])) {
				return false;
			}
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/nodeEdgeColorAction.jsp",
			title: "<spring:message code='menu.nodeEdgeColorAction'/>",
			nopadding: true
		});
	};

	var nodeBGColorAction = function () {
		var selectedNodes = jMap.getSelecteds();
		if (selectedNodes.length == 0) return false;
		for (var i = 0; i < selectedNodes.length; i++) {
			if (!jMap.isAllowNodeEdit(selectedNodes[i])) {
				return false;
			}
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/nodeBGColorAction.jsp",
			title: "<spring:message code='menu.nodeBGColorAction'/>",
			nopadding: true
		});
	};

	var nodeEdgeWidthAction = function (w) {
		var selected = jMap.getSelected();
		if (!selected || !jMap.isAllowNodeEdit(selected)) {
			return false;
		}
		jMap.controller.nodeEdgeWidthAction(w);
	};
	var nodeEdgeWidthAction1 = function () {
		nodeEdgeWidthAction(1);
	};
	var nodeEdgeWidthAction2 = function () {
		nodeEdgeWidthAction(2);
	};
	var nodeEdgeWidthAction4 = function () {
		nodeEdgeWidthAction(4);
	};
	var nodeEdgeWidthAction6 = function () {
		nodeEdgeWidthAction(6);
	};
	var nodeEdgeWidthAction8 = function () {
		nodeEdgeWidthAction(8);
	};

	var CtrlRAction = function () {
		resetCoordinateAction();
	};
	var resetCoordinateAction = function () {
		jMap.controller.resetCoordinateAction();
	};

	var changeNodeAllColorAction = function () {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		var node = jMap.rootNode;
		//var colorSelectList = [];
		//var isMixThmem = true;

		if (node == null || node == undefined) {
			return false;
		}

		if (!jMap.isAllowNodeEdit(node)) {
			return false;
		}

		var selectedNodes = jMap.getSelecteds();
		var selNodeLength = selectedNodes.length;
		for (var i = 0; i < selNodeLength; i++) {
			if (!jMap.isAllowNodeEdit(selectedNodes[i])) {
				return false;
			}
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/changeNodeAllColorAction.jsp",
			title: "<spring:message code='menu.theme'/>",
			nopadding: true
		});
	};

	var nodeColorMix = function () {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		NodeColorMix(jMap.rootNode);
	};

	var changeMapBackgroundAction = function () {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/changeMapBackgroundAction.jsp",
			title: "<spring:message code='menu.rollover.midnmap.mapbackgroundchange'/>",
			nopadding: true
		});
	};

	var googleSearch = function () {
		if (!$('#rightPanelFolding').hasClass('closed')) {
			rightPanelFolding();
		}

		var panel = $('#googleSearch');
		if (!panel.hasClass('loaded')) {
			panel.addClass('skeleton-loading');
			panel.addClass('loaded');
			panel.attr('src', panel.data('src'));
		}

		if (panel.hasClass('closed')) {
			panel.removeClass('closed');
		} else {
			panel.addClass('closed');
		}
	};

	var clipBoard = function () {
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/clipBoard.jsp",
			title: "<spring:message code='menu.import'/>",
			size: 'modal-lg'
		});
	};

	var importBookmark = function () {
		requiredTierPolicy('import_bookmark', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/mindmap/importBookmark.do",
				title: "<spring:message code='message.import.bookmark.upload'/>"
			});
		});
	};

	var importMap = function () {
		requiredTierPolicy('import_freemind', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/mindmap/importMap.do",
				title: "<spring:message code='message.import.freemind.upload'/>"
			});
		});
	};
	
	var importZipMap = function () {
		requiredTierPolicy('import_freemind', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/mindmap/importZipMaps.do",
				title: "<spring:message code='message.import.zipmaps.upload'/>"
			});
		});
	};

	var nodeStructureFromText = function () {
		requiredTierPolicy('import_text', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/nodeStructureFromText.jsp",
				title: "<spring:message code='common.create_node_text'/>",
				size: 'modal-lg'
			});
		});
	};

	var nodeStructureFromXml = function () {
		requiredTierPolicy('import_xml', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/nodeStructureFromXml.jsp",
				title: "<spring:message code='common.import_xml'/>",
				size: 'modal-lg'
			});
		});
	};

	var exportFile = function () {
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/exportFile.jsp",
			title: "<spring:message code='menu.export'/>",
			size: 'modal-lg'
		});
	};

	var exportToPPT = function () {
	/* 	if (!jMap.saveAction.isAlive()) {
			return null;
		}

		document.location.href = "${pageContext.request.contextPath}/export/ppt/" + mapId + "/" + removeIllegalFileNameChars(mapName) + ".ppt" */
	
		requiredTierPolicy('export_ppt', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/exportPpt.jsp",
				title: "<spring:message code='common.export_pptx' />",
				size: 'modal-lg'
			});
		});
	};
	
	var uploadSlideMaster = function(){
//		requiredTierPolicy('export_ppt', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/slideMasterUpload.jsp",
				title: "<spring:message code='common.uploadSlide' />",
				size: 'modal-md'
			});
//		});
	}
	
	var remixActions = function () {
			JinoUtil.closeDialog();
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/remixAction.jsp",
				title: "<spring:message code='menu.remixActions' />",
				size: 'modal-md'
			});
		};
	
	var removeIllegalFileNameChars = function (text) {
		return text.replace(/[\x00-\x1f:?\\/*"<>|]/gi, '_');
	};
	var exportToHTML = function () {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		requiredTierPolicy('export_html', function() {
			document.location.href = "${pageContext.request.contextPath}/export/html/" + mapId + "/" + removeIllegalFileNameChars(mapName) + ".zip";
		});
	};

	var exportToFreemind = function () {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		requiredTierPolicy('export_freemind', function() {
			document.location.href = "${pageContext.request.contextPath}/map/" + mapId + "/" + removeIllegalFileNameChars(mapName) + ".mm";
		});
	};

	var exportToText = function () {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		requiredTierPolicy('export_text', function() {
			var text = jMap.createTextFromNode(jMap.getRootNode(), "\t");
	
			var frm = document.getElementById("text_export");
			frm.id.value = mapId,
				frm.ext.value = "txt",
				frm.text.value = Base64.encode(escape(text));
			frm.submit();
		});
	};

	var nodeStructureToXml = function () {
		requiredTierPolicy('export_xml', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/nodeStructureToXml.jsp",
				title: "<spring:message code='common.export_xml'/>",
				size: 'modal-lg'
			});
		});
	};

	var nodeStructureToText = function () {
		requiredTierPolicy('export_textclipboard', function() {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/nodeStructureToText.jsp",
				title: "<spring:message code='menu.textimportexport.export'/>",
				size: 'modal-lg'
			});
		});
	};

	var saveAsMap = function () {
		if (!jMap.cfg.canEdit) return null;
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/saveAsMap.jsp",
			title: "<spring:message code='message.saveas'/>"
		});
	};

	var timelineMode = function () {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		location.href = "${pageContext.request.contextPath}/map/timeline/<c:out value='${data.map.key}'/>";
	};

	var createEmbedTag = function () {
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/createEmbedTag.jsp",
			title: "<spring:message code='message.mindmap.embed.setting'/>"
		});
	};

	var changeToMindmap = function () {
		requiredTierPolicy('mapstyle_mindmap', function() {
			jMap.setLayoutManager(new jMindMapLayout(jMap));
		});
	};
	var changeToCard = function () {
		requiredTierPolicy('mapstyle_card', function(){
			jMap.setLayoutManager(new jCardLayout(jMap));
		});
	};
	var changeToSunburst = function () {
		requiredTierPolicy('mapstyle_sunburst', function() {
			jMap.setLayoutManager(new jSunburstLayout(jMap));
		});
	};
	var changeToTree = function () {
		requiredTierPolicy('mapstyle_tree', function() {
			jMap.setLayoutManager(new jTreeLayout(jMap));
		});
	};
	var changeToHTree = function () {
		requiredTierPolicy('mapstyle_project', function() {
			jMap.setLayoutManager(new jHTreeLayout(jMap));
		});
	};
	var changeToPadlet = function () {
		requiredTierPolicy('mapstyle_padlet', function() {
			var total_nodes = Object.keys(jMap.nodes).length;
			var has_edit = false;
			var cnt = 0;

			var saveLocation = function(node) {
				if (!node)
					return;

				if (node.attributes == undefined) node.attributes = {};

				if (node.attributes['padlet_x'] == undefined || node.attributes['padlet_y'] == undefined) {
					has_edit = true;
					var loc = node.getLocation();
					//alert(node.plainText + ' x:' + loc.x + ' y: ' + loc.y);
					node.attributes['padlet_x'] = loc.x;
					node.attributes['padlet_y'] = loc.y;
					jMap.saveAction.editAction(node, null, function() {
						jMap.setLayoutManager(new jPadletLayout(jMap));
					});
				}

				if (node.folded == "false" || node.folded == false) {
					//var children = node.getUnChildren();
					var children = node.getChildren();
					if (children != null && children.length > 0) {
						for (var i = 0; i < children.length; i++) {
							saveLocation(children[i]);
						}
					}
				}

				cnt++;
				if(cnt == total_nodes && !has_edit) {
					jMap.setLayoutManager(new jPadletLayout(jMap));
				} 
			}

			var root = jMap.getRootNode();

			if(root.type == 'jRect') {
				//unfold all nodes for location
				root.setFoldingAll(false);
				jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
				jMap.layoutManager.layout(false);

				//save location nodes
				saveLocation(root);
			} else {
				// _gaq.push(['_trackEvent', 'Layout', 'Padlet']);
				jMap.setLayoutManager(new jPadletLayout(jMap));
			}
		});
	};
	var changeToPartition = function () {
		requiredTierPolicy('mapstyle_partition', function() {
			jMap.setLayoutManager(new jPartitionLayout(jMap));
		});
	};
	var changeToFishbone = function () {
		requiredTierPolicy('mapstyle_fishbone', function() {
			jMap.setLayoutManager(new jFishboneLayout(jMap));
		});
	};
	var changeToZoomableTreemap = function () {
		requiredTierPolicy('mapstyle_rect', function() {
			jMap.setLayoutManager(new jZoomableTreemapLayout(jMap));
		});
	};

	var splitMap = function () {
		if (jMap.cfg.isShrdGuest) {
			alert("<spring:message code='common.pleaselogin'/>");
		} else if (jMap.cfg.canEdit) {
			var node = jMap.selectedNodes.getLastElement();

			if (node == null || node == undefined) {
				alert("<spring:message code='message.newnodemap.choosenode'/>");
				return;
			}

			node.setFoldingExecute(false);

			if (node.isRootNode()) {
				alert("<spring:message code='message.newnodemap.rootrestriction'/>");
				return;
			}

			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/splitMap.jsp",
				title: "<spring:message code='menu.mindmap.newnodemap'/>"
			});
		} else {
			alert("<spring:message code='common.nogrant'/>");
		}
	};

	var changeMapName = function () {
		if (jMap.cfg.isShrdGuest) {
			alert("<spring:message code='common.pleaselogin'/>");
		} else if (jMap.cfg.mapOwner) {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/changeMapName.jsp",
				title: "<spring:message code='menu.mindmap.changntitle'/>"
			});
		} else {
			alert("<spring:message code='common.nogrant'/>");
		}
	};

	var delMap = function () {
		deleteMap(mapId);
	};

	var deleteMap = function (id) {
		if (jMap.cfg.isShrdGuest) {
			alert("<spring:message code='common.pleaselogin'/>");
		} else if (jMap.cfg.mapOwner) {
			var confirmed = confirm("<spring:message code='message.delete.confirm'/>");
			if (confirmed) {
				JinoUtil.waitingDialog("<spring:message code='common.wait' />");
				shouldSave = false;
				var sid = parseInt('<c:out value="${data.sid}"/>');
				document.location.href = "${pageContext.request.contextPath}/mindmap/delete.do?del_map=" + id + (sid ? '&sid=' + sid : '');
			}
		} else {
			alert("<spring:message code='message.mindmap.cannotdelete'/>");
		}
	};

	var shareManage = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/share/list.do?map_id=${data.mapId}",
			title: "<spring:message code='menu.setting.share'/>",
			nopadding: true
		});
	};

	var groupManage = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/group/list.do",
			title: "<spring:message code='menu.setting.group'/>",
			size: "modal-lg",
			nopadding: true
		});
	};

	var okmPreference = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/mindmap/mappreference.do?mapid=" + mapId,
			title: "<spring:message code='menu.okmpreference'/>",
			nopadding: true
		});
	};
	
	var usrPreference = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/user/userconfig.do?userid=" + jMap.cfg.userId,
			title: "<spring:message code='menu.usrpreference'/>",
			nopadding: true
		});
	};

	var activityMonitoring = function () {
		var path = location.pathname;
		window.open(path.substring(0, path.indexOf('/map', 0)) + "/viewqueue.do?page=" + location.pathname);
	};

	var setRestrictEditing = function () {
		if (!jMap.cfg.mapOwner) return;

		var checked = $("#restrict_editing").is(":checked");
		// DWR_setRestrictEditing(checked);
		jMap.fireActionListener(ACTIONS.ACTION_MAP_RESTRICT_EDITING, checked);
		jMap.cfg.restrictEditing = checked;

		// nvhoang
		var root = jMap.getRootNode();
		if (root.attributes == undefined)
			root.attributes = {};

		root.attributes['restrictEditing'] = checked ? 1 : 0;
		jMap.saveAction.editAction(root, false);
	};

	var addMoodleActivityAction = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/moodle/moodleActivity.do?mapid=${data.map.id}&mapkey=${data.map.key}&locale=${locale.language}",
			title: "<spring:message code='message.moodle.choose_activity'/>",
			size: "modal-lg"
		});
	};

	var insertActivityAction = function (link, attributes) {
		if (!jMap.saveAction.isAlive()) {
			return null;
		}

		var node = jMap.getSelecteds().getLastElement();
		if (node) {
			JinoUtil.closeDialog();
			J_NODE_CREATING = node;
			node.folded && node.setFolding(false);
			var param = { parent: node };
			var newNode = jMap.createNodeWithCtrl(param);
			if (attributes != undefined) newNode.attributes = attributes;
			if (link != undefined) newNode.setHyperlink(link);
			newNode.focus(true);

			jMap.layoutManager.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors(node);
			jMap.layoutManager.layout(true);

			newNode.setTextExecute("");
			jMap.controller.startNodeEdit(newNode);
		}
	};

	var courseEnrolment = function () {
		JinoUtil.showDialog({
			url: "${pageContext.request.contextPath}/moodle/courseEnrolment.do?mapid=${data.map.id}&tabtype=okmmusers",
			title: "<spring:message code='menu.setting.enrolment'/>",
			size: "modal-lg",
			nopadding: true
		});
	};

	var remixMap = function () {
		if (menu_canCopyNode) {
			JinoUtil.showDialog({
				url: jMap.cfg.contextPath + "/jsp/fn/remixMap.jsp",
				title: "<spring:message code='menu.mindmap.remixmap'/>"
			});
		} else {
			alert("<spring:message code='common.nogrant'/>");
		}
	}

	var mapOfRemixes = function () {
		if (menu_isOwner) {
			$.post(jMap.cfg.contextPath + '/mindmap/mapofremixes.do', {
				mapId: jMap.cfg.mapId,
				mapOfRemixes: (jMap.rootNode.attributes['mapOfRemixes'] || '')
			}, function (data) {
				if (data.redirect != '') {
					window.location.href = data.redirect;
				} else {
					alert("<spring:message code='common.nogrant'/>");
				}
			});
		} else {
			alert("<spring:message code='common.nogrant'/>");
		}
	}
	
	var exportMyData = function () {
		if (!jMap.cfg.isShrdGuest) {
			JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/fn/exportMyData.jsp",
				title: "<spring:message code='menu.export_my_data' />",
				size: 'modal-lg',
				nopadding: true
			});
		} else {
			alert("<spring:message code='common.nogrant'/>");
		}
	}
	
	var pleaseComfirmEmail = function(){
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/jsp/user/pleaseconfirm.jsp",
			title: "<spring:message code='menu.mindmap.newnodemap'/>"
		});
	}
	
	var setNodeMoodle = function(){
		for (var index = 0; index < Object.keys(jMap.nodes).length; index++) {
			var n = jMap.nodes[Object.keys(jMap.nodes)[index]];
			var is_moodle = Object.keys(n.attributes).join('_').indexOf('moodle');
			if(is_moodle >= 0) {
				n.setHasMoodleExecute();
			}
		}
	}
	
	var testLisScore = function(){
		$.ajax({
		      type: 'POST',
		      url: jMap.cfg.contextPath + '/mindmap/lisScore.do',
		      data: {node : jMap.getSelected().getID(), map : mapId},
		      dataType: "text",
		      success: function(data) { 
		    	  console.log(data); 
		    	  var arr = data.split('::');
		    	  console.log(arr[0], arr[1]);
		      }
		});
	}
	
	var testLis = function(){
		$.ajax({
		      type: 'POST',
		      url: jMap.cfg.contextPath + '/mindmap/lis.do',
		      data: {node : jMap.getSelected().getID(), map : mapId},
		      dataType: "application/xml",
		      success: function(data) { 
		    	  console.log(data); 
		      }
		});
	}
	
	var iotDeviceManagerAction = function () {
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/iot/devices.do",
			title: "IoT devices manager",
			size: "modal-md",
			nopadding: true
		});
	};
	
	var iotAddDeviceAction = function () {
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/iot/add.do",
			title: "IoT devices manager",
			size: "modal-md",
			nopadding: true
		});
	};
	
	var iotInsertDeviceAction = function () {
		JinoUtil.showDialog({
			url: jMap.cfg.contextPath + "/iot/readydevice.do",
			title: "Insert IoT device",
			size: "modal-md",
			nopadding: true
		});
	};
	
</script>