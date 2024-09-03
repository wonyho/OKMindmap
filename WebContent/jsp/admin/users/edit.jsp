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

    <!-- <script src="https://cdn.jsdelivr.net/npm/vue"></script> -->
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

    <title>
      Edit user
    </title>

    <script type="text/javascript">
      function saveAvatar(url) {
        var configs = {
          avatar: url,
        };
        var params = "userid=${data.userEdit.id}&";
        for (var config in configs) {
          params += 'fields=' + config + '&';
          if (configs[config] == undefined) configs[config] = '';
          params += 'data=' + configs[config] + '&';
        }
        params += 'confirmed=' + 1;

        $.ajax({
          type: 'post',
          async: false,
          url: '${pageContext.request.contextPath}/user/userconfig.do',
          data: params,
          success: function (data) {
            $('#avatar_view').attr('src', "${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.userEdit.id}' />&v=" + new Date().getTime());
          },
          error: function (data, status, err) {
//            alert('userConfig : ' + status);
        	  $('#avatar_view').attr('src', "${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.userEdit.id}' />&v=" + new Date().getTime());
          },
        });
      }

      function uploadAvatar(file) {
        $('#fileuploading').removeClass('d-none');
        var formData = new FormData();
        formData.append('confirm', 1);
        formData.append('mapid', 1);
        formData.append('file', file);

        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/media/fileupload.do');
        xhr.onerror = function (evt) {
          alert("<spring:message code='common.upload_error'/>");
          $('#fileuploading').addClass('d-none');
        };
        xhr.onreadystatechange = function () {
          if (xhr.readyState === 4 && xhr.status === 200) {
            $('#fileuploading').addClass('d-none');
            var res = JSON.parse(xhr.response);
            saveAvatar(res[0].repoid);
          }
        };
        xhr.send(formData);
      }

      function setAccountLevel(tierid, userid) {
        $.ajax({
          type: 'post',
          url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/accounts.do',
          dataType: 'json',
          data: { action: 'changelevel', tierid: tierid, userid: userid },
          async: false,
          success: function (data) {
            if (data.status == 'ok') {
              alert("Successfully changed!");
              window.location.reload();
            } else {
              alert("Look like something went wrong, can't change.");
            }
          },
        });
      }

      function checkFormat(obj_type) {
        const imageFormat = 'jpg,jpeg,png';
        var format = imageFormat;
        var str = format.split(",");
        var type = obj_type.split("/");

        for (var i = 0; i < str.length; i++) {
          if (str[i] == type[1]) {
            return true;
          }
        }
        return false;
      }

      $(document).ready(function () {
        var tt = '<c:out value="${data.avatar.data}"/>';
        $('#avatar').on('change', function () {
          if (this.files.length) {
            var file = this.files[0];
            if (10120000 < file.size) {
              alert("<spring:message code='file.limit' /> (<10Mb)");
            } else if (!checkFormat(file.type)) {
              alert("<spring:message code='file.image' />");
            } else {
              uploadAvatar(file);
            }
          }
        });

        $('#frm-user-update').submit(function (event) {
          if ($('#password').val() === $('#password1').val()) {
            return;
          }
          alert("Error: <spring:message code='common.password.confirm' />");
          event.preventDefault();
        });

        new Vue({
          el: '#vapp',
          data: {
            tier: ${data.currentTier},
            functions: [
              {
                policy_key: 'map_create',
                policy_name: 'Map creation & manipulation',
                option: true
              },
              {
                policy_key: 'map_remix',
                policy_name: 'Map remix no',
                option: true
              },
              // {
              {
                policy_key: 'presentation',
                policy_name: 'Presentation',
                type: 'header',
              },
              {
                policy_key: 'presentation_box',
                policy_name: 'Box',
                type: 'sub',
              },
              {
                policy_key: 'presentation_dynamic',
                policy_name: 'Dynamic',
                type: 'sub',
              },
              {
                policy_key: 'presentation_aero',
                policy_name: 'Aero',
                type: 'sub',
              },
              {
                policy_key: 'presentation_linear',
                policy_name: 'Linear',
                type: 'sub',
              },
              {
                policy_key: 'presentation_mindmapbasic',
                policy_name: 'Mindmap - Basic',
                type: 'sub',
              },
              {
                policy_key: 'presentation_mindmapzoom',
                policy_name: 'Mindmap - Zoom',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle',
                policy_name: 'Map style',
                type: 'header',
              },
              {
                policy_key: 'mapstyle_mindmap',
                policy_name: 'Mindmap',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_card',
                policy_name: 'Card',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_sunburst',
                policy_name: 'Sunburst',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_tree',
                policy_name: 'Tree',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_project',
                policy_name: 'Project',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_padlet',
                policy_name: 'Padlet',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_partition',
                policy_name: 'Partition',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_fishbone',
                policy_name: 'Fishbone',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle_rect',
                policy_name: 'Rect',
                type: 'sub',
              },
              {
                policy_key: 'map_import_total',
                policy_name: 'Import total count',
                option: true
              },
              {
                policy_key: 'import',
                policy_name: 'Import',
                type: 'header',
              },
              {
                policy_key: 'import_xml',
                policy_name: 'XML',
                type: 'sub',
              },
              {
                policy_key: 'import_text',
                policy_name: 'text (Clipboard)',
                type: 'sub',
              },
              {
                policy_key: 'import_bookmark',
                policy_name: 'Bookmark',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'import_freemind',
                policy_name: 'Freemind',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'map_export_total',
                policy_name: 'Export total count',
                option: true
              },
              {
                policy_key: 'export',
                policy_name: 'Export',
                type: 'header',
              },
              {
                policy_key: 'export_ppt',
                policy_name: 'PPT',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export_html',
                policy_name: 'HTML',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export_freemind',
                policy_name: 'Freemind',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export_svg',
                policy_name: 'SVG',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export_png',
                policy_name: 'PNG',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export_text',
                policy_name: 'TEXT',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export_xml',
                policy_name: 'XML',
                type: 'sub',
              },
              {
                policy_key: 'export_textclipboard',
                policy_name: 'Text (Clipboard)',
                type: 'sub',
              },
              {
                policy_key: 'moodle',
                policy_name: 'Moodle Class',
                option: true
              },
              {
                policy_key: 'iot_add',
                policy_name: 'IOT add (total devices)',
                option: true
              },
              {
                policy_key: 'capacity_limit',
                policy_name: 'Upload capacity (Mb)',
                option: true
              },
            ],
          },
          mounted() {
            //
          }
        });
      });
    </script>
  </head>

  <body>
    <div class="p-3">
      <a href="${pageContext.request.contextPath}/mindmap/admin/users/list.do" class="mx-0 btn btn-secondary btn-min-w">
        Back to user list
      </a>

      <div class="card my-3">
        <div class="card-body">
          <div class="font-weight-bold h5">
            <span>User info</span>
          </div>
          <input id="avatar" type="file" class="d-none" accept="image/*" />
          <form id="frm-user-update" action="${pageContext.request.contextPath}/user/update.do?userid=<c:out value='${data.userEdit.id}' />" method="post">
            <input type="hidden" name="confirmed" value="1" />
            <input type="hidden" name="redirect_url" value="${pageContext.request.contextPath}/mindmap/admin/users/list.do" />
            <div class="row">
              <div class="col-sm">
                <div class="p-3 mb-3 text-center">
                  <img id="avatar_view" src="${pageContext.request.contextPath}/user/avatar.do?userid=<c:out value='${data.userEdit.id}' />" style="width: 128px; height: 128px;" class="d-block mx-auto rounded-circle" />
                  <div id="fileuploading" class="d-none"><i>(Uploading...)</i></div>
                  <label class="btn btn-sm btn-light mt-1 cursor-pointer" for="avatar">
                    <spring:message code="image.image_upload" />
                  </label>
                </div>
              </div>
              
              <div class="col-sm">
                <div class="form-group">
                  <label>
                    <spring:message code="common.name.last" />
                  </label>
                  <input type="text" required class="form-control" name="lastname" value='<c:out value="${data.userEdit.lastname}"></c:out>' />
                </div>
    
                <div class="form-group">
                  <label>
                    <spring:message code="common.name.first" />
                  </label>
                  <input type="text" required class="form-control" name="firstname" value='<c:out value="${data.userEdit.firstname}"></c:out>' />
                </div>
              </div>

              <div class="col-sm">
                <div class="form-group">
                  <label>
                    <spring:message code="common.email" />
                  </label>
                  <input type="email" required class="form-control" name="email" value='<c:out value="${data.userEdit.email}"></c:out>' />
                </div>

                <div class="form-group">
                  <label>
                    <spring:message code="message.id" />
                  </label>
                  <input type="text" readonly class="form-control" value='<c:out value="${data.userEdit.username}"></c:out>' />
                </div>
              </div>

              <div class="col-sm">
                <div class="form-group">
                  <label>
                    <spring:message code="common.password" />
                  </label>
                  <input type="password" class="form-control" id="password" name="password" value="" />
                </div>
    
                <div class="form-group">
                  <label>
                    <spring:message code="common.password.confirm" />
                  </label>
                  <input type="password" class="form-control" id="password1" name="password1" value="" />
                </div>

                <div class="text-center">
                  <button class="btn btn-primary mx-1 btn-min-w" type="submit">
                    <spring:message code="button.apply" />
                  </button>
                </div>

              </div>
            </div>
          </form>
        </div>
      </div>

      <div id="vapp">
        <div class="card my-3">
          <div class="card-body">
            <div class="font-weight-bold h5">
              <span>Service plan info</span>
            </div>
  
            <div class="row">
              <div class="col-md">
                <div class="d-flex justify-content-between">
                  <h5>Plans</h5>
                  <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#planStatus">
                    View plan status
                  </button>
                </div>
  
                <table class="table">
                  <thead>
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
                    <tr>
                      <c:forEach var="tier" items="${data.tiers}">
                        <c:if test="${tier.activated}">
                          <td style="text-align: center;" tierid="${tier.id}">
                            <c:choose>
                              <c:when test="${(tier.id == data.tierId)}">
                                <input type="radio" checked name="lv_plan" onclick="setAccountLevel('${tier.id}', '${data.userEdit.id}')">
                              </c:when>
                              <c:otherwise>
                                <input type="radio" name="lv_plan" onclick="setAccountLevel('${tier.id}', '${data.userEdit.id}')">
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </c:if>
                      </c:forEach>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="col-md">
                <h5>Groups</h5>
                <table class="table">
                  <thead>
                    <tr>
                      <th>Group name</th>
                      <th>Owner</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="group" items="${data.user_groups}">
                      <tr>
                        <td>
                          <a href="${pageContext.request.contextPath}/group/member/list.do?id=${group.id}">
                            ${group.name}
                          </a>
                        </td>
                        <td>
                          <a href="${pageContext.request.contextPath}/mindmap/admin/users/useredit.do?userid=${group.user.id}">
                            ${group.user.lastname}${group.user.firstname}
                          </a>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
  
        <!-- Modal -->
        <div class="modal fade" id="planStatus" tabindex="-1" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Plan status</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <table class="table table-sm">
                  <thead>
                    <tr>
                      <th scope="col">Function name</th>
                      <th scope="col">Used/Total</th>
                    </tr>
                  </thead>
  
                  <tbody>
                    <template v-for="(fn, i) in functions">
                      <tr v-if="fn.type == 'header'">
                        <td colspan="2">
                          {{ fn.policy_name }}
                        </td>
                      </tr>
                      <tr v-else>
                        <td>
                          <div :class="['custom-control custom-checkbox', {'ml-3': fn.type == 'sub'}]">
                            <input readonly disabled type="checkbox" class="custom-control-input" :id="'chk_'+i" :checked="tier[fn.policy_key] ? true : false" />
                            <label class="custom-control-label" :for="'chk_'+i">{{ fn.policy_name }}</label>
                          </div>
                        </td>
                        <td>
                          <div v-if="fn.option" class="form-inline">
                            <template v-if="fn.policy_key == 'moodle'">
                              <span v-if="tier.moodle && tier.moodle.length && JSON.parse(tier.moodle[0].value).only_student">
                                Just as students
                              </span>
                              <span v-else>
                                Courses hosting: {{ tier.moodle[0].used }}/{{ JSON.parse(tier.moodle[0].value).course_hosting }}
                              </span>
                            </template>
  
                            <template v-else>
                              <span v-if="tier[fn.policy_key] && tier[fn.policy_key].length">
                                {{ tier[fn.policy_key][0].used }}/{{ tier[fn.policy_key][0].value }}
                              </span>
                            </template>
                          </div>
                        </td>
                      </tr>
                    </template>
                  </tbody>
                </table>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </body>
</html>
