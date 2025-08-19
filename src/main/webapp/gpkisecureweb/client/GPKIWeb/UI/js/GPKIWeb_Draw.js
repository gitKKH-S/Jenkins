var GPKISecureWebDraw = {
	selectMedia : "",
/* 휴대전화 인증서 목록 이름 정의(인증서 선택창에서 휴대전화 선택시 노출되는 목록)
 */
//--------------------------
	TITLE_MOB_SVC_UBIKEY : $.i18n.prop("TS064"),
	TITLE_MOB_SVC_UBIKEYNX : $.i18n.prop("TS096"),
	TITLE_MOB_SVC_DREAMCS : $.i18n.prop("TS066"),
//--------------------------
/* 각 스토리지별 CS 설치 진행 메시지 정의
 */
//-------------------------
	MSG_MOB_INSTALL     : $.i18n.prop("ES033"),
	MSG_MOB_CANCEL      : $.i18n.prop("ES034"),
	MSG_MOB_UPDATE      : $.i18n.prop("ES035"),

	MSG_SMT_INSTALL     : $.i18n.prop("ES036"),
	MSG_SMT_FAIL        : $.i18n.prop("ES037"),

	MSG_MOB_SIGN_INSTALL : $.i18n.prop("ES038"),
	MSG_MOB_SIGN_CANCEL  : $.i18n.prop("ES039"),
	MSG_MOB_SIGN_UPDATE  : $.i18n.prop("ES040"),
	
	//210806 추가
	MSG_TOKEN_INSTALL	 : $.i18n.prop("ES085"),
	
//-------------------------
/* 경고 메시지 정의
 */
//-------------------------
	MSG_ALERT_LOWER_IE9 : $.i18n.prop("ES041"),
//-------------------------

/* 스토리지 선책창을 만드는 HTML 태그들을 정의 
 * '.value.' 부분은 스크립트에서 동적으로 처리
 * */
//------------------------
	// web
	STG_HTML_WEB      : "<li class='ML_storage_browser'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01' title='브라우저'><span id='MSG_TS701'></span></a></li>",
	//pfx
	STG_HTML_PFX      : "<li class='ML_storage_sch'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01'><span id='MSG_TS702'></span></a></li>",
	STG_HTML_PFX_IE   : "<li class='ML_storage_sch'><a href='#' id='.id_key.' stgIdx='.idx.'><span id='MSG_TS702' class='stg_01'></span></a></li>",
	STG_HTML_PFX_INS  : "<li class='ML_storage_sch ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;)'><span id='MSG_TS702' class='stg_01'></span></a></li>",
	//hdd
	STG_HTML_HDD      : "<li class='ML_storage_hdd'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01' title='하드디스크/이동식'><span id='MSG_TS703'></span></a></li>",
	STG_HTML_HDD_INS  : "<li class='ML_storage_hdd ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;)' class='stg_01' title='하드디스크/이동식'><span id='MSG_TS703'></span></a></li>",
	//shdd
	STG_HTML_SDD      : "<li class='ML_storage_shdd'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01'><span id='MSG_TS704'></span></a></li>",
	STG_HTML_SDD_INS  : "<li class='ML_storage_shdd ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;)' class='stg_01'><span id='MSG_TS704'></span></a></li>",
	//token
	STG_HTML_TKN      : "<li class='ML_storage_token'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01' title='보안토큰'><span id='MSG_TS705'></span></a></li>",
	STG_HTML_TKN_INS  : "<li class='ML_storage_token ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;)' class='stg_01' title='보안토큰'><span id='MSG_TS705'></span></a></li>",
	//mobile
	STG_HTML_MOB      : "<li class='ML_storage_phone'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01' title='휴대전화'><span id='MSG_TS706'></span></a></li>",
	STG_HTML_MOB_INS  : "<li class='ML_storage_phone ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;);' class='stg_01' title='휴대전화'><span id='MSG_TS706'></span></a></li>",
	//smartcert 
	STG_HTML_SMC      : "<li class='ML_storage_smartcert'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01' title='스마트인증'><span id='MSG_TS707'></span></a></li>",
	STG_HTML_SMC_INS  : "<li class='ML_storage_smartcert ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;);' class='stg_01' title='스마트인증'><span id='MSG_TS707'></span></a></li>",
	STG_HTML_SMC_MGMT : "<li class='ML_storage_smartcert off'><a href='#' style='cursor:default;' stgIdx='.idx.' class='stg_01'><span id='MSG_TS707'></span></a></li>",
	//smartcertnx 
	STG_HTML_SMCNX	  : "<li class='ML_storage_smartcert'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01' title='스마트인증'><span id='MSG_TS707'></span></a></li>",
	STG_HTML_SMCNX_INS: "<li class='ML_storage_smartcert ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;);' class='stg_01' title='스마트인증'><span id='MSG_TS707'></span></a></li>",

	//cloud
	STG_HTML_CLD      : "<li class='ML_storage_cloud'><a href='#' id='.id_key.' stgIdx='.idx.' class='stg_01' title='클라우드'><span id='MSG_TS708'></span></a></li>",
	STG_HTML_CLD_INS  : "<li class='ML_storage_cloud ins'><a href='#' stgIdx='.idx.' onClick='installCheck(&#34;.mode.&#34;);' class='stg_01' title='클라우드'><span id='MSG_TS708'></span></a></li>",
//--------------------------


/* UI 스크립트를 여기서 일괄 호출 
 * 기존 InitEventHadnler() 는  GPKIWeb_Main.js 에서 처리
 * */
	initDraw : function(isEmbedded) {
		
		// 인증서 선택 창 그리기
		GPKISecureWebDraw._createWindow(isEmbedded);
			
		// 메시지 초기화
		MessageVO.applyMessage($('[id^="MSG_"]'));
		
		//key event 
		$(this).keydown(function(e){
			if(e.keyCode == "9"){
				var targetElement = $(document.activeElement).attr("id");
				var parentElement = $(document.activeElement).parent().attr("id");
				//console.log("targetElement.id === " + targetElement);
				//console.log("parentElement.id === " + parentElement);
	
				if(targetElement == "stg_smartcert" ){
					var selection = $("#dataTable").MLjquiDataTable('getSelection');
					if(selection && selection.length>0){

					}else{

					}
				} else if(targetElement == "btn_cancel" ){
					$(".ML_storage_area>ul>li:first-child").focus();
				} else if(targetElement == "btn_file_cs" ){
					$("#import_pfx_password").focus();
				} else if(targetElement == "file_route" ){
	
				} else if(targetElement == null || targetElement == 'undefined'){
					
				}
			}else if (e.keyCode == "27"){
				console.log("Esc keydown Esc keydown Esc keydown Esc keydown");
			}
		});
	
		// Slide L&R Button
		$(".customNavigation").click(function(){
			var X=$(this).attr('id');
			if(X==1){
				$(this).children(".str_add_li").removeClass('pr');
				$(this).children(".str_add_li").addClass('ne');
				$(this).attr('id', '0');
	
				$("#wrap_stg_01").animate({left:"0px"}, 250);
				$("#wrap_stg_02").animate({left:"375px"}, 250);
			}else{
				$(".str_add_li").attr('class', 'str_add_li pr');
				$(this).children(".str_add_li").removeClass('ne');
				$(this).children(".str_add_li").addClass('pr');
				$(".customNavigation").attr('id', '0');
				$(this).attr('id', '1');
				
				$("#wrap_stg_01").animate({left:"-375px"}, 250);
				$("#wrap_stg_02").animate({left:"0px"}, 250);
			}
		});
	
		$(".stg_01").focus(function(){
			$("#wrap_stg_01").animate({left:"0px"}, 250);
			$("#wrap_stg_02").animate({left:"375px"}, 250);
			$(".customNavigation").children(".str_add_li").removeClass('pr');
			$(".customNavigation").children(".str_add_li").addClass('ne');
			$(".customNavigation").attr('id', '0')
		});
	
		$(".stg_02").focus(function(){
			$("#wrap_stg_01").animate({left:"-375px"}, 250);
			$("#wrap_stg_02").animate({left:"0px"}, 250);
			$(".customNavigation").children(".str_add_li").removeClass('ne');
			$(".customNavigation").children(".str_add_li").addClass('pr');
			$(".customNavigation").attr('id', '1')
		});
			},
	loadCSS : function(isEmbedded){
		var os_ver = GPKISecureWebApi.getProperty("os");
		var dt_height = "";
		var currentOS = gpkiSecureUtil.getOS();
		for( var i = 0; i < GPKISecureWebApi.webConfig.storageList.length; i++){
			if( GPKISecureWebApi.webConfig.storageList[i] === "smartcertnx" ) {
				if(!document.getElementById('smartcertnx')){
					var head = document.getElementsByTagName('head')[0];
					var script = document.createElement('script');
					script.type= 'text/javascript';
					script.id = "smartcertnx";
					var webSmartCertURL = GPKISecureWebApi.getProperty("web_smartcert_url");
					if(webSmartCertURL == null || typeof(webSmartCertURL) == 'undefined' || webSmartCertURL == ""){
						script.src = "https://cdn.smartcert.kr/SmartCertWeb/API/js/jSmartCertNP2.js";
					}else{
						script.src = webSmartCertURL;
					}
					head.appendChild(script);
				}
			}
			else if( GPKISecureWebApi.webConfig.storageList[i] === "mobile" ) {
				if(GPKISecureWebApi.MobileOption.indexOf("ubikeynx") > -1){
					if(!document.getElementById("ubikeynx")){
						var head = document.getElementsByTagName('head')[0];
						var script = document.createElement('script');
						script.type= 'text/javascript';
						script.id = "ubikeynx";
						var csUbikeyURL = GPKISecureWebApi.getProperty("cs_ubikey_url");
						if(csUbikeyURL == null || typeof(csUbikeyURL) == 'undefined' || csUbikeyURL == ""){
							script.src = "/UBikeyWeb/js/infovineHTML.js";
						}else{
							script.src = csUbikeyURL;
						}
						head.appendChild(script);
					}
				}
			}
		}
		
		if(GPKISecureWebApi.getProperty("storageList").indexOf("web_kftc") > -1 || GPKISecureWebApi.getProperty("storageList").indexOf("kftc") > -1 || GPKISecureWebApi.getProperty("storageList").indexOf("web") > -1){
			if( GPKISecureWebApi.webConfig.virtualKeyboardType === "RAON" ){
				if (document.createStyleSheet){
					document.createStyleSheet(contextPath + '/raonsecure/transkey/transkey.css');
				}else{
					$('head').append( $('<link rel="stylesheet" type="text/css" />').attr('href', contextPath + '/raonsecure/transkey/transkey.css' ) );
				}
				$.cachedScript( contextPath + "/raonsecure/transkey/rsa_oaep_files/rsa_oaep-min.js" ).done(function(){
					$.cachedScript( contextPath + "/raonsecure/transkey/jsbn/jsbn-min.js" ).done(function(){
						$.cachedScript( contextPath + "/raonsecure/transkey/TranskeyLibPack_op.js" ).done(function(){
							$.cachedScript( contextPath + "/raonsecure/transkey/transkey.js" ).done(function(){
								if(typeof initTranskey=="function") initTranskey();				
							});
						});
					});
				});
			}else if( GPKISecureWebApi.webConfig.virtualKeyboardType === "NSHC" ){	
				$.cachedScript( contextPath + "/nfilter/js/include_open_nFilter.js" ).done(function(){
					initializedNFilter();	
				});
			}else if( GPKISecureWebApi.webConfig.virtualKeyboardType === "INCA" ){
				$.cachedScript( contextPath + "/pluginfree/js/nppfs-1.11.0.js" ).done(function(){
					npPfsCtrl.hideLoading();
					npPfsStartup(null, false, false, false, true, "npkencrypt", "on");
				});
			}
		}else{
			if( GPKISecureWebApi.webConfig.useVirtualKeyboard ){
				if( GPKISecureWebApi.webConfig.virtualKeyboardType === "RAON" ){
					if (document.createStyleSheet){
						document.createStyleSheet(contextPath + '/raonsecure/transkey/transkey.css');
					}else{
						$('head').append( $('<link rel="stylesheet" type="text/css" />').attr('href', contextPath + '/raonsecure/transkey/transkey.css' ) );
					}
					$.cachedScript( contextPath + "/raonsecure/transkey/rsa_oaep_files/rsa_oaep-min.js" ).done(function(){
						$.cachedScript( contextPath + "/raonsecure/transkey/jsbn/jsbn-min.js" ).done(function(){
							$.cachedScript( contextPath + "/raonsecure/transkey/TranskeyLibPack_op.js" ).done(function(){
								$.cachedScript( contextPath + "/raonsecure/transkey/transkey.js" ).done(function(){
									if(typeof initTranskey=="function") initTranskey();				
								});
							});
						});
					});
				}else if( GPKISecureWebApi.webConfig.virtualKeyboardType === "NSHC" ){	
					$.cachedScript( contextPath + "/nfilter/js/include_open_nFilter.js" ).done(function(){
						initializedNFilter();	
					});
				}else if( GPKISecureWebApi.webConfig.virtualKeyboardType === "INCA" ){
					$.cachedScript( contextPath + "/pluginfree/js/nppfs-1.11.0.js" ).done(function(){
						npPfsCtrl.hideLoading();
						npPfsStartup(null, false, false, false, true, "npkencrypt", "on");
					});
				}
			}
		}
	},
	/*
	 * 인증서 선택창을 그리는 함수
	 */
	_createWindow : function(isEmbedded) {
		
		if( ! GPKISecureWebApi.getProperty("banner") ){
			$(".ML_cp_AD").remove();
		}
		
		var window_height = 558;
		var window_width = 418;
		var popupWidth = document.body.clientWidth;
		var os_ver = GPKISecureWebApi.getProperty("os");
		var jqxWidget = $('#ML_window');
		var offset = jqxWidget.offset();
		var xValue = offset.left + (($(window).width()/2)-(window_width/2));
		
		var position = { x: xValue, y: offset.top + 50};
		var popupPosition =  {x: offset.left + ($(window).width()/2) - 178, y: offset.top + 180};

		if(isEmbedded){
			position = { x: xValue, y: offset.top};
			popupPosition =  {x: offset.left + ($(window).width()/2) - 193.5, y: offset.top};
		}
		
		popupWidth = 398;
		
		//-00. Main
		$("#ML_window").MLjquiWindow({
			title: $.i18n.prop("TS000"),
			resizable: false,
			position: position,
			showCloseButton:false,
			isModal: true,
			modalOpacity: 0,
			modalZIndex: 9995,
			modalBackgroundZIndex: 9995,
			showCollapseButton: false,
			keyboardCloseKey: 0,
			maxHeight: 600, maxWidth:720,
			minHeight: 200, minWidth: 200,
			height: window_height, width: window_width,
			initContent: function () {
				$('#ML_window').MLjquiWindow('focus');
			}
		});
	
		$('#popup_alert').MLjquiWindow({
			title: $.i18n.prop("TS042"),
			resizable: false,
			position: popupPosition,
			showCloseButton:false,
			zIndex:9999,
			showCollapseButton: false,
			keyboardCloseKey: 0,
			isModal: true,
			maxHeight: 600, maxWidth:420,
			minHeight: 200, minWidth: 200,
			height: 148, width: popupWidth,
			initContent: function () {
				$('#popup_alert').MLjquiWindow('close');
			}
		});
		
		$('#popup_server_info').MLjquiWindow({
			title: '서버 저장소 관리하기 - 신원확인',
			resizable: false,
			position: popupPosition,
			showCloseButton:false,
			zIndex:9999,
			showCollapseButton: false,
			keyboardCloseKey: 0,
			isModal: true,
			maxHeight: 600, maxWidth:420,
			minHeight: 200, minWidth: 200,
			height: 380, width: popupWidth,
			initContent: function () {
				$('#popup_server_info').MLjquiWindow('close');
			}
		});
	
		//-02. Common
		//$('#ML_Dialog_common').show();
		$('#ML_Dialog_common').MLjquiWindow({
	//		autoOpen: false,
	//		title:'비밀번호변경',
			resizable: false,
			//position: 'center',
			position: popupPosition,
			showCloseButton:false,
	//		closeButtonSize: 35,
	//		closeButtonAction:'close',
	//		draggable:false,
			isModal: true,
			modalOpacity: 0.3,
			modalZIndex: 9996,
			keyboardCloseKey: 0,
			modalBackgroundZIndex: 9996,
			showCollapseButton: false,
			width: popupWidth,
			initContent: function () {
				$('#ML_Dialog_common').MLjquiWindow('close');
			}
		});
		$('#ML_Dialog_common_sub').MLjquiWindow({
	//		autoOpen: false,
	//		title:'비밀번호변경',
			resizable: false,
			//position: 'center',
			position: popupPosition,
			showCloseButton:false,
	//		closeButtonSize: 35,
	//		closeButtonAction:'close',
	//		draggable:false,
			isModal: true,
			modalOpacity: 0.3,
			modalZIndex: 9996,
			keyboardCloseKey: 0,
			modalBackgroundZIndex: 9996,
			showCollapseButton: false,
			width: popupWidth,
			initContent: function () {
				$('#ML_Dialog_common_sub').MLjquiWindow('close');
			}
		});
		
		//-03. Cs install dialog
		$('#ML_dialog_cs_install').MLjquiWindow({
			resizable: false,
			//position: 'center',
			position: popupPosition,
			showCloseButton:false,
			isModal: false,
			modalOpacity: 0.3,
			modalZIndex: 9996,
			keyboardCloseKey: 0,
			modalBackgroundZIndex: 9996,
			showCollapseButton: false,
			width: popupWidth,
			initContent: function () {
				$('#ML_dialog_cs_install').MLjquiWindow('close');
			}
		});
		GPKISecureWebUI.blockUI();
	},

	initWebMainEvent : function(isEmbedded) {
		GPKISecureWebLog.log("GPKIWeb_Draw.js - initWebMainEvent() called...");
		
		//인증서 선택창 스토리지 선택
		$('[id^="stg_"]').click(function () {
			var stg_id = this.id.split("stg_")[1];
			//GPKISecureWebLog.log("storage selected.... storageId = "+stg_id)
			selectMedia = stg_id;
			
			if(stg_id == "web" || stg_id == "kftc" || stg_id == "web_kftc"){
				// 브라우저 안내 옵션 처리
				if(isEmbedded){
					$("#ML_window").css('width', '418px');
				}else if(GPKISecureWebApi.getProperty('browserNoticeShow')){
					$("#ML_window").css('width', '668px');
				}else{
					$("#ML_window").css('width', '418px');
				}			
				$("#get_cert").html($.i18n.prop("TS035"));	
				$("#out_cert").html($.i18n.prop("TS098"));	
				$("#con_cert").html($.i18n.prop("TS099"));	
				
				//서버저장소 정보 없을 시 버튼 hide 처리 start
				if(ConfigObject.IframeServer == ""){
					$("#in_browser").css('width', '195px');
					$("#out_browser").css('width', '195px');
					$("#con_browser").hide();
				}else{
					$("#in_browser").css('width', '130px');
					$("#out_browser").css('width', '130px');
					$("#con_browser").css('width', '130px');
					$("#con_browser").show();					
				}
				//서버저장소 정보 없을 시 버튼 hide 처리 end
				$("#in_browser").show();
				$("#out_browser").show();
				
				if(stg_id == "web_kftc"){

					var kftcRelayURL 	= GPKISecureWebApi.getProperty("kftc_script_url_relay");
					var kftcOpenCertURL = GPKISecureWebApi.getProperty("kftc_script_url_opencert");
					var kftcCorpCode 	= GPKISecureWebApi.getProperty("kftc_corp_code");
					
					var opencertURL = ""; 
					var relayURL = ""; 
					var today = new Date();
					today = GPKISecureWebUtil.yyyymmdd(today);
					
					if( kftcRelayURL != "" && kftcOpenCertURL != "" && kftcCorpCode != ""){
						opencertURL = kftcOpenCertURL + "?dt=" + today + "&corp=" + kftcCorpCode;
						relayURL = kftcRelayURL + "?dt=" + today + "&corp=" + kftcCorpCode;
					}else{
						opencertURL = "https://fidoweb.yessign.or.kr:3100/v2/opencert.js?dt=" + today + "&corp=099";
						relayURL = "https://fidoweb.yessign.or.kr:3100/v2/relay.js?dt=" + today + "&corp=099";
					}
					
					if(!document.getElementById('opencerturl') || !document.getElementById('relayurl')){
						var head = document.getElementsByTagName('head')[0];
						var scriptOpenCert = document.createElement('script');
						scriptOpenCert.type= 'text/javascript';
						scriptOpenCert.id = "opencerturl";
						scriptOpenCert.src = opencertURL;
						head.appendChild(scriptOpenCert);
						
						var scriptRelay = document.createElement('script');
						scriptRelay.type= 'text/javascript';
						scriptRelay.id = "relayurl";
						scriptRelay.src = relayURL;
						head.appendChild(scriptRelay);
					}
					
					if( GPKISecureWebApi.webConfig.virtualKeyboardType === "INCA" ){
						var npLength = npVCtrl.keypadObject.length;
						if(npLength > 1){
							for (var i=0; i<npLength; i++){
								if("nppfs-keypad-input_cert_pw" == npVCtrl.keypadObject[i]._uuid){
									npVCtrl.keypadObject.splice(i,1);
									break;
								}
							}
						}
					}
				}
				
				if( !GPKISecureWebApi.webConfig.useVirtualKeyboard && GPKISecureWebApi.webConfig.virtualKeyboardType === "INCA" ){
					$('#input_cert_pw_new').hide();
					$('#input_cert_pw').show();
					$('#keyboardOn').show();
				}
				
			}else{
				$("#ML_window").css('width', '418px');
				// 공인인증서 가져오기 문구 css
				$("#get_cert").html($.i18n.prop("TS035"));
				$("#out_cert").html($.i18n.prop("TS098"));	
				$("#con_cert").html($.i18n.prop("TS099"));		
				$("#in_browser").css('width', '130px');
				$("#out_browser").css('width', '130px');
				$("#con_browser").css('width', '130px');
				
				$("#in_browser").hide();
				$("#out_browser").hide();
				$("#con_browser").hide();
				
				if( !GPKISecureWebApi.webConfig.useVirtualKeyboard && GPKISecureWebApi.webConfig.virtualKeyboardType === "INCA" ){
					$('#input_cert_pw').hide();
					$('#keyboardOn').hide();
					if(!document.getElementById('input_cert_pw_new')){
						$('#input_cert_pw').after("<input type='password' id='input_cert_pw_new' class='passwd_input' placeholder='비밀번호를 입력하시오.' onKeypress='signEnterKeyEvent(event)' onClick='newPasswdClick();' >");
					}else{
						$('#input_cert_pw_new').show();
					}
					
					// CapsLock
					var browser = GPKISecureWebApi.getProperty('browser');
					if((browser != 'MSIE 8') && (browser != 'MSIE 7') && (browser != 'MSIE 6')) {
						document.querySelector('#input_cert_pw_new').addEventListener('keyup', checkCapsLock);
						document.querySelector('#input_cert_pw_new').addEventListener('mousedown', checkCapsLock);
					}
					
					$('#input_cert_pw_new').blur(function(e){
						$("#capslock").hide();
					});
				}
				
				if( GPKISecureWebApi.webConfig.useVirtualKeyboard ){
					if( GPKISecureWebApi.webConfig.virtualKeyboardType === "INCA" ){
						var npLength = npVCtrl.keypadObject.length;
						if(npLength > 1){
							for (var i=0; i<npLength; i++){
								if("nppfs-keypad-input_cert_pw" == npVCtrl.keypadObject[i]._uuid){
									npVCtrl.keypadObject.splice(i,1);
									break;
								}
							}
						}
					}
				}
			}
			
			// 브라우저 안내 옵션 처리
			if(GPKISecureWebApi.getProperty('browserNoticeShow')){
				GPKISecureWebDraw.browser_menu(isEmbedded);
			}
		
			if(stg_id == "token"){
				$("#ML_dp_04").text($.i18n.prop("TS037"));
			}else{
				$("#ML_dp_04").text($.i18n.prop("TS038"));
			}
			
			//UI driver 선택창 위치 조정
			var stg_idx = $(this).attr("stgIdx");
			$('#driver_div').removeClass("pos_01").removeClass("pos_02").removeClass("pos_03").removeClass("pos_04").removeClass("pos_05");
			$('#driver_div').addClass("pos_0"+stg_idx);
	
			//UI css selection 처리
			$('[class^="ML_storage_"]').removeClass("on");
			$(this).parent().addClass("on");
	
			//인증서 목록 무조건 초기화
			GPKISecureWebDraw.MakeCertiListDiv(null);
			
			//UI 웹 접근성 : 선택된 인증서 title에 "선택됨" 문자열 추가
			$('li[class^="ML_storage_"] a').each((_, el) => {
				if(el != null && el != undefined) el.title = el.title.replaceAll(" 선택됨", "");
			});
			if($(this)[0] != null && $(this)[0] != undefined) $(this)[0].title = $(this)[0].title + " 선택됨";
			
			// 드라이버 선택창 닫기
			closeDriverDialog();
	
			//스토리지 정보 조회

			setTimeout(function(){
				GPKISecureWebUI.selectStorageInfo(stg_id, function(resultCode, jsonObj){
					//GPKISecureWebLog.log("[Callback]selectStorage()  .... resultCode === "+resultCode);
					if( resultCode == 0) {
						if(jsonObj == null || $.isEmptyObject(jsonObj)){
							var certOpt = {"storageName":stg_id};
							
							if(stg_id=="smartcert" && GPKISecureWebApi.getProperty("smartcert_type")!='C'){
								// WEB SmartCert 구동
								$('#btn_confirm').onclick();
								return;
							}else{
								GPKISecureWebUI.getStorageCertList(certOpt, function(resultCode, jsonObj) {
									if( resultCode == 0) {//성공
										//GPKISecureWebLog.log("[getStorageCertList() callback === " + JSON.stringify(jsonObj));
										GPKISecureWebDraw.MakeCertiListDiv(jsonObj.cert_list);
									}else{	//실패
										GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + jsonObj.errCode);
										
										GPKISecureWebDraw.MakeCertiListDiv(null);
									}
								});
							}
						} else {
							GPKISecureWebLog.log("[SUCCESS!!!] Select Drive. === " + stg_id);
							
							openDriverDialog(stg_id, stg_idx, jsonObj);
						}
					} else{
						
						GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + jsonObj.errCode + ", errMsg === " +  jsonObj.errMsg);
						
						//210806 추가
						/*if(stg_id == "token" && jsonObj.errCode == 30004){
							
							GPKISecureWebDraw.confirm(GPKISecureWebDraw.MSG_TOKEN_INSTALL, function( code, obj ){
								$("#btn_common_confirm").unbind();
								$("#btn_common_cancle").unbind();
								
								if( code == 0 ){
									var width = screen.availHeight;
									var height = screen.availHeight;
									window.open(ConfigObject.TOKEN_DOWNLOAD_URL,'_blank','scrollbars=no,toolbar=no,resizable=no, width='+ width +', height='+ height);
								}
							});
						}*/
						
						EmptyCertDiv();
					}
				});
			},200);
			
		});
		
		$(document).on("click", function(event, isEmbedded){

			var targetId = event.target.id;
			if($("#sub_drv_list").length > 0){
				closeDriverDialog();
			}
			if(targetId.substring(0,4) == "stg_" || targetId == ""){
				$('#stg_'+selectMedia).focus();
			}
			if(targetId == "manual_close"){
				$("#manual_img").removeAttr("tabindex");
				$("#manual_close").removeAttr("tabindex");
				$("#browser_manual").attr("style", "display:none");
				$("#ML_window").css('width', '418px');
			}else{
				if($("#sub_drv_list").length > 0){
					if(targetId == "MSG_TS701" || targetId == "stg_web"){
						$("#browser_manual").attr("style", "display:inline");	
						if(isEmbedded){
							$("#ML_window").css('width', '418px');
						}else if(GPKISecureWebApi.getProperty('browserNoticeShow')){
							$("#ML_window").css('width', '668px');
						}else{
							$("#ML_window").css('width', '418px');
						}						
					}else if(targetId == "MSG_TS703" || targetId == "MSG_TS705" || targetId == "MSG_TS706" || targetId == "MSG_TS707" || targetId == "stg_hdd" || targetId == "stg_token" || targetId == "stg_mobile" || targetId == "stg_smartcert"){
						$("#manual_img").removeAttr("tabindex");
						$("#manual_close").removeAttr("tabindex");
						$("#manual_close").attr("style", "display:none");
						$("#ML_window").css('width', '418px');
					}
					/*if(targetId == "MSG_TS703" || targetId == "MSG_TS705"|| targetId == "MSG_TS706" || targetId == "MSG_TS707"){
						$("#manual_close").attr("style", "display:none");
						$("#ML_window").css('width', '418px');
					}else if(targetId == "MSG_TS701"|| targetId == "stg_web"){
						$("#browser_manual").attr("style", "display:inline");
						$("#ML_window").css('width', '668px');
					}*/
				}
			}
		});	
	
	},
	
/*
 * 브라우저 인증서 선택시 선택창 옆에 나오는 안내 이미지 출력 함수
 * 브라우저 인증서 선택시에만 버튼 출력 (21.08.26) 수정
 */
	browser_menu : function(isEmbedded) {
		
		if(isEmbedded){
			//Embedded가 true일 경우에는 화면에 보여주지 않음 
		}else{
			if(selectMedia == "web"){
				$("#btn_browser_manual").css("display", "block"); 
				$("#browser_manual1").css("display", "block");
				$("#manual_close").attr("tabindex", "0");
			}else{
				$("#btn_browser_manual").css("display", "none");
				$("#browser_manual1").css("display", "none");
				//$("#manual_close").attr("tabindex", "-1");
			}
			
		}
		
	},

/*
 * 기존 Main.js 에 있던 인증서 선택창에서 스토리지 목록을 만드는 함수
 */
/*
viewoptObj.defaultStorage;
viewoptObj.storageList; //[]
viewoptObj.installcheck;
viewoptObj.updatecheck;
viewoptObj.browserInfo;
*/
	MakeStorageListDiv : function(obj) {
		var default_stg = obj.defaultStorage;
		var isCsInstall = obj.installcheck;
		var isCsUpdate = obj.updatecheck;
		var stgArr = obj.storageList;
		var browser = obj.browserInfo;
		
		//210818 windows가 아닐 경우에는 브라우저 인증만 보이도록 수정
		var os_ver = GPKISecureWebApi.getProperty("os"); // windows x, MAC, UBUNTU64, UBUNTU32, FEDORA64, FEDORA32
		if(os_ver.indexOf('windows') == -1){
			stgArr = ["web"];
		}
		
		stgHtml = '	<div id="wrap_stg_01" class="ML_storage_area">';
		stgHtml += '		<ul>';
		
		if(stgArr != null && stgArr.length > 0){
			
			//목록그리기
			var stg_length = stgArr.length < 5 ? stgArr.length : 5;
			var id_key = "stg_";
			var mode = "main";
			
			if(stgArr.length < 6){
				$(".ML_storage_box_sub").css("margin-left","11px"); 
				$(".customNavigation").css("display","none"); 
			}
			
			for(var i=0; i<stg_length; i++){
				
				var idx = i+1;
				
				switch(stgArr[i]){
				
				// 스토리지 종류 별로 미리 정의된 html 태그를 replace
				case 'web_kftc': 
					stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", id_key + "web_kftc").replace(".idx.", idx);	
					break;
				case 'kftc': 
					stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", id_key + "kftc").replace(".idx.", idx);	
					break;
				case 'web': 
					stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", id_key + "web").replace(".idx.", idx);	
					break;
				case 'pfx':
					if(browser != "MSIE 9" && browser != "MSIE 8" && browser != "MSIE 7" && browser != "MSIE 6"){
						stgHtml += GPKISecureWebDraw.STG_HTML_PFX.replace(".id_key.", id_key + "pfx").replace(".idx.", idx);
					}else if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_PFX_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_PFX_IE.replace(".id_key.", id_key + "pfx").replace(".idx.", idx);
					}
					break;
				case 'hdd':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_HDD_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_HDD.replace(".id_key.", id_key + "hdd").replace(".idx.", idx);
					}
					break;
				case 'shdd':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_SDD_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_SDD.replace(".id_key.", id_key + "shdd").replace(".idx.", idx);
					}
					break;
				case 'token':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_TKN_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_TKN.replace(".id_key.", id_key + "token").replace(".idx.", idx);
					}
					break;
				case 'mobile':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_MOB_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_MOB.replace(".id_key.", id_key + "mobile").replace(".idx.", idx);
					}
					break;
				case 'smartcert':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_SMC_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_SMC.replace(".id_key.", id_key + "smartcert").replace(".idx.", idx);
					}
					break;
				case 'smartcertnx':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_SMCNX_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_SMCNX.replace(".id_key.", id_key + "smartcertnx").replace(".idx.", idx);
					}
					break;
				case 'cloud':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_CLD_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_CLD.replace(".id_key.", id_key + "cloud").replace(".idx.", idx);
					}
					break;
				} // end of switch
					
			} // end of for
			
			if(stgArr.length > 5){
				//stgHtml += '		</ul>';
				//stgHtml += '	</div>';
				//stgHtml += '</div>';
				//stgHtml += '	<div id="wrap_stg_02" class="ML_storage_area">';
				//stgHtml += '		<ul>';
				
				for(var idx=5; idx<stgArr.length; idx++){
					
					switch(stgArr[i]){
						case 'web_kftc': 
							stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", id_key + "web_kftc").replace(".idx.", idx);	
							break;
						case 'kftc': 
							stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", id_key + "kftc").replace(".idx.", idx);	
							break;
						case 'web': 
							stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", id_key + "web").replace(".idx.", idx);	
							break;
						case 'pfx':
							if(browser != "MSIE 9" && browser != "MSIE 8" && 
							   browser != "MSIE 7" && browser != "MSIE 6"){
								stgHtml += GPKISecureWebDraw.STG_HTML_PFX.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}else if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_PFX_INS.replace(".idx.", id_key).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_PFX_IE.replace(".id_key.", id_key + "pfx").replace(".idx.", idx);
							}
							break;
						case 'hdd':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_HDD_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_HDD.replace(".id_key.", id_key + "hdd").replace(".idx.", idx);
							}
							break;
						case 'shdd':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_SDD_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_SDD.replace(".id_key.", id_key + "shdd").replace(".idx.", idx);
							}
							break;
						case 'token':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_TKN_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_TKN.replace(".id_key.", id_key + "token").replace(".idx.", idx);
							}
							break;
						case 'mobile':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_MOB_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_MOB.replace(".id_key.", id_key + "mobile").replace(".idx.", idx);
							}
							break;
						case 'smartcert':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_SMC_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_SMC.replace(".id_key.", id_key + "smartcert").replace(".idx.", idx);
							}
							break;
						case 'smartcertnx':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_SMCNX_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_SMCNX.replace(".id_key.", id_key + "smartcertnx").replace(".idx.", idx);
							}
							break;
						case 'cloud':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_CLD_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_CLD.replace(".id_key.", id_key + "cloud").replace(".idx.", idx);
							}
							break;
						} // end of switch
					} // end of for
					
				} // end of if(stgArr.length >5)\
			
			}else{ 
				// 목록 없음
				stgHtml += '<li class="">'+$.i18n.prop("TS084")+'</li>';
			}
		
		stgHtml += '		</ul>';
		stgHtml += '	</div>';
		stgHtml += '</div>';
		document.getElementById('MLstrSlide').innerHTML = stgHtml;
		
		$("#dataTable").MLjquiDataTable({
			theme:"DSdatatable",
			width: "398",
			height: "150",
			columnsHeight:25,
			altRows: true, // 행 백그라운드 교차 //
			autoRowHeight: false,
			sortable: true,
			pageable: false,
			enableHover: true,
			columnsResize: true,
			selectionMode: "singleRow",
			columns: [
				{ text: $.i18n.prop("TS059"), dataField: 'Cn', width: 140, align: 'center' },
				{ text: $.i18n.prop("TS060"), dataField: 'Policy', width: 100, align: 'center' },
				{ text: $.i18n.prop("TS061"), dataField: 'Issuer', cellsAlign: 'left', align: 'center', cellsFormat: 'c2' },
				{ text: $.i18n.prop("TS062"), dataField: 'enddate', width: 78, cellsAlign: 'left', align: 'center', cellsFormat: 'd'}
			],
			ready:function(){
				$("#dataTable").MLjquiDataTable('selectRow', 0);
			}
		});
		
		//메세지 처리 적용.
		MessageVO.applyMessage($('[id^="MSG_"]'));
	},	
	
	MakeStorageListDiv_old : function(mode) {
		GPKISecureWebLog.log("GPKIWeb_Draw.js - MakeStroageListDiv() called....");
		
		var isCsInstall = GPKISecureWebApi.getProperty("is_cs_install");
		var isCsUpdate = GPKISecureWebApi.getProperty("is_cs_update");
		var smartcertType = GPKISecureWebApi.getProperty("smartcert_type");
		var libType = GPKISecureWebApi.getProperty("libType");
		
		var os_ver = GPKISecureWebApi.getProperty("os"); // windows x, MAC, UBUNTU64, UBUNTU32, FEDORA64, FEDORA32
		
		var stgArr = [];
		
		if(os_ver.indexOf('windows') == -1){
			GPKISecureWebApi.setProperty("storageList",["web","hdd"]);
		}
		if(mode == "mgmt"){
			stgArr = GPKISecureWebApi.getProperty("storageListMgmt");
		}else{
			stgArr = GPKISecureWebApi.getProperty("storageList");
		}
		
		stgHtml = '	<div id="wrap_stg_01" class="ML_storage_area">';
		stgHtml += '		<ul>';
		
		
		if(stgArr != null && stgArr.length > 0){
			
			//목록그리기
			var stg_length = stgArr.length < 5 ? stgArr.length : 5;
			var id_key = (mode=="main") ? "stg_" : "stg_admin_";
			var browser = GPKISecureWebApi.getProperty('browser');
			
			if(stgArr.length < 6){
				$(".ML_storage_box_sub").css("margin-left","11px"); 
				$(".customNavigation").css("display","none"); 
			}
			
			for(var i=0; i<stg_length; i++){
				
				var idx = i+1;
				
				switch(stgArr[i]){
				
				// 스토리지 종류 별로 미리 정의된 html 태그를 replace
				case 'web': 
						stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", id_key + "web").replace(".idx.", idx);	
						break;
				case 'pfx':
						if(browser != "MSIE 9" && browser != "MSIE 8" && browser != "MSIE 7" && browser != "MSIE 6"){
							stgHtml += GPKISecureWebDraw.STG_HTML_PFX.replace(".id_key.", id_key + "pfx").replace(".idx.", idx);
						}else if(!isCsInstall || isCsUpdate){
							stgHtml += GPKISecureWebDraw.STG_HTML_PFX_INS.replace(".idx.", idx).replace(".mode.", mode);
						}else{
							stgHtml += GPKISecureWebDraw.STG_HTML_PFX_IE.replace(".id_key.", id_key + "pfx").replace(".idx.", idx);
						}
						break;
				case 'hdd':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_HDD_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_HDD.replace(".id_key.", id_key + "hdd").replace(".idx.", idx);
					}
					break;
				case 'shdd':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_SDD_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_SDD.replace(".id_key.", id_key + "shdd").replace(".idx.", idx);
					}
					break;
				case 'token':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_TKN_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_TKN.replace(".id_key.", id_key + "token").replace(".idx.", idx);
					}
					break;
				case 'mobile':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_MOB_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_MOB.replace(".id_key.", id_key + "mobile").replace(".idx.", idx);
					}
					break;
				case 'smartcert':
					if(!isCsInstall || isCsUpdate){
						stgHtml += GPKISecureWebDraw.STG_HTML_SMC_INS.replace(".idx.", idx).replace(".mode.", mode);
					}else{
						stgHtml += GPKISecureWebDraw.STG_HTML_SMC.replace(".id_key.", id_key + "smartcert").replace(".idx.", idx);
					}
					break;
				case 'cloud':
					stgHtml += GPKISecureWebDraw.STG_HTML_CLD;
					break;
				} // end of switch
					
			} // end of for
			
			if(stgArr.length > 5){
				stgHtml += '		</ul>';
				stgHtml += '	</div>';
				stgHtml += '</div>';
				//stgHtml += '<div class="item">';
				stgHtml += '	<div id="wrap_stg_02" class="ML_storage_area">';
				stgHtml += '		<ul>';
				
				for(var idx=5; idx<stgArr.length; idx++){
					
					switch(stgArr[i]){
						case 'web': 
							stgHtml += GPKISecureWebDraw.STG_HTML_WEB.replace(".id_key.", idx + "web").replace(".idx.", idx);	
							break;
						case 'pfx':
							if(browser != "MSIE 9" && browser != "MSIE 8" && 
							   browser != "MSIE 7" && browser != "MSIE 6"){
								stgHtml += GPKISecureWebDraw.STG_HTML_PFX.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}else if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_PFX_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_PFX_IE.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}
							break;
						case 'hdd':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_HDD_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_HDD.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}
						case 'shdd':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_SDD_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_SDD.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}
						case 'token':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_TKN_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_TKN.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}
						case 'mobile':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_MOB_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_MOB.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}
						case 'smartcert':
							if(!isCsInstall || isCsUpdate){
								stgHtml += GPKISecureWebDraw.STG_HTML_SMC_INS.replace(".idx.", idx).replace(".mode.", mode);
							}else{
								stgHtml += GPKISecureWebDraw.STG_HTML_SMC.replace(".id_key.", idx + "pfx").replace(".idx.", idx);
							}
						case 'cloud':
							stgHtml += GPKISecureWebDraw.STG_HTML_CLD;
							break;
						} // end of switch
					} // end of for
					
				} // end of if(stgArr.length >5)\
			
			}else{ 
				// 목록 없음
				stgHtml += '<li class="">'+$.i18n.prop("TS084")+'</li>';
			}
		
		stgHtml += '		</ul>';
		stgHtml += '	</div>';
		stgHtml += '</div>';
		document.getElementById('MLstrSlide').innerHTML = stgHtml;
		
		//메세지 처리 적용.
		MessageVO.applyMessage($('[id^="MSG_"]'));
		
	},


/*
 * GPKIWeb_Main.js 에서 옮겨옴. 인증서 목록을 출력하는 함수
 */
	MakeCertiListDiv : function(listObj) {
		//GPKISecureWebLog.log("MakeCertiListDiv() called... listObj === " + JSON.stringify(listObj));
	
		//비번입력창 활성화/비활성화
		if(listObj != null && listObj.length > 0){
			$("#input_cert_pw").val('').prop("disabled",false);
			$("#keyboardOn").css({ 'pointer-events': 'auto' });
			if(document.getElementById('input_cert_pw_new')){
				$("#input_cert_pw_new").val('').prop("disabled",false);
				$("#keyboardOn").css({ 'pointer-events': 'auto' });
			}
		} else {
			$("#input_cert_pw").val('').prop("disabled",true);
			$("#keyboardOn").css({ 'pointer-events': 'none' });
			if(document.getElementById('input_cert_pw_new')){
				$("#input_cert_pw_new").val('').prop("disabled",true);
				$("#keyboardOn").css({ 'pointer-events': 'none' });
			}
		}
		
		var source = makeSourceData(listObj);
		var dataAdapter = new $.MLjqui.dataAdapter(source);
	
		var os_ver = GPKISecureWebApi.getProperty("os");
		var dt_height = "";
		
		$("#dataTable").MLjquiDataTable({
			theme:"DSdatatable",
			width: "398",
			height: "150",
			columnsHeight:25,
			altRows: true, // 행 백그라운드 교차 //
			autoRowHeight: false,
			sortable: true,
			pageable: false,
			source: dataAdapter,
			enableHover: true,
			columnsResize: true,
			selectionMode: "singleRow",
			columns: [
				{ text: $.i18n.prop("TS059"), dataField: 'Cn', width: 140, align: 'center',
					cellsRenderer: function (row, column, value, rowData) {
						var image = "<div style='display:inline-block; padding-right:5px;'>";

						var imgurl = '';
						var isExpired = GPKISecureWebUtil.isDateExpired(rowData.enddatetime);
						if(isExpired){
							imgurl = 'UI/images/icon_cert_expire.png';
						}else{
							var rowEndDate = rowData.enddatetime;
							var a = rowEndDate.split(" ");
							var d = a[0].split("-");
							var t = a[1].split(":");
							var endDate = new Date(d[0],(d[1]-1),d[2],t[0],t[1],t[2]);
							var today = new Date();
							if (today < endDate) {
								diff = Math.floor(( Date.parse(endDate) - Date.parse(today) ) / 86400000);
								if(diff < 31){
									//시계 이미지
									imgurl = 'UI/images/icon_cert_expiring.png';
								}else{
									imgurl = 'UI/images/icon_cert_default.png';
								}
							}
						}
						if(typeof(rowData.cloud) != "undefined"){
							if(rowData.cloud){
								imgurl = 'UI/images/cert_selected_in_cloud.png';
							}
						}

						var img = '<img width="16" height="16" style="display:block;" src="' + imgurl + '" alt=""/>';
						image += img;
						var tooltip = "</div><span style='vertical-align:top; padding-top:2px;' title='" + rowData.Cn + "'>" + rowData.Cn + "</span>";
						return image+=tooltip;
					}
				},
				{ text: $.i18n.prop("TS060"), dataField: 'Policy', width: 100, align: 'center',
					cellsRenderer: function (row, column, value, rowData) {

						var image = "<div style='display:inline-block; padding-right:5px;'>";

						var imgurl = '';
						var isExpired = GPKISecureWebUtil.isDateExpired(rowData.enddatetime);
						if(isExpired){
							imgurl = 'UI/images/icon_cert_expire.png';
						}else{
							imgurl = 'UI/images/icon_cert_default.png';
						}
						image += "</div><span style=' vertical-align:top; padding-top:2px;' title='" + rowData.Policy + "'>" + rowData.Policy + "</span>";
						//var img = '<img width="16" height="16" style="display:block;" src="' + imgurl + '"/>';
						//image += img;
						//image += "</div><span style='display:inline-block; vertical-align:top; padding-top:2px;'>" + rowData.Policy + "</span>";
						//image += "</div><span style='display:inline-block; vertical-align:top; padding-top:2px;' title='" + rowData.Policy + "'>" + rowData.Policy + "</span>";
						return image;
					}
				},
				{ text: $.i18n.prop("TS061"), dataField: 'Issuer', cellsAlign: 'left', align: 'center', cellsFormat: 'c2' },
				{ text: $.i18n.prop("TS062"), dataField: 'enddate', width: 78, cellsAlign: 'left', align: 'center', cellsFormat: 'd',
					cellsrenderer : function(row, column, value, rowData) {
						var enddateSpan = "";
						enddateSpan = "<span style='vertical-align:top; padding-top:2px;'>" + rowData.enddate + "</span>";
						enddateSpan += "<input type='hidden' id='rowEnddate' value='" + rowData.enddatetime + "'>";
						return enddateSpan;
					}
				}
			],
			ready:function(){
				if(listObj != null && listObj.length > 0){
					$("#dataTable").MLjquiDataTable('selectRow', 0);
				}
			}
		});
	
		if (listObj!=null && $.isEmptyObject($("#dataTable").MLjquiDataTable('selectRow')) && listObj.length>0){
			$("#dataTable").MLjquiDataTable('selectRow', 0);
		}
		
		// 인증서 만료일 한달전에 해당 인증서 마우스 오버시 유효기간 공지 
		$("#dataTable tbody").on("mouseover", "tr", function(event){
			var selection = $("#dataTable").MLjquiDataTable('getSelection');
			var selectionCnt = selection.length;
			
			if( selection && selectionCnt > 0 ){
				var diff = '';
				//선택한 row의 enddate 갖고오기
				var rowEndDate = $(this).find('input[type="hidden"]').val();
				var a = rowEndDate.split(" ");
				var d = a[0].split("-");
				var t = a[1].split(":");
				var endDate = new Date(d[0],(d[1]-1),d[2],t[0],t[1],t[2]);
				var today = new Date();
				if (today < endDate) {
					diff = Math.floor(( Date.parse(endDate) - Date.parse(today) ) / 86400000);
					//alert(diff + "일 남았습니다.");
					if(diff < 31){
						// 마우스오버된 
						var rowID = $(this).context.getAttribute("id");
						rowID = "#" + rowID;
//						var strAlert = "선택하신 인증서는 "
//										+ rowEndDate + "(남은 기간 " + diff + "일)에 만료 예정입니다.\n"
//										+ "인증서를 발급받은 기관의 공인인증센터에서 인증서를 갱신하시기 바랍니다.";
//						$(rowID).attr("title", strAlert);
						
						var strAlert = "<div style='padding:2px 2px 0px 4px;'>선택하신 인증서는 "
										+ rowEndDate + "(남은 기간 " + diff + "일)에 만료 예정입니다.</div>"
										+ "<div style='padding:0px 2px 2px 4px;'>인증서를 발급받은 기관의 공인인증센터에서 인증서를 갱신하시기 바랍니다.</div>";
						var thisIsTop = $(this).offset().top + 25;
						var thisIsLeft = $(this).offset().left;
						var divArea = $("<div name='speechBubbleArea' id='"+rowID+"' style='position:absolute;border:1px solid #333;height:39px;z-index:18004;background:#F1F1F1;'><span>"+strAlert+"</span></div>");
						divArea.css("top",thisIsTop+"px");
						divArea.css("left",thisIsLeft+"px");
						$("body").append(divArea);
					}
				} else {
					// 만료된 인증서 마우스 오버시 만료안내 공지
					var rowID = $(this).context.getAttribute("id");
					rowID = "#" + rowID;
					var strAlert = "<div style='padding:2px 2px 0px 4px;'>선택하신 인증서는 만료되었습니다.</div>";
					var thisIsTop = $(this).offset().top + 25;
					var thisIsLeft = $(this).offset().left;
					var divArea = $("<div name='speechBubbleArea' id='"+rowID+"' style='position:absolute;border:1px solid #333;height:20px;z-index:18004;background:#F1F1F1;'><span>"+strAlert+"</span></div>");
					divArea.css("top",thisIsTop+"px");
					divArea.css("left",thisIsLeft+"px");
					$("body").append(divArea);
				}
			}
		});
		
		$("#dataTable tbody").on("mouseout", "tr", function(event){
			$("body").find("div[name='speechBubbleArea']").remove();
		});
		
		//table row(인증서) 선택 event catch
		$("#dataTable").on('rowSelect', function(e){
			var args = e.args;
			var index = args.index;
			var rowData = args.row;
			var rowKey = args.key;
	//		GPKISecureWebLog.log("dataTable.rowSelect.args === " +args);
	//		GPKISecureWebLog.log("dataTable.rowSelect.index === " +index);
	//		GPKISecureWebLog.log("dataTable.rowSelect.rowData === " + JSON.stringify(rowData));
	//		GPKISecureWebLog.log("dataTable.rowSelect.rowKey === " +rowKey);
		});
	
		//웹접근성 포커스 유지를 위한 아래 내용 주석처리
		//$("#dataTable").focus();
	},
	openCSInstallDialog : function(mode){
		
		var browser = GPKISecureWebApi.getProperty('browser');
		var os_ver = GPKISecureWebApi.getProperty("os");
		
		if(os_ver == ""){
			os_ver = getOS();
		}
		
		if(os_ver.indexOf("LINUX") > -1){
			$("#csContainer").load("UI/GPKIWeb_Cs_Linux_Install.html?random=" + Math.random() * 99999, function(){
				$('#ML_install').MLjquiWindow('open', function(e){});
				
			});
		}else{
			var popOption = {
				mode: mode,
				title:$.i18n.prop("TS039"),
				showCert:false,
				certData:null,
				onclick:"installProgram",
				contentKey:"install_cs",
				dialogHeight:"180px"
			};
		}
		DSDialog.openDialog(popOption, null, function(code,jsonObj){});
	},
	openCSUpdateDialog : function(mode){
		
		var browser = GPKISecureWebApi.getProperty('browser');
		var os_ver = GPKISecureWebApi.getProperty("os");
		
		if(os_ver == ""){
			os_ver = getOS();
		}
		
		if(os_ver.indexOf("LINUX") > -1){
			$("#csContainer").load("UI/GPKIWeb_Cs_Linux_Install.html?random=" + Math.random() * 99999, function(){
				$('#ML_install').MLjquiWindow('open', function(e){});				
			});
		}else{
			var popOption = {
					mode: mode,
					title:$.i18n.prop("TS040"),
					showCert:false,
					certData:null,
					onclick:"installProgram",
					contentKey:"install_update",
					dialogHeight:"225px"
			};
		}
		DSDialog.openDialog(popOption, null, function(code,jsonObj){});
	},
	
// 에러 alert dialog 처리
	errorHandler : function(mode, errCode, obj, callback) {
		
		// TODO : 에러 코드별로 분기 처리
		/* 
		 * switch(errCode){
		 * 	case 1:
		 *  case 2:
		 *  	//
		 *  case 3:
		 *  	//
		 *  default :
		 *  	//
		 * }
		 * 
		 */
		
		// alert 호출
		if(typeof(errCode) != "undefined"){
			DSAlert.openAlert(mode, errCode, obj);
		}
		
		
		// 함수 처리
		if(typeof(callback) === "function"){		
			callback();
		}
	},
	confirm : function( message, callback ){
		
		var popOption = {
			mode:"main",
			title:$.i18n.prop("TS014"),
			showCert:false,
			certData:{},
			contentKey:"confirm",
			dialogHeight:190,
			message:message
		};

		var StgName = GPKISecureWebCert.criteria.certObj;
		if(StgName == undefined || StgName == null || StgName == ''){
			StgName = 'UNDEFINED';
		}else{
			StgName = GPKISecureWebCert.criteria.certObj.selectedStg;
		}
		var btnObj = $("#stg_"+ StgName);
		
		DSDialog.openConfirm(popOption, btnObj, function(code,jsonObj){
			$("#btn_common_confirm").unbind().click( function(){
				callback(0,true);
				btnObj.focus();
				return;
			});
			$("#btn_common_cancle").unbind().click( function(){
				callback(1,false);
				return;
			});
		});
	},
	confirmWithButtonTitle : function( message, buttonTitleCode, callback ) {
		if( typeof message ==="undefined" || message == null ) return;
		if( typeof buttonTitle === "function") {
			callback = buttonTitle;
			buttonTitle = '';
		}
		
		var popOption = {
			mode:"main",
			title:$.i18n.prop("TS014"),
			showCert:false,
			certData:{},
			contentKey:"confirm",
			dialogHeight:190,
			message:message,
			attrValue:$.i18n.prop(buttonTitleCode)
		};

		var StgName = GPKISecureWebCert.criteria.certObj;
		if(StgName == undefined || StgName == null || StgName == ''){
			StgName = 'UNDEFINED';
		}else{
			StgName = GPKISecureWebCert.criteria.certObj.selectedStg;
		}
		var btnObj = $("#stg_"+ StgName);
		
		DSDialog.openConfirmWithButtonTitle(popOption, btnObj, function(code,jsonObj){
			$("#btn_common_sub_confirm").unbind().click( function(){
				callback(0,true);
				btnObj.focus();
				return;
			});
			$("#btn_common_sub_cancle").unbind().click( function(){
				callback(1,false);
				return;
			});
		});
	}
};


var GPKISecureWebSaveCertDraw = {
		
	hddOptionMap : {
		// HDD 스토리지 선택 정보 저장을 위해 사용
	},		
	initDraw : function(isEmbedded){

		
		// 인증서 저장 창 그리기
		this._createWindow(isEmbedded);
			
		// 메시지 초기화
		MessageVO.applyMessage($('[id^="MSG_"]'));
		
		//key event 
		$(this).keydown(function(e){
			if(e.keyCode == "9"){
				var targetElement = $(document.activeElement).attr("id");
				var parentElement = $(document.activeElement).parent().attr("id");
				//console.log("targetElement.id === " + targetElement);
				//console.log("parentElement.id === " + parentElement);
	
				if(targetElement == "stg_smartcert" ){
					var selection = $("#dataTable").MLjquiDataTable('getSelection');
					if(selection && selection.length>0){

					}else{

					}
				} else if(targetElement == "btn_cancel" ){
					$(".ML_storage_area>ul>li:first-child").focus();
				} else if(targetElement == "btn_file_cs" ){
					$("#import_pfx_password").focus();
				} else if(targetElement == "file_route" ){
	
				} else if(targetElement == null || targetElement == 'undefined'){
					
				}
			}else if (e.keyCode == "27"){
				console.log("Esc keydown Esc keydown Esc keydown Esc keydown");
			}
		});
		
		// Slide L&R Button
		$(".customNavigation").click(function(){
			var X=$(this).attr('id');
			if(X==1){
				$(this).children(".str_add_li").removeClass('pr');
				$(this).children(".str_add_li").addClass('ne');
				$(this).attr('id', '0');
	
				$("#wrap_stg_01").animate({left:"0px"}, 250);
				$("#wrap_stg_02").animate({left:"375px"}, 250);
			}else{
				$(".str_add_li").attr('class', 'str_add_li pr');
				$(this).children(".str_add_li").removeClass('ne');
				$(this).children(".str_add_li").addClass('pr');
				$(".customNavigation").attr('id', '0');
				$(this).attr('id', '1');
				
				$("#wrap_stg_01").animate({left:"-375px"}, 250);
				$("#wrap_stg_02").animate({left:"0px"}, 250);
			}
		});
	
		$(".stg_01").focus(function(){
			$("#wrap_stg_01").animate({left:"0px"}, 250);
			$("#wrap_stg_02").animate({left:"375px"}, 250);
			$(".customNavigation").children(".str_add_li").removeClass('pr');
			$(".customNavigation").children(".str_add_li").addClass('ne');
			$(".customNavigation").attr('id', '0')
		});
	
		$(".stg_02").focus(function(){
			$("#wrap_stg_01").animate({left:"-375px"}, 250);
			$("#wrap_stg_02").animate({left:"0px"}, 250);
			$(".customNavigation").children(".str_add_li").removeClass('ne');
			$(".customNavigation").children(".str_add_li").addClass('pr');
			$(".customNavigation").attr('id', '1')
		});
		
	},
	_createWindow : function(isEmbedded) {
		
		if( ! GPKISecureWebApi.getProperty("banner") ){
			$(".ML_cp_AD").remove();
		}
		
		var window_height = 558;
		var window_width = 418;
		var popupWidth = document.body.clientWidth;
		
		var os_ver = GPKISecureWebApi.getProperty("os");
		var jqxWidget = $('#ML_window');
		var offset = jqxWidget.offset();
		var xValue = offset.left + (($(window).width()/2)-(window_width/2));
		var position = { x: xValue, y: offset.top + 50};
		var popupPosition =  {x: offset.left + ($(window).width()/2) - 200, y: offset.top + 200};
		
		if(isEmbedded){
			popupPosition =  {x: offset.left + ($(window).width()/2) - 200, y: offset.top};
		}
		
		popupWidth = 398;
		
		//-00. Main
		$("#ML_window").MLjquiWindow({
			title: $.i18n.prop("TS085"),
			resizable: false,
			position:position,
			showCloseButton:false,
			isModal: true,
			modalOpacity: 0.3,
			modalZIndex: 9995,
			modalBackgroundZIndex: 9995,
			showCollapseButton: false,
			draggable: false,
			keyboardCloseKey: 0,
			maxHeight: 600, maxWidth:720,
			minHeight: 200, minWidth: 200,
			height: window_height, width: window_width,
			initContent: function () {
				$('#ML_window').MLjquiWindow('focus');
			}
		});
		
		$('#popup_alert').MLjquiWindow({
			title: $.i18n.prop("TS042"),
			resizable: false,	
			position: popupPosition,
			showCloseButton:false,
			zIndex:9990,
			showCollapseButton: false,
			keyboardCloseKey: 0,
			maxHeight: 600, maxWidth:420,
			minHeight: 200, minWidth: 200,
			height: 148, width: popupWidth,
			isModal: true,
			modalOpacity: 0.3,
			modalZIndex: 9995,
			draggable: false,
			modalBackgroundZIndex: 9995,
			initContent: function () {
				$('#popup_alert').MLjquiWindow('close');
			}
		});
		

		$('#popup_server_info').MLjquiWindow({
			title: '서버 저장소 관리하기 - 신원확인',
			resizable: false,	
			position: popupPosition,
			showCloseButton:false,
			zIndex:9990,
			showCollapseButton: false,
			keyboardCloseKey: 0,
			maxHeight: 600, maxWidth:420,
			minHeight: 200, minWidth: 200,
			height: 380, width: popupWidth,
			isModal: true,
			modalOpacity: 0.3,
			modalZIndex: 9995,
			draggable: false,
			modalBackgroundZIndex: 9995,
			initContent: function () {
				$('#popup_server_info').MLjquiWindow('close');
			}
		});
		
		//-02. Common
		//$('#ML_Dialog_common').show();
		$('#ML_Dialog_common').MLjquiWindow({
		//	autoOpen: false,
		//	title:'비밀번호변경',
			resizable: false,
			//position: 'center',
			position:popupPosition,
			showCloseButton:false,
		//	closeButtonSize: 35,
		//	closeButtonAction:'close',
		//	draggable:false,
			isModal: true,
			modalOpacity: 0.3,
			modalZIndex: 9996,
			keyboardCloseKey: 0,
			modalBackgroundZIndex: 9996,
			showCollapseButton: false,
			width: popupWidth,
			initContent: function () {
				$('#ML_Dialog_common').MLjquiWindow('close');
			}
		});
		$('#ML_Dialog_common_sub').MLjquiWindow({
		//	autoOpen: false,
		//	title:'비밀번호변경',
			resizable: false,
			//position: 'center',
			position:popupPosition,
			showCloseButton:false,
		//	closeButtonSize: 35,
		//	closeButtonAction:'close',
		//	draggable:false,
			isModal: true,
			modalOpacity: 0.3,
			modalZIndex: 9996,
			keyboardCloseKey: 0,
			modalBackgroundZIndex: 9996,
			showCollapseButton: false,
			width: popupWidth,
			initContent: function () {
				$('#ML_Dialog_common_sub').MLjquiWindow('close');
			}
		});
			
		//-03. Cs install dialog
		$('#ML_dialog_cs_install').MLjquiWindow({
			resizable: false,
			//position: 'center',
			position: popupPosition,
			showCloseButton:false,
			isModal: false,
			modalOpacity: 0.3,
			modalZIndex: 9996,
			keyboardCloseKey: 0,
			modalBackgroundZIndex: 9996,
			showCollapseButton: false,
			width: popupWidth,
			initContent: function () {
				$('#ML_dialog_cs_install').MLjquiWindow('close');
			}
		});
	},
	MakeSaveCertDiv : function(certInfo) {
		
		// 인증서 목록에 해당 정보 출력
		var listObj = new Array();
		listObj.push(certInfo);
		var source = makeSourceData(listObj);
		var dataAdapter = new $.MLjqui.dataAdapter(source);
		var certOpt = new Object();
		certOpt.storageName = "";
		
		$("#dataTable").MLjquiDataTable({
			theme:"DSdatatable",
			width: "398",
			height: "150",
			columnsHeight:25,
			altRows: true, // 행 백그라운드 교차 //
			autoRowHeight: false,
			sortable: true,
			pageable: false,
			source: dataAdapter,
			enableHover: true,
			columnsResize: true,
			selectionMode: "singleRow",
			columns: [
				{ text: $.i18n.prop("TS059"), dataField: 'Cn', width: 140, align: 'center',
					cellsRenderer: function (row, column, value, rowData) {
						var image = "<div style='display:inline-block; padding-right:5px;'>";

						var imgurl = '';
						var isExpired = GPKISecureWebUtil.isDateExpired(rowData.enddatetime);
						if(isExpired){
							imgurl = 'UI/images/icon_cert_expire.png';
						}else{
							imgurl = 'UI/images/icon_cert_default.png';
						}
						
						//20200324
						var img = '<img width="16" height="16" style="display:block;" src="' + imgurl + '" alt=""/>';
						image += img;
						var tooltip = "</div><span style='vertical-align:top; padding-top:2px;' title='" + rowData.Cn + "'>" + rowData.Cn + "</span>";
						return image+=tooltip;
					}
				},
				{ text: $.i18n.prop("TS060"), dataField: 'Policy', width: 100, align: 'center',
					cellsRenderer: function (row, column, value, rowData) {

						var image = "<div style='display:inline-block; padding-right:5px;'>";

						var imgurl = '';
						var isExpired = GPKISecureWebUtil.isDateExpired(rowData.enddatetime);
						if(isExpired){
							imgurl = 'UI/images/icon_cert_expire.png';
						}else{
							imgurl = 'UI/images/icon_cert_default.png';
						}
						image += "</div><span style=' vertical-align:top; padding-top:2px;' title='" + rowData.Policy + "'>" + rowData.Policy + "</span>";
						//var img = '<img width="16" height="16" style="display:block;" src="' + imgurl + '"/>';
						//image += img;
						//image += "</div><span style='display:inline-block; vertical-align:top; padding-top:2px;'>" + rowData.Policy + "</span>";
						//image += "</div><span style='display:inline-block; vertical-align:top; padding-top:2px;' title='" + rowData.Policy + "'>" + rowData.Policy + "</span>";
						return image;
					}
				},
				{ text: $.i18n.prop("TS061"), dataField: 'Issuer', cellsAlign: 'left', align: 'center', cellsFormat: 'c2' },
				{ text: $.i18n.prop("TS062"), dataField: 'enddate', width: 78, cellsAlign: 'left', align: 'center', cellsFormat: 'd'}
			], ready:function(){
				$("#dataTable").MLjquiDataTable('selectRow', 0);
			}
		});
		
		// 선택 강제
		if(listObj != null && listObj.length > 0){
			$("#dataTable").MLjquiDataTable('selectRow', 0);
		}
		
		
		$('[id^="stg_"]').click(function () {
			
			//UI driver 선택창 위치 조정
			var stg_idx 		= $(this).attr("stgIdx");
			var selectedStorage = this.id.split("stg_")[1];
			
			selectMedia = selectedStorage;
			
			// btn_confirm 참조 값인 storage 명 셋팅
			certOpt.storageName = selectedStorage;
			GPKISecureWebUI.selectedStorage.current_option = certOpt;
			
			$('#driver_div').removeClass("pos_01").removeClass("pos_02").removeClass("pos_03").removeClass("pos_04").removeClass("pos_05");
			$('#driver_div').addClass("pos_0"+stg_idx);
			
			//UI css selection 처리
			$('[class^="ML_storage_"]').removeClass("on");
			$(this).parent().addClass("on");

			// 드라이버 선택창 닫기
			closeDriverDialog();
			
			if( GPKISecureWebApi.webConfig.useVirtualKeyboard ){
				if( GPKISecureWebApi.webConfig.virtualKeyboardType === "INCA" ){
					var npLength = npVCtrl.keypadObject.length;
					if(npLength > 1){
						for (var i=0; i<npLength; i++){
							if("nppfs-keypad-input_cert_pw" == npVCtrl.keypadObject[i]._uuid){
								npVCtrl.keypadObject.splice(i,1);
								break;
							}
						}
					}
				}
			}
			
			if(selectedStorage == "hdd"){
				
				GPKISecureWebApi.gpkisecureweb_storage_api.SelectStorageInfo("hdd", function(resultCode, jsonObj){					
					
					if(resultCode == 0){
						
						if(jsonObj != null){
							
							// 디폴트 스토리지 HDD 선택시, 디스크 아이콘 선택시 첫번쨰 디스크 선택 된것으로 간주							
							GPKISecureWebUI.selectedStorage.option = jsonObj;																					
							GPKISecureWebSaveCertDraw.hddOptionMap = new Object();
							
							for(var i=0; i<jsonObj.hddOpt.length; i++){								
								GPKISecureWebSaveCertDraw.hddOptionMap[jsonObj.hddOpt[i].diskname] = "DUMMY";								
							}
							
							GPKISecureWebUI.selectedStorage.current_option.storageOpt = jsonObj.hddOpt[0].diskname;
							GPKISecureWebSaveCertDraw.showSelectedStorageName();
							
						}else{
							//no list
							//GPKISecureWebSaveCertDraw.openDriverDialog(selectedStorage, null);
						}
						
					}else{
						// Nothing To do
					}
				});
			}
			
			GPKISecureWebSaveCertDraw.showSelectedStorageName();
			
			// 스토리지 선택 노출 이벤트 처리
			$(document).on("click", function(event){
				
				// 1. HDD 디스크 옵션 선택 처리
				// 2. HDD 디스크 옵션 하위 메뉴 출력 처리
				var currentText = event.target.innerText;
				
				if($("#sub_drv_list").length > 0 && GPKISecureWebSaveCertDraw.hddOptionMap[currentText]){										
					GPKISecureWebUI.selectedStorage.current_option.storageOpt = currentText;															
					GPKISecureWebSaveCertDraw.showSelectedStorageName();
					closeDriverDialog();
				}else if(GPKISecureWebUI.selectedStorage.current_option.storageName == "hdd" && event.target.id.indexOf("stg_") == 0 && GPKISecureWebUI.selectedStorage.option != null){
					GPKISecureWebSaveCertDraw.openDriverDialog(selectedStorage, GPKISecureWebUI.selectedStorage.option);
				}											
			});
			
		});
		
		//메세지 처리 적용.
		MessageVO.applyMessage($('[id^="MSG_"]'));
		
	},
	showSelectedStorageName : function(){
		
		var htmlStream = "인증서 저장 위치 : ";
		
		switch(GPKISecureWebUI.selectedStorage.current_option.storageName){
			case "web" :
				htmlStream += "브라우저";
				break;
			case "hdd" :												
				htmlStream += GPKISecureWebUI.selectedStorage.current_option.storageOpt;												
				break;
			default :
				break;
		}
		$("#ML_dp_03").empty().html(htmlStream);
		
	},		
	openDriverDialog : function(id, obj){		
		var htmlStream = "";
		
		if(id == "mobile"){
			htmlStream += '<ul id="sub_drv_list" class="drive_position_menu wdh_220">';
		}else if(id == "hdd"){
			htmlStream += '<ul id="sub_drv_list" class="drive_position_menu wdh_210">';
		}else{
			htmlStream += '<ul id="sub_drv_list" class="drive_position_menu wdh_150">';
		}
		
		if(id == "hdd"){
			
			var hddOptCnt = obj.hddOpt.length;			
			for(var i=0; i<hddOptCnt; i++){
				
				if(i==(obj.hddOpt.length-1)){
					htmlStream += '	<li id="'+id+'_driver_'+i+'" ><a href="#" class="wdh_210" onblur="closeSubDriverList();">'+obj.hddOpt[i].diskname+'</a></li>';					
				}else{
					htmlStream += '	<li id="'+id+'_driver_'+i+'" ><a href="#" class="wdh_210" >'+obj.hddOpt[i].diskname+'</a></li>';
				}				
			}
		}		
		htmlStream += "</ul>";
			
		$('#driver_div').empty().html(htmlStream);
		$('#driver_div').show();
			
		$('#sub_drv_list>li:first-child>a').focus();
		
	}
	
};
window.onorientationchange = function() {
	var jqxwidget2 = $('#ML_window');
	var offset2 = jqxwidget2.offset();
	detailWidth = screen.width;
	detailHeight = screen.height;
	
	$('#ML_window_detail').MLjquiWindow({
		position:{x: offset2.left, y: offset2.top},
		width:detailWidth,height:detailHeight
	});
}
