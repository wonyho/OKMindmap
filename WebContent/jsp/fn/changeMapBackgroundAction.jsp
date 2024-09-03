<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    String type = "image".equals(request.getParameter("type")) ? "image":"color";
	request.setAttribute("type", type);

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

    <c:choose>
        <c:when test="${type == 'color'}">
            <!-- Color picker -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.css?v=<%=updateTime%>" type="text/css" media="screen">
            <script defer src="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.js?v=<%=updateTime%>" type="text/javascript"></script>
        </c:when>
    </c:choose>

    <title>
        <spring:message code='menu.rollover.midnmap.mapbackgroundchange' />
    </title>

    <style>
        .sp-input {
            border: 1px solid #666666 !important;
        }
    </style>

    <c:choose>
        <c:when test="${type == 'color'}">
            <script type="text/javascript">
                var picker = null;
                function changeMapBackgroundAction(color) {
                    if (color == '') color = '#ffffff';

                    parent.jMap.cfg.mapBackgroundColor = color;
                    $(parent.jMap.work).css("background-color", color);

                    var root = parent.jMap.getRootNode();
                    if (root.attributes == undefined)
                        root.attributes = {};
                    root.attributes['mapBackgroundColor'] = color;
                    parent.jMap.saveAction.editAction(root);

                    parent.JinoUtil.closeDialog();
                }

                $(document).ready(function () {
                    if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
                    
                    jMap = parent.jMap;
                    picker = $("#color").spectrum({
                        allowEmpty: true,
                        color: jMap.cfg.mapBackgroundColor,
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
                        changeMapBackgroundAction($('#color').val());
                    });
                });
            </script>
        </c:when>

        <c:when test="${type == 'image'}">
            <script type="text/javascript">
                const maxUploadSize = 10485760;
                const imageFormat = 'jpg,jpeg,png';
                const FILEUPLOAD_API_URL = "${pageContext.request.contextPath}/media/fileupload.do";
                var bgURL = '';

                function changeMapBackgroundAction(url) {
                    var root = parent.jMap.getRootNode();
                    if (root.attributes == undefined)
                        root.attributes = {};

                    if (url == '') {
                        parent.jMap.cfg.mapBackgroundImage = '';
                        $(parent.jMap.work).css("background-image", '');
                        delete root.attributes.mapBackgroundImage;
                    } else {
                        parent.jMap.cfg.mapBackgroundImage = url;
                        $(parent.jMap.work).css("background-image", 'url("' + url + '")');
                        root.attributes['mapBackgroundImage'] = url;
                    }

                    parent.jMap.saveAction.editAction(root);
                    parent.JinoUtil.closeDialog();
                }

                function loadding(show) {
                    if (show) {
                        $('#main-container').addClass('skeleton-loading');
                    } else {
                        $('#main-container').removeClass('skeleton-loading');
                    }
                }

                function getImageInfo(url, callback) {
                    loadding(true);
                    var $img = $('<img />')
                        .attr('src', url)
                        .on('load', function () {
                            callback(this);
                            loadding(false);
                        })
                        .on('error', function () {
                            alert('Invalid URL format.');
                            loadding(false);
                            callback(null);
                        });
                }

                function showImage() {
                    bgURL = $('#jino_input_img_url').val();
                    if (bgURL != '') {
                        getImageInfo(bgURL, function (img) {
                            if (img != null) {
                                $('#fileupload_img').attr('src', bgURL);
                            }
                        });
                    }
                }

                function checkFormat(obj_type) {
                    var format = imageFormat;
                    var str = format.split(",");
                    var type = obj_type.split("/");

                    for (var i = 0; i < str.length; i++) {
                        if (str[i] == type[1]) {
                            return true;
                        }
                    }
                    return false;
                }

                function uploadFile(file) {
                    $('#fileupload').addClass('onupload');

                    var formData = new FormData();
                    formData.append('confirm', 1);
                    formData.append('url_only', true);
                    formData.append('mapid', parent.jMap.cfg.mapId);
                    formData.append('file', file);

                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', FILEUPLOAD_API_URL);
                    xhr.onprogress = function (evt) {
                        if (evt.lengthComputable) {
                            var per = Math.round(evt.loaded / evt.total * 100);
                            $('#fileupload_progress').css('width', per + '%');
                        }
                    };
                    xhr.onerror = function (evt) {
                        alert("<spring:message code='common.upload_error'/>");
                        $('#fileupload').removeClass('onupload');
                    };
                    xhr.onreadystatechange = function () {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                            $('#fileupload').removeClass('onupload');
                            var res = JSON.parse(xhr.response);
                            bgURL = '${pageContext.request.contextPath}/map' + res.url;
                            $('#fileupload_img').attr('src', bgURL);
                            $('#jino_input_img_url').val(bgURL);
                        }
                    }
                    xhr.send(formData);
                }

                $(document).ready(function () {
                    if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';

                    var root = parent.jMap ? parent.jMap.getRootNode() : null;
                    if (root) {
                        if (root.attributes == undefined)
                            root.attributes = {};
                        if (root.attributes.mapBackgroundImage != undefined) {
                            bgURL = root.attributes.mapBackgroundImage;
                            $('#jino_input_img_url').val(bgURL);
                            $('#fileupload_img').attr('src', bgURL);
                        }
                    }

                    $('#fileupload_input').on('change', function () {
                        if (this.files.length) {
                            var file = this.files[0];
                            if (maxUploadSize < file.size) {
                                alert("<spring:message code='file.limit' /> (<10Mb)");
                            } else if (!checkFormat(file.type)) {
                                alert("<spring:message code='file.image' />");
                            } else {
                                uploadFile(file);
                            }
                        }
                    });

                    $("#frm_confirm").submit(function (event) {
                        event.preventDefault();
                        changeMapBackgroundAction(bgURL);
                    });
                });
            </script>
        </c:when>
    </c:choose>

</head>

<body>
    <header>
        <nav class="navbar navbar-expand navbar-dark bg-primary py-0 position-relative" style="overflow: auto;white-space: nowrap;">
            <div class="collapse navbar-collapse justify-content-center">
                <ul class="navbar-nav">
                    <li class="nav-item mx-2 ${type == 'color' ? 'active font-weight-bold':''}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/jsp/fn/changeMapBackgroundAction.jsp">
                            <spring:message code='menu.format.nodebgcolor' />
                        </a>
                    </li>
                    <li class="nav-item mx-2 ${type == 'image' ? 'active font-weight-bold':''}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/jsp/fn/changeMapBackgroundAction.jsp?type=image">
                            <spring:message code='menu.edit.imageurl' />
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <c:choose>
        <c:when test="${type == 'color'}">
            <div class="container-fluid py-3" style="max-width: 500px; min-height: 330px">
                <form id="frm_confirm" class="text-center">
                    <input type="text" id="color" name="color" />
                    <div id="colorpicker"></div>

                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary btn-min-w">
                            <spring:message code='button.apply' />
                        </button>
                        <button type="button" onclick="changeMapBackgroundAction('')" class="btnDelete btn btn-danger btn-min-w">
                            <spring:message code='button.delete' />
                        </button>
                    </div>
                </form>
            </div>
        </c:when>

        <c:when test="${type == 'image'}">
            <form id="frm_confirm" class="text-center">
                <div class="navbar navbar-light bg-white border-bottom">
                    <div class="input-group">
                        <input type="text" autofocus class="form-control shadow-none border-0 bg-light" id="jino_input_img_url" name="jino_input_img_url" placeholder="<spring:message code='common.url' />">
                        <div class="input-group-append">
                            <button class="btn btn-light shadow-none border-0 bg-light" type="button" onclick="showImage()">
                                <img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
                            </button>
                        </div>
                    </div>
                </div>
                <div id="main-container" class="container-fluid py-3 text-center">
                    <div id="fileupload" class="mx-auto fileupload-thumbnail position-relative d-inline-block">
                        <img id="fileupload_img" src="${pageContext.request.contextPath}/theme/dist/images/default-image-upload.png" class="img-thumbnail" style="max-height: 300px;">
                        <div class="fileupload-thumbnail-backdrop position-absolute top-0 left-0 w-100 h-100 rounded text-white d-flex align-items-center justify-content-center">
                            <div>
                                <img src="${pageContext.request.contextPath}/theme/dist/images/icons/upload-w.svg" width="60px">
                                <h6>
                                    <spring:message code='common.choose_file' />
                                </h6>
                                <div class="progress" style="width: 200px;">
                                    <div id="fileupload_progress" class="progress-bar progress-bar-striped progress-bar-animated h-100" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
                                </div>
                            </div>
                        </div>
                        <input id="fileupload_input" type="file" accept="image/png, image/jpeg" capture="camera" class="position-absolute top-0 left-0 w-100 h-100" />
                    </div>
                </div>
                <div class="text-center p-3">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code='button.apply' />
                    </button>
                    <button type="button" onclick="changeMapBackgroundAction('')" class="btnDelete btn btn-danger btn-min-w">
                        <spring:message code='button.delete' />
                    </button>
                </div>
            </form>
        </c:when>
    </c:choose>
</body>

</html>