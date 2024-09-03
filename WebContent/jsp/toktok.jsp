<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="bitly" uri="http://www.servletsuite.com/servlets/bitlytag" %>
<%@ taglib prefix="env" uri="http://www.servletsuite.com/servlets/enventry" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>톡톡</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-polyfill/7.2.5/polyfill.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/es6-promise/4.1.1/es6-promise.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.18.0/axios.min.js"></script>
<script src="${pageContext.request.contextPath}/lib/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script>
axios.interceptors.request.use(function(request) {
	if(request && request.headers['Content-Type'] != 'multipart/form-data'){
		request.headers['Content-Type'] = 'application/json';
	}
	return request;
});
</script>
<script>
const CONST_TOKTOK_URL = 'http://rang.edunet.net/tt';
function showRoom() {
	axios({
		method: 'POST',
		url: CONST_TOKTOK_URL + '/s/eapi/USER_EAPI_CREATE_TOKEN',
		data: {
			MbrNo: '<c:out value="${data.mbrNo}"/>',
			OpenType: 'ROOM_BY_KEY',
			OpenData: {
				roomKey: '<c:out value="${data.roomKey}"/>',
	            grpNo: '<c:out value="${data.grpNo}"/>',
	            leaderNo: '<c:out value="${data.leaderNo}"/>',
	            roomName: '<c:out value="${data.roomName}"/>'
			}
		}
	}).then(function(res) {
		if(res && res.data && res.data.Error == 'SUCCESS'){
			window.location.replace(CONST_TOKTOK_URL + '/check/' + res.data.token, '_blank');
		}else{
			showMessage("로그인을 해야합니다.");
		}
	}).catch(function(err) {
		// 오류난 경우 처리
		showMessage("잠시후 다시 시도해주세요.");
	});
}
function showMessage(msg) {
	$("#message").text(msg);
}
$( document ).ready(function() {
	showRoom();
});
</script>
</head>

<body>
<div id="message">연결 중 입니다.</div>
</body>

</html>