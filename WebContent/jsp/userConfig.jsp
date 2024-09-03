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
		<spring:message code='menu.usrpreference' />
	</title>
	<script type="text/javascript">
				const default_img_size = parseInt('<c:out value="${data.default_img_size.data}"/>');
				const default_video_size = parseInt('<c:out value="${data.default_video_size.data}"/>');
				const default_node_size = parseInt('<c:out value="${data.default_node_size.data}"/>');
				const default_rMaps_size = parseInt('<c:out value="${data.default_rMaps_number.data}"/>');
				const default_menu_opacity = '<c:out value="${data.default_menu_opacity.data}"/>';

				function userComplete() {
					var configs = {
						'default_img_size': $('#default-img-size').val(),
						'default_video_size': $('#default-video-size').val(),
						'default_node_size': $('#default-node-size').val(),
						'default_rMaps_number': $('#default-rMaps-size').val(),
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
					$('#default-rMaps-size').val(default_rMaps_size || parent.jMap.cfg.default_rMaps_size);
					$('#default_menu_opacity').prop('checked', default_menu_opacity == '' ? parent.jMap.cfg.default_menu_opacity == 'true' : default_menu_opacity == 'true');

					$("#user_preference").submit(function (event) {
						event.preventDefault();
						userComplete();
					});
				});
			</script>
</head>

<body>
	<div class="container-fluid py-3" style="max-width: 300px;">
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
				<input type="number" class="form-control" min="3" id="default-node-size">
			</div>
			
			<div class="form-group">
				<label>
					<spring:message code='setting.rMaps_size' />
				</label>
				<input type="number" class="form-control" min="10" id="default-rMaps-size">
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
	</div>
</body>

</html>