<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ page import="com.okmindmap.util.PagingHelper"%>
<%@ page import="java.util.HashMap"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	String viewMode = "list".equals(request.getParameter("viewMode")) ? "list":"grid";
	request.setAttribute("viewMode", viewMode);

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
		<spring:message code='message.openmap' />
	</title>

	<style>
		.map-card {
			width: 180px;
			font-size: .9rem;
			line-height: 1.2rem;
			margin: 6px;
			cursor: pointer;
		}
		
		.none-select {
		  -webkit-user-select: none; /* Safari */
		  -ms-user-select: none; /* IE 10+ and Edge */
		  user-select: none; /* Standard syntax */
		}

		@media (max-width: 575.98px) {
			.map-card {
				width: 100%;
			}
		}
	</style>

	<c:set var="isLocale_ko" value="${locale.language eq 'ko'}" />

	<script type="text/javascript">
		const isLocale_ko = '${isLocale_ko}';
		var page = 1;
		var pages = parseInt('${data.pages}');
		var viewMode = '${viewMode}';
		var sort = 'created';
		var sortAsc = false;

		function paginate_init(totalMaps, pagelimit, plPageRange, page, pages){
			// paginate init
			// <spring:message code="common.paginate" arguments="${data.page};${data.pagelimit};${data.totalMaps}" htmlEscape="false" argumentSeparator=";" />
			var paginateText = '<spring:message code="common.paginate" />';
			var paginateHtml = '';
			
			var from = ((page -1) * pagelimit) + 1;
			var to = Math.min(page  * pagelimit, totalMaps);
			paginateText = paginateText.replace('{0}', from);
			paginateText = paginateText.replace('{1}', to);
			paginateText = paginateText.replace('{2}', totalMaps);
			$('.paginate-text').html(totalMaps ? paginateText:'');
			
			var offset = Math.floor(plPageRange / 2);
			var start = Math.max(page - offset, 1);
			var end = Math.min(Math.min(page + offset, pages) + Math.max(offset - (page - start), 0), pages);
			start = Math.max(start - Math.max(offset - (end - page), 0), 1);
			if(page > 1) paginateHtml += '<li class="page-item"><a class="page-link" href="#" onclick="fetchData(1);"><span aria-hidden="true">&laquo;</span></a></li>';
			for (var i = start; i <= end; i++) {
				paginateHtml += '<li class="page-item '+(i == page ? 'active':'')+'"><a class="page-link" href="#" onclick="fetchData('+i+');">'+i+'</a></li>';
			}
			if(page < pages) paginateHtml += '<li class="page-item"><a class="page-link" href="#" onclick="fetchData('+pages+');"><span aria-hidden="true">&raquo;</span></a></li>';
			$('.paginate-html').html(paginateHtml);
		}

		function list_init() {
			// 시간포멧 변경
			var created = $('.created');
			for (var i = 0; i < created.length; i++) {
				var c = created[i];
				if (c.innerHTML != '') {
					var date = new Date(parseInt(c.innerHTML));
					var format = "";
					if (isLocale_ko == 'true') {
						format = date.format("yyyy-MM-dd");//date.getFullYear() + "-" + (date.getMonth() + 1).zf(2) + "-" + date.getDate().zf(2);
					} else {
						format = date.format("dd-MM-yyyy");//date.getDate().zf(2) + "-" + (date.getMonth() + 1).zf(2) + "-" + date.getFullYear();
					}

					c.innerHTML = format;
				}
				$(c).removeClass('created');
			}
		}

		Date.prototype.format = function (f) {
			if (!this.valueOf()) return " ";

			var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
			var d = this;

			return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
				switch ($1) {
					case "yyyy": return d.getFullYear();
					case "yy": return (d.getFullYear() % 1000).zf(2);
					case "MM": return (d.getMonth() + 1).zf(2);
					case "dd": return d.getDate().zf(2);
					case "E": return weekName[d.getDay()];
					case "HH": return d.getHours().zf(2);
					case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
					case "mm": return d.getMinutes().zf(2);
					case "ss": return d.getSeconds().zf(2);
					case "a/p": return d.getHours() < 12 ? "오전" : "오후";
					default: return $1;
				}
			});
		};

		String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
		String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
		Number.prototype.zf = function (len) { return this.toString().zf(len); };

		String.prototype.replaceAll = function (search, replacement) {
			var target = this;
			return target.split(search).join(replacement);
		};

		function sortPage(csort, el) {
			var isAsc = !$(el).hasClass('isAsc');
			$('.sortable').removeClass('sort');
			$('.sortable').removeClass('isAsc');
			
			$(el).addClass('sort');
			if(isAsc) $(el).addClass('isAsc');
			
			sort = csort;
			sortAsc = isAsc;
			fetchData(page);
		}

		var fetchData = function (p) {
			page = p;
			var params = { page: page, sort: sort, isAsc: sortAsc, pagelimit: 25 };

			/* if ($("#search").val() != '') {
				params['searchfield'] = $('#searchfield').val();
				params['search'] = $('#search').val();
			} */

			var url = "${pageContext.request.contextPath}/mindmap/list.do?maptype=${data.mapType}${data.mapType == 'public' ? '&sharetype=1':''}&dataType=json&" + $.param(params);

			/* $.ajax({
				url: url,
				contentType: 'application/json; charset=utf-8',
				dataType: "json"
			}).done(function (data) {
				var res = data[0];
				var html = getCardHtml(res);
				newmapHtml = `<div class="card map-card m-2 align-items-center cursor-pointer d-flex justify-content-center" onclick="parent.newMap()" style="min-height: 242px;">
											<div>
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/plus.svg" width="80px;" class="d-block mx-auto mb-4">
												<spring:message code='menu.rollover.mindmap.new' />
											</div>
										</div>`;
				if(res.totalMaps && $('#map-card-wrap').hasClass('gridView')) {
					$('#map-card-wrap').html(newmapHtml + html);
				} else $('#map-card-wrap').html(html);

				if (html == '') {
					$('#emptymap').removeClass('d-none');
				} else {
					$('#emptymap').addClass('d-none');
				}
				list_init();
				paginate_init(res.totalMaps, res.pagelimit, res.plPageRange, res.page, res.pages);
			}); */
			$("#searchWaiting").removeClass("d-none");
			$.ajax({
			      type: 'post',
			      url: url,
			      data: $('#searchf').serialize(),
			      enctype: 'multipart/form-data',
			      success: function (data) {
						var res = data[0];
						var html = getCardHtml(res);
						
						if(res.totalMaps && $('#map-card-wrap1').hasClass('gridView')) {
							$('#map-card-wrap1').html(html);
						} else $('#map-card-wrap1').html(html);
						
						if (html == '') {
							$('#emptymap').removeClass('d-none');
							$('#map-card-wrap2').removeClass('d-none');
							$("#mapsTitle").removeClass('d-none');
							$("#recentTitle").removeClass('d-none');
							$('#map-card-wrap2').addClass('d-flex');
						} else {
							$('#emptymap').addClass('d-none');
							$('#map-card-wrap2').addClass('d-none');
							$("#mapsTitle").addClass('d-none');
							$("#recentTitle").addClass('d-none');
							$('#map-card-wrap2').removeClass('d-flex');
						}
						list_init();
						paginate_init(res.totalMaps, res.pagelimit, res.plPageRange, res.page, res.pages);	
						$("#searchWaiting").addClass("d-none");
						defaultFunction();
			      }
			    });
		}

		var getCardHtml = function (data) {
			var cardTemplate = $('#card-template').html();
			var cardLockTemplate = $('#card-template-lock').html();
			var cardOwnerTemplate = $('#card-template-owner').html();

			var cardShareGroupTemplate = $('#card-template-share-group').html();

			var html = '';
			for (var i = 0; i < data.maps.length; i++) {
				var map = data.maps[i];
				if (data.mapType == 'myshares') {
					map = data.maps[i].map;
				}
				var card = cardTemplate;
				card = card.replaceAll("[map.key]", map.key);
				if (data.mapType == 'public' && map.sharetype != 1) {
					card = card.replaceAll('<span class="tmp-lock"></span>', cardLockTemplate);
				}
				card = card.replaceAll("[map.name]", map.name);
				if (data.mapType != 'user') {
					var owner = cardOwnerTemplate;
					var u = map.owner;
					if (data.mapType == 'myshares') {
						u = map.user;
					}
					owner = owner.replaceAll("[map.owner]", u.lastname + ' ' + u.firstname);
					card = card.replaceAll('<div class="tmp-owner"></div>', owner);
					
				}
				card = card.replaceAll("[map.created]", map.created || '');
				card = card.replaceAll("[map.viewcount]", map.viewcount || '0');
				console.log( "id = " + map.id);
				card = card.replaceAll('type="checkbox"', 'value="'+map.id+'" type="checkbox"');

				if (data.mapType == 'myshares') {
					var group = cardShareGroupTemplate;

					var permissions = '';
					for (var index = 0; index < data.maps[i].permissions.length; index++) {
						var permission = data.maps[i].permissions[index];
						if (permission.permited) {
							permissions += '<span class="badge badge-pill badge-gray-200 p-2 d-inline-block mr-1">' + permission.permissionType.name + '</span>';
						}

					}

					card = card.replaceAll('<span class="tmp-share-permissions"></span>', '<div>' + permissions + '</div>');

					group = group.replaceAll("[share.group]", data.maps[i].group.name);
					card = card.replaceAll('<span class="tmp-share-group"></span>', group); 
				}

				html += card;
			}
			return html;
		};
		
		var defaultFunction = function(){
			$(".delMapId").click(function(){
				var hasCheck = false;
				$(".delMapId").each(function() {
					if($(this).prop('checked')){
						hasCheck = true;
					}
				});

				if(hasCheck) $("#delChosenMap").removeClass("d-none");
				else $("#delChosenMap").addClass("d-none");
			});

			$(window).resize(changeCardSize);
		}
		
		var changeCardSize = function() {
			var dom = $("#map-card-wrap1").width()%180;
			var vid = $("#map-card-wrap1").width()/180;
			var width = 180 + (dom - vid * 12) / vid;
			$(".map-card").css("width",width  + "px");
		}
		
		$(document).ready(function () {
			$("#searchf").submit(function (event) {
				event.preventDefault();
				fetchData(1);
			});

			list_init();
			paginate_init(parseInt('${data.totalMaps}'), parseInt('${data.pagelimit}'), parseInt('${data.plPageRange}'), parseInt('${data.page}'), parseInt('${data.pages}'));
			
			$("#delChosenMap").click(function(){
				var confirmed = confirm("<spring:message code='message.delete.confirm'/>");
				if (confirmed) {
					$("#searchWaiting").removeClass("d-none");
					var params = "";
					$(".delMapId").each(function() {
						if($(this).prop('checked')){
							params += "del_map=" + $(this).val() + "&";
						}
					});
					$.ajax({
						type: 'post',
						async: false,
						url: parent.jMap.cfg.contextPath + '/mindmap/delete.do',
						data: params,
						success: function (data) {
							/* parent.openMap()(); */
							window.location.href  = "${pageContext.request.contextPath}/mindmap/list.do?maptype=${data.mapType}${data.mapType == 'public' ? '&sharetype=1':''}&viewMode=${viewMode}";
					
						}, error: function (data, status, err) {
							alert(status);
						}
					});
				}
			});
			
			defaultFunction();
			changeCardSize();
		});
		
		
	</script>

	<style>
		.myshares .map-created {
			display: none !important;
		}
		.sortable.sort::after {
			content: "↓";
			display: inline-block;
			color: #979b9e;
		}
		.sortable.sort.isAsc::after {
			content: "↑";
		}
		.table-hover tbody tr:hover {
			color: #212529 !important;'1054 994'
			background-color: rgba(0, 0, 0, 0.02) !important;
		}
	</style>
</head>

<body style="min-height: 1000px;">
	<header id="header" class="border-bottom">
		<nav class="navbar navbar-expand navbar-dark bg-primary py-0 position-relative" style="overflow: auto;white-space: nowrap;">
			<div class="collapse navbar-collapse justify-content-center">
				<ul class="navbar-nav">
					<c:if test="${data.user.username ne 'guest'}">
						<li class="nav-item mx-2 ${data.mapType == 'user' ? 'active font-weight-bold':''}">
							<a class="nav-link" href="${pageContext.request.contextPath}/mindmap/list.do?maptype=user">
								<spring:message code='message.openmap.usermaps' />
							</a>
						</li>
						<li class="nav-item mx-2 ${data.mapType == 'myshares' ? 'active font-weight-bold':''}">
							<a class="nav-link" href="${pageContext.request.contextPath}/mindmap/list.do?maptype=myshares">
								<spring:message code='message.groupmaps' />
							</a>
						</li>
					</c:if>
					<li class="nav-item mx-2 ${data.mapType == 'public' ? 'active font-weight-bold':''}">
						<a class="nav-link" href="${pageContext.request.contextPath}/mindmap/list.do?maptype=public&sharetype=1">
							<spring:message code='message.openmap.publicmaps' />
						</a>
					</li>
				</ul>
			</div>
		</nav>
		<div class="d-md-flex align-items-center py-2 px-3 bg-white">
			<div class="mr-auto d-flex justify-content-start">
				<c:if test="${data.mapType eq 'user'}">
					<button class="btn btn-secondary btn-min-w ml-1" type="button" onclick="parent.newMap()">
						<spring:message code='menu.mindmap.new' />
					</button>
					<form id="mapofmap" action="${pageContext.request.contextPath}/mindmap/mapofmap.do" method="post" target="_parent">
						<button class="btn btn-secondary btn-min-w ml-0" type="submit">
							<spring:message code='common.mapofmap' />
						</button>
					</form>
					<button class="btn btn-secondary btn-min-w ml-1  d-none" type="button" id="delChosenMap">
						<spring:message code='menu.mindmap.delete' />
					</button>
				</c:if>
			</div>
			<div class="py-2 mr-3 d-none d-md-block">
				<span class="paginate-text"></span>
			</div>
			<div class="spinner-border text-success d-none mr-2" id="searchWaiting" role="status">
			  <span class="sr-only">Searching...</span>
			</div>
			<form method=post name="searchf" id="searchf">
				<div class="input-group my-1">
					<div class="input-group-prepend" style="max-width: 30%;">
						<select class="custom-select shadow-none btn" id="searchfield" name="searchfield">
							<option value="title" selected>
								<spring:message code='common.title' />
							</option>
							<option value="content">
								<spring:message code='common.content' />
							</option>
							<c:if test="${data.mapType == 'public'}">
								<option value="usernamestring">
									<spring:message code='common.name' />
								</option>
							</c:if>
						</select>
					</div>
					
					<input type="search" id="search" name="search" class="form-control shadow-none" placeholder="<spring:message code='common.search'/>">
					<div class="input-group-append">
						<button class="btn btn-light shadow-none border" type="submit">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px" class="align-text-top">
						</button>
					</div>
				</div>
			</form>
			<div class="d-flex d-md-block justify-content-between">
				<div class="py-2 mr-3 d-md-none">
					<span class="paginate-text"></span>
				</div>
				<div class="btn-group ml-3" role="group">
					<a href="${pageContext.request.contextPath}/mindmap/list.do?maptype=${data.mapType}${data.mapType == 'public' ? '&sharetype=1':''}&viewMode=grid" class="btn btn-light shadow-none border ${viewMode == 'grid' ? 'active':''}">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/grid.svg" width="20px" class="align-text-top">
					</a>
					<a href="${pageContext.request.contextPath}/mindmap/list.do?maptype=${data.mapType}${data.mapType == 'public' ? '&sharetype=1':''}&viewMode=list" class="btn btn-light shadow-none border ${viewMode == 'list' ? 'active':''}">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/list.svg" width="20px" class="align-text-top">
					</a>
				</div>
			</div>
		</div>
	</header>

	<c:choose>
		<c:when test="${viewMode == 'grid'}">
			<div class="container-fluid py-3">
				<div class="text-center py-5 d-none" id="emptymap">
					<img src="${pageContext.request.contextPath}/theme/dist/images/map-type-logo-gray.png" width="80px;">
					<h5 class="mt-3 text-muted">
						<spring:message code='message.page.list.emptymap' />
					</h5>
				</div>
				<h5 class="${fn:length(data.rmaps) < 1 ? 'd-none':''}" id="recentTitle"><spring:message code='common.recentMaps'/></h5>
				<div class="d-flex flex-wrap justify-content-sm-start justify-content-center ${data.mapType} gridView" id="map-card-wrap1">
					<c:forEach var="map" items="${data.rmaps}">
						  <div class="card map-card text-decoration-none none-select">
							<c:if test="${data.mapType eq 'public' && map.sharetype ne '1'}">
								<span class="badge badge-warning position-absolute p-2 rounded-circle" style="top: -8px; right: -8px;">
									<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="14px">
								</span>
							</c:if>
							<input type="checkbox" class="delMapId ${data.mapType == 'user' ? '':'d-none'}" value="${data.mapType == 'user' ? map.id:''}" style="position: absolute;width: 20px; height: 20px;margin: 2px;">
							<img src="${pageContext.request.contextPath}/thumb/<c:out value='${map.key}'/>" class="card-img-top">
							<div class="card-body p-2">
								<a target="_parent" href="${pageContext.request.contextPath}/map/<c:out value='${map.key}'/>" class="card-text text-break text-dark text-truncate text-truncate-2">
									<c:out value="${map.name}" />
								</a>
								<c:if test="${data.mapType ne 'user'}">
									<div class="text-truncate">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user.svg" width="14px">
										<small class="text-muted">
											<c:out value="${map.owner.lastname} ${map.owner.firstname}" />
										</small>
									</div>
								</c:if>
								<div class="d-flex justify-content-between map-created">
									<div class="text-truncate">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/calendar.svg" width="14px">
										<small class="text-muted created">
											<c:out value="${map.created}" />
										</small>
									</div>
									<div class="text-truncate">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/eye.svg" width="14px">
										<small class="text-muted">
											<c:out value="${map.viewcount}" />
										</small>
									</div>
								</div>
							</div>
						</div>				
					</c:forEach>
				</div>
				<h5 class="${fn:length(data.maps) < 1 ? 'd-none':''}" id="mapsTitle"><spring:message code='common.listMaps' /></h5>
				<div class="d-flex flex-wrap justify-content-sm-start justify-content-center ${data.mapType} gridView" id="map-card-wrap2">
					<%-- <div class="card map-card m-2 align-items-center cursor-pointer d-flex justify-content-center" onclick="parent.newMap()" style="min-height: 242px;">
						<div>
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/plus.svg" width="80px;" class="d-block mx-auto mb-4">
							<spring:message code='menu.rollover.mindmap.new' />
						</div>
					</div> --%>
					<c:choose>
						<c:when test="${data.mapType == 'myshares'}">
							<c:forEach var="share" items="${data.maps}" end="${data.startnum}" step="1" varStatus="loop">
								<div class="card map-card text-decoration-none none-select" >
									<c:if test="${share.shareType.shortName == 'password'}">
										<span class="badge badge-warning position-absolute p-2 rounded-circle" style="top: -8px; right: -8px;">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="14px">
										</span>
									</c:if>
									
									<img src="${pageContext.request.contextPath}/thumb/<c:out value='${share.map.key}'/>" class="card-img-top">
									<div class="card-body p-2">
										<a target="_parent" href="${pageContext.request.contextPath}/map/<c:out value='${share.map.key}'/>?sid=<c:out value='${share.id}'/>" class="card-text text-break text-dark text-truncate text-truncate-2">
											<c:out value="${share.map.name}" />
										</a>
										<div>
											<c:forEach var="permission" items="${share.permissions}">
												<c:if test="${permission.permited}">
													<span class="badge badge-pill badge-gray-200 p-2 d-inline-block mr-1">
														<c:out value="${permission.permissionType.name}" />
													</span>
												</c:if>
											</c:forEach>
										</div>
										<div class="text-truncate">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/users.svg" width="14px">
											<small class="text-muted">
												<c:out value="${share.group.name}" />
											</small>
										</div>
										<div class="text-truncate">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user.svg" width="14px">
											<small class="text-muted">
												<c:out value="${share.map.user.lastname} ${share.map.user.firstname}" />
											</small>
										</div>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<c:forEach var="map" items="${data.maps}" end="${data.startnum}" step="1" varStatus="loop">
								<!-- <div> -->
								  
								  <div  class="card map-card text-decoration-none none-select" >
									<c:if test="${data.mapType eq 'public' && map.sharetype ne '1'}">
										<span class="badge badge-warning position-absolute p-2 rounded-circle" style="top: -8px; right: -8px;">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="14px">
										</span>
									</c:if>
									<input type="checkbox" class="delMapId ${data.mapType == 'user' ? '':'d-none'}" value="${data.mapType == 'user' ? map.id:''}" style="position: absolute;width: 20px; height: 20px;margin: 2px;">
									<img src="${pageContext.request.contextPath}/thumb/<c:out value='${map.key}'/>" class="card-img-top">
									<div class="card-body p-2">
										<a target="_parent" href="${pageContext.request.contextPath}/map/<c:out value='${map.key}'/>" class="card-text text-break text-dark text-truncate text-truncate-2">
											<c:out value="${map.name}" />
										</a>
										<c:if test="${data.mapType ne 'user'}">
											<div class="text-truncate">
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user.svg" width="14px">
												<small class="text-muted">
													<c:out value="${map.owner.lastname} ${map.owner.firstname}" />
												</small>
											</div>
										</c:if>
										<div class="d-flex justify-content-between map-created">
											<div class="text-truncate">
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/calendar.svg" width="14px">
												<small class="text-muted created">
													<c:out value="${map.created}" />
												</small>
											</div>
											<div class="text-truncate">
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/eye.svg" width="14px">
												<small class="text-muted">
													<c:out value="${map.viewcount}" />
												</small>
											</div>
										</div>
									</div>
								</div>
								<!-- </div> -->
								
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

				<div style="overflow: auto;text-align: center;">
					<nav aria-label="navigation" class="d-inline-block">
						<ul class="pagination paginate-html"></ul>
					</nav>
				</div>
			</div>

			<template id="card-template">
				<div  class="card map-card m-2 text-decoration-none none-select" >
					<span class="tmp-lock"></span>
					<input class="delMapId ${data.mapType == 'user' ? '':'d-none'}" type="checkbox"  style="position: absolute;width: 20px; height: 20px;margin: 2px;">
					<img src="${pageContext.request.contextPath}/thumb/[map.key]" class="card-img-top">
					<div class="card-body p-2">
						<a target="_parent" href="${pageContext.request.contextPath}/map/[map.key]" class="card-text text-break text-dark text-truncate text-truncate-2">[map.name]</a>
						<span class="tmp-share-permissions"></span>
						<span class="tmp-share-group"></span>
						<div class="tmp-owner"></div>
						<div class="d-flex justify-content-between map-created">
							<div class="text-truncate">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/calendar.svg" width="14px">
								<small class="text-muted created">[map.created]</small>
							</div>
							<div class="text-truncate">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/eye.svg" width="14px">
								<small class="text-muted">[map.viewcount]</small>
							</div>
						</div>
					</div>
				</div>
			</template>
			<template id="card-template-lock">
				<span class="badge badge-warning position-absolute p-2 rounded-circle" style="top: -8px; right: -8px;">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="14px">
				</span>
			</template>
			<template id="card-template-owner">
				<div class="text-truncate">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user.svg" width="14px">
					<small class="text-muted">[map.owner]</small>
				</div>
			</template>

			<template id="card-template-share-group">
				<div class="text-truncate">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/users.svg" width="14px">
					<small class="text-muted">[share.group]</small>
				</div>
			</template>
		</c:when>
		<c:otherwise>
			<div class="container-fluid py-3">
				<div class="table-responsive">
					<c:choose>
						<c:when test="${data.mapType == 'myshares'}">
							<table class="table table-hover">
								<thead>
									<tr>
										<th rowspan="2" scope="col" class="border-top-0">
											<spring:message code='common.title' />
										</th>
										<th colspan="2" scope="col" class="border-top-0 text-center">
											<spring:message code='common.share' />
										</th>
										<th rowspan="2" scope="col" class="border-top-0">
											<spring:message code='common.owner' />
										</th>
									</tr>
									<tr>
										<th scope="col" class="border-top-0">
											<spring:message code='message.share.permission' />
										</th>
										<th scope="col" class="border-top-0">
											<spring:message code='message.share.group' />
										</th>
									</tr>
								</thead>
								<tbody id="map-card-wrap1">
									<c:forEach var="share" items="${data.maps}" end="${data.startnum}" step="1" varStatus="loop">
										<tr>
											<td>
												<div class="text-truncate" style="width: 300px;">
													<a target="_parent" class="text-body text-decoration-none" href="${pageContext.request.contextPath}/map/<c:out value='${share.map.key}'/>?sid=<c:out value='${share.id}'/>">
														<c:out value="${share.map.name}" />
													</a>
													<c:if test="${share.shareType.shortName == 'password'}">
														<span class="badge badge-warning rounded-circle position-relative" style="top: -3px;">
															<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="12px">
														</span>
													</c:if>
												</div>
											</td>
											<td class="py-2">
												<c:forEach var="permission" items="${share.permissions}">
													<c:if test="${permission.permited}">
														<span class="badge badge-pill badge-gray-200 py-2 px-3  d-inline-block mr-1">
															<c:out value="${permission.permissionType.name}" />
														</span>
													</c:if>
												</c:forEach>
											</td>
											<td>
												<div class="text-truncate" style="width: 300px;">
													<c:out value="${share.group.name}" />
												</div>
											</td>
											<td>
												<div class="text-truncate" style="width: 300px;">
													<c:out value="${share.map.user.lastname} ${share.map.user.firstname}" />
												</div>
											</td>
										</tr>
									</c:forEach>
								</tbody>
								<tbody class="${fn:length(data.maps) > 0 ? 'd-none':''}" id="emptymap">
									<tr>
										<td colspan="4" class="text-center text-muted">
											<spring:message code='message.page.list.emptymap' />
										</td>
									</tr>
								</tbody>
							</table>
						</c:when>
						<c:otherwise>
								<h5 class="${fn:length(data.rmaps) < 1 ? 'd-none':''}" id="recentTitle"><spring:message code='common.recentMaps'/></h5>
								<table class="table table-hover">
									<thead>
										<tr>
											<th scope="col" class="border-top-0">
												<span><spring:message code='common.title' /></span>
											</th>
											<c:if test="${data.mapType ne 'user'}">
												<th scope="col" class="border-top-0">
													<span><spring:message code='common.owner' /></span>
												</th>
											</c:if>
											<th scope="col" class="border-top-0">
												<span ><spring:message code='common.viewcount.shortname' /></span>
											</th>
											<th scope="col" class="border-top-0">
												<span><spring:message code='common.createdate' /></span>
											</th>
											<th>#</th>
										</tr>
									</thead>
									<tbody id="map-card-wrap1">
										<c:forEach var="map" items="${data.rmaps}">
											<tr>
												<td>
													<div class="text-truncate" style="width: 400px;">
														<a target="_parent" href="${pageContext.request.contextPath}/map/<c:out value='${map.key}'/>" class="text-body text-decoration-none" style="cursor: pointer;">
															<c:out value="${map.name}" />
														</a>
														<c:if test="${data.mapType eq 'public' && map.sharetype ne '1'}">
															<span class="badge badge-warning rounded-circle position-relative" style="top: -3px;">
																<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="12px">
															</span>
														</c:if>
													</div>
												</td>
												<c:if test="${data.mapType ne 'user'}">
													<td>
														<div class="text-truncate" style="width: 300px;">
															<c:out value="${map.owner.lastname} ${map.owner.firstname}" />
														</div>
													</td>
												</c:if>
												<td>
													<div class="text-truncate" style="width: 100px;">
														<c:out value="${map.viewcount}" />
													</div>
												</td>
												<td>
													<div class="text-truncate" style="width: 100px;">
														<span class="created">
															<c:out value="${map.created}" />
														</span>
													</div>
												</td>
												<td><input type="checkbox" class="delMapId ${data.mapType == 'user' ? '':'d-none'}" value="${data.mapType == 'user' ? map.id:''}"></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								<h5 class="${fn:length(data.maps) < 1 ? 'd-none':''}" id="mapsTitle"><spring:message code='common.listMaps'/></h5>
								<table class="table table-hover" id="map-card-wrap2">
								<thead>
									<tr>
										<th scope="col" class="border-top-0">
											<span class="cursor-pointer sortable" onclick="sortPage('title', this)">
												<spring:message code='common.title' />
											</span>
										</th>
										<c:if test="${data.mapType ne 'user'}">
											<th scope="col" class="border-top-0">
												<span class="cursor-pointer sortable" onclick="sortPage('usernamestring', this)">
													<spring:message code='common.owner' />
												</span>
											</th>
										</c:if>
										<th scope="col" class="border-top-0">
											<span class="cursor-pointer sortable" onclick="sortPage('viewcount', this)">
												<spring:message code='common.viewcount.shortname' />
											</span>
										</th>
										<th scope="col" class="border-top-0">
											<span class="cursor-pointer sortable sort" onclick="sortPage('created', this)">
												<spring:message code='common.createdate' />
											</span>
										</th>
										<th>#</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="map" items="${data.maps}" end="${data.startnum}" step="1" varStatus="loop">
										<tr>
											<td>
												<div class="text-truncate" style="width: 400px;">
													<a target="_parent" href="${pageContext.request.contextPath}/map/<c:out value='${map.key}'/>" class="text-body text-decoration-none" style="cursor: pointer;">
														<c:out value="${map.name}" />
													</a>
													<c:if test="${data.mapType eq 'public' && map.sharetype ne '1'}">
														<span class="badge badge-warning rounded-circle position-relative" style="top: -3px;">
															<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="12px">
														</span>
													</c:if>
												</div>
											</td>
											<c:if test="${data.mapType ne 'user'}">
												<td>
													<div class="text-truncate" style="width: 300px;">
														<c:out value="${map.owner.lastname} ${map.owner.firstname}" />
													</div>
												</td>
											</c:if>
											<td>
												<div class="text-truncate" style="width: 100px;">
													<c:out value="${map.viewcount}" />
												</div>
											</td>
											<td>
												<div class="text-truncate" style="width: 100px;">
													<span class="created">
														<c:out value="${map.created}" />
													</span>
												</div>
											</td>
											<td><input type="checkbox" class="delMapId ${data.mapType == 'user' ? '':'d-none'}" value="${data.mapType == 'user' ? map.id:''}"></td>
										</tr>
									</c:forEach>
								</tbody>
								<tbody class="${fn:length(data.maps) > 0 ? 'd-none':''}" id="emptymap">
									<tr>
										<td colspan="${data.mapType eq 'user' ? '3':'4'}" class="text-center text-muted">
											<spring:message code='message.page.list.emptymap' />
										</td>
									</tr>
								</tbody>
							</table>
						</c:otherwise>
					</c:choose>
				</div>

				<div style="overflow: auto;text-align: center;">
					<nav aria-label="navigation" class="d-inline-block">
						<ul class="pagination paginate-html"></ul>
					</nav>
				</div>
			</div>

			<template id="card-template">
				<c:choose>
					<c:when test="${data.mapType == 'myshares'}">
						<tr>
							<td>
								<div class="text-truncate" style="width: 300px;">
									<a target="_parent" class="text-body text-decoration-none" style="cursor: pointer;" href="${pageContext.request.contextPath}/map/[map.key]">
										[map.name]
									</a>
									<span class="tmp-lock"></span>
								</div>
							</td>
							<td class="py-2">
								<span class="tmp-share-permissions"></span>
							</td>
							<td>
								<div class="text-truncate" style="width: 300px;">
									<span class="tmp-share-group"></span>
								</div>
							</td>
							<td>
								<div class="text-truncate" style="width: 300px;">
									<div class="tmp-owner"></div>
								</div>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<td>
								<div class="text-truncate" style="width: 400px;">
									<a target="_parent" class="text-body text-decoration-none" href="${pageContext.request.contextPath}/map/[map.key]">
										[map.name]
									</a>
									<span class="tmp-lock"></span>
								</div>
							</td>
							<c:if test="${data.mapType ne 'user'}">
								<td>
									<div class="text-truncate" style="width: 300px;">
										<div class="tmp-owner"></div>
									</div>
								</td>
							</c:if>
							<td>
								<div class="text-truncate" style="width: 100px;">
									[map.viewcount]
								</div>
							</td>
							<td>
								<div class="text-truncate" style="width: 100px;">
									<span class="created">
										[map.created]
									</span>
								</div>
							</td>
							<td><input class="delMapId ${data.mapType == 'user' ? '':'d-none'}" type="checkbox"></td>
						</tr>
					</c:otherwise>
				</c:choose>
			</template>
			<template id="card-template-lock">
				<span class="badge badge-warning rounded-circle position-relative" style="top: -3px;">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="12px">
				</span>
			</template>
			<template id="card-template-owner">
				[map.owner]
			</template>

			<template id="card-template-share-group">
				[share.group]
			</template>
		</c:otherwise>
	</c:choose>
</body>
</html>