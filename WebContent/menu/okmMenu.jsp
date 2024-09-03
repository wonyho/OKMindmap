<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${!isembed}">
	<!-- Left navbar -->
	<div class="panel navbar-l position-fixed left-0 pointer-events-none d-flex align-items-center z-10">
		<div class="bg-light border border-left-0 shadow-sm pointer-events-auto px-1 rounded-right">
			<a href="${pageContext.request.contextPath}/" class="btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="right" title="<spring:message code='menu.home'/>">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/home.svg" width="24px">
			</a>

			<button type="button" class="menu-shareManage jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="right" title="<spring:message code='menu.share'/>">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/share-2.svg" width="24px">
			</button>
			<button onclick="openPT();" type="button" class="jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="right" title="<spring:message code='menu.presentation'/>">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/presentation.svg" width="24px">
			</button>
			<button type="button" class="menu-openMap jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="right" title="<spring:message code='menu.mindmap_open'/>">
				<img src="${pageContext.request.contextPath}/menu/icons/icon_open.png" width="24px">
			</button>

			<button onclick="selectedMenu('help');" type="button"  class="menu-helps jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="right" title="<spring:message code='menu.help'/>">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/help-round-button.svg" width="24px">
			</button>
		</div>
	</div>
</c:if>

<!-- Right navbar -->
<div class="navbar-r position-fixed right-0 pointer-events-none z-10" style="${isembed ? 'top: 0px;':''}">
	<c:if test="${!isembed}">
		<div class="bg-light border shadow-sm pointer-events-auto px-1 mt-3 rounded">
			<a class="btn btn-light px-2 my-1 shadow-none" data-toggle="collapse" href="#collapseMenuNav" role="button" aria-expanded="false" aria-controls="collapseMenuNav" onclick="showNavMenu();">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/grid.svg" width="24px">
			</a>
		</div>
		<div class="bg-light border shadow-sm pointer-events-auto px-1 mt-2 rounded collapse" id="collapseMenuNav">
			<c:if test="${cookie['cefapp'].getValue() == 'true'}">
				<button onclick="selectedMenu('cefapp')" type="button" class="jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='common.freemind'/>">
					<img src="${pageContext.request.contextPath}/images/icons/freemind.png" width="24px">
				</button>
			</c:if>

			<button onclick="selectedMenu('file')" type="button" class="jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='menu.file.file'/>">
				<img src="${pageContext.request.contextPath}/menu/icons/files.png" width="24px">
			</button>
			<button onclick="selectedMenu('map-style')" type="button" class="jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='menu.advanced.pt.mapstyle'/>">
				<img src="${pageContext.request.contextPath}/menu/icons/Mapstyle.png" width="24px">
			</button>
			<button onclick="selectedMenu('setting')" type="button" class="jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='menu.setting'/>">
				<img src="${pageContext.request.contextPath}/theme/dist/images/icons/settings.svg" width="24px">
			</button>
			<button onclick="selectedMenu('moodle')" type="button" class="jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='message.moodle'/>">
				<img src="${pageContext.request.contextPath}/menu/icons/moodle.png" width="24px">
			</button>
		</div>
	</c:if>

	<div class="bg-light border shadow-sm pointer-events-auto px-1 mt-2 rounded" id="zoomMenus">
		<button type="button" class="menu-zoominAction jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='menu.view.zoomin' />">
			<img src="${pageContext.request.contextPath}/theme/dist/images/icons/plus.svg" width="24px">
		</button>
		<button type="button" class="menu-zoomoutAction jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='menu.view.zoomout' />">
			<img src="${pageContext.request.contextPath}/theme/dist/images/icons/minus.svg" width="24px">
		</button>
		<button type="button" class="menu-zoomnotAction jino-menu-item btn btn-light px-2 my-1" data-toggle="tooltip" data-placement="left" title="<spring:message code='menu.view.zoomnot' />">
			<img src="${pageContext.request.contextPath}/theme/dist/images/icons/maximize.svg" width="24px">
		</button>
	</div>
</div>

<c:if test="${!isembed}">
	<!-- Context Menus -->
	<div class="jino-menus-wrap w-100 position-fixed left-0 bottom-0 bg-light border-top shadow-sm z-20">
		<div class="jino-menus px-3 py-2 text-center position-relative">
			<!-- CefApp -->
			<button data-group="cefapp" class="menu-importMap jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/icon_open.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.open' />
				</small>
			</button>
			<button data-group="cefapp" class="menu-exportToFreemind jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/file_saveas.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='message.saveas' />
				</small>
			</button>

			<!-- File -->
			<button data-group="file" class="menu-newMap jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/file_new.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.mindmap.new' />
				</small>
			</button>
			<button data-group="file" class="menu-openMap jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/icon_open.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.mindmap.open' />
				</small>
			</button>
			
			
			<div data-group="file" class="jino-menu-item divider"></div>
			<button data-group="file" class="menu-clipBoard jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/share_import.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.import' />
				</small>
			</button>
			<button data-group="file" class="menu-exportFile jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/share_export.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.export' />
				</small>
			</button>
			<button data-group="file" class="menu-remixActions jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/Remix.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.remixActions' />
				</small>
			</button>
			
			<div data-group="file" class="jino-menu-item divider"></div>
			
			<button data-group="file" class="menu-saveAsMap jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/icon_saveas.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='message.saveas' />
				</small>
			</button>
			<button data-group="file" class="menu-changeMapName jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/file_name.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='message.changntitle' />
				</small>
			</button>
			<button data-group="file" class="menu-timelineMode jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/timeline_timeline.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.mindmap.timelinemode' />
				</small>
			</button>
			<button data-group="file" class="menu-delMap jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/file_del.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.mindmap.delete' />
				</small>
			</button>

			<!-- Map Style -->
			<button data-group="map-style" class="menu-changeToMindmap jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/shape_mindmap.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.mindmap' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToCard jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/shape_card.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.card' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToSunburst jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/shape_sunburst.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.sunburst' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToTree jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.tree' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToHTree jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/shape_treemap2.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.project' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToPadlet jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/show_padlet.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.padlet' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToPartition jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/show_partition.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.partition' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToFishbone jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/show_fishbone.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.fishbone' />
				</small>
			</button>
			<button data-group="map-style" class="menu-changeToZoomableTreemap jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/show_zoomabletreemap.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='common.mapstyle.zoomabletreemap' />
				</small>
			</button>
			
			<!-- <div data-group="setting" class="jino-menu-item divider"></div> -->
			<button data-group="setting" class="menu-shareManage jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/share_share.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.setting.share' />
				</small>
			</button>
			<button data-group="setting" class="menu-groupManage jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/share_group.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.setting.group' />
				</small>
			</button>
			<div data-group="setting" class="jino-menu-item divider"></div>
			<button data-group="setting" class="menu-okmPreference jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/MapBehavior.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.okmpreference' />
				</small>
			</button>
			<button data-group="setting" class="menu-usrPreference jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/SizeConfig.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.usrpreference' />
				</small>
			</button>
			<button data-group="setting" class="menu-activityMonitoring jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/activity_icon.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.advanced.activity' />
				</small>
			</button>
			<button data-group="setting" class="menu-createEmbedTag jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/share_embed.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='video.tabs.embed' />
				</small>
			</button>
			<button data-group="setting" disabled class="menu-FacebookGetFeedAction jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/share_facebook.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.plugin.facebook' />
				</small>
			</button>
			<div data-group="setting" class="jino-menu-item font-weight-bold text-muted mx-1 my-3">
				<div class="custom-control custom-switch">
					<input class="custom-control-input" type="checkbox" value="1" name="restrict_editing" id="restrict_editing" onclick="setRestrictEditing();" />
					<label class="custom-control-label" for="restrict_editing">
						<spring:message code='menu.etc.restrictediting' />
					</label>
				</div>
			</div>

			<!-- Moodle -->
			<button data-group="moodle" class="menu-createMoodle jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/ConnectCourse.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.mindmap.moodle.new' />
				</small>
			</button>
			<button data-group="moodle" class="menu-addMoodleActivityAction jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/LearningNode.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.edit.moodle.childnode' />
				</small>
			</button>
			<button data-group="moodle" class="menu-courseEnrolment jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/Enrollment.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.setting.enrolment' />
				</small>
			</button>

			<!-- global -->
			<button data-group="global" class="menu-foldingall jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/edit_expand.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.view.afolding' />
				</small>
			</button>
			<button data-group="global" class="menu-CtrlRAction jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/noalige_icon.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.view.rangenode' />
				</small>
			</button>
			<div data-group="global" class="jino-menu-item divider"></div>
			<button data-group="global" class="menu-changeNodeAllColorAction jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/theme_theme.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.theme' />
				</small>
			</button>
			<button data-group="global" class="menu-nodeColorMix jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/edit_changecolor.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.plugin.colorchange' />
				</small>
			</button>
			<button data-group="global" class="menu-changeMapBackgroundAction jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/theme_background.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.plugin.mapbackgroundchange' />
				</small>
			</button>
			<div data-group="global" class="jino-menu-item divider"></div>
			<button data-group="global" class="menu-rightPanelFolding jino-menu-item btn btn-light p-1 shadow-none position-relative">
				<img src="${pageContext.request.contextPath}/menu/icons/chat-icon.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='chatting.expanding' />
				</small>
				<span class="badge badge-light position-absolute top-0 right-0 rounded-fill py-1 px-2 bg-blue text-white d-none z-10" id="chatUnread"></span>
			</button>
			<button data-group="global" class="menu-googleSearch jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/show_google.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.advanced.googlesearch' />
				</small>
			</button>
			<button data-group="global" class="jino-menu-item btn btn-light p-1 shadow-none" id="googleTranslate">
				<img src="${pageContext.request.contextPath}/menu/icons/translate.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.advanced.googletranslate' />
				</small>
			</button>
			<div class="dropdown-menu" id="googleTranslateContent" style="max-height: 150px;overflow-y: scroll;">
				<a class="dropdown-item langitem" lang="en">English</a>
				<a class="dropdown-item langitem" lang="es">Española</a>
				<a class="dropdown-item langitem" lang="vi">Tiếng Việt</a>
				<a class="dropdown-item langitem" lang="ko">한국어</a>
				<a class="dropdown-item langitem" lang="af">Afrikaans</a>
				<a class="dropdown-item langitem" lang="sq">Shqiptare</a>
				<a class="dropdown-item langitem" lang="am">አማርኛ</a>
				<a class="dropdown-item langitem" lang="ar">عربى</a>
				<a class="dropdown-item langitem" lang="hy">հայերեն</a>
				<a class="dropdown-item langitem" lang="az">Azərbaycan dili</a>
				<a class="dropdown-item langitem" lang="eu">Euskara</a>
				<a class="dropdown-item langitem" lang="be">Беларуская</a>
				<a class="dropdown-item langitem" lang="bn">বাংলা</a>
				<a class="dropdown-item langitem" lang="bs">Bosanski</a>
				<a class="dropdown-item langitem" lang="bg">български</a>
				<a class="dropdown-item langitem" lang="ca">Català</a>
				<a class="dropdown-item langitem" lang="ceb">Sugbuanon</a>
				<a class="dropdown-item langitem" lang="zh-CN">简体中文</a>
				<a class="dropdown-item langitem" lang="zh-TW">中國傳統的</a>
				<a class="dropdown-item langitem" lang="co">Corsu</a>
				<a class="dropdown-item langitem" lang="hr">Hrvatski</a>
				<a class="dropdown-item langitem" lang="cs">čeština</a>
				<a class="dropdown-item langitem" lang="da">Dansk</a>
				<a class="dropdown-item langitem" lang="nl">Nederlands</a>
				<a class="dropdown-item langitem" lang="en">English</a>
				<a class="dropdown-item langitem" lang="eo">Esperanto</a>
				<a class="dropdown-item langitem" lang="et">Eestlane</a>
				<a class="dropdown-item langitem" lang="fi">Suomalainen</a>
				<a class="dropdown-item langitem" lang="fr">Française</a>
				<a class="dropdown-item langitem" lang="gl">Galego</a>
				<a class="dropdown-item langitem" lang="ka">ქართველი</a>
				<a class="dropdown-item langitem" lang="de">Deutsche</a>
				<a class="dropdown-item langitem" lang="el">Ελληνικά</a>
				<a class="dropdown-item langitem" lang="gu">ગુજરાતી</a>
				<a class="dropdown-item langitem" lang="ht">Kreyòl ayisyen</a>
				<a class="dropdown-item langitem" lang="ha">Hausa</a>
				<a class="dropdown-item langitem" lang="haw">Ōlelo Hawaiʻi</a>
				<a class="dropdown-item langitem" lang="he">עִברִית</a>
				<a class="dropdown-item langitem" lang="hi">हिंदी</a>
				<a class="dropdown-item langitem" lang="hmn">Hmong</a>
				<a class="dropdown-item langitem" lang="hu">Magyar</a>
				<a class="dropdown-item langitem" lang="is">Íslenska</a>
				<a class="dropdown-item langitem" lang="ig">Igbo</a>
				<a class="dropdown-item langitem" lang="id">bahasa Indonesia</a>
				<a class="dropdown-item langitem" lang="ga">Gaeilge</a>
				<a class="dropdown-item langitem" lang="it">Italiana</a>
				<a class="dropdown-item langitem" lang="ja">日本語</a>
				<a class="dropdown-item langitem" lang="jv">Wong jawa</a>
				<!-- <a class="dropdown-item langitem" lang="kn">ಕನ್ನಡ</a> -->
				<a class="dropdown-item langitem" lang="kk">Қазақ</a>
				<a class="dropdown-item langitem" lang="km">ខ្មែរ</a>
				<a class="dropdown-item langitem" lang="rw">Kinyarwanda</a>
				<a class="dropdown-item langitem" lang="ko">한국어</a>
				<a class="dropdown-item langitem" lang="ku">Kurdî</a>
				<a class="dropdown-item langitem" lang="ky">Кыргызча</a>
				<a class="dropdown-item langitem" lang="lo">ລາວ</a>
				<a class="dropdown-item langitem" lang="la">Latine</a>
				<a class="dropdown-item langitem" lang="lv">Latvietis</a>
				<a class="dropdown-item langitem" lang="lt">Lietuvis</a>
				<a class="dropdown-item langitem" lang="lb">Lëtzebuergesch</a>
				<a class="dropdown-item langitem" lang="mk">Македонски</a>
				<a class="dropdown-item langitem" lang="mg">Malagasy</a>
				<a class="dropdown-item langitem" lang="ms">Bahasa Melayu</a>
				<a class="dropdown-item langitem" lang="ml">മലയാളം</a>
				<a class="dropdown-item langitem" lang="mt">Malti</a>
				<a class="dropdown-item langitem" lang="mi">Maori</a>
				<a class="dropdown-item langitem" lang="mr">मराठी</a>
				<a class="dropdown-item langitem" lang="mn">Монгол</a>
				<a class="dropdown-item langitem" lang="ne">नेपाली</a>
				<a class="dropdown-item langitem" lang="no">Norsk</a>
				<a class="dropdown-item langitem" lang="ny">Nyanja (Chichewa)</a>
				<a class="dropdown-item langitem" lang="or">ଓଡିଆ (ଓଡିଆ)</a>
				<a class="dropdown-item langitem" lang="ps">پښتو</a>
				<a class="dropdown-item langitem" lang="fa">فارسی</a>
				<a class="dropdown-item langitem" lang="pl">Polskie</a>
				<a class="dropdown-item langitem" lang="pt">Português (Portugal, Brasil)</a>
				<a class="dropdown-item langitem" lang="pa">ਪੰਜਾਬੀ</a>
				<a class="dropdown-item langitem" lang="ro">Romanian</a>
				<a class="dropdown-item langitem" lang="ru">русский</a>
				<a class="dropdown-item langitem" lang="sm">Faasamoa</a>
				<a class="dropdown-item langitem" lang="sr">Српски</a>
				<a class="dropdown-item langitem" lang="sn">Shona</a>
				<a class="dropdown-item langitem" lang="sd">سنڌي</a>
				<a class="dropdown-item langitem" lang="si">සිංහල (සිංහල)</a>
				<a class="dropdown-item langitem" lang="sk">Slovák</a>
				<a class="dropdown-item langitem" lang="sl">Slovenščina</a>
				<a class="dropdown-item langitem" lang="so">Soomaali</a>
				<a class="dropdown-item langitem" lang="es">Española</a>
				<a class="dropdown-item langitem" lang="su">Sundanis</a>
				<a class="dropdown-item langitem" lang="sw">Kiswahili</a>                      
				<a class="dropdown-item langitem" lang="sv">Svenska</a>
				<a class="dropdown-item langitem" lang="tg">Тоҷикӣ</a>
				<a class="dropdown-item langitem" lang="ta">தமிழ்</a>
				<a class="dropdown-item langitem" lang="tt">Татар</a>
				<!-- <a class="dropdown-item langitem" lang="te">తెలుగు</a> -->
				<a class="dropdown-item langitem" lang="th">ไทย</a>
				<a class="dropdown-item langitem" lang="tr">Türk</a>
				<a class="dropdown-item langitem" lang="tk">Türkmenler</a>
				<a class="dropdown-item langitem" lang="uk">Український</a>
				<a class="dropdown-item langitem" lang="ur">اردو</a>                      
				<a class="dropdown-item langitem" lang="ug">ئۇيغۇر</a>
				<a class="dropdown-item langitem" lang="uz">O'zbek</a>
				<a class="dropdown-item langitem" lang="vi">Tiếng Việt</a>
				<a class="dropdown-item langitem" lang="cy">Cymraeg</a>                      
				<a class="dropdown-item langitem" lang="xh">isiXhosa</a>
				<a class="dropdown-item langitem" lang="yi">יידיש</a>
				<a class="dropdown-item langitem" lang="yo">Yoruba</a>
				<a class="dropdown-item langitem" lang="zu">Zulu</a>
			 </div>

			<!-- node -->
			<span id="nodeMenuContent"></span>
			
			 
			<c:if test="${user.id != 2}">
				<button data-group="node" class="menu-sessionMenuSetting jino-menu-item btn btn-light p-1 shadow-none">
					<img src="${pageContext.request.contextPath}/menu/icons/node/menu.usrsetting.png" width="20px" class="d-block mx-auto">
					<small>
						<spring:message code='menu.usrsetting' />
					</small>
				</button>
			</c:if>
			<button data-group="node" class="menu-testRobotTool jino-menu-item btn btn-light p-1 shadow-none" style="display: none !important;">
				<img src="${pageContext.request.contextPath}/menu/icons/settings.png" width="20px" class="d-block mx-auto">
				<small>
					Debug test
				</small>
			</button>
			
			<button data-group="help" class="menu-okmNoticeAction jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/ribbonmenu/ribbonicons/customer_notice.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.cs.notice' />
				</small>
			</button>
			<button data-group="help" class="menu-requestFunction jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/ribbonmenu/ribbonicons/customer_qna.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.cs.qna' />
				</small>
			</button>
			<button data-group="help" class="menu-howtoUse jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/ribbonmenu/ribbonicons/customer_manual.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.help.usage' />
				</small>
			</button>
			<button data-group="help" class="menu-openHotKeys jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/ribbonmenu/ribbonicons/hotkey.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.help.hotKey' />
				</small>
			</button>
			<button data-group="help" onclick="window.open('${pageContext.request.contextPath}/doc/iot/home.jsp','_blank');" class="jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/node/menu.plugin.iot_providers.png" width="20px" class="d-block mx-auto">
				<small>
					IoT
				</small>
			</button>
			
			<c:if test="${user.id != 2}">
				<button data-group="help" onclick="window.open('http://133.186.143.148:1880/auth/iotlogin?username=&password=','_blank');" class="jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/node/menu.plugin.node_red.png" width="20px" class="d-block mx-auto">
				<small>
					Node-RED
				</small>
				</button>
			</c:if>
			
			<c:if test="${user.id == 2}">
				<button data-group="help" onclick="window.open('http://133.186.143.148:1880','_blank');" class="jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/menu/icons/node/menu.plugin.node_red.png" width="20px" class="d-block mx-auto">
				<small>
					Node-RED
				</small>
				</button>
			</c:if>
			
			<button data-group="help" class="menu-aboutJinoTech jino-menu-item btn btn-light p-1 shadow-none">
				<img src="${pageContext.request.contextPath}/ribbonmenu/ribbonicons/customer_com.png" width="20px" class="d-block mx-auto">
				<small>
					<spring:message code='menu.help.introjino' />
				</small>
			</button>
			<!-- <div class="jino-menu-item jino-menu-item-txt show font-weight-bold text-muted mx-1 my-3"><spring:message code='menu.choiceObj' /></div> -->
		</div>
	</div>

	<div id="nodePopupEditBox" class="d-none">
		<div id="popupEditBox_div">
			<textarea data-autoresize id="popupEditBox_text" type="text" value="" onkeypress=""></textarea>
		</div>
		<!-- <input type="button" onclick="" value="닫기" class="btn popEditBtn"> -->
	</div>
	
</c:if>
<style>
	input[type=range][orient=vertical]
	{
	    writing-mode: bt-lr; /* IE */
	    -webkit-appearance: slider-vertical; /* WebKit */
	    width: 8px;
	    height: 175px;
	    padding: 0 5px;
	}
</style>
<script>
var base = '${pageContext.request.contextPath}';
var fold = true;
var foldingAll = function() {
	if (fold) {
		foldingAllAction();
		fold = false;
	} else {
		unfoldingAllAction();
		fold = true;
	}
}

var edgeMenu = function(){
	if($("#edge-menu").css("display") == "none"){
		$("#edge-menu").css("display","block");
	}else{
		$("#edge-menu").css("display","none");
	}
}

var hidenSessionMenu = function(){
	$("#edge-menu").css("display","none");
	$("#main-menu #content").css("display","none");
}

var changeEditMenu = function(idx){
	if(idx==0){
		$("#nodeEditMenu").css("display","none");
		$("#nodeEditMenu-2").css("display","block");
	}else{
		$("#nodeEditMenu-2").css("display","none");
		$("#nodeEditMenu").css("display","block");
	}
}

var changeAttachMenu = function(idx){
	if(idx==0){
		$("#nodeAttachMenu").css("display","none");
		$("#nodeAttachMenu-2").css("display","inline-block");
	}else{
		$("#nodeAttachMenu-2").css("display","none");
		$("#nodeAttachMenu").css("display","inline-block");
	}
}

var closeDialog = function() {
	$("#dialog").dialog("close");
	jMap.work.focus();
	
}

var clearUrl  = function(){
	$("#url").val(" ");
}

var openPT = function(){
	if(jMap.cfg.canEdit && !jMap.cfg.isShrdGuest) 
		presentationEditMode(); 
	else presentationStartMode(); 
}

//CSEDUNG
const nodeFuncList = {
		'menueditsiblingnode':'menu-insertSiblingAction',
		'menueditchildnode':'menu-insertAction',
		'menuedit':'menu-editNodeAction',
		'menueditcut':'menu-cutAction',
		'menueditcopy':'menu-copyAction',
		'menueditpaste':'menu-pasteAction',
		'menueditdelete':'menu-deleteAction',
		'menuviewfolding':'menu-foldingAction',
		'menuedithyperlink':'menu-insertHyperAction',
		'menueditimageurl':'menu-imageProviderAction',
		'videovideo_upload':'menu-videoProviderAction',
		'menueditwebpage':'menu-insertWebPageAction',
		'menufileProviderAction':'menu-fileProviderAction',
		'menuinsertNoteAction':'menu-insertNoteAction',
		'menueditiframe':'menu-insertIFrameAction',
		'menupluginiot_providers':'menu-iotProvidersAction',
		'menupluginiot_control':'menu-iotControlAction',
		'menueditlti':'menu-insertLTIAction',
		'menutextimportexportexport':'menu-nodeStructureToText',
		'menutextimportexportimport':'menu-nodeStructureFromText',
		'menuxmlimportexportexport':'menu-nodeStructureToXml',
		'menuxmlimportexportimport':'menu-nodeStructureFromXml',
		'menuinsertTextOnBranchAction':'menu-insertTextOnBranchAction',
		'menunodeToNodeAction':'menu-nodeToNodeAction',
		/* 'menuremoveArrowLink':'menu-removeArrowLink', */
		'menusettingArrowLink':'menu-settingArrowLink',
		'menufontsize':' ',
		'menunodeTextColorAction':'menu-nodeTextColorAction',
		'menunodeBGColorAction':'menu-nodeBGColorAction',
		'menunodeEdgeColorAction':'menu-nodeEdgeColorAction',
		'menuedgeMenu':' ',
		'menumindmapnewnodemap':'menu-splitMap'
}
const nodeFuncNameList = {
		'menueditsiblingnode':'<spring:message code="menu.edit.siblingnode" />',
		'menueditchildnode':'<spring:message code="menu.edit.childnode" />',
		'menuedit':'<spring:message code="menu.edit" />',
		'menueditcut':'<spring:message code="menu.edit.cut" />',
		'menueditcopy':'<spring:message code="menu.edit.copy" />',
		'menueditpaste':'<spring:message code="menu.edit.paste" />',
		'menueditdelete':'<spring:message code="menu.edit.delete" />',
		'menuviewfolding':'<spring:message code="menu.view.folding" />',
		'menuedithyperlink':'<spring:message code="menu.edit.hyperlink" />',
		'menueditimageurl':'<spring:message code="menu.edit.imageurl" />',
		'videovideo_upload':'<spring:message code="video.video_upload" />',
		'menueditwebpage':'<spring:message code="menu.edit.webpage" />',
		'menufileProviderAction':'<spring:message code="menu.fileProviderAction" />',
		'menuinsertNoteAction':'<spring:message code="menu.insertNoteAction" />',
		'menueditiframe':'<spring:message code="menu.edit.iframe" />',
		'menupluginiot_providers':'<spring:message code="menu.plugin.iot_providers" />',
		'menupluginiot_control':'<spring:message code="menu.plugin.iot_control" />',
		'menueditlti':'<spring:message code="menu.edit.lti" />',
		'menutextimportexportexport':'<spring:message code="menu.textimportexport.export" />',
		'menutextimportexportimport':'<spring:message code="menu.textimportexport.import" />',
		'menuxmlimportexportexport':'<spring:message code="menu.xmlimportexport.export"/>',
		'menuxmlimportexportimport':'<spring:message code="menu.xmlimportexport.import"/>',
		'menuinsertTextOnBranchAction':'<spring:message code="menu.insertTextOnBranchAction" />',
		'menunodeToNodeAction':'<spring:message code="menu.nodeToNodeAction" />',
		/* 'menuremoveArrowLink':'<spring:message code="menu.removeArrowLink" />', */
		'menusettingArrowLink':'<spring:message code="menu.settingArrowLink" />',
		'menufontsize':'<spring:message code="menu.fontsize" />',
		'menunodeTextColorAction':'<spring:message code="menu.nodeTextColorAction" />',
		'menunodeBGColorAction':'<spring:message code="menu.nodeBGColorAction" />',
		'menunodeEdgeColorAction':'<spring:message code="menu.nodeEdgeColorAction" />',
		'menuedgeMenu':'<spring:message code="menu.edgeMenu" />',
		'menumindmapnewnodemap':'<spring:message code="menu.mindmap.newnodemap" />'
}

var checkNodeMenu = function () {
/* 	if(jMap.cfg.isShrdGuest){
		$('.node-menu').attr('style', 'display: none !important;');
		for (i = 0; i < defaultNodeMenuGuest.length; i++) {
			var id = defaultNodeMenuGuest[i].split('.').join('');
			$('#' + id).attr('style', '');
		}
	}else{ */
	$.ajax({
		url: parent.jMap.cfg.contextPath + '/user/usernodesetting.do?',
		data: "confirmed=json",
		type: 'POST',
		success: function (data) {
			
			var txt = '';
			$.each(data, function (index, item) {
				var id = item.fieldname;
				id = id.split('.').join('');
				txt += '<button data-group="node" id="'+id+'" onclick="'+nodeFuncList[id].replace("menu-","")+'()" class="node-menu '+nodeFuncList[id]+' jino-menu-item btn btn-light p-1 shadow-none">';
				txt += '<img src="'+base+'/menu/icons/node/'+item.fieldname+'.png" width="20px" class="d-block mx-auto">';
				txt += '<small>'+nodeFuncNameList[id]+'</small></button>';
			});
			txt += '<div class="dropdown-menu" id="fontMenuContent" style="min-width: 5px !important;">'+
				'<span id="fontText" style="position: absolute;top: -20px;"></span>'+
			  	'<input type="range" min="1" max="100" orient="vertical" id="fontVal"/>'+
			 '</div>'+
			'<div class="dropdown-menu" id="edgeMenuContent">'+
			   '<a class="dropdown-item edgeitem" id="e1"><div style="width: 100%; height: 0px; border: 1px solid #007bff; margin: 6px 0;"></div></a>'+
			   '<a class="dropdown-item edgeitem" id="e2"><div style="width: 100%; height: 0px; border: 2px solid #007bff; margin: 6px 0;"></div></a>'+
			   '<a class="dropdown-item edgeitem" id="e3"><div style="width: 100%; height: 0px; border: 3px solid #007bff; margin: 6px 0;"></div></a>'+
			   '<a class="dropdown-item edgeitem" id="e6"><div style="width: 100%; height: 0px; border: 3.5px solid #007bff; margin: 6px 0;"></div></a>'+
			   '<a class="dropdown-item edgeitem" id="e8"><div style="width: 100%; height: 0px; border: 4px solid #007bff; margin: 6px 0;"></div></a>'+
			 '</div>';
			$("#nodeMenuContent").html(txt);
			
			$(document).on('input change', '#fontVal', function() {
				console.log($(this).val());
				setNodeFontSize($(this).val());
				$("#fontText").text($(this).val());
			});

			$(".edgeitem").click(function(){
				var id = $(this).attr("id");
				nodeEdgeWidthAction(id.replace("e",""));
				$("#edgeMenuContent").hide();
				$("#edgeMenuContent").removeClass("show");
			});
			
			$(".langitem").click(function(){
				translateMapContent($(this).attr("lang"));
				$("#googleTranslateContent").hide();
				$("#googleTranslateContent").removeClass("show");
			});

			$(".jino-menu-item").click(function(){
				if($("#edgeMenuContent").hasClass("show") 
						|| $("#fontMenuContent").hasClass("show")
						|| $("#googleTranslateContent").hasClass("show") ){
					$("#edgeMenuContent").hide();
					$("#edgeMenuContent").removeClass("show");
					$("#fontMenuContent").hide();
					$("#fontMenuContent").removeClass("show");
					$("#googleTranslateContent").hide();
					$("#googleTranslateContent").removeClass("show");
				}else{
					if($(this).attr("id")=="menuedgeMenu"){
						var pos = $("#menuedgeMenu").offset();
						$("#edgeMenuContent").css("position","fixed");
						$("#edgeMenuContent").css("top",pos.top-160);
						$("#edgeMenuContent").css("left",pos.left);
						$("#edgeMenuContent").show();
						$("#edgeMenuContent").addClass("show");
					}else if($(this).attr("id")=="menufontsize"){
						var pos = $("#menufontsize").offset();
						$("#fontMenuContent").css("position","fixed");
						$("#fontMenuContent").css("top",pos.top-200);
						$("#fontMenuContent").css("left",pos.left+20);
						$("#fontMenuContent").show();
						$("#fontMenuContent").addClass("show");
						var v = getNodeFontSize();
						$("#fontVal").val(v);
						$("#fontText").text(v);
					}else if($(this).attr("id")=="googleTranslate"){
						var pos = $("#googleTranslate").offset();
						$("#googleTranslateContent").css("position","fixed");
						$("#googleTranslateContent").css("top",pos.top-160);
						$("#googleTranslateContent").css("left",pos.left);
						$("#googleTranslateContent").show();
						$("#googleTranslateContent").addClass("show");
					}
				}
			});
			if($.cookie('currentSessionMenu') == 'node') $('.node-menu').addClass('show');;
		}
	});
}
var intext = "";
var translated;
var tranidx = 0;
var hasTranslated = false;
var translateMapContent = function(targetLanguage){
	var nodes = jMap.getRootNode().getChildren();
	intext = "";
	intext += "<div>" + jMap.getRootNode().getText() + "</div>";
	getChildText(nodes);
    var outtext = "";
//    console.log(intext);
// Google translator is out of free service
/*    $.ajax({
		url: "https://translation.googleapis.com/language/translate/v2",
		data: {q: intext, format: "html", target:  targetLanguage, key: "<c:out value='${data.translate_api}'/>"},
		type: 'POST',
		success: function (data) {
			outtext = data.data.translations[0].translatedText;
	        translated = outtext.split("</div>");
//	        console.log(translated);
	        tranidx = 0;
	        jMap.getRootNode().setTranslatedText(translated[tranidx++].replace("<div>",""));
	        setChildText(nodes);
	        hasTranslated = true;
	        alert("Your map was translated, will not be saved. \nPlease save as...");
	        CtrlRAction();
		}
    });
//    setTimeout(CtrlRAction, 2000);
*/

//start AI translator
    const data = JSON.stringify({
    	texts: [
    		intext
    	],
    	tls: [
    		targetLanguage
    	]
    });

    const xhr = new XMLHttpRequest();
    xhr.withCredentials = true;

    xhr.addEventListener('readystatechange', function () {
    	if (this.readyState === this.DONE) {
    		var text = JSON.parse(this.responseText.substring(1, this.responseText.length-1));
	        translated = text.texts.split("</div>");
	        tranidx = 0;
	        jMap.getRootNode().setTranslatedText(translated[tranidx++].replace("<div>",""));
	        setChildText(nodes);
	        hasTranslated = true;
	        alert("Your map was translated, will not be saved. \nPlease save as...");
    	}
    });

    xhr.open('POST', 'https://ai-translate.p.rapidapi.com/translates');
    xhr.setRequestHeader('content-type', 'application/json');
    xhr.setRequestHeader('X-RapidAPI-Key', '32b9f2f3ecmshb5d365168f07daap1a8031jsn7152974fe46f');
    xhr.setRequestHeader('X-RapidAPI-Host', 'ai-translate.p.rapidapi.com');

    xhr.send(data);
//end AI translator
}

var getChildText = function(nodes){
	for(var i=0;i < nodes.length; i++){
		intext += "<div>" + nodes[i].getText() + "</div>";
		var ns = nodes[i].getChildren();
		if(ns.length > 0){
			getChildText(nodes[i].getChildren());
		}
	}
}

var setChildText = function(nodes){
	for(var i=0;i < nodes.length; i++){
		var txt = translated[tranidx++].replace("<div>","");
		nodes[i].setTranslatedText(txt);
		var ns = nodes[i].getChildren();
		if(ns.length > 0){
			setChildText(nodes[i].getChildren());
		}
	}
}

/*  var asyncIoT = function(node){
	if(node == undefined) return;
	node.asyncIotDevice();
	var nodes = node.getChildren();
	for(var i=0;i < nodes.length; i++){
		asyncIoT(nodes[i]);
	}
}  */

$(document).ready(function(){
	setTimeout(checkNodeMenu, 200);
	$("#closeIframeDialog").click(function(){
		setTimeout(function(){
			jMap.work.focus();
			
			}, 1000);
//		lastSelected.focus();
		lastSelected = null;
	});
	setInterval(checkSession, 3000);
	
});


</script>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-Q20CLYKQMN"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-Q20CLYKQMN');
</script>
