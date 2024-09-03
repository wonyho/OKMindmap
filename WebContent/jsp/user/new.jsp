<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="env" uri="http://www.servletsuite.com/servlets/enventry" %>

<%
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

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
		<spring:message code='message.member.new' />
	</title>


	<script type="text/javascript">
		var FACEBOOK_APP_ID = '<%=facebook_appid%>';

		var checkedUsername = false;
		var checkedEmail = false;

		function validateUsername(username) {
			var illegalChars = /\W/; // allow letters, numbers, and underscores

			if (username == "") {
				/* alert("<spring:message code='user.new.username_not_enter'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.username_not_enter'/>");
				return false;
			} else if ((username.length < 5) || (username.length > 15)) {
				/* alert("<spring:message code='user.new.username_wrong_length'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.username_wrong_length'/>");
				return false;
			} else if (illegalChars.test(username)) {
				/* alert("<spring:message code='user.new.username_illegal'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.username_illegal'/>");
				return false;
			}else{
				$("#checkAlert").addClass("d-none");
			}

			return true;
		}

		function validateEmail(mail) {
			//var reg = new RegExp('^[a-z0-9]+([_|\.|-]{1}[a-z0-9]+)*@[a-z0-9]+([_|\.|-]­{1}[a-z0-9]+)*[\.]{1}(com|ca|net|org|fr|us|qc.ca|gouv.qc.ca)$', 'i');
			var reg = new RegExp(/^[A-Za-z0-9]([A-Za-z0-9_-]|(\.[A-Za-z0-9]))+@[A-Za-z0-9](([A-Za-z0-9]|(-[A-Za-z0-9]))+)\.([A-Za-z]{2,6})(\.([A-Za-z]{2}))?$/);

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

		function checkAvailableUsername() {
			var frm = document.getElementById("frm-user-new");

			var username = frm.username.value;

			if (validateUsername(username)) {

				var params = {
					"what": "username",
					"value": username
				};

				$.ajax({
					url: "${pageContext.request.contextPath}/user/available.do",
					dataType: 'json',
					data: params,
					success: function (data) {
						if (data.status == "ok") {
							/* alert(username + "<spring:message code='user.new.is_available'/>"); */
							$("#checkAlert").addClass("d-none");
							checkedUsername = true;
							return true;
						} else {
							/* alert(username + "<spring:message code='user.new.is_not_available'/>"); */
							$("#checkAlert").removeClass("d-none");
							$("#checkAlert").html(username + "<spring:message code='user.new.is_not_available'/>");
							return false;
						}
					}
				}
				);
			}

			return false;
		}

		function checkAvailableEmail() {
			var frm = document.getElementById("frm-user-new");

			var mail = frm.email.value;

			if (validateEmail(mail)) {
				var params = {
					"what": "email",
					"value": mail
				};

				$.ajax({
					url: "${pageContext.request.contextPath}/user/available.do",
					dataType: 'json',
					data: params,
					success: function (data) {
						if (data.status == "ok") {
							/* alert(mail + "<spring:message code='user.new.is_available'/>"); */
							$("#checkAlert").addClass("d-none");
							checkedEmail = true;
							return true;
						} else {
							/* alert(mail + "<spring:message code='user.new.is_not_available'/>"); */
							$("#checkAlert").removeClass("d-none");
							$("#checkAlert").html(mail + "<spring:message code='user.new.is_not_available'/>");
							return false;
						}
					}
				}
				);
			} else {
				/* alert("<spring:message code='user.new.email_not_valid'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.email_not_valid'/>");
				checkedEmail = false;

				return false;
			}
		}

		function resetStatus(what) {
			if (what == "username") {
				checkedUsername = false;
			} else if (what == "email") {
				checkedEmail = false;
			}
		}

		function checkSubmit(frm) {

			/* if (!checkedUsername) {
				alert("<spring:message code='user.new.username_check'/>");
				return false;
			}

			if (!checkedEmail) {
				alert("<spring:message code='user.new.email_check'/>");
				return false;
			} */


			var lname = trimAll(frm.lastname.value);
			if (!validateNotEmpty(lname)) {
				/* alert("<spring:message code='user.new.enter_lastname'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.enter_lastname'/>");
				return false;
			}else{
				$("#checkAlert").addClass("d-none");
			}

			var fname = trimAll(frm.firstname.value);
			if (!validateNotEmpty(fname)) {
			/* 	alert("<spring:message code='user.new.enter_firstname'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.enter_firstname'/>");
				return false;
			}else{
				$("#checkAlert").addClass("d-none");
			}

			var pwd1 = trimAll(frm.password.value);
			var pwd2 = trimAll(frm.password1.value);

			if (!validateNotEmpty(pwd1)) {
				/* alert("<spring:message code='user.new.enter_password'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.enter_password'/>");
				return false;
			} else if (!validateNotEmpty(pwd2)) {
				/* alert("<spring:message code='user.new.enter_password1'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.enter_password1'/>");
				return false;
			} else if (pwd1 != pwd2) {
				/* alert("<spring:message code='user.new.password_not_match'/>"); */
				$("#checkAlert").removeClass("d-none");
				$("#checkAlert").html("<spring:message code='user.new.password_not_match'/>");
				return false;
			}else{
				$("#checkAlert").addClass("d-none");
			}

			/* if ($("#click_check").attr("value") == 0) {
				return false;
			};*/

			if($('input[name="register_role"]:checked').val() == 'teacher_role' && $('#school_name').val() == '') {
				$('#school_name').focus();
				return false;
			}

			$("#click_check").attr("value", 0);
			return true; 

		}

		$(function() {
			$('input[name="register_role"]').on('change', function(){
				if($(this).val() == 'teacher_role') {
					$('#school_name_group').css('display', '');
				} else {
					$('#school_name_group').css('display', 'none');
				}
			});
		});
		
		
		function inIframe () {
		    try {
		        return window.self !== window.top;
		    } catch (e) {
		        return true;
		    }
		}
		
		$(document).ready(function(){
			$("#changCap").click(function(){
				/* $.ajax({
			        url: '${pageContext.request.contextPath}/user/new.do',
			        type: 'post',
			        dataType: 'json',
			        success: function (data) {
			        	$("#mycap").attr('src','${pageContext.request.contextPath}/jcaptcha.jpg');
			        }
			    }); */
				var d = new Date();
				$("#mycap").attr('src','${pageContext.request.contextPath}/jcaptcha.jpg?'+d.getTime());
			});
			
			if(inIframe()){
		   	 	parent.$("#iframediv").height('600px');
		   		parent.$("#iframeif").height('600px');
	   	 	}
		});
	</script>

</head>

<body>
	<div class="container-fluid py-1">
		<div id="checkAlert" class="alert alert-danger d-none" role="alert">
		</div>
		<form class="w-100 mx-auto pt-3" style="max-width: 500px;" id="frm-user-new" action="${pageContext.request.contextPath}/user/new.do" method="post" onSubmit="return checkSubmit(this);">

			<input type="hidden" id="click_check" name="click_check" value="1" />
			<input type="hidden" name="confirmed" value="1" />
			<input type="hidden" name="facebook" value="" />

			<div class="text-center">
				<div class="list-group list-group-horizontal-xl list-group-style-1">
					<a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/user/login.do">
						<spring:message code='message.login' /></a>
					<a class="list-group-item list-group-item-action active" href="${pageContext.request.contextPath}/user/new.do">
						<spring:message code='message.member.new' /></a>
				</div>
			</div>

			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/key.svg" width="20px">
					</div>
				</div>
				<input required type="text" name="username" value="" onChange="resetStatus('username');" autofocus class="form-control rounded-0" onfocusout="javascript:checkAvailableUsername();" placeholder="<spring:message code='message.id'/>">
				<%-- <div class="input-group-append">
					<button class="btn btn-light rounded-0 border" type="button" onclick="javascript:checkAvailableUsername();">
						<spring:message code='user.new.check_availability' /></button>
				</div> --%>
			</div>
			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user.svg" width="20px">
							
					</div>
				</div>
				<input type="text" required class="form-control rounded-0" name="lastname" value="" placeholder="<spring:message code='common.name.last'/>">
			</div>
			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user.svg" width="20px">
					</div>
				</div>
				<input type="text" required class="form-control rounded-0" name="firstname" value="" placeholder="<spring:message code='common.name.first'/>">
			</div>
			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/mail.svg" width="20px">
					</div>
				</div>
				<input type="email" name="email" required value="" onChange="resetStatus('email');" onfocusout="javascript:checkAvailableEmail();" class="form-control rounded-0" placeholder="<spring:message code='common.email'/>">
				<%-- <div class="input-group-append">
					<button class="btn btn-light rounded-0 border" type="button" onclick="javascript:checkAvailableEmail();">
						<spring:message code='user.new.check_availability' />
					</button>
				</div> --%>
			</div>
			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="20px">
					</div>
				</div>
				<input type="password" required class="form-control rounded-0" name="password" value="" placeholder="<spring:message code='common.password'/>">
			</div>
			<div class="input-group mt-3">
				<div class="input-group-prepend">
					<div class="input-group-text rounded-0">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/unlock.svg" width="20px">
					</div>
				</div>
				<input type="password" required class="form-control rounded-0" name="password1" value="" placeholder="<spring:message code='common.password.confirm'/>">
			</div>
			<div class="mt-3 form-inline">
				<label>Are you a teacher?</label>
				<div class="custom-control custom-radio ml-2">
					<input type="radio" id="teacher_role" name="register_role" value="teacher_role" class="custom-control-input">
					<label class="custom-control-label" for="teacher_role">Yes</label>
				</div>
				<div class="custom-control custom-radio ml-2">
					<input type="radio" id="other_role" name="register_role" value="other_role" class="custom-control-input" checked>
					<label class="custom-control-label" for="other_role">No</label>
				</div>
			</div>
			<div class="mt-3" id="school_name_group" style="display: none;">
				<label>Your school name</label>
				<input type="text" class="form-control" id="school_name" name="school_name">
			</div>
			<div>
				<img src="${pageContext.request.contextPath}/jcaptcha.jpg" id="mycap" /> 
				<input type="text" name="japtcha" value="" required />
				<a href="#" class="btn btn-secondary btn-sm active" role="button" aria-pressed="true" id="changCap">Change</a>
			</div>
			

			<button class="btn btn-block btn-dark rounded-0 mt-3" type="submit">
				<spring:message code='common.confirm' />
			</button>
		</form>
	</div>
</body>
</html>