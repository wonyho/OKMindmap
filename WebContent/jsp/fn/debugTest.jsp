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
        <c:set var="locale" value="es" />
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

    <title>Debug Test</title>

    <style>
        .disabled {
            opacity: .5;
            pointer-events: none !important;
        }
    </style>

    <script type="text/javascript">
        $.fn.serializeObject = function () {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function () {
                if (o[this.name]) {
                    if (!o[this.name].push) {
                        o[this.name] = [o[this.name]];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        };

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';

            if(parent.jMap.clipboardManager.getClipboardText() == '') {
                $('#copy-group').addClass('disabled');
            }

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                parent.TestRobot.createStart($('#frm_confirm').serializeObject());
                parent.JinoUtil.closeDialog();
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <div class="mx-auto" style="max-width: 300px;">
            <form id="frm_confirm">
                <div class="form-group">
                    <label>Node name</label>
                    <input type="text" required class="form-control" id="node_name" name="node_name">
                </div>
                <div class="form-group">
                    <label>No. of nodes</label>
                    <input type="number" min="1" value="10" required class="form-control" id="period" name="period">
                </div>
                <div class="form-group">
                    <label>Period (milliseconds)</label>
                    <input type="number" min="100" value="1000" required class="form-control" id="repetition" name="repetition">
                </div>
                <div class="form-group" id="copy-group">
                    <label>Duplicate as</label>
                    <div class="custom-control custom-checkbox">
                        <input type="checkbox" class="custom-control-input" id="is_copy" name="is_copy" value="true">
                        <label class="custom-control-label" for="is_copy">Copy selected node</label>
                    </div>
                    <small class="form-text text-muted">You need to copy nodes before using this feature.</small>
                </div>
                <div class="form-group">
                    <label>Expansion</label>
                    <div class="custom-control custom-radio">
                        <input name="expansion" type="radio" class="custom-control-input" id="is_child" value="is_child" checked>
                        <label class="custom-control-label" for="is_child">Child</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input name="expansion" type="radio" class="custom-control-input" id="is_sibling" value="is_sibling">
                        <label class="custom-control-label" for="is_sibling">Sibling</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input name="expansion" type="radio" class="custom-control-input" id="is_random" value="is_random">
                        <label class="custom-control-label" for="is_random">Random</label>
                    </div>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-min-w btn-spinner">
                        <span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                        <spring:message code='button.apply' />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>