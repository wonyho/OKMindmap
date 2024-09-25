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

	<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>
	<script src="https://www.google.com/jsapi"></script>

	<title></title>

	<script type="text/javascript">
		// Load Google Search Api
		google.load('search', '1');

		var selectedItem = null;
		var webSearcher = null;
		var currentPage = 0;

		function OnLoad() {
			////////////////////// web /////////////////////////
			/*
			webSearcher = new google.search.WebSearch();
			webSearcher.setResultSetSize(8);
			webSearcher.setSearchCompleteCallback(this, function(searcher){
				var contentDiv = document.getElementById('dataview-content');
				contentDiv.innerHTML = '';

				if (searcher.results && searcher.results.length > 0) {
					var results = searcher.results;
					for (var i = 0; i < results.length; i++) {
						var result = results[i];

						var webContainer = document.createElement('div');
						webContainer.className = "webContainer";						
						webContainer.googleData = result;
						
						webContainer.onclick = function(){
							selectedItem && (selectedItem.style.background = "none");
							this.style.background = "#E0E4EE";
							contentSelect(this);							
						}
						webContainer.ondblclick  = function() {
							selectItemComplete();
						}
						
						//webContainer.innerHTML = "<a href=\"" + result.url + "\" target=\"_blank\">" + result.title + "</a>";
						webContainer.innerHTML = "<span width=\"100%\" title=\"" + result.content + "\">" + result.title + "</span>";
						contentDiv.appendChild(webContainer);

					}
	
				}
			}, [webSearcher]);
			*/
			///////////////////////////////////////////////////////////

			// 선택된 노드의 Text를 검색 단어로..
			try {
				if (parent.jMap.getSelected()) {
					document.getElementById("searchInput").value = parent.jMap.getSelected().getText();
					// 검색
					googleSearch();
				}
			} catch (e) { }


			parent.jMap.addActionListener(parent.ACTIONS.ACTION_NODE_SELECTED, function () {
				var node = arguments[0];
				var nodeText = node.getText();
				var searchInput = $('#searchInput').val();
				if(!$(parent.document.getElementById('googleSearch')).hasClass('closed') && nodeText != '' && nodeText != searchInput) {
					$('#searchInput').val(nodeText);
					googleSearch();
				}
			});
		}
		// google.setOnLoadCallback(OnLoad);



		function googleSearchFrom(page) {
			if (page == 0) $('#panel-body').addClass('skeleton-loading');
			else {
				$('#loadmore').prop('disabled', true);
			}
			$.ajax({
				/* type: 'GET',
				url: 'https://www.googleapis.com/customsearch/v1',
				dataType: 'json',
				data: {
					'key': 'AIzaSyCqhNd5-z2hAqEK1hSozv32AkFV88_TFjs',
					'cx': '006697568995703237209:vljrny3h45w',
					'q': document.getElementById("searchInput").value,
					'num': 8,
					'start': page * 8 + 1
				}, */
				type: 'GET',
				url: '${pageContext.request.contextPath}/api/search/text.do',
				dataType: 'json',
				data: {
					'q': document.getElementById("searchInput").value,
					'page': page > 0 ? page : 0
				}, 
				success: function (response) {
					var contentDiv = document.getElementById('dataview-content');
					if (page == 0) contentDiv.innerHTML = '';
					$.each(response.items, function (index, result) {
						var webContainer = document.createElement('div');
						webContainer.className = "webContainer";
						webContainer.googleData = {
							titleNoFormatting: result.snippet,
							url: result.formattedUrl
						};

						webContainer.onclick = function () {
							selectedItem && (selectedItem.style.background = "none");
							this.style.background = "#E0E4EE";
							contentSelect(this);
						}
						webContainer.ondblclick = function () {
							selectItemComplete();
						}

						//webContainer.innerHTML = "<a href=\"" + result.url + "\" target=\"_blank\">" + result.title + "</a>";
						webContainer.innerHTML = "<span class='p-2 d-block border-bottom cursor-pointer' title=\"" + result.snippet + "\">" + result.htmlTitle + "</span>";
						contentDiv.appendChild(webContainer);
					});

					if (response.items && response.items.length) {
						$('#noResult').addClass('d-none');
						$('#loadmore').removeClass('d-none');
					} else {
						if (page == 0) $('#noResult').removeClass('d-none');
						$('#loadmore').addClass('d-none');
					}

					if (page == 0) $('#panel-body').removeClass('skeleton-loading');
					else {
						$('#loadmore').prop('disabled', false);
						$("#panel-body").scrollTop($("#panel-body")[0].scrollHeight);
					}
				},
				error: function (err) {
					$('#panel-body').removeClass('skeleton-loading');
					$('#noResult').removeClass('d-none');
					$('#loadmore').addClass('d-none');
				}
			});
		}

		function googleSearch() {
			currentPage = 0;
			googleSearchFrom(currentPage);
			//webSearcher.execute(document.getElementById("searchInput").value);		
		}

		function contentSelect(el) {
			selectedItem = el;
		}

		function previousPage() {
			if (currentPage > 0) {
				currentPage--;
				googleSearchFrom(currentPage);
			}
			//var currentPageIndex = parseInt(webSearcher.cursor.currentPageIndex);
			//if(currentPageIndex > 0) {
			//	webSearcher.gotoPage(currentPageIndex-1);
			//}
		}

		function nextPage() {
			currentPage++;
			googleSearchFrom(currentPage);

			//var currentPageIndex = parseInt(webSearcher.cursor.currentPageIndex);
			//webSearcher.gotoPage(currentPageIndex+1);
		}

		function selectItemComplete() {
			var jMap = parent.jMap;
			var selected = jMap.getSelected();
			if(!selected) return true;

			var param = {
				parent: selected,
				text: selectedItem.googleData.titleNoFormatting
			};
			var newNode = jMap.createNodeWithCtrl(param);
			selected.folded && selected.setFolding(false);

			newNode.setHyperlink(unescape(selectedItem.googleData.url));

			jMap.layoutManager.updateTreeHeightsAndRelativeYOfAncestors(newNode);
			jMap.layoutManager.layout(true);
		}

		$(document).ready(function () {
			$(parent.document.getElementById('googleSearch')).removeClass('skeleton-loading');

			// $("#jino_frm_search").submit(function (event) {
			// 	event.preventDefault();
			// 	googleSearch();
			// });
			OnLoad();
		});
	</script>
</head>

<body>
	<div class="navbar navbar-light bg-white border-bottom px-2">
		<div class="w-100">
			<div class="input-group">
				<input type="text" autofocus required class="form-control shadow-none border-0 bg-light" id="searchInput" name="searchInput" placeholder="<spring:message code='common.search' />">
				<div class="input-group-append">
					<button class="btn btn-light shadow-none border-0 bg-light" onclick="googleSearch()">
						<img src="${pageContext.request.contextPath}/theme/dist/images/icons/search.svg" width="20px">
					</button>
				</div>
			</div>
		</div>
	</div>
	<div id="panel-body" class="container-fluid p-2" style="height: calc(100vh - 55px); overflow: auto;">
		<div class="text-center py-5 d-none" id="noResult">
			<img src="${pageContext.request.contextPath}/theme/dist/images/searching.svg" width="80px;">
			<h5 class="mt-3 text-muted">
				<spring:message code='common.search_noResult' />
			</h5>
		</div>
		<div id="dataview-content" style="font-size: .8rem;"></div>
		<button id="loadmore" type="button" class="mt-3 btn btn-dark btn-block btn-spinner d-none" onclick="nextPage()">
			<span class="spinner spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
			<spring:message code='common.load_more' />
		</button>
	</div>

</body>
	<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-6063842877624694"
     crossorigin="anonymous"></script>
</html>