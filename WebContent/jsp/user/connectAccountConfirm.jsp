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
	<div class="text-center">
		<h2 class="tit v1 h4">Please enter Tubestory password to continue</h2>
		<form class="w-100 mx-auto pt-3" style="max-width: 500px;" 
			action="${pageContext.request.contextPath}/user/confirmAccountConnection.do" method="post">
			<div class="input-group mt-4">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/key.svg" width="20px">
					</div>
				</div>
				<input type="text" id="username" name="username" readonly  required class="form-control rounded-0" value="${data.user}">
			</div>
			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="20px">
					</div>
				</div>
				<input required type="password" class="form-control rounded-0" autofocus name="password" value="" placeholder="<spring:message
				code='message.password' />">
			</div>
			<p class="text-danger">${data.msg}</p>
			<input type="hidden" name="confirm" value="1">
			<input type="hidden" name="type" value="${data.type }">
			<input type="hidden" name="value" value="${data.value }">
			<button class="btn btn-block btn-danger mt-3" type="submit">Continue</button>
		</form>
		
		
	</div>

	<script type="text/javascript">
		
	</script>
</body>

</html>