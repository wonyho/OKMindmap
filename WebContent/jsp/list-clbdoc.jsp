<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>

<%@page import="com.okmindmap.util.PagingHelper"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
Locale locale = RequestContextUtils.getLocale(request);
request.setAttribute("locale", locale);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/okmindmap.css" type="text/css" media="screen">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/opentab.css" type="text/css" media="screen">

<script src="${pageContext.request.contextPath}/lib/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/lib/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/lib/slimScroll.min.js" type="text/javascript" charset="utf-8"></script>

<title><spring:message code='message.openmap'/></title>

<style type="text/css">
	/* active tab uses a id name ${data.mapType}. its highlight is also done by moving the background image. */
	ul.tabs a#${data.mapType}, ul.tabs a#${data.mapType}:hover, ul.tabs li#${data.mapType} a {
	background-position: -420px -62px;
	cursor:default !important;
	color:#000 !important;
	}

	.search{
		text-align: left;		
		margin: 10px;		
		font-size: 12px;
	}
	.pagenum{
		padding-top:10px; padding-bottom:10px;
	}

	th a {
		color:#ffffff;
	}
	 .<c:out value="${data.sort}"/><c:out value="${data.isAsc}"/>{
		color:yellow; font-weight:bold; font-size:1.2em;
	}
</style>

<script type="text/javascript">
var selectedItem = null;
var selectedTab = null;

function confirmDelete() {
	if(confirm( "<spring:message code='jsp.list.areyousure'/>" )) {
		//action  =
			//submit
		document.deleteForm.submit();
	//	document.location.href = "${pageContext.request.contextPath}/mindmap/delete.do?id=" + id + "&return_url=<c:url value="/mindmap/list.do"></c:url>";
	}
}

function goPage(v_curr_page){
    var frm = document.searchf;
    frm.page.value = v_curr_page;
    frm.submit();
}

function sortPage(csort, cisAsc){
    var frm = document.searchf;
    frm.sort.value = csort;
    frm.isAsc.value = cisAsc;
    frm.submit();
}

function goSearch(){
    var frm = document.searchf;
    frm.page.value = 1;
    frm.submit();
}

function checkAll(){
   cBox = document.deleteForm.del_map;
   if(cBox.length) {  // 여러 개일 경우
       for(var i = 0; i<cBox.length;i++) {
           cBox[i].checked = document.deleteForm.allcheckbox.checked;
       }
   } else { // 한 개일 경우
       cBox.checked = document.deleteForm.allcheckbox;
   }
}

function mapOfMap() {
	var frm = document.getElementById("mapofmap");
	frm.submit();
}

function list_init() {
	// 시간포멧 변경
	var created = $('.created');
	for(var i =0; i < created.length; i++) {
		var c = created[i];
		var date = new Date(parseInt(c.innerHTML));
		var format = "";
		<c:choose>
		<c:when test="${locale.language eq 'ko'}">
			format = date.format("yyyy-MM-dd");//date.getFullYear() + "-" + (date.getMonth() + 1).zf(2) + "-" + date.getDate().zf(2); 
		</c:when>
		<c:otherwise>
			format = date.format("dd-MM-yyyy");//date.getDate().zf(2) + "-" + (date.getMonth() + 1).zf(2) + "-" + date.getFullYear(); 
		</c:otherwise>
	</c:choose>
		c.innerHTML = format;
	}
}



Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";
 
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};
 
String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

$(document).ready( list_init );

$(function(){
	$('.content').slimScroll({
		start: 'top'
	}).css({marginRight: '10px' });
});

function contentSelect(el){			
	selectedItem = el;
}

function tabSelect(el){			
	selectedTab = el;
}

function selectItemComplete(){
	
	if(selectedItem == null){
		alert("선택된 목록이 없습니다.");
		return false;
	}
	
	console.log(selectedItem.children.mapId.defaultValue);
	console.log(selectedItem.children.mapName.defaultValue);
	/* var jMap = parent.jMap;
	var selected = jMap.getSelecteds().getLastElement();
	//var param = {parent: selected};
	//var newNode = jMap.createNodeWithCtrl(param);
	//selected.folded && selected.setFoldingExecute(false);
	
	jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap(); */
	
	//parent.$("#dialog").dialog("close");
}
		
function cancel(){
	parent.$("#dialog").dialog("close");
}

$(document).ready(function() {
	
	$(".clbDocContainer_row").click(function(){
		console.log(this.children.mapId.defaultValue);
		console.log(this.children.mapName.defaultValue);
		selectedItem && (selectedItem.style.background = "none");
		this.style.background = "#e7ebff";
		contentSelect(this);
	});
	
	$(".tabs li").click(function(){
		selectedTab && (selectedTab.style.background = "none");
		this.style.background = "#e7ebff";
		tabSelect(this);
	});	
});

</script>
</head>
<body>
<div class="openmapwrap">
		<!-- the tabs -->
	<ul class="tabs clbdoc_tabs">
		<li><a id="public" href="javascript:sortPage('isAsc', 'false')" class="select_tab" style="color:#000; ">일치순</a></li>		
		<li><a id="public" href="javascript:sortPage('created', 'false')" class="select_tab" style="color:#000; ">최신순</a></li>
	</ul>

	<!-- tab "panes" -->
	<div class="clbdoc">
<!--  <div class="content">-->
		<c:choose>
			<c:when test="${data.mapType eq 'user'}">
			<!-- 나의 맵 -->
					<div class="search">
						<form method=post name="searchf" onsubmit="goSearch()">
							클래스 선택
							<select name="searchfield" style="width: 85%;">
								<option value="title">클래스 선택 셀렉트 박스</option>
							</select>
							<input type="hidden" name="search" class="group_search_input" value="${data.search}">
							<input type="hidden" name="page" value="${data.page}">
							<input type="hidden" name="sort" value="${data.sort}">
							<input type="hidden" name="isAsc" value="${data.isAsc}">
							<input type="hidden" name="mapType" value="${data.mapType}">
							<%-- <input type="submit" class="search_btn" value="<spring:message code='common.search'/>"> --%>
						</form>
					</div>
						<!-- 데이터가 없으면 이 문구를 표시한다. -->
						<c:if test="${fn:length(data.maps)<1}">
							 <tr height=28>
							 	<td colspan=4 align=center>
							 		<spring:message code='message.page.list.emptymap'/>
							 	</td>
							 </tr>
						</c:if>
						
						<c:forEach var="map" items="${data.maps}" end="${data.startnum}" step="1"  varStatus="loop"	>						
							<div id="dataview-content-clbDoc">															
								<div class="clbDocContainer_row" style="text-align: left;">
									<input type="hidden" name="page" value="<c:out value="${loop.end - loop.index}"/>">
									<input type="hidden" name="mapName" value="<c:out value="${map.name}"></c:out>">
									<input type="hidden" name="mapId" value="<c:out value="${map.id}"></c:out>">
									<div class="clbDocDiv_row">
										<span class="clbDocTitle_row">
											<p>클래스 이름</p> |
											<p class="created"><c:out value="${map.created}"/><p>											
										</span>										
										<span class="clbDocDesc_row">
											<c:choose>
												<c:when test="${fn:length(map.name) > 30}">
													<c:out value="${fn:substring(map.name, 0, 28)}" />...
												</c:when>
												<c:otherwise>
													<c:out value="${map.name}"></c:out>
												</c:otherwise>
											</c:choose>
										</span>
									</div>
								</div>							
							</div>
						</c:forEach>
				
				<div class="pagenum" style="text-align:center;">
				<%
				HashMap<String, Object> data = (HashMap) request.getAttribute("data");
				out.println(PagingHelper.instance.autoPaging((Integer)data.get("totalMaps"), (Integer)data.get("pagelimit"), (Integer)data.get("plPageRange"), (Integer)data.get("page")));
				%>
				</div>
			</c:when>
		</c:choose>
		</div>
	</div>
	<div style="text-align: center;margin-top: 5px;">									
		<INPUT id="video_confirm" type="button" class="video_btn" value="<spring:message code='video.confirm'/>" onClick="selectItemComplete()">
		<INPUT id="video_cancel" type="button" class="video_btn" value="<spring:message code='video.cancel'/>" onClick="cancel()">
	</div>
	<div>
		<form id="mapofmap" action="${pageContext.request.contextPath}/mindmap/mapofmap.do" method="post" target="_parent">
		</form>
	</div>

</body>
</html>