<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	String useragent = (String) request.getAttribute("agent");
	String facebook_appid = Configuration.getString("facebook.appid");
	Locale locale = RequestContextUtils.getLocale(request);
	request.setAttribute("locale", locale);

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<!doctype html>
<html lang="${locale.language}">

<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

	<title><spring:message code='message.login' /></title>

  <script src="https://apis.google.com/js/api:client.js"></script>

	<script type="text/javascript">
		// var auth_redirect = '${data.auth_redirect}';
		// if (auth_redirect != '') parent.document.location.href = auth_redirect;

		function check() {
			var frm = document.getElementById("frm_login");

			var params = {
				"username": frm.username.value,
				"password": frm.password.value
			};

			$.post("${pageContext.request.contextPath}/confirm.do", params, function (data) {
				if(data.status == 'ok') {
					var frm = document.getElementById("frm_login");
					if(parent != window) {
						frm.target = "_parent";
						frm.return_url.value = parent.document.location.href;
					}
					frm.submit();
				} else {
					alert("error3 : " + data.message);
				}
			});
		}

		function jsEnter(e) {
			e = e || window.event;
			if (e.keyCode == 13) {
				check();
			}
		}

    function GoogleAuthInit() {
      gapi.load('auth2', function () {
        auth2 = gapi.auth2.init({
          client_id: '720327265186-m1ums5qrbg5g4scu78vlj2u3b1imdv5e.apps.googleusercontent.com',
          cookiepolicy: 'single_host_origin',
        });
          
        attachSignin(document.getElementById('btnGoogleLogin'));
      });
    };

    function attachSignin(element) {
      auth2.attachClickHandler(
        element,
        {},
        function (googleUser) {
          var google_id = googleUser.getBasicProfile().getId();

          $.post("${pageContext.request.contextPath}/confirm.do", {
            auth: 'google',
            username: google_id,
            email: googleUser.getBasicProfile().getEmail(),
            firstname: googleUser.getBasicProfile().getGivenName(),
            lastname: googleUser.getBasicProfile().getFamilyName(),
            image_url: googleUser.getBasicProfile().getImageUrl(),
            fullname: googleUser.getBasicProfile().getName()
          }, function (data) {
            if(data.status == 'ok') {
              parent.document.location.href = "${pageContext.request.contextPath}/user/login.do?google=" + google_id;
            } else {
              alert("error3 : " + data.message);
            }
          });
        },
        function (error) {
          alert(JSON.stringify(error, undefined, 2));
        }
      );
    }

    
    
    function inIframe () {
	    try {
	        return window.self !== window.top;
	    } catch (e) {
	        return true;
	    }
	}
    
    $(document).ready(function(){
    	 if(document.getElementById('btnGoogleLogin')) {
             GoogleAuthInit();
        }
    	 
    	 	if(inIframe()){
 	   	 	parent.$("#iframediv").height('500px');
 	   		parent.$("#iframeif").height('500px');
    	 	}
    	 	
     });
    
	</script>
</head>

<body>
	<div class="container-fluid py-1">
		<c:if test="${data.moodle_login eq null}">
			<form class="w-100 mx-auto pt-3" style="max-width: 500px;" name="frm_login" id="frm_login" action="${pageContext.request.contextPath}/user/login.do" method="post">

				<input type="hidden" name="confirmed" value="1" />
				<input type="hidden" name="return_url" value="" />
				<input type="hidden" name="facebook" value="" />
				<input type="hidden" name="google" value="" />

				<c:if test="${data.moodle_oauth_callback ne null}">
					<input type="hidden" name="moodle_oauth_callback" value="${data.moodle_oauth_callback}" />
				</c:if>

				<div class="text-center">
					<div class="list-group list-group-horizontal-xl list-group-style-1">
						<a class="list-group-item list-group-item-action active" href="${pageContext.request.contextPath}/user/login.do">
							<spring:message code='message.login' /></a>
						<a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/user/new.do">
							<spring:message code='message.member.new' /></a>
					</div>
				</div>

				<div class="input-group mt-4">
					<div class="input-group-prepend">
						<div class="input-group-text rounded-0">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/key.svg" width="20px">
						</div>
					</div>
					<input type="text" id="username" name="username" autofocus required class="form-control rounded-0" onkeypress="jsEnter(event)" placeholder="<spring:message
					code='message.id' />">
				</div>
				<div class="input-group mt-3">
					<div class="input-group-prepend">
						<div class="input-group-text rounded-0">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/lock.svg" width="20px">
						</div>
					</div>
					<input required type="password" class="form-control rounded-0" name="password" value="" onkeypress="jsEnter(event)" placeholder="<spring:message
					code='message.password' />">
				</div>

				<div class="custom-control custom-checkbox mt-3">
					<input type="checkbox" class="custom-control-input" name="persistent" id="persistent" value="1">
					<label class="custom-control-label" for="persistent">
						<spring:message code='index.keeplogin' />
					</label>
				</div>

				<a class="btn btn-block btn-dark rounded-0 mt-3" href="#" onclick="check()">
					<spring:message code='message.login' />
				</a>

				<p class="text-right mt-3">
					<a href="${pageContext.request.contextPath}/user/recover.do" class="btn btn-primary btn-sm my-1"><spring:message code='login.fogot' /></a>					
					<a href="${pageContext.request.contextPath}/user/findusername.do" class="btn btn-primary btn-sm my-1"><spring:message code='user.find_username' /></a>
				</p>

				<hr class="mt-5" style="border-style:dashed;" />

				<c:choose>
					<c:when test="${data.moodle_loginpage_idps ne null}">
						<a href="${pageContext.request.contextPath}/user/login.do?moodle=true" class="btn btn-block btn-light mt-3">
							<img src="${pageContext.request.contextPath}/menu/icons/moodle.png" width="24px" class="mr-2">
							<spring:message code='login.moodle' />
						</a>
					</c:when>
				</c:choose>

        <button class="btn btn-block btn-warning mt-3 d-none" type="button" disabled>
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/kakaotalk.svg" width="24px" class="mr-2">
					<spring:message code='login.kakao' />
				</button>

        <%-- <button class="btn btn-block btn-danger mt-3" type="button" id="btnGoogleLogin">
          <img src="${pageContext.request.contextPath}/theme/dist/images/icons/google-plus.svg" width="24px" class="mr-2">
          <spring:message code='login.google' />
        </button> --%>

			</form>
		</c:if>

		<c:if test="${data.moodle_login ne null}">
			<div class="w-100 mx-auto" style="max-width: 500px;">
				<div class="font-weight-bold py-3 text-center h5">Login with Moodle ID</div>
				<ul class="list-group list-group-flush">
					<c:forEach var="idp" items="${data.moodle_loginpage_idps.idps}">
						<li class="list-group-item">
							&#9632; <a href="#" onClick="parent.document.location.href='${idp.url}'">
								<c:out value="${idp.name}" /></a>
						</li>
					</c:forEach>
				</ul>

				<a href="${pageContext.request.contextPath}/user/login.do" class="btn btn-dark btn-block mt-5 rounded-0">
					<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-left-w.svg" width="20px" class="mr-2">
					<spring:message code='button.back' /></a>
				</a>
			</div>
		</c:if>
	</div>
</body>

</html>