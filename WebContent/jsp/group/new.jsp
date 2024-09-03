<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
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
        <spring:message code='message.group.new' />
    </title>

    <script type="text/javascript">
        function setPolicy(policy) {
			var password = $('#group_password')
			if( policy == "password" ) {
				password.removeClass('d-none');
			} else {
				password.addClass('d-none');
			}
		}

        function checkForm() {
			if ($('#policy').val() == 'password' && $('#password').val() == '') {
				alert("<spring:message code='confirm.enterpassword'/>");
			} else {
				document.getElementById('frm_group').submit();
			}
		}

		$(document).ready(function () {
			setPolicy($('#policy').val());

            $("#frm_group").submit(function (event) {
				event.preventDefault();
				checkForm();
			});
		});
    </script>
</head>

<body>
    <div class="container-fluid p-3" style="max-width: 500px; min-height: 450px;">
        <div class="font-weight-bold h4">
            <img src="${pageContext.request.contextPath}/theme/dist/images/icons/users.svg" width="26px" class="mr-1 align-top">
            <span>
                <spring:message code='message.group.new' />
            </span>
        </div>

        <form id="frm_group" action="${pageContext.request.contextPath}/group/new.do" method="post">
            <input type="hidden" name="confirmed" value="1" />

            <div class="form-group">
                <label>
                    <spring:message code='message.group.name' />
                </label>
                <input autofocus required class="form-control" type="text" name="name" id="name" />
            </div>

            <div class="form-group">
                <label>
                    <spring:message code='message.group.parent' />
                </label>
                <select required name="parent" class="form-control">
                    <c:forEach items="${data.categories }" var="category">
                        <option value="<c:out value='${category.id}' />">
                            <c:forEach begin="1" end="${category.depth}">***/</c:forEach>
                            <c:out value="${category.name}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>
                    <spring:message code='message.group.policy' />
                </label>
                <select id="policy" required name="policy" class="form-control" onChange="setPolicy(this.options[this.selectedIndex].value)">
                    <c:forEach items="${data.policies}" var="policy">
                        <option value="<c:out value='${policy.shortName}' />">
                            <spring:message code="message.group.new.policy.${policy.shortName}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div id="group_password" class="form-group">
                <label>
                    <spring:message code='common.password' />
                </label>
                <input type="password" class="form-control" name="password" id="password" value="" />
            </div>

            <div class="form-group">
                <label>
                    <spring:message code='common.explain' />
                </label>
                <textarea name="summary" class="form-control" rows="4"></textarea>
            </div>

            <c:if test="${data.tiers != null}">
				<div class="form-group">
					<label>Plan</label>
						<div>
							<input checked type="radio" name="tier_id" id="tier_id_0" value="0">
							<label for="tier_id_0">(None)</label>
						</div>
						<c:forEach var="tier" items="${data.tiers}">
							<c:if test="${tier.activated}">
								<div>
									<input type="radio" name="tier_id" id="tier_id_${tier.id}" value="${tier.id}">
									<label for="tier_id_${tier.id}">${tier.name}</label>
								</div>
							</c:if>
						</c:forEach>
				</div>
			</c:if>

            <div class="text-center mt-4">
                <button class="btn btn-primary btn-min-w" type="submit">
                    <spring:message code='button.create' />
                </button>
                <a href="${pageContext.request.contextPath}/group/list.do" class="btn btn-dark btn-min-w">
                    <spring:message code='button.cancel' />
                </a>
            </div>
        </form>
    </div>
</body>

</html>