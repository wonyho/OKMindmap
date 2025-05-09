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
	<style>
	.option_row{ cursor: pointer; }
	tr:hover{ backround-color: #28a745 !important; }
	</style>
    <script type="text/javascript">
		var addDevice = function(type, sensor, text){
			var node = parent.jMap.getSelected();
			if(node != undefined && node != null ){
				node.setIotDevice(type, sensor);
				if (node.getText() == '') node.setText(text);
				parent.JinoUtil.closeDialog();
			}
		}
		
		var delDevice = function(){
			var node = parent.jMap.getSelected();
			if(node != undefined && node != null ){
				node.deleteIotDevice();
				if (node.getText() != '') node.setText('');
				
				parent.JinoUtil.closeDialog();
			}
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
		     
		    </tr>
		  </thead>
		  <tbody>
		    <% int i =0; %>
		    <c:forEach var="d" items="${data.connections}">
		    	<tr class="option_row" onclick="addDevice(${d.getSensor().getId()}, ${d.getId()},'${d.getName()}' )">
		    		<td><%=++i %></td>
		    		<td>${d.getName()}</td>
		    		
		    	</tr>
		    </c:forEach>
		    <% if(i==0){ %>
		    	<tr>
		    		<td colspan="2">Not find any device is connected, go to IoT setting to insert device</td>
		    	</tr>
		    <%} %>
		  </tbody>
		</table>
		<h6 class="text-primary">Please select a device to finish</h6>
        <div class="text-center mt-4">
        	<button type="button" onclick="delDevice()" class="btn btn-primary">
			   Delete
			</button>
           <button type="button" onclick="location.href='${pageContext.request.contextPath}/iot/readydevice.do';" class="btn btn-danger">
               Back
           </button>
       </div>
    </div>

</body>

</html>