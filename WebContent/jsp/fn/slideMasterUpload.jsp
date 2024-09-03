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

<c:choose>
    <c:when test="${cookie['locale'].getValue() == 'en'}">
        <c:set var="locale" value="en" />
    </c:when>
    <c:when test="${cookie['locale'].getValue() == 'es'}">
		<c:set var="locale" value="es"/>
	</c:when>
    <c:when test="${cookie['locale'].getValue() == 'vi'}">
        <c:set var="locale" value="vi" />
    </c:when>
    <c:otherwise>
        <c:set var="locale" value="ko" />
    </c:otherwise>
</c:choose>

<fmt:setLocale value="${locale}" />

<!DOCTYPE html>
<html lang="${locale}">

<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

	<title></title>

	<style>
		#file_type, #file_type2 {
			top: 80px;
			left: 50%;
			padding: 5px 10px;
			background: #007bff;
		}
	</style>

	<script type="text/javascript">
		var FILEUPLOAD_API_URL = "${pageContext.request.contextPath}/user/slidemaster.do";
	
		function importMMFile() {
			$('#fileupload').addClass('onupload');
			var file = document.getElementById('fileupload_input').files[0];
			
			var formData = new FormData();
			formData.append('action', 'set');
			formData.append('file', file);
			formData.append('filetype', 'pptx');
			formData.append('format', 'json');

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
					var res = $.parseJSON(xhr.responseText);

					if(xhr.responseText != '[{"message":"Error"}]'){
						parent.JinoUtil.closeDialog();
						parent.exportToPPT();
					}else{
						alert("<spring:message code='common.upload_error_slide'/>");
						location.reload();
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
						
						$('#file_type').html('PPTX'); 
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
	<div class="container-fluid p-3 ">
		<div class="d-flex" style="min-height: 280px;">
		 	<div class="py-4 text-center" style="width: 100%;">
				<div id="fileupload" class="mx-auto fileupload-thumbnail position-relative d-inline-block">
					<img id="fileupload_img" src="${pageContext.request.contextPath}/theme/dist/images/default-file-upload.png" class="img-thumbnail" style="height: 150px;">
					<div id="file_preview" class="img-thumbnail text-center p-4 d-none position-relative" style="max-height: 200px;">
						<img src="${pageContext.request.contextPath}/theme/dist/images/file-type.png" width="80px" class="d-block mx-auto">
						<span id="file_type" class="position-absolute text-uppercase font-weight-bold text-white rounded">PPTX</span>
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
					<input id="fileupload_input" type="file" accept=".pptx" class="position-absolute top-0 left-0 w-100 h-100" />
				</div>
				<p class="font-italic">
					<spring:message code='message.import.slidemaster.default' />
				</p>
			</div>
		 </div>
		

		<form name="frm_confirm" id="frm_confirm">
			<div class="text-center">
				<button class="btn btn-primary btn-min-w" type="submit">
					<spring:message code='button.apply' />
				</button>
				<button class="btn btn-info btn-min-w" type="button" onclick="parent.JinoUtil.closeDialog(); parent.exportToPPT();">
					<spring:message code='button.cancel' />
				</button>
			</div>
		</form>
	</div>
</body>

</html>