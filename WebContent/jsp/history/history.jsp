<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<script type="text/javascript">
$(document).ready(function(){
	$("#rightpanel-tl").eq(0).on('mousewheel DOMMouseScroll touchmove scroll', function(event) {
		if(document.getElementById("okm-tl").style.height == "100%"){
			document.getElementById("okm-tl").style.height = "auto";
		}
	    var elem = $("#rightpanel-tl").eq(0);
	    if(historyScroll){
	    	if(elem[0].scrollHeight - elem.scrollTop() <= elem.outerHeight()) {
	            $("#okm-tl .cd-timeline__read-more").show();
	        } else{
	        	$("#okm-tl .cd-timeline__read-more").hide();
	        }	
	    }        
	});	
})

var curPage = 1;
var pageCount = 1;
var nextPage = 0;
var fnName = "";

$(function(){
	$('*[name=tl_start_time]').appendDtpicker({
		"closeOnSelected": true
	});
	
	$('*[name=tl_end_time]').appendDtpicker({
		"closeOnSelected": true
	});
	
	<c:choose>
	  <c:when test="${ not empty data.orgStartDate }">
	  	$('#tl_start_time').val("${data.orgStartDate}");
	  </c:when>
	  <c:when test="${ not empty data.orgEndDate }">
	 	$('#tl_end_time').val("${data.orgEndDate}");
	  </c:when>
	  <c:otherwise>
		<c:if test="${not empty data.firstDate}">
			<c:forEach var="firstDate" items="${data.firstDate}">
				$('#tl_start_time').val("${firstDate.unixSaved}");
			</c:forEach>
		</c:if>
	  </c:otherwise>
	</c:choose> 
	
	<c:if test="${not empty data.historyUsers}">
		<c:forEach var="historyUsers" items="${data.historyUsers}" varStatus="status">
			<c:if test="${status.first}">
				tmpTlList1.push("전체");
			</c:if>
			console.log("${historyUsers.actionUser}");
			tmpTlList1.push("${historyUsers.actionUser}");
		</c:forEach>
	</c:if>
});
</script>
     <c:if test="${not empty data.history}">
	     <c:forEach var="history" items="${data.history}" varStatus="status">
		    <div class="cd-timeline__block js-cd-block">
				<div class="cd-timeline__content js-cd-content">
					<span class="cd-timeline__date">
						<h4>
							${history.unixSaved}&nbsp;
							${history.actionUser}&nbsp;
							<spring:message code='history.${history.actionName}'/>&nbsp;
							<spring:message code='history.${history.actionType}'/>
						</h4>
					</span>
					<c:if test="${not empty history.actionDesc}">
						<p id="cd-timeline__more" onclick="historyMore(this);">
							<spring:message code='history.inner.more'/>
						</p>
					</c:if>
					<p id="cd-timeline__hidden">${history.actionDesc}</p>
				</div>
			</div>
			<c:if test="${status.first}">
				<script type="text/javascript">
					curPage = ${history.curPage};					
					if(curPage == ""){
						curPage = 1;
					}
					
					pageCount = ${history.pageCount};					
					if(pageCount == ""){
						pageCount = 1;
					}
					
					nextPage = curPage+1;
					
					fnName = "${history.type}";					
					if(fnName == ""){
						fnName = "loadmoreHistory";
					}
					
					//tmpTlList1.push("전체");
				</script>
			</c:if>
			
			<c:if test="${status.last}">
				<script type="text/javascript">
					$.each(tmpTlList1, function (index, element){
					    if ($.inArray(element, tmpTlList2) == -1){
					    	tmpTlList2.push(element);
					    	//$("#tl_select_name").append('<option value="">' + element + '</option>');
					    }
					});
					
					$("#tl_select_td option").remove();
					for(var i=0;i<tmpTlList2.length;i++){
						$("#tl_select_name").append('<option value="' + i + '">' + tmpTlList2[i] + '</option>');
					}
					
					<c:if test="${not empty data.selectedVal}">
						$("#tl_select_name").val("${data.selectedVal}");
					</c:if>

					if(pageCount < curPage){
						timelineScroll = false;
					}
				</script>
				<c:if test="${status.count == 10}">	
					<script type="text/javascript">	
						var makeTlListHtml = '<div class="cd-timeline__load"><a href="#0" class="cd-timeline__read-more" onclick="' + fnName + '(' + nextPage + ')">Read more</a></div>';
						$("#okm-tl .cd-timeline__load").remove();
						$("#okm-tl section").eq(1).prepend(makeTlListHtml);			
					</script>
				</c:if>
			</c:if>
		</c:forEach>
    </c:if>   
    <c:if test="${empty data.history}">
    	 <script type="text/javascript">
    		$("#okm-tl").attr("style", "height:100%;");
    	 </script>
    	 	<div class="cd-timeline__block js-cd-block">
				<div class="cd-timeline__content js-cd-content">
					<span class="cd-timeline__date" style="font-size: 15px;">
						<h4><spring:message code='history.no.data'/></h4>
					</span>
				</div>
			</div>
     </c:if>