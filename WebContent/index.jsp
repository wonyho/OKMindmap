<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="env" uri="http://www.servletsuite.com/servlets/enventry"%>

<%
	Boolean isembed = "off".equals(request.getParameter("m"));
	request.setAttribute("isembed", isembed);
	
	String useragent = (String) request.getAttribute("agent");
	request.setAttribute("useragent", useragent);

	request.setAttribute("user", session.getAttribute("user"));

	Locale locale = RequestContextUtils.getLocale(request);
	request.setAttribute("locale", locale);

	String facebook_appid = Configuration.getString("facebook.appid");

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<!DOCTYPE html>
<html lang="${locale.language}">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta http-equiv="Cache-Control" content="no-cache">
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="Expires" content="0">
		<meta name="Description" content="<c:out value=" ${data.mapContentsText} "/>">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		
		<c:if test = "${useragent != null}">
			<!-- 아이폰 META -->
			<meta name="apple-mobile-web-app-capable" content="yes">
			<link rel="apple-touch-icon" href="${pageContext.request.contextPath}/images/mobile/appicon.png">
			<link rel="apple-touch-startup-image" href="${pageContext.request.contextPath}/images/mobile/startup.jpg">
		</c:if>

		<title>OKMindmap :: Design Your Mind!</title>

		<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico?v=<%=updateTime%>" />
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui/jquery-ui.custom.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/okmindmap.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=<%=updateTime%>" type="text/css"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/impromptu.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/simplemodal.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dialog.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/opentab.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/okm-side.css?v=<%=updateTime%>" type="text/css" media="screen">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/splitter.css?v=<%=updateTime%>" type="text/css" media="screen">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/lib/farbtastic/farbtastic.css?v=<%=updateTime%>" type="text/css" media="screen">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/plugin/presentation/presentation.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>

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
		<%-- <script defer src="${pageContext.request.contextPath}/lib/browser.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/json2.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery-impromptu.3.1.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/hahms-textgrow.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/luasog-0.3.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery.simplemodal.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery.insertatcaret.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/Base64.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/conversionfunctions.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/http.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jscolor/jscolor.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/timeline.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/slimScroll.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/popup_expiredays.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/splitter.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/farbtastic/farbtastic.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/lib/jquery.cookie.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/rgbcolor.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/StackBlur.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/canvg.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>

		<script defer src="${pageContext.request.contextPath}/mayonnaise-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

		<script defer src="${pageContext.request.contextPath}/extends/ExArray.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<script defer src="${pageContext.request.contextPath}/extends/ExRaphael.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_delicious.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_socket.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_google_searcher.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/plugin/jino_node_color_mix.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_facebook.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_twitter.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_wiki.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<script defer src="${pageContext.request.contextPath}/plugin/NodeColorUtil.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/TestRobot.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/animate-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/slideshare-service.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/map_of_delicious.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/collabDocument.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/testcode.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/jmpress/jmpress.all.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/presentation.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/presentation/editorManager.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/plugin/jino_nodeTheme.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script> --%>
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
		<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_popover.css?v=<%=updateTime%>" type="text/css" media="screen"> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/d3js/d3.js?v=<%=updateTime%>" type="text/javascript"></script> --%>
		<%-- <script defer src="${pageContext.request.contextPath}/lib/html2canvas.js?v=<%=updateTime%>" type="text/javascript"></script> --%>

		<!-- LazyLoad -->
		<!-- https://github.com/verlok/lazyload -->
		<%-- <script defer src="${pageContext.request.contextPath}/lib/lazyload.min.js?v=<%=updateTime%>" type="text/javascript"></script> --%>

		<!-- Jquery form -->
		<%-- <script defer src="${pageContext.request.contextPath}/lib/jquery.form.js?v=<%=updateTime%>" type="text/javascript"></script> --%>

		<!-- dtpicker -->
		<%-- <script defer src="${pageContext.request.contextPath}/lib/dtpicker/jquery.simple-dtpicker.js?v=<%=updateTime%>" type="text/javascript"></script> --%>

		<script defer src="${pageContext.request.contextPath}/lib/apputil.js?v=<%=updateTime%>" type="text/javascript"></script>

		<!-- Google classroom -->

		<%@ include file="../okmMenuCommon.js.jsp"%>

		<!-- jMap init -->
		<script defer type="text/javascript">
			const USER_POLICY = '';
			var jMap;
			var mapId = <spring:message code='index.loadmap.id'/>;
			var menu_isOwner = false;
			var menu_canEdit =  false;
			var menu_canCopyNode =  false;
			var shouldSave = false;
			
			/* var saveUserRecentMap = function(){
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
			} */
			
			function jinoMap_init() {	
				
				jMap = new JinoMap("jinomap", 5000, 3000, 0, "${pageContext.request.contextPath}");
				jMap.cfg.contextPath = "${pageContext.request.contextPath}";
				jMap.cfg.mapId = mapId;
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
				jMap.cfg.userLastAccess = "<c:out value="${user.lastaccess}"/>";
				// map load dialog show
				JinoUtil.waitingDialog("<spring:message code='message.loading' />");
				
				jMap.cfg.shortUrl = "${data.map.short_url}";
				jMap.cfg.QRCode = "${data.map.short_url}"+".qrcode";

				<c:if test="${isembed}">
					jMap.setWaterMark();
				</c:if>
				
				jMap.loadMap("${pageContext.request.contextPath}", "<spring:message code='index.loadmap.id'/>", "index.mm");
				jMap.loaded = function() {
					$(jMap.work).focus();

					//KHANG: restore background
					var root = jMap.getRootNode();
					
					if (root.attributes == undefined)
						root.attributes = {};
					
					jMap.cfg.mapBackgroundImage = root.attributes['mapBackgroundImage'] || '';
					jMap.cfg.mapBackgroundColor = root.attributes['mapBackgroundColor'] || "#ffffff";
					
					$(jMap.work).css("background-color", jMap.cfg.mapBackgroundColor);
					$(jMap.work).css("background-image", 'url("' + jMap.cfg.mapBackgroundImage + '")');
					
					
					//KHANG: prevent Browser context menu on map
					$(jMap.work).on('contextmenu', function() {return false;});

					// search node
					initFindNodeAction('#jino_form_search');
					initFindNodeAction('#jino_form_search_m'); // for modile

					JinoUtil.waitingDialogClose();
					
					
					
					if(!jMap.cfg.isShrdGuest) {
						reloadViewAction($.cookie('selectedNodeID'));
					}
					
					setTimeout(function(){
						// okmNoticeAction(false);
						if(jMap.cfg.isShrdGuest) {
							pleaseLoginModal();
						} else {
							openMap();
							
						}
					}, 200);
				}
			}
			$(document).ready( jinoMap_init );
		</script>
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
		</div>
		<!-- OKMindmap View 끝 -->

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
					<div class="modal-body" style="overflow:auto;-webkit-overflow-scrolling:touch">
						<iframe class="d-block mx-auto rounded-bottom" width="100%" onload="onLoadIFrame(this)" frameborder="0"></iframe>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>


