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
        <spring:message code='menu.edit.iframe' />
    </title>

    <script type="text/javascript">
        var w_width = 300;
        var w_height = 200;
        var w_zoom = 100;
        var w_radioScroll = 'No';
        var w_margin_left = 0;
        var w_margin_top = 0;

        function setWidth(size, update) {
            w_width = Math.max(20, Math.min(size, 1000));
            $('#width').val(w_width);
            $('#widthSlider').val(w_width);
            if(update) setForeignObjectExecute();
        }

        function setHeight(size, update) {
            w_height = Math.max(20, Math.min(size, 1000));
            $('#height').val(w_height);
            $('#heightSlider').val(w_height);
            if(update) setForeignObjectExecute();
        }

        function setZoom(size, update) {
            w_zoom = Math.max(10, Math.min(size, 200));
            $('#zoom').val(w_zoom);
            $('#zoomSlider').val(w_zoom);
            if(update) setForeignObjectExecute();
        }

        function setMarginLeft(size, update) {
            w_margin_left = Math.max(0, Math.min(size, 1000));
            $('#marginLeft').val(w_margin_left);
            $('#marginLeftSlider').val(w_margin_left);
            if(update) setForeignObjectExecute();
        }

        function setMarginTop(size, update) {
            w_margin_top = Math.max(0, Math.min(size, 1000));
            $('#marginTop').val(w_margin_top);
            $('#marginTopSlider').val(w_margin_top);
            if(update) setForeignObjectExecute();
        }

        var setForeignObjectExecute = function() {
            var node = parent.jMap.getSelected();
            if (!node) return;

            var url = $('#url').val();
            var zoom = w_zoom / 100.0;
            var width = w_width/zoom + w_margin_left;
            var height = w_height/zoom + w_margin_top;
            var style_zoom =
                '-moz-transform: scale(' + zoom + ');' +
                '-moz-transform-origin: 0 0;' +
                '-o-transform: scale(' + zoom + ');' +
                '-o-transform-origin: 0 0;' +
                '-webkit-transform: scale(' + zoom + ');' +
                '-webkit-transform-origin: 0 0;';
            var srl = $('input[name=radioScroll]:checked').val();

            node.setForeignObjectExecute('<iframe style="' + style_zoom + 'border: none;margin-left:' + (-w_margin_left) + 'px;margin-top:' + (-w_margin_top) + 'px;" src="' + url + '" width="'
                + width + '" height="' + height + '" scrolling="' + srl + '" zoom="' + w_zoom + '"></iframe>', w_width, w_height);
            node.setHyperlinkExecute(url);

            parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
            parent.jMap.layoutManager.layout(true);
        }

        var insertIFrameAction = function (insert, close_dialog) {
            var node = parent.jMap.getSelected();
            if (!node) return;

            if (insert) {
                var url = $('#url').val();
                var zoom = w_zoom / 100.0;
                var width = w_width/zoom + w_margin_left;
			    var height = w_height/zoom + w_margin_top;
                var style_zoom =
                    '-moz-transform: scale(' + zoom + ');' +
                    '-moz-transform-origin: 0 0;' +
                    '-o-transform: scale(' + zoom + ');' +
                    '-o-transform-origin: 0 0;' +
                    '-webkit-transform: scale(' + zoom + ');' +
                    '-webkit-transform-origin: 0 0;';
                var srl = $('input[name=radioScroll]:checked').val();

                node.setForeignObject('<iframe style="' + style_zoom + 'border: none;margin-left:' + (-w_margin_left) + 'px;margin-top:' + (-w_margin_top) + 'px;" src="' + url + '" width="'
                    + width + '" height="' + height + '" scrolling="' + srl + '" zoom="' + w_zoom + '"></iframe>', w_width, w_height);
                node.setHyperlink(url);
            } else {
                node.setForeignObject("");
                node.setHyperlink("");
            }

            parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
            parent.jMap.layoutManager.layout(true);
            if(close_dialog) parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
//			csedung note 1 rows bellow 2020.08.04
//            parent.$('.jino-app').addClass('menu-opacity-active');
            var node = parent.jMap ? parent.jMap.getSelected() : null;
            if (node && node.foreignObjEl) {
                var currentIframe = undefined;
				switch (parent.jMap.layoutManager.type) {
					case 'jCardLayout':
						currentIframe = node.foreignObjEl.iframeEl[0].getElementsByTagName("iframe")[0];
						break;
				
					default:
						currentIframe = node.foreignObjEl.getElementsByTagName("iframe")[0];
						break;
				}
            }

            if (currentIframe != undefined) {
                $('#url').val(currentIframe.getAttribute("src"));
                w_width = parseInt(node.foreignObjEl.getAttribute("width"));
                w_height = parseInt(node.foreignObjEl.getAttribute("height"));
                w_radioScroll = currentIframe.getAttribute("scrolling");
                w_zoom = parseInt(currentIframe.getAttribute("zoom"));
                w_margin_left = Math.abs(currentIframe.style.marginLeft.replace("px", ""));
                w_margin_top = Math.abs(currentIframe.style.marginTop.replace("px", ""));
            }

            setWidth(w_width, false);
            setHeight(w_height, false);
            setZoom(w_zoom, false);
            setMarginLeft(w_margin_left, false);
            setMarginTop(w_margin_top, false);
            if (w_radioScroll == 'Yes') $('#scrollYes').prop("checked", true);
            else $('#scrollNo').prop("checked", true);

            $('#url').on('change', function(){
                insertIFrameAction(true, false);
            });

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                insertIFrameAction(true, true);
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-3">
        <div class="mx-auto">
            <form id="frm_confirm">
                <div class="form-group mb-1 d-flex" style="width: 100%;">
                    <label for="url" style="min-width: 80px;" class="mr-2">
                        <spring:message code='common.url' />
                    </label>
                    <input type="url" required autofocus class="form-control" id="url">
                </div>

                <div class="form-group mb-1 d-flex" style="width: 100%;">
                    <label style="min-width: 80px;" class="mr-2">
                        <spring:message code='common.zoom' />
                    </label>
                    <div class="d-flex align-items-center">
                        <input type="range" min="10" max="200" oninput="setZoom(this.value, true)" class="custom-range flex-grow-1 mr-3" id="zoomSlider">
                        <div class="input-group" style="width: 150px;">
                            <input type="number" min="10" max="200" onchange="setZoom(this.value, true)" class="form-control" id="zoom">
                            <div class="input-group-append">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-1 d-flex" style="width: 100%;">
                    <label style="min-width: 80px;" class="mr-2">
                        <spring:message code='common.width' />
                    </label>
                    <div class="d-flex align-items-center">
                        <input type="range" min="20" max="1000" oninput="setWidth(this.value, true)" class="custom-range flex-grow-1 mr-3" id="widthSlider">
                        <input type="number" min="20" max="1000" onchange="setWidth(this.value, true)" class="form-control" id="width" style="width: 150px;">
                    </div>
                </div>
                <div class="form-group mb-1 d-flex" style="width: 100%;">
                    <label style="min-width: 80px;" class="mr-2">
                        <spring:message code='common.height' />
                    </label>
                    <div class="d-flex align-items-center">
                        <input type="range" min="20" max="1000" oninput="setHeight(this.value, true)" class="custom-range flex-grow-1 mr-3" id="heightSlider">
                        <input type="number" min="20" max="1000" onchange="setHeight(this.value, true)" class="form-control" id="height" style="width: 150px;">
                    </div>
                </div>

                <div class="form-group mb-1 d-flex" style="width: 100%;">
                    <label style="min-width: 80px;" class="mr-2">X</label>
                    <div class="d-flex align-items-center">
                        <input type="range" min="0" max="1000" oninput="setMarginLeft(this.value, true)" class="custom-range flex-grow-1 mr-3" id="marginLeftSlider">
                        <input type="number" min="0" max="1000" onchange="setMarginLeft(this.value, true)" class="form-control" id="marginLeft" style="width: 150px;">
                    </div>
                </div>

                <div class="form-group mb-1 d-flex" style="width: 100%;">
                    <label style="min-width: 80px;" class="mr-2">Y</label>
                    <div class="d-flex align-items-center">
                        <input type="range" min="0" max="1000" oninput="setMarginTop(this.value, true)" class="custom-range flex-grow-1 mr-3" id="marginTopSlider">
                        <input type="number" min="0" max="1000" onchange="setMarginTop(this.value, true)" class="form-control" id="marginTop" style="width: 150px;">
                    </div>
                </div>

                <div class="form-group mb-1 d-flex" style="width: 100%;">
                    <label style="min-width: 80px;" class="mr-2">
                        <spring:message code='common.show_scroll' />
                    </label>
                    <div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="scrollYes" name="radioScroll" value="Yes" class="custom-control-input" onclick="setForeignObjectExecute();">
                            <label class="custom-control-label" for="scrollYes">
                                <spring:message code='common.yes' />
                            </label>
                        </div>
                        <div class="custom-control custom-radio custom-control-inline">
                            <input type="radio" id="scrollNo" name="radioScroll" value="No" class="custom-control-input" onclick="setForeignObjectExecute();">
                            <label class="custom-control-label" for="scrollNo">
                                <spring:message code='common.no' />
                            </label>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-3">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code='button.apply' />
                    </button>
                    <button type="button" onclick="insertIFrameAction(false, true)" class="btn btn-danger btn-min-w">
                        <spring:message code='button.delete' />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>