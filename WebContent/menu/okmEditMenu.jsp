<%@ page contentType="text/html; charset=utf-8"%>
<script>

var _saveAs = "<spring:message code='message.saveas'/>";
var _textOnBranck = "<spring:message code='dialog.textOnBranch'/>";
var _delete = "<spring:message code='button.delete'/>";
var _noInput = "<spring:message code='confirm.noInput'/>";
var _canNotDelRoot = "<spring:message code='confirm.canNotDelRoot'/>";
var _confirmDelNode = "<spring:message code='confirm.deletenode'/>";
var _confirmCutNode = "<spring:message code='confirm.cutnode'/>";
var _upload = "<spring:message code='image.image_upload'/>";
var _apply = "<spring:message code='button.apply'/>";
var _confirm = "<spring:message code='button.confirm'/>";
var _cancel = "<spring:message code='button.cancel'/>";
var _nextMenu = "<spring:message code='menu.openEditMenuTopic'/>";
var _priMenu = "<spring:message code='menu.openEditMenuTopic'/>";
var _openEditMenuTopic = "<spring:message code='menu.openEditMenuTopic'/>";
var _openEditMenuTopic_M = "<spring:message code='menu.openEditMenuTopic_M'/>";
var _meno = "<spring:message code='alert.memo'/>";

var _edgeMenu = "<spring:message code='menu.edgeMenu'/>";
var _nodeEdgeColorAction = "<spring:message code='menu.nodeEdgeColorAction'/>";
var _nodeBGColorAction = "<spring:message code='menu.nodeBGColorAction'/>";
var _nodeTextColorAction = "<spring:message code='menu.nodeTextColorAction'/>";
var _increaseFontSizeAction = "<spring:message code='menu.increaseFontSizeAction'/>";
var _decreaseFontSizeAction = "<spring:message code='menu.decreaseFontSizeAction'/>";
var _cutAction = "<spring:message code='menu.cutAction'/>";
var _copyAction = "<spring:message code='menu.copyAction'/>";
var _pasteAction = "<spring:message code='menu.pasteAction'/>";
var _deleteAction = "<spring:message code='menu.deleteAction'/>";
var _insertTextOnBranchAction = "<spring:message code='menu.insertTextOnBranchAction'/>";
	
var _insertHyperAction = "<spring:message code='menu.insertHyperAction'/>";
var _imageProviderAction = "<spring:message code='menu.imageProviderAction'/>";
var _videoProviderAction = "<spring:message code='menu.videoProviderAction'/>";
var _insertWebPageAction = "<spring:message code='menu.insertWebPageAction'/>";
var _insertIFrameAction = "<spring:message code='menu.insertIFrameAction'/>";
var _fileProviderAction = "<spring:message code='menu.fileProviderAction'/>";
var _insertNoteAction = "<spring:message code='menu.insertNoteAction'/>";
var _insertLTIAction = "<spring:message code='menu.insertLTIAction'/>";
var _iotProvidersAction = "<spring:message code='menu.iotProvidersAction'/>";

var _changeMapBackround = "<spring:message code='menu.rollover.midnmap.mapbackgroundchange'/>";
var _alertBookmark = "<spring:message code='alert.bookmark'/>";

var _presenTheme1 = "<spring:message code='presentation.theme1'/>";
var _presenTheme2 = "<spring:message code='presentation.theme2'/>";
var _presenTheme3 = "<spring:message code='presentation.theme3'/>";
var _presenTheme4 = "<spring:message code='presentation.theme4'/>";
var _presenTheme5 = "<spring:message code='presentation.theme5'/>";
var _presenAlert = "<spring:message code='presentation.alert'/>";
var _presenSlide = "<spring:message code='presentation.slide'/>";
var _presenType = "<spring:message code='presentation.type'/>";
var _presenDynamic = "<spring:message code='presentation.dynamic'/>";
var _presenBox = "<spring:message code='presentation.box'/>";
var _presenAero = "<spring:message code='presentation.aero'/>";
var _presenLinear = "<spring:message code='presentation.linear'/>";
var _presenBasic = "<spring:message code='presentation.basic'/>";
var _presenZoom = "<spring:message code='presentation.zoom'/>";
var _presenStart = "<spring:message code='presentation.start'/>";
var _presenRow = "<spring:message code='presentation.row'/>";
var _presenTopic = "<spring:message code='presentation.topic'/>";
var _presenChild = "<spring:message code='presentation.child'/>";
var _presenRemove = "<spring:message code='presentation.remove'/>";
var _presenBackground = "<spring:message code='presentation.background'/>";

var _menuMouseClickAction = false;
var _scaleValue = 0.5;


var keypressEvent = function(e){
	if (e.which == 13 || e.keyCode == 13) {
        $("#insertNoteFrm #jino_input_note").val($("#insertNoteFrm #jino_input_note").val()+"\n");
        return false;
    }
}

</script>