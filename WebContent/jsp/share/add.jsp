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
		<spring:message code='message.share.button.add' />
	</title>

	<script type="text/javascript">
		var shareType = 'open';
		var groupid = '';

		function setShareType(type) {
			$('.share-type').addClass('d-none');
			$('.share-type-' + type).removeClass('d-none');
			$('#sharetype-' + type).prop('checked', true);
		}

		function checkForm() {
			if ($('input[name=sharetype]:checked').val() == 'password' && $('#password').val() == '') {
				alert("<spring:message code='message.share.add.password.empty'/>");
			} else if ($('input[name=sharetype]:checked').val() == 'group' && $('#groupid').val() == null) {
				alert("<spring:message code='message.share.add.type.empty'/>");
			} else {
				document.getElementById('frm_share').submit();
			}
		}

		$(document).ready(function () {
			setShareType(shareType || 'open');
			$('#groupid').val(groupid);

			$("#frm_share").submit(function (event) {
				event.preventDefault();
				checkForm();
			});
			
			$(".share-type").click(function(){
				if($(this).attr("id") == 'sharetype-private'){
					$(".share-permissions-area").addClass('d-none');
				}else{
					$(".share-permissions-area").removeClass('d-none');
				}
			})
			if($("#sharetype-private").prop('checked')){
				$(".share-permissions-area").addClass('d-none');
			}
		});
	</script>
</head>

<body>
	<div class="container-fluid p-3" style="max-width: 500px; min-height: 450px;">
		<div class="font-weight-bold h4">
			<img src="${pageContext.request.contextPath}/theme/dist/images/icons/share-2.svg" width="26px" class="mr-1 align-top">
			<span>
				<spring:message code='message.share.button.add' />
			</span>
		</div>

		<form id="frm_share" action="${pageContext.request.contextPath}/share/add.do" method="post">
			<input type="hidden" name="confirmed" value="1" />

			<div class="form-group">
				<label>
					<spring:message code='common.mindmap' />
				</label>

				<c:choose>
					<c:when test="${data.map == null}">
						<select name="map_id" id="map_id" class="form-control">
							<c:forEach var="map" items="${data.maps}">
								<option value="<c:out value='${map.id}' />">
									<c:out value="${map.name}"></c:out>
								</option>
							</c:forEach>
						</select>
					</c:when>
					<c:otherwise>
						<input class="form-control" type="text" readonly disabled value="<c:out value='${ data.map.name }'/>" />
						<input type="hidden" name="map_id" value="<c:out value='${ data.map.id }' />" />
					</c:otherwise>
				</c:choose>
			</div>

			<div class="form-group">
				<label>
					<spring:message code='message.share.type' />
				</label>
				<div class="share-types">
					<c:forEach var="type" items="${data.shareTypes}">
						<div class="custom-control custom-radio custom-control-inline">
							<input type="radio" id="sharetype-${type.shortName}" value="<c:out value='${type.shortName}'/>" name="sharetype" class="custom-control-input share-type" onchange="setShareType('<c:out value="${type.shortName}" />')">
							<label class="custom-control-label" for="sharetype-${type.shortName}">
								<spring:message code="message.share.add.type.${type.shortName}" />
							</label>
						</div>
					</c:forEach>
				</div>
			</div>

			<div class="share-type share-type-group form-group">
				<label>
					<spring:message code='message.group.name' />
				</label>
				<select name="groupid" id="groupid" class="form-control">
					<c:forEach var="group" items="${data.groups}">
						<option value="<c:out value='${group.id}' />">
							<c:forEach begin="1" end="${group.category.depth - 1}">***/</c:forEach>
							<c:out value="${group.name}"></c:out>
						</option>
					</c:forEach>
				</select>
			</div>

			<div class="share-type share-type-password form-group d-none">
				<label>
					<spring:message code='common.password' />
				</label>
				<input type="password" class="form-control" name="password" id="password">
			</div>
			
			<div class="share-type share-type-lti form-group d-none">
				<label>
					<spring:message code='common.secret_value' />
				</label>
				<input type="password" class="form-control" name="secret" id="secret">
			</div>

			<div class="form-group share-permissions-area">
				<label>
					<spring:message code='message.share.permission' />
				</label>
				<div class="share-permissions">
					<c:forEach var="permission" items="${data.permissionTypes}">
						<div class="custom-control custom-checkbox custom-control-inline">
							<input type="checkbox" class="custom-control-input share-permission" value="1" name="permission_<c:out value='${permission.shortName }' />" id="permission_<c:out value='${permission.shortName }' />" <c:if test="${permission.shortName eq 'view'}"> checked onclick="this.checked=true"</c:if>
							>
							<label class="custom-control-label" for="permission_<c:out value='${permission.shortName }' />">
								<spring:message code="message.share.add.permission_${permission.shortName}" />
							</label>
						</div>
					</c:forEach>
				</div>
			</div>

			<div class="text-center mt-4">
				<button class="btn btn-primary btn-min-w" type="submit">
					<spring:message code='button.save' />
				</button>
				<a href="${pageContext.request.contextPath}/share/list.do?map_id=<c:out value='${ data.map.id }' />" class="btn btn-dark btn-min-w">
					<spring:message code='button.cancel' />
				</a>
			</div>
		</form>
	</div>
</body>

</html>