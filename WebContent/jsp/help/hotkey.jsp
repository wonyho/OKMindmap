<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
		<c:set var="locale" value="es"/>
	</c:when>
    <c:when test="${cookie['locale'].getValue() == 'vi'}">
        <c:set var="locale" value="vi" />
    </c:when>
    <c:otherwise>
        <c:set var="locale" value="ko" />
    </c:otherwise>
</c:choose>

<fmt:setLocale value="${locale}" />

<!doctype html>
<html lang="${locale}">

<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
<!-- Theme -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
<script
	src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

<title><spring:message code='message.login' /></title>
<!-- Hotkey function -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/hotkey.css" type="text/css" media="screen">
</head>
<body>
	<div class="text-center">
		<input type="text" id="keywordHotkey" placeholder="<spring:message code='hotkey.keyword'/>" onkeydown="startSearchHotkey();"
			class="form-control form-control-lg bg-light text-center border-0 shadow-none" />
		<button class="btn btn-primary btn-min-w" onclick="startSearchHotkey();"><spring:message code='hotkey.searchBtn'/></button>
	</div>
	<div class="table-header">
		<table class="hotkey-header">
			<tr>
				<th class="col-ti"><spring:message code='hotkey.head'/></th>
				<th class="col-linux"><img
					src="${pageContext.request.contextPath}/menu/icons/linux.png">
					<img
					src="${pageContext.request.contextPath}/menu/icons/window.png">
				</th>
				<th class="col-mac"><img
					src="${pageContext.request.contextPath}/menu/icons/mac.jpg">
				</th>
			</tr>
		</table>
	</div>
	<div class="container" id="func-key">
		
	</div>
</body>
<script>
var FUNCTIONS = 44;
var funcDict = {};
var addFuncDict = function(key, value){
	funcDict[key] = value;
}
var getFuncDict = function(key){
	return funcDict[key];
}

var linuxDict = {};
var addLinuxDict = function(key, value){
	linuxDict[key] = value;
}
var getLinuxDict = function(key){
	return linuxDict[key];
}

var macDict = {};
var addMacDict = function(key, value){
	macDict[key] = value;
}
var getMacDict = function(key){
	return macDict[key];
}

addFuncDict(0,"<spring:message code='hotkey.0'/>");
addFuncDict(1,"<spring:message code='hotkey.1'/>");
addFuncDict(2,"<spring:message code='hotkey.2'/>");
addFuncDict(3,"<spring:message code='hotkey.3'/>");
addFuncDict(4,"<spring:message code='hotkey.4'/>");
addFuncDict(5,"<spring:message code='hotkey.5'/>");
addFuncDict(6,"<spring:message code='hotkey.6'/>");
addFuncDict(7,"<spring:message code='hotkey.7'/>");
addFuncDict(8,"<spring:message code='hotkey.8'/>");
addFuncDict(9,"<spring:message code='hotkey.9'/>");
addFuncDict(10,"<spring:message code='hotkey.10'/>");
addFuncDict(11,"<spring:message code='hotkey.11'/>");
addFuncDict(12,"<spring:message code='hotkey.12'/>");
addFuncDict(13,"<spring:message code='hotkey.13'/>");
addFuncDict(14,"<spring:message code='hotkey.14'/>");
addFuncDict(15,"<spring:message code='hotkey.15'/>");
addFuncDict(16,"<spring:message code='hotkey.16'/>");
addFuncDict(17,"<spring:message code='hotkey.17'/>");
addFuncDict(18,"<spring:message code='hotkey.18'/>");
addFuncDict(19,"<spring:message code='hotkey.19'/>");
addFuncDict(20,"<spring:message code='hotkey.20'/>");
addFuncDict(21,"<spring:message code='hotkey.21'/>");
addFuncDict(22,"<spring:message code='hotkey.22'/>");
addFuncDict(23,"<spring:message code='hotkey.23'/>");
addFuncDict(24,"<spring:message code='hotkey.24'/>");
addFuncDict(25,"<spring:message code='hotkey.25'/>");
addFuncDict(26,"<spring:message code='hotkey.26'/>");
addFuncDict(27,"<spring:message code='hotkey.27'/>");
addFuncDict(28,"<spring:message code='hotkey.28'/>");
addFuncDict(29,"<spring:message code='hotkey.29'/>");
addFuncDict(30,"<spring:message code='hotkey.30'/>");
addFuncDict(31,"<spring:message code='hotkey.31'/>");
addFuncDict(32,"<spring:message code='hotkey.32'/>");
addFuncDict(33,"<spring:message code='hotkey.33'/>");
addFuncDict(34,"<spring:message code='hotkey.34'/>");
addFuncDict(35,"<spring:message code='hotkey.35'/>");
addFuncDict(36,"<spring:message code='hotkey.36'/>");
addFuncDict(37,"<spring:message code='hotkey.37'/>");
addFuncDict(38,"<spring:message code='hotkey.38'/>");
addFuncDict(39,"<spring:message code='hotkey.39'/>");
addFuncDict(40,"<spring:message code='hotkey.40'/>");
addFuncDict(41,"<spring:message code='hotkey.41'/>");
addFuncDict(42,"<spring:message code='hotkey.42'/>");
addFuncDict(43,"<spring:message code='hotkey.43'/>");

addLinuxDict(0,"Alt$N");
addLinuxDict(1,"Ctrl$O");
addLinuxDict(2,"Shift$Z");
addLinuxDict(3,"Alt$B");
addLinuxDict(4,"Alt$Del");
addLinuxDict(5,"Alt$R");
addLinuxDict(6,"Alt$S");
addLinuxDict(7,"Alt$G");
addLinuxDict(8,"Alt$C");
addLinuxDict(9,"Ctrl$1");
addLinuxDict(10,"Enter");
addLinuxDict(11,"Tab");
addLinuxDict(12,"Ctrl$E");
addLinuxDict(13,"Ctrl$B");
addLinuxDict(14,"Ctrl$L");
addLinuxDict(15,"Space");
addLinuxDict(16,"Enter");
addLinuxDict(17,"Alt$Z");
addLinuxDict(18,"Esc");
addLinuxDict(19,"Ctrl$+");
addLinuxDict(20,"Ctrl$-");
addLinuxDict(21,"Ctrl$X");
addLinuxDict(22,"Ctrl$C");
addLinuxDict(23,"Ctrl$V");
addLinuxDict(24,"Del");
addLinuxDict(25,"Alt$K");
addLinuxDict(26,"Alt$2");
addLinuxDict(27,"Alt$3");
addLinuxDict(28,"Alt$4");
addLinuxDict(29,"Alt$5");
addLinuxDict(30,"Alt$6");
addLinuxDict(31,"Alt$7");
addLinuxDict(32,"Alt$8");
addLinuxDict(33,"Ctrl$K");
addLinuxDict(34,"Alt$P");
addLinuxDict(35,"Shift$Space");
addLinuxDict(36,"Shift$-");
addLinuxDict(37,"Shift$+");
addLinuxDict(38,"Shift$Enter");
addLinuxDict(39,"Alt$T");
addLinuxDict(40,"Alt$G");
addLinuxDict(41,"Enter");
addLinuxDict(42,"N");
addLinuxDict(43,"Shift$N");

addMacDict(0,"Option$N");
addMacDict(1,"Ctrl$O");
addMacDict(2,"Shift$Z");
addMacDict(3,"Option$B");
addMacDict(4,"Option$Del");
addMacDict(5,"Option$R");
addMacDict(6,"Option$S");
addMacDict(7,"Option$G");
addMacDict(8,"Option$C");
addMacDict(9,"Ctrl$1");
addMacDict(10,"Enter");
addMacDict(11,"Tab");
addMacDict(12,"Ctrl$E");
addMacDict(13,"Ctrl$B");
addMacDict(14,"Ctrl$L");
addMacDict(15,"Space");
addMacDict(16,"Enter");
addMacDict(17,"Option$Z");
addMacDict(18,"Esc");
addMacDict(19,"Ctrl$+");
addMacDict(20,"Ctrl$-");
addMacDict(21,"Ctrl$X");
addMacDict(22,"Ctrl$C");
addMacDict(23,"Ctrl$V");
addMacDict(24,"Del");
addMacDict(25,"Option$K");
addMacDict(26,"Option$2");
addMacDict(27,"Option$3");
addMacDict(28,"Option$4");
addMacDict(29,"Option$5");
addMacDict(30,"Option$6");
addMacDict(31,"Option$7");
addMacDict(32,"Option$8");
addMacDict(33,"Option$K");
addMacDict(34,"Option$P");
addMacDict(35,"Shift$Space");
addMacDict(36,"Shift$-");
addMacDict(37,"Shift$+");
addMacDict(38,"Shift$Enter");
addMacDict(39,"Option$T");
addMacDict(40,"Option$G");
addMacDict(41,"Enter");
addMacDict(42,"N");
addMacDict(43,"Shift$N");

var setInnerHotFunction = function(){
	var html = '<table class="hotkey-function">';
	for(i=0; i<44; i++){
		html += '<tr><td class="col-ti"><p>'+getFuncDict(i)+'</p></td>'+
		'<td class="col-co key-content">';
		var lin = getLinuxDict(i).split("$");
		for(j=0; j<lin.length; j++){
			html += '<p>' + lin[j] + '</p>';
		}
		html += '</td>' + 
		'<td class="col-co key-content-mac">';
		var mac = getMacDict(i).split("$");
		for(j=0; j<mac.length; j++){
			html += '<p>' + mac[j] + '</p>';
		}
		html += '</td></tr>';
	}
	html += '</table>';
	$("#func-key").html(html);
}

var findHotKey = function(keyword){
	var funcSearchResult = [];
	var keys = keyword.toLowerCase().split(" ");
	for(i=0; i<FUNCTIONS; i++){
		var funcs = getFuncDict(i).toLowerCase().split(" ");
		for(j=0; j<funcs.length; j++){
			for(k=0; k<keys.length; k++){
				if(funcs[j] == keys[k] && keys[k].length > 1){
					funcSearchResult.push(i);
					j=funcs.length;
					k<keys.length;
				}
			}
		}
	}
	displayHotFuncSearch(funcSearchResult);
}

var displayHotFuncSearch = function(funcSearchResult){
	var html = '<table class="hotkey-function">';
	for(k=0; k<funcSearchResult.length; k++){
		var i = funcSearchResult[k];
		html += '<tr><td class="col-ti"><p>'+getFuncDict(i)+'</p></td>'+
		'<td class="col-co key-content">';
		var lin = getLinuxDict(i).split("$");
		for(j=0; j<lin.length; j++){
			html += '<p>' + lin[j] + '</p>';
		}
		html += '</td>' + 
		'<td class="col-co key-content-mac">';
		var mac = getMacDict(i).split("$");
		for(j=0; j<mac.length; j++){
			html += '<p>' + mac[j] + '</p>';
		}
		html += '</td></tr>';
	}
	html += '</table>';
	$("#func-key").html(html);
}

var startSearchHotkey = function(){
	var keyword = $("#keywordHotkey").val();
	if(keyword.length > 1){
		findHotKey(keyword);
	}else{
		setInnerHotFunction();
	}
	
}

setInnerHotFunction();
</script>
</html>