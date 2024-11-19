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
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">

	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

	<script type="text/javascript">
		$(document).ready(function () {
			$("#frm_presentation").submit(function (event) {
				var url = document.location.protocol + '//' + document.location.host + '${pageContext.request.contextPath}/show/map/' + parent.jMap.cfg.mapKey +
					'?type=' + $('#type_presentation').val() + '&style=' + $('#style_presentation').val();

				$('#url_presentation').val(url).select();
				// Copy to the clipboard
				document.execCommand('copy');
				alert("<spring:message code='presentation.create_url_message'/>");
				event.preventDefault();
			});
			
			var n = countChildNode(parent.jMap.getRootNode()) + 1;
			$("#map-size").text(n);
			var kb = parseInt((xmlLength + 10) / 1024);
			$("#map-sizeKb").text((xmlLength + 10) % 1024 > 0 ? kb + 1 : kb);
		});
		
		var xmlLength = 0;
		
		var countChildNode = function(node){
			xmlLength += node.toXML().length;
			var childs = node.getChildren();
			var n = 0;
			for(var i =0; i<childs.length; i++){
				n = n + countChildNode(childs[i]);
			}
			return  n + childs.length;;
		}
	</script>
</head>

<body>
	<div class="container-fluid py-1" style="max-width: 500px;">
		<div class="text-center">
			<c:choose>
				<c:when test="${short_url == ''}">
					<div class="img-thumbnail bg-light d-inline-block mx-auto" style="width: 250px; height: 250px;"></div>
				</c:when>
				<c:otherwise>
					<a href="http://api.qrserver.com/v1/create-qr-code/?data=<%=short_url%>" target="_blank">
						<img class="img-thumbnail" style="width: 250px; height: 250px;" src="http://api.qrserver.com/v1/create-qr-code/?data=https://<%=short_url%>">
					</a>
					<h4 class="my-3" style='font-family: "Times New Roman", Times, serif; font-size: 39px;' ><%=short_url%></h4>
				</c:otherwise>
			</c:choose>
		</div>
		<h6 class="mt-3 text-center">
			<spring:message code='common.size' />: <span id="map-size"></span> (nodes), <span id="map-sizeKb"></span>Kb (XML format)
		</h6>
		<h6 class="mt-3">
			<spring:message code='menu.presentation' />
		</h6>
		<form class="mt-2" id="frm_presentation">
			<div class="row">
				<div class="col px-2">
					<div class="form-group">
						<select id="type_presentation" class="custom-select form-control">
							<option value="Box">--<spring:message code='presentation.type' />--</option>
							<option value="Dynamic"><spring:message code='presentation.dynamic' /></option>
							<option value="Box"><spring:message code='presentation.box' /></option>
							<option value="Aero"><spring:message code='presentation.aero' /></option>
							<option value="Linear"><spring:message code='presentation.linear' /></option>
							<option value="Mindmap-Basic"><spring:message code='presentation.basic' /></option>
							<option value="Mindmap-Zoom"><spring:message code='presentation.zoom' /></option>
						</select>
					</div>
				</div>
				<div class="col px-2">
					<div class="form-group">
						<select id="style_presentation" class="custom-select form-control">
							<option value="Basic">--<spring:message code='presentation.theme' />--</option>
							<option value="BlackLabel"><spring:message code='presentation.theme1' /></option>
							<option value="Basic"><spring:message code='presentation.theme2' /></option>
							<option value="Sunshine"><spring:message code='presentation.theme3' /></option>
							<option value="Sky"><spring:message code='presentation.theme4' /></option>
							<option value="BlueLabel"><spring:message code='presentation.theme5' /></option>
						</select>
					</div>
				</div>
			</div>

			<div class="text-center">
				<button type="submit" class="btn btn-primary"><spring:message code='presentation.create_url' /></button>
			</div>
		</form>
		<textarea id="url_presentation" style="resize: none; height: 90px;" readonly class="form-control text-monospace bg-light shadow-none mt-3" rows="4"></textarea>
	</div>
</body>

</html>