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
		<spring:message code='image.image_add' />
	</title>

	<style>
		.card {
			width: 240px;
			transition: all 200ms ease-in-out;
		}

		.card-selected,
		.card:hover {
			border-color: #ced4da;
			background-color: #ced4da;
			box-shadow: 0 0 0 0.2rem rgba(173, 181, 189, 0.25);
		}
	</style>

	<c:set var="type" value="${data.type}" />

	<c:choose>
		<c:when test="${type == 'url'}">
			<script type="text/javascript">
				function init() {
					if (imgInfo.href) {
						$('#img_url').attr('src', imgInfo.href);
						$('#jino_input_img_url').val(imgInfo.href)
					}

					$("#jino_frm_img_url").submit(function (event) {
						event.preventDefault();
						var url = $('#jino_input_img_url').val();
						getImageInfo(url, function (img) {
							if (img) {
								$('#img_url').attr('src', url);
								imgInfo.width = img.width;
								imgInfo.height = img.height;
								imgInfo.href = url;
								insertImageAction(imgInfo, false);
							} else {
								$('#jino_input_img_url').val(imgInfo.href);
							}
						});
					});
				}
			</script>
		</c:when>
		<c:when test="${type == 'fileupload'}">
			<script type="text/javascript">
				const maxUploadSize = parseInt('<c:out value="${data.maxUploadSize}"/>');
				const imageFormat = '<c:out value="${data.imageFormat}"/>';
				// const uuid = '<c:out value="${data.uuid}"/>';
				const FILEUPLOAD_API_URL = "${pageContext.request.contextPath}/media/fileupload.do";
				// const FILEKEY = "";
				// const IS_ANDROID_19 = (AppUtil.getAndVer() == '19');

				function init() {
					$('#fileupload_input').on('change', function () {
						if (this.files.length) {
							var file = this.files[0];
							if (10120000 < file.size) {
								alert("<spring:message code='file.limit' /> (<10Mb)");
							} else if (!checkFormat(file.type)) {
								alert("<spring:message code='file.image' />");
							} else {
								uploadFile(file);
							}
						}
					});
				}

				function checkFormat(obj_type) {
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

				function uploadFile(file) {
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
								var url = '${pageContext.request.contextPath}/map' + res[0].url;
								getImageInfo(url, function (img) {
									if (img) {
										$('#fileupload_img').attr('src', url);
										imgInfo.width = img.width;
										imgInfo.height = img.height;
										imgInfo.href = url;
										insertImageAction(imgInfo, false);
									}
								})
								imgInfo.href = url;
							}else{
								alert(res[0].message);
							}
							
						}
					}
					xhr.send(formData);
				}
			</script>
		</c:when>
		<c:when test="${type == 'google'}">
			<script type="text/javascript">
				var page = 0;

				String.prototype.replaceAll = function (search, replacement) {
					var target = this;
					return target.split(search).join(replacement);
				};

				function init() {
					// $(parent.document).find('#iframeDialog .modal-dialog').addClass('modal-xl');

					if (parent.jMap.getSelected()) {
						$('#searchInput').val(parent.jMap.getSelected().getText());
						fetchData(true);
					}

					$("#jino_frm_google_search").submit(function (event) {
						event.preventDefault();
						fetchData(true);
					});
				}

				function fetchData(isSearchf) {
					if ($('#searchInput').val() == '') return;
					$('#loadmore').prop('disabled', true);
					if (isSearchf) {
						page = 0;
						loadding(true);
					} else page++;

					$.ajax({
						/* type: 'GET',
						url: 'https://www.googleapis.com/customsearch/v1',
						dataType: 'json',
						data: {
							'key': 'AIzaSyA5j1VZ3hJccqvMQZ8h_nWAl5kzRMZNnUQ',
							'cx': '006697568995703237209:vljrny3h45w',
							'q': $('#searchInput').val(),
							'searchType': 'image',
							'num': 10,
							'start': page * 10 + 1
						}, */
						type: 'GET',
						url: '${pageContext.request.contextPath}/api/search/image.do',
						contentType: "application/json;charset=utf-8",
						data: {
							'q': $('#searchInput').val(),
							'page': page > 0 ? page : 0
						}, 
						success: function (data) {
							var items = data.items || [];

							if (isSearchf) {
								$('#google-search-wrap').empty();
								if (items.length) {
									$('#loadmore').removeClass('d-none');
									$('#emptymap').addClass('d-none');
								} else {
									$('#loadmore').addClass('d-none');
									$('#emptymap').removeClass('d-none');
								}
								loadding(false);
							} else {
								if (items.length == 0) $('#loadmore').addClass('d-none');
							}

							getCardHtml(items, $('#google-search-wrap'));
							$('#loadmore').prop('disabled', false);
						},
						error: function () {
							if (isSearchf) {
								$('#google-search-wrap').empty();
								$('#emptymap').removeClass('d-none');
							}
							$('#loadmore').addClass('d-none');
							$('#loadmore').prop('disabled', true);
							loadding(false);
						}
					});
				}

				function getCardHtml(items, container) {
					var cardTemplate = $('#google-card-template').html();

					for (var i = 0; i < items.length; i++) {
						var item = items[i];
						var tmp = cardTemplate;
						tmp = tmp.replaceAll("[img.link]", item.link);
						tmp = tmp.replaceAll("[img.width]", item.image.width);
						tmp = tmp.replaceAll("[img.height]", item.image.height);
						tmp = tmp.replaceAll("[img.title]", item.title);

						var card = $(tmp).appendTo(container);
						$(card).data('cardData', {
							href: item.link,
							width: item.image.width,
							height: item.image.height
						})
						$(card).on('click', function () {
							$('.card').removeClass('card-selected');
							$(this).addClass('card-selected');
							imgInfo = $(this).data('cardData') || {};
							insertImageAction(imgInfo, false);
						});
					}
				}
			</script>
		</c:when>
	</c:choose>

	<script type="text/javascript">
		var size = 50;
		var imgInfo = {};

		function setSize(s) {
			size = Math.max(50, Math.min(s, 700));
			$('#rangeValue').val(size);
			$('#range').val(size);

			var selected = parent.jMap.getSelected();
			if (!selected || selected.img == undefined) return;
			selected.imageResizeExecute(size, Math.round(size * (selected.img.attr().height / selected.img.attr().width)));
		}

		function blurModal(status) {
			if(status) {
				parent.$('#iframeDialog').addClass('modal-blur');
				$('html').addClass('modal-blur');
			} else {
				parent.$('#iframeDialog').removeClass('modal-blur');
				$('html').removeClass('modal-blur');
			}
		}

		function loadding(show) {
			if (show) {
				$('#main-container').addClass('skeleton-loading');
			} else {
				$('#main-container').removeClass('skeleton-loading');
			}
		}

		function getImageInfo(url, callback) {
			loadding(true);
			var $img = $('<img />')
				.attr('src', url)
				.on('load', function () {
					callback(this);
					loadding(false);
				})
				.on('error', function () {
					alert('Invalid URL format.');
					loadding(false);
					callback(null);
				});
		}

		function insertImageAction(img, close_dialog) {
			var selected = parent.jMap.getSelected();
			if (!selected) return;

			if (img && img.href != undefined && img.href != '') selected.setImage(img.href, size, Math.round(size * (imgInfo.height / imgInfo.width)));
			else selected.setImage();

			parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(selected);
			parent.jMap.layoutManager.layout(true);
			if(close_dialog) parent.JinoUtil.closeDialog();
		}

		$(document).ready(function () {
//			csedung note 1 rows bellow 2020.08.04
//			parent.$('.jino-app').addClass('menu-opacity-active');
			var selected = parent.jMap.getSelected();
			if (selected) {
				if (selected.img) {
					imgInfo.width = parseInt(selected.imgInfo.width);
					imgInfo.height = parseInt(selected.imgInfo.height);
					imgInfo.href = selected.imgInfo.href;

					size = imgInfo.width;
				}
			}
			setSize(size);

			init();

			$("#frm_confirm").submit(function (event) {
				event.preventDefault();
				insertImageAction(imgInfo, true);
			});
		});
	</script>
</head>

<body>
	<header>
		<nav class="navbar navbar-expand navbar-dark bg-primary py-0 position-relative" style="overflow: auto;white-space: nowrap;">
			<div class="collapse navbar-collapse justify-content-center">
				<ul class="navbar-nav">
					<li class="nav-item mx-2 ${type == 'url' ? 'active font-weight-bold':''}">
						<a class="nav-link" href="${pageContext.request.contextPath}/media/image.do?type=url">
							<spring:message code='image.tabs.url' />
						</a>
					</li>
					<li class="nav-item mx-2 ${type == 'fileupload' ? 'active font-weight-bold':''}">
						<a class="nav-link" href="${pageContext.request.contextPath}/media/image.do?type=fileupload">
							<spring:message code='image.tabs.fileupload' />
						</a>
					</li>
					<li class="nav-item mx-2 ${type == 'google' ? 'active font-weight-bold':''}">
						<a class="nav-link" href="${pageContext.request.contextPath}/media/image.do?type=google">
							<spring:message code='image.tabs.google' />
						</a>
					</li>
				</ul>
			</div>
		</nav>
	</header>
	<c:choose>
		<c:when test="${type == 'url'}">
			<div class="navbar navbar-light bg-white border-bottom">
				<form id="jino_frm_img_url" class="w-100">
					<div class="input-group">
						<input type="url" autofocus required class="form-control shadow-none border-0 bg-light" id="jino_input_img_url" name="jino_input_img_url" placeholder="<spring:message code='common.url' />">
						<div class="input-group-append">
							<button class="btn btn-light shadow-none border-0 bg-light" type="submit">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
							</button>
						</div>
					</div>
				</form>
			</div>
		</c:when>
		<c:when test="${type == 'google'}">
			<div class="navbar navbar-light bg-white border-bottom">
				<form id="jino_frm_google_search" class="w-100">
					<div class="input-group">
						<input type="text" autofocus required class="form-control shadow-none border-0 bg-light" id="searchInput" placeholder="<spring:message code='common.search' />">
						<div class="input-group-append">
							<button class="btn btn-light shadow-none border-0 bg-light" type="submit">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
							</button>
						</div>
					</div>
				</form>
			</div>
		</c:when>
	</c:choose>
	<div id="main-container" class="container-fluid py-3" style="height: 300px; overflow: auto;">
		<c:choose>
			<c:when test="${type == 'url'}">
				<div class="py-4 text-center">
					<img id="img_url" src="${pageContext.request.contextPath}/theme/dist/images/default-image.png" class="img-thumbnail" style="max-height: 200px;">
				</div>
			</c:when>
			<c:when test="${type == 'fileupload'}">
				<div class="py-4 text-center">
					<div id="fileupload" class="mx-auto fileupload-thumbnail position-relative d-inline-block">
						<img id="fileupload_img" src="${pageContext.request.contextPath}/theme/dist/images/default-image-upload.png" class="img-thumbnail" style="max-height: 200px;">
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
						<input id="fileupload_input" type="file" accept="image/png, image/jpeg" capture="camera" class="position-absolute top-0 left-0 w-100 h-100" />
					</div>
				</div>
			</c:when>
			<c:when test="${type == 'google'}">
				<div class="text-center py-5 d-none" id="emptymap">
					<img src="${pageContext.request.contextPath}/theme/dist/images/searching.svg" width="80px;">
					<h5 class="mt-3 text-muted">
						<spring:message code='common.search_noResult' />
					</h5>
				</div>
				<div id="google-search-wrap" class="d-flex flex-wrap justify-content-sm-start justify-content-center"></div>
				<div class="text-center">
					<button id="loadmore" onclick="fetchData(false)" class="btn btn-dark btn-lg btn-spinner mt-3 d-none" style="min-width: 200px;">
						<span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true" style="width: 20px; height: 20px;"></span>
						<span class="btn-lbl">
							<spring:message code='common.load_more' />
						</span>
					</button>
				</div>
			</c:when>
		</c:choose>
	</div>

	<div class="container-fluid border-top py-3 align-items-center ignore-modal-blur bg-white">
		<form name="frm_confirm" id="frm_confirm">
			<div class="form-group form-inline">
				<label class="mr-3">
					<spring:message code='common.size' />
				</label>
				<input type="number" min="50" max="700" onchange="setSize(this.value)" onfocus="blurModal(true)" onblur="blurModal(false)" class="form-control" id="rangeValue" style="width: 150px;">
			</div>
			<div class="form-group">
				<input type="range" min="50" max="700" oninput="setSize(this.value)" onfocus="blurModal(true)" onblur="blurModal(false)" class="custom-range" id="range">
			</div>
			<div class="text-center">
				<button class="btn btn-primary btn-min-w" type="submit">
					<spring:message code='button.apply' />
				</button>
				<button class="btn btn-danger btn-min-w" type="button" onclick="insertImageAction(null, true)">
					<spring:message code='button.imagedelete' />
				</button>
			</div>
		</form>
	</div>

	<template id="google-card-template">
		<div class="card m-1 text-decoration-none cursor-pointer">
			<img src="[img.link]" class="card-img-top bg-light" style="min-height: 100px;">
			<div class="card-body py-1 px-2">
				<div class="text-truncate">
					<small class="text-muted">[img.width]x[img.height] | [img.title]</small>
				</div>
			</div>
		</div>
	</template>
</body>

</html>