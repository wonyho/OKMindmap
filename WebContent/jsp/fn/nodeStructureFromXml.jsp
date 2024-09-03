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

    <script defer src="${pageContext.request.contextPath}/lib/conversionfunctions.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

    <title>
        <spring:message code='common.import_xml' />
    </title>

    <script type="text/javascript">
        function nodeStructureFromXml(xmlStr) {
            var node = parent.jMap.getSelected();
            if (!node || xmlStr == '') return;

            xmlStr = xmlStr.replace(/&/g, '&amp;');
			// & < > 는 매칭이 되는데 "는 매칭할 방법이 없다.. 그래서 다음같은 표현식에서 바꾼다. 			
			// /(TEXT=")([^"]*)/ig
			// 아래와 같은 표현식은 정말이지 정말 안좋은 방법이다.
			var re = /(TEXT=")(.*)(" FOLDED=)/ig;			
			xmlStr = xmlStr.replace (re, function () {
				var matchTag = arguments[1];
				var matchText = convertXML2Char(arguments[2]);
				var matchOther = arguments[3];
				return matchTag+matchText+matchOther;
			});
			re = /(LINK=")([^"]*)/ig;
			xmlStr = xmlStr.replace (re, function () {
				var matchTag = arguments[1];
				var matchText = convertXML2Char(arguments[2]);
				return matchTag+matchText;
			});
			
			// position 삭제			
			xmlStr = xmlStr.replace (/ POSITION="[^"]*"/ig, "");
			var pasteNodes = parent.jMap.loadManager.pasteNode(node, xmlStr);
			var postPasteProcess = function() {
				// 저장
				var nodeLength = pasteNodes.length;
				for (var i = 0; i < nodeLength; i++) {
					parent.jMap.saveAction.pasteAction(pasteNodes[i]);
				}
				
				// 이벤트 리스너 호출
				parent.jMap.fireActionListener(parent.ACTIONS.ACTION_NODE_PASTE, node, xmlStr);
				
				parent.jMap.initFolding(node);
				parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfDescendantsAndAncestors(node);
				parent.jMap.layoutManager.layout(true);
			}
			
			if(parent.jMap.loadManager.imageLoading.length == 0) {
				postPasteProcess();
			} else {
				var loaded = parent.jMap.addActionListener(parent.ACTIONS.ACTION_NODE_IMAGELOADED, function(){
					postPasteProcess();
					// 이미지로더 리스너는 삭제!!! 중요.
					parent.jMap.removeActionListener(loaded);
				});
            }
            
            // parent.JinoUtil.closeDialog();
            alert("<spring:message code='confirm.success' />");
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                nodeStructureFromXml($('#okm_node_structure_textarea').val());
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid p-3">
        <div class="mx-auto">
            <form id="frm_confirm">
                <div class="form-group">
                    <textarea required autofocus class="form-control" id="okm_node_structure_textarea" name="okm_node_structure_textarea" rows="10"></textarea>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code='button.apply' />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>