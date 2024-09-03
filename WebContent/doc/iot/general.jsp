<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        IoT support
    </title>
		<style>
	.center {
	  display: block;
	  margin-left: auto;
	  margin-right: auto;

	}
	</style>
    <script type="text/javascript">
		
    </script>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-light" style="background-color: #48b87e !important;">
  <a class="navbar-brand" href="#">OKMindmap IoT</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNavDropdown">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}">Homepage</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}">Overview</a>
      </li>
      <li class="nav-item  active dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Examples
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          <%-- <a class="dropdown-item" href="${pageContext.request.contextPath}/doc/iot/general.jsp">General</a> --%>
          <a class="dropdown-item" href="${pageContext.request.contextPath}/doc/iot/esp8266.jsp">ESP8266</a>
        </div>
      </li>
    </ul>
  </div>
</nav>
<div class="container my-4">
	<h4 class="text-secondary"><span class="badge badge-secondary">I</span> Update sensor values to Tubestory IoT server</h4>
	<p>- iot_device_key: 1-ee1f9ccf0f42dba12f94bed0d09160d7</p>
	<p>- iot_sensor: 5</p>
	<p>- iot_sensor_value: TEMP:30.0,HUMID:80</p>
	<p><b>Send request: </b></p>
	<p><b>http://tubestory.co.kr/iot/setval.do?iot_device_key=1-ee1f9ccf0f42dba12f94bed0d09160d7 &iot_sensor=5&iot_sensor_value=TEMP:30.0,HUMID:80</b></p>
	<p><b>Response : </b></p>
	<p><b>{"iot_set_result":"true","iot_device_key":"1-ee1f9ccf0f42dba12f94bed0d09160d7"}</b></p>
	
	
	<h4 class="text-secondary"><span class="badge badge-secondary">II</span> Sync action request from Tubestory IoT server</h4>
	<p>- iot_device_key: 1-ee1f9ccf0f42dba12f94bed0d09160d7</p>
	<p>- iot_sensor: 1</p>
	<p><b>Send request: </b>
	<p><b>http://tubestory.co.kr/iot/action.do?iot_device_key=1-ee1f9ccf0f42dba12f94bed0d09160d7&iot_sensor=1</b></p>
	<p><b>Response : </b></p>
	<p><b>{"iot_action":"SWITCH:ON","iot_device_key":"1-ee1f9ccf0f42dba12f94bed0d09160d7"}</b></p>
	
		<video class="center" width="" height="400" controls>
	  <source src="${pageContext.request.contextPath}/doc/img/video1.mov" type="video/mp4">
	</video>
</div>


</body>
</html>