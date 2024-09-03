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
    const isLocale_ko = '${isLocale_ko}';

    function list_init() {
      // 시간포멧 변경
      var created = $('.created');
      for (var i = 0; i < created.length; i++) {
        var c = created[i];
        if (c.innerHTML != '') {
          var date = new Date(parseInt(c.innerHTML));
          var format = '';
          if (isLocale_ko == 'true') {
            format = date.format('yyyy-MM-dd'); //date.getFullYear() + "-" + (date.getMonth() + 1).zf(2) + "-" + date.getDate().zf(2);
          } else {
            format = date.format('dd-MM-yyyy'); //date.getDate().zf(2) + "-" + (date.getMonth() + 1).zf(2) + "-" + date.getFullYear();
          }

          c.innerHTML = format;
        }
        $(c).removeClass('created');
      }
    }

    Date.prototype.format = function (f) {
      if (!this.valueOf()) return ' ';

      var weekName = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
      var d = this;

      return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
          case 'yyyy':
            return d.getFullYear();
          case 'yy':
            return (d.getFullYear() % 1000).zf(2);
          case 'MM':
            return (d.getMonth() + 1).zf(2);
          case 'dd':
            return d.getDate().zf(2);
          case 'E':
            return weekName[d.getDay()];
          case 'HH':
            return d.getHours().zf(2);
          case 'hh':
            return ((h = d.getHours() % 12) ? h : 12).zf(2);
          case 'mm':
            return d.getMinutes().zf(2);
          case 'ss':
            return d.getSeconds().zf(2);
          case 'a/p':
            return d.getHours() < 12 ? '오전' : '오후';
          default:
            return $1;
        }
      });
    };

    String.prototype.string = function (len) {
      var s = '',
        i = 0;
      while (i++ < len) {
        s += this;
      }
      return s;
    };
    String.prototype.zf = function (len) {
      return '0'.string(len - this.length) + this;
    };
    Number.prototype.zf = function (len) {
      return this.toString().zf(len);
    };

    String.prototype.replaceAll = function (search, replacement) {
      var target = this;
      return target.split(search).join(replacement);
    };

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

		function editMember(id, status, expiry_date, fullname) {
			var d = new Date(parseInt(expiry_date));
			$('#frm_title').html(fullname);
			$('#tier_member_id').val(id);
			$('#status').prop('checked', status == '1');
			$('#expiry_date').val(d.getFullYear() +'-'+('0' + (d.getMonth()+1)).slice(-2)+'-'+('0'+d.getDate()).slice(-2));
			$('#editMemberModal').modal('show');
		}

		function deleteMember(id, fullname) {
			if(confirm('Are you sure you want to delete user "'+fullname+'"?')) {
				$.ajax({
					type: 'post',
					url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/member/list.do?id=${data.tier.id}',
					dataType: 'json',
					data: { action: 'delete_tier_member', tier_member_id: id },
					async: false,
					success: function (data) {
						if (data.status == 'ok') {
							alert('Has been deleted.');
							document.searchf.submit();
						} else {
							alert("Look like something went wrong, can't delete.");
						}
					},
				});
			}
		}
    
    $(document).ready(function () {
      list_init();

			$('#frmEditMember').submit(function(event){
				event.preventDefault();
				if($('#tier_member_id').val() !='' && $('#expiry_date').val() != '') $.ajax({
					type: 'post',
					url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/member/list.do?id=${data.tier.id}',
					dataType: 'json',
					data: {
						action: 'update_tier_member',
						tier_member_id: $('#tier_member_id').val(),
						status: $('#status').is(':checked') ? 1:0,
						expiry_date: (new Date($('#expiry_date').val())).getTime()
					},
					async: false,
					success: function (data) {
						if (data.status == 'ok') {
							alert('Has been updated.');
							document.searchf.submit();
						} else {
							alert("Look like something went wrong, can't update.");
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
			<spring:message code='message.group.member.registered' />
		</div>

		<div class="d-md-flex align-items-center py-2 px-3 bg-white">
			<div class="mr-auto">
				<a href="${pageContext.request.contextPath}/mindmap/admin/pricing/tier/member/add.do?id=${data.tier.id}" class="mx-0 btn btn-secondary btn-min-w">
					<spring:message code='message.group.member.add.short' />
				</a>
			</div>
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
    <div>Total: ${data.totalMembers}</div>
		<c:choose>
			<c:when test="${(data.members != null and fn:length(data.members) > 0)}">
				<div class="">
					<table class="table">
            <thead>
              <tr>
                <th scope="col" class="border-top-0">
                  <span>User</span>
                </th>
                <th scope="col" class="border-top-0">Status</th>
                <th scope="col" class="border-top-0">Created date</th>
                <th scope="col" class="border-top-0">Expiry date</th>
                <th scope="col" class="border-top-0"></th>
              </tr>
            </thead>
						<tbody>
							<c:forEach var="member" items="${data.members}">
								<tr>
									<td class="py-1">
										<div class="d-flex align-items-center">
											<div class="flex-shrink-1">
												<img src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${member.user.id}' />" style="width: 34px; height: 34px;" class="rounded-circle">
											</div>
											<div class="px-3" style="max-width: 300px;">
												<div class="font-weight-bold text-truncate">
													<c:out value="${member.user.lastname}"></c:out>
													<c:out value="${member.user.firstname}"></c:out>
												</div>
												<div class="text-muted text-truncate">
													<small>
														Id: <c:out value="${member.user.password != 'not cached' ? member.user.username : '******'}"></c:out> -
														<spring:message code='common.email' />: <c:out value="${member.user.email}"></c:out>
													</small>
												</div>
											</div>
										</div>
                  </td>
                  
                  <td>
                    <c:if test="${member.status}">
                      <span class="badge badge-success">Activate</span>
                    </c:if>
                    <c:if test="${!member.status}">
                      <span class="badge badge-danger">Disabled</span>
                    </c:if>
                  </td>
                  <td>
                    <span class="created">
                      <c:out value="${member.created}"></c:out>
                    </span>
                  </td>
                  <td>
                    <span class="created">
                      <c:out value="${member.expiryDate}"></c:out>
                    </span>
                  </td>
									
									<td class="text-right">
										<button type="button" class="btn btn-outline-primary btn-sm ml-4" onclick="editMember('${member.id}', '${member.status ? 1:0}', '${member.expiryDate}', '${member.user.lastname} ${member.user.firstname}')">Edit</button>
										<button type="button" class="btn btn-outline-danger btn-sm ml-4" onclick="deleteMember('${member.id}', '${member.user.lastname} ${member.user.firstname}')">Delete</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<div class="pagenum" style="text-align:center;padding-top:7px;">
					<%
						HashMap<String, Object> data = (HashMap) request.getAttribute("data");
						out.println(PagingHelper.instance.autoPaging((Integer)data.get("totalMembers"), (Integer)data.get("pagelimit"), (Integer)data.get("plPageRange"), (Integer)data.get("page")));
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
			<a href="${pageContext.request.contextPath}/mindmap/admin/pricing/tier/list.do" class="mx-0 btn btn-dark btn-min-w">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/arrow-left-w.svg" width="20px">
				Back to tier list
			</a>
		</div>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="editMemberModal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog">
			<form class="modal-content" id="frmEditMember">
				<input type="hidden" name="tier_member_id" id="tier_member_id">
				<div class="modal-header">
					<h5 class="modal-title" id="frm_title"></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label>Expiry date</label>
						<input type="date" required class="form-control" id="expiry_date" name="expiry_date">
					</div>
					
					<div class="form-group">
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" id="status" name="status" value="1">
							<label class="custom-control-label" for="status">Active</label>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
					<button type="submit" class="btn btn-primary">Save</button>
				</div>
			</form>
		</div>
	</div>
</body>

</html>