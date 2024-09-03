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
        <spring:message code='message.mindmap.embed.setting' />
    </title>

    <script type="text/javascript">
        function EmbedTag_create() {
            var mapKey = parent.jMap.cfg.mapKey;
            var onMenu = $('#menu').is(':checked') ? "on" : "off";
            var onGoogle = $('#google').is(':checked') ? "on" : "off";
            var passwd = (EmbedTag_trim($('#password').val()).length > 0) ? "&password=" + EmbedTag_trim($('#password').val()) : "";
            var d = parent.document;
            var url_prefix = d.location.protocol + '//' + d.location.host + parent.jMap.cfg.contextPath;
            var code = '<iframe src="' + url_prefix + '/map/' + mapKey + '?m=' + onMenu + '&g=' + onGoogle + passwd + '" width="' + $('#width').val() + '" height="' + $('#height').val() + '" frameborder="0"  ></iframe>';

            var textarea = $('textarea#embedcode')[0];
            textarea.value = code;
            textarea.select();
            document.execCommand('copy');
        }
        function EmbedTag_trim(str) {
            return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                EmbedTag_create();
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid p-3">
        <div class="mx-auto">
            <form id="frm_confirm">
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label>
                                <spring:message code='common.width' />
                            </label>
                            <input type="number" required min="1" value="640" class="form-control" id="width">
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label>
                                <spring:message code='common.height' />
                            </label>
                            <input type="number" required min="1" value="480" class="form-control" id="height">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" id="menu">
                                <label class="custom-control-label" for="menu">
                                    <spring:message code='message.mindmap.embed.menuview' />
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" id="google">
                                <label class="custom-control-label" for="google">
                                    <spring:message code='message.mindmap.embed.google' />
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label>
                        <spring:message code="message.mindmap.embed.password" />
                    </label>
                    <input type="text" class="form-control" id="password">
                </div>
                <div class="form-group">
                    <label>
                        <spring:message code="message.mindmap.embed.code" />
                    </label>
                    <textarea onfocus="this.select()" class="form-control" id="embedcode" rows="5"></textarea>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code="message.mindmap.embed.newcode" />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>