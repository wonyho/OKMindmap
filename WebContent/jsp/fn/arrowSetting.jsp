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

    <!-- Color picker -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.css?v=<%=updateTime%>" type="text/css" media="screen">
    <script defer src="${pageContext.request.contextPath}/lib/bgrins-spectrum/spectrum.js?v=<%=updateTime%>" type="text/javascript"></script>

    <title>
        <spring:message code='menu.nodeTextColorAction' />
    </title>

    <style>
        .sp-input {
            border: 1px solid #666666 !important;
        }
    </style>

    <script type="text/javascript">
        var picker = null;
        var jMap = parent.jMap;
        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';
            
            /* var node = parent.jMap ? parent.jMap.getSelected() : null;
            if(parent.lastSelected != null) node = parent.lastSelected;
            if(parent.lastSelected != null) lastSelected = parent.lastSelected;
            if (node) {
             	var txt = '';
             	arrowLinks = node.arrowlinks;
            	for(var i= 0; i<node.arrowlinks.length; i++){
            		if(node.arrowlinks[i] != undefined ){
                		txt += '<div class="input-group mb-3" id="box-'+node.arrowlinks[i].id+'">' +
             			 ' <input type="text" class="form-control arrowTxt" placeholder="Arrow link text" '+
             			 ' idarrow="'+ node.arrowlinks[i].id +'" '+
             			 ' value="'+ node.arrowlinks[i].getText() +'"' +
             			 'aria-label="Arrow link text" aria-describedby="basic-addon2">' +
         			  	 '<div class="input-group-append"> <button class="btn btn-primary arrowSetting" '+
         			  	' idarrow="'+ node.arrowlinks[i].id +'" '+
         			  	 ' type="button">Set</button>'+
                		'<button class="btn btn-danger arrowDel" '+
         			  	' idarrow="'+ node.arrowlinks[i].id +'" '+
         			  	 ' type="button">X</button></div></div>';
                	}
            	}
            	txt += '<button type="button" class="btn btn-primary btn-min-w" id="addArrow">Add</button>';
            	$("#arrowText").html(txt);
            } */
            
/*             $(document).delegate(".arrowDel", "click",function(){
            	parent.jMap.controller.removeArrowLinkId($(this).attr("idarrow"));
            	var arrs = $(".arrowTxt");
            	for(var i = 0; i<arrs.length; i++){
                	if($(arrs[i]).attr("idarrow") == $(this).attr("idarrow")){
                		$("#box-"+$(arrs[i]).attr("idarrow")).addClass("d-none");
                	}
                }
            }); 
            
            var currentID = null;
            $(document).delegate(".arrowSetting", "click",function(){
//            	parent.jMap.controller.removeArrowLinkId($(this).attr("idarrow"));
            	$("#tab01").addClass("d-none");
            	$("#tab02").removeClass("d-none");
            	$("#backtab").removeClass("d-none");
            	$("#applytab").removeClass("d-none");
            	$("#apply").addClass("d-none");
            	currentID = $(this).attr("idarrow");
            	for(var i= 0; i<node.arrowlinks.length; i++){
            		if(node.arrowlinks.length != undefined ){
            			if(node.arrowlinks[i].id == currentID){
            				loadSetting(node.arrowlinks[i]);
            				break;
            			}
            		}
            	}
            });
            
            $(document).delegate("#backtab", "click",function(){
//            	parent.jMap.controller.removeArrowLinkId($(this).attr("idarrow"));
            	$("#tab02").addClass("d-none");
            	$("#tab01").removeClass("d-none");
            	$("#backtab").addClass("d-none");
            	$("#applytab").addClass("d-none");
            	$("#apply").removeClass("d-none");
            });
            
            $(document).delegate("#applytab", "click",function(){
//            	parent.jMap.controller.removeArrowLinkId($(this).attr("idarrow"));
            	$("#tab02").addClass("d-none");
            	$("#tab01").removeClass("d-none");
            	$("#backtab").addClass("d-none");
            	$("#applytab").addClass("d-none");
            	$("#apply").removeClass("d-none");
            	if(currentID == null) return;
            	var color = $('#color').val();
                if (color == '') color = '#000000';
    			var width = $("#arrowWidth").val();
    			if(width < 1) width = 4;
    			var start = $("#s1").val();
    			var end = $("#s3").val();
    			var line = $("#s2").val();
    			
                parent.jMap.controller.settingArrowLinkAttr(currentID,
                		color,width, line == "1" ? 1 : 2,start == "2",end == "2");
            });
            
            var lastSelected;
            $(document).delegate("#addArrow", "click",function(){
//            	parent.jMap.controller.removeArrowLinkId($(this).attr("idarrow"));
            	parent.__$("#iframeDialog").modal("hide");
            	lastSelected = parent.jMap.getSelected();
            	if(parent.lastSelected != null) lastSelected = parent.lastSelected;
            	parent.lastSelected = lastSelected;
            }); */
            var settingArrowLinkAction = function() {
            	var node = parent.jMap ? parent.jMap.getSelected() : null;
                var lastNode = parent.lastSelected;
                var currentLink = parent.jMap.controller.getSelectedLink(lastNode, node);
                if(currentLink == null) currentLink = parent.jMap.controller.createSelectedLink(lastNode, node);
                parent.jMap.controller.settingArrowLinkText(currentLink.id, $("#arrowText").val());
                
          
            	var color = $('#color').val();
                if (color == '') color = '#000000';
    			var width = $("#arrowWidth").val();
    			if(width < 1) width = 4;
    			var start = $("#s1").val();
    			var end = $("#s3").val();
    			var line = $("#s2").val();
    			
    			parent.jMap.controller.settingArrowLinkAttr(currentLink.id,
                		color,width, line == "1" ? 1 : 2,start == "2",end == "2");
    			parent.lastSelected = null;
    			parent.JinoUtil.closeDialog();	        
            }
            
            var loadSetting = function(){
            	var node = parent.jMap ? parent.jMap.getSelected() : null;
                var lastNode = parent.lastSelected;
                var link = parent.jMap.controller.getSelectedLink(lastNode, node);
                
            	if(link != undefined ){
            		$('#color').val(link.getColor());
            		$("#arrowWidth").val(link.getLineWidth() > 0 ? link.getLineWidth() : "4");
            		$("#arrowText").val(link.getText());
            		$("#s1").val(link.getStart());
            		$("#s3").val(link.getEnd());
            		$("#s2").val(link.getStyle());
            	} 
            	picker = $("#color").spectrum({
                    allowEmpty: true,
                    color: (link  ? link.getColor() : '#000000'),
                    showInput: true,
                    containerClassName: "full-spectrum",
                    showInitial: true,
                    showAlpha: true,
                    maxPaletteSize: 10,
                    preferredFormat: "hex",
                    showPalette: true,
                    showSelectionPalette: true,
                    showButtons: false,
                    showPaletteOnly: true,
                    flat: true,
                    localStorageKey: "spectrum.mindmap",
                    move: function (color) {
                        $("#color").val(color);
                    },
                    show: function () {
                        $("#colorPicker").removeClass("sp-palette-only");
                    },
                    beforeShow: function () { },
                    hide: function (color) { },
                    palette: [
                        [
                            "rgb(0, 0, 0)", "rgb(67, 67, 67)", "rgb(102, 102, 102)", /*"rgb(153, 153, 153)","rgb(183, 183, 183)",*/
                            "rgb(204, 204, 204)", "rgb(217, 217, 217)", /*"rgb(239, 239, 239)", "rgb(243, 243, 243)",*/ "rgb(255, 255, 255)"
                        ],
                        [
                            "rgb(152, 0, 0)", "rgb(255, 0, 0)", "rgb(255, 153, 0)", "rgb(255, 255, 0)", "rgb(0, 255, 0)",
                            "rgb(0, 255, 255)", "rgb(74, 134, 232)", "rgb(0, 0, 255)", "rgb(153, 0, 255)", "rgb(255, 0, 255)"
                        ],
                        [
                            "rgb(230, 184, 175)", "rgb(244, 204, 204)", "rgb(252, 229, 205)", "rgb(255, 242, 204)", "rgb(217, 234, 211)",
                            "rgb(208, 224, 227)", "rgb(201, 218, 248)", "rgb(207, 226, 243)", "rgb(217, 210, 233)", "rgb(234, 209, 220)",
                            "rgb(221, 126, 107)", "rgb(234, 153, 153)", "rgb(249, 203, 156)", "rgb(255, 229, 153)", "rgb(182, 215, 168)",
                            "rgb(162, 196, 201)", "rgb(164, 194, 244)", "rgb(159, 197, 232)", "rgb(180, 167, 214)", "rgb(213, 166, 189)",
                            "rgb(204, 65, 37)", "rgb(224, 102, 102)", "rgb(246, 178, 107)", "rgb(255, 217, 102)", "rgb(147, 196, 125)",
                            "rgb(118, 165, 175)", "rgb(109, 158, 235)", "rgb(111, 168, 220)", "rgb(142, 124, 195)", "rgb(194, 123, 160)",
                            "rgb(166, 28, 0)", "rgb(204, 0, 0)", "rgb(230, 145, 56)", "rgb(241, 194, 50)", "rgb(106, 168, 79)",
                            "rgb(69, 129, 142)", "rgb(60, 120, 216)", "rgb(61, 133, 198)", "rgb(103, 78, 167)", "rgb(166, 77, 121)",
                            /*"rgb(133, 32, 12)", "rgb(153, 0, 0)", "rgb(180, 95, 6)", "rgb(191, 144, 0)", "rgb(56, 118, 29)",
                            "rgb(19, 79, 92)", "rgb(17, 85, 204)", "rgb(11, 83, 148)", "rgb(53, 28, 117)", "rgb(116, 27, 71)",*/
                            "rgb(91, 15, 0)", "rgb(102, 0, 0)", "rgb(120, 63, 4)", "rgb(127, 96, 0)", "rgb(39, 78, 19)",
                            "rgb(12, 52, 61)", "rgb(28, 69, 135)", "rgb(7, 55, 99)", "rgb(32, 18, 77)", "rgb(76, 17, 48)"
                        ]
                    ]
                });
            }
            
            $(document).delegate("#removeLink", "click",function(){
            	var node = parent.jMap ? parent.jMap.getSelected() : null;
                var lastNode = parent.lastSelected;
                var currentLink = parent.jMap.controller.getSelectedLink(lastNode, node);
                if(currentLink != null)
            		parent.jMap.controller.removeArrowLinkId(currentLink.id);
                parent.lastSelected = null;
                parent.JinoUtil.closeDialog();	
            });

            $("#frm_confirm").submit(function (event) {
                event.preventDefault();
                settingArrowLinkAction(); 
                /* var arrs = $(".arrowTxt");
                for(var i = 0; i<arrs.length; i++){
                	console.log($(arrs[i]).attr("idarrow"));
                	parent.jMap.controller.settingArrowLinkText($(arrs[i]).attr("idarrow"), $(arrs[i]).val());
                }
//                parent.lastSelected.focus();
                parent.lastSelected = null;*/
               
              
            });
            loadSetting();
        });
    </script>
</head>

<body>
    <div class="container-fluid py-3" style="height: 500px; max-width: 500px; min-height: 500px">
        <form id="frm_confirm" class="text-center">
        	<!-- <div id="tab01" style="height: 420px;">
        		<div id="arrowText" style="height: 420px;max-height: 420px;/*  overflow-y: scroll; */">
	        		
        		</div>
        	</div> -->
        	<div class="form-group">
				<label>
					<spring:message code='arrow.Text' />
				</label>
				<input type="text" class="form-control" min="1" id="arrowText">
			</div>
       		<div class="form-group">
				<label>
					<spring:message code='arrow.Color' />
				</label>
				<input type="text" id="color" name="color" />
            	<div id="colorpicker"></div>
			</div>
            
			<div class="form-group">
				<label>
					<spring:message code='arrow.Width' />
				</label>
				<input type="number" class="form-control" value="4" min="1" id="arrowWidth">
			</div>
			<div class="form-group">
				<label>
					<spring:message code='arrow.Style' />
				</label>
				<div class="row mx-2">
				  <select class="custom-select col" id="s1">	  
					    <option value="1" selected>None start</option>
					    <option value="2">Arrow start</option>
				  </select>
				   <select class="custom-select col" id="s2">
					    <option value="1" selected>Line</option>
					    <option value="2">Dash</option>
				  </select>
				   <select class="custom-select col" id="s3">
					   <option value="1">None end</option>
					   <option value="2" selected>Arrow end</option>
				  </select>				  
				</div>
			</div>
            <div class="text-center mt-4">
           		<%-- <button type="button" class="btn btn-primary btn-min-w d-none" id="backtab">
                   Back
                </button>
                
                <button type="button" class="btn btn-danger btn-min-w d-none" id="applytab">
                    <spring:message code='button.apply' />
                </button>
                 --%>
                <button type="submit" class="btn btn-primary btn-min-w" id="apply">
                    <spring:message code='button.apply' />
                </button>
                
                <button type="button" id="removeLink" class="btn btn-danger btn-min-w">
                    <spring:message code='common.delete' />
                </button>
            </div>
        </form>
    </div>

</body>

</html>