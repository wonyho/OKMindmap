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
        <spring:message code='common.export_xml' />
    </title>

    <script type="text/javascript">
        function doCopy() {
            $('#okm_node_structure_textarea').select();
            document.execCommand('copy');
        };

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            var node = parent.jMap.getSelected();
            if (node) {
                $('#okm_node_structure_textarea').val("<okm>" + node.toXML() + "</okm>");
                $('#okm_node_structure_textarea').select();
            }
        });
    </script>
</head>

<body>
    <div class="container-fluid p-3">
        <div class="mx-auto">
            <div id="frm_confirm">
                <div class="form-group">
                    <label>
                        <spring:message code='common.node_structure' />
                    </label>
                    <textarea onfocus="this.select()" class="form-control" id="okm_node_structure_textarea" name="okm_node_structure_textarea" rows="10"></textarea>
                </div>

                <div class="text-center">
                    <button type="button" class="btn btn-primary btn-min-w" onclick="doCopy()">
                        Copy to clipboard
                    </button>
                </div>
            </div>
        </div>
    </div>

</body>

</html>