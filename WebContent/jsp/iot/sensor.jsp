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
        Add IoT devices
    </title>

    <script type="text/javascript">
		var addDevice = function(){
			$.ajax({
			      type: 'POST',
			      url: parent.jMap.cfg.contextPath + '/iot/sensor.do',
			      data: {name : $("#name").val(), type: $("#mains").val(), board: ${data.board}, confirm : 1},
			      dataType: "application/xml",
			      success: function(data) { 
			    	  if(data == "1") {
			    		  parent.iotDeviceManagerAction(); 
			    	  }else{
			    		  alert(data);
			    	  }
			      }
			});
		}
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <table class="table">
		  <thead class="thead-dark">
		    <tr>
		      <th scope="col">No.</th>
		      <th scope="col">Name</th>
		      <th scope="col">ID</th>
		      <th scope="col">#</th>
		    </tr>
		  </thead>
		  <tbody>
		    <% int i =0; %>
		    <c:forEach var="d" items="${data.connections}">
		    	<tr>
		    		<td><%=++i %></td>
		    		<td>${d.getName()}</td>
		    		<td>${d.getId()}</td>
		    		<td>
						<a href="${pageContext.request.contextPath}/iot/updateconn.do?id=${d.getId()}&bid=${data.board}" class="btn btn-light btn-sm mr-1">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/edit-3.svg" width="18px">
						</a>
						<a href="${pageContext.request.contextPath}/iot/deleteconn.do?id=${d.getId()}&bid=${data.board}" class="btn btn-light btn-sm">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/trash-2.svg" width="18px">
						</a>
		    		</td>
		    	</tr>
		    </c:forEach>
		  </tbody>
		</table>
		
        <div class="text-center mt-4">
        	<button type="button" onclick="location.href='${pageContext.request.contextPath}/iot/addconn.do?id=${data.board}';" class="btn btn-primary">
			    Add connection
			</button>
           <button type="button" onclick="parent.iotDeviceManagerAction()" class="btn btn-danger">
               Back
           </button>
       </div>
    </div>

</body>

</html>