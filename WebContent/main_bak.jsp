<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="env" uri="http://www.servletsuite.com/servlets/enventry" %>

<%
	request.setAttribute("user", session.getAttribute("user"));

	boolean cefapp = Boolean.parseBoolean(request.getParameter("cefapp"));
	request.setAttribute("cefapp", cefapp);
	if(cefapp) {
		Cookie cookie = new Cookie("cefapp", "true");
		cookie.setPath("/");
		response.addCookie(cookie);
	}

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}

%>

<c:choose>
	<c:when test="${cookie['locale'].getValue() == 'en'}">
		<c:set var="locale" value="en"/>
	</c:when>
	<c:when test="${cookie['locale'].getValue() == 'es'}">
		<c:set var="locale" value="es"/>
	</c:when>
	<c:when test="${cookie['locale'].getValue() == 'vi'}">
		<c:set var="locale" value="vi"/>
	</c:when>
	<c:otherwise>
		<c:set var="locale" value="ko"/>
	</c:otherwise>
</c:choose>

<c:if test="${cookie['cefapp'].getValue() != null}">
	<c:set var="cefapp" value="${cookie['cefapp'].getValue()}"/>
</c:if>

<fmt:setLocale value="${locale}"/>

<!doctype html>
<html lang="${locale}">

<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico?v=<%=updateTime%>" />
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">

	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>
	<script src="${pageContext.request.contextPath}/lib/jquery.cookie.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

	<title>OKMindmap :: Design Your Mind!</title>

</head>

<body>

	<c:choose>
		<c:when test="${cefapp}">
			<%@include file="main_app.jsp" %>
		</c:when>
		<c:when test="${locale == 'en'}">
			<%@include file="main_en.jsp" %>
		</c:when>
		<c:when test="${locale == 'es'}">
			<%@include file="main_es.jsp" %>
		</c:when>
		<c:when test="${locale == 'vi'}">
			<%@include file="main_vi.jsp" %>
		</c:when>
		<c:otherwise>
			<%@include file="main_ko.jsp" %>
		</c:otherwise>
	</c:choose>

	<script type="text/javascript">
		var okmLogout = function () {
			$.cookie('currentTab', 0);
			document.location.href = "${pageContext.request.contextPath}/user/logout.do";
		}

		function changeLanguage(lang) {
			document.location.href = "${pageContext.request.contextPath}/language.do?locale=" + lang + "&page=" + document.location.href;
		}
	</script>

	<!-- Start of StatCounter Code for Default Guide -->
	<script type="text/javascript">
		var sc_project = 7775078;
		var sc_invisible = 1;
		var sc_security = "aab0f358"; 
	</script>
	<script type="text/javascript" src="http://www.statcounter.com/counter/counter.js"></script>
	<noscript>
		<div class="statcounter">
			<a title="tumblrtracker" href="http://statcounter.com/tumblr/" target="_blank">
				<img class="statcounter" src="http://c.statcounter.com/7775078/0/aab0f358/1/" alt="tumblr tracker" />
			</a>
		</div>
	</noscript>
	<!-- End of StatCounter Code for Default Guide -->
</body>

</html>