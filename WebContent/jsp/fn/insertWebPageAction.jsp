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

    <!-- Tinymce for webpage node -->
    <script defer src="${pageContext.request.contextPath}/lib/tinymce/tinymce.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

    <title>
        <spring:message code='menu.edit.webpage' />
    </title>

    <style>
        .mce-branding-powered-by {
            display: none !important;
        }
    </style>

    <script type="text/javascript">
        var w_width = 300;
        var w_height = 200;
        var w_zoom = 100;
        var w_radioScroll = 'No';

        function blurModal(status) {
			if(status) {
				parent.$('#iframeDialog').addClass('modal-blur');
				$('html').addClass('modal-blur');
			} else {
				parent.$('#iframeDialog').removeClass('modal-blur');
				$('html').removeClass('modal-blur');
			}
		}

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

        var setForeignObjectExecute = function() {
            var node = parent.jMap.getSelected();
            if (!node) return;

            if(tinyMCE && tinyMCE.get('webpage_editor')) {
                var webpage = tinyMCE.get('webpage_editor').getContent();
                var zoom = w_zoom/100.0;
                var style_zoom =
                    '-moz-transform: scale(' + zoom + ');' +
                    '-moz-transform-origin: 0 0;' +
                    '-o-transform: scale(' + zoom + ');' +
                    '-o-transform-origin: 0 0;' +
                    '-webkit-transform: scale(' + zoom + ');' +
                    '-webkit-transform-origin: 0 0;';
                var srl = $('input[name=radioScroll]:checked').val() != 'Yes' ? "" : "overflow:auto;";

                node.setForeignObjectExecute('<div style="' + srl + style_zoom + 'margin:0;border: none;width:'
                    + w_width / zoom + 'px; height:' + w_height / zoom + 'px;" zoom="' + w_zoom + '">' + webpage + '</div>', w_width, w_height);
                
                parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
                parent.jMap.layoutManager.layout(true);
            }
        };

        var insertWebPageAction = function (insert, close_dialog) {
            var node = parent.jMap.getSelected();
            if (!node) return;

            if (insert) {
                var webpage = tinyMCE.get('webpage_editor').getContent();
                var zoom = w_zoom/100.0;
                var style_zoom =
                    '-moz-transform: scale(' + zoom + ');' +
                    '-moz-transform-origin: 0 0;' +
                    '-o-transform: scale(' + zoom + ');' +
                    '-o-transform-origin: 0 0;' +
                    '-webkit-transform: scale(' + zoom + ');' +
                    '-webkit-transform-origin: 0 0;';
                var srl = $('input[name=radioScroll]:checked').val() != 'Yes' ? "" : "overflow:auto;";

                node.setForeignObject('<div style="' + srl + style_zoom + 'margin:0;border: none;width:'
                    + w_width / zoom + 'px; height:' + w_height / zoom + 'px;" zoom="' + w_zoom + '">' + webpage + '</div>', w_width, w_height);
            } else {
                node.setForeignObject("");
            }

            parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
            parent.jMap.layoutManager.layout(true);
            if(close_dialog) parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
//			csedung note 1 rows bellow 2020.08.04
//          parent.$('.jino-app').addClass('menu-opacity-active');
            var node = parent.jMap ? parent.jMap.getSelected() : null;
            if (node && node.foreignObjEl) {
                var currentWebPage = node.foreignObjEl.getElementsByTagName("div")[0];
            }

            tinymce.init({
                selector: '#webpage_editor',
                height: '300',
                entity_encoding: 'raw',
                menubar: false,
                plugins: [
                    "advlist autolink link image lists charmap print preview hr anchor pagebreak",
                    "searchreplace wordcount visualblocks visualchars fullscreen insertdatetime media nonbreaking",
                    "formula table contextmenu directionality emoticons code template textcolor paste textcolor colorpicker textpattern"
                ],
                toolbar1: 'toolbar_toggle,formatselect,wrap,bold,italic,wrap,bullist,numlist,wrap,link,unlink,wrap,image',
                toolbar2: 'undo,redo,wrap,underline,strikethrough,subscript,superscript,wrap,justifyleft,justifycenter,justifyright,wrap,outdent,indent,wrap,forecolor,backcolor,wrap,ltr,rtl',
                toolbar3: 'fontselect,fontsizeselect,wrap,formula,searchreplace,code,wrap,nonbreaking,charmap,table,wrap,cleanup,removeformat,pastetext,pasteword,wrap,codesample fullscreen',

                setup: function (editor) {
                    editor.addButton('toolbar_toggle', {
                        tooltip: "<spring:message code='common.toolbar_toggle' />",
                        image: tinymce.baseURL + '/img/toolbars.png',
                        onclick: function () {
                            var toolbars = editor.theme.panel.find('toolbar');
                            for (var i = 1; i < toolbars.length; i++)
                                $(toolbars[i].getEl()).toggle();
                        }
                    });
                    editor.on('init', function (e) {
                        var toolbars = editor.theme.panel.find('toolbar');
                        for (var i = 1; i < toolbars.length; i++) {
                            $(toolbars[i].getEl()).toggle();
                        }

                        if (currentWebPage != undefined) editor.setContent(currentWebPage.innerHTML);
                        else editor.setContent("Your Webpage goes here");
                    });
                }
            });


            if (currentWebPage != undefined) {
                w_width = parseInt(node.foreignObjEl.getAttribute("width"));
                w_height = parseInt(node.foreignObjEl.getAttribute("height"));

                w_width = parseInt(node.foreignObjEl.getAttribute("width"));
                w_height = parseInt(node.foreignObjEl.getAttribute("height"));
                w_radioScroll = currentWebPage.style.overflow ? "Yes" : "No";
                w_zoom = parseInt(currentWebPage.getAttribute("zoom"));
            }

            setWidth(w_width, false);
            setHeight(w_height, false);
            setZoom(w_zoom, false);
            if (w_radioScroll == 'Yes') $('#scrollYes').prop("checked", true);
            else $('#scrollNo').prop("checked", true);

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                insertWebPageAction(true, true);
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid p-3">
        <div class="mx-auto">
            <form id="frm_confirm">
                <div class="form-group">
                    <textarea id="webpage_editor" name="webpage_editor"></textarea>
                </div>

                <div class="form-inline mx-auto" style="max-width: 700px;">
                    <div class="form-group mb-1" style="width: 100%;">
                        <label style="min-width: 150px;">
                            <spring:message code='common.width' />
                        </label>
                        <div class="ml-2 d-flex align-items-center">
                            <input type="range" min="20" max="1000" oninput="setWidth(this.value, true)" class="custom-range flex-grow-1 mr-3" id="widthSlider">
                            <input type="number" min="20" max="1000" onchange="setWidth(this.value, true)" class="form-control" id="width" style="width: 150px;">
                        </div>
                    </div>
                    <div class="form-group mb-1" style="width: 100%;">
                        <label style="min-width: 150px;">
                            <spring:message code='common.height' />
                        </label>
                        <div class="ml-2 d-flex align-items-center">
                            <input type="range" min="20" max="1000" oninput="setHeight(this.value, true)" class="custom-range flex-grow-1 mr-3" id="heightSlider">
                            <input type="number" min="20" max="1000" onchange="setHeight(this.value, true)" class="form-control" id="height" style="width: 150px;">
                        </div>
                    </div>
                    <div class="form-group mb-1" style="width: 100%;">
                        <label style="min-width: 150px;">
                            <spring:message code='common.zoom' />
                        </label>
                        <div class="ml-2 d-flex align-items-center">
                            <input type="range" min="10" max="200" oninput="setZoom(this.value, true)" class="custom-range flex-grow-1 mr-3" id="zoomSlider">
                            <div class="input-group" style="width: 200px;">
                                <input type="number" min="10" max="200" onchange="setZoom(this.value, true)" class="form-control" id="zoom">
                                <div class="input-group-append">
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group mb-1" style="width: 100%;">
                        <label style="min-width: 150px;">
                            <spring:message code='common.show_scroll' />
                        </label>
                        <div class="ml-2">
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
                </div>

                <div class="text-center mt-3">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code='button.apply' />
                    </button>
                    <button type="button" onclick="insertWebPageAction(false, true)" class="btn btn-danger btn-min-w">
                        <spring:message code='button.delete' />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>