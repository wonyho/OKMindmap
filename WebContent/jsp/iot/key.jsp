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
    	$(document).ready(function(){
    		$("#keyId").select();
            document.execCommand('copy');
    	});
        var copyKey = function(){
        	$("#keyId").select();
            document.execCommand('copy');
        }
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <textarea rows="" cols="" style="width: 100%; height: 100px;" id="keyId">${data.key}</textarea>
        <h6 class="text-primary">The key is copied. Insert this key to your device to use.</h6>	
		<div class="text-center mt-4">
		    <button type="button" onclick="copyKey()" class="btn btn-primary">
		        Copy
		    </button>
		    <button type="button" onclick="location.href='${pageContext.request.contextPath}/iot/devices.do'" class="btn btn-danger">
		        Back
		    </button>
		</div>
    </div>

</body>

</html>