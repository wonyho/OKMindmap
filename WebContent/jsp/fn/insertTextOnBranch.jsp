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
        <spring:message code='dialog.textOnBranch' />
    </title>

    <script type="text/javascript">
        var insertTextOnBranchAction = function (text) {
            var selected = parent.jMap.getSelected();
            if (!selected) return;

            selected.setAttributeExecute("branchText", text);
            parent.jMap.fireActionListener(parent.ACTIONS.ACTION_NODE_BRANCH_TEXT, selected);
			parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(selected);
			parent.jMap.layoutManager.layout(true);
            parent.jMap.saveAction.editAction(selected);
            parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            var selected = parent.jMap.getSelected();
            if(selected) {
                var branch_text = selected.attributes && selected.attributes['branchText'];
	            branch_text = branch_text || "";
                $('#jino_input_branch_text').val(branch_text);
            }

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                insertTextOnBranchAction($('#jino_input_branch_text').val());
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <div class="mx-auto" style="max-width: 300px;">
            <form id="frm_confirm">
                <div class="form-group">
                    <label for="jino_input_branch_text">
                        <spring:message code='dialog.textOnBranch' />
                    </label>
                    <input type="text" autofocus required class="form-control" id="jino_input_branch_text">
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-min-w">
                        <spring:message code='button.apply' />
                    </button>
                    <button type="button" onclick="insertTextOnBranchAction(undefined)" class="btn btn-danger btn-min-w">
                        <spring:message code='button.delete' />
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>

</html>