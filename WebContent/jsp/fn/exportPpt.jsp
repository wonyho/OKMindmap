<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

<!DOCTYPE html>
<html lang="${locale}">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
    <!-- Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

    <title>
        <spring:message code='common.export_pptx' />
    </title>
</head>
<% String[] files = {"ptline_083","ptline_047","ptline_049","ptline_050","ptline_051","ptline_052",
		"ptline_053","ptline_059","ptline_067","ptline_069","ptline_070",
		"ptline_071","ptline_072","ptline_073","ptline_074","ptline_075",
		"ptline_076","ptline_077","ptline_078","ptline_079","ptline_080",
		"ptline_081","ptline_082","ptline_084","ptline_085"}; %>
<body>
    <div class="container-fluid p-3">
        <div class="mx-auto">
            <div id="frm_confirm">
                <div>
					<label>
						<spring:message code='presentation.theme' />
					</label>
					<div class="style-wrap pb-1 mb-2 position-relative" style="overflow: auto;white-space: nowrap;">
						<% for(String file : files){ %>
							<div class="d-inline-block mx-1 cursor-pointer div-theme" style="width: 210px; height: 160px;" id="div-<%= file %>">
								<label for="pt-style-BlackLabel" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="width: 210px; height: 160px; font-size: 0.8em;">
									<img src="${pageContext.request.contextPath}/plugin/slideshow/theme/<%= file %>.png" id="lab-<%= file %>" class=" d-block mx-auto img-labb" style="width: 200px; height: 150px;">
								</label>
								<img src="${pageContext.request.contextPath}/plugin/slideshow/check.png" id="img-<%= file %>" class="img-check d-none" style="position: relative ;top: -150px; left: 50px; width: 150px; height: 150px;">
							</div>
						<%} %>
					</div>
					<input class="d-none radio-input-block" type="text" id="ptt-theme" value="">
					
					<label>
						<spring:message code='presentation.font' />
					</label>
					<div class="row px-3">
						<div class="style-wrap pb-1 mb-2 mx-2 position-relative" style="overflow: auto;white-space: nowrap; width: 100px;">
							<label><spring:message code='presentation.title' /></label>
							<input type="number" class="form-control cus" id="ptt-font" min="2" value="28">
						</div>
						<div class="style-wrap pb-1 mb-2 mx-2 position-relative" style="overflow: auto;white-space: nowrap; width: 100px;">
							<label><spring:message code='presentation.level' /> 1</label>
							<input type="number" class="form-control cus" id="ptt-font1" min="2" value="20">
						</div>
						<div class="style-wrap pb-1 mb-2 mx-2 position-relative" style="overflow: auto;white-space: nowrap; width: 100px;">
							<label><spring:message code='presentation.level' /> 2</label>
							<input type="number" class="form-control cus" id="ptt-font2" min="2" value="18">
						</div>
						<div class="style-wrap pb-1 mb-2 mx-2 position-relative" style="overflow: auto;white-space: nowrap; width: 100px;">
							<label><spring:message code='presentation.level' /> 3</label>
							<input type="number" class="form-control cus" id="ptt-font3" min="2" value="14">
						</div>
						
					</div>
					<div class="d-inline-flex">
						<div class="custom-control custom-checkbox" id="customCheckd">
							<input type="checkbox" class="custom-control-input" id="customCheck">
							<label class="custom-control-label" for="customCheck"><spring:message code='presentation.customDilive' /></label>
						</div>
						<div class="ml-3 custom-control custom-checkbox" id="customSlide">
							<input type="checkbox" class="custom-control-input" id="customSlideCheck" name="personalSlide" value="1">
							<label class="custom-control-label" for="customSlideCheck"><spring:message code='presentation.theme.personal' /></label>
						</div>
					</div>
					
					<div class="row px-3">
						
						<div class="style-wrap pb-1 mb-2 mx-2 position-relative d-none" id="customRows" style="overflow: auto;white-space: nowrap;">
							<label><spring:message code='presentation.rows' /></label>
							<input type="number" class="form-control" id="ptt-lines" min="1" value="16">
						</div>
					</div>
					<div class="style-wrap pb-1 mb-2 position-relative d-none" id="customRows2" style="overflow: auto;white-space: nowrap;">
						
					</div>
					<input class="d-none radio-input-block" type="text" id="ptt-theme2" value="">
					
				</div>
                <div class="text-center">
                    <button type="button" class="btn btn-primary btn-min-w" id="exportPPT">
                        Download
                    </button>
                </div>
            </div>
        </div>
    </div>

</body>
<script type="text/javascript">
$(document).ready(function() {
	// Slide default 
	var id = "ptline_083";
	$("#ptt-theme").val(id);
	
	$("#img-"+id).removeClass("d-none");
	$("#img-"+id).addClass("d-block");
	$("#lab-"+id).addClass("opacity-02");
	
	
});

$("#customSlide").click(function(){
	if ($('#customSlideCheck').prop('checked'))
	{
		$(".cus").attr("disabled", true);
	    $("#customRows2").removeClass("d-none");
	    parent.$(".modal-body iframe").css("height","520px");
	    
	    
	    $.ajax({
	        url: "${pageContext.request.contextPath}/user/slidemaster.do",
	        type: "post",
	        data: {action:'get'},
	        success: function (data) {
	        	var txt = '';
	        	txt += '<div class="d-inline-block mx-1 cursor-pointer div-theme2" style="width: 210px; height: 160px;" id="addSlide">' +
				'<label for="pt-style-BlackLabel" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="width: 210px; height: 160px; font-size: 0.8em;">'+
					'<img src="${pageContext.request.contextPath}/plugin/slideshow/add.png"  class=" d-block mx-auto " style="margin: 25px 50px; width: 100px; height: 100px;">'+
				'</label>'+
				'</div>';
	        	$.each(data, function(index, item) { 
	        		txt += '<div class="d-inline-block mx-1 cursor-pointer div-theme2" style="width: 210px; height: 160px;" id="div2-'+item.contentType+'">' +
					'<label for="pt-style-BlackLabel" class="btn btn-light px-1 py-2 my-0 shadow-none cursor-pointer" style="width: 210px; height: 160px; font-size: 0.8em;">'+
						'<img src="${pageContext.request.contextPath}/../'+item.path+'" id="lab2-'+item.contentType+'" class=" d-block mx-auto img-labb2" style="width: 200px; height: 150px;">'+
					'</label>'+
					'<img src="${pageContext.request.contextPath}/plugin/slideshow/check.png" id="img2-'+item.contentType+'" class="img-check2 d-none" style="position: relative ;top: -150px; left: 50px; width: 150px; height: 150px;">'+
					'</div>';
	        	});
	        	
	        	$("#customRows2").html(txt);
	        	
	        	$(".div-theme2").click(function(){
	        		$(".img-check2").removeClass("d-block");
	        		$(".img-check2").addClass("d-none");
	        		$(".img-labb2").removeClass("opacity-02");
	        		
	        		var id = $(this).attr("id");
	        		id = id.replace("div2-", "");
	        		$("#ptt-theme2").val(id);
	        		
	        		$("#img2-"+id).removeClass("d-none");
	        		$("#img2-"+id).addClass("d-block");
	        		$("#lab2-"+id).addClass("opacity-02");
	        	});
	        	
	        	$("#addSlide").click(function(){
	        		parent.uploadSlideMaster();
	        	});
	        }
	    });
	    
	    
	}
	else
	{
		$(".cus").attr("disabled", false);
	    $("#customRows2").addClass("d-none");
	    parent.$(".modal-body iframe").css("height","432px");
	}
});

$("#customCheckd").click(function(){
	if ($('#customCheck').prop('checked'))
	{
	    $("#customRows").removeClass("d-none");
	    parent.$(".modal-body iframe").css("height","520px");
	}
	else
	{
	    $("#customRows").addClass("d-none");
	    parent.$(".modal-body iframe").css("height","432px");
	}
});

$(".div-theme").click(function(){
	$(".img-check").removeClass("d-block");
	$(".img-check").addClass("d-none");
	$(".img-labb").removeClass("opacity-02");
	
	var id = $(this).attr("id");
	id = id.replace("div-", "");
	$("#ptt-theme").val(id);
	
	$("#img-"+id).removeClass("d-none");
	$("#img-"+id).addClass("d-block");
	$("#lab-"+id).addClass("opacity-02");
});

$("#exportPPT").click(function(){
	if (!parent.jMap.saveAction.isAlive()) {
		return null;
	}
	
	var ft = $("#ptt-font").val();
	if(ft < 6){
		window.alert("<spring:message code='presentation.warnFont' />"); 
		return;
	}
	var ft1 = $("#ptt-font1").val();
	if(ft1 < 6){
		window.alert("<spring:message code='presentation.warnFont' />"); 
		return;
	}
	var ft2 = $("#ptt-font2").val();
	if(ft2 < 6){
		window.alert("<spring:message code='presentation.warnFont' />"); 
		return;
	}
	var ft3 = $("#ptt-font3").val();
	if(ft3 < 6){
		window.alert("<spring:message code='presentation.warnFont' />"); 
		return;
	}
	var ln = $("#ptt-lines").val();
	if(ln < 1){
		window.alert("<spring:message code='presentation.warnLines' />"); 
		return;
	}
	var devi = $('#customCheck').prop('checked');
	var perSlide = $('#customSlideCheck').prop('checked');
	var para = "?theme="+$("#ptt-theme").val()+"&theme2="+$("#ptt-theme2").val()+"&font="+ft+"&font1="+ft1+
			"&font2="+ft2+"&font3="+ft3+"&lines="+ln+"&divide="+devi+"&perSlide="+perSlide;
	
	parent.document.location.href = "${pageContext.request.contextPath}/export/ppt/" + parent.mapId + "/" + removeIllegalFileNameChars(parent.mapName) + ".pptx"+para;
	
	parent.JinoUtil.closeDialog();
});

var removeIllegalFileNameChars = function (text) {
	return text.replace(/[\x00-\x1f:?\\/*"<>|]/gi, '_');
};

</script>
<style>
.opacity-02{
	opacity: 0.2 !important;
}
</style>
</html>