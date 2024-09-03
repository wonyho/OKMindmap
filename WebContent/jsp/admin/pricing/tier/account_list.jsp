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
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
    <!-- Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>" />
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>
    <script src="${pageContext.request.contextPath}/lib/jquery.min.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/lib/jquery-impromptu.3.1.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/lib/jquery.form.js?v=<%=updateTime%>" type="text/javascript" charset="utf-8"></script>

    <title>
      Account list
    </title>

    <style>
      .sortable.sort::after {
        content: '↓';
        display: inline-block;
        color: #979b9e;
      }
      .sortable.sort.isAsc::after {
        content: '↑';
      }
      .table-hover tbody tr:hover {
        color: #212529 !important;
        background-color: rgba(0, 0, 0, 0.02) !important;
      }
    </style>

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
          __$(c).removeClass('created');
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

      function setAccountLevel(tierid, userid) {
        __$.ajax({
          type: 'post',
          url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/accounts.do',
          dataType: 'json',
          data: { action: 'changelevel', tierid: tierid, userid: userid },
          async: false,
          success: function (data) {
            if (data.status == 'ok') {
              goSearch();
            } else {
              alert("Look like something went wrong, can't change.");
              goSearch();
            }
          },
        });
      }

      function compileUser(data) {			
        var userdata = data.split(',');			
        var username = (userdata[0] == null || userdata[0] == "")? "" : userdata[0]; 
        var account_level = (userdata[1] == null || userdata[1] == "")? "" : userdata[1];

        __$.ajax({
          type: 'post',
          url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/accounts.do',
          dataType: 'json',
          data: { action: 'changelevel', tierid: account_level, username: username },
          async: false,
          success: function (data) {
            if (data.status == 'ok') {
              $('#user-ret').append('<div>'+userdata[0]+' : 성공'+'</div>');
            } else {
              $('#user-ret').append('<div>'+userdata[0]+' : 실패'+'</div>');
            }
          },
        });
      }

      __$(document).ready(function () {
        list_init();

        $('#frm_import').ajaxForm({
            beforeSend: function() {
            },
            success: function(response, status, xhr) {
              var dbs = response.split('\n');
              for(var i=0; i < dbs.length; i++) {
                compileUser(dbs[i]);
              }
            },
          complete: function(xhr) {					
          }
        });

        $('#searchfield').val("${data.searchfield}");
      });
    </script>
  </head>

  <body>
    <div>
      <div class="p-3">
        <div class="font-weight-bold h4">
          <span>
            Account list
          </span>
        </div>
      </div>

      <div class="d-md-flex align-items-center py-2 px-3 bg-white">
        <div class="mr-auto">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#importModal">
            Import account status from file
          </button>
        </div>
        <form method=post name="searchf" onsubmit="goSearch()">
          <input type="hidden" name="page" value="${data.page}" />
          <input type="hidden" name="sort" value="${data.sort}" />
          <input type="hidden" name="isAsc" value="${data.isAsc}" />

          <div class="input-group my-1">
            <div class="input-group-prepend" style="max-width: 30%;">
              <select class="custom-select shadow-none btn" id="searchfield" name="searchfield">
                <option value="username">ID</option>
                <option value="fullname">Name</option>
                <option value="email">Email</option>
              </select>
            </div>

            <input type="search" id="search" name="search" class="form-control shadow-none" placeholder="<spring:message code='common.search'/>" value="${data.search}" />
            <div class="input-group-append">
              <button class="btn btn-light shadow-none border" type="submit">
                <img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px" />
              </button>
            </div>
          </div>
        </form>
      </div>

      <div class="px-3">
        <div>Total: ${data.total}</div>
        <c:choose>
          <c:when test="${(data.members != null and fn:length(data.members) > 0)}">
            <div class="">
              <table class="table">
                <thead>
                  <tr>
                    <th scope="col" class="border-top-0" rowspan="2">
                      <span>User</span>
                    </th>
                    <th scope="col" colspan="${fn:length(data.tiers)}" class="border-top-0" style="text-align: center;">Plans</th>
                  </tr>
                  <tr>
                    <c:forEach var="tier" items="${data.tiers}">
                      <c:if test="${tier.activated}">
                        <th style="text-align: center;">
                          <small><c:out value="${tier.name}"></c:out></small>
                        </th>
                      </c:if>
                    </c:forEach>
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
                              <a href="${pageContext.request.contextPath}/mindmap/admin/users/useredit.do?userid=${member.user.id}">
                                <c:out value="${member.user.lastname}"></c:out>
                                <c:out value="${member.user.firstname}"></c:out>
                              </a>
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
                      <c:forEach var="tier" items="${data.tiers}">
                        <c:if test="${tier.activated}">
                          <td style="text-align: center;" tierid="${tier.id}" mem="${member.tier.id}">
                            <c:choose>
                              <c:when test="${(member.tier.id == 0 && tier.id == 1) || (tier.id == member.tier.id)}">
                                <input type="radio" checked name="lv_${member.user.id}" onclick="setAccountLevel('${tier.id}', '${member.user.id}')">
                              </c:when>
                              <c:otherwise>
                                <input type="radio" name="lv_${member.user.id}" onclick="setAccountLevel('${tier.id}', '${member.user.id}')">
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </c:if>
                      </c:forEach>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>

            <div class="pagenum" style="text-align:center;padding-top:7px;">
              <%
                HashMap<String, Object> data = (HashMap) request.getAttribute("data");
                out.println(PagingHelper.instance.autoPaging((Integer)data.get("total"), (Integer)data.get("pagelimit"), (Integer)data.get("plPageRange"), (Integer)data.get("page")));
              %>
            </div>

            <!-- Modal -->
            <div class="modal fade" id="importModal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog">
                <form class="modal-content" id="frm_import" name="frm_import" action="${pageContext.request.contextPath}/mindmap/admin/users/importUser.do" method="post" enctype="multipart/form-data">
                  <div class="modal-header">
                    <h5 class="modal-title">Import account status from file</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body">
                    <a href="${pageContext.request.contextPath}/change_account_status_example.txt">예제파일</a>
                    <div class="form-group">
                      <input type="hidden" name="confirm" value="1"/>
		        	        <input type="file" name="file"><br>
                    </div>
                    <div id="user-ret">
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Upload File to Server</button>
                  </div>
                </form>
              </div>
            </div>
            
          </c:when>
          <c:otherwise>
            <div class="alert alert-success text-center" role="alert">
              No data found.
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </body>
</html>
