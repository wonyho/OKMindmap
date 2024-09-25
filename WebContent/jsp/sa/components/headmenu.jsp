<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<header class="header header-sticky mb-4">
        <div class="container-fluid">
          <button class="header-toggler px-md-0 me-md-3" type="button" onclick="coreui.Sidebar.getInstance(document.querySelector('#sidebar')).toggle()">
            <svg class="icon icon-lg">
              <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-menu"></use>
            </svg>
          </button><a class="header-brand d-md-none" href="#">
            <svg width="118" height="46" alt="CoreUI Logo">
              <use xlink:href="${pageContext.request.contextPath}/jsp/sa/assets/brand/coreui.svg#full"></use>
            </svg></a>
          <ul class="header-nav d-none d-md-flex">
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/mindmap/admin/index.do" target="_blank">Admin page</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}" target="_blank">Home page</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.do" target="_blank">Start Okmindmap</a></li>
          </ul>
          <ul class="header-nav ms-auto">
            <li class="nav-item"><a class="nav-link" href="#">
                <svg class="icon icon-lg">
                  <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-bell"></use>
                </svg></a></li>
            <li class="nav-item"><a class="nav-link" href="#">
                <svg class="icon icon-lg">
                  <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-envelope-open"></use>
                </svg></a></li>
            <li class="nav-item"><a class="nav-link" href="https://okmindmap.org">
                <svg class="icon icon-lg">
                  <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-list-rich"></use>
                </svg></a></li>
            
          </ul>
          <ul class="header-nav ms-3">
            <li class="nav-item dropdown"><a class="nav-link py-0" data-coreui-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
                <div class="avatar avatar-md"><img class="avatar-img" src="${pageContext.request.contextPath}/jsp/sa/assets/img/avatars/5.jpg" alt="user@email.com"></div>
              </a>
              <div class="dropdown-menu dropdown-menu-end pt-0">
                <div class="dropdown-header bg-light py-2">
                  <div class="fw-semibold">Account</div>
                </div><a class="dropdown-item" href="#">
                  <svg class="icon me-2">
                    <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-envelope-open"></use>
                  </svg> Messages<span class="badge badge-sm bg-success ms-2">42</span></a><a class="dropdown-item" href="#">
                <div class="dropdown-header bg-light py-2">
                  <div class="fw-semibold">Settings</div>
                </div><a class="dropdown-item" href="#">
                  <svg class="icon me-2">
                    <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-user"></use>
                  </svg> Profile</a><a class="dropdown-item" href="#">
                <div class="dropdown-divider"></div><a class="dropdown-item" href="#">
                  <svg class="icon me-2">
                    <use xlink:href="${pageContext.request.contextPath}/jsp/sa/vendors/@coreui/icons/svg/free.svg#cil-account-logout"></use>
                  </svg> Logout</a>
              </div>
            </li>
          </ul>
        </div>
      </header>