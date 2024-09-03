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
		<spring:message code='message.newmap' />
	</title>

	<style>
		input[type=radio]:checked+label {
			background-color: #dae0e5 !important;
			border-color: #213756 !important;
		}
	</style>

	<c:set var="isGuest" value="${user.username eq 'guest'}" />
	<c:set var="checkMoodleForm" value="${data.maptype eq 'moodle' and data.tabidx eq 'frm'}" />

	<script type="text/javascript">
		const isGuest = '${isGuest}';
		const checkMoodleForm = '${checkMoodleForm}';

		function check(frm) {
			var title = frm.title.value;

			frm.title.value = trimAll(title);
			if (!validateNotEmpty(title)) {
				alert("<spring:message code='map.new.enter_title'/>");
				frm.title.focus();
				return false;
			}
			if (!isDuplicateMapName(title)) {
				alert("<spring:message code='message.mindmap.new.duplicate.mapName'/>");
				frm.title.focus();
				return false;
			}


			if (isGuest == 'true') {
				var email_t = frm.email == undefined ? '' : frm.email.value;
				email_t = trimAll(email_t);
				if (!validateNotEmpty(email_t)) {
					alert("<spring:message code='map.new.enter_email'/>");
					if (frm.email != undefined) frm.email.focus();
					return false;
				}
				frm.email.value = email_t;

				var password_t = frm.password == undefined ? '' : frm.password.value;
				password_t = trimAll(password_t);
				if (!validateNotEmpty(password_t)) {
					alert("<spring:message code='map.new.enter_password'/>");
					if (frm.password != undefined) frm.password.focus();
					return false;
				}
				frm.password.value = password_t;
			}

			// email과 password를 입력한 경우는 email, password 를 입력하는 페이지로 이동함으로
			// 현재 창을 닫지 않는다. 그 외에는 창을 닫도록 target을 "_parent"로 한다.
			if ((frm.email == undefined || frm.password == undefined)
				|| (trimAll(frm.email.value) == "" || trimAll(frm.password.value) == "")) {
				frm.target = "_parent";
			} else {
				// email 형식이 맞는지 체크한다.
				if (!validateEmail(trimAll(frm.email.value))) {
					alert("<spring:message code='user.new.email_not_valid'/>");
					frm.email.focus();
					return false;
				}
			}

			if (checkMoodleForm == 'true') {
				if (!create_moodle(frm.title.value, frm.shortname.value, frm.category.value, frm.summary.value)) return false;
			}

			return true;
		}

		function isDuplicateMapName(mapTitle) {
			var params = {
				"mapTitle": mapTitle
			};
			var returnV = false;
			$.ajax({
				type: 'post',
				url: "${pageContext.request.contextPath}/mindmap/isDuplicateMapName.do",
				dataType: 'json',
				data: params,
				async: false,
				success: function (data) {
					if (data.status == "ok") {
						returnV = true;
					} else {
						returnV = false;
					}
				}
			}
			);
			return returnV;
		}

		function validateEmail(mail) {
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

		function cancel() {
			parent.$("#dialog").dialog("close");
		}

		function create_moodle(title, shortname, category, summary) {
			var params = {
				type: 'moodle',
				mdlurl: '${data.mdlurl}',
				create_moodle: true,
				title: title,
				shortname: shortname,
				category: category,
				summary: summary
			};
			var returnV = false;
			window.parent.JinoUtil.waitingDialog("<spring:message code='common.wait' />");
			$.ajax({
				type: 'post',
				url: "${pageContext.request.contextPath}/mindmap/new.do",
				dataType: 'json',
				data: params,
				async: false,
				success: function (data) {
					if (data.status == "ok") {
						document.frm_confirm.moodleCourseId.value = data.course;
						returnV = true;
					} else {
						alert(data.message);
						returnV = false;

					}
					window.parent.JinoUtil.waitingDialogClose();
				}
			});
			return returnV;
		}

		function goPage(v_curr_page) {
			var frm = document.searchf;
			frm.page.value = window.Math.max(1, v_curr_page);
			frm.submit();
		}

		function goSearch() {
			var frm = document.searchf;
			frm.page.value = 1;
			frm.submit();
		}

		function doConnect(id, title) {
			var frm = document.frm_confirm;
			frm.moodleCourseId.value = id;
			frm.title.value = title;
			$('#tblCourses').hide();
			$('#frmConnect').show();
		}

		function doConnectExisting(id){
			window.location.href = "${pageContext.request.contextPath}/mindmap/new.do?type=moodle&tab=tbl&mdlurl=${data.mdlurl}&courseId="+id;
		}

		function doConnectExistingAction(map_id, course_id){
			$.post('${pageContext.request.contextPath}/moodle/moodleConnectExisting.do', {
					map_id: map_id,
					course_id: course_id,
					moodleUrl: '${data.mdlurl}'
				}, function(data){
				if(data.status && data.map_key != '') {
					doOpenMindmap(data.map_key);
				}
			});
		}

		function backToCourses() {
			$('#tblCourses').show();
			$('#frmConnect').hide();
		}

		function doOpenMindmap(map_key) {
			if (map_key == '') {
				alert('Not found map_key');
				return;
			}
			window.parent.document.location.href = "${pageContext.request.contextPath}/map/" + map_key;
		}

		function doDisconnect(map_id) {
			if (map_id) {
				$.post('${pageContext.request.contextPath}/moodle/moodleDisconnect.do', {map_id: map_id}, function(data){
					if(data.status) {
						parent.window.location.reload();
					}
				});
			}
		}

		$(document).ready(function () {
			if ($('.map-style-wrap').length) {
				new PerfectScrollbar('.map-style-wrap');
			}
		});
	</script>
</head>

<body>
	<c:if test="${data.message eq ''}">
		<c:if test="${data.maptype ne 'moodle'}">
			<div class="container-fluid py-3" style="max-width: 500px;">
				<form id="frm_confirm" name="frm_confirm" action="${pageContext.request.contextPath}/mindmap/new.do" onsubmit="return check(this);" method="post">
					<div class="form-group">
						<input required class="form-control form-control-lg bg-light text-center border-0 shadow-none" type="text" name="title" id="title" placeholder="<spring:message code='common.title'/>" autofocus style="font-size: 2rem;">
					</div>
					<div class="form-group">
						<label class="d-block">
							<spring:message code='menu.advanced.pt.mapstyle' />
						</label>

						<div class="map-style-wrap pt-2 pb-3 position-relative">
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jMindMapLayout" value="jMindMapLayout" checked>
								<label for="mapstyle-jMindMapLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/shape_mindmap.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.mindmap' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jTreeLayout" value="jTreeLayout">
								<label for="mapstyle-jTreeLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.tree' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jFishboneLayout" value="jFishboneLayout">
								<label for="mapstyle-jFishboneLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/show_fishbone.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.fishbone' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jCardLayout" value="jCardLayout">
								<label for="mapstyle-jCardLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/shape_card.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.card' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jSunburstLayout" value="jSunburstLayout">
								<label for="mapstyle-jSunburstLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/shape_sunburst.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.sunburst' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jHTreeLayout" value="jHTreeLayout">
								<label for="mapstyle-jHTreeLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap2.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.project' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jPadletLayout" value="jPadletLayout">
								<label for="mapstyle-jPadletLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/show_padlet.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.padlet' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jPartitionLayout" value="jPartitionLayout">
								<label for="mapstyle-jPartitionLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/show_partition.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.partition' />
									</small>
								</label>
							</div>
							<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
								<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jZoomableTreemapLayout" value="jZoomableTreemapLayout">
								<label for="mapstyle-jZoomableTreemapLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/menu/icons/show_partition.png" width="25px" class="d-block mx-auto">
									<small>
										<spring:message code='common.mapstyle.zoomabletreemap' />
									</small>
								</label>
							</div>
						</div>
					</div>
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
					<div class="form-group">
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" name="openmap" id="openmap" value="1" checked>
							<label class="custom-control-label" for="openmap">
								<spring:message code='message.mindmap.new.sharemymap' />
							</label>
						</div>
					</div>
					<div class="mt-5 text-center">
						<button type="submit" class="btn btn-primary btn-min-w">
							<spring:message code='button.create' />
						</button>
					</div>
				</form>
			</div>
		</c:if>

		<!-- moodle -->
		<c:if test="${data.maptype eq 'moodle'}">
			<c:if test="${data.mdlurl eq null}">
				<div class="container-fluid py-3" style="max-width: 500px;">
					<div class="h5 font-weight-bold">
						<spring:message code='message.moodle.choose_site' />
					</div>
					<table class="table">
						<c:forEach var="conn" items="${data.moodle_connections.connections}">
							<tr>
								<td style="font-size: 16px; padding: 4px 0px;">
									&#9632; <a class="text-body text-decoration-none" href="${pageContext.request.contextPath}/mindmap/new.do?type=moodle&tab=frm&mdlurl=${conn.url}">
										<c:out value="${conn.name}" /></a>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</c:if>

			<c:if test="${data.mdlurl ne null}">
				<header>
					<nav class="navbar navbar-expand navbar-dark bg-primary py-0 position-relative">
						<div class="collapse navbar-collapse justify-content-center">
							<ul class="navbar-nav">
								<li class="nav-item mx-2 ${data.tabidx == 'frm' ? 'active font-weight-bold':''}">
									<a class="nav-link" href="${pageContext.request.contextPath}/mindmap/new.do?type=moodle&tab=frm&mdlurl=${data.mdlurl}">
										<spring:message code='message.moodle.new' />
									</a>
								</li>
								<li class="nav-item mx-2 ${data.tabidx == 'tbl' ? 'active font-weight-bold':''}">
									<a class="nav-link" href="${pageContext.request.contextPath}/mindmap/new.do?type=moodle&tab=tbl&mdlurl=${data.mdlurl}">
										<spring:message code='message.moodle.available_courses' />
									</a>
								</li>
							</ul>
						</div>
					</nav>
				</header>


				<c:choose>
					<c:when test="${data.tabidx eq 'frm'}">
						<div class="container-fluid py-3" style="max-width: 500px;">
							<form id="frm_confirm" name="frm_confirm" action="${pageContext.request.contextPath}/mindmap/new.do" onsubmit="return check(this);" method="post">
								<input type="hidden" name="moodleUrl" value="${data.mdlurl}">
								<input type="hidden" name="moodleCourseId">

								<div class="form-group">
									<label>
										<spring:message code='common.title' />
									</label>
									<input type="text" autofocus required class="form-control" name="title" id="title">
								</div>
								<div class="form-group">
									<label>
										<spring:message code='message.moodle.shortname' />
									</label>
									<input type="text" required class="form-control" name="shortname" id="shortname">
								</div>

								<c:if test="${user.username eq 'guest'}">
									<div class="form-group">
										<label>
											<spring:message code='common.email' />
										</label>
										<input type="email" required class="form-control" name="email" id="email">
									</div>
									<div class="form-group">
										<label>
											<spring:message code='common.password' />
										</label>
										<input type="password" required class="form-control" name="password" id="password">
									</div>
								</c:if>

								<div class="form-group">
									<label>
										<spring:message code='common.mapstyle' />
									</label>
									<div class="map-style-wrap pt-2 pb-3 position-relative">
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jMindMapLayout" value="jMindMapLayout" checked>
											<label for="mapstyle-jMindMapLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/shape_mindmap.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.mindmap' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jTreeLayout" value="jTreeLayout">
											<label for="mapstyle-jTreeLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.tree' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jFishboneLayout" value="jFishboneLayout">
											<label for="mapstyle-jFishboneLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/show_fishbone.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.fishbone' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jCardLayout" value="jCardLayout">
											<label for="mapstyle-jCardLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/shape_card.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.card' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jSunburstLayout" value="jSunburstLayout">
											<label for="mapstyle-jSunburstLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/shape_sunburst.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.sunburst' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jHTreeLayout" value="jHTreeLayout">
											<label for="mapstyle-jHTreeLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap2.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.project' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jPadletLayout" value="jPadletLayout">
											<label for="mapstyle-jPadletLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/show_padlet.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.padlet' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jPartitionLayout" value="jPartitionLayout">
											<label for="mapstyle-jPartitionLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/show_partition.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.partition' />
												</small>
											</label>
										</div>
										<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
											<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jZoomableTreemapLayout" value="jZoomableTreemapLayout">
											<label for="mapstyle-jZoomableTreemapLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
												<img src="${pageContext.request.contextPath}/menu/icons/show_partition.png" width="25px" class="d-block mx-auto">
												<small>
													<spring:message code='common.mapstyle.zoomabletreemap' />
												</small>
											</label>
										</div>
									</div>
								</div>

								<div class="form-group">
									<div class="custom-control custom-checkbox">
										<input type="checkbox" class="custom-control-input" name="openmap" id="openmap" value="1" checked>
										<label class="custom-control-label" for="openmap">
											<spring:message code='message.mindmap.new.sharemymap' />
										</label>
									</div>
								</div>

								<div class="form-group">
									<label>
										<spring:message code='message.moodle.category' />
									</label>
									<select id="category" name="category" class="form-control">
										<c:forEach var="category" items="${data.categories}">
											<option value="${category.id}">
												<c:forEach var="i" begin="1" end="${category.depth}">
													-
												</c:forEach>
												${category.name}
											</option>
										</c:forEach>
									</select>
								</div>

								<div class="form-group">
									<label>
										<spring:message code='message.moodle.summary' />
									</label>
									<textarea rows="4" class="form-control" name="summary" id="summary"></textarea>
								</div>

								<div class="mt-4 text-center">
									<button type="submit" class="btn btn-primary btn-min-w">
										<spring:message code='button.apply' />
									</button>
								</div>
							</form>
						</div>
					</c:when>

					<c:when test="${data.tabidx == 'tbl' && data.courseId != null && data.courseId != ''}">
						<div class="d-md-flex align-items-center py-2 px-3 bg-white">
							<div class="mr-auto"></div>
							<form method=post name="searchf" onsubmit="goSearch()">
								<input type="hidden" name="mdlurl" value="${data.mdlurl}">
								<input type="hidden" name="page" value="${data.page}">
								<input type="hidden" name="type" value="${data.maptype}">
								<input type="hidden" name="tab" value="${data.tabidx}">
								<input type="hidden" name="courseId" value="${data.courseId}">

								<div class="input-group my-1">
									<input type="search" id="search" name="search" class="form-control shadow-none" placeholder="<spring:message code='common.search'/>" value="${data.search}">
									<div class="input-group-append">
										<button class="btn btn-light shadow-none border" type="submit">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
										</button>
									</div>
								</div>
							</form>
						</div>

						<div class="container-fluid py-3">
							<div id="tblCourses">
								<table class="table">
									<tr>
										<th>
											<spring:message code='message.openmap.usermaps' />
										</th>
										<th></th>
									</tr>

									<c:forEach var="map" items="${data.maps}">
										<tr>
											<td>
												<c:out value="${map.name}" />
											</td>
											<td align="right">
												<div class="btn-group" role="group">
													<button type="button" class="btn btn-sm btn-success" onclick="doConnectExistingAction('${map.id}', '${data.courseId}')">
														<spring:message code='message.moodle.connect'/>
													</button>
												</div>
											</td>
										</tr>
									</c:forEach>
								</table>

								<div class="mt-3 text-center">
									<button type="button" class="btn btn-dark" onclick="goPage(parseInt('${data.page - 1}'))">◁</button>
									<button type="button" class="btn btn-dark" onclick="goPage(parseInt('${data.page + 1}'))">▷</button>
								</div>
							</div>
						</div>
					</c:when>

					<c:when test="${data.tabidx == 'tbl' && (data.courseId == null || data.courseId == '')}">
						<div class="d-md-flex align-items-center py-2 px-3 bg-white">
							<div class="mr-auto"></div>
							<form method=post name="searchf" onsubmit="goSearch()">
								<input type="hidden" name="mdlurl" value="${data.mdlurl}">
								<input type="hidden" name="page" value="${data.page}">
								<input type="hidden" name="type" value="${data.maptype}">
								<input type="hidden" name="tab" value="${data.tabidx}">

								<div class="input-group my-1">
									<input type="search" id="search" name="search" class="form-control shadow-none" placeholder="<spring:message code='common.search'/>" value="${data.search}">
									<div class="input-group-append">
										<button class="btn btn-light shadow-none border" type="submit">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
										</button>
									</div>
								</div>
							</form>
						</div>

						<div class="container-fluid py-3">
							<div id="tblCourses">
								<table class="table">
									<tr>
										<th>
											<spring:message code='message.moodle.course' />
										</th>
										<th></th>
										<th></th>
									</tr>

									<c:if test="${fn:length(data.courses)<1}">
										<tr height=28>
											<td colspan="2" align="center">
												<spring:message code='message.moodle.not_found' />
											</td>
										</tr>
									</c:if>
									<c:forEach var="course" items="${data.courses}">
										<c:if test="${course.is_teacher eq '1' and course.map_key eq ''}">
											<tr>
												<td>
													<c:out value="${course.fullname}" />
												</td>
												<td align="center">(1)</td>
												<td align="right">
													<div class="btn-group" role="group">
														<button type="button" class="btn btn-sm btn-success" onclick="doConnect(parseInt('${course.id}'), '${course.fullname}')">
															<spring:message code='message.moodle.newmap'/>
														</button>
														<button type="button" class="btn btn-sm btn-dark" onclick="doConnectExisting(parseInt('${course.id}'))">
															<spring:message code='message.moodle.existingmap' />
														</button>
													</div>
												</td>
											</tr>
										</c:if>
									</c:forEach>

									<c:forEach var="course" items="${data.courses}">
										<c:if test="${course.is_teacher eq '1' and course.map_key ne ''}">
											<tr>
												<td>
													<c:out value="${course.fullname}" />
												</td>
												<td align="center">(2)</td>
												<td align="right">
													<div class="btn-group" role="group">
														<button type="button" class="btn btn-sm btn-success" onclick="doOpenMindmap('${course.map_key}')">
															<spring:message code='message.moodle.goto_mindmap' />
														</button>
														<button type="button" class="btn btn-sm btn-danger" onclick="doDisconnect(parseInt('${course.map_id}'))">
															<spring:message code='message.moodle.disconnect' />
														</button>
													</div>
												</td>
											</tr>
										</c:if>
									</c:forEach>

									<c:forEach var="course" items="${data.courses}">
										<c:if test="${false && course.is_teacher eq '0'}">
											<tr>
												<td>
													<c:out value="${course.fullname}" />
												</td>
												<td align="center">(3)</td>
												<td align="right"></td>
											</tr>
										</c:if>
									</c:forEach>
								</table>

								<c:if test="${fn:length(data.courses)>=1}">
									<p>(1)
										<spring:message code='message.moodle.note.can_connect' />
									</p>
									<p>(2)
										<spring:message code='message.moodle.note.connected' />
									</p>
									<div class="mt-3 text-center">
										<button type="button" class="btn btn-dark" <c:if test='${data.page == "1"}'>disabled</c:if> onclick="goPage(parseInt('${data.page - 1}'))">◁</button>
										<%-- <% int i = 0; %>
										<c:forEach var="c" items="${data.tolCourse.courses}">
											<c:if test="${c.is_teacher eq '1'}">
											
											<% if(i % 10 == 0) {%>
												<button type="button" class="btn 
												<c:if test="${Integer.parseInt(data.page) == i / 10}">btn-dark</c:if> 
												<c:if test="${Integer.parseInt(data.page) != i / 10}">btn-outline-dark</c:if>" 
												onclick="goPage(<%=i / 10 +1 %>)"><%= i / 10 + 1 %></button>
												
											<% } %>
											<% i++; %>
											</c:if>
										</c:forEach> --%>
										<c:forEach var = "i" begin = "0" end = "${data.total}">
											<c:if test="${i % 10 == 0}">
												<button type="button" class="btn 
												<c:if test="${data.page == i / 10 + 1}">btn-dark</c:if> 
												<c:if test="${data.page != i / 10 + 1}">btn-outline-dark</c:if>" 
												onclick="goPage(<c:out value = "${i / 10 + 1}"/>)"><fmt:formatNumber pattern="#,##0" value = "${i / 10 + 1}"/></button>
											</c:if>
										</c:forEach>
										<button <c:if test='${data.page > data.total / 10}'> disabled </c:if>  type="button" class="btn btn-dark" onclick="goPage(parseInt('${data.page + 1}'))">▷</button>
									</div>
								</c:if>
								
							</div>

							<div id='frmConnect' style="display: none; max-width: 500px;" class="mx-auto">
								<form id="frm_confirm" name="frm_confirm" action="${pageContext.request.contextPath}/mindmap/new.do" onsubmit="return check(this);" method="post">
									<input type="hidden" name="moodleUrl" value="${data.mdlurl}">
									<input type="hidden" name="moodleCourseId">

									<div class="form-group">
										<label>
											<spring:message code='common.title' />
										</label>
										<input type="text" class="form-control" name="title" value="" />
									</div>

									<c:if test="${user.username eq 'guest'}">
										<div class="form-group">
											<label>
												<spring:message code='common.email' />
											</label>
											<input type="email" class="form-control" name="email" value="" />
										</div>
										<div class="form-group">
											<label>
												<spring:message code='common.password' />
											</label>
											<input type="password" class="form-control" name="password" value="" />
										</div>
									</c:if>

									<div class="form-group">
										<label>
											<spring:message code='common.mapstyle' />
										</label>
										<div class="map-style-wrap pt-2 pb-3 position-relative">
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jMindMapLayout" value="jMindMapLayout" checked>
												<label for="mapstyle-jMindMapLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/shape_mindmap.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.mindmap' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jTreeLayout" value="jTreeLayout">
												<label for="mapstyle-jTreeLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.tree' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jFishboneLayout" value="jFishboneLayout">
												<label for="mapstyle-jFishboneLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/show_fishbone.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.fishbone' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jCardLayout" value="jCardLayout">
												<label for="mapstyle-jCardLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/shape_card.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.card' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jSunburstLayout" value="jSunburstLayout">
												<label for="mapstyle-jSunburstLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/shape_sunburst.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.sunburst' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jHTreeLayout" value="jHTreeLayout">
												<label for="mapstyle-jHTreeLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap2.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.project' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jPadletLayout" value="jPadletLayout">
												<label for="mapstyle-jPadletLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/show_padlet.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.padlet' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jPartitionLayout" value="jPartitionLayout">
												<label for="mapstyle-jPartitionLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/show_partition.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.partition' />
													</small>
												</label>
											</div>
											<div class="d-inline-block mx-1 cursor-pointer" style="vertical-align: bottom;">
												<input class="d-none" type="radio" name="mapstyle" id="mapstyle-jZoomableTreemapLayout" value="jZoomableTreemapLayout">
												<label for="mapstyle-jZoomableTreemapLayout" class="btn btn-light p-1 shadow-none cursor-pointer" style="line-height: 1em; width: 70px; font-size: 0.8em;">
													<img src="${pageContext.request.contextPath}/menu/icons/show_partition.png" width="25px" class="d-block mx-auto">
													<small>
														<spring:message code='common.mapstyle.zoomabletreemap' />
													</small>
												</label>
											</div>
										</div>
									</div>

									<div class="form-group">
										<div class="custom-control custom-checkbox">
											<input type="checkbox" class="custom-control-input" name="openmap" id="openmap" value="1" checked>
											<label class="custom-control-label" for="openmap">
												<spring:message code='message.mindmap.new.sharemymap' />
											</label>
										</div>
									</div>

									<div class="mt-4 text-center">
										<button type="button" class="btn btn-dark btn-min-w" onclick="backToCourses()">
											<spring:message code='button.cancel' />
										</button>
										<button type="submit" class="btn btn-primary btn-min-w">
											<spring:message code='button.apply' />
										</button>
									</div>
								</form>
							</div>
						</div>
					</c:when>
				</c:choose>
			</c:if>
		</c:if>
	</c:if>

	<c:if test="${data.message ne ''}">
		<div class="container-fluid py-3" style="max-width: 500px;">
			<img class="d-block mx-auto mb-4" src="${pageContext.request.contextPath}/theme/dist/images/icons/exclamation-mark.svg" width="80px">
			<h5 class="text-center">${data.message}</h5>
		</div>
	</c:if>
</body>

</html>