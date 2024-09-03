<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ page import="com.okmindmap.util.PagingHelper"%>
<%@ page import="java.util.HashMap"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	Locale locale = RequestContextUtils.getLocale(request);
	request.setAttribute("locale", locale);

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<!DOCTYPE html>
<html lang="${locale.language}">

<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

	<title>
		<spring:message code='menu.okmpreference' />
	</title>

	<script type="text/javascript">
		function mapComplete() {
			$.ajax({
				type: 'post',
				async: false,
				url: parent.jMap.cfg.contextPath + '/mindmap/changeMap.do',
				data: {
					'mapId': parent.mapId,
					'lazyloading': $('#lazyloading-check').is(':checked') ? 1 : 0,
					'queueing': $('#queue-check').is(':checked') ? 1 : 0
				},
				success: function (data) {
					parent.window.location.reload(true);
				},
				error: function (data, status, err) {
					alert("err : " + status);
				}
			});
		}

		$(document).ready(function () {
			$("#map_preference").submit(function (event) {
				event.preventDefault();
				mapComplete();
			});
		});
	</script>
</head>

<body>
	<div class="container-fluid py-3" style="max-width: 300px;">
		<form id="map_preference">
			<div class="form-group">
				<div class="custom-control custom-checkbox">
					<input type="checkbox" class="custom-control-input" id="lazyloading-check" <c:if test="${data.lazyloading eq '1'}">checked</c:if> />
					<label class="custom-control-label" for="lazyloading-check">
						<spring:message code='setting.lazy_loading' />
					</label>
				</div>
			</div>

			<div class="form-group">
				<div class="custom-control custom-checkbox">
					<input type="checkbox" class="custom-control-input" id="queue-check" <c:if test="${data.queueing}">checked</c:if> />
					<label class="custom-control-label" for="queue-check">
						<spring:message code='preference.stackqueue' />
					</label>
				</div>
			</div>

			<div class="text-center">
				<button type="submit" class="btn btn-primary btn-min-w">
					<spring:message code='button.apply' />
				</button>
			</div>
		</form>
	</div>
</body>

</html>