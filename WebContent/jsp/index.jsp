<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="bitly" uri="http://www.servletsuite.com/servlets/bitlytag" %>
<%@ taglib prefix="env" uri="http://www.servletsuite.com/servlets/enventry" %>

<%
	Boolean isembed = "off".equals(request.getParameter("m"));
	request.setAttribute("isembed", isembed);

	String useragent = (String)request.getAttribute("agent");
	request.setAttribute("useragent", useragent);

	request.setAttribute("user", session.getAttribute("user"));

	Locale locale = RequestContextUtils.getLocale(request);
	request.setAttribute("locale", locale);

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}

	StringBuffer url = request.getRequestURL();
	String uri = request.getRequestURI();
	String ctx = request.getContextPath();
	String base = url.substring(0, url.length() - uri.length() + ctx.length()) + "/";
%>

<!DOCTYPE html>
<html lang="${locale.language}">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta http-equiv="Cache-Control" content="no-cache">
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="Expires" content="0">
		<meta name="Description" content="<c:out value="${data.mapContentsText}"/>">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		
		<% if(useragent != null){ %>
			<!-- 아이폰 META -->
			<meta name="apple-mobile-web-app-capable" content="yes">
			<link rel="apple-touch-icon" href="${pageContext.request.contextPath}/images/mobile/appicon.png">
			<link rel="apple-touch-startup-image" href="${pageContext.request.contextPath}/images/mobile/startup.jpg">
		<% } %>

		<title><c:out value="${data.map.name}"/></title>
		
		<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/bootstrap4-toggle.min.css?v=<%=updateTime%>">
    	
		
		<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico?v=<%=updateTime%>" />
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui/jquery-ui.custom.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/okmindmap.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=<%=updateTime%>" type="text/css"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/impromptu.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/simplemodal.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dialog.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/opentab.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/okm-side.css?v=<%=updateTime%>" type="text/css" media="screen">		 --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/splitter.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/farbtastic/farbtastic.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/plugin/presentation/presentation.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		
	    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/menu/style.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
	    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/ribbonmenu/ribbon/user.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<script defer type="text/javascript" src='${pageContext.request.contextPath}/ribbonmenu/okmMenuRibbonEnable.js?v=<%=updateTime%>'></script>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/history.css?v=<%=updateTime%>" type="text/css"> --%>
		
		<!-- dtpicker -->
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dtpicker/jquery.simple-dtpicker.css?v=<%=updateTime%>" type="text/css"> --%>

		<!-- okmm theme -->
		<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>" type="text/css">
		<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		
		<%-- <script src="http://www.google.com/jsapi" type="text/javascript"></script> --%>
		<script src="${pageContext.request.contextPath}/lib/jquery.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script src="${pageContext.request.contextPath}/lib/jquery-ui.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery-bug.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/jquery.mobile.custom.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery.caret.1.02.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/yui-3.2.0-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/raphael.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/i18n.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		
		<%-- <script defer src="${pageContext.request.contextPath}/lib/json2.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery-impromptu.3.1.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/hahms-textgrow.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/luasog-0.3.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery.simplemodal.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/conversionfunctions.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/http.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jscolor/jscolor.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/timeline.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/slimScroll.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/popup_expiredays.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/splitter.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/farbtastic/farbtastic.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/jquery.cookie.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		
		<%-- <script defer src="${pageContext.request.contextPath}/lib/StackBlur.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		

		<script defer src="${pageContext.request.contextPath}/mayonnaise-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

		<script defer src="${pageContext.request.contextPath}/extends/ExArray.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/extends/ExRaphael.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script src="${pageContext.request.contextPath}/extends/javascript-chat.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>		
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_delicious.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/plugin/jino_socket.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_google_searcher.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_facebook.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/plugin/jino_node_color_mix.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_twitter.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_wiki.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/plugin/NodeColorUtil.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/plugin/TestRobot.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/slideshare-service.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/map_of_delicious.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/collabDocument.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>		 --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/testcode.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/jmpress/jmpress.all.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/presentation.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/editorManager.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_nodeTheme.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>		 --%>
		<script src="${pageContext.request.contextPath}/plugin/okm-chat.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script src="${pageContext.request.contextPath}/plugin/okm-adsense.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>

		<%-- <script defer type="text/javascript" src='${pageContext.request.contextPath}/menu/okmMenu.js?v=<%=updateTime%>'></script> --%>
		
		<!-- Tinymce for webpage node -->
		<%-- <script defer src="${pageContext.request.contextPath}/lib/tinymce/tinymce.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
	    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/webpage.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>

		<!-- Context menu -->
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/contextmenu/jquery.contextmenu.css" type="text/css" media="screen"> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/contextmenu/jquery.contextmenu.js" type="text/javascript"></script> --%>

		<!-- Color picker -->
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.js?v=<%=updateTime%>" type="text/javascript"></script> --%>
		
		<!-- D3js -->
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_popover.css?v=<%=updateTime%>" type="text/css" media="screen">
		<script defer src="${pageContext.request.contextPath}/lib/d3js/d3.js?v=<%=updateTime%>" type="text/javascript"></script>

		<!-- LazyLoad -->
		<!-- https://github.com/verlok/lazyload -->
		<script defer src="${pageContext.request.contextPath}/lib/lazyload.min.js?v=<%=updateTime%>" type="text/javascript"></script>

		<!-- Jquery form -->
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery.form.js?v=<%=updateTime%>" type="text/javascript"></script> --%>

		<!-- dtpicker -->
		<%-- <script defer src="${pageContext.request.contextPath}/lib/dtpicker/jquery.simple-dtpicker.js?v=<%=updateTime%>" type="text/javascript"></script> --%>
		
		<script defer src="${pageContext.request.contextPath}/lib/apputil.js?v=<%=updateTime%>" type="text/javascript"></script>
		<script defer src="${pageContext.request.contextPath}/lib/browser.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

		<c:if test="${data.canEdit}">
			<!-- canEdit -->
			<script defer src="${pageContext.request.contextPath}/lib/jquery.insertatcaret.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		</c:if>
		<script defer src="${pageContext.request.contextPath}/lib/Base64.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

		<c:if test="${data.canCopyNode && !isembed}">
			<!-- canExport -->

			<!-- https://github.com/canvg/canvg -->
			<script src="https://cdnjs.cloudflare.com/ajax/libs/canvg/1.4/rgbcolor.min.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/stackblur-canvas@^1/dist/stackblur.min.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/canvg/dist/browser/canvg.min.js"></script>

			<script defer src="${pageContext.request.contextPath}/lib/html2canvas.js?v=<%=updateTime%>" type="text/javascript"></script>

			<%-- <script defer src="${pageContext.request.contextPath}/lib/rgbcolor.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
			<script defer src="${pageContext.request.contextPath}/lib/canvg.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		</c:if>
		<!-- presentation -->
		<link rel="stylesheet" href="${pageContext.request.contextPath}/plugin/presentation/presentation.css?v=<%=updateTime%>" type="text/css" media="screen">
		<script src="${pageContext.request.contextPath}/lib/jquery-ui.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/plugin/animate-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/plugin/presentation/jmpress/jmpress.all.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/plugin/presentation/presentation.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/plugin/presentation/editorManager.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		
		<script src="${pageContext.request.contextPath}/theme/dist/assets/js/bootstrap4-toggle.min.js?v=<%=updateTime%>"></script>
		<style>
			#presentation_editor-container {
				overflow-x: hidden;
				overflow-y: auto;
				height: calc(100vh - 378px - 56px - 78px);
				min-height: 400px;
				background-color: #f8f9fa;
			}

			.radio-input-block:checked+label {
				background-color: #dae0e5 !important;
				border-color: #213756 !important;
			}
		</style>

		<c:if test="${data.nodejs_url ne ''}">
			<script src="${pageContext.request.contextPath}/lib/socket.io.js"></script>
			<script>
				if(window.io !== undefined) {
					var mindmapIO = io("${data.nodejs_url}/mindmap", {transports: ['websocket', 'polling']});
				}
			</script>
		</c:if>

		<!-- Google classroom -->
		
		<%@ include file="../okmMenuCommon.js.jsp"%>

		<c:if test="${(data.isOwner || data.canEdit || data.canCopyNode) && !isembed}">
		<%@ include file="../okmMenu.js.jsp"%>
		</c:if>
				
		<!-- jMap init -->
		<script defer type="text/javascript">
			const USER_POLICY = "${data.user_policy}";
			var jMap;
			var pageId;
			var mapId = ${data.mapId > 0 ? data.mapId : 0 };
			console.log(${data.mapId > 0 ? data.mapId : 0 }, "OK OK OK");
			var mapName = "<c:out value="${data.map.name}"/>";
			var menu_isOwner = <c:out value="${data.isOwner ? 'true':'false'}"/>;
			var menu_canEdit =  <c:out value="${data.canEdit ? 'true':'false'}"/>;
			var menu_canCopyNode =  <c:out value="${data.canCopyNode ? 'true':'false'}"/>;
			var shouldSave = true;

			// presentation mode
			var showPresentation = <c:out value="${data.show ? 'true':'false'}"/>;
			var presentationType = "<c:out value="${data.type}"/>";
			var presentationStyle = "<c:out value="${data.style}"/>";
			var presentationEdit = null;
			
			var saveUserRecentMap = function(){
				if(jMap.cfg.mapOwner){
					$.ajax({
						type: 'post',
						async: false,
						url: jMap.cfg.contextPath + '/user/userrecentmaps.do',
						data: {action: 'set', recentMaps: jMap.cfg.mapId},
						success: function (data) {
						}, 
						error: function (data, status, err) {
						}
					});
				}
			}
			
			function jinoMap_init() {	
				
				jMap = new JinoMap("jinomap", 5000, 3000, <c:choose><c:when test="${data.canEdit}">1</c:when><c:otherwise>0</c:otherwise></c:choose>, "${pageContext.request.contextPath}");				
				jMap.cfg.lazyLoading = <c:out value="${data.lazyloading == '0' ? 'false':'true'}"/>;
				jMap.cfg.queueing = <c:out value="${data.queueing == '0' ? 'false':'true'}"/>;
				jMap.cfg.contextPath = "${pageContext.request.contextPath}";
				jMap.cfg.mapId = mapId;
				jMap.cfg.mapName = mapName;
				jMap.cfg.mapKey = "<c:out value="${data.map.key}"/>";
				jMap.cfg.mapOwner = menu_isOwner;
				jMap.cfg.canEdit = menu_canEdit;
				jMap.cfg.baseUrl = '<%=base%>';
				jMap.cfg.isShrdGuest = <c:out value="${user == null || user.username == 'guest' ? 'true':'false'}"/>;
				
				<c:choose>
					<c:when test="${user.guest}">
			    		jMap.cfg.userId = "<c:out value="0"/>";
					</c:when>
					<c:otherwise>
						jMap.cfg.userId = "<c:out value="${user.id}"/>";
					</c:otherwise>
				</c:choose>
				jMap.cfg.userLastAccess = "<c:out value="${user.lastaccess}"/>";
				
				// map load dialog show
				JinoUtil.waitingDialog("<spring:message code='message.loading' />");
				
				jMap.cfg.shortUrl = "${data.map.short_url}";
				jMap.cfg.QRCode = "${data.map.short_url}"+".qrcode";
				
				<c:if test="${isembed}">
					jMap.setWaterMark();
				</c:if>
				
				jMap.setUserConfig(<c:out value="${user.id}"/>);

				jMap.loadMap("${pageContext.request.contextPath}", <c:out value="${data.map.id}"/>, mapName);
				jMap.loaded = function() {
					$(jMap.work).focus();

					//KHANG: restore background
					var root = jMap.getRootNode();

					if (root.attributes == undefined)
						root.attributes = {};
					
					jMap.cfg.mapBackgroundImage = root.attributes['mapBackgroundImage'] || '';
					jMap.cfg.mapBackgroundColor = root.attributes['mapBackgroundColor'] || "#ffffff";
					
					var restrictEditing = false;
					if(root.attributes.restrictEditing == 1) {
						restrictEditing = true;
					}
					jMap.cfg.restrictEditing = restrictEditing;
					$( "#restrict_editing" ).prop('checked', restrictEditing);
					
					$(jMap.work).css("background-color", jMap.cfg.mapBackgroundColor);
					$(jMap.work).css("background-image", 'url("' + jMap.cfg.mapBackgroundImage + '")');

					//paste image
					function retrieveImageFromClipboardAsBlob(pasteEvent, callback) {
						if(pasteEvent.clipboardData == false){
					        if(typeof(callback) == "function"){
					            callback(undefined);
					        }
					    };

					    var items = pasteEvent.clipboardData.items;

					    if(items == undefined){
					        if(typeof(callback) == "function"){
					            callback(undefined);
					        }
					    };
					    for (var i = 0; i < items.length; i++) {
					        // Skip content if not image
					        if (items[i].type.indexOf("image") == -1) continue;
					        
					        // Retrieve image on clipboard as blob
					        var blob = items[i].getAsFile();

					        if(typeof(callback) == "function"){
								callback(blob);
					        }
					        break;
					    }
					}

					window.addEventListener("paste", function(e) {
					    // Handle the event
					    retrieveImageFromClipboardAsBlob(e, function(imageBlob) {
					        // If there's an image, display it in the canvas
					        if (!imageBlob)
					        	return;
			            	var selected = jMap.getSelected();
			                if (!selected || !jMap.isAllowNodeEdit(selected))
			                	return;
							
			                var NodeWidth;
					    	if (selected.img != undefined){
								NodeWidth = selected.img.attr().width;
							} else {
								NodeWidth = jMap.cfg.default_img_size;
							}

							// if(imageBlob.size <= 5242880) {	// 5MB
							// 	var canvas = document.createElement('canvas');
							// 	canvas.id = "temp_canvas";
							// 	document.body.appendChild(canvas);
								
							// 	var ctx = canvas.getContext('2d');
								
							// 	// Create an image to render the blob on the canvas
							// 	var img = new Image();

							// 	// Once the image loads, render the img on the canvas
							// 	img.onload = function() {
							// 		// Update dimensions of the canvas with the dimensions of the image
							// 		canvas.width = NodeWidth; //this.width;
							// 		canvas.height = NodeWidth*this.height/this.width;

							// 		// Draw the image
							// 		ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
							// 		selected.setImage(canvas.toDataURL('image/png'), canvas.width, canvas.height);
							// 		document.body.removeChild(canvas);
							// 	};

							// 	// Crossbrowser support for URL
							// 	var URLObj = window.URL || window.webkitURL;

							// 	// Creates a DOMString containing a URL representing the object given in the parameter
							// 	// namely the original Blob
							// 	img.src = URLObj.createObjectURL(imageBlob);
							// } else if(imageBlob.size <= 10485760) { // 10MB
								var formData = new FormData();
								formData.append('confirm', 1);
								formData.append('mapid', jMap.cfg.mapId);
								formData.append('nodeId', selected.id);
								formData.append('file', imageBlob);

								var xhr = new XMLHttpRequest();
								xhr.open('POST', "${pageContext.request.contextPath}/media/fileupload.do");
								xhr.onreadystatechange = function () {
									if (xhr.readyState === 4 && xhr.status === 200) {
										var res = JSON.parse(xhr.response);
										var url = '${pageContext.request.contextPath}/map' + res[0].url;
										$('<img />').attr('src', url)
										.on('load', function () {
											selected.setImage(url, NodeWidth, NodeWidth*this.height/this.width);
										});
									}
								}
								xhr.send(formData);
							// }
						});
					}, false);
					
					
					//KHANG: prevent Browser context menu on map
					$(jMap.work).on('contextmenu', function() {return false;});

					if(LazyLoad) {
						window.lazyLoadInstance = new LazyLoad({
							elements_selector: ".lazy-load"
						});
					}

					SET_SOCKET(true);

					// search node
					initFindNodeAction('#jino_form_search');
					initFindNodeAction('#jino_form_search_m'); // for modile

					if ($.cookie('rightPanelFolding') == 1) {
						rightPanelFolding();
					}
					OKMChat('okm-chat', '<c:out value="${user.lastname}"/> <c:out value="${user.firstname}"/>');

					switch (jMap.layoutManager.type) {
						case 'jCardLayout':
							setMenuActions(false, new Array(
								"foldingall", "CtrlRAction"
							));
							break;
						case 'jSunburstLayout':
							setMenuActions(false, new Array(
								"foldingall", "CtrlRAction"
							));
							break;
						case 'jPadletLayout':
							setMenuActions(false, new Array(
								"foldingall", "CtrlRAction"
							));
							break;
					}

					JinoUtil.waitingDialogClose();

					if(showPresentation) {
						if (presentationType == 'Mindmap-Basic') {
							navbarMenusToggle(false);
							
							EditorManager.show();
							EditorManager.hide();
							ScaleAnimate.showStyle = ScaleAnimate.scaleToScreenFitWithZoomInOut;
							ScaleAnimate.startShowMode(30, 20, true);
						} else if (presentationType == 'Mindmap-Zoom') {
							navbarMenusToggle(false);

							EditorManager.show();
							EditorManager.hide();
							ScaleAnimate.showStyle = ScaleAnimate.scaleToScreenFit;
							ScaleAnimate.startShowMode(30, 20, true);
						} else {
							presentationStartMode();
						}
					}else{
						if(!jMap.cfg.isShrdGuest) {
							reloadViewAction($.cookie('selectedNodeID'));
						}
					}

					setMenuOpacity(jMap.cfg.default_menu_opacity == 'true');

					setTimeout(function(){
						okmNoticeAction(false);
						//CSEDUNG 
						saveUserRecentMap();
						
						if(jMap.cfg.userId == 0){
							okmLogin();
						}
						moodleDisconnectDetection();
					}, 200);

					if (jMap.rootNode.attributes["remixesOfMap"] != undefined) {
						setMenuActions(false, new Array("remixMap", "mapOfRemixes"));
					}

					
					getNodeLisScore(jMap.getRootNode().getChildren());
					
					setTimeout(function(){
						JinoUtil.closeEmbedDialog();
					}, 1000);
				}
			}
			$(document).ready( jinoMap_init );
		</script>

		<c:if test="${data.ga_trackingId ne ''}">
			<!-- Google Analytics -->
			<script>
				window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
				ga('create', {
					trackingId: '${data.ga_trackingId}',
					cookieDomain: 'none'
				});
				ga('send', 'pageview');
			</script>
			<script async src='https://www.google-analytics.com/analytics.js'></script>
			<!-- End Google Analytics -->
		</c:if>
    </head>

    <body class="jino-app">
		<c:if test="${!isembed}">
			<!-- 헤더 -->
			<%@ include file="../ribbonmenu/okmMenuRibbonWedorangHeader.jsp"%>
		</c:if>

		<!-- 메뉴 시작 -->
		<%@ include file="../menu/okmMenu.jsp"%>
		
		<!-- OKMindmap View 시작 -->
		<div id="main" class="vw-100 vh-100">
			<!-- 스크롤바 보이기 : overflow:auto 숨기기 : overflow:hidden -->
			<div id="jinomap" tabindex="-1" style="outline: none; border: none; width: 100%; height: 100%; position: relative; overflow: hidden;"></div>

			<div id="presentation_editor" class="panel closed panel-l presentationEdit-panel position-fixed left-0 z-20 border border-top-0 bg-white" style="width: 350px;">
				<div class="d-flex align-items-center py-2 px-3 bg-light font-weight-bold border-bottom">
					<div class="mr-auto">
						<spring:message code='menu.presentation' />
					</div>
					<button type="button" class="btn btn-light btn-sm" onclick="presentationEditMode()">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-left.svg" width="18px">
					</button>
				</div>
				<div class="container-fluid py-1" style="overflow-x: hidden; overflow-y: auto; height: calc(100vh - 105px - 56px - 78px);">
					<div class="form-group">
						<label>
							<spring:message code='presentation.slide' />
						</label>
						<div class="p-2 border rounded-sm" id="presentation_editor-container"></div>
					</div>
					<div>
						<label>
							<spring:message code='presentation.type' />
						</label>
						<div class="type-wrap pb-1 mb-2 position-relative" style="overflow: auto;white-space: nowrap;">
							<div class="d-inline-block mx-1 cursor-pointer tierpolicy-presentationdynamic">
								<input class="d-none radio-input-block" type="radio" name="pt-type" id="pt-type-Dynamic" value="Dynamic">
								<label for="pt-type-Dynamic" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/images/types/prezilike.png" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.dynamic' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer tierpolicy-presentationbox">
								<input class="d-none radio-input-block" type="radio" name="pt-type" id="pt-type-Box" value="Box" checked>
								<label for="pt-type-Box" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/images/types/box.png" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.box' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer tierpolicy-presentationaero">
								<input class="d-none radio-input-block" type="radio" name="pt-type" id="pt-type-Aero" value="Aero">
								<label for="pt-type-Aero" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/images/types/aero.png" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.aero' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer tierpolicy-presentationlinear">
								<input class="d-none radio-input-block" type="radio" name="pt-type" id="pt-type-Linear" value="Linear">
								<label for="pt-type-Linear" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/images/types/linear.png" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.linear' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer tierpolicy-presentationmindmapbasic">
								<input class="d-none radio-input-block" type="radio" name="pt-type" id="pt-type-MindmapBasic" value="Mindmap - Basic">
								<label for="pt-type-MindmapBasic" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/images/types/mindmap_basic.png" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.basic' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer tierpolicy-presentationmindmapzoom">
								<input class="d-none radio-input-block" type="radio" name="pt-type" id="pt-type-MindmapZoom" value="Mindmap - Zoom">
								<label for="pt-type-MindmapZoom" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/images/types/mindmap_zoom.png" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.zoom' />
									</small>
								</label>
							</div>
						</div>
					</div>
					<div>
						<label>
							<spring:message code='presentation.background' />
						</label>
						<div class="style-wrap pb-1 mb-2 position-relative" style="overflow: auto;white-space: nowrap;">
							<div class="d-inline-block mx-1 cursor-pointer">
								<input class="d-none radio-input-block" type="radio" name="pt-style" id="pt-style-BlackLabel" value="BlackLabel" checked>
								<label for="pt-style-BlackLabel" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/theme/BlackLabel/preview.jpg" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.theme1' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer">
								<input class="d-none radio-input-block" type="radio" name="pt-style" id="pt-style-Basic" value="Basic">
								<label for="pt-style-Basic" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/theme/Basic/preview.jpg" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.theme2' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer">
								<input class="d-none radio-input-block" type="radio" name="pt-style" id="pt-style-Sunshine" value="Sunshine">
								<label for="pt-style-Sunshine" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/theme/Sunshine/preview.jpg" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.theme3' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer">
								<input class="d-none radio-input-block" type="radio" name="pt-style" id="pt-style-Sky" value="Sky">
								<label for="pt-style-Sky" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/theme/Sky/preview.jpg" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.theme4' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer">
								<input class="d-none radio-input-block" type="radio" name="pt-style" id="pt-style-BlueLabel" value="BlueLabel">
								<label for="pt-style-BlueLabel" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="min-width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/presentation/theme/BlueLabel/preview.jpg" width="20px" class="d-block mx-auto">
									<small>
										<spring:message code='presentation.theme5' />
									</small>
								</label>
							</div>
						</div>
					</div>
				</div>
				<div class="d-flex justify-content-center px-4">
					<button type="button" onclick="EditorManager.setDefaultSlide();" class="btn btn-info btn-block mt-3 mr-2 px-0">
						<spring:message code='presentation.reset' />
					</button>
					<button type="button" id="pt-start" class="btn btn-primary btn-block mt-3 px-0">
						<spring:message code='menu.advanced.pt.show.view' />
					</button>
					<button type="button" onclick="exportToPPT()" class="tierpolicy-exportToPPT btn btn-info btn-block mt-3 ml-2 px-0">
						<spring:message code='presentation.pptx' />
					</button>
				</div>
			
			</div>
			
		</div>
		<!-- OKMindmap View 끝 -->

		<!-- 우패널 시작 -->
		<div id="rightPanelFolding" class="panel closed panel-r chat-panel position-fixed right-0 z-20 border border-top-0 bg-white">
			<div class="chat-header d-flex align-items-center py-2 px-3 bg-blue text-white font-weight-bold">
				<div class="mr-auto">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/chat-bubble.svg" width="18px" class="mr-1 align-text-top">
					<spring:message code='chatting.expanding'/>
				</div>
				<button type="button" class="btn btn-blue btn-sm" onclick="rightPanelFolding()">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-right-w.svg" width="18px">
				</button>
			</div>
			<div class="chat-body p-2" id="chatlog"></div>
			<div class="position-relative">
				<div class="typing position-absolute px-2 pt-0 pb-2 bg-gray-200 pointer-events-none d-none">
					<div class="bubble-loading">
						<span></span>
						<span></span>
						<span></span>
					</div>
				</div>
			</div>
			<div class="chat-footer d-flex align-items-center p-2">
				<form class="w-100" id="jino_chat_frm_send">
					<div class="input-group">
						<input id="jino_chat_input" type="text" class="input-send form-control bg-gray-200 shadow-none border-0" placeholder="<spring:message code='common.enter_message'/>">
						<div class="input-group-append">
							<button class="btn btn-send shadow-none bg-gray-200 border-0 px-2" type="submit">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/send.svg" width="20px">
							</button>
						</div>
					</div>
				</form>
			</div>
		</div>

		<!-- Google search -->
		<iframe id="googleSearch" data-src="${pageContext.request.contextPath}/media/text.do?type=google" class="panel closed panel-r googleSearch-panel position-fixed right-0 z-20 border border-top-0 bg-white"></iframe>

		<!-- waitingDialog -->
		<div class="modal" id="waitingDialog" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
			<div class="modal-dialog modal-dialog-centered modal-sm" role="document">
				<div class="modal-content">
					<div class="modal-body text-center">
					</div>
				</div>
			</div>
		</div>

		<!-- iframeDialog -->
		<div class="modal modal-iframe" id="iframeDialog" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header border-0 py-2">
						<div class="modal-title h5"></div>
						<button type="button" id="closeIframeDialog" class="close" data-dismiss="modal" aria-label="Close" style="padding: 11px 16px; margin: -8px -16px -16px auto; outline: none;">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" style="overflow:auto;-webkit-overflow-scrolling:touch">
						<iframe class="d-block mx-auto rounded-bottom" width="100%" onload="onLoadIFrame(this)" frameborder="0"></iframe>
					</div>
				</div>
			</div>
		</div>

		<!-- asynchronousDialog -->
		<div class="modal" id="asynchronousDialog" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
			<div class="modal-dialog modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-body text-center py-3">
						<img class="d-block mx-auto mb-3" src="${pageContext.request.contextPath}/theme/dist/images/icons/exclamation-mark.svg" width="80px">

						<div class="text-center">
							<div class="h4"><spring:message code="alert.asynchronous_title"></spring:message></div>
							<c:set var="countdownTag" value="<span class='text-danger font-weight-bold' id='asynchronousCountdown'></span>" />
							<spring:message code="alert.asynchronous_desc" arguments="${countdownTag}" htmlEscape="false" argumentSeparator=";"/>
						</div>
						<div class="text-center mt-4">
							<button type="button" class="btn btn-danger btn-min-w" onclick="window.location.reload();"><spring:message code="button.reload_now"></spring:message></button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div id="toastWrap" class="pointer-events-none position-absolute top-0 right-0" style="z-index: 1170;"></div>

		<!-- presentation -->
		<iframe id="presentation" data-src="${pageContext.request.contextPath}/jsp/fn/presentation.jsp" class="position-absolute top-0 right-0 vw-100 vh-100 d-none bg-white" style="z-index: 1200;" frameborder="0"></iframe>


		<form id="svg_export" action="${pageContext.request.contextPath}/svg" method="post">
			<input type="hidden" name="id">
			<input type="hidden" name="svg">
			<input type="hidden" name="type">
		</form>
		<form id="text_export" action="${pageContext.request.contextPath}/text" method="post">
			<input type="hidden" name="id">
			<input type="hidden" name="ext">
			<input type="hidden" name="text">
		</form>
		<canvas id="svgcanvas" width="0px" height="0px"></canvas> 
		
	</body>
</html>