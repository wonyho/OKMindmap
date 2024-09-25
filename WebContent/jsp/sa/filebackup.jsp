<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<jsp:include page="components/head.jsp" />
<div class="d-flex justify-content-between page-tool-bar py-3 ">
	<div class="left-tool">
		<button type="button" class="btn btn-sm btn-primary" id="openOkmCloudSetting">Setting</button>
		<button type="button" class="btn btn-sm btn-danger text-white" id="okmCloudStatus">Disconnected</button>
	</div>
	<div class="right-tool d-flex">
		<input type="text" value="${data.search}" id="searchkey"
			placeholder="Map name, owner name" aria-label="Search..."
			aria-describedby="search_key">
		<button class="btn btn-sm  btn-outline-secondary" type="button"
			id="search_key"
			onclick="location.href='${pageContext.request.contextPath}/sa/uploadbackup.do?search=' + $('#searchkey').val()">Search</button>
		<button class="btn btn-sm btn-info text-white">${data.rows}
			Maps</button>
	</div>
</div>
<table class="table table-hover table-bordered">
	<thead>
		<tr>
			<th class="text-center align-middle" scope="col" rowspan="2">Map</th>
			<th class="text-center align-middle" scope="col" rowspan="2">Name</th>
			<th class="text-center align-middle" scope="col" rowspan="2">Nodes</th>
			<th class="text-center align-middle" scope="col" rowspan="2">Files</th>
			<th class="text-center align-middle" scope="col" colspan="6">Node
				Uploaded Files</th>
		</tr>
		<tr>
			<th class="text-center align-middle" scope="col">Fnode</th>
			<th class="text-center align-middle" scope="col">Totals</th>
			<th class="text-center align-middle" scope="col">Missed</th>
			<th class="text-center align-middle" scope="col">Safe</th>
			<th class="text-center align-middle" scope="col">Lost</th>
			<th class="text-center align-middle" scope="col">Used</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="map" items="${data.maps}">
			<tr>
				<td class="text-center align-middle"><a
					href="${pageContext.request.contextPath}/map/${map.key}"
					target="_blank">${map.id}</a></td>
				<td class="text-center align-middle">${map.name}</td>
				<td class="text-center align-middle">${map.getCounter("nodes")}</td>
				<td class="text-center align-middle">${map.getCounter("files")}</td>
				<td class="text-center align-middle">${map.getCounter("fnodes")}</td>
				<td class="text-center align-middle">${map.getCounter("nfiles")}</td>
				<td class="text-center align-middle">${map.getCounter("lost")}</td>
				<td class="text-center align-middle">0</td>
				<td class="text-center align-middle">0</td>
				<td class="text-center align-middle">${map.getCounter("used")}
					KB</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<div style="overflow: auto; text-align: center;" class="py-3 ">
	<nav aria-label="navigation" class="d-inline-block">
		<ul class="pagination paginate-html"></ul>
	</nav>
</div>

<div class="modal fade" id="okmSetting" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="okmSettingLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="okmSettingLabel">OkmCloud Setting</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      	<form id="okmSettingForm" action="${pageContext.request.contextPath}/api/okmcloud/setting.do" method="post">
	      	<input class="form-control mb-2" name="host" type="text" placeholder="OkmCloud server" aria-label="OkmCloud server">
	        <input class="form-control mb-2" name="app" type="text" placeholder="App name" aria-label="App name">
	        <input class="form-control mb-2" name="user" type="text" placeholder="User name" aria-label="User name">
	        <input class="form-control" name="key" type="text" placeholder="Private key" aria-label="Private key">
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button id="saveOkmSetting" type="button" class="btn btn-primary">Submit</button>
      </div>
    </div>
  </div>
</div>

<jsp:include page="components/foot.jsp" />
<script type="text/javascript">
var baseurl = '${pageContext.request.contextPath}';
paginate_init('${pageContext.request.contextPath}/sa/uploadbackup.do?search=${data.search}&page=', ${data.page}, ${data.pages});	

$(document).ready(function(){
	checkOkmCloudConnection();
})

$("#openOkmCloudSetting").click(function(){
	$("#okmSetting").modal("show");
})

$("#saveOkmSetting").click(function(){
	var frm = $('#okmSettingForm');
	$.ajax({
        type: frm.attr('method'),
        url: frm.attr('action'),
        data: frm.serialize(),
        success: function (data) {
        	checkOkmCloudConnection();
        	$("#okmSetting").modal("hidden");
        },
        error: function (data) {
			
        },
    });
})

var checkOkmCloudConnection = function(){
	$.ajax({
        type: "post",
        url: baseurl +"/api/okmcloud/info.do",
        data: {},
        success: function (data) {
        	if(data.connected == true){
        		$("#okmCloudStatus").removeClass("btn-danger");
        		$("#okmCloudStatus").addClass("btn-success");
        		$("#okmCloudStatus").text("Connected");
        	}else{
        		$("#okmCloudStatus").removeClass("btn-success");
        		$("#okmCloudStatus").addClass("btn-danger");
        		$("#okmCloudStatus").text("Disconnected");
        	}
        },
        error: function (data) {
			
        },
    });
} 
</script>

