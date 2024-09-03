<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page
	import="org.springframework.web.servlet.support.RequestContextUtils"%>
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
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
<!-- Theme -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
<script
	src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

<title><spring:message code='message.login' /></title>

<script type="text/javascript">
	var auth_redirect = '${data.auth_redirect}';
	if (auth_redirect != '')
		parent.document.location.href = auth_redirect;

	function check() {
		var frm = document.getElementById("frm_login");

		var params = {
			"username" : frm.username.value,
			"password" : frm.password.value
		};

		$.post("${pageContext.request.contextPath}/confirm.do", params,
				function(data) {
					if (data.status == 'ok') {
						var frm = document.getElementById("frm_login");
						frm.target = "_parent";
						frm.return_url.value = parent.document.location.href;
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

<script type="text/javascript">
	function checkSubmit(frm) {
		var username = frm.username.value;
		if (!validateNotEmpty(username)) {
			alert("<spring:message code='user.new.username_not_enter'/>");
			return false;
		}

		var email = frm.email.value;
		if (!validateEmail(email)) {
			alert("<spring:message code='user.new.email_not_valid'/>");
			return false;
		}

		return true;
	}

	function validateEmail(mail) {
		//var reg = new RegExp('^[a-z0-9]+([_|\.|-]{1}[a-z0-9]+)*@[a-z0-9]+([_|\.|-]­{1}[a-z0-9]+)*[\.]{1}(com|ca|net|org|fr|us|qc.ca|gouv.qc.ca)$', 'i');
		var reg = new RegExp(
				/^[A-Za-z0-9]([A-Za-z0-9_-]|(\.[A-Za-z0-9]))+@[A-Za-z0-9](([A-Za-z0-9]|(-[A-Za-z0-9]))+)\.([A-Za-z]{2,6})(\.([A-Za-z]{2}))?$/);

		if (!reg.test(mail) || mail == "") {
			return false;
		} else {
			return true;
		}
	}

	function validateNotEmpty(strValue) {
		var strTemp = strValue;

		strTemp = trimAll(strTemp);
		if (strTemp.length > 0) {
			return true;
		}

		return false;
	}

	function trimAll(strValue) {
		var objRegExp = /^(\s*)$/;

		//check for all spaces
		if (objRegExp.test(strValue)) {
			strValue = strValue.replace(objRegExp, '');

			if (strValue.length == 0)
				return strValue;
		}

		//check for leading & trailing spaces
		objRegExp = /^(\s*)([\W\w]*)(\b\s*$)/;
		if (objRegExp.test(strValue)) {
			//remove leading and trailing whitespace characters
			strValue = strValue.replace(objRegExp, '$2');
		}

		return strValue;
	}

	function cancel() {
		parent.$("#dialog").dialog("close");
	}
</script>
</head>

<body>
	<div class="container-fluid py-1">
		<form class="w-100 mx-auto pt-3" style="max-width: 500px;"
			name="frm_recover" id="frm_recover"
			action="${pageContext.request.contextPath}/user/recover.do"
			method="post" onSubmit="return checkSubmit(this);">

			<input type="hidden" name="confirmed" value="1" /> 

			<div class="text-center">
				<div class="list-group list-group-horizontal-xl list-group-style-1">
					<a class="list-group-item list-group-item-action active"
						href="${pageContext.request.contextPath}/user/recover.do"> 
						<spring:message code='login.fogot' /></a>
				</div>
			</div>

			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user.svg" width="20px">
					</div>
				</div>
				<input type="text" required class="form-control rounded-0" name="username" value="" placeholder="<spring:message code='message.id'/>">
			</div>
			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/mail.svg" width="20px">
					</div>
				</div>
				<input type="email" required name="email" value="" class="form-control rounded-0" placeholder="<spring:message code='common.email'/>">
			</div>
			<div class="input-group mt-3">
				<button class="btn btn-block btn-danger rounded-0 mt-3" type="submit">
					<spring:message code='common.confirm' />
				</button>
			</div>
		</form>
	</div>
</body>

</html>