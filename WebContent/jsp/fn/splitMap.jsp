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

    <script defer src="${pageContext.request.contextPath}/lib/Base64.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

    <title>
        <spring:message code='menu.mindmap.newnodemap' />
    </title>

    <script type="text/javascript">
        var loading = false;
        var node = null;

        function isDuplicateMapName(mapTitle) {
            var params = {
                "mapTitle": mapTitle
            };
            var returnV = false;
            $.ajax({
                type: 'post',
                url: "${pageContext.request.contextPath}/mindmap/isDuplicateMapName.do",
                dataType: 'json',
                data: params,
                async: false,
                success: function (data) {
                    if (data.status == "ok") {
                        returnV = true;
                    } else {
                        returnV = false;
                    }
                }
            }
            );
            return returnV;
        }

        function onSplitMap(data, textStatus, jqXHR) {
            var url = data.url;
            node.setHyperlink(url);

            var children = node.getChildren();
            if (children.length > 0) {
                for (var k = children.length - 1; k >= 0; k--) {
                    children[k].remove();
                }
            }

            parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors(node);
            parent.jMap.layoutManager.layout(true);

            parent.JinoUtil.closeDialog();
        }

        function splitMap() {
            var title = $('#splitmap_title').val();

            if (!isDuplicateMapName(title)) {
                alert("<spring:message code='message.mindmap.new.duplicate.mapName'/>");
                $("#splitmap_title").focus();
                return false;
            }

            if (title != "") {
                node.setFoldingExecute(false);

                loading = true;
                $('.btn').prop('disabled', true);

                var params = {
                    "title": title,
                    "xml": Base64.encode(escape(node.toXML())),
                    "link": parent.document.location.href
                };
                $.ajax({
                    type: 'post',
                    dataType: 'json',
                    async: false,
                    url: '${pageContext.request.contextPath}/mindmap/splitMap.do',
                    data: params,
                    success: onSplitMap,
                    error: function (data, status, err) {
                        alert("splitMap error : " + status);
                        loading = false;
                        $('.btn').prop('disabled', false);
                    }
                });
            } else {
                alert("<spring:message code='map.new.enter_title'/>");
                $("#splitmap_title").focus();
            }
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';

            node = parent.jMap.getSelected();

            $('#splitmap_title').val(node.getText());
            $('#splitmap_title').select();

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                if (!loading && node != null) splitMap();
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <div class="mx-auto" style="max-width: 300px;">
            <form id="frm_confirm">
                <div class="form-group">
                    <label>
                        <spring:message code='common.title' />
                    </label>
                    <input type="text" autofocus required class="form-control" id="splitmap_title">
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