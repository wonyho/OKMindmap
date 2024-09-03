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
		<spring:message code='message.group.join' />
	</title>
</head>

<body>
	<div class="container-fluid py-3">
		<div class="mx-auto" style="max-width: 300px;">
			<img class="d-block mx-auto mb-3" src="${pageContext.request.contextPath}/theme/dist/images/icons/confirm-owner.svg" width="80px">
			<div class="text-center mb-3">
				<spring:message code='message.group.join' />
				<div class="h4">
					<c:out value="${ data.group.name }" />
				</div>
			</div>

			<form action="${pageContext.request.contextPath}/group/join.do" method="post">
				<input type="hidden" name="groupid" value="<c:out value='${data.group.id}' />">

				<c:if test="${data.wrongPassword}">
					<div class="alert alert-danger text-center" role="alert">
						<spring:message code='error.passwordincorrect' />
					</div>
				</c:if>

				<div class="form-group">
					<label for="password">
						<spring:message code='common.password' />
					</label>
					<input type="password" required autofocus class="form-control" id="password" name="password">
				</div>

				<div class="text-center mt-4">
					<button type="submit" class="btn btn-primary btn-min-w">
						<spring:message code='button.submit' />
					</button>
					<a href="${pageContext.request.contextPath}/group/join.do" class="btn btn-dark btn-min-w">
						<spring:message code='button.cancel' />
					</a>
				</div>
			</form>
		</div>
	</div>

</body>

</html>