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
				<spring:message code='board.list.new' />
			</c:when>
			<c:when test="${data.boardType==2}">
				<spring:message code='menu.cs.qna' />
				<spring:message code='board.list.new' />
			</c:when>
			<c:otherwise>
				<spring:message code='menu.cs.require' />
				<spring:message code='board.list.new' />
			</c:otherwise>
		</c:choose>
	</title>

	<script type="text/javascript">
		var count = 0;
		var onsend = false;

		function sleep(delay) {
			var start = new Date().getTime();
			while (new Date().getTime() < start + delay);
		}
		function saveContents() {
			count++;
			if (document.frm_group.title.value == '') {
				alert("<spring:message code='board.new.inserttitle'/>");
				document.frm_group.title.focus();
				return;
			}
			
			if (document.frm_group.content.value == '') {
				alert("<spring:message code='board.new.insertcontents'/>");
				document.frm_group.content.focus();
				return;
			}
			
			<c:if test="${data.userId == null}">
				if (document.frm_group.username2.value == '') {
					alert("<spring:message code='board.view.insertusername'/>");
					document.frm_group.username2.focus();
					return;
				}

				if (document.frm_group.userpassword.value == '') {
					alert("<spring:message code='board.view.insertpassword'/>");
					document.frm_group.userpassword.focus();
					return;
				}
			</c:if>		
			
			if(count == 1){
				onsend = true;
				$('#btnsubmit').prop('disabled', true);
				document.frm_group.action = '${pageContext.request.contextPath}/board/new.do';
				document.frm_group.confirmed.value = "1";
				document.frm_group.submit();
			}else{
				alert("<spring:message code='board.list.save'/>");
				sleep(3000);
				location.href="${pageContext.request.contextPath}/board/list.do?boardType=<c:out value="${data.boardType}"/>&lang=<c:out value="${data.lang}"/>"
			}
		}

		$(document).ready(function () {
			$("#frm_group").submit(function (event) {
				event.preventDefault();
				if(!onsend) saveContents();
			});
			
			$("#changCap").click(function(){
				var d = new Date();
				$("#mycap").attr('src','${pageContext.request.contextPath}/jcaptcha.jpg?'+d.getTime());
			});
			if("${data.error}" != "") alert("${data.error}");
		});
	</script>
</head>

<body>
	<div class="container-fluid py-3">
		<div class="font-weight-bold h4">
			<img src="${pageContext.request.contextPath}/theme/dist/images/icons/edit-3.svg" width="26px" class="mr-1 align-top">
			<span>
				<spring:message code='board.list.new' />
			</span>
		</div>

		<form id="frm_group" name="frm_group" method="post" >
			<input type="hidden" name="confirmed" value="1" />
			<input type="hidden" name="boardType" value="<c:out value='${data.boardType}'/>" />
			<input type="hidden" name="lang" value="<c:out value='${data.lang}'/>" />

			<div class="form-group">
				<label>
					<spring:message code='common.title'/>
				</label>
				<input type="text" required autofocus name="title" class="form-control" value="${data.title}">
			</div>
			<div class="form-group">
				<label>
					<spring:message code='board.common.content'/>
				</label>
				<textarea name="content" class="form-control" rows="4">${data.content}</textarea>
			</div>
			<c:if test="${data.userId == null}">
				<div class="form-group">
					<label>
						<spring:message code='common.name'/>
					</label>
					<input type="text" name="username2" class="form-control">
				</div>
				<div class="form-group">
					<label>
						<spring:message code='common.password'/>
					</label>
					<input type="password" name="userpassword" class="form-control">
				</div>
			</c:if>
			
			<div class="d-flex justify-content-center">
				<img src="${pageContext.request.contextPath}/jcaptcha.jpg" id="mycap" /> 
				<a href="#" class="btn btn-secondary btn-sm active" role="button" aria-pressed="true" id="changCap" style="max-height: 30px; margin-top:30px">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-counterclockwise" viewBox="0 0 16 16">
					  <path fill-rule="evenodd" d="M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2v1z"/>
					  <path d="M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466z"/>
					</svg>
				</a>
				<input type="text" name="japtcha" value="" required  style="max-height: 30px; margin-top:30px"/>
				
			</div>

			<div class="text-center mt-4">
				<button id="btnsubmit" type="submit" class="btn btn-primary btn-min-w btn-spinner">
					<span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true" style="width: 20px; height: 20px;"></span>
					<span class="btn-lbl">
						<spring:message code='board.button.confirm'/>
					</span>
				</button>
				<a href="${pageContext.request.contextPath}/board/list.do?boardType=<c:out value='${data.boardType}'/>&lang=<c:out value='${data.lang}'/>" class="btn btn-dark btn-min-w">
					<spring:message code='board.button.list'/>
				</a>
			</div>
		</form>
	</div>
</body>

</html>