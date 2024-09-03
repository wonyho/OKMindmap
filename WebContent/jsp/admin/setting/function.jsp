<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="env" uri="http://www.servletsuite.com/servlets/enventry" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
	<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
	<META HTTP-EQUIV="Expires" CONTENT="0">
		
	<title>Group</title>
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/tables.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
	<script src="${pageContext.request.contextPath}/lib/jquery.min.js?v=<env:getEntry name="versioning"/>" type="text/javascript" charset="utf-8"></script>
	
	<style>
		#content > table > tbody > tr:nth-child(even){
			background-color: #f5f5f5;
		}
	</style>

	<script type="text/javascript">
	
		var retGuestMap = false;
		var retMaxMap = false;
		var retMoodleConnections = false;
		var retNodejsUrl = false;
		var retNoderedConnections = false;
		var rettranslate = false;
		
		var moodleConnections = '${data.moodle_connections}';
		var noderedConnections = '${data.nodered_connections}';
	
		function setGuestMap(el) {
			var checked = ($(el).is(':checked'))?1:0;
			retGuestMap = false;
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {	'func': 'set',
							'key': 'guest_map_allow',
							'value': checked
				},
				success: function(data) {
					retGuestMap = true;
					//console.log(data)
				},
				error: function(data, status, err) {
					alert("setGuestMap error : " + status);
				}
			});
		}
		
		function setMaxMap() {
			var maxmap = $('#setting_max_map').val();
			retMaxMap = false;
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {	'func': 'set',
							'key': 'create_max_map',
							'value': maxmap
				},
				success: function(data) {
					retMaxMap = true;
					//console.log(data)
				},
				error: function(data, status, err) {
					alert("setGuestMap error : " + status);
				}
			});
		}
		
		function initMoodleConnections(){
			var data = moodleConnections == '' ? [] : JSON.parse(moodleConnections);
			$.each(data, (idx, val)=>{
				addMoodleConnection(val.name, val.url, val.secret, val.creator_group_id);
			});
		}
		
		function addMoodleConnection(name, url, secret, group){
			let _name = name || '';
			let _url = url || '';
			let _secret = secret || Math.random().toString(36).substring(2,10) + Math.random().toString(36).substring(2,10);
			let _group = group || '';
			$('<tr class="moodle_connection">'
					+'<td><input type="text" id="name" value="'+_name+'" /></td>'
					+'<td><input type="text" id="url" value="'+_url+'" /></td>'
					+'<td><input type="text" id="secret" value="'+_secret+'" /></td>'
					+'<td><input type="number" min="0" id="creator_group_id" value="'+_group+'" /></td>'
					+'<td><button onclick="$(this).parent().parent().remove()">Remove</button></td>'
				+'</tr>').appendTo( "#moodle_connections" );
		}
		
		function getMoodleConnections(){
			var data = [];
			$('#moodle_connections .moodle_connection').each((idx, el)=>{
			 	data.push({
			 		name: $(el).children().children('#name').val(),
			 		url: $(el).children().children('#url').val(),
			 		secret: $(el).children().children('#secret').val(),
			 		creator_group_id: $(el).children().children('#creator_group_id').val()
			 	});
			})
			return data;
		}
		
		function setMoodleConnections() {
			var moodle_connections = JSON.stringify(getMoodleConnections());
			retMoodleConnections = false;
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {	'func': 'set',
							'key': 'moodle_connections',
							'value': moodle_connections
				},
				success: function(data) {
					retMoodleConnections = true;
					//console.log(data)
				},
				error: function(data, status, err) {
					alert("setMoodleConnections error : " + status);
				}
			});
		}

		function setNodejsUrl() {
			var nodejsUrl = $('#setting_nodejs_url').val();
			retNodejsUrl = false;
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {	'func': 'set',
							'key': 'nodejs_url',
							'value': nodejsUrl
				},
				success: function(data) {
					retNodejsUrl = true;
				},
				error: function(data, status, err) {
					alert("setNodejsUrl error : " + status);
				}
			});
		}
		
		function setTranslateAPI() {
			var translate_api = $('#setting_translate_api').val();
			rettranslate = false;
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {	'func': 'set',
							'key': 'translate_api',
							'value': translate_api
				},
				success: function(data) {
					rettranslate = true;
				},
				error: function(data, status, err) {
					alert("Set translate API error : " + status);
				}
			});
		}
		
		function getNoderedConnections(){
			var data = [];
			$('#nodered_connections .nodered_connection').each((idx, el)=>{
			 	data.push({
			 		username: $(el).children().children("input[key='username']").val(),
			 		password: $(el).children().children("input[key='password']").val()
			 	});
			})
			return data;
		}
		
		function setNoderedConnections() {
			var nodered_connections = JSON.stringify(getNoderedConnections());
			retNoderedConnections = false;
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {	'func': 'set',
							'key': 'nodered_connections',
							'value': nodered_connections
				},
				success: function(data) {
					retNoderedConnections = true;
				},
				error: function(data, status, err) {
					alert("setNoderedConnections error : " + status);
				}
			});
		}
		
		function addNoderedConnection(account){
			account = account || {};
			let _username = account.username || '';
			let _password = account.password || '';
			$('<tr class="nodered_connection">'
					+'<td><input type="text" key="username" value="'+_username+'" /></td>'
					+'<td><input type="password" key="password" value="'+_password+'" /></td>'
					+'<td><button onclick="$(this).parent().parent().remove()">Remove</button></td>'
				+'</tr>').appendTo( "#nodered_connections" );
		}
		
		function initNoderedConnections(){
			var data = noderedConnections == '' ? [] : JSON.parse(noderedConnections);
			$.each(data, (idx, val)=>{
				addNoderedConnection(val);
			});
		}

		function setGATrackingId() {
			var trackingId = $('#setting_ga_trackingId').val();
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {
					'func': 'set',
					'key': 'ga_trackingId',
					'value': trackingId
				},
				success: function(data) {
					//
				},
				error: function(data, status, err) {
					alert("setGATrackingId error : " + status);
				}
			});
		}

		function setDefaultAccountLevel(role) {
			var level_id = $('#setting_default_account_level_'+role).val();
			
			$.ajax({
				type: 'post',
				dataType: 'json',
				async: false,
				url: '${pageContext.request.contextPath}/mindmap/admin/setting/function.do',
				data: {
					'func': 'set',
					'key': 'default_account_level_'+role,
					'value': level_id
				},
				success: function(data) {
					//
				},
				error: function(data, status, err) {
					alert("setDefaultAccountLevel error : " + status);
				}
			});
		}
		
		function apply() {
			setGuestMap();
			setMaxMap();
			setMoodleConnections();
			setNodejsUrl();
			setNoderedConnections();
			setGATrackingId();
			setDefaultAccountLevel('teacher');
			setTranslateAPI();
			
			if(retMaxMap && retMaxMap && retMoodleConnections && retNodejsUrl && retNoderedConnections) {
				alert("적용 되었습니다.");
			}
		}
		
		function init_d(){
			initMoodleConnections();
			initNoderedConnections();
		}
		$(document).ready( init_d );
	</script>

</head>
<body>
<div class="table_box">
	<div class="table_box_title">기능설정</div>
	<div class="table_box_con">
	<div id="content">
	
	
	<table width="100%">
	<tr>
		<th width="30%">기능</th><th width="70%">설정값</th>
	</tr>
	<tr>
		<td>손님맵 생성 허용</td>
		<td><input type="checkbox" id="setting_guestmap" name="setting_guestmap" <c:if test="${data.guest_map_allow == 1}">checked</c:if>/></td>
	</tr>
	<tr>
		<td>맵 갯수 제한</td>
		<td><input type="text" id="setting_max_map" name="setting_max_map" value="<c:out value="${data.create_max_map}"/>"/></td>
	</tr>
	<tr>
		<td>Moodle Connections</td>
		<td>
			<table width="100%" id="moodle_connections">
				<tr>
					<td width="20%">Site name</td>
					<td width="35%">URL</td>
					<td width="30%">Secret key</td>
					<td width="15%">Creator group ID</td>
					<td></td>
				</tr>
			</table>
			<div align="center" class="center_btn">
				<button onclick="addMoodleConnection();">Add connection</button>
			</div>
		</td>
	</tr>
	<tr>
		<td>Nodejs url</td>
		<td><input type="text" id="setting_nodejs_url" name="setting_nodejs_url" value="<c:out value="${data.nodejs_url}"/>"/></td>
	</tr>
	<tr>
		<td>Node-RED Connections<br><i>(The list of accounts is allowed to connect Node-red to Nodejs)</i></td>
		<td>
			<table width="100%" id="nodered_connections">
				<tr>
					<td width="40%">Username</td>
					<td width="40%">Password</td>
					<td></td>
				</tr>
			</table>
			<div align="center" class="center_btn">
				<button onclick="addNoderedConnection();">Add account</button>
			</div>
		</td>
	</tr>
	<tr>
		<td>Google Analytics</td>
		<td>
			<table width="100%" id="nodered_connections">
				<tr>
					<td width="100%">Measurement ID/ Web Property ID</td>
				</tr>
				<tr>
					<td>
						<input type="text" placeholder="UA-XXXX-Y" id="setting_ga_trackingId" name="setting_ga_trackingId" value='<c:out value="${data.ga_trackingId}"/>'/>
					</td>	
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>Google Translate API key</td>
		<td><input type="text" id="setting_translate_api" name="setting_translate_api" value="<c:out value="${data.translate_api}"/>"/></td>
	</tr>
	<tr>
		<td>
			Account-level management<br>
			<i>(The default role when the user registers)</i>
		</td>
		<td>
			<table width="100%" id="nodered_connections">
				<tr>
					<td style="width: 30%;">Teachers</td>
					<td style="text-align: left;">
						<input type="text" placeholder="Level ID" id="setting_default_account_level_teacher" name="setting_default_account_level_teacher" value='<c:out value="${data.default_account_level_teacher}"/>'/>
					</td>	
				</tr>
			</table>
		</td>
	</tr>
	</table>
	
	<div align="center" class="center_btn">
		<button onclick="apply();">적용</button>
	</div>
	
	</div>
	
	</div>
	</div>
</body>
</html>
