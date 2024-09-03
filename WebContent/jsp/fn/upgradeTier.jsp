<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ page import="java.util.Locale"%> <%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%> <%@ page import="com.okmindmap.configuration.Configuration"%> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> <% long updateTime = 0l; if (Configuration.getBoolean("okmindmap.debug")) { updateTime = System.currentTimeMillis() / 1000; } else { updateTime = Configuration.getLong("okmindmap.update.version"); } %>

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
      Upgrade to Premium
    </title>

    <script type="text/javascript">
      $(document).ready(function () {
        if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
      });
    </script>
  </head>

  <body>
    <div class="container-fluid py-1">
      <div class="pricing-header px-3 py-3 pb-md-4 mx-auto text-center">
        <h1 class="display-4">Pricing</h1>
        <p class="lead">Upgrade your account now to experience the many benefits of Premium.</p>
      </div>

      <div class="card-deck mb-3 text-center">
        <div class="card mb-4 shadow-sm" style="border-color: #718096 !important;">
          <div class="card-header" style="border-color: #718096 !important; background-color: #718096 !important;">
            <h4 class="my-0 font-weight-normal text-white">Free</h4>
          </div>
          <div class="card-body">
            <h1 class="card-title pricing-card-title">$0 <small class="text-muted">/ mo</small></h1>
            <ul class="list-unstyled mt-3 mb-4">
              <li>05 Map Creation & manipulation</li>
              <li>05 Remix map</li>
              <li>03 IOT devices</li>
              <li>02 Map styles</li>
              <li>02 Presentation styles</li>
            </ul>
          </div>
        </div>
        <div class="card mb-4 shadow-sm" style="border-color: #ecc94b !important;">
          <div class="card-header" style="border-color: #ecc94b !important; background-color: #ecc94b !important;">
            <h4 class="my-0 font-weight-normal text-white">Standard</h4>
          </div>
          <div class="card-body">
            <h1 class="card-title pricing-card-title">$15 <small class="text-muted">/ mo</small></h1>
            <ul class="list-unstyled mt-3 mb-4">
              <li>100 Map Creation & manipulation</li>
              <li>20 Remix map</li>
              <li>02 Moodle courses hosting</li>
              <li>10 IOT devices</li>
              <li>04 Map styles</li>
              <li>04 Presentation styles</li>
            </ul>
            <button type="button" class="btn btn-lg btn-block btn-primary" style="border-color: #ecc94b !important; background-color: #ecc94b !important;" disabled>Upgrade now</button>
          </div>
        </div>
        <div class="card mb-4 shadow-sm" style="border-color: #4fd1c5 !important;">
          <div class="card-header" style="border-color: #4fd1c5 !important; background-color: #4fd1c5 !important;">
            <h4 class="my-0 font-weight-normal text-white">Enterprise</h4>
          </div>
          <div class="card-body">
            <h1 class="card-title pricing-card-title">$29 <small class="text-muted">/ mo</small></h1>
            <ul class="list-unstyled mt-3 mb-4">
              <li>500 Map Creation & manipulation</li>
              <li>100 Remix map</li>
              <li>05 Moodle courses hosting</li>
              <li>50 IOT devices</li>
              <li>All map styles</li>
              <li>All presentation styles</li>
            </ul>
            <button type="button" class="btn btn-lg btn-block btn-primary" style="border-color: #4fd1c5 !important; background-color: #4fd1c5 !important;" disabled>Upgrade now</button>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
