<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<c:choose>
    <c:when test="${cookie['locale'].getValue() == 'en'}">
        <c:set var="locale" value="en" />
    </c:when>
    <c:when test="${cookie['locale'].getValue() == 'es'}">
        <c:set var="locale" value="es" />
    </c:when>
    <c:when test="${cookie['locale'].getValue() == 'vi'}">
        <c:set var="locale" value="vi" />
    </c:when>
    <c:otherwise>
        <c:set var="locale" value="ko" />
    </c:otherwise>
</c:choose>

<fmt:setLocale value="${locale}" />

<!DOCTYPE html>
<html lang="${locale}">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
    <!-- Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>

    <script defer src="${pageContext.request.contextPath}/lib/apputil.js?v=<%=updateTime%>" type="text/javascript"></script>

    <script type="text/javascript" src="${pageContext.request.contextPath}/theme/dist/assets/js/Chart.min.js"></script>

    <!-- https://www.daterangepicker.com/ -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/theme/dist/assets/js/moment.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/theme/dist/assets/js/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/theme/dist/assets/css/daterangepicker.css" />

    <title>
        <spring:message code='menu.export_my_data' />
    </title>

    <style>
        .daterangepicker td.in-range,
        .daterangepicker td.available:hover,
        .daterangepicker th.available:hover {
            background-color: #48b87e30;
        }

        .daterangepicker td.active,
        .daterangepicker td.active:hover {
            background-color: #48b87e;
        }
    </style>

    <script type="text/javascript">
        var mChart = null;
        var dates = null;
        var config = {
            type: 'bar',
            data: {
                labels: [],
                datasets: [{
                    label: 'Total',
                    borderColor: '#48b87e',
                    backgroundColor: '#48b87e30',
                    borderWidth: 1,
                    data: []
                }],
            },
            options: {
                legend: {
                    display: false
                },
                title: {
                    display: true,
                    text: ''
                },
                responsive: true,
                scales: {
                    xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: ''
                        }
                    }],
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                },
                hover: {
                    animationDuration: 0
                },
                animation: {
                    duration: 400,
                    onComplete: function () {
                        var chartInstance = this.chart,
                            ctx = chartInstance.ctx;

                        ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, Chart.defaults.global.defaultFontStyle, Chart.defaults.global.defaultFontFamily);
                        ctx.textAlign = 'center';
                        ctx.textBaseline = 'bottom';

                        this.data.datasets.forEach(function (dataset, i) {
                            var meta = chartInstance.controller.getDatasetMeta(i);
                            if(meta.data.length <= 50) {
                                meta.data.forEach(function (bar, index) {
                                    var data = dataset.data[index];
                                    ctx.fillText(data, bar._model.x, bar._model.y - 5);
                                });
                            }
                        });
                    }
                },
            }
        };

        function loadding(show) {
            if (show) {
                $('#main-container').addClass('skeleton-loading');
            } else {
                $('#main-container').removeClass('skeleton-loading');
            }
        }

        function fetchData() {
            var params = $('#all').is(':checked') ? { all: '1' } : dates;
            loadding(true);
            $.post("${pageContext.request.contextPath}/mindmap/mydatastatistics.do", params, function (data) {
                var total = 0;
                var labels = [];
                datasets = [];
                for (var i = 0; i < data.data.length; i++) {
                    labels.push(data.data[i].month);
                    datasets.push(data.data[i].total);
                    total += data.data[i].total;
                }
                config.options.scales.xAxes[0].scaleLabel.labelString = "<spring:message code='common.total_maps' />".replace('[n]', total);
                config.data.labels = labels;
                config.data.datasets[0].data = datasets;
                mChart.update();

                if (total == 0) {
                    $('#export').addClass('d-none');
                    $('#export').attr('href', '#');
                } else {
                    $('#export').removeClass('d-none');
                    $('#export').attr('href', "${pageContext.request.contextPath}/export-zip-maps?" + $.param(params));
                }
            }).always(function () {
                loadding(false);
            });
        }

        $(document).ready(function () {
            if (!parent.jMap) window.location.href = '${pageContext.request.contextPath}';

            $('#all').change(function () {
                if ($(this).is(':checked')) {
                    $('#dates').prop('disabled', true);
                    fetchData();
                } else {
                    $('#dates').prop('disabled', false);
                    $('#dates').click();
                }
            });

            $('#dates').daterangepicker({
                "opens": "left",
                "locale": {
                    "applyLabel": "<spring:message code='button.apply' />",
                    "cancelLabel": "<spring:message code='button.cancel' />"
                }
            }, function (start, end, label) {
                dates = {
                    createdFrom: start.format('x'),   // Unix Millisecond Timestamp	
                    createdTo: end.format('x')        // Unix Millisecond Timestamp	
                };
                fetchData();
            });

            setTimeout(() => {
                var ctx = document.getElementById('mapChart').getContext('2d');
                mChart = new Chart(ctx, config);
                fetchData();
            }, 200);
        });
    </script>
</head>

<body>
    <div class="container-fluid p-3">
        <div class="d-md-flex justify-content-between">
            <div class="py-2"><spring:message code='menu.export_my_data_chart' /></div>
            <div class="">
                <div class="custom-control custom-checkbox mr-3 py-2">
                    <input type="checkbox" class="custom-control-input" id="all" checked>
                    <label class="custom-control-label" for="all">
                        <spring:message code='common.all' />
                    </label>
                </div>
                <input type="text" id="dates" disabled class="form-control" style="min-width: 250px;">
            </div>
        </div>
        <div id="main-container">
            <canvas id="mapChart" class="my-3" style="height: 400px;"></canvas>
            <div class="mt-3 text-center">
                <a href="#" class="btn btn-primary btn-min-w" id="export">
                    <spring:message code='button.export_to_zip' />
                </a>
            </div>
        </div>
    </div>
</body>

</html>