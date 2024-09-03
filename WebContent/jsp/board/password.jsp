<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <spring:message code='common.password' />
    </title>
</head>

<body>
    <div class="container-fluid py-3">
        <div class="mx-auto" style="max-width: 300px;">
            <img class="d-block mx-auto mb-3" src="${pageContext.request.contextPath}/theme/dist/images/icons/confirm-owner.svg" width="80px">
            <div class="h5 mb-3 text-center">
                <spring:message code='common.password' />
                <spring:message code='board.common.insert' />
            </div>

            <form id="frm_share_password" action="${pageContext.request.contextPath}<c:out value='${data.action}' />" method="post">
                <c:if test="${data.boardId != null}">
                    <input type="hidden" name="boardId" value="<c:out value='${data.boardId}' />" />
                </c:if>
                <c:if test="${data.memoId != null}">
                    <input type="hidden" name="memoId" value="<c:out value='${data.memoId}' />" />
                </c:if>
                <input type="hidden" name="boardType" value="<c:out value='${data.boardType}' />" />

                <div class="form-group">
                    <label for="password">
                        <spring:message code='common.password' />
                    </label>
                    <input type="password" required class="form-control form-control-lg" id="password" name="password">
                </div>

                <div class="text-center mt-3">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code='button.confirm' />
                    </button>
                    <a href="${pageContext.request.contextPath}/board/view.do?boardId=<c:out value='${data.boardId}'/>&boardType=<c:out value='${data.boardType}'/>" class="btn btn-dark btn-min-w">
                        <spring:message code='button.cancel' />
                    </a>
                </div>
            </form>
        </div>
    </div>

</body>

</html>