<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    request.setAttribute("user", session.getAttribute("user"));
%>

<style>
    html,
    body {
        height: 100%;
    }

    body {
        display: -ms-flexbox;
        display: flex;
        -ms-flex-align: center;
        align-items: center;
        padding-top: 40px;
        padding-bottom: 40px;

        background-image: url('${pageContext.request.contextPath}/theme/dist/images/cefapp_bg.svg');
        background-position: bottom;
        background-repeat: no-repeat;
        background-size: contain;
    }
</style>
<style>.img_lang{width: 30px;height: 20px;margin: 0px 10px 0 0;}</style>
<script type="text/javascript">
    var okmNoticeAction = function (check) {
		check = typeof check !== 'undefined' ? check : true;
		$.ajax({
			url: '${pageContext.request.contextPath}/mindmap/admin/notice/okmNotice.do?func=view',
			dataType: "json",
			cache: false,
			async: false,
			success: function (data) {
				var notices = data[0].notices;
                var updateItemTemplate = $('#update-item-template').html();
                var notice = "";
                for (var i = notices.length - 1; i >= 0; i--) {
                    var n = notices[i];
                    if (typeof n == 'undefined') continue;
                    var locale = "content_${locale}";
                    if(n[locale] == undefined) locale = "content_en";
                    var title = n[locale];
                    var item = updateItemTemplate;
                    var hyperlink = '';
                    if (n["link_${locale}"]) hyperlink = '<a class="text-decoration-none text-body" href="' + n["link_${locale}"] + '" target="_blank"><img src="${pageContext.request.contextPath}/theme/dist/images/icons/link.svg" width="18px" class="ml-1"></a>';
                    item = item.replace('[title]', title + hyperlink);
                    notice = notice + item;
                }

                $('#update-list').html(notice);
			}
		});
    };
    
    $(document).ready( function() {
        okmNoticeAction();
    });
</script>

<div class="container m-auto p-3">
    <div class="row">
        <div class="col-lg-7 col-sm-12">
            <img src="${pageContext.request.contextPath}/theme/dist/images/map-type-logo.png" width="150px">
            <div class="row mt-5 mx-1 mb-1">
                <div class="col">
                    <div class="text-secondary font-weight-bold h4">
                        <spring:message code='admin.okm_notice.okm_notice_title' />
                    </div>
                </div>
                <div class="col-2 text-right">
                    <b class="d-none">+더보기</b>
                </div>
            </div>

            <ul class="list-group list-group-flush mb-3" id="update-list">
                
            </ul>

            <div class="dropdown mb-3">
                <button class="btn btn-light dropdown-toggle" type="button" data-toggle="dropdown">
					<c:if test='${locale =="en"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/usa.png"></c:if>
					<c:if test='${locale =="es"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/Espanol.svg"></c:if>
					<c:if test='${locale =="ko"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/korea.webp"></c:if>
					<c:if test='${locale =="vi"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/vietnam.webp"></c:if>
					<spring:message code="menu.select.lang.${locale}" text="English" /></a>
				</button>
				<div class="dropdown-menu dropdown-menu-xl-right">
					<a class="dropdown-item" href="#" onclick="changeLanguage('en')">
						<img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/usa.png"><spring:message code='menu.select.lang.en' /></a>
					<a class="dropdown-item" href="#" onclick="changeLanguage('es')">
						<img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/Espanol.svg"><spring:message code='menu.select.lang.es' /></a>
					<a class="dropdown-item" href="#" onclick="changeLanguage('ko')">
						<img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/korea.webp"><spring:message code='menu.select.lang.ko' /></a>
					<a class="dropdown-item" href="#" onclick="changeLanguage('vi')">
						<img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/vietnam.webp"><spring:message code='menu.select.lang.vi' /></a>
				</div>
            </div>
        </div>
        <div class="col-lg-5 col-sm-12 mx-auto" style="max-width: 400px;">
            <div class="shadow p-3 rounded border bg-white">

                <c:choose>
                    <c:when test="${user == null || user.username == 'guest'}">
                        <iframe class="d-block mx-auto" src="${pageContext.request.contextPath}/user/login.do"
                            width="100%" onload="onLoadIFrame(this)" frameborder="0"></iframe>
                    </c:when>
                    <c:otherwise>
                        <div class="p-3 mb-3">
                            <img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 128px; height: 128px;" class="d-block mx-auto rounded-circle">
                            <h4 class="text-center font-weight-bold mt-3">
                                <c:out value="${user.firstname}" />
                            </h4>
                        </div>
                        <a href="${pageContext.request.contextPath}/index.do"
                            class="btn btn-secondary btn-block rounded-0 btn-lg">
                            <spring:message code='common.getstarted' />
                            <img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-right-w.svg"
                                class="ml-2" width="24px">
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<template id="update-item-template">
    <li class="list-group-item">
        [title]
    </li>
</template>