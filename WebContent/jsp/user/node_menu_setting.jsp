<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.*"%>
<%@page import="java.util.Enumeration"%>
<%@ page import="com.okmindmap.model.UserConfigData"%>
<%@ page
	import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

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
<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>
<script src="${pageContext.request.contextPath}/lib/jquery.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/lib/jquery-ui.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script defer src="${pageContext.request.contextPath}/lib/raphael.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
<script defer src="${pageContext.request.contextPath}/lib/jquery.cookie.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
<script defer src="${pageContext.request.contextPath}/mayonnaise-min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
	
<title><spring:message code='message.login' /></title>

<script type="text/javascript">
	
</script>



<script type="text/javascript">
	var changeState = function(obj){
		if($("#"+obj).attr('checked')){
			$("#"+obj).attr('checked', false);
		}else{
			$("#"+obj).attr('checked', true);
		}
		orderListAcion(obj);
	}

	function init(){
			
		$.ajax({        
	        url: parent.jMap.cfg.contextPath + '/user/usernodesetting.do?' ,
	        data: "confirmed=json",
	        type: 'POST',
	        success: function (data) {
	        	$.each(data, function(index, item) {    
    				//document.getElementById("func-"+item.id).checked = true;
    				$("#func-"+item.id).attr('checked',true);
    				$("#icon-"+item.id).removeClass("d-none");
    				
	            });
	        } 
	    });
		
	}
	
	function userComplete() {
		var configs = {
				<c:forEach items="${listFuncs}" var="func">
				'${func.getId()}': document.getElementById('func-${func.getId()}').checked,
			    </c:forEach>
			};
		
		var userid = parent.jMap.cfg.userId;
		var params =	'userid=' + userid + '&';
		for(var config in configs) {
			params += 'fields=' + config + '&';
			if(configs[config] == undefined) configs[config] = ''; 
			params += 'data=' + configs[config] + '&';
		}
		params += 'confirmed=active';
		
		$.ajax({
			type: 'post',
			async: false,
			url: parent.jMap.cfg.contextPath + '/user/usernodesetting.do',
			data: params,
			success: function (data) {
				
			}, error: function (data, status, err) {
				alert("userConfig : " + status);
			}
		});
		
	}
	
	var saveOrderList = function(){
		var orderArr = [];
		var orderString = '--';
		$('#list-1 li').each(function(){
			orderString += ',' + $(this).attr('id').replace('icon-','');
		});
		orderString = orderString.replace('--,','');
		$.ajax({
			type: 'post',
			async: false,
			url: parent.jMap.cfg.contextPath + '/user/usernodesetting.do',
			data: { confirmed:'order', order : orderString},
			success: function (data) {
				
			}, error: function (data, status, err) {
				alert("userConfig : " + status);
			}
		});
	}
	
	var orderListAcion = function(id){
		var iid = id.replace("func-","icon-");
		if($("#"+id).attr("checked")){
			$("#"+iid).removeClass("d-none");
		}else{
			$("#"+iid).addClass("d-none");
		}
		saveOrderList();
	}

	__$(document).ready(function () {
		__$("#frm_confirm_s").submit(function (event) {
			//alert("Commited");
			event.preventDefault();
			userComplete();
			saveOrderList();
			parent.checkNodeMenu();
			parent.JinoUtil.closeDialog();
		});
		init();
		
		$("#list-1").sortable({
		}).disableSelection(); 
		
		__$('.funcStatus').change(function() {
			var id=$(this).attr("id");
			orderListAcion(id);
		});
	});
	
	
	
</script>
<style type="text/css">
ul {
    list-style-type: none;
    display: block;
    background: white;
    padding: 0;
    height: 100px;
    width: 100%;
    margin-bottom: 10px;
    overflow-x: scroll;
    overflow-y: hidden;
}
ul>li {
    background: white;
    height: 60px;
    margin: 10px;
    padding: 5px;
    text-align: center;
  	white-space: nowrap;
}

ul>li>input {
	position: absolute;
	width: 20px; 
	height: 20px;
	margin: 2px;
	margin-top: -20px;
	margin-left: -10px;
}
</style>
</head>

<body>

	<div class="container-fluid py-1">
		<form class="w-100 mx-auto pt-3" style="width: 100%;"
			name="frm_confirm_s" id="frm_confirm_s">
			<input type="hidden" name="confirmed" value="1" />
			
			<div class="container">
				<h4 class="border-bottom">
					<spring:message code='menu.node_function' />
				</h4>
				<div class="row">
				<c:forEach items="${listFuncs}" var="func">
					<div class="col-lg-3 mb-1">
						<div class="input-group border border-primary rounded-left">
							<div class="input-group-prepend">
								<div class="input-group-text">
									<input type="checkbox" class="funcStatus" id="func-${func.getId()}"
										aria-label="Checkbox for following text input">
								</div>
							</div>
							<label type="text" class="form-control" onclick="changeState('func-${func.getId()}')"
								style="margin-top: 1px;padding-right: 0px; padding-left: 0px;"
								aria-label="Text input with checkbox"><spring:message code='${func.getFieldname()}' />
								</label>
								<img class="m-2" src="${pageContext.request.contextPath}/menu/icons/node/${func.getFieldname()}.png" width="24px" height="24px" class="d-block mx-auto">
						</div>
					</div>
				</c:forEach>
				</div>
				<h4 class="border-bottom mt-3">
					<spring:message code='menu.node_function.order' />
				</h4>
				<ul id="list-1" class="d-flex pt-2">
				<c:forEach items="${nodeFuncs}" var="func">
				    <li id="icon-${func.getId()}" class="d-none">
						<img src="${pageContext.request.contextPath}/menu/icons/node/${func.getFieldname()}.png" width="20px" class="d-block mx-auto">
						<small class="d-inline">
							<spring:message code='${func.getFieldname()}' />
						</small>
					</li>
				</c:forEach>
				</ul>
				<div class="text-right mt-3">
					<button class="btn btn-primary btn-min-w" type="submit">
						<spring:message code='button.apply' />
					</button>
					<%-- <button class="btn btn-danger btn-min-w" type="button"
						onclick="cancel()">
						<spring:message code='button.close' />
					</button> --%>
				</div>	
			</div>
		</form>
	</div>
</body>

</html>