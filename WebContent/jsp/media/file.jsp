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
		<spring:message code='menu.fileProviderAction' />
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
		var maxUploadSize = '<c:out value="${data.maxUploadSize}"/>';
		var fileFormat = '<c:out value="${data.fileFormat}"/>';
		var uuid = '<c:out value="${data.uuid}"/>';
		var FILEUPLOAD_API_URL = "${pageContext.request.contextPath}/media/fileupload.do";
		var FILEKEY = "";
		// var IS_ANDROID_19 = (AppUtil.getAndVer() == '19');
		var fileUrl = '';
		var isImg = false;

		function uploadFile(file) {
			fileUrl = '';
			isImg = false;
			$('#fileupload').addClass('onupload');

			var formData = new FormData();
			formData.append('confirm', 1);
			formData.append('mapid', parent.jMap.cfg.mapId);
			formData.append('nodeId', parent.jMap.getSelected().id);
			formData.append('file', file);

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
					if(res[0].message == undefined){
						var imgExt = 'jpg jpeg bmp gif png'.split(' ');
						var resExt = res[0].ext;
						var resUrl = res[0].url;

						for (ext in imgExt) {
							if (imgExt[ext] == resExt) {
								isImg = true;
								break;
							}
						}

						fileUrl = '${pageContext.request.contextPath}/map' + res[0].url;
						if (isImg) {
							$('#fileupload_img').attr('src', fileUrl);
							$('#fileupload_img').removeClass('d-none');
							$('#file_preview').addClass('d-none');
						} else {
							$('#file_name').html(res[0].filename);
							$('#file_type').html(resExt);
							$('#fileupload_img').addClass('d-none');
							$('#file_preview').removeClass('d-none');
						}
					}else{
						alert(res[0].message);
					}
					
				}
			}
			xhr.send(formData);
		}

		function checkFormat(obj_name) {
			var format = fileFormat;
			var fileLen = obj_name.length;
			var lastDot = obj_name.lastIndexOf('.');
			var fileExt = obj_name.substring(lastDot + 1, fileLen).toLowerCase();
			var str = format.split(",");

			for (var i = 0; i < str.length; i++) {
				if (str[i] == fileExt) {
					return true;
				}
			}
			return false;
		}

		function fileProviderAction(fileUrl) {
			var node = parent.jMap.getSelected();
			if (!node) return;

			if (fileUrl) {
				if (isImg) {
					node.setImage(fileUrl);
				} else {
					node.setFile(fileUrl);
				}
			} else {
				node.setFile("");
			}

			parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
			parent.jMap.layoutManager.layout(true);
			parent.JinoUtil.closeDialog();
		}

		$(document).ready(function () {
			$('#fileupload_input').on('change', function () {
				if (this.files.length) {
					var file = this.files[0];
					if (0 == file.size) {
						alert("<spring:message code='file.emty' />");
					} else if (maxUploadSize < file.size) {
						alert("<spring:message code='file.limit' /> (<"+maxUploadSize/1048576+"Mb)");
					} else if (!checkFormat(file.name)) {
						alert("<spring:message code='file.type' />.\n(txt, doc, docx, xls, xlsx, ppt, pptx, hwp, pdf, zip, show, mp3, mp4, mov, jpg, jpeg, gif, png, bmp)");
					} else {
						uploadFile(file);
					}
				}
			});

			$("#frm_confirm").submit(function (event) {
				event.preventDefault();
				if (fileUrl != '') fileProviderAction(fileUrl);
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
					<span id="file_type" class="position-absolute text-uppercase font-weight-bold text-white rounded"></span>
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
				<input id="fileupload_input" type="file" accept="*/*" capture="camera" class="position-absolute top-0 left-0 w-100 h-100" />
			</div>
			<p class="font-italic text-danger">(*
				<spring:message code='file.alert' />)</p>
		</div>

		<form name="frm_confirm" id="frm_confirm">
			<div class="text-center">
				<button class="btn btn-primary btn-min-w" type="submit">
					<spring:message code='button.apply' />
				</button>
				<button class="btn btn-danger btn-min-w" type="button" onclick="fileProviderAction()">
					<spring:message code='button.imagedelete' />
				</button>
			</div>
		</form>
	</div>
</body>

</html>