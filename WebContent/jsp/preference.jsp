<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ page import="com.okmindmap.util.PagingHelper"%>
<%@ page import="java.util.HashMap"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	Locale locale = RequestContextUtils.getLocale(request);
	request.setAttribute("locale", locale);

	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<!DOCTYPE html>
<html lang="${locale.language}">

<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
	<!-- Theme -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
	<script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

	<title>
		<spring:message code='menu.okmpreference' />
	</title>

	<script type="text/javascript">
		function changePreference(type) {
			if (type == "map")
				document.location.href = "${pageContext.request.contextPath}/mindmap/mappreference.do?mapid=" + parent.jMap.cfg.mapId;
			else if (type == "user")
				document.location.href = "${pageContext.request.contextPath}/user/userconfig.do?userid=" + parent.jMap.cfg.userId;
		}
	</script>

	<c:choose>
		<c:when test="${data.preference_type eq 'map_preference'}">
			<script type="text/javascript">
				function mapComplete() {
					$.ajax({
						type: 'post',
						async: false,
						url: parent.jMap.cfg.contextPath + '/mindmap/changeMap.do',
						data: {
							'mapId': parent.mapId,
							'lazyloading': $('#lazyloading-check').is(':checked') ? 1 : 0,
							'queueing': $('#queue-check').is(':checked') ? 1 : 0
						},
						success: function (data) {
							parent.window.location.reload(true);
						},
						error: function (data, status, err) {
							alert("err : " + status);
						}
					});
				}

				$(document).ready(function () {
					$("#map_preference").submit(function (event) {
						event.preventDefault();
						mapComplete();
					});
				});
			</script>
		</c:when>
		<c:when test="${data.preference_type eq 'user_preference'}">
			<script type="text/javascript">
				const default_img_size = parseInt('<c:out value="${data.default_img_size.data}"/>');
				const default_video_size = parseInt('<c:out value="${data.default_video_size.data}"/>');
				const default_node_size = parseInt('<c:out value="${data.default_node_size.data}"/>');
				const default_menu_opacity = '<c:out value="${data.default_menu_opacity.data}"/>';

				function userComplete() {
					var configs = {
						'default_img_size': $('#default-img-size').val(),
						'default_video_size': $('#default-video-size').val(),
						'default_node_size': $('#default-node-size').val(),
						'default_menu_opacity': $('#default_menu_opacity').is(':checked')
					};

					var userid = parent.jMap.cfg.userId;
					var params = 'userid=' + userid + '&';
					for (var config in configs) {
						params += 'fields=' + config + '&';
						if (configs[config] == undefined) configs[config] = '';
						params += 'data=' + configs[config] + '&';
					}
					params += 'confirmed=' + 1;

					$.ajax({
						type: 'post',
						async: false,
						url: parent.jMap.cfg.contextPath + '/user/userconfig.do',
						data: params,
						success: function (data) {
							var calcBodySize = false;
							if (parent.jMap.cfg.default_node_size != configs['default_node_size'] && ['jRect', 'jPadletNode'].indexOf(parent.jMap.rootNode.type) != -1) {
								calcBodySize = true;
							}
							// 현재 상태에서 환경설정 저장
							for (config in configs) {
								parent.jMap.cfg[config] = configs[config];
							}

							if (calcBodySize) {
								for (var iid in parent.jMap.nodes) {
									if (typeof parent.jMap.nodes[iid].CalcBodySize == 'function') {
										parent.jMap.nodes[iid].CalcBodySize();
									}
								}
								parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfWholeMap();
							}

							parent.setMenuOpacity(configs.default_menu_opacity);
							parent.JinoUtil.closeDialog();
						}, error: function (data, status, err) {
							alert("userConfig : " + status);
						}
					});
				}

				$(document).ready(function () {
					$('#default-img-size').val(default_img_size || parent.jMap.cfg.default_img_size);
					$('#default-video-size').val(default_video_size || parent.jMap.cfg.default_video_size);
					$('#default-node-size').val(default_node_size || parent.jMap.cfg.default_node_size);
					$('#default_menu_opacity').prop('checked', default_menu_opacity == '' ? parent.jMap.cfg.default_menu_opacity == 'true' : default_menu_opacity == 'true');

					$("#user_preference").submit(function (event) {
						event.preventDefault();
						userComplete();
					});
				});
			</script>
		</c:when>
	</c:choose>
</head>

<body>
	<header>
		<nav class="navbar navbar-expand navbar-dark bg-primary py-0 position-relative" style="overflow: auto;white-space: nowrap;">
			<div class="collapse navbar-collapse justify-content-center">
				<ul class="navbar-nav">
					<li class="nav-item mx-2 ${data.preference_type == 'map_preference' ? 'active font-weight-bold':''}">
						<a class="nav-link cursor-pointer" onclick="changePreference('map')">
							<spring:message code='setting.map' />
						</a>
					</li>
					<li class="nav-item mx-2 ${data.preference_type == 'user_preference' ? 'active font-weight-bold':''}">
						<a class="nav-link cursor-pointer" onclick="changePreference('user')">
							<spring:message code='setting.user' />
						</a>
					</li>
				</ul>
			</div>
		</nav>
	</header>
	<div class="container-fluid py-3" style="max-width: 300px;">
		<c:choose>
			<c:when test="${data.preference_type eq 'map_preference'}">
				<form id="map_preference">
					<div class="form-group">
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" id="lazyloading-check" <c:if test="${data.lazyloading eq '1'}">checked</c:if> />
							<label class="custom-control-label" for="lazyloading-check">
								<spring:message code='setting.lazy_loading' />
							</label>
						</div>
					</div>

					<div class="form-group">
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" id="queue-check" <c:if test="${data.queueing}">checked</c:if> />
							<label class="custom-control-label" for="queue-check">
								<spring:message code='preference.stackqueue' />
							</label>
						</div>
					</div>

					<div class="text-center">
						<button type="submit" class="btn btn-primary btn-min-w">
							<spring:message code='button.apply' />
						</button>
					</div>
				</form>
			</c:when>
			<c:when test="${data.preference_type eq 'user_preference'}">
				<form id="user_preference">
					<div class="form-group">
						<label>
							<spring:message code='setting.image_size' />
						</label>
						<input type="number" class="form-control" min="0" id="default-img-size">
					</div>

					<div class="form-group">
						<label>
							<spring:message code='setting.video_size' />
						</label>
						<input type="number" class="form-control" min="0" id="default-video-size">
					</div>

					<div class="form-group">
						<label>
							<spring:message code='setting.node_size' />
						</label>
						<input type="number" class="form-control" min="10" id="default-node-size">
					</div>

					<div class="form-group">
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" id="default_menu_opacity" />
							<label class="custom-control-label" for="default_menu_opacity">
								<spring:message code='setting.menu_opacity' />
							</label>
						</div>
					</div>

					<div class="text-center">
						<button type="submit" class="btn btn-primary btn-min-w">
							<spring:message code='button.apply' />
						</button>
					</div>
				</form>
			</c:when>
		</c:choose>
	</div>
</body>

</html>