<%@page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=utf-8" %>

<header>
	<nav class="navbar navbar-expand-sm navbar-dark bg-primary shadow-md position-fixed top-0 left-0 w-100 z-20">
		<div class="container-fluid">
			<div class="d-flex col-4 col-md-5 col-xl-6">
				<a class="navbar-brand mx-0" href="${pageContext.request.contextPath}/index.do">
					<img class="d-none d-lg-block d-xl-block" src="${pageContext.request.contextPath}/theme/dist/images/logo-white.png" height="34px" style="margin-top: -6px;">
					<img class="d-lg-none d-xl-none" src="${pageContext.request.contextPath}/theme/dist/images/logo-white-m.png" height="34px" style="margin-top: -6px;">
				</a>

				<c:if test="${data.map.key != null}">
			
					<a class="navbar-brand m-0 py-0 active font-weight-bold d-flex justify-content-start" href="#" onclick="shorturlFunction()" style="height: 34px;">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/qr-code-w.svg" width="16px" class="mx-1 d-inline-block" style="vertical-align: text-top;">
						<span class="d-inline-block text-truncate col-6 col-sm-7 col-md-12" style="font-size: 16px;padding-top: 6px;"><c:out value="${data.map.name}" /></span>
					</a>
			
				</c:if>

			</div>
			<div>
				<div class="d-inline-block d-sm-none btn p-0" onclick="navbarMenusToggle(!($.cookie('toggleMenus') == 'true'), true)">
					<div class="custom-control custom-switch">
						<input type="checkbox" class="custom-control-input" disabled id="toggleMenus">
						<label class="custom-control-label" for="toggleMenus"></label>
					</div>
				</div>
				<button class="btn btn-primary d-sm-none px-1" type="button" onclick="jMap.controller.findNodeAction()">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search-w.svg" width="20px" class="align-text-top">
				</button>
				<button class="navbar-toggler outline-none border-0 btn btn-primary d-inline-block d-sm-none px-1" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
			</div>
			
			<div class="collapse navbar-collapse" id="navbarCollapse">
				
				<ul class="navbar-nav mr-auto"></ul>
				<div class="d-none d-sm-block btn p-0" onclick="navbarMenusToggle(!($.cookie('toggleMenus') == 'true'), true)">
					<div class="custom-control custom-switch">
						<input type="checkbox" class="custom-control-input" disabled id="toggleMenus2">
						<label class="custom-control-label" for="toggleMenus2"></label>
					</div>
				</div>
				<form class="mx-2 form-inline my-1 my-lg-0 jino_form_search d-none d-sm-block" id="jino_form_search" style="width: 120px;">
					<div class="input-group">
						<input type="search" class="form-control border-0 shadow-none" id="jino_input_search_text" placeholder="<spring:message code='menu.search'/>">

						<div class="input-group-append">
							<span class="input-group-text bg-white border-0 shadow-none d-none" id="jino_form_search_results"></span>
							<button class="btn btn-light border-0 shadow-none d-none" id="jino_form_search_prev" type="button" onclick="jMap.controller.prevFindNodeAction()">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/chevron-left.svg" width="20px">
							</button>
							<button class="btn btn-light border-0 rounded-right shadow-none d-none" id="jino_form_search_next" type="button" onclick="jMap.controller.nextFindNodeAction()">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/chevron-right.svg" width="20px">
							</button>
							<button class="btn btn-light border-0 shadow-none px-2" id="jino_form_search_action" type="submit">
								<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
							</button>
						</div>
					</div>
				</form>

				<div class="mx-2 my-1 my-xl-0 d-flex justify-content-end">
					<c:choose>
						<c:when test="${user == null || user.username == 'guest'}">
							<button type="button" class="btn btn-outline-light px-1 py-1 rounded" style="width:120px;" onclick="okmLogin()">
								<spring:message code="message.login" />
								<!-- <spring:message code="message.member.new" /> -->
							</button>
						</c:when>
						<c:otherwise>
							<div class="dropdown">
								<button type="button" class="btn btn-outline-light px-2 py-1 rounded dropdown-toggle after-content-none" data-toggle="dropdown">
									<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 26px; height: 26px;" class="rounded-circle mr-1">
									<c:out value="${user.firstname}" />
								</button>
								<div class="dropdown-menu dropdown-menu-right" style="min-width: 200px;">
									<div class="p-3">
										<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 64px; height: 64px;" class="d-block mx-auto rounded-circle">

										<div class="text-center font-weight-bold mt-3 h6">
											<c:out value="${user.firstname}" />
										</div>
										<div class="text-center h6 text-success">
											(<c:out value="${data.user_policy_name}" />)
										</div>
									</div>
									<a class="dropdown-item" href="#" onclick="editProfile()">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/home.svg" width="18px" class="mr-3 mb-1">
										<spring:message code="message.editprofile" />
									</a>
									<c:if test="${user.username == 'admin'}">
										<a class="dropdown-item" href="${pageContext.request.contextPath}/mindmap/admin/index.do">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/settings.svg" width="18px" class="mr-3 mb-1">
											<spring:message code="message.admin" />
										</a>
									</c:if>
									<c:if test="${user.username != 'guest' && user.username != ''}">
										<a class="dropdown-item" href="#" onclick="iotDeviceManagerAction()">
											<img src="${pageContext.request.contextPath}/theme/dist/images/icons/settings.svg" width="18px" class="mr-3 mb-1">
											IoT setting
										</a>
									</c:if>
									<a class="dropdown-item text-warning" href="#">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/crown.svg" width="18px" class="mr-3 mb-1">
										Upgrade account
									</a>
									<div class="dropdown-divider"></div>
									<a class="dropdown-item text-danger" href="#" onclick="okmLogout()">
										<img src="${pageContext.request.contextPath}/theme/dist/images/icons/log-out.svg" width="18px" class="mr-3 mb-1">
										<spring:message code="message.logout" />
									</a>
								</div>
							</div>
						</c:otherwise>
					</c:choose>
					
					<div class="dropdown ml-2">
						<button class="btn btn-outline-light dropdown-toggle after-content-none" type="button" data-toggle="dropdown">
							<c:if test='${locale.language =="en"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/usa.png"></c:if>
							<c:if test='${locale.language =="es"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/Espanol.svg"></c:if>
							<c:if test='${locale.language =="ko"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/korea.webp"></c:if>
							<c:if test='${locale.language =="vi"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/vietnam.webp"></c:if>
							<spring:message code="menu.select.lang.${locale.language}" text="English" /></a>
						</button>
						<div class="dropdown-menu dropdown-menu-right">
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
				<%-- <div class="mx-2 my-1 my-xl-0 d-flex justify-content-end">
					<div class="dropdown">
						<button class="btn btn-outline-light dropdown-toggle" type="button" data-toggle="dropdown">
							<c:if test='${locale.language =="en"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/usa.png"></c:if>
							<c:if test='${locale.language =="es"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/Espanol.svg"></c:if>
							<c:if test='${locale.language =="ko"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/korea.webp"></c:if>
							<c:if test='${locale.language =="vi"}'><img class="img_lang mr-1" style="width: 20px; height: 14px;vertical-align: initial;" src="${pageContext.request.contextPath}/ribbonmenu/icons/normal/vietnam.webp"></c:if>
							<spring:message code="menu.select.lang.${locale.language}" text="English" /></a>
						</button>
						<div class="dropdown-menu dropdown-menu-right">
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
					
				</div> --%>
			</div>
		</div>
	</nav>
</header>

<div class="navbar navbar-light bg-white shadow-sm position-fixed top-0 left-0 w-100 z-30 navbar-modal" id="jino_form_search_modal">
	<div class="d-flex w-100">
		<div>
			<button class="btn border-0 shadow-none" type="button" onclick="navbarModalToggle()">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-left.svg" width="20px">
			</button>
		</div>
		<div class="w-100">
			<form class="mx-2" id="jino_form_search_m">
				<div class="input-group">
					<input type="search" class="form-control border-0 shadow-none bg-light" id="jino_input_search_text" placeholder="<spring:message code='menu.search'/>">

					<div class="input-group-append d-inline">
						<span class="input-group-text bg-light border-0 shadow-none d-none" id="jino_form_search_results"></span>
						<button class="btn btn-light border-0 shadow-none d-none" id="jino_form_search_prev" type="button" onclick="jMap.controller.prevFindNodeAction()">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/chevron-left.svg" width="20px">
						</button>
						<button class="btn btn-light border-0 rounded-right shadow-none d-none" id="jino_form_search_next" type="button" onclick="jMap.controller.nextFindNodeAction()">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/chevron-right.svg" width="20px">
						</button>
						<button class="btn btn-light border-0 shadow-none px-2" id="jino_form_search_action" type="submit">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
						</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>

<style>.img_lang{width: 30px;height: 20px;margin: 0px 10px 0 0;}</style>
<script>
$(window).resize(function() {
	if($(window).width() < 1050){
		$("#jino_form_search").css("width","120px");
	}else{
		$("#jino_form_search").css("width","200px");
	}
	
});
$(document).ready(function(){
	if($(window).width() < 1050){
		$("#jino_form_search").css("width","120px");
	}else{
		$("#jino_form_search").css("width","200px");
	}
});
</script>