<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<c:choose>
    <c:when test="${cookie['locale'].getValue() == 'en'}">
        <c:set var="locale" value="en" />
    </c:when>
    <c:when test="${cookie['locale'].getValue() == 'es'}">
		<c:set var="locale" value="es"/>
	</c:when>
    <c:when test="${cookie['locale'].getValue() == 'vi'}">
        <c:set var="locale" value="vi" />
    </c:when>
    <c:otherwise>
        <c:set var="locale" value="ko" />
    </c:otherwise>
</c:choose>

<fmt:setLocale value="${locale}" />

<!DOCTYPE html>
<html lang="${locale}">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
    <!-- Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

    <script src="${pageContext.request.contextPath}/lib/jquery.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/lib/jquery-ui.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/lib/jquery.mobile.custom.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/lib/raphael.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/lib/browser.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/lib/slimScroll.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/mayonnaise-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

    <script defer src="${pageContext.request.contextPath}/extends/ExArray.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/extends/ExRaphael.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/plugin/presentation/presentation.css?v=<%=updateTime%>" type="text/css" media="screen">
    <script defer src="${pageContext.request.contextPath}/plugin/presentation/jmpress/jmpress.all.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/plugin/presentation/presentation.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/plugin/presentation/editorManager.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui/jquery-ui.custom.css?v=<%=updateTime%>" type="text/css" media="screen">
    
    <title>
        <spring:message code='menu.presentation' />
    </title>

    <style>
        .jmpress-jumpto-panel {
            position: fixed;
            top: 0;
            left: -400px;
            width: 350px;
            background: #ffff;
            height: 100vh;
            z-index: 10000;
            box-shadow: 8px 0px 10px #00000012;
            transition: left .2s ease,right .2s ease,opacity .2s ease;
        }

        .jmpress-jumpto-panel.jmpress-jumpto-transparent-panel {
            opacity: 0.75 !important;
        }

        .jmpress-jumpto-panel.show {
            left: 0px !important;
        }
        .jmpress-jumpto-panel .jt-header{
            display: flex;
            padding: 8px 15px;
            align-items: center;
            border-bottom: 1px solid #ddd;
        }
        .jmpress-jumpto-panel .jt-header .gh-btn{
            margin-left: auto;
        }
        .jmpress-jumpto-panel .jt-content {
            height: calc(100vh - 50px);
            overflow-y: auto;
            padding: 8px 15px;
            background: #ddd;
        }
        .jmpress-jumpto-panel .jt-content .jt-item {
            cursor: pointer;
            background: #fff;
            border-radius: 8px;
            margin: 2px 0px;
            display: flex;
        }
        .jmpress-jumpto-panel .jt-content .jt-item:hover {
            background-color: #fafafa;
        }

        .jmpress-jumpto-panel .jt-content .jt-item .jt-tit{
            padding: 10px 15px;
            flex: 1 1 auto!important;
        }
        .jmpress-jumpto-panel .jt-content .jt-item .jt-icon {
            padding: 8px;
            border-left: 1px solid #ddd;
        }
    </style>

    <script type="text/javascript">
        var jMap = parent.jMap;

        function getSize() {
            var myWidth = 0;
            var myHeight = 0;

            var d = document;
            if (typeof (window.innerWidth) == 'number') {
                //Non-IE
                myWidth = window.innerWidth;
                myHeight = window.innerHeight;
            } else if (d.documentElement &&
                (d.documentElement.clientWidth || d.documentElement.clientHeight)) {
                //IE 6+ in 'standards compliant mode'
                myWidth = d.documentElement.clientWidth;
                myHeight = d.documentElement.clientHeight;
            } else if (d.body && (d.body.clientWidth || d.body.clientHeight)) {
                //IE 4 compatible
                myWidth = d.body.clientWidth;
                myHeight = d.body.clientHeight;
            }

            return { "width": myWidth, "height": myHeight }
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            if (parent.showPresentation) {
                var types = {
                    dynamic: 'Dynamic',
                    box: 'Box',
                    aero: 'Aero',
                    linear: 'Linear'
                };

                var themes = {
                    blacklabel: 'BlackLabel',
                    basic: 'Basic',
                    sunshine: 'Sunshine',
                    sky: 'Sky',
                    bluelabel: 'BlueLabel'
                };

                var typeName = parent.presentationType.toLowerCase();
                var theme = parent.presentationStyle.toLowerCase();

                if (types[typeName] && themes[theme]) {
                    Presentation.setEffect(types[typeName]);
                    Presentation.setStyle(themes[theme]);
                    Presentation.start(true); //auto start for Dynamic type.
                } else {
                    //unknown typeName or theme
                }
            } else {
                if(parent.presentationEdit == null) {
                    EditorManager.start();
                } else {
                    Presentation.setEffect(parent.presentationEdit.type);
                    Presentation.setStyle(parent.presentationEdit.style);
                    Presentation.start(true); //auto start for Dynamic type.
                }
            }
            $(parent.document.getElementById('presentation')).removeClass('skeleton-loading');
            $(parent.document.getElementById('presentation')).focus();
        });
    </script>
</head>

<body id="main">
    <div class="d-none" id="presentation_editor">
        <div id="presentation_editor-container"></div>
    </div>
</body>

</html>