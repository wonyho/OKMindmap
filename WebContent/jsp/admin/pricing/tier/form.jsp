<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@ page import="java.util.Locale"%> <%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%> <%@ page import="com.okmindmap.configuration.Configuration"%> <%@ page import="com.okmindmap.util.PagingHelper"%> <%@ page import="java.util.HashMap"%> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> <% Locale locale = RequestContextUtils.getLocale(request); request.setAttribute("locale", locale); long updateTime = 0l; if (Configuration.getBoolean("okmindmap.debug")) { updateTime = System.currentTimeMillis() / 1000; } else { updateTime = Configuration.getLong("okmindmap.update.version"); } %>

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
      Update plan
    </title>

    <script>
      $(document).ready(function () {
        new Vue({
          el: '#vapp',
          data: {
            extend_tier_id: 0,
            id: '${data.tier.id}',
            name: '${data.tier.name}',
            summary: '${data.tier.summary}',
            activated: '${data.tier.activated ? 1:0}' == '1',
            functions: [
              {
                policy_key: 'map.create',
                policy_name: 'Map creation & manipulation',
                activated: '${data.map_create_activated ? 1:0}' == '1',
                value: '${data.map_create_value}',
                option: true
              },
              {
                policy_key: 'map.remix',
                policy_name: 'Map remix no',
                activated: '${data.map_remix_activated ? 1:0}' == '1',
                value: '${data.map_remix_value}',
                option: true
              },
              // {
              //   policy_key: 'sharemap',
              //   policy_name: 'Share map',
              //   type: 'header',
              // },
              // {
              //   policy_key: 'sharemap.creategroup',
              //   policy_name: 'Group creation',
              //   activated: '${data.sharemap_creategroup_activated ? 1:0}' == '1',
              //   value: '${data.sharemap_creategroup_value}',
              //   option: true,
              //   type: 'sub',
              // },
              {
                policy_key: 'presentation',
                policy_name: 'Presentation',
                type: 'header',
              },
              {
                policy_key: 'presentation.box',
                policy_name: 'Box',
                activated: '${data.presentation_box_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'presentation.dynamic',
                policy_name: 'Dynamic',
                activated: '${data.presentation_dynamic_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'presentation.aero',
                policy_name: 'Aero',
                activated: '${data.presentation_aero_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'presentation.linear',
                policy_name: 'Linear',
                activated: '${data.presentation_linear_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'presentation.mindmapbasic',
                policy_name: 'Mindmap - Basic',
                activated: '${data.presentation_mindmapbasic_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'presentation.mindmapzoom',
                policy_name: 'Mindmap - Zoom',
                activated: '${data.presentation_mindmapzoom_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle',
                policy_name: 'Map style',
                type: 'header',
              },
              {
                policy_key: 'mapstyle.mindmap',
                policy_name: 'Mindmap',
                activated: '${data.mapstyle_mindmap_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.card',
                policy_name: 'Card',
                activated: '${data.mapstyle_card_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.sunburst',
                policy_name: 'Sunburst',
                activated: '${data.mapstyle_sunburst_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.tree',
                policy_name: 'Tree',
                activated: '${data.mapstyle_tree_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.project',
                policy_name: 'Project',
                activated: '${data.mapstyle_project_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.padlet',
                policy_name: 'Padlet',
                activated: '${data.mapstyle_padlet_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.partition',
                policy_name: 'Partition',
                activated: '${data.mapstyle_partition_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.fishbone',
                policy_name: 'Fishbone',
                activated: '${data.mapstyle_fishbone_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'mapstyle.rect',
                policy_name: 'Rect',
                activated: '${data.mapstyle_rect_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'map.import_total',
                policy_name: 'Import total count',
                activated: '${data.map_import_total_activated ? 1:0}' == '1',
                value: '${data.map_import_total_value}',
                option: true
              },
              {
                policy_key: 'import',
                policy_name: 'Import',
                type: 'header',
              },
              {
                policy_key: 'import.xml',
                policy_name: 'XML',
                activated: '${data.import_xml_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'import.text',
                policy_name: 'text (Clipboard)',
                activated: '${data.import_text_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'import.bookmark',
                policy_name: 'Bookmark',
                activated: '${data.import_bookmark_activated ? 1:0}' == '1',
                value: '${data.import_bookmark_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'import.freemind',
                policy_name: 'Freemind',
                activated: '${data.import_freemind_activated ? 1:0}' == '1',
                value: '${data.import_freemind_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'map.export_total',
                policy_name: 'Export total count',
                activated: '${data.map_export_total_activated ? 1:0}' == '1',
                value: '${data.map_export_total_value}',
                option: true
              },
              {
                policy_key: 'export',
                policy_name: 'Export',
                type: 'header',
              },
              {
                policy_key: 'export.ppt',
                policy_name: 'PPT',
                activated: '${data.export_ppt_activated ? 1:0}' == '1',
                value: '${data.export_ppt_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export.html',
                policy_name: 'HTML',
                activated: '${data.export_html_activated ? 1:0}' == '1',
                value: '${data.export_html_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export.freemind',
                policy_name: 'Freemind',
                activated: '${data.export_freemind_activated ? 1:0}' == '1',
                value: '${data.export_freemind_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export.svg',
                policy_name: 'SVG',
                activated: '${data.export_svg_activated ? 1:0}' == '1',
                value: '${data.export_svg_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export.png',
                policy_name: 'PNG',
                activated: '${data.export_png_activated ? 1:0}' == '1',
                value: '${data.export_png_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export.text',
                policy_name: 'TEXT',
                activated: '${data.export_text_activated ? 1:0}' == '1',
                value: '${data.export_text_value}',
                option: true,
                type: 'sub',
              },
              {
                policy_key: 'export.xml',
                policy_name: 'XML',
                activated: '${data.export_xml_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'export.textclipboard',
                policy_name: 'Text (Clipboard)',
                activated: '${data.export_textclipboard_activated ? 1:0}' == '1',
                value: '',
                type: 'sub',
              },
              {
                policy_key: 'moodle',
                policy_name: 'Moodle Class',
                activated: '${data.moodle_activated ? 1:0}' == '1',
                value: '${data.moodle_value != null && data.moodle_value != "" ? data.moodle_value : "{}"}',
                option: true,
                options: JSON.parse('${data.moodle_value != null && data.moodle_value != "" ? data.moodle_value : "{\"only_student\":true,\"course_hosting\":1}"}'),
              },
              {
                policy_key: 'iot.add',
                policy_name: 'IOT add (total devices)',
                activated: '${data.iot_add_activated ? 1:0}' == '1',
                value: '${data.iot_add_value}',
                option: true
              },
              {
                  policy_key: 'capacity.limit',
                  policy_name: 'Upload capacity (Mb)',
                  activated: '${data.capacity_limit_activated ? 1:0}' == '1',
                  value: '${data.capacity_limit_value}',
                  option: true
                },
            ],
          },
          methods: {
            save: function () {
              $.ajax({
                type: 'post',
                url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/form.do',
                dataType: 'json',
                data: { formdata: JSON.stringify(this._data) },
                async: false,
                success: function (data) {
                  if (data.status == 'ok') {
                    alert('Has been saved.');
                    window.location.href = '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/list.do';
                  } else {
                    alert("Look like something went wrong, can't save tier data.");
                  }
                },
              });
            },
            loadTierPolicy() {
              $.ajax({
                type: 'post',
                url: '${pageContext.request.contextPath}/mindmap/admin/pricing/tier/form.do',
                dataType: 'json',
                data: { action: 'loadtier', tierid: this.extend_tier_id },
                async: false,
                success: function (data) {
                  if (data.status == 'ok') {
                    var policy = data.data;
                    Object.keys(policy).forEach(function(keyname) {
                      for (let i = 0; i < this.functions.length; i++) {
                        if(this.functions[i].policy_key.replace('.', '_') == keyname) {
                          this.$set(this.functions[i], 'activated', true);
                          if(policy[keyname].length) {
                            this.$set(this.functions[i], 'value', policy[keyname][0].value);
                            if(keyname == 'moodle') {
                              this.$set(this.functions[i], 'options', JSON.parse(policy[keyname][0].value));
                            }
                          }
                        }
                      }
                    }.bind(this));
                  } else {
                    alert("Look like something went wrong, can't load plan data.");
                  }
                }.bind(this),
              });
            }
          },
        });
      });
    </script>
  </head>

  <body>
    <div id="vapp">
      <template>
        <div class="p-3">
          <div class="font-weight-bold h4">
            <span>
              {{ id == '' ? 'Add new plan' : 'Update plan' }}
            </span>
          </div>
        </div>

        <div class="py-2 px-3 bg-white">
          <form @submit.prevent="save">
            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label>Name</label>
                  <input type="text" required class="form-control" v-model="name" />
                </div>
                <div class="form-group">
                  <label>Summary</label>
                  <textarea required rows="4" class="form-control" v-model="summary"></textarea>
                </div>
                <div class="custom-control custom-checkbox">
                  <input type="checkbox" class="custom-control-input" id="activated" v-model="activated" />
                  <label class="custom-control-label" for="activated">Activate</label>
                </div>
              </div>

              <div class="col-md-8">
                <div class="form-row align-items-center">
                  <div class="col-auto my-1">
                    <label>Extend from plan:</label>
                  </div>
                  <div class="col-auto my-1">
                    <select class="form-control" v-model="extend_tier_id">
                      <c:forEach var="tier" items="${data.tiers}">
                        <option value="${tier.id}">${tier.name}</option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="col-auto my-1">
                    <button type="button" class="btn btn-primary" :disabled="extend_tier_id == 0" @click="loadTierPolicy">Load policy</button>
                  </div>
                </div>
                <label>Settings</label>
                <table class="table table-sm">
                  <thead>
                    <tr>
                      <th scope="col">Function name</th>
                      <th scope="col">Value</th>
                    </tr>
                  </thead>

                  <tbody>
                    <template v-for="(fn, i) in functions">
                      <tr v-if="fn.type == 'header'">
                        <td colspan="2">
                          {{ fn.policy_name }}
                        </td>
                      </tr>
                      <tr v-else :class="{'bg-light': !fn.activated}" :style="{'opacity':fn.activated ? 1:0.5}">
                        <td>
                          <div :class="['custom-control custom-checkbox', {'ml-3': fn.type == 'sub'}]">
                            <input type="checkbox" class="custom-control-input" :id="'chk_'+i" v-model="fn.activated" />
                            <label class="custom-control-label" :for="'chk_'+i">{{ fn.policy_name }}</label>
                          </div>
                        </td>
                        <td>
                          <div v-if="fn.option" class="form-inline">
                            <template v-if="fn.policy_key == 'moodle'">
                              <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" :id="'opt_chk_'+i" v-model="fn.options.only_student" @change="fn.value = JSON.stringify(fn.options)" />
                                <label class="custom-control-label" :for="'opt_chk_'+i">Just as students</label>
                              </div>
                              <div class="input-group input-group-sm ml-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Courses hosting</span>
                                </div>
                                <input type="number" min="0" class="form-control" v-model="fn.options.course_hosting" :disabled="fn.options.only_student" @change="fn.value = JSON.stringify(fn.options)" />
                              </div>
                            </template>

                            <template v-else>
                              <div class="input-group input-group-sm">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Limit</span>
                                </div>
                                <input type="number" min="0" class="form-control" v-model="fn.value" :disabled="!fn.activated" />
                              </div>
                            </template>
                          </div>
                        </td>
                      </tr>
                    </template>
                  </tbody>
                </table>

                <div class="mt-4">
                  <a href="${pageContext.request.contextPath}/mindmap/admin/pricing/tier/list.do" class="mx-0 btn btn-secondary btn-min-w">
                    Cancel
                  </a>
                  <button type="submit" class="btn btn-primary btn-min-w btn-spinner">
                    <span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                    <spring:message code="button.save" />
                  </button>
                </div>
              </div>
            </div>
          </form>
        </div>
      </template>
    </div>
  </body>
</html>
