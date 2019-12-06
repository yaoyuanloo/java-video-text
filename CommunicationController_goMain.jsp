<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String websock = request.getServerName()+":"+request.getServerPort()+path;
	String share = request.getServerName() + path;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="chrome=1" />
<meta content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" name="viewport">
<meta content=”initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width” name=”viewport” />
<title>视频</title>
<link href="<%=path %>/static/Content/JqueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/static/Content/JqueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/static/Content/themes/Default/style.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/static/Content/themes/Default/default.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/static/layui/css/layui.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/static/liveTVcss/detail.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/static/liveTVcss/style.css" rel="stylesheet" type="text/css" />
<link href="<%=path %>/static/liveTVcss/base.css" rel="stylesheet" type="text/css" />
<link href="https://vjs.zencdn.net/7.0.3/video-js.css" rel="stylesheet">
<link href="http://vjs.zencdn.net/6.7/video-js.min.css" rel="stylesheet">
<script src="http://vjs.zencdn.net/6.7/video.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/videojs-contrib-hls/5.14.1/videojs-contrib-hls.min.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=path %>/static/layui/layui.all.js"></script>
<script type="text/javascript"	src="<%=path %>/static/Content/JqueryEasyUI/jquery.min.js"></script>
<script type="text/javascript"	src="<%=path %>/static/Content/JqueryEasyUI/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path %>/static/Content/JqueryEasyUI/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=path %>/static/js/public.js"></script>
<script type="text/javascript" src="<%=path %>/static/js/DataChannel.js"></script>
<script type="text/javascript" src="<%=path %>/static/js/channel.js"></script>
<script type="text/javascript" src="<%=path %>/static/js/adapter2.js"></script>
<script type="text/javascript"  src="<%=path %>/static/js/sockjs.min.js"></script>

<style type="text/css">
a:link {
	color: #ffffff;
}

a:visited {
	color: #ffffff;
}

/* html, body { */
/* 	background-color: #000000; */
/* 	height: 100%; */
/* 	font-family: Verdana, Arial, Helvetica, sans-serif; */
/* } */

body {
	margin: 0;
	padding: 0;
}

#container {
	background-color: #000000;
	position: relative;
	min-height: 100%;
	width: 100%;
	margin: 0px auto;
	-webkit-perspective: 1000;
}

#card {
	-webkit-transition-property: rotation;
	-webkit-transition-duration: 2s;
	-webkit-transform-style: preserve-3d;
}

#local {
	position: absolute;
	width: 100%;
	-webkit-transform: scale(-1, 1);
	-webkit-backface-visibility: hidden;
}

#remote {
	position: absolute;
	width: 100%;
	-webkit-transform: rotateY(180deg);
	-webkit-backface-visibility: hidden;
}

#mini {
	position: absolute;
	height: 30%;
	width: 30%;
	bottom: -250px;
	right: 4px;
	-webkit-transform: scale(-1, 1);
/* 	-moz- */
/* 	-o- */
/* 	无 */
	opacity: 1.0;
}

#localVideo {
	opacity: 0;
	-webkit-transition-property: opacity;
	-webkit-transition-duration: 2s;
}

#remoteVideo {
	opacity: 0;
	-webkit-transition-property: opacity;
	-webkit-transition-duration: 2s;
}

#miniVideo {
	opacity: 0;
	-webkit-transition-property: opacity;
	-webkit-transition-duration: 2s;
}

#footer {
	spacing: 4px;
	position: absolute;
	bottom: 0;
	width: 100%;
	height: 28px;
	background-color: #3F3F3F;
	color: rgb(255, 255, 255);
	font-size: 13px;
	font-weight: bold;
	line-height: 28px;
	text-align: center;
}

.shutdown {
	margin-left: 30%;
	margin-top: -25%;
	spacing: 4px;
	position: absolute;
	bottom: 28;
	width: 55px;
	height: 60px;
	float:left
}

.refresh {
	margin-left: 50%;
	margin-top: -25%;
	spacing: 4px;
	position: absolute;
	bottom: 28;
	width: 55px;
	height: 60px;
}

#hangup {
	font-size: 13px;
	font-weight: bold;
	color: #FFFFFF;
	width: 128px;
	height: 24px;
	background-color: #808080;
	border-style: solid;
	border-color: #FFFFFF;
	margin: 2px;
}

#logo {
	display: block;
	top: 4;
	right: 4;
	position: absolute;
	float: right;
	opacity: 0.5;
}

.vid-wrapper{
    width:100%;
    position:relative;
    padding-bottom:75%; 
    height: 0;
}
.vid-wrapper video{
    position: absolute;
    top:0;
    left: 0;
    width: 100%;
    height: 100%
}
</style>

<script type="text/javascript">
	var  pcVideo = {
		    width: { min: 240, ideal: 480, max: 1080},
		    height: { min: 320, ideal: 640, max: 1920  }
		  };
	var  padVideo = {
		    width: { min: 1024, ideal: 1280, max: 2560 },
		    height: { min: 776, ideal: 720, max: 1440 }
		  };
	var  pVideo;
	$(function() {
		document.onkeydown = function(e) {
			var ev = document.all ? window.event : e;
			if (ev.keyCode == 13) {
				sendMsg();
			}
		}
		browserRedirect();//适配手机端和PC端浏览器
		if(${isRoomFull}){
			alert("该房间当前正在视频中，请稍候....")
		}
		setTimeout(function() { 
			isConnectVideo();
		}
        ,40000)
	});
	
	function isConnectVideo(){
		var room = '${room}';
		var postData = {
			"room":room
		}
		$.post("isConnectVideo.do",postData,function(data){
			if(data.flagVideo&&data.flag){
				
			}else{
				alert(data.msg);
				Android.finishActivity();
			}
			
		});
	}
	
	function browserRedirect() {
	    var sUserAgent = navigator.userAgent.toLowerCase();
	    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
	    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
	    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
	    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
	    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
	    var bIsAndroid = sUserAgent.match(/android/i) == "android";
	    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
	    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
	    
	    if (bIsIphoneOs || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM ){//手机
	    	pVideo = padVideo;
	    	return true;
	    } else if(bIsIpad || bIsMidp ){ //ipad
	    	pVideo = padVideo;
	    	return true;
	    }else{//电脑
	    	pVideo = pcVideo;
// 	    	$("#container").css("width","60%");
	    	return false;
	    }
	}
	
	
	function setBox(){
		$("#container").css("height",$(window).height());
    	$("#container").css("width",$(window).width());
    	
//     	$("#local").css("height",$(window).height());
//     	$("#local").css("width",$(window).width());
    	
//     	$("#remote").css("height",$(window).height());
//     	$("#remote").css("width",$(window).width());
    	
    	$("#localVideo").css("height",$(window).height());
    	$("#localVideo").css("width",$(window).width());
    	
    	$("#remoteVideo").css("height",$(window).height());
    	$("#remoteVideo").css("width",$(window).width());
    	
    	$("#miniVideo").css("height",$(window).height()*0.2);
    	$("#miniVideo").css("width",$(window).width()*0.2);
	}



	function sendMsg() {
		var liveTerm = $("#liveTerm").val();
		var liveId = $("#liveId").val();
		var msgText = $.trim($("#msgText").val());
		var wxName = $("#wxName").val();
		var ImgUrl = $("#ImgUrl").val();
		if (msgText == '' || msgText == null) return;
		var postData = {
			"liveTerm" : liveTerm,
			"liveId" : liveId,
			"msgText" : msgText,
			"websockFlag" : 3
		};
		$.post("sendMsg.do", postData, function(date) {
			if (date.flag) {

			} else {
				layer.msg("网络超时或发送失败!");
			}
		})
	}
</script>

<script type="text/javascript">
		//支持多种浏览器
// 		navigator.getUserMedia = navigator.getUserMedia || navigator.mozGetUserMedia || navigator.webkitGetUserMedia;
// 		window.RTCPeerConnection = window.RTCPeerConnection || window.mozRTCPeerConnection || window.webkitRTCPeerConnection;
// 		window.RTCIceCandidate = window.RTCIceCandidate || window.mozRTCIceCandidate || window.webkitRTCIceCandidate;
// 		window.RTCSessionDescription = window.RTCSessionDescription || window.mozRTCSessionDescription || window.webkitRTCSessionDescription;
// 		window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition || window.mozSpeechRecognition || window.msSpeechRecognition || window.oSpeechRecognition;
		
		var localVideo;
		var miniVideo;
		var remoteVideo;
		var localStream;
		var remoteStream;
		var channel;
		var channelReady = false;
		var pc;
		var socket;
		var initiator = ${initiator};//发送数据流
		var started = false;
		var isRTCPeerConnection = true;//客户端之间传输音视频.
		var mediaConstraints = {
			'has_audio' : true,
			'has_video' : {width: {exact: 1920}, height: {exact: 1080}}
		};
		var isVideoMuted = false;
		var isAudioMuted = false;

		setTimeout(initialize, 1);
		
		function initialize() {
			console.log("Initializing; room=${room}.");
			card = document.getElementById("card");
			localVideo = document.getElementById("localVideo");
			miniVideo = document.getElementById("miniVideo");
			remoteVideo = document.getElementById("remoteVideo");
			resetStatus();
			openChannel();
			getUserMedia();
			setBox();
		}
		
		//系统的方法   获取音视频.
		function getUserMedia() {
			try {
				navigator.getUserMedia({
					'audio' : true,
					'video' :  pVideo
				}, onUserMediaSuccess, onUserMediaError);
				console.log("Requested access to local media with new syntax.");
			} catch (e) {
				try {
					navigator.getUserMedia("video,audio", onUserMediaSuccess, onUserMediaError);
					console .log("Requested access to local media with old syntax.");
				} catch (e) {
					alert(e.message);
					console.log(e);
				}
			}
		}
		
		
		//加载本地 视频
		function onUserMediaSuccess(stream) {
			console.log("User has granted access to local media.");
			var url = URL.createObjectURL(stream);
			localVideo.style.opacity = 1;
			localVideo.src = url;
			localStream = stream;
			if (initiator)
				maybeStart();
		}
		
		function maybeStart() {
			if (!started && localStream && channelReady) {
				setStatus("等待对方接听...");
				console.log("Creating PeerConnection.");
				createPeerConnection();
				console.log("Adding local stream.");
				pc.addStream(localStream);
				started = true;
				if (initiator)
					doCall();
			}
		}

		//发送offer
		function doCall() {
			console.log("Sending offer to peer.");
			if (isRTCPeerConnection) {
				pc.createOffer(setLocalAndSendMessage,  function (error) {
                    console.log('Failure callback: ' + error);
                });
			} else {
				var offer = pc.createOffer(mediaConstraints);
				pc.setLocalDescription(pc.SDP_OFFER, offer);
				sendMessage({
					type : 'offer',
					sdp : offer.toSdp()
				});
				pc.startIce();
			}
		}

		//设置本地sdp，完成设置后onicecandidate事件会调用。
		function setLocalAndSendMessage(sessionDescription) {
			pc.setLocalDescription(sessionDescription);
			sendMessage(sessionDescription);//将offer发送给对方
		}

		//发送消息
		function sendMessage(message) {
			var msgString = JSON.stringify(message);
			console.log('${user}发出信息 : ' + msgString);
			url = 'message?r=${room}&u=${user}';
			var xhr = new XMLHttpRequest();
			xhr.open('POST', url, false);
			xhr.send(msgString);
		}

		//协调通信
		function openChannel() {
			console.log("Opening channel.");
			var websockurl = "wss://<%=websock %>/WebSocket/WebSocket.do?type=${user}";
			socket = new WebSocket(websockurl);
			socket.onopen = onChannelOpened;
			socket.onmessage = onChannelMessage;
			socket.onclose = onChannelClosed;
		}

		function resetStatus() {
// 			console.log("让别人加入视频聊天:");
// 			console.log(  "${roomLink}"+"&u=text"  );
// 			alert("让别人加入视频聊天:"+"${roomLink}"+"&u=text" );
			if (!initiator) {
// 				setStatus("让别人加入视频聊天: <a href=\"${roomLink}&u=text\">${roomLink}&u=text</a>");
			} else {
// 				setStatus("初始化...");
			}
			setStatus("等待对方接听...");
		}

		
		//创建 PeerConnection
		function createPeerConnection() {
			var pc_config = {
				"iceServers" : [{'url': 'stun:stun.services.mozilla.com'}, 
				                {'url': 'stun:stun.l.google.com:19302'}]
			};
			try {
				pc = new RTCPeerConnection(pc_config);
				pc.onicecandidate = onIceCandidate;
				console.log("Created webkitRTCPeerConnnection with config \"" + JSON.stringify(pc_config) + "\".");
			} catch (e) {
				try {
					var stun_server = "";
					if (pc_config.iceServers.length !== 0) {
						stun_server = pc_config.iceServers[0].url.replace('stun:', 'STUN ');
					}
					pc = new RTCPeerConnection(stun_server, onIceCandidate);
					isRTCPeerConnection = false;
					console.log("Created webkitPeerConnnection00 with config \"" + stun_server + "\".");
				} catch (e) {
					alert("Failed to create PeerConnection, exception: " + e.message);
					return;
				}
			}

			pc.onconnecting = onSessionConnecting;
			pc.onopen = onSessionOpened;
			pc.onaddstream = onRemoteStreamAdded;
			pc.onremovestream = onRemoteStreamRemoved;
		}

		function setStatus(state) {
			footer.innerHTML = state;
		}

		function doAnswer() {
			console.log("Sending answer to peer.");
			if (isRTCPeerConnection) {
				pc.createAnswer(setLocalAndSendMessage, function (error) {
                    console.log('Failure callback: ' + error);
                });
			} else {
				var offer = pc.remoteDescription;
				var answer = pc.createAnswer(offer.toSdp(), mediaConstraints);
				pc.setLocalDescription(pc.SDP_ANSWER, answer);
				sendMessage({
					type : 'answer',
					sdp : answer.toSdp()
				});
				pc.startIce();
			}
		}

		function processSignalingMessage00(message) {
			var msg = JSON.parse(message);

			// if (msg.type === 'offer') should not happen here.
			if (msg.type === 'answer' && started) {
				pc.setRemoteDescription(pc.SDP_ANSWER, new SessionDescription(msg.sdp));
			} else if (msg.type === 'candidate' && started) {
				var candidate = new IceCandidate(msg.label, msg.candidate);
				pc.processIceMessage(candidate);
			} else if (msg.type === 'bye' && started) {
				onRemoteHangup();
			}
		}

		var channelOpenTime;
		var channelCloseTime;

		//websock onpen
		function onChannelOpened() {
			channelOpenTime = new Date();
			console.log("Channel opened.Open time is : " + channelOpenTime.toLocaleString());
			channelReady = true;
			if (initiator)
				maybeStart();
		}
		
		//websock onMessage
		function onChannelMessage(message) {
			console.log('收到信息 : ' + message.data);
			console.log('isRTCPeerConnection : ' + isRTCPeerConnection);
			if (isRTCPeerConnection)
				processSignalingMessage(message.data);//建立视频连接
			else
				processSignalingMessage00(message.data);
		}
		
		function onChannelError() {
			console.log('Channel error.');
		}
		//websock onClosed
		function onChannelClosed() {
			if(!channelOpenTime){
				channelOpenTime = new Date();
			}
			channelCloseTime = new Date();
			console.log("Channel closed.Close time is " + channelOpenTime.toLocaleString()
							+ " ,Keep time : " + ((channelCloseTime.getTime() - channelOpenTime.getTime()) / 1000 + "s"));
			openChannel();
		}
		
		
 		//当offer提供端接收到来自对方的answer时: pc.setRemoteDescription(new RTCSessionDescription(message));
 		//当offer端接收到来自对方的candidate时，pc.addIceCandidate(candidate);//将来自对方的candidate设置给本地
		function processSignalingMessage(message) {
			var temp = eval('(' + (message) + ')');
			var msg =  JSON.parse(temp.msg);
			console.log(    msg);
			if (msg.type === 'offer') {
				if (!initiator && !started)
					maybeStart();
				if (isRTCPeerConnection)
					pc.setRemoteDescription(new RTCSessionDescription(msg));
				else
					pc.setRemoteDescription(pc.SDP_OFFER, new SessionDescription(msg.sdp));

				doAnswer();
			} else if (msg.type === 'answer' && started) {
				pc.setRemoteDescription(new RTCSessionDescription(msg));
			} else if (msg.type === 'candidate' && started) {
				var candidate = new RTCIceCandidate({
					sdpMLineIndex : msg.label,
					candidate : msg.candidate
				});
				pc.addIceCandidate(candidate);
			} else if (msg.type === 'bye' && started) {
				onRemoteHangup();
			}
		}

		function onUserMediaError(error) {
			alert("调用摄像头错误："+  error  );
		}

		function onIceCandidate(event) {
			if (event.candidate) {
				sendMessage({
					type : 'candidate',
					label : event.candidate.sdpMLineIndex,
					id : event.candidate.sdpMid,
					candidate : event.candidate.candidate
				});
			} else {
				console.log("End of candidates.");
			}
		}

		function onIceCandidate00(candidate, moreToFollow) {
			if (candidate) {
				sendMessage({
					type : 'candidate',
					label : candidate.label,
					candidate : candidate.toSdp()
				});
			}

			if (!moreToFollow) {
				console.log("End of candidates.");
			}
		}

		function onSessionConnecting(message) {
			console.log("Session connecting.");
		}
		function onSessionOpened(message) {
			console.log("Session opened.");
		}

		
		//加载对方视频和自己的视频
		function onRemoteStreamAdded(event) {
			console.log("Remote stream added.");
			var url = URL.createObjectURL(event.stream);
			miniVideo.src = localVideo.src;
			remoteVideo.src = url;
			remoteStream = event.stream;
			waitForRemoteVideo();
			setBox();
		}
		function onRemoteStreamRemoved(event) {
			console.log("Remote stream removed.");
		}

		//挂断视频
		function onHangup() {
			console.log("Hanging up.");
			transitionToDone();
			stop();
			socket.close();
// 			$("#shutdownDiv").hide();

		}

		function onRemoteHangup() {
			console.log('Session terminated.');
			transitionToWaiting();
			stop();
			initiator = 0;
		}

		function stop() {
			started = false;
			isRTCPeerConnection = true;
			isAudioMuted = false;
			isVideoMuted = false;
			pc.close();
			pc = null;
		}

		function waitForRemoteVideo() {
			if ( remoteVideo.currentTime > 0) {
				transitionToActive();
			} else {
				setTimeout(waitForRemoteVideo, 100);
			}
			setBox();
		}
		function transitionToActive() {
			remoteVideo.style.opacity = 1;
			card.style.webkitTransform = "rotateY(180deg)";
			setTimeout(function() {
				localVideo.src = "";
			}, 500);
			setTimeout(function() {
				miniVideo.style.opacity = 1;
			}, 1000);
// 			setStatus("<input type=\"button\" id=\"hangup\" value=\"Hang up\" onclick=\"onHangup()\" />");
			setStatus("连接成功.");
// 			$("#shutdownDiv").show();
// 			$("#refreshDiv").show();
			setBox();
		}
		function transitionToWaiting() {
			card.style.webkitTransform = "rotateY(0deg)";
			setTimeout(function() {
				localVideo.src = miniVideo.src;
				miniVideo.src = "";
				remoteVideo.src = ""
			}, 500);
			miniVideo.style.opacity = 0;
			remoteVideo.style.opacity = 0;
			resetStatus();
		}
		function transitionToDone() {
			localVideo.style.opacity = 0;
			remoteVideo.style.opacity = 0;
			miniVideo.style.opacity = 0;
// 			setStatus("You have left the call. <a href=\"{{ room_link }}\">Click here</a> to rejoin.");
		}
		function enterFullScreen() {
			container.webkitRequestFullScreen();
		}

		function toggleVideoMute() {
			if (localStream.videoTracks.length === 0) {
				console.log("No local video available.");
				return;
			}

			if (isVideoMuted) {
				for (i = 0; i < localStream.videoTracks.length; i++) {
					localStream.videoTracks[i].enabled = true;
				}
				console.log("Video unmuted.");
			} else {
				for (i = 0; i < localStream.videoTracks.length; i++) {
					localStream.videoTracks[i].enabled = false;
				}
				console.log("Video muted.");
			}

			isVideoMuted = !isVideoMuted;
		}

		function toggleAudioMute() {
			if (localStream.audioTracks.length === 0) {
				console.log("No local audio available.");
				return;
			}

			if (isAudioMuted) {
				for (i = 0; i < localStream.audioTracks.length; i++) {
					localStream.audioTracks[i].enabled = true;
				}
				console.log("Audio unmuted.");
			} else {
				for (i = 0; i < localStream.audioTracks.length; i++) {
					localStream.audioTracks[i].enabled = false;
				}
				console.log("Audio muted.");
			}
			isAudioMuted = !isAudioMuted;
		}
		
		function shutdown(obj) {
			transitionToDone();
// 			stop();
			socket.close();
			sendMessage({
				type : 'bye',
				r : '${room}',
				u : '${user}'
			});
// 			setTimeout(function() {
				var  flag = browserRedirect()?true:false;
				if(flag){
					if(obj=='1'){
						Android.finishByBack();
					}else{
						Android.finishActivity();
					}
				}else{
			        window.opener=null;
			        window.open('','_self');
			        window.close();
				}
// 			 } ,500)
				window.location.reload();
				
			
		}


		// Send BYE on refreshing(or leaving) a demo page
		// to ensure the room is cleaned for next session.
		window.onbeforeunload = function() {
			sendMessage({
				type : 'bye',
				r : '${room}',
				u : '${user}'
			});
		}
		
		

		// Ctrl-D: toggle audio mute; Ctrl-E: toggle video mute.
		// On Mac, Command key is instead of Ctrl.
		// Return false to screen out original Chrome shortcuts.
		document.onkeydown = function() {
			if (navigator.appVersion.indexOf("Mac") != -1) {
				if (event.metaKey && event.keyCode === 68) {
					toggleAudioMute();
					return false;
				}
				if (event.metaKey && event.keyCode === 69) {
					toggleVideoMute();
					return false;
				}
			} else {
				if (event.ctrlKey && event.keyCode === 68) {
					toggleAudioMute();
					return false;
				}
				if (event.ctrlKey && event.keyCode === 69) {
					toggleVideoMute();
					return false;
				}
			}
		}
		
	</script>
<body>

<!-- 	<div class="ask-everybody" style="width: 30%"> -->
<!-- 		<ul class="ask-everybody-list" id="msgContext"> -->
<!-- 		</ul> -->
<!-- 	</div> -->
	<div id="container" ondblclick="enterFullScreen()">
		<div id="card">
			<div id="local" class="vid-wrapper">
				<video id="localVideo" style="object-fit:fill" poster="" autoplay="autoplay" x5-playsinline="true" x5-video-player-type="" playsinline="" webkit-playsinline=""  class="video-js vjs-default-skin vjs-big-play-centered" ></video>
			</div>
			<div id="remote" class="vid-wrapper">
				<video id="remoteVideo" style=" object-fit:fill" poster="" autoplay="autoplay" x5-playsinline="true" x5-video-player-type="" playsinline="" webkit-playsinline=""  class="video-js vjs-default-skin vjs-big-play-centered" ></video>
				<div id="mini">
					<video id="miniVideo" mute="true" style="object-fit:fill" poster="" autoplay="autoplay"  x5-playsinline="true" x5-video-player-type="" playsinline="" webkit-playsinline=""  class="video-js vjs-default-skin vjs-big-play-centered" ></video>
				</div>
			</div>
		</div>
	</div>
	<div class="shutdown" id="shutdownDiv">
		<img  height="200px" id="isImg" src="<%=path %>/static/images/shutdown.png" onclick="shutdown();" />
	</div>
	<div class="refresh" id="refreshDiv">
		<img  height="200px" id="isImg" src="<%=path %>/static/images/refresh.png" onclick="javascript:window.location.reload();" />
	</div>
	<div id="footer" class="footer-everybody" style="position:fixed;bottom:0;"></div>

<!-- 	<div class="footer-everybody"> -->
<!-- 		<div class="footer-ipt-box"> -->
<!-- 			<div class="footer-ipt-box-left"> -->
<!-- 				<input type="text" class="ipt" id="msgText"> -->
<!-- 			</div> -->
<!-- 			<div class="footer-ipt-box-right"> -->
<!-- 				<button class="footer-btn" onclick="sendMsg()">发送</button> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
</body>
</html>
