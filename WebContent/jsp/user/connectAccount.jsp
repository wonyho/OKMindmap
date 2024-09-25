<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}

	String sessionCheckUrl = Configuration.getString("session.check.url");
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
</head>

<body class="bg-gray-200 p-3">
	<div class="w-100 mx-auto pt-3 text-center" style="max-width: 500px;">
		<img src="${pageContext.request.contextPath}/theme/dist/images/icons/help-round-button.svg" width="80px;" class="mb-5">
		<h2 class="tit v1 h4">The email <br> <b class="text-primary">${data.user.getEmail()}</b><br> is used for an account <br> Do you want to connect?</h2>
		<button class="btn btn-block btn-danger mt-3" type="button" id="doNew">No, create new account</button>
		<button class="btn btn-block btn-danger mt-3" type="button" id="doConnect">Yes, connect to this account</button>
		
	</div>

	<script type="text/javascript">
		$("#doConnect").click(function(){
			location.href="${pageContext.request.contextPath}/user/confirmAccountConnection.do?type=${data.type}&value=${data.value}&username=${data.user.getUsername()}";
		})
		
		$("#doNew").click(function(){
			location.href="${pageContext.request.contextPath}/user/new.do";
		})
	</script>
</body>

</html>