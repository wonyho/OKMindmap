<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    request.setAttribute("user", session.getAttribute("user"));
%>
<style>.img_lang{width: 30px;height: 20px;margin: 0px 10px 0 0;}</style>
<header>
    <nav class="navbar navbar-expand-lg navbar-light fixed-top bg-white shadow">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}">
                <img src="${pageContext.request.contextPath}/theme/dist/images/logo.png" height="34px"
                    style="margin-top: -4px;">
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse"
                aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item mx-2 active">
                        <a class="nav-link text-dark font-weight-bold" href="#">마인드맵 소개 <span
                                class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item mx-2">
                        <a class="nav-link text-dark" href="#">활용하기</a>
                    </li>
                    <li class="nav-item mx-2">
                        <a class="nav-link text-dark" href="#">이용 및 제휴 문의</a>
                    </li>
                    <li class="nav-item mx-2">
                        <a class="nav-link text-dark" href="#">마인드</a>
                    </li>
                    <li class="nav-item mx-2">
                        <a class="nav-link text-secondary font-weight-bold"
                            href="${pageContext.request.contextPath}/index.do">마인드맵 시작하기</a>
                    </li>
                </ul>
                <div class="mx-2 my-3 my-lg-0">
                    <c:choose>
                        <c:when test="${user == null || user.username == 'guest'}">
                            <div class="dropdown d-none d-lg-block d-xl-block dropdown-iframe">
                                <button class="btn btn-secondary dropdown-toggle"
                                    data-toggle="dropdown">
                                    <spring:message code="message.login" /> / <spring:message code="message.member.new" />
                                </button>
                                <div class="dropdown-menu dropdown-menu-right">
                                    <form style="width: 350px;">
                                        <iframe class="d-block mx-auto"
                                            data-src="${pageContext.request.contextPath}/user/login.do" width="100%"
                                            onload="onLoadIFrame(this)" frameborder="0"></iframe>
                                    </form>
                                </div>
                            </div>

                            <button type="button" class="btn btn-secondary d-lg-none d-xl-none"
                                data-toggle="modal" data-target="#login-signup">
                                <spring:message code="message.login" /> / <spring:message code="message.member.new" />
                            </button>
                        </c:when>
                        <c:otherwise>
                            <div class="dropdown">
                                <button type="button"
                                    class="btn btn-light px-2 py-1 rounded dropdown-toggle after-content-none"
                                    data-toggle="dropdown">
                                    <img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 26px; height: 26px;" class="rounded-circle mr-1">
                                    <c:out value="${user.firstname}" />
                                </button>
                                <div class="dropdown-menu dropdown-menu-right" style="min-width: 200px;">
                                    <div class="p-3">
                                        <img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 64px; height: 64px;" class="d-block mx-auto rounded-circle">

                                        <div class="text-center font-weight-bold mt-3 h6">
                                            <c:out value="${user.firstname}" />
                                        </div>
                                    </div>
                                    <a class="dropdown-item" href="#" data-toggle="modal" data-target="#user-info">
                                        <img src="${pageContext.request.contextPath}/theme/dist/images/icons/home.svg"
                                            width="18px" class="mr-3 mb-1">
                                        <spring:message code="message.editprofile"/>
                                    </a>
                                    <c:if test="${user.username == 'admin'}">
										<a class="dropdown-item" href="${pageContext.request.contextPath}/mindmap/admin/index.do">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/settings.svg" width="18px" class="mr-3 mb-1">
											<spring:message code="message.admin" />
										</a>
									</c:if>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item text-danger" href="#" onclick="okmLogout();">
                                        <img src="${pageContext.request.contextPath}/theme/dist/images/icons/log-out.svg"
                                            width="18px" class="mr-3 mb-1">
                                        <spring:message code="message.logout"/>
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mx-2 my-3 my-lg-0">
                    <div class="dropdown">
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
            </div>
        </div>
    </nav>
</header>

<c:choose>
    <c:when test="${user == null || user.username == 'guest'}">
        <!-- Modal #login-signup -->
        <div class="modal fade modal-iframe" id="login-signup" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="m-2">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body pt-0">
                        <iframe class="d-block mx-auto" data-src="${pageContext.request.contextPath}/user/login.do"
                            width="100%" onload="onLoadIFrame(this)" frameborder="0"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <!-- Modal #user-info -->
        <div class="modal fade modal-iframe" id="user-info" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="m-2">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <iframe class="d-block mx-auto" data-src="${pageContext.request.contextPath}/user/update.do"
                            width="100%" onload="onLoadIFrame(this)" frameborder="0"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<main role="main">
    <div id="main-slideshow" class="carousel slide" data-ride="carousel">
        <ol class="carousel-indicators">
            <li data-target="#main-slideshow" data-slide-to="0" class="active"></li>
            <li data-target="#main-slideshow" data-slide-to="1"></li>
            <li data-target="#main-slideshow" data-slide-to="2"></li>
            <li data-target="#main-slideshow" data-slide-to="3"></li>
            <li data-target="#main-slideshow" data-slide-to="4"></li>
        </ol>
        <div class="carousel-inner">
        
            <div style="height: 28rem;" class="carousel-item active">
				<svg class="bd-placeholder-img" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
                    preserveAspectRatio="xMidYMid slice" focusable="false" role="img">
                    <rect width="100%" height="100%" fill="#ee7476" /></svg>
                <div class="container-fluid">
                    <div class="carousel-caption text-left">
                        <div class="mx-2 my-3 rounded-0 cursor-pointer border-0" data-toggle="modal"
		                    data-target=".widget1-modal">
		                    <div class="card-body p-0 row h-100 justify-content-center align-items-center">
		                    	<div class="col-md-6 col-12">
		                    		<img src="${pageContext.request.contextPath}/theme/dist/images/widget1.png" height="250px">
		                    	</div>
		                    	<div class="col-md-6 col-12">
			                    	<div class="card-title font-weight-bold h4">멀티 미디어 콘텐츠</div>
			                        <p class="card-text">이미지, 동영상, 웹페이지로 구성한 나만의 멀티미디어 콘텐츠를 맵의 마디로 구성하여 만드세요.</p>
		                    	</div>
		                    </div>
		                </div>
                    </div>
                </div>
            </div>
            
            <div style="height: 28rem;" class="carousel-item">
            	<svg class="bd-placeholder-img" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
                    preserveAspectRatio="xMidYMid slice" focusable="false" role="img">
                    <rect width="100%" height="100%" fill="#ee7476" /></svg>
                <div class="container-fluid">
                    <div class="carousel-caption text-left">
                        <div class="mx-2 my-3 rounded-0 cursor-pointer border-0" data-toggle="modal"
		                    data-target=".widget2-modal">
		                    <div class="card-body p-0 row h-100 justify-content-center align-items-center">
		                    	<div class="col-md-6 col-12">
		                    		<img src="${pageContext.request.contextPath}/theme/dist/images/widget2.png" height="250px">
		                    	</div>
		                    	<div class="col-md-6 col-12">
			                        <div class="card-title font-weight-bold h4">프레젠테이션</div>
			                        <p class="card-text">맵을 PPT로 한번에 변환하고 프레지 같은 스타일의 발표도 해보세요.</p>
		                    	</div>
		                    </div>
		                </div>
                    </div>
                </div>
            </div>
            
            <div style="height: 28rem;" class="carousel-item">
            	<svg class="bd-placeholder-img" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
                    preserveAspectRatio="xMidYMid slice" focusable="false" role="img">
                    <rect width="100%" height="100%" fill="#ee7476" /></svg>
                <div class="container-fluid">
                    <div class="carousel-caption text-left">
                        <div class="mx-2 my-3 rounded-0 cursor-pointer border-0" data-toggle="modal"
		                    data-target=".widget3-modal">
		                    <div class="card-body p-0 row h-100 justify-content-center align-items-center">
		                    	<div class="col-md-6 col-12">
		                    		<img src="${pageContext.request.contextPath}/theme/dist/images/widget3.png" height="250px">
		                    	</div>
		                    	<div class="col-md-6 col-12">
			                    	<div class="card-title font-weight-bold h4">협업 플랫폼</div>
                        			<p class="card-text">동료들과 같이 브라우저를 사용하여 협업으로 지식을 쌓아 놓으세요.</p>
		                    	</div>
		                    </div>
		                </div>
                    </div>
                </div>
            </div>
            
            <div style="height: 28rem;" class="carousel-item">
            	<svg class="bd-placeholder-img" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
                    preserveAspectRatio="xMidYMid slice" focusable="false" role="img">
                    <rect width="100%" height="100%" fill="#ee7476" /></svg>
                <div class="container-fluid">
                    <div class="carousel-caption text-left">
                        <div class="mx-2 my-3 rounded-0 cursor-pointer border-0" data-toggle="modal"
		                    data-target=".widget4-modal">
		                    <div class="card-body p-0 row h-100 justify-content-center align-items-center">
		                    	<div class="col-md-6 col-12">
		                    		<img src="${pageContext.request.contextPath}/theme/dist/images/widget4.png" height="250px">
		                    	</div>
		                    	<div class="col-md-6 col-12">
			                    	<div class="card-title font-weight-bold h4">학습 콘텐츠</div>
                        			<p class="card-text">퀴즈, 상호평가, 과제 제출등 학습 관리시스템의 기능을 추가하세요.</p>
		                    	</div>
		                    </div>
		                </div>
                    </div>
                </div>
            </div>
            
            <div style="height: 28rem;" class="carousel-item">
            	<svg class="bd-placeholder-img" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
                    preserveAspectRatio="xMidYMid slice" focusable="false" role="img">
                    <rect width="100%" height="100%" fill="#ee7476" /></svg>
                <div class="container-fluid">
                    <div class="carousel-caption text-left">
                        <div class="mx-2 my-3 rounded-0 cursor-pointer border-0" data-toggle="modal"
		                    data-target=".widget5-modal">
		                    <div class="card-body p-0 row h-100 justify-content-center align-items-center">
		                    	<div class="col-md-6 col-12">
		                    		<img src="${pageContext.request.contextPath}/theme/dist/images/widget5.png" height="250px">
		                    	</div>
		                    	<div class="col-md-6 col-12">
			                    	<div class="card-title font-weight-bold h4">IOT, 서비스 허브</div>
                        			<p class="card-text">다양한 IOT로 부터 발생하는 정보나 LTI 서비스 정보를 맵으로 모으세요.</p>
		                    	</div>
		                    </div>
		                </div>
                    </div>
                </div>
            </div>

        </div>
        <a class="carousel-control-prev" href="#main-slideshow" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#main-slideshow" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>
    <!-- .widget1-modal -->
    <div class="modal fade widget1-modal" tabindex="-1" role="dialog" aria-labelledby="widget1-modal"
        aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="bg-secondary rounded-top" style="height: 4px;"></div>
                <div class="modal-header border-bottom-0">
                    <div class="modal-title">
                        <h5 class="font-weight-bold">멀티 미디어 콘텐츠</h5>
                    </div>

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body pt-0">
                    <div class="media d-block d-xl-flex">
                        <img src="${pageContext.request.contextPath}/theme/dist/images/widget1.png"
                            class="mr-3 mx-auto d-block d-xl-auto" width="250px">
                        <div class="media-body">
                            <p>이미지, 동영상, 웹페이지로 구성한 나만의 멀티미디어 콘텐츠를 맵의 마디로 구성하여 만드세요.</p>
                            <p>Tubestory 마디에는 이외에도 웹 링크, 파일, 메모, IOT 데이터등을 넣을 수 있습니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- .widget2-modal -->
    <div class="modal fade widget2-modal" tabindex="-1" role="dialog" aria-labelledby="widget2-modal"
        aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="bg-secondary rounded-top" style="height: 4px;"></div>
                <div class="modal-header border-bottom-0">
                    <div class="modal-title">
                        <h5 class="font-weight-bold">프레젠테이션</h5>
                    </div>

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body pt-0">
                    <div class="media d-block d-xl-flex">
                        <img src="${pageContext.request.contextPath}/theme/dist/images/widget2.png"
                            class="mr-3 mx-auto d-block d-xl-auto" width="250px">
                        <div class="media-body">
                            <p>맵을 PPT로 한번에 변환하고 프레지 같은 스타일의 발표도 해보세요.</p>
                            <p>웹기반에서 13가지 이상의 방식으로 프레젠테이션을 진행할 수 있습니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- .widget3-modal -->
    <div class="modal fade widget3-modal" tabindex="-1" role="dialog" aria-labelledby="widget3-modal"
        aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="bg-secondary rounded-top" style="height: 4px;"></div>
                <div class="modal-header border-bottom-0">
                    <div class="modal-title">
                        <h5 class="font-weight-bold">협업 플랫폼</h5>
                    </div>

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body pt-0">
                    <div class="media d-block d-xl-flex">
                        <img src="${pageContext.request.contextPath}/theme/dist/images/widget3.png"
                            class="mr-3 mx-auto d-block d-xl-auto" width="250px">
                        <div class="media-body">
                            <p>동료들과 같이 브라우저를 사용하여 협업으로 지식을 쌓아 놓으세요.</p>
                            <p>스마트폰, 패드, 컴퓨터등의 다양한 기기에서 실시간으로 맵을 협업으로 만들 수 있습니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- .widget4-modal -->
    <div class="modal fade widget4-modal" tabindex="-1" role="dialog" aria-labelledby="widget4-modal"
        aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="bg-secondary rounded-top" style="height: 4px;"></div>
                <div class="modal-header border-bottom-0">
                    <div class="modal-title">
                        <h5 class="font-weight-bold">학습 콘텐츠</h5>
                    </div>

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body pt-0">
                    <div class="media d-block d-xl-flex">
                        <img src="${pageContext.request.contextPath}/theme/dist/images/widget4.png"
                            class="mr-3 mx-auto d-block d-xl-auto" width="250px">
                        <div class="media-body">
                            <p>퀴즈, 상호평가, 과제 제출등 학습 관리시스템의 기능을 추가하세요.</p>
                            <p>30여가지 이상의 학습활동을 지원하는 Moodle 강의를 맵과 연결하여 블렌디드 러닝이 가능합니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- .widget5-modal -->
    <div class="modal fade widget5-modal" tabindex="-1" role="dialog" aria-labelledby="widget5-modal"
        aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="bg-secondary rounded-top" style="height: 4px;"></div>
                <div class="modal-header border-bottom-0">
                    <div class="modal-title">
                        <h5 class="font-weight-bold">IOT, 서비스 허브</h5>
                    </div>

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body pt-0">
                    <div class="media d-block d-xl-flex">
                        <img src="${pageContext.request.contextPath}/theme/dist/images/widget5.png"
                            class="mr-3 mx-auto d-block d-xl-auto" width="250px">
                        <div class="media-body">
                            <p>다양한 IOT로 부터 발생하는 정보나 LTI 서비스 정보를 맵으로 모으세요.</p>
                            <p>원격지의 카메라와 센서의 내용을 보거나 모터를 제어할 수 있습니다. 또한 LTI를 지원하는 웹 서비스를 쉽게 통합할 수 있습니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
	
	<div class="bg-light my-4">
        <div class="container">
            <div class="text-center h6 mx-auto" style="max-width: 800px;">
                <p class="my-1">Tubestory은 기본적으로 웹 브라우저에서 사용이 가능하며, 윈도우 OS, iOS, Android에 특화된 앱도 추가로 사용할 수 있습니다. 웹 표준을 준수하여 크롬 브라우저에서 가장 완벽하게 운영되나 기타 브라우저에서는 버전별 기능별 제한이 있을 수 있습니다. 그러한 경우에는 환경에 따라 앱을 설치하여 사용하시면 좋습니다.</p>
            </div>

            <div class="row">
            	<div class="col-lg-2"></div>
                <div class="mx-4 my-3 text-center">
                    <img src="${pageContext.request.contextPath}/theme/dist/images/platform-window.png" width="100px"
                        class="mw-100 cursor-pointer" data-toggle="modal" data-target=".platform-window-modal">
                    <div class="font-weight-bold text-center h6 mx-auto"><p class="my-1">Window 7/10</p></div>
                </div>
                <div class="mx-4 my-3 text-center">
                    <img src="${pageContext.request.contextPath}/theme/dist/images/platform-android.png" width="100px"
                        class="mw-100 cursor-pointer" data-toggle="modal" data-target=".platform-android-modal">
                    <div class="font-weight-bold text-center h6 mx-auto"><p class="my-1">Android</p></div>
                </div>
                <div class="mx-4 my-3 text-center">
                    <img src="${pageContext.request.contextPath}/theme/dist/images/platform-ios.png" width="100px"
                        class="mw-100 cursor-pointer" data-toggle="modal" data-target=".platform-ios-modal">
                    <div class="font-weight-bold text-center h6 mx-auto"><p class="my-1">IOS</p></div>
                </div>
                <div class="mx-4 my-3 text-center">
                    <img src="${pageContext.request.contextPath}/theme/dist/images/platform-chrome.png" width="100px"
                        class="mw-100 cursor-pointer" data-toggle="modal" data-target=".platform-chrome-modal">
                    <div class="font-weight-bold text-center h6 mx-auto"><p class="my-1">Chrome Browser</p></div>
                </div>
                <div class="mx-4 my-3 text-center">
                    <img src="${pageContext.request.contextPath}/theme/dist/images/moodle.png" width="100px" height="78px"
                        class="mw-100 cursor-pointer" data-toggle="modal" data-target=".moodle-plugin-modal">
                    <div class="font-weight-bold text-center h6 mx-auto"><p class="my-1">Moodle plugin</p></div>
                </div>
                <div class="col-lg-2"></div>
            </div>
        </div>
    </div>
    <!-- .platform-window-modal -->
    <div class="modal fade platform-window-modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <p>Windows 7, 10 환경에서 시도해 주세요</p>
                    <p>다운로드를 시작하다?</p>
                </div>
                <div class="modal-footer border-0 justify-content-center">
                    <a href="extends/InstallTubestory.zip"><button type="button" class="btn btn-success px-4">확인</button></a>
                    <button type="button" class="btn btn-danger px-4" data-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>
    <!-- .platform-android-modal -->
    <div class="modal fade platform-android-modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <p>안드로이드, iOS의 앱은 모바일만
                        지원 합니다.</p>
                    <p>모바일 디바이스에서 확인해주세요</p>
                </div>
                <div class="modal-footer border-0 justify-content-center">
                    <button type="button" class="btn btn-light px-4" data-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-secondary px-4" disabled>확인</button>
                </div>
            </div>
        </div>
    </div>
    <!-- .platform-ios-modal -->
    <div class="modal fade platform-ios-modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <p>안드로이드, iOS의 앱은 모바일만
                        지원 합니다.</p>
                    <p>모바일 디바이스에서 확인해주세요</p>
                </div>
                <div class="modal-footer border-0 justify-content-center">
                    <button type="button" class="btn btn-light px-4" data-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-secondary px-4" disabled>확인</button>
                </div>
            </div>
        </div>
    </div>
    <!-- .platform-chrome-modal -->
    <div class="modal fade platform-chrome-modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <p>크롬브라우저를 다운로드 받기위해,
                        크롬 다운로드 사이트로 이동합니다.</p>
                    <p>이동 하시겠습니까?</p>
                </div>
                <div class="modal-footer border-0 justify-content-center">
                    <button type="button" class="btn btn-success px-4" data-dismiss="modal" onclick="window.open('https://www.google.com/chrome','_blank');">확인</button>
                    <button type="button" class="btn btn-danger px-4" data-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>
	 <!-- .moodle-plugin-modal -->
    <div class="modal fade moodle-plugin-modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <p>Moodle plugin</p>
                    <p>다운로드를 시작하다?</p>
                </div>
                <div class="modal-footer border-0 justify-content-center">
                    <a href="extends/auth_okmmauth.zip"><button type="button" class="btn btn-success px-4">확인</button></a>
                    <button type="button" class="btn btn-danger px-4" data-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>
    <div class="container my-5">
        <h4 class="font-weight-bold text-secondary my-3">비즈니스 제휴문의</h4>
        <div class="row">
            <div class="col-lg-7 col-12">
                <p>보다 나은 미래를 함께 만들어 나갈 소중한 파트너의 참여를 기다리고 있습니다<br>
                    파트너의 참여를 기다리고 있습니다.</p>
            </div>
            <div class="col-lg-5 col-12">
                <div class="alert alert-danger bg-secondary text-white border-0 text-center" role="alert">
                    전화 문의 및 상담 <b>10:00 ~ 19:00</b><br>
                    대표전화 <b>07048585950</b>
                </div>
            </div>
        </div>
        <form>
            <div class="row">
                <div class="col-lg-5 col-12">
                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label">이름</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control bg-light" placeholder="이름을 입력하세요 (최소 2]자)">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-4 col-form-label">이메일 주소</label>
                        <div class="col-sm-8">
                            <input type="email" class="form-control bg-light" placeholder="jinotech@jinotech.com">
                        </div>
                    </div>
                </div>
                <div class="col-lg-2 col-12">
                    <label class="col-form-label">이용 관련 및
                        제휴 문의 내용</label>
                </div>
                <div class="col-lg-5 col-12">
                    <textarea class="form-control bg-light" placeholder="문의 내용을 입력해 주세요" rows="5"></textarea>

                    <button type="button" class="btn btn-lg my-3 btn-dark btn-block">문의하기</button>
                </div>
            </div>
        </form>
    </div>
</main>

<hr>
<footer class="my-2 text-muted text-center text-small">
     <p>(주)인튜브 | 서울시 성동구 성수이로 51, 1204호 (성수동2가, 서울숲 한라시그마 밸리) | 사업자등록번호 : 868-88-01475 <br> 대표자 : 이대현 | 대표전화 070.6956.0104 | support@intube.kr</p>
    <p>Copyright ⓒ intube.kr,Inc. All Rights Reserved</p>
</footer>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-Q20CLYKQMN"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-Q20CLYKQMN');
</script>
    