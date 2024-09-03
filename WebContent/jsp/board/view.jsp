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
				<spring:message code='common.view' />
			</c:when>
			<c:when test="${data.boardType==2}">
				<spring:message code='menu.cs.qna' />
				<spring:message code='common.view' />
			</c:when>
			<c:otherwise>
				<spring:message code='menu.cs.require' />
				<spring:message code='common.view' />
			</c:otherwise>
		</c:choose>
	</title>

	<script type="text/javascript">
		var isEditMode = "<c:out value='${data.isEditMode}' />";
		var onsend = false;
		$(document).ready(function () {
			$("#memoForm").submit(function (event) {
				event.preventDefault();
				if(!onsend) {
					$('#btnsubmit').prop('disabled', true);
					if (isEditMode == '1') {
						document.memoForm.action = '<c:url value="/board/memo_edit.do"/>';
						document.memoForm.memoId.value = '${data.myMemo.memoId}';
						document.memoForm.confirmed.value = "1";
						document.memoForm.isEditMode.value = "0";
						document.memoForm.submit();
					} else {
						document.memoForm.action = '<c:url value="/board/memo_new.do"/>';
						document.memoForm.confirmed.value = "1";
						document.memoForm.submit();
					}
				}
			});
		});
	</script>
</head>

<body class="bg-gray-200">
	<header class="border-bottom">
		<div class="d-md-flex align-items-center py-2 px-3 bg-white">
			<div class="mr-auto">
				<a href="${pageContext.request.contextPath}/board/list.do?boardType=<c:out value='${data.boardType}'/>&lang=<c:out value='${locale.language}'/>" class="ml-0 btn btn-dark">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-left-w.svg" width="20px" class="mr-1">
					<spring:message code='board.button.list' />
				</a>
			</div>
		</div>
	</header>
	<div class="container-fluid py-3 border-bottom bg-white">
		<div class="d-flex align-items-start">
			<div class="flex-shrink-1 pt-2">
				<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.board.userId}' />" style="width: 34px; height: 34px;" class="rounded-circle">
			</div>
			<div class="flex-fill pl-3">
				<div class="d-flex align-items-start">
					<div class="mr-auto" style="max-width: 300px;">
						<div class="text-truncate">
							<small class="font-weight-bold">
								<c:out value="${data.board.username2}" />
							</small>
						</div>
					</div>
					<div class="text-muted text-truncate">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/calendar.svg" width="14px">
						<small>
							<c:out value="${data.board.insertDate}" />
						</small>
					</div>
				</div>
				<div class="h5">
					<c:out value="${data.board.title}" />
				</div>
				<div>
					<c:out value="${data.board.content}" />
				</div>
				<div class="mt-3">
					<a href="${pageContext.request.contextPath}/board/edit_view.do?boardId=<c:out value='${data.board.boardId}'/>&boardType=<c:out value='${data.boardType}'/>" class="btn btn-sm btn-light mr-2">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/edit-3.svg" width="18px">
						<spring:message code='common.edit' />
					</a>
					<a href="${pageContext.request.contextPath}/board/delete.do?boardId=<c:out value='${data.board.boardId}'/>&boardType=<c:out value='${data.boardType}'/>" class="btn btn-sm btn-light">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/trash-2.svg" width="18px">
						<spring:message code='common.delete' />
					</a>
				</div>
			</div>
		</div>
	</div>

	<div class="container-fluid py-3" id="main-container" style="height: 400px; overflow: auto; padding-left: 50px;">
		<c:forEach var="memo" items="${data.boardMemoList}">
			<div class="bg-white my-1 px-2 py-1 rounded">
				<div class="d-flex align-items-start">
					<div class="flex-shrink-1 pt-2">
						<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${memo.userId}' />" style="width: 34px; height: 34px;" class="rounded-circle">
					</div>
					<div class="flex-fill pl-3">
						<div class="d-flex align-items-start">
							<div class="mr-auto" style="max-width: 300px;">
								<div class="text-truncate">
									<small class="font-weight-bold">
										<c:out value="${memo.username2}" />
									</small>
								</div>
							</div>
							<div class="text-muted text-truncate">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/calendar.svg" width="14px">
								<small>
									<fmt:formatDate value="${memo.insertDate}" pattern="yyyy-MM-dd" />
								</small>
							</div>
						</div>
						<div>
							<c:out value="${memo.content}" />
						</div>
						<div class="mt-2">
							<a href="${pageContext.request.contextPath}/board/memo_delete.do?boardId=<c:out value='${data.board.boardId}'/>&boardType=<c:out value='${data.boardType}'/>&memoId=<c:out value='${memo.memoId}'/>" class="btn btn-sm btn-light">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/trash-2.svg" width="18px">
								<spring:message code='common.delete' />
							</a>
						</div>
					</div>
				</div>
			</div>
		</c:forEach>

		<form id="memoForm" name="memoForm" method="post">
			<input type="hidden" name="confirmed" value="0">
			<input type="hidden" name="isEditMode" value="0">
			<input type="hidden" name="memoId">
			<input type="hidden" name="boardId" value="<c:out value='${data.board.boardId}'/>">
			<input type="hidden" name="boardType" value="<c:out value='${data.boardType}'/>">

			<div class="bg-white my-1 px-2 py-2 rounded mt-4">
				<div class="d-flex align-items-start">
					<div class="flex-shrink-1 pt-2">
						<c:choose>
							<c:when test="${data.user.username eq 'guest'}">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user-2.svg" width="34px">
							</c:when>
							<c:otherwise>
								<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.user.id}' />" style="width: 34px; height: 34px;" class="rounded-circle">
							</c:otherwise>
						</c:choose>
					</div>
					<div class="flex-fill pl-3">
						<div class="d-flex align-items-start">
							<c:choose>
								<c:when test="${data.user.username eq 'guest'}">
									<div class="form-group mr-2">
										<label>
											<spring:message code='message.id' />
										</label>
										<input type="text" class="form-control" name="username2" required>
									</div>
									<div class="form-group">
										<label>
											<spring:message code='common.password' />
										</label>
										<input type="password" class="form-control" name="password" required>
									</div>
								</c:when>
								<c:otherwise>
									<div class="mr-auto" style="max-width: 300px;">
										<div class="text-truncate">
											<small class="font-weight-bold">
												<c:out value="${data.user.username}" />
											</small>
										</div>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="form-group">
							<textarea name="content" required class="form-control"><c:out value="${data.myMemo.content }" /></textarea>
						</div>
						<button id="btnsubmit" type="submit" class="btn btn-primary btn-min-w btn-spinner">
							<span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true" style="width: 20px; height: 20px;"></span>
							<span class="btn-lbl">
								<spring:message code='board.button.confirm' />
							</span>
						</button>
					</div>
				</div>
			</div>
		</form>
	</div>
</body>

</html>