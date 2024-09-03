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

	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/bootstrap4-toggle.min.css?v=<%=updateTime%>">
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/bootstrap4-toggle.min.js?v=<%=updateTime%>"></script>
	
	<!-- Tinymce for webpage node -->
    <script defer src="${pageContext.request.contextPath}/lib/tinymce/tinymce.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
	
    <title>
        Add IoT devices
    </title>

    <script type="text/javascript">
		var updateDevice = function(){
			var layout = "";
			var layoutW = 150;
			var layoutH = 100;
			
			
			var gid = ${data.connection.getSensor().getGroupId()};
			if(gid == 1){
				/* var rid = $('input[name="inlineRadioOptions"]:checked').val();
				
				$(".toggle-group").attr("onclick", "jMap.getSelected().setIotSwitchButtonExcute(jMap.getSelected().iotId, jMap.getSelected().iotOnOff)");
				
				var html = $("#lableRadio" + rid).html();
				
				layout = '<div style = "display: inline-block; border: 5px solid #28a745; background-color: #20c997; padding: 10px; border-radius: 25px;">\n' + 
				html +
				'</div>'; */
				layout = "";
				
				var layoutW = 150;
				var layoutH = 100;
				
			}else if(gid == 2){
				layout = '<div style = "display: inline-block; border: 5px solid #28a745; background-color: #20c997; padding: 10px; border-radius: 25px;">\n' + 
				tinyMCE.get('webpage_editor').getContent() +
				'</div>';
				layoutW = $("#webpage_layout").width() + 50;
				layoutH = $("#webpage_layout").height() + 40;
			}
			
			$.ajax({
			      type: 'POST',
			      url: '${pageContext.request.contextPath}/iot/updateconn.do',
			      data: {name : $("#name").val(),note: $("#note").val(), id: ${data.connection.getId()}, layout: layout, layoutW: layoutW, layoutH: layoutH, confirm : 1},
			      dataType: "application/xml",
			      success: function(data) { 
			      }
			});
			setTimeout(function(){
				location.href='${pageContext.request.contextPath}/iot/sensor.do?id=${data.board}';
			}, 2000);
		}
		
		var updateWebpageContent = function(html){
			var var1 = html.split("{{");
			var html1 = var1[0];
			if(var1.length > 1){
				for(var i = 1; i< var1.length; i++){
					var var2 = var1[i].split("}}");
					html1 += " #Nan " + var2[1];
				}
			}
			$("#webpage_layout").html(html1);
		}
		
		$(document).ready(function () {
			<c:if test="${data.connection.getSensor().getGroupId() == 2 }">
				
			
			var currentWebPage = ${data.connection.getLayout()};
			var html = currentWebPage.replace('<div style = "display: inline-block; border: 5px solid #28a745; background-color: #20c997; padding: 10px; border-radius: 25px;">','');
			html = html.substring(0, html.length - 6);
			updateWebpageContent(html);
            tinymce.init({
                selector: '#webpage_editor',
                height: '300',
                entity_encoding: 'raw',
                menubar: false,
                plugins: [
                    "advlist autolink link image lists charmap print preview hr anchor pagebreak",
                    "searchreplace wordcount visualblocks visualchars fullscreen insertdatetime media nonbreaking",
                    "formula table contextmenu directionality emoticons code template textcolor paste textcolor colorpicker textpattern"
                ],
                toolbar1: 'toolbar_toggle,formatselect,wrap,bold,italic,wrap,bullist,numlist,wrap,link,unlink,wrap,image',
                toolbar2: 'undo,redo,wrap,underline,strikethrough,subscript,superscript,wrap,justifyleft,justifycenter,justifyright,wrap,outdent,indent,wrap,forecolor,backcolor,wrap,ltr,rtl',
                toolbar3: 'fontselect,fontsizeselect,wrap,formula,searchreplace,code,wrap,nonbreaking,charmap,table,wrap,cleanup,removeformat,pastetext,pasteword,wrap,codesample fullscreen',

                setup: function (editor) {
                    editor.addButton('toolbar_toggle', {
                        tooltip: "<spring:message code='common.toolbar_toggle' />",
                        image: tinymce.baseURL + '/img/toolbars.png',
                        onclick: function () {
                            var toolbars = editor.theme.panel.find('toolbar');
                            for (var i = 1; i < toolbars.length; i++)
                                $(toolbars[i].getEl()).toggle();
                        }
                    });
                    editor.on('init', function (e) {
                        var toolbars = editor.theme.panel.find('toolbar');
                        for (var i = 1; i < toolbars.length; i++) {
                            $(toolbars[i].getEl()).toggle();
                        }

                        if (currentWebPage != undefined) editor.setContent(html);
                        else editor.setContent("Custom your layout here");
                    });
                    
                    editor.on('keyup', function(e){
                    	var webpage = tinyMCE.get('webpage_editor').getContent();
                    	/* console.log(webpage); */
                    	
                    	updateWebpageContent(webpage);
                    });
                }
            });
           
			
           /*  $("#mains").change(function(){
				$(".groupid").addClass("d-none");
				var gid = $(this).find(':selected').attr("groupid");
				$("#groupid-"+gid).removeClass("d-none");
				if(gid == 1){
					parent.$("#iframeDialog iframe").height("370px");
					
				}else if(gid == 2){
					parent.$("#iframeDialog iframe").height("600px");
					$("#mceu_32").height("200px");
					$("#mceu_40").height("120px");
					$("#webpage_editor_ifr").height("120px")
				}
				
			}) */
            </c:if>
        });
    </script>
</head>

<body>
    <div class="container-fluid py-1">
        <div class="form-group">
            <label for="name">
                Device's name
            </label>
		 	<input type="text" value="${data.connection.getName() }" required class="form-control" id="name">
        </div>
        <div class="form-group">
        	<label for="name">
                Device
            </label>
            <input type="text" value="${data.connection.getSensor().getName() }" readonly class="form-control">
        </div>
        <div class="form-group">
        	 <label for="name">
                Note
            </label>
            <input type="text" value="${data.connection.getNote() }" required class="form-control" id="note">
        </div>
        
        <%-- <c:if test="${data.connection.getSensor().getGroupId() == 1 }">
        
        <div id="groupid-1" class="groupid">
        	<div class="form-check form-check-inline">
			  <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio1" value="1" checked>
			  <label class="form-check-label" for="inlineRadio1" id="lableRadio1">
			  		<input type="checkbox" checked data-toggle="toggle" data-onstyle="info">
			  </label>
			</div>
			<!-- <div class="form-check form-check-inline">
			  <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio2" value="2">
			  <label class="form-check-label" for="inlineRadio2" id="lableRadio2">
			  		<input type="checkbox" checked data-toggle="toggle" data-onstyle="success">
			  </label>
			</div> -->
			<div class="form-check form-check-inline">
			  <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio3" value="3">
			  <label class="form-check-label" for="inlineRadio3" id="lableRadio3">
			  		<input type="checkbox" checked data-toggle="toggle" data-onstyle="danger">
			  </label>
			</div>
			<div class="form-check form-check-inline">
			  <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio4" value="4">
			  <label class="form-check-label" for="inlineRadio4" id="lableRadio4">
			  		<input type="checkbox" checked data-toggle="toggle" data-onstyle="warning">
			  </label>
			</div>
			<div class="form-check form-check-inline">
			  <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio5" value="5">
			  <label class="form-check-label" for="inlineRadio5" id="lableRadio5">
			  		<input type="checkbox" checked data-toggle="toggle" data-onstyle="dark">
			  </label>
			</div>
        </div>
        </c:if> --%>
        <c:if test="${data.connection.getSensor().getGroupId() == 2 }">
        <div id="groupid-2" class="groupid">
        	<div class="form-group">
	            <textarea id="webpage_editor" name="webpage_editor"></textarea>
	        </div>
	        
	        <div id="webpage_layout" style = "display: inline-block; border: 5px solid #28a745; background-color: #20c997; padding: 10px; border-radius: 25px;">
	        
	        </div>
        </div>
        </c:if>
        
        
        
        <div class="text-center mt-4">
        	<button type="button" onclick="updateDevice()" class="btn btn-primary">
			    Update
			</button>
           <button type="button" onclick="location.href='${pageContext.request.contextPath}/iot/sensor.do?id=${data.board}';" class="btn btn-danger">
               Back
           </button>
       </div>
    </div>

</body>

</html>