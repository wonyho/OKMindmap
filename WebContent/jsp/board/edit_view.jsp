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
		<c:choose>
			<c:when test="${data.boardType==1}">
				<spring:message code='menu.cs.notice' />
				<spring:message code='common.edit' />
			</c:when>
			<c:when test="${data.boardType==2}">
				<spring:message code='menu.cs.qna' />
				<spring:message code='common.edit' />
			</c:when>
			<c:otherwise>
				<spring:message code='menu.cs.require' />
				<spring:message code='common.edit' />
			</c:otherwise>
		</c:choose>
	</title>

	<script type="text/javascript">
		var onsend = false;

		$(document).ready(function () {
			$("#frm_board").submit(function (event) {
				event.preventDefault();
				if(!onsend) {
					onsend = true;
					$('#btnsubmit').prop('disabled', true);
					document.frm_board.action = '${pageContext.request.contextPath}/board/edit.do';
					document.frm_board.submit();
				}
			});
		});
	</script>
</head>

<body>
	<div class="container-fluid py-3">
		<div class="font-weight-bold h4">
			<img src="${pageContext.request.contextPath}/theme/dist/images/icons/edit-3.svg" width="26px" class="mr-1 align-top">
			<span>
				<spring:message code='common.edit' />
			</span>
		</div>

		<form id="frm_board" name="frm_board" method="post">
			<input type="hidden" name="confirmed" value="1" />
			<input type="hidden" name="boardType" value="<c:out value='${data.boardType}' />" />
			<input type="hidden" name="boardId" value="<c:out value='${data.board.boardId}' />" />
			<input type="hidden" name="password" value="<c:out value='${data.password}' />" />

			<div class="form-group">
				<label>
					<spring:message code='common.title' />
				</label>
				<input type="text" required autofocus name="title" class="form-control" value="<c:out value='${data.board.title}' />">
			</div>
			<div class="form-group">
				<label>
					<spring:message code='board.common.content' />
				</label>
				<textarea name="content" class="form-control" rows="4"><c:out value="${data.board.content}" /></textarea>
			</div>

			<div class="text-center mt-4">
				<button id="btnsubmit" type="submit" class="btn btn-primary btn-min-w btn-spinner">
					<span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true" style="width: 20px; height: 20px;"></span>
					<span class="btn-lbl">
						<spring:message code='board.button.confirm' />
					</span>
				</button>
				<a href="${pageContext.request.contextPath}/board/view.do?boardId=<c:out value='${data.board.boardId}'/>&boardType=<c:out value='${data.boardType}'/>" class="btn btn-dark btn-min-w">
					<spring:message code='button.cancel' />
				</a>
			</div>
		</form>
	</div>
</body>

</html>