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
	<script src="${pageContext.request.contextPath}/lib/apputil.js?v=<%=updateTime%>" type="text/javascript"></script>
</head>

<body class="bg-gray-200 p-3">
	<div class="d-flex justify-content-center align-items-center vh-100">
		<div class="text-center py-5 px-3 bg-white shadow-lg rounded-lg w-100" style="min-height: 200px; max-width: 600px;">
			<img src="${pageContext.request.contextPath}/theme/dist/images/icons/help-round-button.svg" width="80px;" class="mb-5">
			<h2 class="tit v1 h4"></h2>
			<div class="mt-4">
				<button class="btn btn btn-primary btn-min-w" id="toMain_btn" type="button"><spring:message code="error.gomain"/></button>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		$(document).ready(function () {
			var ISMOBILE = ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPad/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/Android/i)));
			var supportsTouch = "createTouch" in document;
			var sessionCheckUrl = '<%=sessionCheckUrl%>';
			var message = '<c:out value="${data.message}"/>';

			if (message != '') {
				message = message.replace('&lt;', '<').replace('&gt;', '>');
				$("h2.v1").html(message);
			} else {
				$("h2.v1").html('<spring:message code="user.new.email_pleaseconfirm" />');
			}

			$("#toMain_btn").on("click touchstart", function () {
				// fnPageMove(1);
				window.location.href = '${pageContext.request.contextPath}/';
			});			
		});
	</script>
</body>

</html>