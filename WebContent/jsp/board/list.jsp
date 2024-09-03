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
		<spring:message code='menu.cs.qna' />
	</title>

	<script type="text/javascript">
		var page = 1;

		String.prototype.replaceAll = function (search, replacement) {
			var target = this;
			return target.split(search).join(replacement);
		};

		function fetchData(isSearchf) {
			$('#loadmore').prop('disabled', true);
			if (isSearchf) {
				page = 1;
				loadding(true);
			} else page++;

			$.ajax({
				type: 'GET',
				url: '${pageContext.request.contextPath}/board/list.do',
				data: {
					boardType: 3,
					lang: '${locale.language}',
					searchVal: $('#searchVal').val(),
					searchKey: $('#searchKey').val(),
					page: page,
					format: 'json'
				},
				success: function (data) {
					var items = data || [];
					if (isSearchf) {
						$('#board-list').empty();
						if (items.length) {
							$('#loadmore').removeClass('d-none');
							$('#isempty').addClass('d-none');
						} else {
							$('#loadmore').addClass('d-none');
							$('#isempty').removeClass('d-none');
						}
						loadding(false);
					} else {
						if (items.length == 0) $('#loadmore').addClass('d-none');
					}

					getBoardHtml(items, $('#board-list'));
					$('#loadmore').prop('disabled', false);
				},
				error: function () {
					if (isSearchf) {
						$('#board-list').empty();
						$('#isempty').removeClass('d-none');
					}
					$('#loadmore').addClass('d-none');
					$('#loadmore').prop('disabled', true);
					loadding(false);
				}
			});
		}

		function getBoardHtml(items, container) {
			var boardTemplate = $('#board-template').html();

			for (var i = 0; i < items.length; i++) {
				var item = items[i];
				var tmp = boardTemplate;
				tmp = tmp.replaceAll("[board.link]", "${pageContext.request.contextPath}/board/view.do?boardId="+item.boardId+"&boardType=<c:out value='${data.boardType}'/>");
				tmp = tmp.replaceAll("[board.userId]", item.userId);
				tmp = tmp.replaceAll("[board.username2]", item.username2);
				tmp = tmp.replaceAll("[board.insertDate]", item.insertDate);
				tmp = tmp.replaceAll("[board.title]", item.title);
				tmp = tmp.replaceAll("[board.content]", item.content);

				var board = $(tmp).appendTo(container);
			}
		}

		function loadding(show) {
			if (show) {
				$('#main-container').addClass('skeleton-loading');
			} else {
				$('#main-container').removeClass('skeleton-loading');
			}
		}

		$(document).ready(function () {
			if ('${fn:length(data.myBoards) == 0}' == 'true') {
				$('#isempty').removeClass('d-none');
			} else {
				$('#loadmore').removeClass('d-none');
			}

			$("#searchf").submit(function (event) {
				event.preventDefault();
				fetchData(true);
			});
		});
	</script>
</head>

<body class="bg-gray-200">
	<header class="border-bottom">
		<div class="d-md-flex align-items-center py-2 px-3 bg-white">
			<div class="mr-auto">
				<a href="${pageContext.request.contextPath}/board/new.do?boardType=<c:out value='${data.boardType}'/>&lang=<c:out value='${data.lang}'/>" class="ml-0 btn btn-secondary btn-min-w">
					<spring:message code='board.list.new' />
				</a>
			</div>
			<form id="searchf">
				<input type="hidden" name="boardType" value="${data.boardType}">
				<input type="hidden" name="lang" value="${data.lang}">

				<div class="input-group my-1">
					<div class="input-group-prepend" style="max-width: 30%;">
						<select class="custom-select shadow-none btn" name="searchKey" id="searchKey">
							<option value="title" selected>
								<spring:message code='common.title' />
							</option>
						</select>
					</div>
					<input type="search" id="searchVal" name="searchVal" class="form-control shadow-none" placeholder="<spring:message code='common.search'/>" value="${data.searchVal}">
					<div class="input-group-append">
						<button class="btn btn-light shadow-none border" type="submit">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
						</button>
					</div>
				</div>
			</form>
		</div>
	</header>
	<div class="container-fluid py-3" id="main-container" style="height: 600px; overflow: auto;">
		<div id="board-list">
			<c:forEach var="board" items="${data.myBoards}">
				<a href="${pageContext.request.contextPath}/board/view.do?boardId=<c:out value='${board.boardId}'/>&boardType=<c:out value='${data.boardType}'/>" class="d-block bg-white my-1 px-2 py-1 rounded text-body text-decoration-none">
					<div class="d-flex align-items-start">
						<div class="flex-shrink-1 pt-2">
							<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${board.userId}' />" style="width: 34px; height: 34px;" class="rounded-circle">
						</div>
						<div class="flex-fill pl-3">
							<div class="d-flex align-items-start">
								<div class="mr-auto" style="max-width: 300px;">
									<div class="text-truncate">
										<small class="font-weight-bold">
											<c:out value="${board.username2}" />
										</small>
									</div>
								</div>
								<div class="text-muted text-truncate">
									<img src="${pageContext.request.contextPath}/theme/dist/images/icons/calendar.svg" width="14px">
									<small>
										<c:out value="${board.insertDate}" />
									</small>
								</div>
							</div>
							<div class="h5">
								<c:out value="${board.title}" />
							</div>
							<div>
								<c:out value="${board.content}" />
							</div>
						</div>
					</div>
				</a>
			</c:forEach>
		</div>
		<div class="text-center">
			<button id="loadmore" onclick="fetchData(false)" class="btn btn-dark btn-lg btn-spinner mt-3 d-none" style="min-width: 200px;">
				<span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true" style="width: 20px; height: 20px;"></span>
				<span class="btn-lbl">
					<spring:message code='common.load_more' />
				</span>
			</button>
		</div>
		<div class="text-center py-5 d-none" id="isempty">
			<img src="${pageContext.request.contextPath}/theme/dist/images/searching.svg" width="80px;">
			<h5 class="mt-3 text-muted">
				<spring:message code='common.search_noResult' />
			</h5>
		</div>
	</div>

	<template id="board-template">
		<a href="[board.link]" class="d-block bg-white my-1 px-2 py-1 rounded text-body text-decoration-none">
			<div class="d-flex align-items-start">
				<div class="flex-shrink-1 pt-2">
					<img src="${pageContext.request.contextPath}/user/avatar.do?userid=[board.userId]" style="width: 34px; height: 34px;" class="rounded-circle">
				</div>
				<div class="flex-fill pl-3">
					<div class="d-flex align-items-start">
						<div class="mr-auto" style="max-width: 300px;">
							<div class="text-truncate">
								<small class="font-weight-bold">
									[board.username2]
								</small>
							</div>
						</div>
						<div class="text-muted text-truncate">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/calendar.svg" width="14px">
							<small>
								[board.insertDate]
							</small>
						</div>
					</div>
					<div class="h5">
						[board.title]
					</div>
					<div>
						[board.content]
					</div>
				</div>
			</div>
		</a>
	</template>
</body>

</html>