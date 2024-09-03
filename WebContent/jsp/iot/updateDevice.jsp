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
        Update IoT devices
    </title>

    <script type="text/javascript">
		var updateDevice = function(){
			$.ajax({
			      type: 'POST',
			      url: parent.jMap.cfg.contextPath + '/iot/updateDevice.do',
			      data: {name : $("#name").val(),id: ${data.device.getId()}, confirm : 1},
			      dataType: "application/xml",
			      success: function(data) { 
			    	  /* if(data == "1") {
			    		  parent.iotDeviceManagerAction(); 
			    	  }else{
			    		  alert(data);
			    	  } */
			      }
			});
			setTimeout(function(){
				parent.iotDeviceManagerAction(); 
			}, 2000);
		}
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <div class="mx-auto" style="max-width: 360px;">
            <form id="frm_confirm">
                <div class="form-group">
                    <label for="name">
                        Device's name
                    </label>
                    <input type="text" value="${data.device.getName() }" required class="form-control" id="name">
                </div>
				<div class="form-group">
                    <label for="mains">
                        Motherboard
                    </label>
                    <input type="text" value="${data.device.getModules().getName() }" readonly class="form-control">
                </div>
                <div class="text-center mt-4">
                    <button type="button" onclick="updateDevice()" class="btn btn-primary">
                        Update
                    </button>
                    <button type="button" onclick="parent.iotDeviceManagerAction()" class="btn btn-danger">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>