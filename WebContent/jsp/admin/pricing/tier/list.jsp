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

    <title>
      Plan management
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

      function deleteTier(id, tier_name) {
        if (confirm('Are you sure you want to delete "'+tier_name+'"?')) {
          $.ajax({
            type: 'post',
            url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/list.do',
            dataType: 'json',
            data: { action: 'deletetier', id: id },
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

      $(document).ready(function () {
        list_init();
      });
    </script>
  </head>

  <body>
    <div>
      <div class="p-3">
        <div class="font-weight-bold h4">
          <span>
            Plan management
          </span>
        </div>
      </div>

      <div class="d-md-flex align-items-center py-2 px-3 bg-white">
        <div class="mr-auto">
          <a href="${pageContext.request.contextPath}/mindmap/admin/pricing/tier/form.do" class="mx-0 btn btn-secondary btn-min-w">
            Add new plan
          </a>
        </div>
        <form method=post name="searchf" onsubmit="goSearch()">
          <input type="hidden" name="page" value="${data.page}" />
          <input type="hidden" name="sort" value="${data.sort}" />
          <input type="hidden" name="isAsc" value="${data.isAsc}" />

          <div class="input-group my-1">
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
        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
              <tr>
                <th scope="col" class="border-top-0">ID</th>
                <th scope="col" class="border-top-0">Name</th>
                <th scope="col" class="border-top-0">Summary</th>
                <th scope="col" class="border-top-0">Status</th>
                <th scope="col" class="border-top-0">Created date</th>
                <th scope="col" class="border-top-0"></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${data.tiers}" var="tier">
                <tr>
                  <td><c:out value="${tier.id}" /></td>
                  <td>
                    <a href="${pageContext.request.contextPath}/mindmap/admin/pricing/tier/form.do?id=${tier.id}">
                      <c:out value="${tier.name}" />
                    </a>
                  </td>
                  <td><c:out value="${tier.summary}" /></td>
                  <td>
                    <c:if test="${tier.activated}">
                      <span class="badge badge-success">Activate</span>
                    </c:if>
                    <c:if test="${!tier.activated}">
                      <span class="badge badge-danger">Disabled</span>
                    </c:if>
                  </td>
                  <td>
                    <span class="created">
                      <c:out value="${tier.created}" />
                    </span>
                  </td>
                  <td class="text-right">
                    <a href="${pageContext.request.contextPath}/mindmap/admin/pricing/tier/form.do?id=${tier.id}" class="btn btn-outline-primary btn-sm ml-1">Edit</a>
                    <c:if test="${tier.id != 1}">
                      <button type="button" class="btn btn-outline-danger btn-sm ml-4" onclick="deleteTier('${tier.id}', '${tier.name}')">Delete</button>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>

              <c:if test="${data.tiers.size() == 0}">
                <tr>
                  <td colspan="6" class="text-center">
                    No data found.
                  </td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>

        <div class="pagenum" style="text-align:center;padding-top:7px;">
          <%
						HashMap<String, Object> data = (HashMap) request.getAttribute("data");
						out.println(PagingHelper.instance.autoPaging((Integer)data.get("total"), (Integer)data.get("pagelimit"), (Integer)data.get("plPageRange"), (Integer)data.get("page")));
					%>
				</div>
      </div>
    </div>
  </body>
</html>
