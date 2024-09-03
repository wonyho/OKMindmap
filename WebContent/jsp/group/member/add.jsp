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
		<spring:message code='message.group.member.add' />
	</title>

	<script>
		function goSearch() {
			var frm = document.searchf;
			frm.page.value = 1;
			frm.submit();
		}

		function goPage(v_curr_page) {
			var frm = document.searchf;
			frm.page.value = v_curr_page;
			frm.submit();
		}
	</script>

</head>

<body>
	<header>
		<div class="p-3">
			<div class="font-weight-bold h4">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/users.svg" width="26px" class="mr-1 align-top">
				<span>
					<c:out value="${data.group.name}" />
				</span>
			</div>
			<spring:message code='message.group.member.add' />
		</div>

		<div class="d-md-flex align-items-center py-2 px-3 bg-white">
			<div class="mr-auto"></div>
			<form method=post name="searchf" onsubmit="goSearch()">
				<input type="hidden" name="page" value="${data.page}">
				<input type="hidden" name="sort" value="${data.sort}">
				<input type="hidden" name="isAsc" value="${data.isAsc}">
				<input type="hidden" name="mapType" value="${data.mapType}">

				<div class="input-group my-1">
					<div class="input-group-prepend" style="max-width: 30%;">
						<select class="custom-select shadow-none btn" name="searchfield" id="searchfield">
							<option value="username" ${data.searchfield=="username" ? "selected" :""}>Id</option>
							<option value="fullname" ${data.searchfield=="fullname" ? "selected" :""}>
								<spring:message code='common.name' />
							</option>
						</select>
					</div>
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
			<c:when test="${(data.notMembers != null and fn:length(data.notMembers) > 0) or data.search != null}">
				<div class="table-responsive">
					<table class="table">
						<tbody>
							<c:forEach var="user" items="${data.notMembers}">
								<tr>
									<td class="py-1">
										<div class="d-flex align-items-center">
											<div class="flex-shrink-1">
												<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 34px; height: 34px;" class="rounded-circle">
											</div>
											<div class="px-3" style="max-width: 300px;">
												<div class="font-weight-bold text-truncate">
													<c:out value="${user.lastname}"></c:out>
													<c:out value="${user.firstname}"></c:out>
												</div>
												<div class="text-muted text-truncate">
													<small>
														Id: <c:out value="${user.password != 'not cached' ? user.username : '******'}"></c:out> -
														<spring:message code='common.email' />: <c:out value="${fn:substring(user.email, 0, 5)}"></c:out>***
													</small>
												</div>
											</div>
										</div>
									</td>
									<td class="py-3">
										<div class="d-flex justify-content-end">
											<a href="${pageContext.request.contextPath}/group/member/add.do?groupid=<c:out value='${data.group.id}'/>&userid=<c:out value='${user.id}' />" class="btn btn-light btn-sm">
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user-plus.svg" width="18px">
											</a>
										</div>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<div class="pagenum" style="text-align:center;padding-top:7px;">
					<%
						HashMap<String, Object> data = (HashMap) request.getAttribute("data");
						out.println(PagingHelper.instance.autoPaging((Integer)data.get("totalMembers"), (Integer)data.get("pagelimit"), (Integer)data.get("plPageRange"), (Integer)data.get("page")));
					%>
				</div>
			</c:when>
			<c:otherwise>
				<div class="alert alert-success text-center" role="alert">
					<spring:message code='message.group.member.emptyregistered' />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="mt-3 text-center">
			<a href="${pageContext.request.contextPath}/group/member/list.do?id=<c:out value='${data.group.id}' />" class="mx-0 btn btn-dark btn-min-w">
				<spring:message code='button.cancel' />
			</a>
		</div>
	</div>
</body>

</html>