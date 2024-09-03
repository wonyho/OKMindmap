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

	<title>
		<spring:message code='user.membershipwithrawal' />
	</title>
</head>

<body>

	<div class="container-fluid py-1">
		<div class="mx-auto pt-4" style="max-width: 500px;">
			<img class="d-block mx-auto mb-4" src="${pageContext.request.contextPath}/theme/dist/images/icons/exclamation-mark.svg" width="80px">

			<ul class="font-weight-bold">
				<li>
					<spring:message code='user.membershipwithrawal.profiledeleted' />
				</li>
				<li>
					<spring:message code='user.membershipwithrawal.mapsremain' />
				</li>
				<li>
					<spring:message code='user.membershipwithrawal.mapcantrestoredeleted' />
				</li>
			</ul>

			<form id="frm-user-update" action="${pageContext.request.contextPath}/user/delete.do" method="post">
				<div class="custom-control custom-checkbox my-3">
					<input type="checkbox" class="custom-control-input" id="dropoutAgree" id="dropoutAgree" name="confirmed" value="1">
					<label class="custom-control-label" for="dropoutAgree">
						<spring:message code='user.membershipwithrawal.readandagrees' />
					</label>
				</div>

				<div class="form-group row my-3">
					<label class="col-4 col-form-label">
						<spring:message code='common.password' /></label>
					<div class="col-8">
						<input required type="password" class="form-control" id="password" name="password" value="">
					</div>
				</div>

				<c:if test="${data.error != ''}">
					<div class="alert alert-danger" role="alert">
						*
						<c:out value="${data.error}" />
					</div>
				</c:if>

				<div class="text-center mt-5">
					<button type="submit" class="btn btn-danger btn-min-w">
						<spring:message code='user.membershipwithrawal' />
					</button>
				</div>
			</form>
		</div>
	</div>
</body>

</html>