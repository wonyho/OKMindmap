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
		<spring:message code='video.video_upload' />
	</title>

	<style>
		.media {
			transition: all 200ms ease-in-out;
		}

		.media-selected,
		.media:hover {
			border-color: #ced4da;
			background-color: #ced4da;
			box-shadow: 0 0 0 0.2rem rgba(173, 181, 189, 0.25);
		}
	</style>

	<script type="text/javascript">
		var page = 0;
		var pageToken = null;

		String.prototype.replaceAll = function (search, replacement) {
			var target = this;
			return target.split(search).join(replacement);
		};

		function init() {
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
			var searchInput = $('#searchInput').val();
			if (searchInput == '') return;

			$('#loadmore').prop('disabled', true);
			if (isSearchf) {
				pageToken = null;
				page = 0;
				loadding(true);
			} else page++;
//			'key': 'AIzaSyCqhNd5-z2hAqEK1hSozv32AkFV88_TFjs'
			$.ajax({
				type: 'GET',
				url: 'https://www.googleapis.com/youtube/v3/search',
				dataType: 'json',
				data: {
					'key': 'AIzaSyBBlzzuTQWuTy5FSKpSB5Ax8Q4IEKT3fKo',
//					'key': 'AIzaSyB_47y8v4_0zwC075Y4zI0oeA9BvHTgT_I',
					'cx': '006697568995703237209:vljrny3h45w',
					'q': searchInput,
					'type': 'video',
					'part': 'snippet',
					'safeSearch': 'strict',
					'maxResults': 25,
					'pageToken': pageToken
				},
				success: function (data) {
					pageToken = data.nextPageToken;
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
				tmp = tmp.replaceAll("[video.thumb]", item.snippet.thumbnails.default.url);
				tmp = tmp.replaceAll("[video.title]", item.snippet.title);
				tmp = tmp.replaceAll("[video.channel]", item.snippet.channelTitle);
				tmp = tmp.replaceAll("[video.desc]", item.snippet.description);

				var card = $(tmp).appendTo(container);
				$(card).data('cardData', {
					playUrl: "https://www.youtube.com/watch?v=" + item.id.videoId,
					width: item.snippet.thumbnails.high.width,
					height: item.snippet.thumbnails.high.height
				})
				$(card).on('click', function () {
					$('.media').removeClass('media-selected');
					$(this).addClass('media-selected');
					videoInfo = $(this).data('cardData') || {};
					videoProviderAction(videoInfo, false);
				});
			}
		}
	</script>

	<script type="text/javascript">
		var size = 200;
		var videoInfo = {};

		function setSize(s) {
			size = Math.max(50, Math.min(s, 700));
			$('#rangeValue').val(size);
			$('#range').val(size);

			var selected = parent.jMap.getSelected();
			if (!selected) return;
			selected.foreignObjectResizeExecute(size, size);
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

		function videoProviderAction(videoInfo, close_dialog) {
			var selected = parent.jMap.getSelected();
			if (!selected) return;

			if (videoInfo && videoInfo.playUrl != undefined && videoInfo.playUrl != '') selected.setYoutubeVideo(videoInfo.playUrl, size, Math.round(size * (videoInfo.height / videoInfo.width)));
			else {
				selected.setForeignObject("");
				selected.setHyperlink("");
			}

			parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(selected);
			parent.jMap.layoutManager.layout(true);
			if(close_dialog) parent.JinoUtil.closeDialog();
		}

		$(document).ready(function () {
//			csedung note 1 rows bellow 2020.08.04
//			parent.$('.jino-app').addClass('menu-opacity-active');
			var selected = parent.jMap.getSelected();
			if (selected && selected.foreignObjEl != undefined) {
				var videoEmbedTag = null;
				
				switch (parent.jMap.layoutManager.type) {
					case 'jCardLayout':
						videoEmbedTag = selected.foreignObjEl.iframeEl[0].getElementsByTagName("iframe")[0];
						break;
				
					default:
						videoEmbedTag = selected.foreignObjEl.getElementsByTagName("iframe")[0];
						break;
				}
				
				size = parseInt(videoEmbedTag.getAttribute("width"));
				videoInfo = {
					width: parseInt(videoEmbedTag.getAttribute("width")),
					height: parseInt(videoEmbedTag.getAttribute("height"))
				}
				var url = videoEmbedTag.getAttribute("src").split('www.youtube.com/embed/');
				if(url.length == 2) videoInfo.playUrl = "https://www.youtube.com/watch?v=" + url[1];
			}
			setSize(size);

			init();

			$("#frm_confirm").submit(function (event) {
				event.preventDefault();
				videoProviderAction(videoInfo, true);
			});
		});
	</script>
</head>

<body>
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
	<div id="main-container" class="container-fluid py-3" style="height: 300px; overflow: auto;">
		<div class="text-center py-5 d-none" id="emptymap">
			<img src="${pageContext.request.contextPath}/theme/dist/images/searching.svg" width="80px;">
			<h5 class="mt-3 text-muted">
				<spring:message code='common.search_noResult' />
			</h5>
		</div>
		<div id="google-search-wrap"></div>
		<div class="text-center">
			<button id="loadmore" onclick="fetchData(false)" class="btn btn-dark btn-lg btn-spinner mt-3 d-none" style="min-width: 200px;">
				<span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true" style="width: 20px; height: 20px;"></span>
				<span class="btn-lbl">
					<spring:message code='common.load_more' />
				</span>
			</button>
		</div>
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
				<button class="btn btn-danger btn-min-w" type="button" onclick="videoProviderAction(null, true)">
					<spring:message code='button.imagedelete' />
				</button>
			</div>
		</form>
	</div>

	<template id="google-card-template">
		<div class="m-1 p-2 text-decoration-none cursor-pointer media rounded-sm">
			<img src="[video.thumb]" class="align-self-start mr-3 bg-light rounded-sm">
			<div class="media-body overflow-auto">
				<div class="text-truncate text-truncate-2">[video.title]</div>
				<div class="text-truncate">
					<small class="text-muted font-italic">[video.channel]</small>
				</div>
				<div class="text-truncate">
					<small class="text-muted">[video.desc]</small>
				</div>
			</div>
		</div>
	</template>
</body>

</html>