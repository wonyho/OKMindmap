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
		<spring:message code='message.group.member.registered' />
	</title>

	<script>
		function goSearch() {
			var frm = document.searchf;
			frm.page.value = 1;
			frm.submit();
		}

		function goPage(v_curr_page) {
			var frm = document.searchf;
			frm.page.value = v_curr_page;
			frm.submit();
    }
		
		var user_id = null;
    function addMember(id) {
			user_id = id;
			$('#addMemberModal').modal('show');
		}
		$(document).ready(function(event) {
			$('#frmAddMember').submit(function(event){
				event.preventDefault();
				if(user_id != null && $('#expiry_date').val() != '') $.ajax({
					type: 'post',
					url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/member/add.do?id=${data.tier.id}',
					dataType: 'json',
					data: {
						formdata: JSON.stringify({
							userid: user_id,
							expiry_date: (new Date($('#expiry_date').val())).getTime()
						})
					},
					async: false,
					success: function (data) {
						if (data.status == 'ok') {
							alert('Has been added.');
							document.searchf.submit();
						} else {
							alert("Look like something went wrong, can't add member.");
						}
					},
				});
			});
		});
	</script>

</head>

<body>
	<header>
		<div class="p-3">
			<div class="font-weight-bold h4">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/users.svg" width="26px" class="mr-1 align-top">
				<span>
					<c:out value="${data.tier.name}" />
				</span>
			</div>
			<spring:message code='message.group.member.add' />
		</div>

		<div class="d-md-flex align-items-center py-2 px-3 bg-white">
			<div class="mr-auto"></div>
			<form method=post name="searchf" onsubmit="goSearch()">
				<input type="hidden" name="page" value="${data.page}">
				<input type="hidden" name="sort" value="${data.sort}">
				<input type="hidden" name="isAsc" value="${data.isAsc}">

				<div class="input-group my-1">
					<div class="input-group-prepend" style="max-width: 30%;">
						<select class="custom-select shadow-none btn" name="searchfield" id="searchfield">
							<option value="username" ${data.searchfield=="username" ? "selected" :""}>Id</option>
							<option value="fullname" ${data.searchfield=="fullname" ? "selected" :""}>
								<spring:message code='common.name' />
							</option>
						</select>
					</div>
					<input type="search" id="search" name="search" class="form-control shadow-none" placeholder="<spring:message code='common.search'/>" value="${data.search}">
					<div class="input-group-append">
						<button class="btn btn-light shadow-none border" type="submit">
							<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
						</button>
					</div>
				</div>
			</form>
		</div>
	</header>
	<div class="container-fluid py-3">
    <div>Total: ${data.totalNotMembers}</div>
		<c:choose>
			<c:when test="${(data.notMembers != null and fn:length(data.notMembers) > 0)}">
				<div class="table-responsive">
					<table class="table">
						<tbody>
							<c:forEach var="user" items="${data.notMembers}">
								<tr>
									<td class="py-1">
										<div class="d-flex align-items-center">
											<div class="flex-shrink-1">
												<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${user.id}' />" style="width: 34px; height: 34px;" class="rounded-circle">
											</div>
											<div class="px-3" style="max-width: 300px;">
												<div class="font-weight-bold text-truncate">
													<c:out value="${user.lastname}"></c:out>
													<c:out value="${user.firstname}"></c:out>
												</div>
												<div class="text-muted text-truncate">
													<small>
														Id: <c:out value="${user.password != 'not cached' ? user.username : '******'}"></c:out> -
														<spring:message code='common.email' />: <c:out value="${user.email}"></c:out>
													</small>
												</div>
											</div>
										</div>
									</td>
									
									<td class="py-3">
										<div class="d-flex justify-content-end">
											<button onclick="addMember('${user.id}')" type="button" class="btn btn-light btn-sm">
												<img src="${pageContext.request.contextPath}/theme/dist/images/icons/user-plus.svg" width="18px">
                      </button>
										</div>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<div class="pagenum" style="text-align:center;padding-top:7px;">
					<%
						HashMap<String, Object> data = (HashMap) request.getAttribute("data");
						out.println(PagingHelper.instance.autoPaging((Integer)data.get("totalNotMembers"), (Integer)data.get("pagelimit"), (Integer)data.get("plPageRange"), (Integer)data.get("page")));
					%>
				</div>
			</c:when>
			<c:otherwise>
				<div class="alert alert-success text-center" role="alert">
					No data found.
				</div>
			</c:otherwise>
		</c:choose>

		<div class="mt-3 text-center">
			<a href="${pageContext.request.contextPath}/mindmap/admin/pricing/tier/member/list.do?id=${data.tier.id}" class="mx-0 btn btn-dark btn-min-w">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-left-w.svg" width="20px">
				Back to member list
			</a>
		</div>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="addMemberModal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog">
			<form class="modal-content" id="frmAddMember">
				<div class="modal-header">
					<h5 class="modal-title">Settings</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label>Expiry date</label>
							<input type="date" required class="form-control" id="expiry_date" name="expiry_date">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
					<button type="submit" class="btn btn-primary">Add</button>
				</div>
			</form>
		</div>
	</div>
</body>

</html>