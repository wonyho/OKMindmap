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
		<spring:message code='message.group.join' />
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
					<spring:message code='message.group.join' />
				</span>
			</div>
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
							<option value="groupname">
								<spring:message code='message.group.name' />
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
			<c:when test="${data.groups != null and fn:length(data.groups) > 0}">
				<div class="table-responsive">
					<table class="table">
						<tbody>
							<c:forEach var="group" items="${data.groups}">
								<tr>
									<td class="py-1">
										<div class="d-flex align-items-start">
											<div class="flex-shrink-1 pt-2">
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/teamwork.svg" width="34px">
											</div>
											<div class="px-3" style="max-width: 300px;">
												<div class="font-weight-bold text-truncate">
													<c:choose>
														<c:when test="${user.id == group.user.id}">
															<a href="${pageContext.request.contextPath}/group/member/list.do?id=<c:out value='${group.id}'/>">
																<c:out value="${group.name}"></c:out>
															</a>
														</c:when>
														<c:otherwise>
															<c:out value="${group.name}" />
														</c:otherwise>
													</c:choose>
												</div>
												<div class="text-muted text-truncate" style="line-height: 0.8;">
													<small>
														/<c:forEach begin="1" end="${group.category.depth - 1}">***/</c:forEach>
													</small>
												</div>
												<div class="text-muted text-truncate">
													<small>
														<c:out value="${group.summary}" />
													</small>
												</div>
											</div>
										</div>
									</td>
									
									<td class="py-3">
										<span class="badge badge-pill badge-gray-200 px-3 py-2">
											<spring:message code="message.group.new.policy.${group.policy.shortName}" />
										</span>
									</td>
									<td class="py-3">
										<div class="d-flex justify-content-end">
											<a href="${pageContext.request.contextPath}/group/join.do?groupid=<c:out value='${group.id}' />" class="btn btn-primary btn-sm mr-1">
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/plus-w.svg" width="18px" class="mr-1">
												<spring:message code='message.group.join'/>
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
						out.println(PagingHelper.instance.autoPaging((Integer)data.get("totalGroups"), (Integer)data.get("pagelimit"), (Integer)data.get("plPageRange"), (Integer)data.get("page")));
					%>
				</div>
			</c:when>
			<c:otherwise>
				<div class="alert alert-success text-center" role="alert">
					<spring:message code='message.group.nogroup' />
				</div>
			</c:otherwise>
		</c:choose>

		<div class="mt-3 text-center">
			<a href="${pageContext.request.contextPath}/group/list.do" class="mx-0 btn btn-dark btn-min-w">
				<spring:message code='button.cancel' />
			</a>
		</div>
	</div>
</body>

</html>