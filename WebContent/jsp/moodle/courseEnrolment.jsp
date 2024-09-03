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
		<spring:message code='menu.setting.enrolment' />
	</title>

	<script>
		function goSearch(page) {
			var frm = document.searchf;
			frm.page.value = (page == undefined ? 0 : Math.max(0, page));
			frm.submit();
		}

		function doAction(action, userid) {
			var frm = document.enrolAction;
			frm.action.value = action;
			frm.userid.value = userid;
			frm.submit();
		}
	</script>

</head>

<body>
	<c:if test="${data.message eq ''}">
		<header>
			<nav class="navbar navbar-expand navbar-dark bg-primary py-0 position-relative" style="overflow: auto;white-space: nowrap;">
				<div class="collapse navbar-collapse justify-content-center">
					<ul class="navbar-nav">
						<li class="nav-item mx-2 ${data.tabType == 'okmmusers' ? 'active font-weight-bold':''}">
							<a class="nav-link" href="${pageContext.request.contextPath}/moodle/courseEnrolment.do?mapid=${data.mapId}&tabtype=okmmusers">
								<spring:message code='message.moodle.enrollment.okmm_user' />
							</a>
						</li>
						<li class="nav-item mx-2 ${data.tabType == 'moodleusers' ? 'active font-weight-bold':''}">
							<a class="nav-link" href="${pageContext.request.contextPath}/moodle/courseEnrolment.do?mapid=${data.mapId}&tabtype=moodleusers">
								<spring:message code='message.moodle.enrollment.moodle_user' />
							</a>
						</li>
					</ul>
				</div>
			</nav>

			<div class="d-md-flex align-items-center py-2 px-3 bg-white">
				<div class="mr-auto">
					<div>
						${data.total_enrolled_users}
						<spring:message code='message.moodle.enrollment.enrolled' />
					</div>
				</div>
				<form method=post name="searchf" onsubmit="goSearch()">
					<input type="hidden" name="mapid" value="${data.mapId}">
					<input type="hidden" name="tabType" value="${data.tabType}">
					<input type="hidden" name="page">

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
		</header>
		<div class="container-fluid py-3">
			<c:choose>
				<c:when test="${fn:length(data.users) > 0}">
					<div class="table-responsive">
						<table class="table">
							<tbody>
								<c:forEach var="user" items="${data.users}">
									<c:if test="${user.is_enrolled eq '1' && user.is_teacher eq '1'}">
										<tr>
											<td class="py-1">
												<div class="d-flex align-items-center">
													<div class="flex-shrink-1">
														<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 34px; height: 34px;" class="rounded-circle">
													</div>
													<div class="px-3" style="max-width: 300px;">
														<div class="font-weight-bold text-truncate">
															<c:out value="${user.firstname}" />
															<c:out value="${user.lastname}" />
														</div>
														<div class="text-muted text-truncate">
															<small>
																Id: <c:out value="${user.password != 'not cached' ? user.username : '******'}"></c:out> -
																<spring:message code='common.email' />:
																<c:out value="${user.email}" />
															</small>
														</div>
													</div>
												</div>
											</td>
											<td class="py-3">
												<div class="d-flex justify-content-end">
													<button onclick="doAction('unenrol', ${user.id})" type="button" class="btn btn-light btn-sm">
														<img src="${pageContext.request.contextPath}/theme/dist/images/icons/trash-2.svg" width="18px">
														<spring:message code='message.moodle.enrollment.unenroll' />
													</button>
													<button onclick="doAction('unassign_teacher', ${user.id})" type="button" class="btn btn-light btn-sm ml-1">
														<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user-x.svg" width="18px">
														<spring:message code='message.moodle.enrollment.unenroll_teacher' />
													</button>
												</div>
											</td>
										</tr>
									</c:if>
								</c:forEach>

								<c:forEach var="user" items="${data.users}">
									<c:if test="${user.is_enrolled eq '1' && user.is_teacher eq '0'}">
										<tr>
											<td class="py-1">
												<div class="d-flex align-items-center">
													<div class="flex-shrink-1">
														<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 34px; height: 34px;" class="rounded-circle">
													</div>
													<div class="px-3" style="max-width: 300px;">
														<div class="font-weight-bold text-truncate">
															<c:out value="${user.firstname}" />
															<c:out value="${user.lastname}" />
														</div>
														<div class="text-muted text-truncate">
															<small>
																Id: <c:out value="${user.password != 'not cached' ? user.username : '******'}"></c:out> -
																<spring:message code='common.email' />:
																<c:out value="${user.email}" />
															</small>
														</div>
													</div>
												</div>
											</td>
											<td class="py-3">
												<div class="d-flex justify-content-end">
													<button onclick="doAction('unenrol', ${user.id})" type="button" class="btn btn-light btn-sm">
														<img src="${pageContext.request.contextPath}/theme/dist/images/icons/trash-2.svg" width="18px">
														<spring:message code='message.moodle.enrollment.unenroll' />
													</button>
													<button onclick="doAction('assign_teacher', ${user.id})" type="button" class="btn btn-light btn-sm ml-1">
														<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user-check.svg" width="18px">
														<spring:message code='message.moodle.enrollment.enroll_teacher' />
													</button>
												</div>
											</td>
										</tr>
									</c:if>
								</c:forEach>

								<c:forEach var="user" items="${data.users}">
									<c:if test="${user.is_enrolled eq '0'}">
										<tr>
											<td class="py-1">
												<div class="d-flex align-items-center">
													<div class="flex-shrink-1">
														<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 34px; height: 34px;" class="rounded-circle">
													</div>
													<div class="px-3" style="max-width: 300px;">
														<div class="font-weight-bold text-truncate">
															<c:out value="${user.firstname}" />
															<c:out value="${user.lastname}" />
														</div>
														<div class="text-muted text-truncate">
															<small>
																Id: <c:out value="${user.password != 'not cached' ? user.username : '******'}"></c:out> -
																<spring:message code='common.email' />:
																<c:out value="${user.email}" />
															</small>
														</div>
													</div>
												</div>
											</td>
											<td class="py-3">
												<div class="d-flex justify-content-end">
													<button onclick="doAction('enrol', ${user.id})" type="button" class="btn btn-light btn-sm">
														<img src="${pageContext.request.contextPath}/theme/dist/images/icons/plus.svg" width="18px">
														<spring:message code='message.moodle.enrollment.enroll' />
													</button>
												</div>
											</td>
										</tr>
									</c:if>
								</c:forEach>

							</tbody>
						</table>
					</div>

				</c:when>
				<c:otherwise>
					<div class="alert alert-success text-center" role="alert">
						<spring:message code='message.page.list.emptymap' />
					</div>
				</c:otherwise>
			</c:choose>

			<div class="text-center">
				<button type="button" class="btn btn-dark mr-1" onclick="goSearch(${data.page - 1})">◁</button>
				<button type="button" class="btn btn-dark mr-1" onclick="goSearch(${data.page + 1})">▷</button>
			</div>

			<form method=post name="enrolAction" style="display: none;" accept-charset="UTF-8">
				<input type="hidden" name="search" value="${data.search}">
				<input type="hidden" name="mapid" value="${data.mapId}">
				<input type="hidden" name="tabType" value="${data.tabType}">
				<input type="hidden" name="page" value="${data.page}">

				<input type="hidden" name="action">
				<input type="hidden" name="userid">
			</form>
		</div>
	</c:if>
	<c:if test="${data.message ne ''}">
		<div class="container-fluid py-3" style="max-width: 500px;">
			<img class="d-block mx-auto mb-4" src="${pageContext.request.contextPath}/theme/dist/images/icons/exclamation-mark.svg" width="80px">
			<h5 class="text-center">${data.message}</h5>
		</div>
	</c:if>
</body>

</html>