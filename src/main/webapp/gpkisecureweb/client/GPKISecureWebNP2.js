document.writeln('<form name=gpkiForm METHOD=POST>');
document.writeln('      <input name=encryptedData type=hidden>');
document.writeln('      <input name=pwCheckCode type=hidden>');
document.writeln('      <input name=userDN type=hidden>');
document.writeln('      <input name=signedData type=hidden>');
document.writeln('</form>');
var GPKISecureWebUi = {};
var GPKISecureWeb = {};
var GPKIMessage = {};
var vidCheck = 0;
var installCheckCount = 0;
var downCheckCount = 0;
GPKISecureWeb.DownloadCount = 10;			//다운로드버튼 횟수 제한
GPKISecureWeb.AjaxLocal = false;
GPKISecureWeb.initFlag; 					// 0 : CS 실행중  , 그 밖의 코드 : CS 실행되지 않음
GPKISecureWeb.installCheckFlag = "";
GPKISecureWeb.InstallCheckCount = 10;		
GPKISecureWeb.isInstall = "download"; 		//설치페이지 사용 여부  true: 사용 , false : 미사용 , download : 바로 다운로드
GPKISecureWeb.DownloadWinFileName = "GPKISecureWebSetup"+".exe";
GPKISecureWeb.InstallPageURL = location.protocol +'//'+ location.host+ "/gpkisecureweb/install.html";
GPKISecureWeb.popupCallback = "";
GPKISecureWeb.closeCallback = "";
GPKISecureWeb.successCallback = "";
GPKISecureWeb.setupCheckCallback = "";
GPKISecureWeb.runningCheckCallback = "";
GPKISecureWeb.failedCallback = "";
GPKISecureWeb.DownloadURL = location.protocol +'//'+ location.host+ "/gpkisecureweb/client/setup/";
GPKISecureWeb.DownloadWinFileName ="GPKISecureWebSetup"+".exe";
GPKISecureWeb.UrlSchemeServerURL = location.protocol +'//'+ location.host+ "/gpkisecureweb/client/";
var isEmbedded = false;
var sessionid="";
var returnIndexPage = '/gpkisecureweb/index.html';
GPKISecureWebUi.dialogWidth = 480;
//GPKISecureWebUi.dialogButton = 80;
GPKISecureWebUi.installCheckMessage = "GPKISecureWeb 설치를 확인 중 입니다.";
GPKISecureWebUi.popupCheckMessage = "팝업이 차단된 경우 정상적으로 동작하지 않습니다.\n 팝업을 허용해 주세요";
GPKISecureWebUi.setupCertFailed = "프로그램이 정상적으로 설치되어 있지 않습니다.\n 브라우저 재구동후 다시 설치하여 주세요";
GPKISecureWebUi.downloadCheckMessage ="다운로드가 되지 않는 경우 '다운로드' 버튼을 눌러주세요";
GPKISecureWebUi.setupConfirmMessage = "GPKISecureWeb 설치 확인에 실패하였습니다<br/>GPKISecureWeb 이 설치되어 있지 않은 경우에는 <br/>'설치' 버튼을 눌러주세요";//로그인을위해 보안프로그램을 설치해야합니다 설치하시겠습니까
GPKISecureWebUi.setupConfirmMessageMAC = "GPKISecureWeb 설치 확인에 실패하였습니다.<br/>보안프로그램이 설치되어 있지 않은 경우에는 '설치' 버튼을<br/> 눌러주세요";
GPKISecureWebUi.upgradeConfirmMessage = "설치된 GPKISecureWeb이 최신버전이 아닙니다.<br/>최신버전을 다운로드하여 설치하세요";
GPKISecureWebUi.downloadPopMessge = "OS에 맞는 GPKISecureWeb을 설치하세요";
GPKISecureWebUi.setupMessage = "설치";
GPKISecureWebUi.startMessage = "실행";
GPKISecureWebUi.cancelMessage = "취소";
GPKISecureWebUi.restartDownLoadMessage = "다운로드";

var GPKIClientJS = new GPKISecureWebJS();

/*********************************************************************/
//					GPKISubmit(form)						 		 //
/*********************************************************************/
function GPKISubmit(form){
	return GPKISecureWebUi.GPKISubmit(form);
}

/*********************************************************************/
//					Init()		                   			 		 //
/*********************************************************************/
function Init(){
	return GPKISecureWebUi.Init();
}

/*********************************************************************/
//					Login(target, form, isEmbedded)					 //
/*********************************************************************/
function Login(target, form, isEmbedded){
	GPKISecureWebUi.Login(target, form, isEmbedded);
}

/*********************************************************************/
//					LoginEmbedded(form)				 				 //
/*********************************************************************/
function LoginEmbedded(form){
	return GPKISecureWebUi.LoginEmbedded(form);
}

/*********************************************************************/
//					LoginLink(link)		     			 			 //
/*********************************************************************/
function LoginLink(link){
	return GPKISecureWebUi.LoginLink(link, sessionid);
}

/*********************************************************************/
//					Logout()					 		     		 //
/*********************************************************************/
function Logout(){
	return GPKISecureWebUi.Logout();
}

/*********************************************************************/
//					EnvelopedSignData(target,form)   		 		 //
/*********************************************************************/
function EnvelopedSignData(target, form){
	GPKISecureWebUi.EnvelopedSignData(target, form);
}

/*********************************************************************/
//					EnvelopData(form)		         		 		 //
/*********************************************************************/
function EnvelopedData(form, callback){
	GPKISecureWebUi.EnvelopedData(form);
}

/*********************************************************************/
//					SignedDataForm(target, form)           			 //
/*********************************************************************/
function SignedDataForm(target, form){
	GPKISecureWebUi.SignedDataForm(target, form);
}

/*********************************************************************/
//					SignedData(target, form)               			 //
/*********************************************************************/
function SignedData(target, data){
	GPKISecureWebUi.SignedData(target, data);
}

/*********************************************************************/
//					EncryptedSignData(target,form)		 			 //
/*********************************************************************/
function EncryptedSignData(target,form){
	return GPKISecureWebUi.EncryptedSignData(target,form);
}

/*********************************************************************/
//					Encrypt(form)    		 				 		 //
/*********************************************************************/
function Encrypt(form, callback){
	GPKISecureWebUi.Encrypt(form);
}

/*********************************************************************/
//					Decrypt(encData)    		 			 		 //
/*********************************************************************/
function Decrypt(encData){
	return GPKISecureWebUi.Decrypt(encData);
}

/*********************************************************************/
//					EncryptLink()									 //
/*********************************************************************/
function EncryptLink(link,isSubmit,sessionid, callback){
	GPKISecureWebUi.EncryptLink(link,isSubmit,sessionid);
}

//================================================================================================================================
var GPKISecureWebFormString = "";

// GPKISecureWeb InstallCheck Popup Message
GPKISecureWebFormString += '<div id="layerPop" class="GWSdialog-div"><br/>';
GPKISecureWebFormString += decodeURI(GPKISecureWebUi.setupConfirmMessage);
GPKISecureWebFormString += '<br/><br/><span class="GWSdialog-button-set2" >';
GPKISecureWebFormString += '<a id="WinInstallButton" tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.goInstall(\'layerPop\');}" href="javascript:GPKISecureWebUi.goInstall(\'layerPop\');" class="GWSdialog-blue-button">'+decodeURI(GPKISecureWebUi.setupMessage)+'</a>';
/*GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.restartInstallCheck();}" href="javascript:GPKISecureWebUi.restartInstallCheck();" class="GWSdialog-grey-button">'+decodeURI(GPKISecureWebUi.startMessage)+'</a>';*/
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.closeLayer(\'true\');}" href="javascript:GPKISecureWebUi.closeLayer(\'true\');" class=\'GWSdialog-grey-button\'>'+decodeURI(GPKISecureWebUi.cancelMessage)+'</a></div>';

GPKISecureWebFormString += '<div id="layerPopMac" class="GWSdialog-div"><br/><br/><br/>';
GPKISecureWebFormString += decodeURI(GPKISecureWebUi.setupConfirmMessageMAC);
GPKISecureWebFormString += '<div class="GWSdialog-MacPath-img"></div><br/><br/><span class="GWSdialog-button-set">';
GPKISecureWebFormString += '<a id="MacInstallButton" tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.goInstallMAC(\'layerPop\');}" href="javascript:GPKISecureWebUi.goInstallMAC(\'layerPop\');" class="GWSdialog-blue-button">'+decodeURI(GPKISecureWebUi.setupMessage)+'</a>';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.closeLayerMAC(\'true\');}" href="javascript:GPKISecureWebUi.closeLayerMAC(\'true\');" class=\'GWSdialog-grey-button\'>'+decodeURI(GPKISecureWebUi.cancelMessage)+'</a></span></div>';

GPKISecureWebFormString += '<div id="ML_linux_downloadPop" class="GWSdialog-div"><br/><br/><br/>';
GPKISecureWebFormString += decodeURI(GPKISecureWebUi.downloadPopMessge);
GPKISecureWebFormString += '<br/><br/><span class="GWSdialog-button-set">';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadUbuntuFileName32;GPKISecureWebUi.ML_linux_downloadPopClose();}" href="javascript:document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadUbuntuFileName32;GPKISecureWebUi.ML_linux_downloadPopClose();" class="GWSdialog-blue-button3">UBUNTU 32BIT</a>';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadUbuntuFileName64;GPKISecureWebUi.ML_linux_downloadPopClose();}" href="javascript:document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadUbuntuFileName64;GPKISecureWebUi.ML_linux_downloadPopClose();" class="GWSdialog-blue-button3">UBUNTU 64BIT</a>';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadFedoraFileName32;GPKISecureWebUi.ML_linux_downloadPopClose();}" href="javascript:document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadFedoraFileName32;GPKISecureWebUi.ML_linux_downloadPopClose();" class="GWSdialog-blue-button3">FEDORA 32BIT</a>';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadFedoraFileName64;GPKISecureWebUi.ML_linux_downloadPopClose();}" href="javascript:document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadFedoraFileName64;GPKISecureWebUi.ML_linux_downloadPopClose();" class="GWSdialog-blue-button3">FEDORA 64BIT</a>';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.ML_linux_downloadPopClose();}" href="javascript:GPKISecureWebUi.ML_linux_downloadPopClose();" class=\'GWSdialog-grey-button3\'>'+decodeURI(GPKISecureWebUi.cancelMessage)+'</a></span></div>';

GPKISecureWebFormString += '<iframe title="내용없음" id="GPKISecureWebIframe" style="display:none"></iframe>';

GPKISecureWebFormString += '<div id="mask" class="GWSdialog-mask"></div>';

GPKISecureWebFormString += '<div id="progress" class="GWSdialog-progress"><div class="GWSdialog-progress-set"><div class="GWSdialog-load-progress"/></div></div><span class="GWSdialog-progress-font">'+decodeURI(GPKISecureWebUi.installCheckMessage)+'</span></div>';

GPKISecureWebFormString += '<div id="downloadChecker" class="GWSdialog-downloadChecker"><br/>';
GPKISecureWebFormString += '<div class="GWSdialog-downloadChecker-icon"><div class="GWSdialog-load-progress"/></div></div>';
GPKISecureWebFormString += '<span class="GWSdialog-downloadChecker-font">'+decodeURI(GPKISecureWebUi.downloadCheckMessage)+'</span>';
GPKISecureWebFormString += '<span style="display:block; padding-left:50px;">';
GPKISecureWebFormString += '<a id="GPKISecureWebInstallButton" tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.goInstall(\'layerPop\');}" href="javascript:GPKISecureWebUi.goInstall(\'layerPop\');" class="GWSdialog-blue-button">'+decodeURI(GPKISecureWebUi.restartDownLoadMessage)+'</a>';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.downloadCheckerClose(true);}" href="javascript:GPKISecureWebUi.downloadCheckerClose(true);" class=\'GWSdialog-grey-button\'>'+decodeURI(GPKISecureWebUi.cancelMessage)+'</a></span></div>';

GPKISecureWebFormString += '<div id="layerPopUpgrade" class="GWSdialog-div"><br/>';
GPKISecureWebFormString += decodeURI(GPKISecureWebUi.upgradeConfirmMessage);
GPKISecureWebFormString += '<br/><br/><span class="GWSdialog-button-set">';
GPKISecureWebFormString += '<a id="GPKISecureWebUpgradeButton" tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.goUpgrade(\'layerPop\');}" href="javascript:GPKISecureWebUi.goUpgrade(\'layerPop\');" class="GWSdialog-blue-button">'+decodeURI(GPKISecureWebUi.restartDownLoadMessage)+'</a>';
GPKISecureWebFormString += '<a tabindex="0" onKeyPress="javascript:if(event.keyCode == 13){GPKISecureWebUi.upgradeConfirmClose(\'layerPop\');}" href="javascript:GPKISecureWebUi.upgradeConfirmClose(\'layerPop\');" class=\'GWSdialog-grey-button\'>'+decodeURI(GPKISecureWebUi.cancelMessage)+'</a></span></div>';

/* GPKISecureWeb default Version */
if( false ){
	document.writeln(GPKISecureWebFormString);
}else{
	$(document ).ready(function(){
		var GPKISecureWebElementCheck = document.getElementById("GPKISecureWebDiv");
		if( GPKISecureWebElementCheck === null || GPKISecureWebElementCheck === "" ){
			var newDiv = document.createElement("div");
			newDiv.id = "GPKISecureWebDiv";
			newDiv.style.display = "none";
			newDiv.innerHTML += GPKISecureWebFormString;			
			document.body.appendChild(newDiv);
		}
	});
}
//================================================================================================================================
//인스톨 확인 Dialog
GPKISecureWebUi.installCheckdialog = function(){
	try{
		$("#progress").dialog({
			width:GPKISecureWebUi.dialogWidth,
			modal: true,
			Position:"center",
			dialogClass:"GPKIDialogClass",
			closeOnEscape:false,
			resizable: false,
			create: function(event, ui){ $(".ui-dialog-titlebar-close").hide();$(".ui-dialog-title").hide();$(".ui-dialog-titlebar").hide();$(".ui-dialog-content").hide();$(this).removeClass("ui-dialog-content");$(this).removeClass("ui-widget-content");}
		});
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebLog.installCheckDialog ]    :  "+ e.message);
	}
};

GPKISecureWebUi.installCheckdialogClose = function(){
	try{
		$("#progress").dialog("close");
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.installCheckdialogClose ]    :  "+ e.message);
	}
};

GPKISecureWebUi.goInstall = function(IdName){
	try{
		GPKISecureWeb.popupCallback(true);
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.goInstall ]    :  "+ e.message);
	}
};

//설치 실행 취소 버튼 팝업
GPKISecureWebUi.installPageConfirm = function(callback){
	try{
		$("#layerPop").dialog({
			width:GPKISecureWebUi.dialogWidth,
			Position:"center",
			dialogClass:"GPKIDialogClass",
			closeOnEscape:false,
			modal: true,
			resizable: false,
			create: function(event, ui){ $(".ui-dialog-titlebar-close").hide();$(".ui-dialog-title").hide();$(".ui-dialog-titlebar").hide();$(".ui-dialog-content").hide();$(this).removeClass("ui-dialog-content");$(this).removeClass("ui-widget-content");}
		});
		GPKISecureWeb.popupCallback = "";
		GPKISecureWeb.popupCallback = callback;
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.installPageConfirm ]    :  "+ e.message);
	}
};

//설치가이드 Dialog 닫기 ( 설치 안 할 경우 )
GPKISecureWebUi.closeLayer = function(callbackFlag){
	try{
		$("#layerPop").dialog("close");
		if( typeof GPKISecureWeb.GPKIpopup === "object" && GPKISecureWeb.GPKIpopup !== null ){
			GPKISecureWeb.GPKIpopup.close();
		}
		if( callbackFlag ){
			GPKISecureWeb.popupCallback(false);
		}
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.closeLayer ]    :  "+ e.message);
	}
};
//직접다운로드 dialog
GPKISecureWebUi.downloadChecker = function(){
	try{
		$("#downloadChecker").dialog({
			width:GPKISecureWebUi.dialogWidth,
			Position:"center",
			dialogClass:"GPKIDialogClass",
			closeOnEscape:false,
			modal: true,
			resizable: false,
			create: function(event, ui){ $(".ui-dialog-titlebar-close").hide();$(".ui-dialog-title").hide();$(".ui-dialog-titlebar").hide();$(".ui-dialog-content").hide();$(this).removeClass("ui-dialog-content");$(this).removeClass("ui-widget-content");}
		});
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.downloadChecker ]    :  "+ e.message);
	}
};

//직접다운로드 dialog close
GPKISecureWebUi.downloadCheckerClose = function( closeCallbackFlag ){
	try{
		$("#downloadChecker").dialog("close");
		if( closeCallbackFlag === true ){
			GPKISecureWeb.popupCallback(false);
		}
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.downloadCheckerClose ]    :  "+ e.message);
	}
};

//설치가이드 Dialog 닫기 ( 설치 안 할 경우 )
GPKISecureWebUi.upgradeConfirmClose = function(IdName){
	try{
		$("#layerPopUpgrade").dialog("close");
		GPKISecureWeb.popupCallback(false);
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.upgradeConfirmClose ]    :  "+ e.message);
	}
};
// 업그레이드 확인 팝업
GPKISecureWebUi.upgradeConfirm = function(callback){
	try{
		$("#layerPopUpgrade").dialog({
			width:GPKISecureWebUi.dialogWidth,
			Position:"center",
			dialogClass:"GPKIDialogClass",
			closeOnEscape:false,
			modal: true,
			create: function(event, ui){ $(".ui-dialog-titlebar-close").hide();$(".ui-dialog-title").hide();$(".ui-dialog-titlebar").hide();$(".ui-dialog-content").hide();$(this).removeClass("ui-dialog-content");$(this).removeClass("ui-widget-content");}
		});
		GPKISecureWeb.popupCallback = "";
		GPKISecureWeb.popupCallback = callback;
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.upgradeConfirm ]    :  "+ e.message);
	}
};

GPKISecureWebUi.goUpgrade = function(){
	try{
		$("#layerPopUpgrade").dialog("close");
		GPKISecureWeb.popupCallback(true);
	}catch( e ){
		GPKISecureWebLog.log( " dialogError [ GPKISecureWebUi.goUpgrade ]    :  "+ e.message);
	}
};

//설치파일 다운로드후 설치확인이 될때까지 풀링한다.
GPKISecureWebUi.setupCheck = function(){
	try{
		var resultObj = GPKISecureWeb.InstallCheck();
		var result = resultObj.ResultCode;
		if( result === 0){
			setTimeout(function(){
				GPKISecureWeb.clientVersion = GPKISecureWeb.getAPIVersion();
				var resultVersion = GPKISecureWeb.clientVersion.split(".");
				var version = clientVersion.split(".");
				for(i=0; i<=resultVersion.length; i++){
					if(version[i] < resultVersion[i] ){
						GPKISecureWebUi.downloadCheckerClose();
						GPKISecureWebUi.successSetupCheck();
						GPKISecureWeb.installCheckFlag = "ok";
						break;
					}else if(version[i] == resultVersion[i]){
						if(i == 3){
							GPKISecureWebUi.downloadCheckerClose();
							GPKISecureWebUi.successSetupCheck();
							GPKISecureWeb.installCheckFlag = "ok";
						}
					}else{
						setTimeout("GPKISecureWebUi.setupCheck()",300);
						break;
					}
				}
			}, 300);
		} else {
			setTimeout("GPKISecureWebUi.setupCheck()",300);
		}
	}catch( e ){
			setTimeout("GPKISecureWebUi.setupCheck()",300);
	}	
};

GPKISecureWebUi.downLoadFile = function() {
	try{
		
		if( downCheckCount < GPKISecureWeb.DownloadCount ){
			downCheckCount++;
			var os = GPKISecureWeb.getOS();
			if( os.indexOf("MAC")> -1 ){	
				document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadMacFileName;
			}else if( os.indexOf("UBUNTU64")> -1 ){	
				document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadUbuntuFileName64;
			}else if( os.indexOf("UBUNTU32")> -1 ){
				document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadUbuntuFileName32;
			}else if( os.indexOf("FEDORA64")> -1 ){	
				document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadFedoraFileName64;
			}else if( os.indexOf("FEDORA32")> -1 ){	
				document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadFedoraFileName32;
			}else {
				document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadWinFileName;
				//document.location.href = "/gpkisecureweb/index.html";
			}
		}else{
			return;
		}
	}catch(e){
		document.location.href = GPKISecureWeb.DownloadURL + GPKISecureWeb.DownloadWinFileName;
	}
};

GPKISecureWebUi.WinPopup = function( modeString ){
	var WinFunc = function( isInstall ){
		if( downCheckCount < GPKISecureWeb.DownloadCount ){
			if( isInstall ){
				if( GPKISecureWeb.isInstall == "download" ){
					if( downCheckCount < GPKISecureWeb.DownloadCount ){
						if( modeString === "install" ){
							GPKISecureWebUi.closeLayer(false);
						}
						GPKISecureWebUi.downloadChecker();
						GPKISecureWebUi.setupCheck();
						GPKISecureWebUi.downLoadFile();
					}else{
						GPKISecureWebUi.downLoadFile();
					}
				} else {
					GPKISecureWebUi.goInstallPage();
				}
			} else {
				if(returnPageUse){
					GPKISecureWebUi.goIndexPage();
				}else{
					return;
				}
			}
		}else{
			if(! isInstall ){
				if(returnPageUse){
					GPKISecureWebUi.goIndexPage();
				}else{
					return;
				}
			}
		}
	}
	if( modeString === "install" ){
		GPKISecureWebUi.installPageConfirm(WinFunc);
	}else if( modeString ==="upgrade" ){
		GPKISecureWebUi.upgradeConfirm(WinFunc);
	}
}
//================================================================================================================
//URLScheme
//URL Scheme 으로 CS실행후 상호검증 진행
GPKISecureWeb.StartCS = function( port )
{
	if (GPKISecureWebUi.documentWrite === true){
		GPKISecureWeb.sendURLScheme( port );
	}else{
		ML$( document ).ready(function(){
			GPKISecureWeb.sendURLScheme( port );
		});
	}
};
// 브라우저별 분기후 팝업이나 iframe을 이용해  URL Scheme으로 CS 실행 
GPKISecureWeb.sendURLScheme = function( port ){
	var os = GPKISecureWeb.getOS();
	var GPKISecureWebBrowser = GPKISecureWeb.getBrowser();
	var GPKIpopup = "";
	if( GPKISecureWebBrowser.toUpperCase().indexOf( "MSIE" ) > -1 ){
		GPKISecureWeb.openPopup();
	}else if( GPKISecureWebBrowser.toUpperCase().indexOf( "FIREFOX" ) > -1 || GPKISecureWebBrowser.toUpperCase().indexOf( "OPERA" ) > -1 ||GPKISecureWebBrowser.toUpperCase().indexOf( "SAFARI" ) > -1 || GPKISecureWebBrowser.toUpperCase().indexOf( "CHROME" ) > -1 ){
		window.document.getElementById("GPKISecureWebIframe").src="GPKISecureWebNP://";
	}else if( ( GPKISecureWebBrowser.toUpperCase().indexOf( "TRIDENT" ) > -1 ) || GPKISecureWebBrowser.toUpperCase().indexOf( "MSIE 7" ) > -1  ){
		GPKISecureWeb.openPopup();
	}else if(  GPKISecureWebBrowser.toUpperCase().indexOf( "EDGE" ) > -1 && os.toUpperCase().indexOf("WINDOWS 10") > -1 ){
		window.document.getElementById("GPKISecureWebIframe").src="GPKISecureWebNP://";
	} else {
		GPKISecureWeb.openPopup();
	}	
};
GPKISecureWeb.openPopup = function(){
	try{
		GPKISecureWeb.GPKIpopup = window.open( GPKISecureWeb.UrlSchemeServerURL  + "call.html", "GPKISecureWeb", "width=315,height=115,left=5000,top=5000,resizable=no,toolbar=no,location=no,status=no" );
		if( GPKISecureWeb.GPKIpopup === null ){
				alert( decodeURI(GPKISecureWebUi.popupCheckMessage) );
		}
	}catch(e){
		GPKISecureWebLog.log( " [GPKISecureWebUi.openPopup]"+ e.message);
	}
};
GPKISecureWeb.GPKIpopupClose = function(){
	var GPKISecureWebBrowser = GPKISecureWeb.getBrowser();
	
	try{
		if( typeof GPKISecureWeb.GPKIpopup === "object" && GPKISecureWeb.GPKIpopup !== null ){
			GPKISecureWeb.GPKIpopup.close();
		}else if( GPKISecureWeb.GPKIpopup !== null ) {
			if( GPKISecureWeb.GPKIpopup !== "" ){
			if( ( GPKISecureWebBrowser.indexOf( "MSIE" ) > -1 ) || GPKISecureWebBrowser.indexOf( "Trident" ) > -1){
				GPKISecureWeb.GPKIpopup.close();
			}
			setTimeout(GPKISecureWeb.GPKIpopupClose1,1000);
		}
		}
	}catch(e){
		if( GPKISecureWeb.GPKIpopup !== null ) {
			GPKISecureWeb.GPKIpopup = window.open("about:blank", "GPKISecureWebNP","width=315,height=115,left=50000,top=5000,resizable=no,toolbar=no,location=no,status=no");
			if( GPKISecureWeb.GPKIpopup !== null ) {
				if( GPKISecureWeb.GPKIpopup !== "" ){
					if( ( GPKISecureWebBrowser.indexOf( "MSIE" ) > -1 ) || GPKISecureWebBrowser.indexOf( "Trident" ) > -1){
						GPKISecureWeb.GPKIpopup.close();
					}
					setTimeout(GPKISecureWeb.GPKIpopupClose1,1000);
				}
			}
		}
	}
}
GPKISecureWeb.GPKIpopupClose1 = function(){
	try{ 
		if( typeof GPKISecureWeb.GPKIpopup === "object" && GPKISecureWeb.GPKIpopup !== null ){
			GPKISecureWeb.GPKIpopup.close();
		}else if( GPKISecureWeb.GPKIpopup !== null ) {
			if( GPKISecureWeb.GPKIpopup !== "" ){
				if( ( GPKISecureWebBrowser.indexOf( "MSIE" ) > -1 ) || GPKISecureWebBrowser.indexOf( "Trident" ) > -1){
					GPKISecureWeb.GPKIpopup.close(); 
				}
				setTimeout(GPKISecureWeb.GPKIpopupClose1,1000);
			}
		}
	}catch(e){
		GPKISecureWebLog.log( " [GPKISecureWebUi.GPKIpopupClose1]"+ e.message);
	}
};
//====================================================================
//GPKISecureWebNP 설치 관련 기능
//====================================================================

//설치페이지 이동
GPKISecureWebUi.goInstallPage = function(){
	GPKISecureWeb.setCookie( "GPKISecureWebReuturnURL", window.location.href, 0 );
	window.location.href = GPKISecureWeb.InstallPageURL;
};

GPKISecureWebUi.restartInstallCheck = function(){
	var os = GPKISecureWeb.getOS();
	var GPKISecureWebBrowser = GPKISecureWeb.getBrowser();
	installCheckCount = 0;
	try{
		GPKISecureWebUi.closeLayer();
		GPKISecureWebUi.installCheckdialog();
		GPKISecureWebUi.secureWebNPRunningCheck();
	}catch(e){
		GPKISecureWebLog.log( " [GPKISecureWebUi.restartInstallCheck]"+ e.message);
	}
	GPKISecureWeb.sendURLScheme();
}

GPKISecureWebUi.goIndexPage = function(){	
	GPKISecureWeb.GPKIpopupClose(GPKISecureWeb.GPKIpopup);
	if( typeof GPKISecureWeb.closeCallback !== 'function'){
		document.location.href = returnIndexPage;
	}else{
		GPKISecureWeb.closeCallback();
	}
}

GPKISecureWebUi.successInstallCheck = function(){
	try{
		
		var os = GPKISecureWeb.getOS();
		if( os.indexOf("win") >= 0){
			GPKISecureWebUi.closeLayer();
		}else{
			GPKISecureWebUi.closeLayerMAC();
		}
	}catch( e ){	
		GPKISecureWebLog.log( " [GPKISecureWebUi.successInstallCheck] [closeLayer]"+ e.message);
	}
	try{
		GPKISecureWebUi.installCheckdialogClose();
	}catch(e){
		GPKISecureWebLog.log( " [GPKISecureWebUi.successInstallCheck] [installCheckdialogClose] "+ e.message);
	};
	GPKISecureWeb.GPKIpopupClose(GPKISecureWebUi.GPKIpopup);
	if( typeof GPKISecureWeb.successCallback !== 'function'){	
	}else{
		GPKISecureWeb.successCallback();
	}
}

GPKISecureWebUi.successSetupCheck = function(){
	try{
		
		var os = GPKISecureWeb.getOS();
		if( os.indexOf("win") >= 0){
			GPKISecureWebUi.closeLayer();
		}else{
			GPKISecureWebUi.closeLayerMAC();
		}
	}catch( e ){	
		GPKISecureWebLog.log( " [GPKISecureWebUi.successInstallCheck] [closeLayer]"+ e.message);
	}
	try{
		GPKISecureWebUi.installCheckdialogClose();
	}catch(e){
		GPKISecureWebLog.log( " [GPKISecureWebUi.successInstallCheck] [installCheckdialogClose] "+ e.message);
	};
	GPKISecureWeb.GPKIpopupClose(GPKISecureWebUi.GPKIpopup);
	if( typeof GPKISecureWeb.setupCheckCallback !== 'function'){	
	}else{
		GPKISecureWeb.setupCheckCallback();
	}
}
GPKISecureWebUi.successRunningCheck = function(){
	try{
		
		var os = GPKISecureWeb.getOS();
		if( os.indexOf("win") >= 0){
			GPKISecureWebUi.closeLayer();
		}else{
			GPKISecureWebUi.closeLayerMAC();
		}
	}catch( e ){	
		GPKISecureWebLog.log( " [GPKISecureWebUi.successInstallCheck] [closeLayer]"+ e.message);
	}
	try{
		GPKISecureWebUi.installCheckdialogClose();
	}catch(e){
		GPKISecureWebLog.log( " [GPKISecureWebUi.successInstallCheck] [installCheckdialogClose] "+ e.message);
	};
	GPKISecureWeb.GPKIpopupClose(GPKISecureWebUi.GPKIpopup);
	if( typeof GPKISecureWeb.runningCheckCallback !== 'function'){	
	}else{
		GPKISecureWeb.runningCheckCallback();
	}
}
GPKISecureWebUi.failedInstallCheck = function( dialogType, errorCode ){
	//팝업창 닫기
	try{
		GPKISecureWeb.GPKIpopupClose(GPKISecureWeb.GPKIpopup);
	}catch( e ){
		GPKISecureWebLog.log( " [GPKISecureWebUi.failedInstallCheck] [ GPKISecureWebUi.GPKIpopupClose ]    :  "+ e.message);
	}
	//dialog 닫기
	try{
		if( dialogType === "installCheck"){
			GPKISecureWebUi.installCheckdialogClose();
		}else if( dialogType === "setupCheck" ){
			GPKISecureWebUi.downloadCheckerClose();
		}
	}catch( e ){
		GPKISecureWebLog.log( " [GPKISecureWebUi.failedInstallCheck] [ dialog close ]    :  "+ e.message);
	}
	if( typeof GPKISecureWeb.failedCallback !== 'function'){
		if( errorCode === -3000 ){
			alert( "쿠키를 사용하지 않는 경우 정상적으로 동작하지 않습니다.\n쿠키를 허용해주세요");
		}else if( errorCode === -5000 ){
			alert( "통신중 오류가 발생하였습니다.(E"+errorCode+")");
		}else if( errorCode >= 12000 && errorCode <= 13000 ){
			alert( "통신중 오류가 발생하였습니다.(E"+errorCode+")");
		}else if( errorCode == 150 ){
			//비밀번호 틀림 횟수 초과
			return;
		}else if( errorCode == -1000 ){
			//alert( "클라이언트와 통신할수 없습니다.\n error : "+ errorCode );
			installCheck.count = GPKISecureWeb.InstallCheckCount - 1;
			try{
				GPKISecureWebUi.closeMask();
			}catch(e){
				GPKISecureWebLog.log( " [GPKISecureWebUi.closeMask] :  "+ e.message);
			}
			GPKISecureWebUi.InstallCheck();
		}else{
			GPKISecureWebLog.log("GPKISecureWeb_MessageError","start GPKI Error : [ GPKISecureWeb "+decodeURI("%EA%B2%80%EC%A6%9D%EC%8B%A4%ED%8C%A8")+" ] "+"\n ErrorCode : "+errorCode, errorCode );
			alert( decodeURI(GPKISecureWebUi.setupCertFailed) +"(E"+errorCode+")" ) ;
			//GPKISecureWeb.TerminateCS();
			document.location.href = returnIndexPage;
		}
	}else{
		GPKISecureWeb.failedCallback( errorCode );
	}
}
//================================================================================================================================
GPKISecureWebUi.GPKISubmit = function( form, isEmbedded ){
	
	var queryString = "";
	var qs_index = "";
	var action = "";
	var noenc_qs = "";
	if ( form.action.indexOf('?') != -1 ){
		alert(action);
		action = form.action;
		document.gpkiForm.action = action.substring( 0, form.action.lastIndexOf('?') );
		queryString = action.substring( action.lastIndexOf('?') + 1, action.length) + '&';
	}else{
		document.gpkiForm.action = form.action;
	}
	
	queryString += makeQueryString(form, isEmbedded);
	return queryString;

}

GPKISecureWebUi.Init = function(){
	var ret;
	// 기존 설정 값들을 JSON Object로 만든다
	var prop = {}; // JSON객체생성

	// 기존 SetProperty 함수에 설정되는 Key, Value 값을 JSON Key, Value로 설정한다.
	prop[1] = WorkDir;
	prop[2] = ServerCert;
	prop[3] = AlgoMode;
	prop[4] = HashAlg;
	prop[5] = GNCertType;
	prop[6] = ValidCertInfo;
	prop[7] = '';
	prop[8] = '';
	prop[9] = smartCardOpt;
	prop[10] = phoneOpt;
	prop[11] = langOpt;
	prop[12] = secureApiOpt;

	prop[13] = UbikeyWParam;
	prop[14] = UbikeyCompany;
	prop[15] = UbikeyKeyboardSec;
	prop[16] = keysecOpt;
	if( typeof(UbikeyVersion)!='undefined' && UbikeyVersion != null){
		prop[17] = UbikeyVersion;
	}
	prop[19] = "행정자치부:행정안전부";
	if(keysecOpt != null && keysecOpt == 2){
		prop[26] = keyboardSecOpt;
	}
	prop[27] = JSON.stringify(DS_PKI_CERT_PATH);
	prop[28] = JSON.stringify(DS_PKI_POLICY_OID);

	// JSON 타입의 설정 Key값은 0 이고, encodeURIComponent 로 인코딩하여 설정해야 한다.
	GPKISecureWeb.SetProperty(0,  encodeURIComponent(JSON.stringify(prop)));
	
	var ret = GPKISecureWeb.Init();
	if(keysecOpt==2 && ret == 30003){
		alert(ErrorMessage.code70018);
	}else if( ret != 0 ){ 
		alert(ErrorMessage.code30001 + ret);
		return -1;		
	}	

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKISecureWeb.setServerEncoding(serverCharEnc);      // 서버 인코딩 지정 
	GPKISecureWeb.setClientEncoding(clientCharEnc);      // 클라이언트 인코딩 지정
			
	return ret;
	
}

GPKISecureWebUi.EmbInit = function(form){
	return 0;
}

GPKISecureWebUi.LoginEmbedded = function(form){
	var strSendData; 
	strData=  encodeURIComponent(GPKISecureWebUi.GPKISubmit(form));
	 
	gfNextParameters = strData+'$'+form.method+'$'+form.action+'$'+form.sessionid.value;
	embededWin.startAction();
	return false;
}

GPKISecureWebUi.Login = function(target,form,isEmbeded){

	var nResult;
	var strReturnData;
	var strData;
	strData = GPKISecureWebUi.GPKISubmit(form, isEmbeded); 
	
	var certbag = {};
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.Login(sSiteID, strData, certbag, function(result){
		
		if(isEmbeded){
			form = document.getElementById("popForm");
			strData = GPKISecureWebUi.GPKISubmit(form, true); 
		}
		
		nResult = result.code;
		strReturnData = result.message;
		
		if(passwordCount!=0 && checkCount == passwordCount){
			document.gpkiForm.pwCheckCode.value="77777";
			document.gpkiForm.userDN.value= encodeURIComponent(userDN); 
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else if( nResult == 0 ){
			document.gpkiForm.encryptedData.value = replaceLtRt(strReturnData);
			document.gpkiForm.pwCheckCode.value="0";
			document.gpkiForm.method = form.method;
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else{
			alert(strReturnData); 
		}
	}, isEmbeded);
}

GPKISecureWebUi.LoginLink = function(link,cookieSession){	
	var strData;
	var nResult;
	var strReturnData;
	var strSendData;
	
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	strData =  GPKISecureWeb.GPKILink( link );
	
	var certbag = {};
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.Login(sSiteID, strData, certbag, function(result){
		nResult = result.code;
		strReturnData = result.message;
		
		if(passwordCount!=0 && checkCount == passwordCount){
			document.gpkiForm.pwCheckCode.value="77777";
			document.gpkiForm.userDN.value= encodeURIComponent(userDN); 
			document.gpkiForm.action = link;
			document.gpkiForm.submit();
		}else if( nResult == 0){
			document.gpkiForm.encryptedData.value = replaceLtRt(strReturnData);
			document.gpkiForm.pwCheckCode.value="0";
			document.gpkiForm.action = link;
			
			if ( typeof(link.target) == "undefined" || link.target == "" || link.target == null ) {
				document.gpkiForm.target = "_self";
			}else{
				document.gpkiForm.target = link.target;
			}
			document.gpkiForm.submit();
		}else{
			alert(strReturnData); 
		}
	});
}


GPKISecureWebUi.Logout = function(){
	var strData;
	var nResult;
	var strReturnData;
	var strSendData; 
	
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	nResult = GPKIClientJS.Logout(sSiteID);
	if( nResult == 0 ){
		top.location.href = ServiceStartPageURL;
	}
}

GPKISecureWebUi.EnvelopedSignData = function(target,form){
	var strData;
	var nResult;
	var strReturnData;
		
	strData=  GPKISecureWebUi.GPKISubmit(form);
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	
	var certbag = {};
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.EnvelopedSignData(sSiteID, strData, certbag, function(result){
		nResult = result.code;
		strReturnData = result.message;
		
		if(passwordCount!=0 && checkCount == passwordCount){
			document.gpkiForm.pwCheckCode.value="77777";
			document.gpkiForm.userDN.value= encodeURIComponent(userDN); 
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else if( nResult == 0 ){
			document.gpkiForm.encryptedData.value = replaceLtRt(strReturnData);
			document.gpkiForm.pwCheckCode.value="0";
			document.gpkiForm.method = form.method;
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else{
			if( nResult != 106)
				alert(strReturnData); 
		}
	});
	
}

GPKISecureWebUi.EnvelopedData = function(form){
	var strData;
	var nResult;
	var strReturnData;
	strData = GPKISecureWebUi.GPKISubmit(form); 
	
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.EnvelopData(sSiteID, strData, function(result){
		nResult = result.code;
		strReturnData = result.message;
		
		if( nResult == 0 ){
			document.gpkiForm.encryptedData.value = replaceLtRt(strReturnData);
			document.gpkiForm.pwCheckCode.value="0";
			document.gpkiForm.method = form.method;
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else{
			if( nResult != 106){
				alert(strReturnData); 
			}
		}
	});
}


GPKISecureWebUi.SignedDataForm = function(target,form){
	var nResult;
	var strData;
	strData = GPKISecureWebUi.GPKISubmit(form);
	
	var certbag = {};
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.SignedData(sSiteID, strData, certbag, function(result){
		nResult = result.code;
		if(passwordCount!=0 && checkCount == passwordCount){
			document.gpkiForm.pwCheckCode.value="77777";
			document.gpkiForm.userDN.value= encodeURIComponent(userDN); 
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else if( nResult == 0 ){
			document.gpkiForm.encryptedData.value = replaceLtRt(result.message);
			document.gpkiForm.pwCheckCode.value="0";
			document.gpkiForm.method = form.method;
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else{
			if( nResult == 30053 )
				result.message = ErrorTest.code30053;
				alert(result.message); 
		}
	});
}

GPKISecureWebUi.SignedData = function(target,data){
	var nResult;
	var strReturnData;
	
	var dataOrg = data.split(/_[^_]+$/g, "");
	if(dataOrg == null || dataOrg == ""){
		alert(ErrorMessage.code70003);
		return false;
	}
	
	var certbag = {};
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	var idn = document.getElementById('ssn');
	if(idn !=null && typeof(idn)!='undefined' && idn.value.length > 0) {
		GPKIClientJS.SignedDataWithVIDCheck(sSiteID, dataOrg, idn.value, certbag, function(result){
			nResult = result.code;
			strReturnData = result.message;
			
			if(passwordCount!=0 && checkCount == passwordCount){
				document.gpkiForm.pwCheckCode.value="77777";
				document.gpkiForm.userDN.value= encodeURIComponent(userDN);
			}else if( nResult == 0 ){
				var signedDataField = document.getElementById('signedDataValue');
				if (signedDataField != null && typeof(signedDataField) != 'undefined') {
					signedDataField.value = strReturnData;
					document.gpkiForm.pwCheckCode.value="0";
				} else{
					alert(ErrorMessage.code70003);
				}
				return strReturnData;
				
			}else{
				if( nResult == 30053){
					alert(ErrorMessage.code30053);
				}else if(nResult == 30063){
					alert(ErrorMessage.code30063);
				}
				else {
					makeError("code" + nResult);	
				}			
				return "";
			}
		});
	}else{
		GPKIClientJS.SignedData(sSiteID, dataOrg, certbag, function(result){
			nResult = result.code;
			strReturnData = result.message;
			
			if(passwordCount!=0 && checkCount == passwordCount){
				document.gpkiForm.pwCheckCode.value="77777";
				document.gpkiForm.userDN.value= encodeURIComponent(userDN);
			}else if( nResult == 0 ){
				var signedDataField = document.getElementById('signedDataValue');
				if (signedDataField != null && typeof(signedDataField) != 'undefined') {
					signedDataField.value = strReturnData;
					document.gpkiForm.pwCheckCode.value="0";
				} else{
					alert(ErrorMessage.code70003);
				}
				return strReturnData;
				
			}else{
				if( nResult == 30053){
					alert(ErrorMessage.code30053);
				}else if(nResult == 30063){
					alert(ErrorMessage.code30063);
				}
				else {
					makeError("code" + nResult);	
				}			
				return "";
			}
		});
	}
}	

GPKISecureWebUi.EncryptedSignData = function(target,form){
	var strData;
	var nResult;
	var strReturnData;
	strData = GPKISecureWebUi.GPKISubmit(form);
	
	var certbag = {};
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.EncryptedSignData(sSiteID, strData, function(result){
		nResult = result.code;
		strReturnData = result.message;
		
		if(passwordCount!=0 && checkCount == passwordCount){
			document.gpkiForm.pwCheckCode.value="77777";
			document.gpkiForm.userDN.value= encodeURIComponent(userDN); 
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else if( nResult == 0 ){
			document.gpkiForm.encryptedData.value = replaceLtRt(strReturnData);
			document.gpkiForm.pwCheckCode.value="0";
			document.gpkiForm.method = form.method;
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else{
			if( nResult == 30053){
				//obj.ResultMessage = 'Not Exist SecureSession. \n Please retry after you create Securesession';
				strReturnData = ErrorMessage.code30053;
				alert(strReturnData);
			}
			location.href = ServiceStartPageURL;
		}
	});
	
}

GPKISecureWebUi.Encrypt = function(form){
	var nResult;
	var strReturnData;
	var strData;
	strData = GPKISecureWebUi.GPKISubmit(form);
	
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.Encrypt(sSiteID, strData, function(result){
		nResult = result.code;
		strReturnData = result.message;
		
		if( nResult == 0 ){
			document.gpkiForm.encryptedData.value = replaceLtRt(strReturnData);
			document.gpkiForm.pwCheckCode.value="0";
			document.gpkiForm.method = form.method;
			document.gpkiForm.action = form.action;
			document.gpkiForm.submit();
		}else{
			if( nResult == 30053){
				alert(ErrorMessage.code30053);
				return false;
			}else{
				alert(strReturnData);
				return false;
			}
			location.href = ServiceStartPageURL;
			return false;
		}
	});
}

GPKISecureWebUi.EncryptLink = function(link,isSubmit,sessionid){
	var strData;
	strData = GPKISecureWeb.GPKILink(link); 
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	link.href += "encryptedData=";	
	
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	GPKIClientJS.Encrypt(sSiteID, strData, function(result){
		nResult = result.code;
		strReturnData = result.message;
		
		if(nResult == 0){
			if(isSubmit==null || typeof(isSubmit)=='undefined' || isSubmit){
				document.gpkiForm.encryptedData.value = replaceLtRt(strReturnData);
				document.gpkiForm.pwCheckCode.value="0";
				document.gpkiForm.action = link.href.substring(link.href.lastIndexOf('\/')+1,link.href.lastIndexOf('\?'));
				document.gpkiForm.target="_self";
				document.gpkiForm.submit();
			}else{
				strData = replaceEscapeString(replaceLtRt(strReturnData));
				link.href += replaceLtRt(strData);
			}
		}else{
			if(nResult == 30053){
				strReturnData = ErrorMessage.code30053;
			}
			alert(strReturnData);
			return false;
		}
	});
}

GPKISecureWebUi.Decrypt = function(encData){
	var strReturnData;
	var strData = encData;
	
	var cookieSession = GPKISecureWeb.getCookie("GPKISecureWebSession");
	var sSiteID = SiteID+cookieSession;
	
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	nResult = GPKIClientJS.Decrypt(sSiteID, strData);
	strReturnData = GPKIClientJS.GetReturnData();
	var obj = JSON.parse(strReturnData);
	
	if( nResult == 0 ){
		return obj.ResultMessage;
	}else{
		if(nResult == 30053){
			alert(ErrorMessage.code30053);
			
		}else{
			alert(ErrorMessage.code70004 + obj.ResultMessage);
		}
		return false;
		location.href = ServiceStartPageURL;
	}
}
GPKISecureWebUi.KeyboardSecurityLoad = function(){
	if(keyboardSecOpt == 2){
		npPfsCtrl.RescanField();
		$(".nppfs-elements").attr("style","display:none");
	}
	
}
//===========================================================================================================================================================
/* 2019-04-03  function createStandardXHR(){try{return new window.XMLHttpRequest}catch(a){GPKISecureWebLog.log("GPKISecureWeb.createStandardXHR :  [ "+a.message+" ]["+a.code+" ]")}}function createActiveXHR(){try{return new window.ActiveXObject("Microsoft.XMLHTTP")}catch(a){GPKISecureWebLog.log("GPKISecureWeb.createActiveXHR :  [ "+a.message+" ]["+a.code+" ]")}}function makeQueryString(a){var b=new Array(a.elements.length),c=new Array(a.elements.length),d=!1,e=0,f="";for(len=a.elements.length,i=0;i<len;i++)if("button"!=a.elements[i].type&&"reset"!=a.elements[i].type&&"submit"!=a.elements[i].type)if("radio"==a.elements[i].type||"checkbox"==a.elements[i].type)1==a.elements[i].checked&&(b[e]=a.elements[i].name,c[e]=encodeURIComponent(a.elements[i].value),e++);else{if(b[e]=a.elements[i].name,"select-one"==a.elements[i].type){var g=a.elements[i].selectedIndex;""!=a.elements[i].options[g].value?c[e]=a.elements[i].options[g].value:c[e]=encodeURIComponent(a.elements[i].options[g].text)}else c[e]=a.elements[i].value;e++}for(i=0;i<e;i++)d?f+="&":d=!0,f+=b[i],f+="=",f+="challenge"!=b[i]?encodeURIComponent(c[i]):c[i];return f}function replaceEscapeString(a){var b,c,d="",e="";for(e=String(a),b=0;b<e.length;b++)c=e.charAt(b),d+=" "==c?"%20":"%"==c?"%25":"&"==c?"%26":"+"==c?"%2B":"="==c?"%3D":"?"==c?"%3F":c;return d}function embeddedEnterEvent(a){return 13==a.keyCode?(LoginEmbedded(document.getElementById("popForm")),!1):void 0}function loadJavascript(URL,callback,event,charet){var xmlhttp=null;xmlhttp=window.XMLHttpRequest?new XMLHttpRequest:new ActiveXObject("Microsoft.XMLHTTP"),URL=null!=charet&&"undefined"!=typeof charet&&0!=charet.length?URL+"_"+charet:URL,xmlhttp.open("GET",URL,!1),xmlhttp.onreadystatechange=function(){4==xmlhttp.readyState&&200==xmlhttp.status&&"OK"==xmlhttp.statusText&&eval(xmlhttp.responseText)},xmlhttp.send("");var userAgent=navigator.userAgent;return userAgent.indexOf("Firefox")>-1&&userAgent.indexOf("3.6.")>-1&&4==xmlhttp.readyState&&200==xmlhttp.status&&"OK"==xmlhttp.statusText&&eval(xmlhttp.responseText),null!=event&&"undefined"!=typeof event?callback(event):callback()}function cipherAction(){gfNextFunc(gfNextParameters)}function vKSetPointInit(a,b,c){var d=b.indexOf("<gpki"),e="</gpki:ENCRYPTED DATA>",f=b.indexOf(e)+e.length,g=b.substring(d,f),h=new Array;h=g.split("+ "),g="";for(var i=0;i<h.length;i++){var j=h[i].replace("'","");j=j.replace(/(^\s*)|(\s*$)/gi,""),g+=j.replace("\n","")}GPKISecureWeb.SetPointInit(a,g,c)}function vKSetPoint(a){GPKISecureWeb.SetPoint(a)}function displayEmbedWindow(a){displayWindow(a,!0)}function displayWindow(a,b,c){var d;null!=c&&"undefined"!=typeof c&&(gpSessionId=c);try{b?(d=new CertSelect(!0,gpSessionId),embededWin=d):d=new CertSelect(!1,gpSessionId)}catch(e){d=new CertSelect(!1,gpSessionId)}var f=new Array;f[0]=RequestSKeyboard,f[1]=EncryptLink,f[2]=vKSetPointInit,f[3]=vKSetPoint,d.setKeyboardSec(keysecOpt,f),GPKISecureWeb.SetProperty(16,keysecOpt),d.show(a)}function RequestSKeyboard(a,b){var c,d,e;if(d=Init(),117!=d){if(1==b.length)c="func="+b[0];else{if(4!=b.length)return;c="func="+b[0]+"&change="+b[1]+"&dummy="+b[2]}null!=sessionid&&"undefined"!=typeof sessionid&&(GPKISecureWeb.SetSessionID(sessionid),gpSessionId=sessionid),d=GPKISecureWeb.Encrypt(SiteID+gpSessionId,c),e=GPKISecureWeb.GetReturnData();var f=JSON.parse(e);if(0==d){var g="./makeDSKeySecure";g+="."+addPageExt(),g+="?encryptedData="+encodeURIComponent(f.ResultMessage)+"&mkdummy="+b[2],"php"!=addPageExt()?a.src=g:loadJavascript(g,showPHPVKeyboard,a)}else 106!=d&&alert(f.ResultMessage)}}function showPHPVKeyboard(a){var b=decodeURIComponent(urlBase64Image);a.src="data:image/jpeg;base64,"+b}function initSecureSession(){if(0!=GPKISecureWeb.initFlag&&(GPKISecureWebUi.InitCheck(),0!=GPKISecureWeb.initFlag))return!1;var a=GPKISecureWeb.SetSessionID(sessionid),b=GPKISecureWeb.Encrypt(SiteID+sessionid,"111");0==a&&30053==b&&(location.href="./requestSecureSession."+serverLangExt+"?rnd="+sessionid)}function addPageExt(){var a,b=window.location.href;return a=b.indexOf(".aspx")>-1?"aspx":b.indexOf(".asp")>-1?"asp":b.indexOf(".php")>-1?"php":"jsp"}function replaceServerScriptExt(){$("#gpkilink").find("a").each(function(){if($(this).attr("href").indexOf(".html")<0){var a=$(this).attr("href");$(this).attr("href",serverLangExt+"/"+a+"."+serverLangExt)}})}function replaceLtRt(a){return aspxXSSvalidate&&null!=a&&"jsp"==serverLangExt&&(a=a.replace(/</gi,"_"),a=a.replace(/>/gi,"_")),$.trim(a)}function postSignedDataToServer(a){return 0!=vidCheck||null==a||""==a?!1:(document.gpkiForm.encryptedData.value=a,document.gpkiForm.method="post",document.gpkiForm.action="./createSecureSession_1_1_response."+serverLangExt,void document.gpkiForm.submit())}GPKISecureWebLog=new Object,GPKISecureWebLog.logType="",GPKISecureWebLog.log=function(a){"console"==GPKISecureWebLog.logType?console.log(a):"alert"==GPKISecureWebLog.logType&&alert(a)};var GPKISecureWebAjax={};GPKISecureWebAjax.xhr=void 0!==window.ActiveXObject?function(){return GPKISecureWeb.AjaxLocal&&createStandardXHR()||createActiveXHR()}:createStandardXHR,GPKISecureWebAjax.request=function(a,b,c,d){try{var e=GPKISecureWebAjax.xhr(),f=!b;if(e.open("POST",a,f),e.setRequestHeader("Content-Type","application/x-www-form-urlencoded"),e.send(c),b===!1)e.onreadystatechange=function(){4==e.readyState&&(200==e.status?d(e.responseText,0):d(e.statusText,e.status))};else if(b===!0)if(4==e.readyState){if(200==e.status)return e.responseText;GPKISecureWebLog.log("GPKISecureWebAjaxError","AJAX Failed : [ xmlHttpRequest.statusText ][ "+e.statusText+" ][xmlHttpRequest.readyState][ "+e.readyState+" ]")}else GPKISecureWebLog.log("GPKISecureWebAjaxError","AJAX Failed : [ xmlHttpRequest.statusText ][ "+e.statusText+" ][xmlHttpRequest.readyState][ "+e.readyState+" ]")}catch(g){GPKISecureWebLog.log("GPKISecureWebAjaxError","AJAX Failed : [ xmlHttpRequest.statusText ][ "+e.statusText+" ][xmlHttpRequest.readyState][ "+e.readyState+" ]",e.status)}},GPKISecureWeb.encodeUtf8andBase64=function(a){var b,c,d,e="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",f="",g="",h=0;for(a=unescape(encodeURIComponent(a)),maxline=(a.length+2-(a.length+2)%3)/3*4;h<a.length;)b=a.charCodeAt(h++),c=a.charCodeAt(h++),d=a.charCodeAt(h++),f+=e.charAt(b>>2),f+=e.charAt((3&b)<<4|c>>4),isNaN(c)?f+="==":(f+=e.charAt((15&c)<<2|d>>6),f+=isNaN(d)?"=":e.charAt(63&d)),maxline&&f.length>maxline&&(g+=f.substr(0,maxline)+"\r\n",f=f.substr(maxline));return g+=f},GPKISecureWeb.InitCheck=function(){var a=GPKISecureWeb.makeJsonMessage("InitCheck");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a),c="";return c=JSON.parse(b),c.ResultCode}catch(d){return d.code}},GPKISecureWeb.SetProperty=function(a,b){var c=GPKISecureWeb.makeJsonMessage("SetProperty",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return GPKISecureWebLog.log("GPKISecureWeb.SetPropertyError :  [ "+f.message+" ]["+f.code+" ]"),f.code}},GPKISecureWeb.Init=function(){var a=GPKISecureWeb.makeJsonMessage("Init");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a),c=JSON.parse(b);return c.ResultCode}catch(d){return GPKISecureWebLog.log("GPKISecureWeb.InitError :  [ "+d.message+" ]["+d.code+" ]"),d.code}},GPKISecureWeb.UnInit=function(){var a=GPKISecureWeb.makeJsonMessage("UnInit");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a),c=JSON.parse(b);return c.ResultCode}catch(d){return GPKISecureWebLog.log("GPKISecureWeb.UnInitError :  [ "+d.message+" ]["+d.code+" ]"),d.code}},GPKISecureWeb.GetReturnData=function(){var a=GPKISecureWeb.makeJsonMessage("GetReturnData");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a);return b}catch(c){return GPKISecureWebLog.log("GPKISecureWeb.GetReturnDataError :  [ "+c.message+" ]["+c.code+" ]"),c.code}},GPKISecureWeb.Logout=function(a){var b=GPKISecureWeb.makeJsonMessage("Logout",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return GPKISecureWebLog.log("GPKISecureWeb.LogoutError :  [ "+e.message+" ]["+e.code+" ]"),e.code}},GPKISecureWeb.setCookie=function(a,b,c){var d=new Date;d.setTime(d.getTime()+24*c*60*60*1e3);var e="expires="+d.toUTCString();0===c?document.cookie=a+"="+b+"; path=/; ":document.cookie=a+"="+b+"; "+e+"; path=/;"},GPKISecureWeb.getCookie=function(a){if("true"===isCookie){for(var b=a+"=",c=document.cookie.split(";"),d=0;d<c.length;d++){for(var e=c[d];" "===e.charAt(0);)e=e.substring(1);if(0===e.indexOf(b))return e.substring(b.length,e.length)}return""}return"GPKISecureWebSession"===a?session:""},GPKISecureWeb.trim=function(a){return a+="",a=a.replace(/^\s+|\s+$/gm,""),a=a.replace(/[\r][\n]/g,""),a=a.replace(/[\x10][\x13]/g,"")},GPKISecureWeb.createGPKISecureWebSessionID=function(){"true"===isCookie?(sessionid=GPKISecureWeb.getCookie("GPKISecureWebSession"),""===sessionid&&GPKISecureWeb.setCookie("GPKISecureWebSession",GPKISecureWeb.makeSessionString(),0)):""==sessionid&&(sessionid=GPKISecureWeb.makeSessionString())},GPKISecureWeb.makeSessionString=function(){for(var a="",b="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",c=0;20>c;c++)a+=b.charAt(Math.floor(Math.random()*b.length));return a},GPKISecureWeb.getOS=function(){try{var a=navigator.userAgent;return a=a.toUpperCase(),-1!=a.indexOf("NT 5.1")?"windows XP":-1!=a.indexOf("NT 6.0")?"windows vista":-1!=a.indexOf("NT 6.1")?"windows 7":-1!=a.indexOf("NT 6.2")?"windows 8":-1!=a.indexOf("NT 6.3")?"windows 8.1":-1!=a.indexOf("NT 10.0")?"windows 10":-1!=a.indexOf("IPAD")?"IOS":-1!=a.indexOf("ANDROID")?"Android":-1!=a.indexOf("BLACKBERRY")?"BlackBerry":-1!=a.indexOf("MAC")?"MAC":-1!=a.indexOf("SYMBIAN")?"Symbian":-1!=a.indexOf("UBUNTU")?-1!=a.indexOf("86_64")?"UBUNTU64":"UBUNTU32":-1!=a.indexOf("FEDORA")?-1!=a.indexOf("86_64")?"FEDORA64":"FEDORA32":-1!=a.indexOf("LINUX")?-1!=a.indexOf("86_64")?"LINUX64":"LINUX32":"Unknown"}catch(b){return"Unknown"}},GPKISecureWeb.InstallCheck=function(){var a=(GPKISecureWeb.setSessionTimeout,GPKISecureWeb.makeJsonMessage("InitCheck"));try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a),c=JSON.parse(b);return 0===c.ResultCode&&GPKISecureWeb.setCookie("GPKISecureWebSetupStatus","1",1),c}catch(d){return GPKISecureWebLog.log("GPKISecureWeb.InstallCheckError : [ "+d.message+" ]["+d.code+" ]"),{ResultCode:-1666,ResultMessage:d.name}}},GPKISecureWeb.Login=function(a,b){var c=GPKISecureWeb.makeJsonMessage("Login",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return GPKISecureWebLog.log("GPKISecureWebLog.LoginError :  [ "+f.message+" ]["+f.code+" ]"),f.code}},GPKISecureWeb.EnvelopedSignData=function(a,b){var c=GPKISecureWeb.makeJsonMessage("EnvelopedSignData",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return GPKISecureWebLog.log("GPKISecureWeb.EnvelopedSignDataError :  [ "+f.message+" ]["+f.code+" ]"),f.code}},GPKISecureWeb.EnvelopData=function(a,b){var c=GPKISecureWeb.makeJsonMessage("EnvelopData",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return GPKISecureWebLog.log("GPKISecureWeb.EnvelopDataError :  [ "+f.message+" ]["+f.code+" ]"),f.code}},GPKISecureWeb.EncryptedSignData=function(a,b,c){var d=GPKISecureWeb.makeJsonMessage("EncryptedSignData",a,b,c);try{var e=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,d),f=JSON.parse(e);return f.ResultCode}catch(g){return GPKISecureWebLog.log("GPKISecureWeb.EncryptedSignDataError :  [ "+g.message+" ]["+g.code+" ]"),g.code}},GPKISecureWeb.SignedData=function(a,b){var c=GPKISecureWeb.makeJsonMessage("SignedData",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return GPKISecureWebLog.log("GPKISecureWebLog.SignedDataError :  [ "+f.message+" ]["+f.code+" ]"),f.code}},GPKISecureWeb.SignedDataWithVIDCheck=function(a,b,c,d){var e=GPKISecureWeb.makeJsonMessage("SignedDataWithVIDCheck",a,c,d);try{var f=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,e),g=JSON.parse(f);return g.ResultCode}catch(h){return GPKISecureWebLog.log("GPKISecureWebLog.SignedDataWithVIDCheckError :  [ "+h.message+" ]["+h.code+" ]"),h.code}},GPKISecureWeb.Encrypt=function(a,b){var c=GPKISecureWeb.makeJsonMessage("Encrypt",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return GPKISecureWebLog.log("GPKISecureWeb.EncryptError :  [ "+f.message+" ]["+f.code+" ]"),f.code}},GPKISecureWeb.Decrypt=function(a,b){var c=GPKISecureWeb.makeJsonMessage("Decrypt",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return GPKISecureWebLog.log("GPKISecureWeb.DecryptError :  [ "+f.message+" ]["+f.code+" ]"),f.code}},GPKISecureWeb.SetSessionID=function(a){var b=GPKISecureWeb.makeJsonMessage("SetSessionID",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.GPKILink=function(a){if(0!=GPKISecureWeb.initFlag&&(GPKISecureWebUi.InitCheck(),0!=GPKISecureWeb.initFlag))return!1;var b="",c="";return a.protocol.indexOf("http:")<-1?(alert(ErrorMessage.code70005),!0):a.search.length<1?(alert(ErrorMessage.code70006),!1):(b="http://"+a.hostname+":"+a.port+"/"+a.pathname,c=a.search.substring(a.search.lastIndexOf("?")+1,a.search.length))},GPKISecureWeb.SetSearchFile=function(a,b){var a=GPKISecureWeb.encodeUtf8andBase64(a),c=GPKISecureWeb.makeJsonMessage("SetSearchFile",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return f.code}},GPKISecureWeb.GetFileCount=function(a){var b=GPKISecureWeb.makeJsonMessage("GetFileCount",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return 0==d.ResultCode?d.ResultValue:d.ResultCode}catch(e){return e.code}},GPKISecureWeb.GetFileList=function(a,b){var c=GPKISecureWeb.makeJsonMessage("GetFileList",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c);return d}catch(e){return e.code}},GPKISecureWeb.getAPIVersion=function(){var a=GPKISecureWeb.makeJsonMessage("GetAPIVersion");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a),c=JSON.parse(b);return c.ResultMessage}catch(d){return d.code}},GPKISecureWeb.SetMediaType=function(a){var b=GPKISecureWeb.makeJsonMessage("SetMediaType",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.GetMediaSubCount=function(){var a=GPKISecureWeb.makeJsonMessage("GetMediaSubCount");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a),c=JSON.parse(b);return 0==c.ResultCode?c.ResultValue:c.ResultCode}catch(d){return d.code}},GPKISecureWeb.GetMediaSubInfo=function(a){var b=GPKISecureWeb.makeJsonMessage("GetMediaSubInfo",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b);return c}catch(d){return d.code}},GPKISecureWeb.SetPFXPath=function(a,b){var c=GPKISecureWeb.makeJsonMessage("SetPFXPath",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return f.code}},GPKISecureWeb.GetCertCount=function(a){var b=GPKISecureWeb.makeJsonMessage("GetCertCount",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return 0==d.ResultCode?d.ResultValue:d.ResultCode}catch(e){return e.code}},GPKISecureWeb.GetCertListInfo=function(a){var b=GPKISecureWeb.makeJsonMessage("GetCertListInfo",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b);return c}catch(d){return d.code}},GPKISecureWeb.SetPINNumber=function(a){var b=GPKISecureWeb.makeJsonMessage("SetPINNumber",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.LoadCertList=function(a){var b=GPKISecureWeb.makeJsonMessage("LoadCertList",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.SelectCert=function(a,b){var c=GPKISecureWeb.makeJsonMessage("SelectCert",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c),e=JSON.parse(d);return e.ResultCode}catch(f){return f.code}},GPKISecureWeb.SelectCertKeyboard=function(a,b,c){var d=GPKISecureWeb.makeJsonMessage("SelectCert",a,b,c);try{var e=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,d),f=JSON.parse(e);return f.ResultCode}catch(g){return g.code}},GPKISecureWeb.GetCertNormalInfo=function(a){var b=GPKISecureWeb.makeJsonMessage("GetCertNormalInfo",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b);return c}catch(d){return d.code}},GPKISecureWeb.GetCertDetailField=function(a,b){var c=GPKISecureWeb.makeJsonMessage("GetCertDetailField",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c);return d}catch(e){return e.code}},GPKISecureWeb.GetCertDetailInfo=function(a,b){var c=GPKISecureWeb.makeJsonMessage("GetCertDetailInfo",a,b);try{var d=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,c);return d}catch(e){return e.code}},GPKISecureWeb.GetMediaType=function(){var a=GPKISecureWeb.makeJsonMessage("GetMediaType");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a);return b}catch(c){return c.code}},GPKISecureWeb.GetCertDN=function(){var a=GPKISecureWeb.makeJsonMessage("GetCertDN");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a);return b}catch(c){return c.code}},GPKISecureWeb.GetCertSerialNum=function(){var a=GPKISecureWeb.makeJsonMessage("GetCertSerialNum");try{var b=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,a);return b}catch(c){return c.code}},GPKISecureWeb.SetPointInit=function(a,b,c){var d=GPKISecureWeb.makeJsonMessage("SetPointInit",a,b,c);try{var e=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,d),f=JSON.parse(e);return f.ResultCode}catch(g){return g.code}},GPKISecureWeb.SetPoint=function(a){var b=GPKISecureWeb.makeJsonMessage("SetPoint",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.setServerEncoding=function(a){var b=GPKISecureWeb.makeJsonMessage("setServerEncoding",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.setClientEncoding=function(a){var b=GPKISecureWeb.makeJsonMessage("setClientEncoding",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.SetServerEncoding=function(a){var b=GPKISecureWeb.makeJsonMessage("SetServerEncoding",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}},GPKISecureWeb.SetClientEncoding=function(a){var b=GPKISecureWeb.makeJsonMessage("SetServerEncoding",a);try{var c=GPKISecureWebAjax.request(CsUrl+CsPort+"/",!0,b),d=JSON.parse(c);return d.ResultCode}catch(e){return e.code}};var gfNextFunc,gfNextParameters=new Array,mkdummy=0;GPKISecureWeb.makeJsonMessage=function(a){var b="",c=arguments.length-1;if(!(0>c)){for(b+="{",b+='"Version":"'+Version+'",',b+='"ServiceID":"'+ServiceID+'",',b+='"SessionTimeout":"'+setSessionTimeout+'",',b+=""===GPKISecureWeb.getCookie("GPKISecureWebSession")?'"SessionID":"'+GPKISecureWeb.getCookie("NONEID")+'",':'"SessionID":"'+GPKISecureWeb.getCookie("GPKISecureWebSession")+'",',b+=0===c?'"MessageID":"'+a+'"':'"MessageID":"'+a+'",',i=0;i<c;i++)b+=i+1==c?'"'+i+'":"'+arguments[i+1]+'"':'"'+i+'":"'+arguments[i+1]+'",';return b+="}"}},GPKISecureWeb.createJsonMessage=function(a,b){var c="",d="";return d=""===GPKISecureWeb.getCookie("GPKISecureWebSession")?GPKISecureWeb.getCookie("NONEID"):GPKISecureWeb.getCookie("GPKISecureWebSession"),"CrossCertification"==a?(c={Version:Version,ServiceID:"GPKISecureWeb",SessionID:sessionid,MessageID:a},JSON.stringify(c)):"isValidCertVID"==a?(c={Version:Version,ServiceID:"GPKISecureWeb",SessionID:sessionid,binyIDN:b.binyIDN,MessageID:a},JSON.stringify(c)):void 0},GPKISecureWeb.getBrowser=function(){var a="";try{var b,c=navigator.userAgent,d=c.toLowerCase();return d.indexOf("edge")>-1?(a="Edge"+d.substr(d.indexOf("edge")+4,3),a=a.replace("/"," ")):(M=c.match(/(OPR|edge|opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i)||[],/trident/i.test(M[1])&&(b=/\brv[ :]+(\d+)/g.exec(c)||[],a="IE "+(b[1]||"")),"Chrome"===M[1]&&(b=c.match(/\bOPR\/(\d+)/),null!==b)?a="Opera "+b[1]:(M=M[2]?[M[1],M[2]]:[navigator.appName,navigator.appVersion,"-?"],null!==(b=c.match(/version\/(\d+)/i))&&M.splice(1,1,b[1]),a=M.join(" "),a.toLowerCase()))}catch(e){return GPKISecureWebpLog.log("[ getBrowser ][ error ][ "+e.message+" ]"),""}},GPKISecureWeb.createGPKISecureWebSessionID();*/
GPKISecureWebLog = new Object();
GPKISecureWebLog.logType = "";
GPKISecureWebLog.log = function( text ){
	if( GPKISecureWebLog.logType == "console" ){
		console.log( text );
	}else if( GPKISecureWebLog.logType == "alert" ){
		alert( text );
	}
};

function createStandardXHR() {
	try {
		return new window.XMLHttpRequest();
	} catch( e ) {
		GPKISecureWebLog.log("GPKISecureWeb.createStandardXHR :  [ " + e.message + " ][" + e.code +" ]" );
	}
}

function createActiveXHR() {
	try {
		return new window.ActiveXObject( "Microsoft.XMLHTTP" );
	} catch( e ) {
		GPKISecureWebLog.log("GPKISecureWeb.createActiveXHR :  [ " + e.message + " ][" + e.code +" ]" );
	}
}
var GPKISecureWebAjax = {};
GPKISecureWebAjax.xhr = window.ActiveXObject !== undefined ?function() {return GPKISecureWeb.AjaxLocal && createStandardXHR() || createActiveXHR(); } : createStandardXHR;
GPKISecureWebAjax.request = function( url, sync, data, callbackFunction ){
	try{
		var xmlHttpRequest = GPKISecureWebAjax.xhr();
		var syncType = !sync;		
		xmlHttpRequest.open("POST", url, syncType);
		xmlHttpRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xmlHttpRequest.send(data);
		
		if( sync === false){
			xmlHttpRequest.onreadystatechange = function(){
				if( xmlHttpRequest.readyState == 4){
					if( xmlHttpRequest.status == 200){
						callbackFunction( xmlHttpRequest.responseText, 0 );
					} else {
						callbackFunction( xmlHttpRequest.statusText, xmlHttpRequest.status );
					} 
				}
			};
		}else if( sync === true){
			if( xmlHttpRequest.readyState == 4){
				if( xmlHttpRequest.status == 200 ){
					return xmlHttpRequest.responseText;
				} else {
					GPKISecureWebLog.log( "GPKISecureWebAjaxError", "AJAX Failed : [ xmlHttpRequest.statusText ][ " + xmlHttpRequest.statusText + " ][xmlHttpRequest.readyState][ "+xmlHttpRequest.readyState + " ]" );
				}
			} else {
				GPKISecureWebLog.log( "GPKISecureWebAjaxError", "AJAX Failed : [ xmlHttpRequest.statusText ][ " + xmlHttpRequest.statusText + " ][xmlHttpRequest.readyState][ "+xmlHttpRequest.readyState + " ]" );
			}
		}
	}catch( e ){
		GPKISecureWebLog.log( "GPKISecureWebAjaxError", "AJAX Failed : [ xmlHttpRequest.statusText ][ " + xmlHttpRequest.statusText + " ][xmlHttpRequest.readyState][ "+xmlHttpRequest.readyState + " ]", xmlHttpRequest.status );
	}
}

GPKISecureWeb.encodeUtf8andBase64 = function (input) {
	var _base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
	var line = '';
	var output = '';
	var chr1, chr2, chr3;
	var i = 0;

	input = unescape(encodeURIComponent(input));
	//R = (n + 2 - ((n + 2) % 3)) / 3 * 4
	maxline = (input.length + 2 - ((input.length + 2) % 3)) / 3 * 4;

	while(i < input.length) {
		chr1 = input.charCodeAt(i++);
		chr2 = input.charCodeAt(i++);
	    chr3 = input.charCodeAt(i++);
	    
	    // encode 4 character group
	    line += _base64.charAt(chr1 >> 2);
	    line += _base64.charAt(((chr1 & 3) << 4) | (chr2 >> 4));
	    
	    if(isNaN(chr2)) {
	    	line += '==';
	    }else {
	    	line += _base64.charAt(((chr2 & 15) << 2) | (chr3 >> 6));
	    	line += isNaN(chr3) ? '=' : _base64.charAt(chr3 & 63);
	    }

	    if(maxline && line.length > maxline) {
	    	output += line.substr(0, maxline) + '\r\n';
	    	line = line.substr(maxline);
	    }
	}
	
	output += line;
	
	return output;
};
GPKISecureWeb.InitCheck = function(){
	var message = GPKISecureWeb.makeJsonMessage("InitCheck");	
	try{
		var data = GPKISecureWebAjax.request( CsUrl + CsPort+"/", true, message );
		var obj =""; 
		obj = 	JSON.parse(data);
		return obj.ResultCode;
	}catch( e ){
		return e.code;
	}
}
GPKISecureWeb.SetProperty = function(binyOptional, binyValue){
	var message = GPKISecureWeb.makeJsonMessage("SetProperty", binyOptional, binyValue);	
	try{
		var data = GPKISecureWebAjax.request( CsUrl + CsPort+"/", true, message );
		var obj = JSON.parse(data);
		return obj.ResultCode;
	}catch( e ){
		GPKISecureWebLog.log("GPKISecureWeb.SetPropertyError :  [ " + e.message + " ][" + e.code +" ]" );
		return e.code;
	}
}

GPKISecureWeb.Init = function() {
	var message = GPKISecureWeb.makeJsonMessage("Init");		
	try{
		var data = GPKISecureWebAjax.request( CsUrl + CsPort+"/", true, message );
		var obj = JSON.parse(data);
		return obj.ResultCode;
	}catch( e ){
		GPKISecureWebLog.log("GPKISecureWeb.InitError :  [ " + e.message + " ][" + e.code +" ]" );
		return e.code;
	}
}

GPKISecureWeb.UnInit = function() {
	var message = GPKISecureWeb.makeJsonMessage("UnInit");		
	try{
		var data = GPKISecureWebAjax.request( CsUrl + CsPort+"/", true, message );
		var obj = JSON.parse(data);
		return obj.ResultCode;
	}catch( e ){
		GPKISecureWebLog.log("GPKISecureWeb.UnInitError :  [ " + e.message + " ][" + e.code +" ]" );
		return e.code;
	}
}

GPKISecureWeb.GetReturnData = function(){
	var message = GPKISecureWeb.makeJsonMessage("GetReturnData");
	try{
		var data = GPKISecureWebAjax.request( CsUrl + CsPort+"/", true, message );
		//var obj = JSON.parse(data);
		return data;
	}catch( e ){
		GPKISecureWebLog.log("GPKISecureWeb.GetReturnDataError :  [ " + e.message + " ][" + e.code +" ]" );
		return e.code;
	}
}

GPKISecureWeb.setCookie = function(cname, cvalue, exdays) {
	var d = new Date();
	d.setTime ( d.getTime() + ( exdays * 24 * 60 * 60 * 1000) );
	var expires = "expires="+d.toUTCString();
	if( exdays === 0 ){
		document.cookie = cname + "=" + cvalue + "; path=/; ";
	} else {
		document.cookie = cname + "=" + cvalue + "; " + expires+"; path=/;";
	}
}

GPKISecureWeb.getCookie = function(cname) {
	if( isCookie === "true"){
		var name = cname + "=";
		var ca = document.cookie.split(';');
		for(var i=0; i<ca.length; i++) {
			var c = ca[i];
		   while (c.charAt(0)===' ') c = c.substring(1);
			if (c.indexOf(name) === 0) return c.substring(name.length,c.length);
		}
		return "";
	}else{
		if( cname === "GPKISecureWebSession"){
			return session;
		}else{
			return "";
		}
	}
}

GPKISecureWeb.trim = function(x) {
	x = x + "";
	x = x.replace(/^\s+|\s+$/gm, '');
	x = x.replace(/[\r][\n]/g, '');
	x = x.replace(/[\x10][\x13]/g, '');
    return x;
}

GPKISecureWeb.createGPKISecureWebSessionID = function(){
	if( isCookie === "true"){
		sessionid = GPKISecureWeb.getCookie("GPKISecureWebSession");
		if( sessionid === ""){
			GPKISecureWeb.setCookie("GPKISecureWebSession", GPKISecureWeb.makeSessionString() , 0 );
		}
	}else{
		if( sessionid == "" ){
			sessionid = GPKISecureWeb.makeSessionString();
		}
	}
}

GPKISecureWeb.makeSessionString = function(){
	var text = "";
	var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	for( var i=0; i < 20; i++ ){
		text += possible.charAt(Math.floor(Math.random() * possible.length));
	}
	return text;
}

GPKISecureWeb.getOS = function(){
	try{
		var OsVersion = navigator.userAgent;
		OsVersion = OsVersion.toUpperCase();
		if( OsVersion.indexOf("NT 5.1") != -1 )	     {return "windows XP";}
		else if( OsVersion.indexOf("NT 6.0") != -1 ) {return "windows vista";}
		else if( OsVersion.indexOf("NT 6.1") != -1 ) {return "windows 7";}
		else if( OsVersion.indexOf("NT 6.2") != -1 ) {return "windows 8";}
		else if( OsVersion.indexOf("NT 6.3") != -1 ) {return "windows 8.1";}
		else if( OsVersion.indexOf("NT 10.0") != -1 ){return "windows 10";}
		else if( OsVersion.indexOf("MAC") != -1 ) 	 {return "MAC";}
		else if( OsVersion.indexOf("SYMBIAN") != -1 ){return "Symbian";}
		else if( OsVersion.indexOf("UBUNTU") != -1 ) {
			if( OsVersion.indexOf("86_64") != -1 ){
				return "UBUNTU64";
			}else{
				return "UBUNTU32";
			}
		}else if( OsVersion.indexOf("FEDORA") != -1 ){
			if( OsVersion.indexOf("86_64") != -1 ){
				return "FEDORA64";
			}else{
				return "FEDORA32";
			}
		}
		else if( OsVersion.indexOf("LINUX") != -1 ){
			if( OsVersion.indexOf("86_64") != -1 ){
				return "LINUX64";
			}else{
				return "LINUX32";
			}
		}
		else return "Unknown";
	}catch( ex ) {
		return "Unknown";
	}
}
//=========================================================================================================================================
//=========================================================================================================================================

GPKISecureWeb.GPKILink = function( link ){	
	/*if(GPKISecureWeb.initFlag != 0){
		GPKISecureWebUi.InitCheck();
		if(GPKISecureWeb.initFlag != 0){
			return false;
		}
	}*/
	var action = "";
	var queryString = "";
	var noenc_qs = "";
	var strResult ="";
	var strCode = ""
	var strMsg = ""
	
	if ( link.protocol.indexOf("http:") <-1 ){
		//alert("http 프로토콜이 아닙니다.");
		alert(ErrorMessage.code70005);
		return true;
	}
	if (link.search.length < 1){
		//alert("링크 정보가 없습니다.");
		alert(ErrorMessage.code70006);
		return false;
	}
	action = "http://" + link.hostname + ":" + link.port + "/" + link.pathname;
	queryString = link.search.substring( link.search.lastIndexOf('?') + 1, link.search.length);
	//link.href = action + "?";	
	return queryString;
}

//=========================================================================================================================================================
function makeQueryString( form, isEmbedded ){

	if(isEmbedded){
		form = document.getElementById("popForm");
	}
	
	var name  =  new Array(form.elements.length); 
	var value =  new Array(form.elements.length); 
	var flag  = false;
	var j     = 0;
	var plain_text ="";

	len = form.elements.length; 
	
	for (i = 0; i < len; i++){

		if( (form.elements[i].type != "button") && (form.elements[i].type != "reset") && (form.elements[i].type != "submit") ){
			if (form.elements[i].type == "radio" || form.elements[i].type == "checkbox"){ 
				if (form.elements[i].checked == true){
					name[j] = form.elements[i].name; 
					value[j] = encodeURIComponent(form.elements[i].value);
					j++;
				}
			}else {
				name[j] = form.elements[i].name; 
				if (form.elements[i].type == "select-one"){
					var ind = form.elements[i].selectedIndex;
					if (form.elements[i].options[ind].value != ''){
						value[j] = form.elements[i].options[ind].value;
					}else{
						value[j] = encodeURIComponent(form.elements[i].options[ind].text);
					}
				}else{
					value[j] = form.elements[i].value;
				}
				j++;
			}
		}
	}

	for (i = 0; i < j; i++){
		if (flag){
			plain_text += "&";
		}else{
			flag = true;
		}
		plain_text += name[i] ;
		plain_text += "=";
		plain_text += (name[i]!='challenge')?encodeURIComponent(value[i]):value[i];
	}
	return plain_text;
}

function replaceEscapeString( qureyString ){
	var i;
	var ch;
	var rstring = '';
	var qstring = '';

	qstring = String(qureyString);
	for (i = 0; i < qstring.length; i++){
		ch = qstring.charAt(i);

		if (ch == ' ')  rstring += '%20';
		else 
		if (ch == '%')  rstring += '%25';
		else 
		if (ch == '&')  rstring += '%26';
		else 
		if (ch == '+')  rstring += '%2B';
		else 
		if (ch == '=')  rstring += '%3D';
		else 
		if (ch == '?')  rstring += '%3F';
		else rstring += ch;
	}

	return rstring;
}

function embeddedEnterEvent(event){
	if (event.keyCode == 13){
		LoginEmbedded(document.getElementById("popForm"));
		return false;
	}
	
}
function vKSetPointInit(session,params,isInit){
	var start = params.indexOf('<gpki');
	var endTag = '</gpki:ENCRYPTED DATA>';
	var end = params.indexOf(endTag)+endTag.length;
	
	var orgEncData = params.substring(start,end);
	
	var orgEncDatas = new Array();
	orgEncDatas = orgEncData.split("+ ");
	orgEncData="";
	for(var i=0; i<orgEncDatas.length;i++){
		var tmp= orgEncDatas[i].replace("'","");
		tmp=tmp.replace(/(^\s*)|(\s*$)/gi, "");
		orgEncData += tmp.replace("\n","");			
	}	
	
	GPKISecureWeb.SetPointInit(session,orgEncData,isInit);
}

function vKSetPoint(params){
	GPKISecureWeb.SetPoint(params);
}

var mkdummy = 0;


function showPHPVKeyboard(target){
    var base64Img = decodeURIComponent(urlBase64Image);
    target.src = "data:image/jpeg;base64,"+base64Img ;
}

function initSecureSession(){
	var initResult = GPKIClientJS.Init();
	if(initResult != 0){
		alert(GPKIClientJS.ErrCode.AXERR_FAILINITALIZE.message);
		return false;
	}

	GPKIClientJS.SetProperty(2, ServerCert);
	GPKIClientJS.SetProperty(3, 3);
	GPKIClientJS.SetProperty(4, 4);

	//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
	GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
	GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
	
	var setSID = GPKIClientJS.SetSessionID(sessionid);
	var resEnc = GPKIClientJS.Encrypt(SiteID+sessionid, '111')
	if( (setSID == 0) && (resEnc == 30053) ){
		location.href = "./requestSecureSession." + serverLangExt + "?rnd=" + sessionid;
	}
}

function addPageExt(){
	var currentUrl = window.location.href;
	var target ;
	
	if(currentUrl.indexOf('\.aspx')>-1){
		target = 'aspx';
	}else if(currentUrl.indexOf('\.asp')>-1){
		target = 'asp';		
	}else if(currentUrl.indexOf('\.php')>-1){
		target = 'php';	
	}else{
		target = 'jsp';
	}
	
	return target;
}

function replaceServerScriptExt(){

	$("#gpkilink").find("a").each( function() {

		if ($(this).attr("href").indexOf(".html") < 0) {
			var linkrul = $(this).attr("href");
			$(this).attr("href", serverLangExt + "/" + linkrul + "." + serverLangExt);
		}
	} );
}

GPKISecureWeb.makeJsonMessage = function(FuncName){	
	var message = '';
	var args = arguments.length - 1;
	
	if( args<0) return;
	
	message += '{';
	message+='"gpki_authkey":"'+ConfigObject.GPKIJS_LIC+'",';
	message += '"Version":"'	+ Version + '",';
	message += '"ServiceID":"'	+ ServiceID + '",';
	message += '"SessionTimeout":"' + setSessionTimeout + '",';
	if( GPKISecureWeb.getCookie( "GPKISecureWebSession" ) === ""){
		message += '"SessionID":"'	+ GPKISecureWeb.getCookie( "NONEID" ) + '",';
	}else{
		message += '"SessionID":"'	+ GPKISecureWeb.getCookie("GPKISecureWebSession") + '",';
	}
	
	
	if( args === 0){
		message += '"MessageID":"'	+ FuncName 	+ '"';
	}else{
		message += '"MessageID":"'	+ FuncName 	+ '",';
	}
	
	for (i=0; i<args; i++){
		if( i+1 == (args)){
			message += '"' + i + '":"' + arguments[i+1] + '"';
		}else{
			message += '"' + i + '":"' + arguments[i+1] + '",';
		}
	}
	message += '}';
	
	return message;
}

GPKISecureWeb.createJsonMessage = function( code, data ){
	var message = "";
	var sid = ""
	if( GPKISecureWeb.getCookie( "GPKISecureWebSession" ) === ""){
		sid = GPKISecureWeb.getCookie( "NONEID" );
	}else{
		sid = GPKISecureWeb.getCookie("GPKISecureWebSession");
	}
	if( code == "CrossCertification" ){
		message = {
			Version		:	Version,
			ServiceID	:	"GPKISecureWeb",
			SessionID	:	sessionid,
			MessageID : code
		};
		return JSON.stringify( message );
	}else if( code == "isValidCertVID" ){
		message = {
			Version		:	Version,
			ServiceID	:	"GPKISecureWeb",
			SessionID	:	sessionid,
			binyIDN : data.binyIDN,
			MessageID : code
		};
		return JSON.stringify( message );
	}
};

function replaceLtRt(data){
	if (aspxXSSvalidate && data != null && serverLangExt == "jsp") {
		data = data.replace(/</gi, '_');
		data = data.replace(/>/gi, '_');
	}
	return $.trim(data);
}

function postSignedDataToServer(data) {
	if(vidCheck !=0 || data == null || data ==""){
		return false;
	}
	document.gpkiForm.encryptedData.value=data;
	document.gpkiForm.method="post";
	document.gpkiForm.action="./createSecureSession_1_1_response." + serverLangExt;
	document.gpkiForm.submit();
}

GPKISecureWeb.getBrowser = function(){
	var GPKISecureWebBrowser="";
	try{
		var ua= navigator.userAgent, tem;
		var ualow = ua.toLowerCase(); 
		
		if( ualow.indexOf("edge")>-1){
			GPKISecureWebBrowser = "Edge"+ualow.substr(ualow.indexOf("edge")+4,3);
			GPKISecureWebBrowser = GPKISecureWebBrowser.replace("/"," ");
			return GPKISecureWebBrowser;
		}else{
			M= ua.match(/(OPR|edge|opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
			
			if( /trident/i.test(M[1])){
				tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
				GPKISecureWebBrowser = 'IE '+(tem[1] || '');
			}
			if( M[1]=== 'Chrome'){
				tem= ua.match(/\bOPR\/(\d+)/);
				if( tem!== null){
					GPKISecureWebBrowser = 'Opera '+tem[1];
					 return GPKISecureWebBrowser;
				}
			}
			M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
			if( (tem= ua.match(/version\/(\d+)/i))!== null){
				M.splice(1, 1, tem[1]);
			} 
			GPKISecureWebBrowser =  M.join(' ');
			return GPKISecureWebBrowser.toLowerCase();
		}
	}catch( ex ){
		GPKISecureWebpLog.log("[ getBrowser ][ error ][ "+ex.message+" ]");
		return "";
	}
}




function gpkiReload(){
	GPKIClientJS.gpkiReload();
}
;
GPKISecureWeb.createGPKISecureWebSessionID();
