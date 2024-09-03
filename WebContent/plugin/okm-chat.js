/**
 *
 * @author Hahm Myung Sun (hms1475@gmail.com)
 *
 * Copyright (c) 2011 JinoTech (http://www.jinotech.com)
 * Licensed under the LGPL v3.0 license (http://www.gnu.org/licenses/lgpl.html).
 */

OKMChat = (function() {
  var $wnd = null;
  var userName = "";
  var guestID = "";

  function OKMChat(el, username) {
    $wnd = $("#" + el);
    userName = username;
    // createPanel();

    // $('#rightpanel').bind('resize', function() {
    // 	var topheight = parseInt($(this).children()[0].style.height);
    // 	if(!topheight) topheight = 0;

    // 	//$(this).find('#chatlog').height($(this).height() - topheight - 100);
    // });

    // chatting 창 처음에 보여줄지 여부
    //		if(document.body.clientWidth<1024){
    //			document.getElementById("openpanel").style.display = "";
    //			document.getElementById("rightpanel").style.display = "none";
    //		}else{
    //			document.getElementById("openpanel").style.display = "none";
    //			document.getElementById("rightpanel").style.display = "";
    //		}

    // OKMChat.getMessages(1);
    $("#jino_chat_frm_send").submit(function(event) {
      event.preventDefault();
      OKMChat.sendMessage();
    });

    $("#jino_chat_input").focus(function() {
		jMap.fireActionListener(ACTIONS.ACTION_CHAT_ON_TYPING);
    });

    $("#jino_chat_input").blur(function() {
		jMap.fireActionListener(ACTIONS.ACTION_CHAT_OFF_TYPING);
    });

    if (jMap.cfg.userId == "0") {
      guestID = $.cookie("chatGuestID") || parseInt(Math.random() * 2000000000);
      $.cookie("chatGuestID", guestID, { path: "/" });
      guestID = " #" + guestID;
    }
  }

  // var createPanel = function() {
  // 	var $panel = $('<div id ="titlepanel">' +
  // 								'<span id="people" width="49%">'+i18n.msgStore["chatting"]+'</span>	'+'<input type="hidden" id="username" value="'+userName+'"/>'+
  // 							'</div>	' +
  // 							'<div id ="chatpanel">' +
  // 								'<div id="chatlog"></div>' +
  // 								'<div class="input_text_bar">' +
  // 									'<input class="input_text_bar_input" type="text" onkeypress="OKMChat.onReturn(event, OKMChat.sendMessage)" />' +
  // 									'<input type="button" class="send_btn input_text_bar_send"  value="'+i18n.msgStore["send"]+'" onclick="OKMChat.sendMessage()"/>' +
  // 								'</div>' +
  // 							'</div>');

  // 	$wnd.append($panel);
  // }

  // OKMChat.logOut = function(){
  // 	JavascriptChat.logout( {
  // 	  callback:function(data) {},
  // 	  async:false
  // 	});
  // }

  // OKMChat.updateUserInfo = function(username, userList){
  // 	var names;
  // 	for (var data in userList) {

  // 	}
  // }

  // OKMChat.onReturn = function(event, action) {
  // 	if (!event) event = window.event;
  // 	if (event && event.keyCode && event.keyCode == 13) action();
  // };

  OKMChat.sendMessage = function() {
    // if(dwr.util.getValue("text")){
    // 	var username = dwr.util.getValue("username");
    // 	var text = dwr.util.getValue("text");
    // 	dwr.util.setValue("text", "");

    // 	JavascriptChat.sendMessage(username, text,mapId, jMap.cfg.userId );
    // 	//JavascriptChat.sendMessage(username, text );
    // }

    var input = $("#jino_chat_input");
    if (input && input.val() !== "") {
      var input_message = input.val();
      $.ajax({
        type: "post",
        url: jMap.cfg.contextPath + "/chat/sendMessages.do",
        dataType: "json",
        data: {
          roomnumber: jMap.cfg.mapId,
          message: input_message,
          username: userName + guestID
        },
        success: function(data2) {
          if (data2.status == "success") {
            OKMChat.receiveMessages(userName + guestID, input_message, true, data2.timecreated);
            jMap.fireActionListener(ACTIONS.ACTION_CHAT_SEND_MESSAGE, userName + guestID, input_message, jMap.cfg.mapId, jMap.cfg.userId, data2.timecreated);
            input.val("");
          } else {
            alert("This message cannot be sent.");
          }
        }
      });
    }
  };
  var lastIdx = 0;
  var chatAmount = 10;

  OKMChat.getMessages = function(isFirst) {
    $("#chatlog").addClass("skeleton-loading");
    $.ajax({
      type: "post",
      async: true,
      url: jMap.cfg.contextPath + "/chat/getMessages.do",
      dataType: "json",
      data: {
        roomnumber: mapId,
        lastIdx: lastIdx,
        amount: chatAmount
      },
      beforeSend: function() {},
      success: function(data2) {
        $("#chatlog")
          .find("span[chatuserload]")
          .remove();
        $("#chatlog")
          .find(".chatloadmore")
          .remove();
        var oldText = "";
        var chatlog = $("#chatlog").html();
        var currentUser = "";
        $.each(data2.message, function(i, v) {
          var _isMe = jMap.cfg.userId == this.userid;
          if (jMap.cfg.userId == "0") {
            _isMe = this.username.indexOf(guestID) != -1;
          }

          if (_isMe) {
            if (currentUser == this.username) {
              var _msg = "		<span chatuserload></span>" + '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-blue text-white">' + this.message + "</div>" + "		</div>";
              oldText = oldText.replace("<span chatuserload></span>", _msg);
            } else {
              oldText = oldText.replace("<span chatuserload></span>", "");
              oldText = '<div class="chat-message d-flex align-items-end justify-content-end text-right">' + '	<div class="message-wrap message-r w-100" chatuser="' + this.username + '">' + "		<span chatuserload></span>" + '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-blue text-white">' + this.message + "</div>" + "		</div>" + (chatlog == "" && i == 0 ? "<span chatuseradd></span>" : "") + "	</div>" + "</div>" + oldText;
            }
          } else {
            if (currentUser == this.username) {
              var _msg = "		<span chatuserload></span>" + '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-gray-200">' + this.message + "</div>" + "		</div>";
              oldText = oldText.replace("<span chatuserload></span>", _msg);
            } else {
              oldText = oldText.replace("<span chatuserload></span>", "");
              oldText = '<div class="chat-message d-flex align-items-end justify-content-end">' + '	<div class="flex-shrink-1 px-1">' + '		<img src="' + jMap.cfg.contextPath + '/theme/dist/images/icons/user-2.svg" width="34px">' + " 	</div>" + '	<div class="message-wrap message-l w-100" chatuser="' + this.username + '">' + "		<span chatuserload></span>" + '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-gray-200">' + this.message + "</div>" + "		</div>" + (chatlog == "" && i == 0 ? "<span chatuseradd></span>" : "") + "	</div>" + "</div>" + '<small class="text-muted">' + this.username + "</small>" + oldText;
            }
          }
          currentUser = this.username;
          lastIdx = this.id;
        });

        var _moreBtn = '<button type="button" class="chatloadmore btn btn-gray-200 btn-block btn-sm my-2" onclick="OKMChat.getMessages()">&#8682;</button>';
        if (data2.message.length) {
          oldText = _moreBtn + oldText;
        }

        $("#chatlog").html(oldText + chatlog);
        if (isFirst == 1) {
          $("#chatlog").scrollTop($("#chatlog")[0].scrollHeight);
        }
      },
      error: function(data2, status, err) {
        console.log("error forward : " + data2 + " " + status + " " + err);
        alert("서버와의 통신이 실패했습니다.");
      },
      complete: function() {
        $("#chatlog").removeClass("skeleton-loading");
      }
    });
  };

  OKMChat.onGetMessages = function() {
    if (http.readyState == 4) {
      if (http.status == 200) {
        var jsonData = JSON.parse(http.responseText);
        if (jsonData.status == "ok") {
          console.log(jsonData.message);
        } else {
          alert("error3 : " + jsonData.message);
        }
      } else {
      }
    }
  };

  OKMChat.receiveMessages = function(receive_username, receive_message, receive_isMe, timecreated) {
    if ($("#rightPanelFolding").hasClass("closed")) {
      var _chatUnread = parseInt($("#chatUnread").html()) || 0;
      $("#chatUnread")
        .html(_chatUnread + 1)
        .removeClass("d-none");
    } else {
      $("#chatUnread")
        .html("")
        .addClass("d-none");
    }

    if(!$('#rightPanelFolding').hasClass('loaded')) return;

    var chatlog = $("#chatlog").html();
    if (receive_isMe) {
      if (
        $("span[chatuseradd]")
          .parent()
          .attr("chatuser") == receive_username
      ) {
        var _msg = '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-blue text-white">' + receive_message + "</div>" + "		</div>" + "<span chatuseradd></span>";
        $("span[chatuseradd]").replaceWith(_msg);
      } else {
        $("span[chatuseradd]").remove();
        var _msg = '<div class="chat-message d-flex align-items-end justify-content-end text-right">' + '	<div class="message-wrap message-r w-100" chatuser="' + receive_username + '">' + (chatlog == "" ? "		<span chatuserload></span>" : "") + '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-blue text-white">' + receive_message + "</div>" + "		</div>" + "		<span chatuseradd></span>" + "	</div>" + "</div>";
        $("#chatlog").append(_msg);
      }
    } else {
      if (
        $("span[chatuseradd]")
          .parent()
          .attr("chatuser") == receive_username
      ) {
        var _msg = '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-gray-200">' + receive_message + "</div>" + "		</div>" + "<span chatuseradd></span>";
        $("span[chatuseradd]").replaceWith(_msg);
      } else {
        $("span[chatuseradd]").remove();
        var _msg = '<div class="chat-message d-flex align-items-end justify-content-end">' + '	<div class="flex-shrink-1 px-1">' + '		<img src="' + jMap.cfg.contextPath + '/theme/dist/images/icons/user-2.svg" width="34px">' + " 	</div>" + '	<div class="message-wrap message-l w-100" chatuser="' + receive_username + '">' + (chatlog == "" ? "		<span chatuserload></span>" : "") + '		<div class="my-1">' + '			<div class="message text-break px-3 py-2 d-inline-block bg-gray-200">' + receive_message + "</div>" + "		</div>" + "		<span chatuseradd></span>" + "	</div>" + "</div>" + '<small class="text-muted">' + receive_username + "</small>";
        $("#chatlog").append(_msg);
      }
    }

    $("#chatlog").scrollTop($("#chatlog")[0].scrollHeight);
  };

  return OKMChat;
})();
