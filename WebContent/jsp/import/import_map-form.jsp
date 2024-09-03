<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
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
		<spring:message code='message.import.freemind.upload' />
	</title>

	<style>
		#file_type {
			top: 80px;
			left: 50%;
			padding: 5px 10px;
			background: #007bff;
		}
	</style>

	<script type="text/javascript">
		var FILEUPLOAD_API_URL = "${pageContext.request.contextPath}/mindmap/importMap.do";
		var isGuest = "${user.username eq 'guest'}";

		function importMMFile() {
			$('#fileupload').addClass('onupload');
			var file = document.getElementById('fileupload_input').files[0];

			var formData = new FormData();
			formData.append('confirm', 1);
			formData.append('file', file);
			formData.append('filetype', file.type == 'application/zip' ? 'zip':'mm');
			formData.append('format', 'json');

			if(isGuest == 'true') {
				formData.append('email', $('#email').val());
				formData.append('password', $('#password').val());
			}

			var xhr = new XMLHttpRequest();
			xhr.open('POST', FILEUPLOAD_API_URL);
			xhr.onprogress = function (evt) {
				if (evt.lengthComputable) {
					var per = Math.round(evt.loaded / evt.total * 100);
					$('#fileupload_progress').css('width', per + '%');
				}
			};
			xhr.onerror = function (evt) {
				alert("<spring:message code='common.upload_error'/>");
				$('#fileupload').removeClass('onupload');
			};
			xhr.onreadystatechange = function () {
				if (xhr.readyState === 4 && xhr.status === 200) {
					$('#fileupload').removeClass('onupload');
					var res = JSON.parse(xhr.response);
					if(res.message == 'Success!') {
						parent.window.location.href = '${pageContext.request.contextPath}/map/' + res.key;
					} else {
						alert(res.message);
					}
				}
			}
			xhr.send(formData);
		}

		$(document).ready(function () {
			$('#fileupload_input').on('change', function () {
				if (this.files.length) {
					var file = this.files[0];
					if (0 == file.size) {
						alert("파일 크기가 0 byte인 파일은 추가할 수 없습니다.");
					} else {
						$('#file_name').html(file.name);
						$('#fileupload_img').addClass('d-none');
						$('#file_preview').removeClass('d-none');
						
						if(file.type == 'application/zip'){
							$('#file_type').html('ZIP');
						} else $('#file_type').html('MM');
					}
				}
			});

			$("#frm_confirm").submit(function (event) {
				event.preventDefault();
				if (document.getElementById('fileupload_input').files.length) importMMFile();
			});
		});
	</script>
</head>

<body>
	<div class="container-fluid p-3">
		<div class="py-4 text-center">
			<div id="fileupload" class="mx-auto fileupload-thumbnail position-relative d-inline-block">
				<img id="fileupload_img" src="${pageContext.request.contextPath}/theme/dist/images/default-file-upload.png" class="img-thumbnail" style="max-height: 300px;">
				<div id="file_preview" class="img-thumbnail text-center p-4 d-none position-relative" style="min-width: 300px;">
					<img src="${pageContext.request.contextPath}/theme/dist/images/file-type.png" width="80px" class="d-block mx-auto">
					<span id="file_type" class="position-absolute text-uppercase font-weight-bold text-white rounded">MM</span>
					<div id="file_name" class="py-1"></div>
				</div>
				<div class="fileupload-thumbnail-backdrop position-absolute top-0 left-0 w-100 h-100 rounded text-white d-flex align-items-center justify-content-center">
					<div>
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/upload-w.svg" width="60px">
						<h6>
							<spring:message code='common.choose_file' />
						</h6>
						<div class="progress" style="width: 200px;">
							<div id="fileupload_progress" class="progress-bar progress-bar-striped progress-bar-animated h-100" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
						</div>
					</div>
				</div>
				<input id="fileupload_input" type="file" accept=".mm" class="position-absolute top-0 left-0 w-100 h-100" />
			</div>
			<p class="font-italic">
				<spring:message code='message.import.freemind.default' />
			</p>
		</div>

		<form name="frm_confirm" id="frm_confirm">
			<c:if test="${user.username eq 'guest'}">
				<div class="form-group row">
					<label class="col-4 col-form-label">
						<spring:message code='common.email' />
					</label>
					<div class="col-8">
						<input type="email" required class="form-control" id="email" name="email">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-4 col-form-label">
						<spring:message code='common.password' />
					</label>
					<div class="col-8">
						<input type="password" required class="form-control" id="password" name="password">
					</div>
				</div>
			</c:if>

			<div class="text-center">
				<button class="btn btn-primary btn-min-w" type="submit">
					<spring:message code='button.apply' />
				</button>
			</div>
		</form>
	</div>
</body>

</html>