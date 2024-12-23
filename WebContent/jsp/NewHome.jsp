<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="env" uri="http://www.servletsuite.com/servlets/enventry" %>

<%
	request.setAttribute("user", session.getAttribute("user"));

	boolean cefapp = Boolean.parseBoolean(request.getParameter("cefapp"));
	request.setAttribute("cefapp", cefapp);
	if(cefapp) {
		Cookie cookie = new Cookie("cefapp", "true");
		cookie.setPath("/");
		response.addCookie(cookie);
	}

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}

%>

<c:choose>
	<c:when test="${cookie['locale'].getValue() == 'en'}">
		<c:set var="locale" value="en"/>
	</c:when>
	<c:when test="${cookie['locale'].getValue() == 'es'}">
		<c:set var="locale" value="es"/>
	</c:when>
	<c:when test="${cookie['locale'].getValue() == 'vi'}">
		<c:set var="locale" value="vi"/>
	</c:when>
	<c:otherwise>
		<c:set var="locale" value="ko"/>
	</c:otherwise>
</c:choose>

<c:if test="${cookie['cefapp'].getValue() != null}">
	<c:set var="cefapp" value="${cookie['cefapp'].getValue()}"/>
</c:if>

<fmt:setLocale value="${locale}"/>

<!doctype html>
<html lang="${locale}">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta property="og:type" content="website" />
    <meta property="og:image" content="${pageContext.request.contextPath}/dist/images/og-image.png" />
    
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico?v=<%=updateTime%>" />

    <title>TubeStory</title>
	
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/app.css" />
    <script defer src="${pageContext.request.contextPath}/dist/js/app.js"></script>
    <script src="${pageContext.request.contextPath}/lib/jquery.min.js?v=<env:getEntry name="versioning"/>" type="text/javascript" charset="utf-8"></script>
  
  <style>
		.dropbtn {
		  color: red;
		  padding-left: 20px;
		  font-size: 16px;
		  border: none;
		  cursor: pointer;
		}
		
		.dropbtn:hover, .dropbtn:focus {
		  
		}
		
		.dropdown {
		  float: right;
		  position: relative;
		  display: inline-block;
		}
		
		.dropdown-content {
		  display: none;
		  position: absolute;
		  background-color: #f1f1f1;
		  min-width: 160px;
		  overflow: auto;
		  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
		  right: 0;
		  z-index: 1;
		}
		
		.dropdown-content a {
		  color: black;
		  padding: 12px 16px;
		  text-decoration: none;
		  display: block;
		}
		
		.dropdown a:hover {background-color: #ddd;}
		
		.show {display: block;}
	</style>
  	<style>
		body {font-family: Arial, Helvetica, sans-serif;}
		
		/* The Modal (background) */
		.modal {
		  display: none; /* Hidden by default */
		  position: fixed; /* Stay in place */
		  z-index: 1; /* Sit on top */
		  padding-top: 100px; /* Location of the box */
		  left: 0;
		  top: 0;
		  width: 100%; /* Full width */
		  height: 100%; /* Full height */
		  overflow: auto; /* Enable scroll if needed */
		  background-color: rgb(0,0,0); /* Fallback color */
		  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
		}
		
		/* Modal Content */
		.modal-content {
		  background-color: #fefefe;
		  margin: auto;
		  padding: 20px;
		  border: 1px solid #888;
		  width: 600px;
		}
		
		/* The Close Button */
		.close {
		  color: #aaaaaa;
		  float: right;
		  font-size: 28px;
		  font-weight: bold;
		}
		
		.close:hover,
		.close:focus {
		  color: #000;
		  text-decoration: none;
		  cursor: pointer;
		}
	</style>
  </head>
  <body class="page-tubestory overflow-x-hidden pt-70 lg:pt-90" x-data x-cloak>
    <!-- header section -->
    <div class="header shadow-lg fixed top-0 left-0 w-full z-100 bg-white">
      <div class="max-w-1200 mx-auto px-4 s1280:px-0">
        <div class="flex items-center justify-between h-70 lg:h-90">
          <a href="${pageContext.request.contextPath}">
            <img src="${pageContext.request.contextPath}/theme/dist/images/logo.png" alt="logo" />
          </a>

          <div class="main-menu hidden lg:flex uppercase font-medium">
            <!-- <div class="menu-item hover:text-primary">
              <a href="index.html" x-text="$t('menus.about')"></a>
            </div> -->
            <!--  <div class="menu-item hover:text-primary">
              <a href="consulting.html" x-text="$t('menus.consulting')"></a>
            </div>
            <div class="menu-item hover:text-primary">
              <a href="tubelearn.html" x-text="$t('menus.tubelearn')"></a>
            </div>
            <div class="menu-item hover:text-primary">
              <a href="tubeanaly.html" x-text="$t('menus.tubeanaly')"></a>
            </div>
            <div class="menu-item text-primary">
              <a href="tubestory.html" x-text="$t('menus.tubestory')"></a>
            </div> -->
            
            <div class="menu-item">
              <a href="${pageContext.request.contextPath}#ss3">주요기능</a>
            </div>
            <div class="menu-item">
              <a href="${pageContext.request.contextPath}#ss4">다양한 활용법</a>
            </div>
            <div class="menu-item">
              <a href="${pageContext.request.contextPath}#ss5">요금안내</a>
            </div>
            <div class="menu-item">
              <a class="text-primary" href="${pageContext.request.contextPath}/index.do">Tubestory시작하기</a>
            </div>
          </div>

          <div class="lang-menu hidden lg:flex">
            <a href="${pageContext.request.contextPath}#contact" class="btn rounded-15 px-5 bg-light leading-175p h-30 mr-3" x-text="$t('contact')"></a>

			<c:choose>
			    <c:when test="${user == null || user.username == 'guest'}">
			    	<div class="dropdown">
					  <a onclick="myFunction()" class="dropbtn btn rounded-15 px-5 bg-light leading-175p h-30 mr-3">로그인/회원가입</a>
					  <div id="myDropdown" class="dropdown-content">
					    <form style="width: 350px; height: 350px;" id="iframediv">
		                  <iframe class="d-block mx-auto" style="width: 350px; height: 350px;" id="iframeif"
		                      src="${pageContext.request.contextPath}/user/login.do" width="100%"
		                       frameborder="0"></iframe>
		                   </form>
					  </div>
					</div>
			    </c:when>
			    <c:otherwise>
			    	
			    	<div class="dropdown">
			    	<a  class="dropbtn btn rounded-15 px-5 bg-light leading-175p h-30 mr-3" style="display: inline-flex;">
				    	<img onclick="myFunction2()" class="dropb" src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 28px; height: 28px;" class="d-block mx-auto rounded-circle">
				    	<span onclick="myFunction2()" class="dropb" style="padding: 0px 0 0 10px;"><c:out value="${user.firstname}" /></span>
			    	</a>
			    		<%-- <div onclick="myFunction2()" class="d-inline dropbtn" style="display: inline-flex;">
	                       <img onclick="myFunction2()" src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 32px; height: 32px;" class="d-block mx-auto rounded-circle">
	
	                       <div onclick="myFunction2()" class="text-center font-weight-bold h6" style="padding: 4px 0 0 10px;">
	                           <c:out value="${user.firstname}" />
	                       </div>
	                   </div> --%>
					  <div id="myDropdown2" class="dropdown-content">
					  	<a class="text-center">
					  		<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" 
					  		style="width: 64px; height: 64px;" class="d-block mx-auto rounded-circle">
					  		<c:out value="${user.firstname}" />
					  	</a>
					    <a style="display: flex;"  id="myBtn">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/home.svg"
							width="18px" class="mr-3 mb-1">
							<span style="padding-left: 10px;"><spring:message code="message.editprofile"/></span>
						</a>
						<c:if test="${user.username == 'admin'}">
						<a style="display: flex;"  href="${pageContext.request.contextPath}/mindmap/admin/index.do">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/settings.svg" width="18px" class="mr-3 mb-1">
							<span style="padding-left: 10px;"><spring:message code="message.admin" /></span>
						</a>
						</c:if>
						<div class="dropdown-divider"></div>
						<a style="display: flex;" class="text-primary" href="${pageContext.request.contextPath}/user/logout.do">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/log-out.svg"
							width="18px" class="mr-3 mb-1">
							<span class="text-primary" style="padding-left: 10px;"><spring:message code="message.logout"/></span>
	                    </a>
					  </div> 
					
					</div>
			    </c:otherwise>
			</c:choose>
            
            
            <div class="relative" x-data="{ opened: false }">
              <div class="ml-5 flex items-center cursor-pointer" :class="{active: opened}" @click="opened=!opened">
                <img src="${pageContext.request.contextPath}/dist/images/icon-globe.png" alt="icon-globe" />
              </div>

              <div @click.away="opened = false" x-show.transition="opened" class="border border-light border-t-0 origin-top-left absolute -left-7 top-60 bg-white text-gray py-3 text-center uppercase" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
                <div class="px-7 py-2 cursor-pointer hover:bg-light" :class="{'text-primary':$locale() == 'ko'}" @click="$locale('ko')" x-text="$t('lang.ko')"></div>
                <div class="px-7 py-2 cursor-pointer hover:bg-light" :class="{'text-primary':$locale() == 'en'}" @click="$locale('en')" x-text="$t('lang.en')"></div>
                <div class="px-7 py-2 cursor-pointer hover:bg-light" :class="{'text-primary':$locale() == 'vi'}" @click="$locale('vi')" x-text="$t('lang.vi')"></div>
              </div>
            </div>
          </div>

          <div class="hamburger-button lg:hidden w-60 h-60 cursor-pointer bg-img"></div>
        </div>
      </div>
    </div>
    <!-- header section -->
    <!-- section 1 -->
    <div class="relative overflow-hidden max-w-1920 mx-auto">
      <div id="heading-swiper" class="swiper-container">
        <div class="swiper-wrapper">
          <template x-for="(slide, idx) in $t('heading')">
            <div :id="'slide-'+idx" class="swiper-slide bg-img bg-cover w-full" :style="'background-image: url(\'dist/images/heading-'+(idx+1)+'.png\');'">
              <div class="max-w-1200 mx-auto text-center px-4 text-white py-24">
                <div class="ani-item text-30 lg:text-48 font-gmarketsans" x-text="slide.title"></div>
                <div class="ani-item text-18 lg:text-22 leading-175p mt-8" x-html="slide.desc"></div>
              </div>
            </div>
          </template>
        </div>

        <div class="swiper-pagination text-center mt-6"></div>

        <div class="swiper-prev hidden md:block"></div>
        <div class="swiper-next hidden md:block"></div>
      </div>
      
    </div>
    <!-- section 1 -->

    <div  class="max-w-1200 mx-auto px-4 s1280:px-0">
      <!-- section 2 -->
      <div id="s2" class="ani-sections text-center">
        <div class="ani-item text-30 lg:text-60 uppercase pt-11 lg:pt-14 font-bold" x-html="$t('tubestory.s2.text1')"></div>
        <div class="ani-item text-24 lg:text-40 font-medium  mt-16" x-html="$t('tubestory.s2.text2')"></div>
        <div class="ani-item text-18 lg:text-26 mt-5" x-html="$t('tubestory.s2.text3')"></div>
        <div class="ani-item text-18 lg:text-26 mt-5" x-html="$t('tubestory.s2.text4')"></div>
        <div class="ani-item text-18 lg:text-26 mt-5" x-html="$t('tubestory.s2.text5')"></div>
        <div class="ani-item text-span-primary text-20 lg:text-30 font-medium mt-10" x-html="$t('tubestory.s2.text6')"></div>
      </div>
      <!-- section 2 -->
		<span id="ss3"></span>
      <!-- section 3 -->
      <div id="s3" class="ani-sections mt-24 pb-60 lg:pb-70">
        <div class="ani-item text-center text-24 lg:text-30 font-medium mb-5" x-html="$t('tubestory.s3.text1')"></div>

        <template x-for="(block,idx) in $t('tubestory.s3.blocks')">
          <div class="ani-item s2-box px-3 lg:px-30 py-9 mb-10px" :style="'background-image: url(\'dist/images/tubestory-s2-'+(idx+1)+'.png\')'">
            <div class="text-20 lg:text-25 font-medium text-primary" x-html="block.text1"></div>
            <div class="text-18 lg:text-20 font-medium mt-1" x-html="block.text2"></div>
            <div class="text-16 lg:text-18 text-gray10 mt-3" x-html="block.text3"></div>
          </div>
        </template>
        <span id="ss4"></span>
      </div>
      <!-- section 3 -->
      
    </div>

    <!-- section 4 -->
    <div class="max-w-1920 mx-auto bg-gray5">
      <div class="max-w-1200 mx-auto px-4 s1280:px-0 md:pb-10">
        <div id="s4" class="ani-sections">
          <div class="ani-item text-20 lg:text-30 font-medium text-white bg-primary max-w-520 mx-auto text-center rounded-b-50 lg:rounded-b-85 py-4 lg:py-6" x-html="$t('tubestory.s4.text1')"></div>
        </div>

        <div id="s4-video" class="ani-sections md:grid grid-cols-2 lg:grid-cols-3 gap-11 mt-14">
          <template x-for="(video, idx) in $t('tubestory.s4.videolist')">
            <div class="ani-item mb-60 md:mb-8 text-center">
              <iframe class="w-full h-210 rounded-10 bg-black" :src="video.url" title="YouTube video player" frameborder="0" allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
              <div class="text-18 lg:text-24 text-primary font-medium mt-4" x-html="video.title"></div>
              <div class="lg:text-18 mt-4" x-html="video.desc"></div>
            </div>
          </template>
          <span id="ss5"></span>
        </div>
      </div>
      
    </div>
    <!-- section 4 -->

    <div  class="max-w-1200 mx-auto px-4 s1280:px-0 pt-12">
      <!-- section 5 -->
      <div id="s5" class="ani-sections">
        <div class="ani-item text-20 lg:text-30 font-medium text-center" x-html="$t('tubestory.s5.text1')"></div>
      </div>

      <div id="s5-blocks" class="ani-sections md:grid grid-cols-3 gap-3 lg:gap-11 mt-8">
        <template x-for="(block, idx) in $t('tubestory.s5.blocks')">
          <div class="ani-item mb-8 lg:mb-0 text-center">
            <div class="text-20 lg:text-26 font-medium text-white bg-black px-3 py-6" x-html="block.text1"></div>
            <div class="border border-gray13 px-3 lg:px-10">
              <img class="mx-auto py-11" :src="'dist/images/tubestory-s5-'+(idx+1)+'.png'" />
              <a :href="block.url" class="block rounded-full bg-primary text-white text-18 lg:text-24 font-medium py-4" x-html="block.text2"></a>
              <div class="text-18 py-4" x-html="block.text3"></div>
            </div>
          </div>
        </template>
      </div>

      <div id="s5-table" class="ani-sections">
        <table class="ani-item text-center mt-90">
          <thead>
            <tr>
              <template x-for="col in $t('tubestory.s5.tabletitle')">
                <th class="w-1/4" x-html="col"></th>
              </template>
            </tr>
          </thead>
          <tbody>
            <template x-for="row in $t('tubestory.s5.tablelist')">
              <tr>
                <template x-for="col in row">
                  <td x-html="col"></td>
                </template>
              </tr>
            </template>
          </tbody>
        </table>
      </div>
      <!-- section 5 -->

      <!-- section 6 -->
      <div id="s6" class="ani-sections text-center mt-100">
        <div class="ani-item text-24 lg:text-35 font-medium" x-html="$t('tubestory.s6.text1')"></div>
        <div class="ani-item text-18 lg:text-26 text-primary mt-10" x-html="$t('tubestory.s6.text2')"></div>
        <div class="ani-item text-18 lg:text-26" x-html="$t('tubestory.s6.text3')"></div>

        <a href="tel:02-6956-0104" class="ani-item block max-w-500 rounded-100 bg-primary text-white mx-auto py-5 lg:py-30 mt-11">
          <img class="mx-auto w-10 lg:w-16" src="${pageContext.request.contextPath}/dist/images/tubelearn-s5-1.png" />
          <div class="text-30 lg:text-40 font-bold mt-3">02-6956-0104</div>
        </a>
      </div>
      <!-- section 6 -->
    </div>

    <!-- section 7 -->
    <div id="contact" class="pt-60 lg:pt-150" x-data="contact">
      <div id="s7" class="ani-sections relative overflow-hidden max-w-1920 mx-auto">
        <img class="img-fit" src="${pageContext.request.contextPath}/dist/images/tubelearn-s6-1.png" />
        <div class="max-w-600 mx-auto text-center px-4 relative z-10 pt-12 pb-70">
          <div class="ani-title text-24 lg:text-35 font-bold text-white" x-text="$t('tubestory.s7.text1')"></div>
          <form class="ani-form mt-12">
            <input x-model="frmdata.fullname" required class="input mt-10px" type="text" :placeholder="$t('contactform.fullname')" id="txtName"/>
            <input x-model="frmdata.email" required class="input mt-10px" type="email" :placeholder="$t('contactform.email')" id="txtEmail"/>
            <input x-model="frmdata.tubestoryid" class="input mt-10px" type="text" :placeholder="$t('contactform.id')" id="txtID"/>
            <input x-model="frmdata.phone" class="input mt-10px" type="text" :placeholder="$t('contactform.phone')" id="txtPhone"/>
            <textarea x-model="frmdata.message" required class="input mt-10px" rows="8" :placeholder="$t('contactform.message')" id="txtContent"></textarea>
            <button class="button bg-white text-primary text-18 lg:text-25 font-medium border-2 py-3 mt-30" type="button" id="sendContact" x-html="$t('contactform.submit')"></button>
          </form>

          <div class="mt-4 text-center text-white text-18 font-medium" x-html="status == '' ? '' : $t('contactform.'+status)"></div>
        </div>
      </div>
    </div>
    
    <script type="text/javascript">
    	$("#sendContact").click(function(){
    	    $.ajax({
    			url: "${pageContext.request.contextPath}/contact.do",
    			data: {txtName: $("#txtName").val(), 
    				txtEmail: $("#txtEmail").val(),
    				txtID: $("#txtID").val(),
    				txtPhone: $("#txtPhone").val(),
    				txtContent: $("#txtContent").val()},
    			type: 'POST',
    			success: function (data) {
    				alert("Your info was sent ! Thank you !");
    				$("#txtName").val("");
    				$("#txtMail").val("");
    				$("#txtID").val("");
    				$("#txtPhone").val("");
    				$("#txtContent").val("");
    			},
    			error: function (data) {
    				alert("Your info was not sent !");
    			}
    	    });
    	})
    </script>
    <!-- section 7 -->

    <!-- footer section -->
    <div id="footer" class="ani-sections relative overflow-hidden max-w-1920 mx-auto">
      <img class="img-fit" src="${pageContext.request.contextPath}/dist/images/footer-bg.png" />
      <div class="max-w-1200 mx-auto text-center px-4 relative z-10 py-10">
        <div class="ani-item text-14 lg:text-16 text-gray3" x-html="$t('footer.text1')"></div>
        <div class="ani-item text-14 lg:text-16 text-gray3">Tel : 02-6956-0104 / e-Mail : intube@intube.kr</div>
        <a href="${pageContext.request.contextPath}#contact" class="ani-item button mt-30" x-text="$t('contact')"></a>
      </div>
    </div>
    <!-- footer section -->

    <!-- mobile-menu -->
    <div class="mobile-menu-wrap fixed left-0 w-full z-100 hidden overflow-auto bg-white top-70" style="height: calc(100vh - 70px)">
      <div class="p-5 text-center">
        <div class="mobile-menu-item">
          <!-- <div class="text-18 leading-150p uppercase">
            <a href="index.html" x-text="$t('menus.about')"></a>
          </div>

          <div class="text-18 leading-150p uppercase mt-6">
            <a href="consulting.html" x-text="$t('menus.consulting')"></a>
          </div>

          <div class="text-18 leading-150p uppercase mt-6">
            <a href="tubelearn.html" x-text="$t('menus.tubelearn')"></a>
          </div>

          <div class="text-18 leading-150p uppercase mt-6">
            <a href="tubeanaly.html" x-text="$t('menus.tubeanaly')"></a>
          </div>

          <div class="text-18 leading-150p uppercase mt-6">
            <a href="tubestory.html" x-text="$t('menus.tubestory')"></a>
          </div> -->
          
          <div class="menu-item">
              <a href="${pageContext.request.contextPath}#ss3">주요기능</a>
            </div>
            <div class="menu-item">
              <a href="${pageContext.request.contextPath}#ss4">다양한 활용법</a>
            </div>
            <div class="menu-item">
              <a href="${pageContext.request.contextPath}#ss5">요금안내</a>
            </div>
            <div class="menu-item">
              <a class="text-primary" href="${pageContext.request.contextPath}/index.do">Tubestory시작하기</a>
            </div>
        </div>

        <div class="mt-12 mobile-menu-item">
          <a href="${pageContext.request.contextPath}#contact" class="btn rounded-15 px-5 bg-light leading-175p h-30" x-text="$t('contact')"></a>
        </div>
		<c:choose>
			    <c:when test="${user == null || user.username == 'guest'}">
			    	<div class="mt-10 flex mx-auto text-gray justify-center mobile-menu-item">
						<div class="px-4 cursor-pointer">
							<a href="${pageContext.request.contextPath}/user/login.do" class="btn rounded-15 px-5 bg-light leading-175p h-30 mr-3">로그인/회원가입</a>
						</div>
					</div>
			    </c:when>
			    <c:otherwise>
					<div class="mt-10 flex mx-auto text-gray justify-center mobile-menu-item">
						<div class="px-4 cursor-pointer">
							<a  class="dropbtn btn rounded-15 px-5 bg-light leading-175p h-30 mr-3" style="display: inline-flex;">
						    	<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 28px; height: 28px;" class="d-block mx-auto rounded-circle">
						    	<span  style="padding: 0px 0 0 10px;"><c:out value="${user.firstname}" /></span>
					    	</a>
						</div>
					</div>
					<div class="mt-10 flex mx-auto text-gray justify-center mobile-menu-item">
						<div class="px-4 cursor-pointer"><a href="${pageContext.request.contextPath}/user/update.do"><spring:message code="message.editprofile"/></a></div>
						<c:if test="${user.username == 'admin'}">
							<div class="px-4 cursor-pointer border-gray border-l"><a href="${pageContext.request.contextPath}/mindmap/admin/index.do"><spring:message code="message.admin" /></a></div>
						</c:if>
						<div class="px-4 cursor-pointer border-gray border-l"><a href="${pageContext.request.contextPath}/user/logout.do"><spring:message code="message.logout"/></a></div>
					</div>
			    </c:otherwise>
			</c:choose>
        <div class="mt-10 flex mx-auto text-gray justify-center mobile-menu-item">
          <div class="px-4 cursor-pointer" :class="{'text-primary': $locale() == 'ko'}" @click="$locale('ko')" x-text="$t('lang.ko')"></div>
          <div class="px-4 cursor-pointer border-gray border-l" :class="{'text-primary': $locale() == 'en'}" @click="$locale('en')" x-text="$t('lang.en')"></div>
          <div class="px-4 cursor-pointer border-gray border-l" :class="{'text-primary': $locale() == 'vi'}" @click="$locale('vi')" x-text="$t('lang.vi')"></div>
        </div>
      </div>
    </div>
    
    
    <!-- The Modal -->
<div id="myModal" class="modal">

  <!-- Modal content -->
  <div class="modal-content">
    <span class="close">&times;</span>
    <iframe class="d-block mx-auto" src="${pageContext.request.contextPath}/user/update.do?redirect_url=${pageContext.request.contextPath}/new/index.do"
                            width="100%" frameborder="0" style="height: 900px"></iframe>
  </div>

</div>

  </body>


<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-Q20CLYKQMN"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-Q20CLYKQMN');
</script>

<script>
/* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
function myFunction() {
  document.getElementById("myDropdown").classList.toggle("show");
}

function myFunction2() {
  document.getElementById("myDropdown2").classList.toggle("show");
}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn') && !event.target.matches('.dropb')) {
    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
  
  if (event.target == modal) {
	    modal.style.display = "none";
	  }
}
</script>

<script>
// Get the modal
var modal = document.getElementById("myModal");

// Get the button that opens the modal
var btn = document.getElementById("myBtn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

if(btn){
	// When the user clicks the button, open the modal 
	btn.onclick = function() {
	  modal.style.display = "block";
	}

	// When the user clicks on <span> (x), close the modal
	span.onclick = function() {
	  modal.style.display = "none";
	}
}


$(".menu-item").click(function(){
	$(".menu-item").removeClass("text-primary");
	$(this).addClass("text-primary");
})	
</script>

</html>