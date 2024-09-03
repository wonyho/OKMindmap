<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<c:choose>
    <c:when test="${cookie['locale'].getValue() == 'en'}">
        <c:set var="locale" value="en" />
    </c:when>
    <c:when test="${cookie['locale'].getValue() == 'es'}">
		<c:set var="locale" value="es"/>
	</c:when>
    <c:when test="${cookie['locale'].getValue() == 'vi'}">
        <c:set var="locale" value="vi" />
    </c:when>
    <c:otherwise>
        <c:set var="locale" value="ko" />
    </c:otherwise>
</c:choose>

<fmt:setLocale value="${locale}" />

<!DOCTYPE html>
<html lang="${locale}">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
    <!-- Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

    <title>
        <spring:message code='message.hyperlink.title' />
    </title>

    <script type="text/javascript">
        var insertHyperActionAction = function (url) {
            var selected = parent.jMap.getSelected();
            if (!selected) return;

            selected.setHyperlink(url);
            parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(selected);
            parent.jMap.layoutManager.layout(true);
            parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            var selected = parent.jMap.getSelected();
            if (selected) {
                var urlText = selected.hyperlink && selected.hyperlink.attr().href;
                urlText = urlText;
                $('#jino_input_url').val(urlText);
                $('#jino_input_url').select();
            }
            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                var url = $('#jino_input_url').val();
                if(!url.startsWith('http://') && !url.startsWith('https://')) {
                    url = 'http://' + url;
                }
                insertHyperActionAction(url);
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <div class="mx-auto" style="max-width: 300px;">
            <form id="frm_confirm">
                <div class="form-group">
                    <label for="jino_input_branch_text">
                        <spring:message code='message.hyperlink.title' />
                    </label>
                    <input type="text" required class="form-control" id="jino_input_url">
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code='button.apply' />
                    </button>
                    <button type="button" onclick="insertHyperActionAction(null)" class="btn btn-danger btn-min-w">
                        <spring:message code='button.delete' />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>