// Android에서 백키 누를 경우 웹으로 전달됨
function backRouter() {
    // TODO: 화면 상태에 따라 페이지 전환을 하거나 닫기 요청을 진행
    // 아래 코드는 닫기 요청을 진행하는 부분
    nativeBridge.screenClose();
}

//네이티브 브릿지 사용 함수
function sendNativeBridge(cmd, data, callback) {
	 if (cmd) {
		 if(!data) {
	         data = null;
	     }
	     if(!callback) {
	         callback = null;
	     }
	     if (navigator.userAgent.search('os:android') != -1) {
	         Android.nativeBridge(cmd, data, callback)
	     } else if (navigator.userAgent.search('os:ios') != -1) {
	         webkit.messageHandlers.nativeBridge.postMessage({
	             cmd: cmd,
	             data: data,
	             callback: callback
	         });
	     }
	 }
}

// 네이티브 앱 사용 유틸
const AppUtil = {
    // 접속 OS 정보 확인
	// return : android
    getNativeOS: function () {
        var appOS = "";
        if (navigator.userAgent.search(",os:") != -1) {
            appOS = navigator.userAgent.substring(
                navigator.userAgent.indexOf(",os:") + ",os:".length
            );
            appOS = appOS.substring(0, appOS.indexOf(","));
        }

        return appOS;
    },
    
    // only web return
    getWebDeviceIofo: function () {
        var webDevice = "";
        var mobileArr = new Array("iPhone", "iPod", "BlackBerry", "Android", "Windows CE", "LG", "MOT", "SAMSUNG", "SonyEricsson");
        
        for(var txt in mobileArr){
            if(navigator.userAgent.match(mobileArr[txt]) != null){
            	webDevice = mobileArr[txt];
            	break;
            }else{            	        
            	break;
            }
        }

        return webDevice;
    },
    
    // return : true or false
    getBrowserIsIE: function () {
        var agent = navigator.userAgent.toLowerCase();
        var isIE = false;
        
        if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
        	isIE = true;
        }else{
        	isIE = false;
        }
        
        return isIE;
    },
    
    // return : 4.4
    getAndroidVersion: function () {
    	var ua = navigator.userAgent;
    	var androidversion;
    	if( ua.indexOf("Android") >= 0 ){
    	  androidversion = parseFloat(ua.slice(ua.indexOf("Android")+8)); 
    	}

        return androidversion;
    },
    
    getAndVer: function() {
        var andver = "";
        if (navigator.userAgent.search(",andver:") != -1) {
            andver = navigator.userAgent.substring(
                navigator.userAgent.indexOf(",andver:") + ",andver:".length
            );
            andver = andver.substring(0, andver.indexOf(","));
        }
        return andver;
    }
};

// 네이티브 브릿지 모음
const nativeBridge = {
    // 화면 닫기 처리
	screenClose: function () {
    //screenClose: () => {
        sendNativeBridge('screenClose');
    },
    
    //안드로이드 파일선택
	fileSelect: function(acceptType, callback) {
	    var os = AppUtil.getNativeOS().toLowerCase();
	    if (os == 'android' && AppUtil.getAndVer() == '19') {
	        var sendData = {
	            acceptType: acceptType
	        };
	        sendNativeBridge('popFileSelect', JSON.stringify(sendData), callback);
	    }
	},
	
	//안드로이드 파일업로드
	fileUpload: function(fileKey, confirm, mapid, nodeId, callback, FILEUPLOAD_API_URL) {
	    var os = AppUtil.getNativeOS().toLowerCase();
	    if (os == 'android' && AppUtil.getAndVer() == '19') {
	        var sendData = {
	            fileKey: fileKey,
	            url: FILEUPLOAD_API_URL,
	            confirm: confirm,
	            mapid: mapid,
	            nodeId: nodeId
	        };
	        console.log(sendData);
	        //alert(JSON.stringify(sendData));
	        sendNativeBridge('popFileUpload', JSON.stringify(sendData), callback);
	    }
	}
};

$(document).ready(function() {
	// 앱인 경우 닫기 표시.	
    if(AppUtil.getNativeOS() != ""){
		var html = "<img id='app_close_button' src='/pop/images/wedorang/app_close.png' alt=''>";
        $("header#okm_header h1").prepend(html);
        
        $('img#app_close_button').css('cursor','pointer');
        $("img#app_close_button").click(function() {
        	nativeBridge.screenClose();
        });
	}
});
