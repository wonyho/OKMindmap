<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	String useragent = (String) request.getAttribute("agent");
	String facebook_appid = Configuration.getString("facebook.appid");
	Locale locale = RequestContextUtils.getLocale(request);
	request.setAttribute("locale", locale);

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<!doctype html>
<html lang="${locale.language}">

<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

	<title><spring:message code='message.login' /></title>

  <script src="https://apis.google.com/js/api:client.js"></script>

	<script type="text/javascript">
		// var auth_redirect = '${data.auth_redirect}';
		// if (auth_redirect != '') parent.document.location.href = auth_redirect;

		function check() {
			var frm = document.getElementById("frm_login");

			var params = {
				"username": frm.username.value,
				"password": frm.password.value
			};

			$.post("${pageContext.request.contextPath}/confirm.do", params, function (data) {
				if(data.status == 'ok') {
					var frm = document.getElementById("frm_login");
					if(parent != window) {
						frm.target = "_parent";
						frm.return_url.value = parent.document.location.href;
					}
					frm.submit();
				} else {
					alert("error3 : " + data.message);
				}
			});
		}

		function jsEnter(e) {
			e = e || window.event;
			if (e.keyCode == 13) {
				check();
			}
		}
		
	</script>
</head>

<body>
	<div class="container-fluid py-1">
		<c:if test="${data.moodle_login eq null}">
			<form class="w-100 mx-auto pt-3" style="max-width: 500px;" name="frm_login" id="frm_login" action="${pageContext.request.contextPath}/oauth2/authorize.do" method="post">

				<input type="hidden" name="confirmed" value="1" />
				<input type="hidden" name="client_id" value="${data.client_id}" />
				<input type="hidden" name="redirect_uri" value="${data.redirect_uri}" />
				<input type="hidden" name="response_type" value="${data.response_type}" />

				<div class="text-center">
					<div class="list-group list-group-horizontal-xl list-group-style-1">
						<a class="list-group-item list-group-item-action active" href="#">
							<spring:message code='message.login' /></a>
						
					</div>
				</div>

				<div class="input-group mt-4">
					<div class="input-group-prepend">
						<div class="input-group-text rounded-0">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/key.svg" width="20px">
						</div>
					</div>
					<input type="text" id="username" name="username" autofocus required class="form-control rounded-0" onkeypress="jsEnter(event)" placeholder="<spring:message
					code='message.id' />">
				</div>
				<div class="input-group mt-3">
					<div class="input-group-prepend">
						<div class="input-group-text rounded-0">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="20px">
						</div>
					</div>
					<input required type="password" class="form-control rounded-0" name="password" value="" onkeypress="jsEnter(event)" placeholder="<spring:message
					code='message.password' />">
				</div>

				<a class="btn btn-block btn-dark rounded-0 mt-3" href="#" onclick="check()">
					<spring:message code='message.login' />
				</a>

			</form>
		</c:if>

	</div>
</body>

</html>