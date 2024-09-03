<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

	String short_url  = request.getParameter("short_url");
	request.setAttribute("short_url", short_url);
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

<!doctype html>
<html lang="${locale}">

<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
	<title>
		Score
	</title>
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">

	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

	<script type="text/javascript">
		$(document).ready(function () {
			
		});
	</script>
</head>

<body>
	<div class="container-fluid py-1">
		<table class="table">
		  <thead class="thead-dark">
		    <tr>
		      <th scope="col">#</th>
		      <th scope="col">Username</th>
		      <th scope="col">Fullname</th>
		      <th scope="col">Score</th>
		      <!-- <th scope="col">Time</th> -->
		    </tr>
		  </thead>
		  <tbody>
		    <% int i =0; %>
		    <c:forEach var="score" items="${data.scores}">
		    	<% i++; %>
		    	<tr>
			      <th scope="row"><%= i %></th>
			      <td>${score.username}</td>
			      <td>${score.fullname}</td>
			      <td>${score.score}</td>
			      <%-- <td>${score.fulltime}</td> --%>
			    </tr>
		    </c:forEach>
		  </tbody>
		</table>
	</div>
</body>

</html>