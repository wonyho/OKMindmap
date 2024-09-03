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
		<%-- <script defer src="${pageContext.request.contextPath}/lib/popup_expiredays.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/splitter.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/farbtastic/farbtastic.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/jquery.cookie.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		
		<%-- <script defer src="${pageContext.request.contextPath}/lib/StackBlur.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		

		<script defer src="${pageContext.request.contextPath}/mayonnaise-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

		<script defer src="${pageContext.request.contextPath}/extends/ExArray.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/extends/ExRaphael.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script src="${pageContext.request.contextPath}/extends/javascript-chat.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>		 --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_delicious.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_socket.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_google_searcher.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_facebook.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/plugin/jino_node_color_mix.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_twitter.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_wiki.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/plugin/NodeColorUtil.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/TestRobot.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/animate-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/slideshare-service.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/map_of_delicious.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/collabDocument.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>		 --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/testcode.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/jmpress/jmpress.all.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/presentation.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/editorManager.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_nodeTheme.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>		 --%>
		<%-- <script src="${pageContext.request.contextPath}/plugin/okm-chat.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
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
			<script defer src="${pageContext.request.contextPath}/lib/Base64.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		</c:if>

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

		<c:if test="${data.nodejs_url ne ''}">
			<script src="${pageContext.request.contextPath}/lib/socket.io.js"></script>
			<script>
				/* if(window.io !== undefined) {
					var mindmapIO = io("${data.nodejs_url}/mindmap", {transports: ['websocket', 'polling']});
				} */
				var mindmapIO = undefined;
			</script>
		</c:if>
		
		<!-- Google classroom -->
		
		<%@ include file="../okmMenuCommon.js.jsp"%>

		<%-- <c:if test="${(data.isOwner || data.canEdit || data.canCopyNode) && !isembed}"> --%>
		<%-- <%@ include file="../okmMenu.js.jsp"%> --%>
		<%-- </c:if> --%>

		<script defer type="text/javascript">
			// 선택된 타임라인을 불러온다.
			function loadTimeline(e) {
				currentTimeline.item && currentTimeline.item.removeClass('active');
				
				var timelineID = parseInt($(e).data('timelineid'));
				currentTimeline.id = timelineID;
				currentTimeline.item = $(e);
				currentTimeline.item.addClass('active');
				
				$.ajax({
					type: 'post',
					async: false,
					url: '${pageContext.request.contextPath}/timeline/xml.do',
					data: {'id': timelineID },
					success: function(data, textStatus, jqXHR) {
						JinoUtil.waitingDialog("<spring:message code='message.loading' />");
						jMap.loadMapFromXml(jqXHR.responseText);
					},
					error: function(data, status, err) {
						alert("loadTimeline : " + status);
					}
			    });
				
			}

			// 타임라인 리스트를 만든다.
			function updateTimelineList() {
				$( '.timeline-item' ).each(function() {
					var item = $(this);
					var saved = item.data('saved');
					if(saved) {
						var d = new Date(saved);				
						var format = d.getFullYear() + "/" + (d.getMonth()+1) + "/" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
						item.attr('title', format);
						item.html(format);
					}
				});
			}

			var TimelineRevert = function () {
				if(!jMap.cfg.mapOwner) {
					alert("<spring:message code='common.nogrant'/>");
					return false;
				}
				if(currentTimeline.id == -1) {
					alert("<spring:message code='timeline.menu.currentnotsave'/>");
					return;
				}
				location.href = '${pageContext.request.contextPath}/timeline/revert.do?id=' + currentTimeline.id;
			};

			var TimelineSaveAs = function () {
				if(!jMap.cfg.mapOwner) {
					alert("<spring:message code='common.nogrant'/>");
					return false;
				}
				if(currentTimeline.id == -1) {
					alert("<spring:message code='timeline.menu.currentnotsave'/>");
					return;
				}

				JinoUtil.showDialog({
					url: jMap.cfg.contextPath + "/jsp/fn/TimelineSaveAs.jsp",
					title: "<spring:message code='timeline.menu.saveasnewmap'/>"
				});
			};
		</script>
				
		<!-- jMap init -->
		<script defer type="text/javascript">
			var jMap;
			var pageId;
			var mapId = <c:out value="${data.mapId}"/>;
			var mapName = "<c:out value="${data.map.name}"/>";
			var menu_isOwner = <c:out value="${data.isOwner ? 'true':'false'}"/>;
			var menu_canEdit =  <c:out value="${data.canEdit ? 'true':'false'}"/>;
			var menu_canCopyNode =  <c:out value="${data.canCopyNode ? 'true':'false'}"/>;
			var currentTimeline = {id: -1, item:null};
			
			function jinoMap_init() {				
				jMap = new JinoMap("jinomap", 5000, 3000, 0);
				jMap.cfg.contextPath = "${pageContext.request.contextPath}";
				jMap.cfg.mapId = mapId;
				jMap.cfg.mapName = mapName;
				jMap.cfg.mapKey = "<c:out value="${data.map.key}"/>";
				jMap.cfg.mapOwner = menu_isOwner;
				jMap.cfg.canEdit = menu_canEdit;
				jMap.cfg.isShrdGuest = <c:out value="${user == null || user.username == 'guest' ? 'true':'false'}"/>;
				
				<c:choose>
					<c:when test="${user.guest}">
			    		jMap.cfg.userId = "<c:out value="0"/>";
					</c:when>
					<c:otherwise>
						jMap.cfg.userId = "<c:out value="${user.id}"/>";
					</c:otherwise>
				</c:choose>
				
				// map load dialog show
				JinoUtil.waitingDialog("<spring:message code='message.loading' />");
				
				jMap.cfg.shortUrl = "${data.map.short_url}";
				jMap.cfg.QRCode = "${data.map.short_url}"+".qrcode";
				
				jMap.loadMap("${pageContext.request.contextPath}", <c:out value="${data.map.id}"/>, mapName);
				jMap.loaded = function() {
					JinoUtil.waitingDialogClose();
					if(LazyLoad) {
						window.lazyLoadInstance = new LazyLoad({
							elements_selector: ".lazy-load"
						});
					}
				}
				
				updateTimelineList();
				var current = $('#currentTimeline');
				current.on('click', function(){
					JinoUtil.waitingDialog("<spring:message code='message.loading' />");
					jMap.loadMap("${pageContext.request.contextPath}", <c:out value="${data.map.id}"/>, "<c:out value='${data.map.name}'/>");
					
					currentTimeline.item && currentTimeline.item.removeClass('active');					
					currentTimeline.id = -1;
					currentTimeline.item = $(this);
					currentTimeline.item.addClass('active');
				});
				currentTimeline.item = current;
				currentTimeline.item.addClass('active');

			}
			$(document).ready( jinoMap_init );
		</script>

		<style>
			.timeline-panel {
				width: 220px;
			}
			#timelineList {
				height: calc(100vh - 88px);
				overflow: auto;
				font-size: 0.8rem;
			}

			#timelineList::after {
				content: "";
				position: fixed;
				top: 0;
				left: 20px;
				width: 3px;
				height: 100%;
				background: #adb5bd;
			}
			#timelineList .timeline {
				padding-left: 30px;
			}
			#timelineList .timeline::before {
				content: "";
				position: absolute;
				top: 33px;
				left: 7px;
				width: 13px;
				height: 13px;
				border-radius: 15px;
				background: #adb5bd;
				z-index: 1;
			}
			#timelineList .timeline .timeline-item{
				border-left: 4px solid #ddd;
			}
			#timelineList .timeline-item.active {
				color: #48b87e;
			}
			#timelineList .timeline-item.active{
				border-left: 4px solid #48b87e;
			}
		</style>

    </head>

    <body class="jino-app">
		<!-- OKMindmap View 시작 -->
		<div id="main" class="vw-100 vh-100">
			<!-- 스크롤바 보이기 : overflow:auto 숨기기 : overflow:hidden -->
			<div id="jinomap" tabindex="-1" style="outline: none; border: none; width: 100%; height: 100%; position: relative; overflow: hidden;"></div>
		</div>
		<!-- OKMindmap View 끝 -->

		<!-- timeline panel -->

		<div class="timeline-panel position-fixed top-0 vh-100 left-0 z-10 shadow-sm bg-light">
			<div class="p-2 bg-primary text-white position-relative z-10">
				<div class="d-flex align-items-center">
					<a href="${pageContext.request.contextPath}/map/<c:out value='${data.map.key}'></c:out>" class="btn btn-primary btn-sm">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-left-w.svg" width="18px" class="align-text-top">
					</a>
					<div class="font-weight-bold ml-2" style="font-size: 1.4rem;">
						<spring:message code='timeline.title' />
					</div>
				</div>
				<div class="mt-2">
					<button type="button" class="btn btn-primary btn-sm" onclick="TimelineRevert()">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/save-w.svg" width="18px" class="align-text-bottom mr-1">
						<spring:message code='timeline.menu.save' />
					</button>
					<button type="button" class="btn btn-primary btn-sm" onclick="TimelineSaveAs()">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/save-w.svg" width="18px" class="align-text-bottom mr-1">
						<spring:message code='timeline.menu.saveas' />
					</button>
				</div>
			</div>
			<div id="timelineList" class="p-2 border-right position-relative">
				<c:forEach var="timeline" items="${data.timelines}">
					<div class="timeline position-relative py-3" >
						<span class="timeline-item rounded-right p-3 d-inline-block bg-white shadow-sm cursor-pointer" onclick="loadTimeline(this)" data-saved="<c:out value='${timeline.saved}'/>" data-timelineid="<c:out value='${timeline.id}' />"></span>
					</div>
				</c:forEach>
				<div class="timeline position-relative py-3" >
					<span id="currentTimeline" title="Current" class="active timeline-item rounded-right p-3 d-inline-block bg-white shadow-sm cursor-pointer">Current</span>
				</div>
			</div>
		</div>

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
		<div class="modal modal-iframe" id="iframeDialog" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header border-0 py-2">
						<div class="modal-title h5"></div>
						<button type="button" id="closeIframeDialog" class="close" data-dismiss="modal" aria-label="Close" style="padding: 11px 16px; margin: -8px -16px -16px auto; outline: none;">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<iframe class="d-block mx-auto rounded-bottom" width="100%" onload="onLoadIFrame(this)" frameborder="0"></iframe>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>