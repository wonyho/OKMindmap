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
        <spring:message code='menu.insertLTIAction' />
    </title>

    <script type="text/javascript">
        var insertLTIAction = function (insert) {
            var node = parent.jMap.getSelected();
            if (!node) return;

            var url = $('#url').val();
            var secret = $('#secret').val();
            /* var key = $('#key').val(); */

            if (insert && url != '') {
                node.attributes['url'] = url;
                node.attributes['secret'] = secret;
                /* node.attributes['key'] = key; */
                node.setHyperlink(parent.jMap.cfg.contextPath + '/mindmap/launch.do?' + 'map=' + parent.mapId + '&node=' + node.getID());
            } else {
                delete node.attributes.url;
                delete node.attributes.secret;
                /* delete node.attributes.key; */
                node.setHyperlink(null);
            }

            parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
            parent.jMap.layoutManager.layout(true);
            parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            var node = parent.jMap ? parent.jMap.getSelected() : null;
            if (node) {
                if (!node.attributes) node.attributes = {};
                var url = node.attributes['url'] || "http://";
                var secret = node.attributes['secret'] || "";
                /* var key = node.attributes['key'] || ""; */

                $('#url').val(url);
                $('#secret').val(secret);
                /* $('#key').val(key); */
                if(url == "http://" || url == "" || url == " "){
                	$(".viewScore").addClass("d-none");
                }
            }

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                insertLTIAction(true);
            });
            
            $("#viewScore").click(function(e){
            	e.preventDefault();
            	
            	if($("#checkAll").prop('checked')){
            		var murl = parent.jMap.cfg.contextPath + '/mindmap/lisAllNodesScore.do?' + 'map=' + parent.mapId + 
        			'&calAction=' + $("#calAction").val() + 
        			'&viewMode=' + $("#viewMode").val();
            		window.open(murl, '_blank');
            		return;
            	}
            	
            	var node = parent.jMap.getSelected();
                if (!node) return;

            	var url = parent.jMap.cfg.contextPath + '/mindmap/lisAllScore.do?' + 'map=' + parent.mapId + 
            			'&node=' + node.getID() + '&calAction=' + $("#calAction").val() + 
            			'&viewMode=' + $("#viewMode").val();
            	window.open(url, '_blank');
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <div class="mx-auto" style="max-width: 360px;">
            <form id="frm_confirm">
                <div class="form-group">
                    <label for="url">
                        <spring:message code='common.launch_url' />
                    </label>
                    <input type="url" autofocus required class="form-control" id="url">
                </div>

                <div class="form-group">
                    <label for="secret">
                        <spring:message code='common.secret_value' />
                    </label>
                    <input type="text" required class="form-control" id="secret">
                </div>

                <%-- <div class="form-group">
                    <label for="key">
                        <spring:message code='common.key_value' />
                    </label>
                    <input type="text" required class="form-control" id="key">
                </div> --%>
				<div class="form-group viewScore">
                    <label for="key">
                        <spring:message code='common.calAction' />
                    </label>
                    <select class="custom-select col" id="calAction">
					    <option value="last" selected>Last update</option>
					    <option value="max">Maximum</option>
					    <option value="average">Average</option>
				  	</select>
                </div>
                <div class="form-group viewScore">
                    <label for="key">
                        <spring:message code='common.viewMode' />
                    </label>
                    <select class="custom-select col" id="viewMode">
					    <option value="html" selected>Html</option>
					    <!-- <option value="map">Mindmap</option>
					    <option value="csv">CSV</option> -->
				  	</select>
                </div>
                <div class="form-group viewScore mx-2">
                    <input type="checkbox" class="form-check-input" id="checkAll">
    				<label class="form-check-label" for="checkAll">View all LTI nodes</label>
                </div>
                <div class="text-center mt-4">
                	<button type="button" class="btn btn-info viewScore" id="viewScore">
                        <spring:message code='button.viewScore' />
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <spring:message code='button.apply' />
                    </button>
                    <button type="button" onclick="insertLTIAction(false)" class="btn btn-danger">
                        <spring:message code='button.delete' />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>