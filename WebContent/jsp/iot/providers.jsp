<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <c:choose>
            <c:when test="${data.control eq '1'}">
                <spring:message code='menu.iotControl' />
            </c:when>
            <c:otherwise>
                <spring:message code='menu.iotProvidersAction' />
            </c:otherwise>
        </c:choose>
        <spring:message code='menu.iotProvidersAction' />
    </title>

    <style>
        .widgets {
            list-style-type: none;
            padding: 0;
        }

        .widgets .widget {
            display: inline-block;
            min-width: 30%;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 2px;
            text-align: center;
            min-height: 80px;
            cursor: pointer;
        }

        .widgets .widget:hover {
            border-color: #5cc4c8;
        }
    </style>

    <c:if test="${not empty data.emitters}">
        <script type="text/javascript">
            function DHTEmitterInit(el) {
                var temp = '<svg style="width: 200px; background-color: white;" id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 80"><path d="M22.84,61.26a3,3,0,1,1-3-2.92A3,3,0,0,1,22.84,61.26Zm1.52-3.86a5.71,5.71,0,0,1,1.52,3.86,6,6,0,0,1-6.08,5.85h0a6,6,0,0,1-6-5.88,5.68,5.68,0,0,1,1.51-3.83V48.1a4.56,4.56,0,0,1,9.12,0Zm-.76,3.86a4.2,4.2,0,0,0-1.52-3V48.1a2.28,2.28,0,0,0-4.56,0V58.22a4.23,4.23,0,0,0-1.52,3,3.75,3.75,0,0,0,3.77,3.68h0A3.73,3.73,0,0,0,23.6,61.26Z" fill="#727374"/><circle cx="9.19" cy="6.57" r="3.98" fill="#6ec5a4"/><text transform="translate(31.19 67.11)" font-size="40" fill="#333" font-family="ArialMT, Arial">23</text><text transform="translate(75.68 51.12) scale(0.58)" font-size="30" fill="#333" font-family="ArialMT, Arial">°C</text><text transform="translate(20.62 25.39)" font-size="11" fill="#727373" font-family="ArialMT, Arial"><tspan x="5.5" y="0">Temperature</tspan></text><text transform="translate(15.53 9.55)" font-size="8" fill="#6ec5a4" font-family="ArialMT, Arial">Online</text><text transform="translate(131.26 66.77)" font-size="40" fill="#333" font-family="ArialMT, Arial">80</text><text transform="translate(175.75 50.78) scale(0.58)" font-size="30" fill="#333" font-family="ArialMT, Arial">%</text><text transform="translate(130.18 25.05)" font-size="11" fill="#727373" font-family="ArialMT, Arial">Humidity</text><path d="M127.37,55.26c0-2.1-3-5.6-3.65-6.28a.8.8,0,0,0-1.12,0l0,0a25.81,25.81,0,0,0-2.85,3.88c-.49-.61-.88-1-1-1.19a.78.78,0,0,0-1.11,0l0,0a39.14,39.14,0,0,0-2.91,3.75c-.35-.6-.69-1.1-.88-1.37a.76.76,0,0,0-1.06-.19.73.73,0,0,0-.2.19c-.46.7-2,3.07-2,4.28A2.69,2.69,0,0,0,112.91,61a5.37,5.37,0,0,0,10.62-1.16,2.53,2.53,0,0,0,0-.38A4.22,4.22,0,0,0,127.37,55.26Zm-14.21,4.22A1.15,1.15,0,0,1,112,58.33a8,8,0,0,1,1.15-2.43,7.85,7.85,0,0,1,1.16,2.43A1.15,1.15,0,0,1,113.16,59.48Zm5,4.22a3.86,3.86,0,0,1-3.74-3,2.68,2.68,0,0,0,1.44-2.38,3.6,3.6,0,0,0-.32-1.25,1.16,1.16,0,0,1,.2-.47,34.66,34.66,0,0,1,2.42-3.25c1.69,2,3.84,5,3.84,6.5A3.84,3.84,0,0,1,118.15,63.7Zm5-5.75h-.1a19.19,19.19,0,0,0-2.27-3.76.75.75,0,0,1,.06-.13,19.42,19.42,0,0,1,2.31-3.38c1.25,1.54,2.68,3.62,2.68,4.58A2.69,2.69,0,0,1,123.15,58Z" fill="#727374"/><path d="M125.13,54.38l0-.05-.2-.41a.39.39,0,0,0-.53-.12.37.37,0,0,0-.14.49c.06.12.12.24.17.36a.38.38,0,0,0,.5.22A.37.37,0,0,0,125.13,54.38Z" fill="#727374"/><path d="M124.42,53.12c-.32-.47-.66-.9-.89-1.18a.38.38,0,0,0-.53-.08.4.4,0,0,0-.09.54l0,0c.22.27.54.68.84,1.12a.38.38,0,0,0,.53.11A.4.4,0,0,0,124.42,53.12Z" fill="#727374"/><path d="M119.29,62.33a.39.39,0,0,0-.48-.26,2.07,2.07,0,0,1-.66.1.38.38,0,0,0-.38.38.39.39,0,0,0,.38.39,3.23,3.23,0,0,0,.88-.13A.38.38,0,0,0,119.29,62.33Z" fill="#727374"/><path d="M121.11,59a.38.38,0,1,0-.73.22,2.32,2.32,0,0,1-.56,2.27.38.38,0,0,0,0,.54.36.36,0,0,0,.25.11.38.38,0,0,0,.28-.12A3.06,3.06,0,0,0,121.11,59Z" fill="#727374"/></svg>';
                $(el).html(temp);
            }

            function CameraEmitterInit(el) {
                var temp = '<svg style="height: 80px; background-color: white;" id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 150 100"><title>cam</title><rect x="2.37" y="3" width="145.97" height="95.33" rx="6" ry="6" fill="#414042"/><rect x="8.33" y="9.67" width="35.62" height="15.84" rx="2.53" ry="2.53" fill="#ed1c24"/><text transform="translate(15.51 22.2)" font-size="12" fill="#fff" font-family="MyriadPro-Regular, Myriad Pro">LIVE</text></svg>';
                $(el).html(temp);
            }


            function insertEmitter(attr) {
                var params = JSON.parse(decodeURI(attr));
                var node = parent.jMap.getSelected();
                if (node) {
                    if (node.getText() == '') node.setTextExecute(params.name);
                    node['set' + params.type](params);
                    parent.JinoUtil.closeDialog();
                }
            }
        </script>
    </c:if>
    <c:if test="${not empty data.listeners}">
        <script type="text/javascript">
            function SwitchListenerInit(el) {
                var temp = '<svg style="width: 100px; background-color: white;" id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 80"><title>switch-on</title><path d="M69.83,18.31H30.17a23.44,23.44,0,0,0,0,46.88H69.83a23.44,23.44,0,0,0,0-46.88Z" fill="#cfd8dc"/><circle cx="69.83" cy="41.75" r="16.23" fill="#4daf4e"/><path d="M26.56,50.76a5.41,5.41,0,0,1-5.41-5.41V38.14a5.41,5.41,0,0,1,10.82,0v7.21A5.41,5.41,0,0,1,26.56,50.76Zm0-14.42a1.81,1.81,0,0,0-1.8,1.8v7.21a1.8,1.8,0,1,0,3.6,0V38.14A1.8,1.8,0,0,0,26.56,36.34Z" fill="#455b64"/><path d="M44.59,50.76a1.79,1.79,0,0,1-1.61-1l-3.8-7.6V49a1.8,1.8,0,1,1-3.6,0V34.54A1.81,1.81,0,0,1,37,32.78a1.79,1.79,0,0,1,2,.95l3.8,7.59V34.54a1.8,1.8,0,1,1,3.6,0V49A1.79,1.79,0,0,1,45,50.71,1.51,1.51,0,0,1,44.59,50.76Z" fill="#455b64"/></svg>';
                $(el).html(temp);
            }


            function insertListener(attr) {
                var params = JSON.parse(decodeURI(attr));
                var node = parent.jMap.getSelected();
                if (node) {
                    if (node.getText() == '') node.setTextExecute(params.name);
                    node['set' + params.type](params);
                    parent.JinoUtil.closeDialog();
                }
            }
        </script>
    </c:if>

    <script type="text/javascript">
        function deleteIoT() {
            var node = parent.jMap.getSelected();
            if (node && node.attributes.iot && parent.mindmapIO) {
                parent.mindmapIO.removeListener(node.attributes.iotId);

                var attributes = node.attributes;
                delete attributes['iot'];

                node.attributes = attributes;
                node.setForeignObjectExecute(null);

                parent.jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(node);
                parent.jMap.layoutManager.layout(true);

                parent.jMap.saveAction.editAction(node);
                parent.jMap.fireActionListener(parent.ACTIONS.ACTION_NODE_ATTRS, node);
                parent.jMap.setSaved(false);
                // parent.JinoUtil.closeDialog();

                $('.btnDelete').addClass('d-none');
            }
        }

        $(function () {
            $(".w-item").each(function (index) {
                var attr = $(this).attr('w-attr');
                var params = JSON.parse(decodeURI(attr));
                window[params.type + 'Init'](this);
            });

            var node = parent.jMap ? parent.jMap.getSelected() : null;
            if (node && node.attributes.iot && parent.mindmapIO) {
                $('.btnDelete').removeClass('d-none');
            }
        });

        var closeDialog = function () {
            parent.JinoUtil.closeDialog();
        }
    </script>
</head>

<body>
    <c:if test="${empty data.message}">
        <div class="container-fluid">
            <c:choose>
                <c:when test="${not empty data.providers}">
                    <div>Please click on the name to choose provider:</div>
                    <table class="table">
                        <thead>
                            <tr class="text-primary">
                                <th style="width: 30px;">#</th>
                                <th class="tetx-center">Providers</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="provider" items="${data.providers}" varStatus="loop">
                                <tr>
                                    <td>${loop.index}</td>
                                    <td>
                                        <a class="text-decoration-none text-body" 
                                        href="${pageContext.request.contextPath}/iot/providers.do?id=${provider.id}&control=${data.control}">
                                        ${provider.name}</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="text-center">
                        <button type="button" onclick="deleteIoT()" class="btnDelete btn btn-danger btn-min-w d-none">
                            <spring:message code='button.delete' />
                        </button>
                    </div>
                </c:when>

                <c:when test="${not empty data.provider}">
                    <div>Please click on the widget to finish:</div>
                    <table class="table">
                        <thead>
                            <tr class="text-primary">
                                <th colspan="2" class="text-center">${data.provider.name}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <c:if test="${not empty data.listeners}">
                                        <ul class="widgets">
                                            <c:forEach var="listener" items="${data.listeners}" varStatus="loop">
                                                <li class="widget" onclick="insertListener('${listener.attr}')">
                                                    <div class="w-item" w-attr="${listener.attr}"></div>
                                                    <div class="w-name">${listener.name}</div>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                    <c:if test="${not empty data.emitters}">
                                        <ul class="widgets">
                                            <c:forEach var="emitter" items="${data.emitters}" varStatus="loop">
                                                <li class="widget" onclick="insertEmitter('${emitter.attr}')">
                                                    <div class="w-item" w-attr="${emitter.attr}"></div>
                                                    <div class="w-name">${emitter.name}</div>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="text-center">
                        <a class="btn btn-dark btn-min-w" href="${pageContext.request.contextPath}/iot/providers.do?control=${data.control}">
                            Back to list
                        </a>
                        <button type="button" onclick="deleteIoT()" class="btnDelete btn btn-danger btn-min-w d-none">
                            <spring:message code='button.delete' />
                        </button>
                    </div>
                </c:when>

                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr class="text-primary">
                                <th style="width: 30px;">#</th>
                                <th class="tetx-center">Providers</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td></td>
                                <td>
                                    Not find any provider is connected.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="text-center">
                        <button type="button" onclick="deleteIoT()" class="btnDelete btn btn-danger btn-min-w d-none">
                            <spring:message code='button.delete' />
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
    <c:if test="${not empty data.message}">
		<div class="container-fluid py-3" style="max-width: 500px;">
			<img class="d-block mx-auto mb-4" src="${pageContext.request.contextPath}/theme/dist/images/icons/exclamation-mark.svg" width="80px">
			<h5 class="text-center">${data.message}</h5>
		</div>
	</c:if>
</body>

</html>