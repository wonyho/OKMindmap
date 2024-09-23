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

	<title>
		<spring:message code='user.edit_information' />
	</title>

	<script type="text/javascript">
		function saveAvatar(url) {
			var configs = {
				avatar: url
			};
			var params = "userid=<c:out value='${data.user.getId()}' />&";
			for (var config in configs) {
				params += 'fields=' + config + '&';
				if (configs[config] == undefined) configs[config] = '';
				params += 'data=' + configs[config] + '&';
			}
			params += 'confirmed=' + 1;

			$.ajax({
				type: 'post',
				async: false,
				url: '${pageContext.request.contextPath}/user/userconfig.do',
				data: params,
				success: function (data) {
					$('#avatar_view').attr('src', "${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.user.getId()}' />&v=" + (new Date).getTime());
				}, error: function (data, status, err) {
//					alert("userConfig : " + status);
					$('#avatar_view').attr('src', "${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.user.getId()}' />&v=" + (new Date).getTime());
				}
			});
		}

		function uploadAvatar(file) {
			$('#fileuploading').removeClass('d-none');
			var formData = new FormData();
			formData.append('confirm', 1);
			formData.append('mapid', 1);
			formData.append('file', file);

			var xhr = new XMLHttpRequest();
			xhr.open('POST', "${pageContext.request.contextPath}/media/fileupload.do");
			xhr.onerror = function (evt) {
				alert("<spring:message code='common.upload_error'/>");
				$('#fileuploading').addClass('d-none');
			};
			xhr.onreadystatechange = function () {
				if (xhr.readyState === 4 && xhr.status === 200) {
					$('#fileuploading').addClass('d-none');
					var res = JSON.parse(xhr.response);
					saveAvatar(res[0].repoid);
				}
			}
			xhr.send(formData);
		}

		function checkFormat(obj_type) {
			const imageFormat = 'jpg,jpeg,png';
			var format = imageFormat;
			var str = format.split(",");
			var type = obj_type.split("/");

			for (var i = 0; i < str.length; i++) {
				if (str[i] == type[1]) {
					return true;
				}
			}
			return false;
		}

		$(document).ready(function () {
			var tt = '<c:out value="${data.avatar.data}"/>';
			$('#avatar').on('change', function(){
				if (this.files.length) {
					var file = this.files[0];
					if (10120000 < file.size) {
						alert("<spring:message code='file.limit' /> (<10Mb)");
					} else if (!checkFormat(file.type)) {
						alert("<spring:message code='file.image' />");
					} else {
						uploadAvatar(file);
					}
				}
			});

			$("#frm-user-update").submit(function (event) {
				if ($("#password").val() === $("#password1").val()) {
					return;
				}
				alert("Error: <spring:message code='common.password.confirm' />");
				event.preventDefault();
			});
		});
	</script>
</head>

<body>
<div class="container-fluid py-1" style="max-width: 500px;">
		<c:if test="${data.user.getAuth() == 'manual'}">
			<input id="avatar" type="file" class="d-none" accept="image/*" />
			<form id="frm-user-update" action="${pageContext.request.contextPath}/user/update.do?userid=<c:out value='${data.user.getId()}' />" method="post">
				<input type="hidden" name="confirmed" value="1" />

				<div class="p-3 mb-3 text-center">
					<img id="avatar_view" src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.user.getId()}' />" style="width: 128px; height: 128px;" class="d-block mx-auto rounded-circle">
					<div id="fileuploading" class="d-none"><i>(Uploading...)</i></div>
					<label class="btn btn-sm btn-light mt-1 cursor-pointer" for="avatar">
						<spring:message code='image.image_upload' />
					</label>
				</div>

				<div class="form-group">
					<label>
						<spring:message code='message.id' />
					</label>
					<input type="text" readonly class="form-control" value='<c:out value="${data.user.getUsername()}"></c:out>'>
				</div>

				<div class="form-group">
					<label>
						<spring:message code='common.email' />
					</label>
					<input type="email" required class="form-control" name="email" value='<c:out value="${data.user.getEmail()}"></c:out>'>
				</div>

				<div class="form-group">
					<label>
						<spring:message code='common.name.last' />
					</label>
					<input type="text" required class="form-control" name="lastname" value='<c:out value="${data.user.getLastname()}"></c:out>'>
				</div>

				<div class="form-group">
					<label>
						<spring:message code='common.name.first' />
					</label>
					<input type="text" required class="form-control" name="firstname" value='<c:out value="${data.user.getFirstname()}"></c:out>'>
				</div>

				<div class="form-group">
					<label>
						<spring:message code='common.password' />
					</label>
					<input type="password" class="form-control" id="password" name="password" value="">
				</div>

				<div class="form-group">
					<label>
						<spring:message code='common.password.confirm' />
					</label>
					<input type="password" class="form-control" id="password1" name="password1" value="">
				</div>
				
				<div class="form-group">
					<label>
						Connected account:
					</label>
					<table class="table">
						<tbody>
						<c:forEach var="con" items="${data.connection}" >
							<tr>
								<td>${con.getAccountName() }</td>
								<td>${con.getValue() }</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>

				<div class="text-center mt-5">
					<button class="btn btn-primary mx-1 btn-min-w" type="submit">
						<spring:message code='button.apply' />
					</button>
					<a class="btn btn-danger mx-1 btn-min-w" href="${pageContext.request.contextPath}/user/delete.do">
						<spring:message code='user.membershipwithrawal' />
					</a>
				</div>
				
			</form>
		</c:if>

		<c:if test="${data.user.getAuth() != 'manual'}">
			<input id="avatar" type="file" class="d-none" accept="image/*" />
			<form id="frm-user-update" action="${pageContext.request.contextPath}/user/update.do?userid=<c:out value='${data.user.getId()}' />" method="post">
				<input type="hidden" name="confirmed" value="1" />

				<div class="p-3 mb-3 text-center">
					<img id="avatar_view" src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.user.getId()}' />" style="width: 128px; height: 128px;" class="d-block mx-auto rounded-circle">
					<div id="fileuploading" class="d-none"><i>(Uploading...)</i></div>
					<label class="btn btn-sm btn-light mt-1 cursor-pointer" for="avatar">
						<spring:message code='image.image_upload' />
					</label>
				</div>
			</form>

			<table class="table">
				<tbody>
					<tr>
						<td>OAuth</td>
						<td><span class="badge bg-warning text-dark rounded-pill" style="text-transform: capitalize;">${data.user.getAuth()}</span></td>
					</tr>
					<tr>
						<td><spring:message code='common.name.first' /></td>
						<td><c:out value="${data.user.getFirstname()}"></c:out></td>
					</tr>
					<tr>
						<td><spring:message code='common.name.last' /></td>
						<td><c:out value="${data.user.getLastname()}"></c:out></td>
					</tr>
          			<tr>
						<td><spring:message code='common.email' /></td>
						<td><c:out value="${data.user.getEmail()}"></c:out></td>
					</tr>
				</tbody>
			</table>
			<label>
				Connected account:
			</label>
			<table class="table">
				<tbody>
				<c:forEach var="con" items="${data.connection}" >
					<tr>
						<td>${con.getAccountName() }</td>
						<td>${con.getValue() }</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>

</html>