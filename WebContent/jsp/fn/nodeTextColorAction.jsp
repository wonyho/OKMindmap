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
        <spring:message code='menu.nodeTextColorAction' />
    </title>

    <style>
        .sp-input {
            border: 1px solid #666666 !important;
        }
    </style>

    <script type="text/javascript">
        var picker = null;
        function nodeTextColorAction() {
            var color = $('#color').val();
            if (color == '') color = '#000000';

            var selectedNodes = parent.jMap.getSelecteds();
            for (var i = 0; i < selectedNodes.length; i++) {
                selectedNodes[i].setTextColor(color);
            }

            parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            jMap = parent.jMap;
            var node = parent.jMap ? parent.jMap.getSelected() : null;
            if (node) {
                $('#color').val(node.getTextColor());
            }

            picker = $("#color").spectrum({
                allowEmpty: true,
                color: (node ? node.getTextColor() : '#000000'),
                showInput: true,
                containerClassName: "full-spectrum",
                showInitial: true,
                showAlpha: true,
                maxPaletteSize: 10,
                preferredFormat: "hex",
                showPalette: true,
                showSelectionPalette: true,
                showButtons: false,
                showPaletteOnly: true,
                flat: true,
                localStorageKey: "spectrum.mindmap",
                move: function (color) {
                    $("#color").val(color);
                },
                show: function () {
                    $("#colorPicker").removeClass("sp-palette-only");
                },
                beforeShow: function () { },
                hide: function (color) { },
                palette: [
                    [
                        "rgb(0, 0, 0)", "rgb(67, 67, 67)", "rgb(102, 102, 102)", /*"rgb(153, 153, 153)","rgb(183, 183, 183)",*/
                        "rgb(204, 204, 204)", "rgb(217, 217, 217)", /*"rgb(239, 239, 239)", "rgb(243, 243, 243)",*/ "rgb(255, 255, 255)"
                    ],
                    [
                        "rgb(152, 0, 0)", "rgb(255, 0, 0)", "rgb(255, 153, 0)", "rgb(255, 255, 0)", "rgb(0, 255, 0)",
                        "rgb(0, 255, 255)", "rgb(74, 134, 232)", "rgb(0, 0, 255)", "rgb(153, 0, 255)", "rgb(255, 0, 255)"
                    ],
                    [
                        "rgb(230, 184, 175)", "rgb(244, 204, 204)", "rgb(252, 229, 205)", "rgb(255, 242, 204)", "rgb(217, 234, 211)",
                        "rgb(208, 224, 227)", "rgb(201, 218, 248)", "rgb(207, 226, 243)", "rgb(217, 210, 233)", "rgb(234, 209, 220)",
                        "rgb(221, 126, 107)", "rgb(234, 153, 153)", "rgb(249, 203, 156)", "rgb(255, 229, 153)", "rgb(182, 215, 168)",
                        "rgb(162, 196, 201)", "rgb(164, 194, 244)", "rgb(159, 197, 232)", "rgb(180, 167, 214)", "rgb(213, 166, 189)",
                        "rgb(204, 65, 37)", "rgb(224, 102, 102)", "rgb(246, 178, 107)", "rgb(255, 217, 102)", "rgb(147, 196, 125)",
                        "rgb(118, 165, 175)", "rgb(109, 158, 235)", "rgb(111, 168, 220)", "rgb(142, 124, 195)", "rgb(194, 123, 160)",
                        "rgb(166, 28, 0)", "rgb(204, 0, 0)", "rgb(230, 145, 56)", "rgb(241, 194, 50)", "rgb(106, 168, 79)",
                        "rgb(69, 129, 142)", "rgb(60, 120, 216)", "rgb(61, 133, 198)", "rgb(103, 78, 167)", "rgb(166, 77, 121)",
                        /*"rgb(133, 32, 12)", "rgb(153, 0, 0)", "rgb(180, 95, 6)", "rgb(191, 144, 0)", "rgb(56, 118, 29)",
                        "rgb(19, 79, 92)", "rgb(17, 85, 204)", "rgb(11, 83, 148)", "rgb(53, 28, 117)", "rgb(116, 27, 71)",*/
                        "rgb(91, 15, 0)", "rgb(102, 0, 0)", "rgb(120, 63, 4)", "rgb(127, 96, 0)", "rgb(39, 78, 19)",
                        "rgb(12, 52, 61)", "rgb(28, 69, 135)", "rgb(7, 55, 99)", "rgb(32, 18, 77)", "rgb(76, 17, 48)"
                    ]
                ]
            });

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                nodeTextColorAction();
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-3" style="max-width: 500px; min-height: 330px">
        <form id="frm_confirm" class="text-center">
            <input type="text" id="color" name="color" />
            <div id="colorpicker"></div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary btn-min-w">
                    <spring:message code='button.apply' />
                </button>
            </div>
        </form>
    </div>

</body>

</html>