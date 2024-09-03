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
		<spring:message code='message.share.openmap' />
	</title>

	<c:choose>
		<c:when test="${data.type=='popup'}">
			<script type="text/javascript">
				var okmLogin = function () {
					document.location.href = "${pageContext.request.contextPath}/user/login.do";
				};
			</script>
		</c:when>
	</c:choose>

	<script type="text/javascript">
		function check() {
			var frm = document.getElementById("frm_share_password");

			var params = {
				"id": frm.id.value,
				"password": frm.password.value
			};

			$.post("${pageContext.request.contextPath}/confirm.do", params, function (data) {
				if (data.status == "ok") {
					var frm = document.getElementById("frm_share_password");
					frm.submit();
				} else {
					alert("error1 : " + data.message);
				}
			});
		}

		function directView() {
			var frm = document.getElementById("frm_share_password");
			frm.password.value = "";
			frm.directView.value = "1";
			frm.submit();
		}

		function moveTo(url) {
			document.location.href = url;
		}

		$(document).ready(function () {
			$("#frm_share_password").submit(function (event) {
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
				<c:choose>
					<c:when test="${data.hasPasswordEditGrant=='true'}">
						<spring:message code='share.password.pleasinputpasswordtoedit' />
					</c:when>
					<c:otherwise>
						<spring:message code='share.password.pleasinputpasswordtosee' />
					</c:otherwise>
				</c:choose>
			</div>

			<form id="frm_share_password" name="frm_share_password" action="${pageContext.request.contextPath}<c:out value='${data.action}'/>" method="post" target="_parent">
				<input type="hidden" name="directView" value="0" />
				<input type="hidden" name="shareConfirm" value="passwordCheck" />

				<c:if test="${data.mapId != null}">
					<input type="hidden" name="id" value="<c:out value='${data.mapId}' />" />
				</c:if>

				<div class="form-group">
					<label for="password">
						<spring:message code='message.password' />
					</label>
					<input type="password" required class="form-control form-control-lg" id="password" name="password">
				</div>

				<div class="text-center mt-3">
					<button type="submit" class="btn btn-primary btn-block btn-lg">
						<spring:message code='button.confirm' />
					</button>
				</div>
			</form>

			<div class="text-center mt-5">
				<c:if test="${user.username == 'guest' && data.type == 'popup'}">
					<button type="button" class="btn btn-dark btn-min-w" onclick="okmLogin()">
						<spring:message code='message.login' />
					</button>
				</c:if>
				<c:if test="${data.message == 'strongpassword'}">
					<button type="button" class="btn btn-dark btn-min-w" onclick="parent.JinoUtil.closeDialog();">
						<spring:message code='share.password.viewmindmap' />
					</button>
				</c:if>
				<c:if test="${data.message != 'strongpassword'}">
					<button type="button" class="btn btn-dark btn-min-w" onclick="moveTo('${pageContext.request.contextPath}/')">
						<spring:message code='error.gomain' />
					</button>
				</c:if>
			</div>
		</div>
	</div>

</body>

</html>