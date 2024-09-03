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

    <script defer src="${pageContext.request.contextPath}/lib/apputil.js?v=<%=updateTime%>" type="text/javascript"></script>

    <title>
        <spring:message code='menu.export' />
    </title>
</head>

<body>
    <div class="container-fluid py-1">
        <button type="button" class="btn btn-light p-3 shadow-none m-1" id="remixMap" style="min-width: 130px">
            <img src="${pageContext.request.contextPath}/theme/dist/images/icons/remixmap.svg" width="40px" class="d-block mx-auto">
            <small>
                <spring:message code='menu.mindmap.remixmap' />
            </small>
        </button>

        <button type="button" class="btn btn-light p-3 shadow-none m-1" id="mapOfRemix" style="min-width: 130px">
            <img src="${pageContext.request.contextPath}/theme/dist/images/icons/mapofremixes.png" width="40px" class="d-block mx-auto">
            <small>
                <spring:message code='menu.mindmap.mapofremixes' />
            </small>
        </button>
    </div>
</body>
<script type="text/javascript">
$("#remixMap").click(function(){
	parent.JinoUtil.closeDialog();
	parent.remixMap();
});
$("#mapOfRemix").click(function(){
	parent.JinoUtil.closeDialog();
	parent.mapOfRemixes();
	parent.JinoUtil.waitingDialog("<spring:message code='message.loading' />");
});
</script>
</html>