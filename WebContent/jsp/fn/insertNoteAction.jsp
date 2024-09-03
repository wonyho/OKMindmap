<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    Boolean showNote = "true".equals(request.getParameter("show"));
    request.setAttribute("showNote", showNote);

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
        <spring:message code='menu.insertNoteAction' />
    </title>

    <script type="text/javascript">
        const showNote = '${showNote}';

        function insertNoteAction(node) {
            var selected = parent.jMap.getSelected();
            if (!selected) return;

            selected.setNote(node || '');
            parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(selected);
            parent.jMap.layoutManager.layout(true);
            parent.JinoUtil.closeDialog();
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            var selected = parent.jMap ? parent.jMap.getSelected() : null;
            if (selected) {
                var noteText = selected.note && selected.noteText;
                $('#jino_input_note').val(noteText || "");

                if (showNote == 'true') $('#jino_input_note').prop('readonly', true);
            }

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                if (showNote == 'false') insertNoteAction($('#jino_input_note').val());
            });
        });
    </script>
</head>

<body>
    <div class="container-fluid p-3">
        <div class="mx-auto">
            <form id="frm_confirm">
                <div class="form-group">
                    <textarea required class="form-control" id="jino_input_note" name="jino_input_note" rows="5"></textarea>
                </div>

                <div class="text-center">
                    <c:choose>
                        <c:when test="${showNote}">
                            <button type="button" class="btn btn-dark btn-min-w" onclick="parent.JinoUtil.closeDialog()">
                                <spring:message code='button.close' />
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="btn btn-primary btn-min-w">
                                <spring:message code='button.apply' />
                            </button>
                            <button type="button" onclick="insertNoteAction()" class="btn btn-danger btn-min-w">
                                <spring:message code='button.delete' />
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>
    </div>

</body>

</html>