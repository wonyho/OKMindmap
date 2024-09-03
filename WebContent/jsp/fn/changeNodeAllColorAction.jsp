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

    <!-- Color picker -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.css?v=<%=updateTime%>" type="text/css" media="screen">
    <script defer src="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.js?v=<%=updateTime%>" type="text/javascript"></script>

    <title>
        <spring:message code='menu.theme' />
    </title>

    <style>
        .sp-input {
            border: 1px solid #666666 !important;
        }
    </style>

    <script type="text/javascript">
        var picker = null;
        function changeNodeAllColorAction(colors) {
            if (colors.length) {
                parent.NodeColorMix(parent.jMap.rootNode, colors);
            }
            parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            jMap = parent.jMap;
            picker = $("#color").spectrum({
                allowEmpty: true,
                showInput: true,
                containerClassName: "spectrum-mix-theme",
                showInitial: true,
                showAlpha: true,
                maxPaletteSize: 10,
                preferredFormat: "hex",
                showPalette: true,
                showPaletteOnly: true,
                showButtons: false,
                flat: true,
                localStorageKey: "spectrum.mindmap",
                move: function (color) {
                    $("#color").val(color);
                },
                show: function () {},
                beforeShow: function () {},
                hide: function (color) {},
                palette: [
                    ["#FF6666", "#FFAC33", "#BEBE02", "#6DB847", "#00CC52", "#22DDDD", "#4D95FF", "#9880FF", "#CD80FF", "#FF66E5"],
                    ["#ed1b2e", "#6d6e70", "#d7d7d8", "#b4a996", "#ecb731", "#8ec06c", "#537b35", "#c4dff6", "#56a0d3", "#0091cd"],
                    ["#74d2e7", "#48a9c5", "#0085ad", "#8db9ca", "#4298b5", "#005670", "#00205b", "#009f4d", "#84bd00", "#efdf00"],
                    ["#fdb94e", "#f9a852", "#f69653", "#f38654", "#f07654", "#ed6856", "#ef5956", "#ee4c58", "#56c1ab", "#6a6b6a"],
                    ["#405de6", "#5851db", "#833ab4", "#c13584", "#e1306c", "#fd1d1d", "#f56040", "#f77737", "#fcaf45", "#ffdc80"],
                    ["#0079bf", "#70b500", "#ff9f1a", "#eb5a46", "#f2d600", "#c377e0", "#ff78cb", "#00c2e0", "#51e898", "#c4c9cc"],
                ]
            });

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                changeNodeAllColorAction(jMap.cfg.colorSelectList);
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-3" style="max-width: 500px; min-height: 330px">
        <form id="frm_confirm" class="text-center fn_color_theme">
            <input type="text" id="color" name="color" />
            <div id="colorpicker"></div>
            <input type="hidden" id="isMixTheme" name="isMixTheme" value="true" />
            <input type="hidden" id="isSelectRow" name="isSelectRow" value="false" />
            <input type="hidden" id="selectRowClass" name="selectRowClass" value="" />
            <div class="my-3">
                <spring:message code='alert.changeColor' />
            </div>
            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary btn-min-w">
                    <spring:message code='button.apply' />
                </button>
            </div>
        </form>
    </div>

</body>

</html>