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

    <title>
        <spring:message code='menu.cs.notice' />
    </title>

    <script type="text/javascript">
        function init() {
            var notices = parent.okmNotices || [];
            var updateItemTemplate = $('#update-item-template').html();
            var notice = "";
            for (var i = notices.length - 1; i >= 0; i--) {
                var n = notices[i];
                if (typeof n == 'undefined') continue;
                var locale = "content_${locale}";
                if(n[locale] == undefined) locale = "content_en";
                var title = n[locale];
                var item = updateItemTemplate;
                var hyperlink = '';
                if (n["link_${locale}"]) hyperlink = '<a class="text-decoration-none text-body" href="' + n["link_${locale}"] + '" target="_blank"><img src="${pageContext.request.contextPath}/theme/dist/images/icons/link.svg" width="18px" class="ml-1"></a>';
                item = item.replace('[title]', title + hyperlink);
                notice = notice + item;
            }

            $('#update-list').html(notice);

            
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            init();
        });
    </script>

    <style>
        .notice-warp {
            background-image: url('${pageContext.request.contextPath}/theme/dist/images/notice-bg.png');
            background-position: right top;
            background-repeat: no-repeat;
            background-size: 350px;
            min-height: 400px;
        }

        .notice-warp>div {
            max-width: 60%;
            margin-top: 50px;
            margin-left: 50px;
        }

        @media (max-width: 500px) {
            .notice-warp {
                background-size: 200px;
                background-position: center top;
            }

            .notice-warp>div {
                max-width: 100%;
                margin-top: 150px;
                margin-left: 0px;
                text-align: center;
            }
        }
    </style>
</head>

<body>
    <div class="container-fluid py-3 notice-warp">
        <div>
            <h3 class="mb-4">
                <spring:message code='admin.okm_notice.okm_notice_title' />
            </h3>
            <ul class="list-group list-group-flush" id="update-list">
            </ul>
            <button type="button" class="btn btn-secondary rounded-pill mt-5" onclick="parent.closeNotice()">
                <spring:message code='admin.okm_notice.okm_notice_button_close' />
            </button>
        </div>
    </div>

    <template id="update-item-template">
        <li class="list-group-item bg-transparent px-0 py-2 border-0">
            <img src="${pageContext.request.contextPath}/theme/dist/images/icons/check.svg" width="18px" class="mr-2">
            [title]
        </li>
    </template>
</body>

</html>