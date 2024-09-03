<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="${locale.language}">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>" type="text/css">
</head>

<body>

	<div class="container-fluid py-3" style="max-width: 500px;">
		<img class="d-block mx-auto mb-3" src="${pageContext.request.contextPath}/theme/dist/images/icons/exclamation-mark.svg" width="80px">

		<div class="text-center">
			<div class="h4">
				<spring:message code='common.error'/>
			</div>
			<p><c:out value="${error_message}"/></p>
		</div>

		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/user/recover.do" class="btn btn-dark btn-min-w">
				<spring:message code='common.confirm' />
			</a>
		</div>
	</div>
</body>

</html>