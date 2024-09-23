<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="sidebar sidebar-dark sidebar-fixed" id="sidebar">
	<div class="sidebar-brand d-none d-md-flex">
		<img class="sidebar-brand-full" width="170" height="46"
			alt="Okmindmap Logo"
			src="${pageContext.request.contextPath}/jsp/sa/assets/brand/okmm-white.png" />
		<img class="sidebar-brand-narrow" width="46" height="46"
			alt="Okmindmap Logo"
			src="${pageContext.request.contextPath}/jsp/sa/assets/brand/okmm-white.png" />
	</div>
	<ul class="sidebar-nav" data-coreui="navigation" data-simplebar="">
		<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/sa/index.do">
            <svg class="nav-icon">
              <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-speedometer"></use>
            </svg> Dashboard<span class="badge badge-sm bg-info ms-auto">NEW</span></a></li>
		<li class="nav-title">API Manager:</li>
		<li class="nav-item">
			<a class="nav-link" href="${pageContext.request.contextPath}/sa/googleapi.do">
				<svg class="nav-icon">
	              <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-drop"></use>
	            </svg>
				Google Search
			</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="${pageContext.request.contextPath}/sa/translateapi.do">
				<svg class="nav-icon">
	              <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-drop"></use>
	            </svg>
				AI Translate
			</a>
		</li>
		<li class="nav-title">Backup Manager:</li>
		<li class="nav-item">
			<a class="nav-link" href="${pageContext.request.contextPath}/sa/uploadbackup.do">
				<svg class="nav-icon">
	              <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-drop"></use>
	            </svg>
				Map Files
			</a>
		</li>
	</ul>
	<button class="sidebar-toggler" type="button"
		data-coreui-toggle="unfoldable"></button>
</div>