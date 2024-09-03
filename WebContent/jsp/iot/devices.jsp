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
        <spring:message code='menu.insertLTIAction' />
    </title>

    <script type="text/javascript">
       
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <table class="table">
		  <thead class="thead-dark">
		    <tr>
		      <th scope="col">No.</th>
		      <th scope="col">Name</th>
		      <th scope="col">#</th>
		    </tr>
		  </thead>
		  <tbody>
		    <% int i =0; %>
		    <c:forEach var="d" items="${data.devices}">
		    	<tr>
		    		<td><%=++i %></td>
		    		<td>${d.getName()}</td>
		    		<td>
		    			<a href="${pageContext.request.contextPath}/iot/key.do?id=${d.getId()}" class="btn btn-light btn-sm mr-1 copyKey">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/key.svg" width="18px">
						</a>
		    			<a href="${pageContext.request.contextPath}/iot/sensor.do?id=${d.getId()}" class="btn btn-light btn-sm mr-1">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/settings.svg" width="18px">
						</a>
						<a href="${pageContext.request.contextPath}/iot/updateDevice.do?id=${d.getId()}" class="btn btn-light btn-sm mr-1">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/edit-3.svg" width="18px">
						</a>
						<a href="${pageContext.request.contextPath}/iot/deleteDevice.do?id=${d.getId()}" class="btn btn-light btn-sm">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/trash-2.svg" width="18px">
						</a>
		    		</td>
		    	</tr>
		    </c:forEach>
		  </tbody>
		</table>
        	
		<div class="text-center mt-4">
		    <button type="button" onclick="parent.iotAddDeviceAction()" class="btn btn-primary">
		        New
		    </button>
		    <button type="button" onclick="parent.JinoUtil.closeDialog()" class="btn btn-danger">
		        Close
		    </button>
		    <input class="d-none" type="text" id="copyMemo" />
		</div>
    </div>

</body>

</html>