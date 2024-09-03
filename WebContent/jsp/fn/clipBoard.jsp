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
    <c:set var="locale" value="es" />
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
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
    <!-- Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>" />
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

    <title>
      <spring:message code='menu.import' />
    </title>

    <script type="text/javascript">
      function setMenuActions(action, menus) {
        $.each(menus, function (idx, menu) {
          if (action) {
            $('.' + menu).prop('disabled', false);
            $('.' + menu).attr('onclick', 'parent.' + menu + '()');
          } else {
            $('.' + menu).prop('disabled', true);
            $('.' + menu).attr('onclick', '');
          }
        });
      }

      const tierpolicy = {
        nodeStructureFromXml: 'import_xml',
        nodeStructureFromText: 'import_text',
        importBookmark: 'import_bookmark',
        importMap: 'import_freemind',
      };

      function setTierPolicy() {
        var policy_class = Object.keys(tierpolicy);
        for (var i = 0, len = policy_class.length; i < len; i++) {
          var el = $('.' + policy_class[i]);
          var policy_key = tierpolicy[policy_class[i]];
          var policy = parent.getUserPolicy();
          if (policy[policy_key] == undefined) {
            el.addClass('need-upgrade');
            if (el.attr('onclick') == undefined) {
              el.click(function () {
                parent.showUpgradeTierDialog();
              });
            }
          }
        }
      }

      $(document).ready(function () {
        if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';

        setMenuActions(parent.jMap.cfg.canEdit, ['importBookmark', 'importMap', 'importZipMap']);
        /* setMenuActions(parent.jMap.getSelected() != null, ['nodeStructureFromText', 'nodeStructureFromXml']); */
				
				setTierPolicy();
			});
    </script>
  </head>

  <body>
    <div class="container-fluid py-1">
      <%-- <button type="button" class="nodeStructureFromXml btn btn-light p-3 shadow-none m-1" style="min-width: 130px;">
        <img src="${pageContext.request.contextPath}/images/wedorang/xmlicon.png" width="40px" class="d-block mx-auto" />
        <small>
          <spring:message code="menu.xmlimportexport.import" />
        </small>
      </button>

      <button type="button" class="nodeStructureFromText btn btn-light p-3 shadow-none m-1" style="min-width: 130px;">
        <img src="${pageContext.request.contextPath}/images/wedorang/cliptexticon.png" width="40px" class="d-block mx-auto" />
        <small>
          <spring:message code="menu.textimportexport.import" />
        </small>
      </button> --%>

      <button type="button" class="importBookmark btn btn-light p-3 shadow-none m-1" style="min-width: 130px;">
        <img src="${pageContext.request.contextPath}/images/icons/bookmark.png" width="40px" class="d-block mx-auto" />
        <small>
          <spring:message code="menu.plugin.bookmark" />
        </small>
      </button>

      <button type="button" class="importMap btn btn-light p-3 shadow-none m-1" style="min-width: 130px;">
        <img src="${pageContext.request.contextPath}/images/icons/freemind.png" width="40px" class="d-block mx-auto" />
        <small>
          <spring:message code="common.freemind" />
        </small>
      </button>
      
      <button type="button" class="importZipMap btn btn-light p-3 shadow-none m-1" style="min-width: 130px;">
        <img src="${pageContext.request.contextPath}/theme/dist/images/icons/user_data.png" width="40px" class="d-block mx-auto" />
        <small>
          <spring:message code="message.import.zipmaps" />
        </small>
      </button>
      
    </div>
  </body>
</html>
