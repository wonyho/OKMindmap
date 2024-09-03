<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<%-- <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script> --%>

	<title>
		<spring:message code='message.share.title' />
	</title>

	<script type="text/javascript">
		// $(document).ready(function () {

		// });
	</script>
	
</head>

<body>

	<c:choose>
		<c:when test="${data.sharedMaps != null and fn:length(data.sharedMaps) > 0}">
			<div class="container-fluid py-3" style="max-height: 600px; overflow: auto;">
				<c:set var="mapId" value="" />
				<c:forEach var="map" items="${data.sharedMaps}">
					<c:if test="${mapId != map.id && mapId != ''}">
						</div> 
					</c:if>
					<c:if test="${mapId != map.id}">
						<div class="font-weight-bold h4">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/share-2.svg" width="26px" class="mr-1 align-top">
							<span>
								<c:out value="${map.name}" />
							</span>
						</div>
						<div class="mb-3">
					</c:if>

					<c:set var="shareType" value="" />
					<c:forEach var="share" items="${map.shares}">
						<c:if test="${share.shareType.name != shareType && shareType != ''}">
							</ul>
						</c:if>
						<c:if test="${share.shareType.name != shareType}">
							<label>
								<spring:message code="message.share.add.type.${share.shareType.shortName}" />
							</label>
							<ul class="list-group mb-2">
						</c:if>

							<li class="list-group-item px-2 py-1">
								<c:if test="${share.shareType.shortName == 'group'}">
									<div class="mb-1 text-truncate">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/users.svg" width="16px" class="mr-1 align-text-bottom">
										<c:out value="${share.group.name}" />
									</div>
								</c:if>
								<div class="d-flex flex-wrap align-items-center">
									<c:if test='${share.shareType.shortName == "private"}'> 
										<span class="badge badge-gray-200 badge-pill px-3 py-2 mr-1 text-danger">
												<spring:message code="message.share.add.type.${share.shareType.shortName}" />
										</span>
									</c:if>
									<c:forEach var="permission" items="${share.permissions}">
										<c:if test="${permission.permited}">
											<span class="badge badge-gray-200 badge-pill px-3 py-2 mr-1">
												<spring:message code="message.share.add.permission_${permission.permissionType.shortName}" />
											</span>
										</c:if>
									</c:forEach>
									<div class="mr-auto"></div>
									<a href="${pageContext.request.contextPath}/share/update.do?id=<c:out value='${share.id}'/>&map_id=<c:out value='${data.map_id}'/>" class="btn btn-light btn-sm mr-1">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/edit-3.svg" width="18px">
									</a>
									<a href="${pageContext.request.contextPath}/share/delete.do?id=<c:out value='${share.id}'/>&map_id=<c:out value='${data.map_id}'/>" class="btn btn-light btn-sm">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/trash-2.svg" width="18px">
									</a>
								</div>
							</li>
						
						<c:set var="shareType" value="${share.shareType.name}" />
					</c:forEach>

					<c:set var="mapId" value="${map.id}" />
				</c:forEach>
			</div>
		</c:when>
		<c:otherwise>
			<div class="container-fluid py-3">
				<div class="alert alert-success text-center" role="alert">
					<spring:message code='message.share.emptysharedlist' />
				</div>
			</div>
		</c:otherwise>
	</c:choose>
	<div class="container-fluid py-3 text-center">
		<a href="${pageContext.request.contextPath}/share/add.do?map_id=${data.map_id}" class="btn btn-primary btn-min-w">
			<spring:message code='message.share.button.add' />
		</a>
	</div>

</body>

</html>