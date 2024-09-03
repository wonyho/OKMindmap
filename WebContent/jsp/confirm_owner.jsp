<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
		<spring:message code='confirm.owner' />
	</title>

	<script type="text/javascript">
		function check() {
			var frm = document.getElementById("frm_confirm");

			var params = {
				"id": frm.id.value,
				"email": frm.email.value,
				"password": frm.password.value
			};

			$.post("${pageContext.request.contextPath}/confirm.do", params, function (data) {
				if (data.status == "ok") {
					var frm = document.getElementById("frm_confirm");
					frm.submit();
				} else {
					alert("error4 : " + data.message);
				}
			});
		}

		$(document).ready(function () {
			$("#frm_confirm").submit(function (event) {
				event.preventDefault();
				check();
			});
		});
	</script>
</head>

<body>
	<div class="container-fluid py-1">
		<div class="mx-auto pt-4" style="max-width: 300px;">
			<img class="d-block mx-auto mb-4" src="${pageContext.request.contextPath}/theme/dist/images/icons/confirm-owner.svg" width="80px">
			<div class="h5 mb-3 text-center">
				<spring:message code='confirm.owner' />
			</div>

			<form id="frm_confirm" action="${pageContext.request.contextPath}<c:out value='${data.action}'/>" method="post" target="_parent">
				<input type="hidden" name="id" value="<c:out value='${data.mapId}'/>" />

				<div class="form-group">
					<label for="email">
						<spring:message code='common.email' />
					</label>
					<input type="email" required class="form-control" id="email" name="email">
				</div>
				<div class="form-group">
					<label for="password">
						<spring:message code='common.password' />
					</label>
					<input type="password" required class="form-control" id="password" name="password">
				</div>

				<div class="text-center mt-5">
					<button type="submit" class="btn btn-primary btn-min-w">
						<spring:message code='button.submit' />
					</button>
				</div>
			</form>
		</div>
	</div>

</body>

</html>