// 로컬
var cpUrl = location.port != ""?location.hostname+":"+location.port:location.hostname;
var mlMainUrl = location.protocol+"//"+( location.port != ""?location.hostname+":"+location.port:location.hostname );
var mlDirPath = ConfigObject.mlDirPath;
var childHtml = ConfigObject.ChildURL;	
var embeddedHtml = ConfigObject.embeddedHtml;


$(document).ready(function(){

	var currentLocation = document.location.pathname;
	var isEmbedded = currentLocation.indexOf(embeddedHtml);
	
	if(isEmbedded == '0' || isEmbedded == 0){
		isEmbedded = true;
		childHtml = ConfigObject.ChildEmbeddedURL;
	}else{
		isEmbedded = false;
	}
	
	$('#dscertContainer').hide();
	
	$.blockUI({
		message:'<div><div><img src="' + mlDirPath + 'UI/images/loader.gif" alt="로딩중입니다."/></div><p style="display:inline-block; padding-top:4px; font-size:11px; color:#333; font-weight:bold;">잠시만 기다려 주세요.</p></div>',
		css:{left:(($(window).width()/2)-75)+'px'}
	});
	
	gpkisecureweb.uiapi.SECURE_funProcInitCheck(function(code,data){
		if( code == 0 ){
			gpkisecureweb.uiapi.completeInit();
			if(typeof(checkCallback) == "function"){
				gpkisecureweb.uiapi.checkInstall(checkCallback);
			}
		}
	}, isEmbedded);
	
	gpkisecureweb.uiapi.SECURE_checkInit();

});

var gpkisecureweb = {
		uiapi : "",
		initCallback : "",
		is_ML_Sign_Init:false
}
var gpkisecurewebApi = function(){
	var callback="";
	var defaultOptions = {
			sign:{signType:"MakeSignData",msg:"",messageType:"",signOpt:{ds_pki_sign:['OPT_NONE'], ds_pki_rsa:'rsa15', ds_pki_hash:'sha256',ds_msg_decode:"false",ds_pki_sign_type:"signeddata"}},
			signPdfOpt:{ds_pki_sign:['OPT_USE_CONTNET_INFO','OPT_USE_PKCS7','OPT_NO_CONTENT','OPT_HASHED_CONTENT'], ds_pki_rsa:'rsa15', ds_pki_hash:'sha256',ds_msg_decode:"true"},
			encOpt:{ds_pki_rsa:'rsa15'},
			signedenvOpt:{ds_pki_sign:['OPT_USE_CONTNET_INFO'], ds_pki_rsa:'rsa15', ds_pki_algo:'SEED-CBC'},
			// 추가
			idn : "",
			vidType : "",
			certOidfilter:"", //1.2.410.100001.2.2.1,1.2.410.200005.1.1.4
			certExpirefilter:true, //false:만료 인증서 보여주기, true:보여주지 않기
			//mrs2 옵션 설정
			saveStorageList : ["web","hdd"],
			exportStorageList : ["web", "hdd"],
			exportStorageSelect : "web",
			browser_notice_show	: false,
			//특허청 전자서명 옵션
			kipoSignOpt:{signType:"MakeSignData",msg:"",messageType:"",signOpt:{ds_pki_sign:['OPT_USE_CONTNET_INFO', 'OPT_HASHED_CONTENT'], ds_pki_rsa:'rsa15', ds_pki_hash:'sha256',ds_msg_decode:"hash",ds_pki_sign_type:"signeddata"}}
	}
	
	function CommonResopnseProcess( json ){
		
		var response = JSON.parse( json );
		var close = response.close;

		if( response.close  == 'closeDialog'){
			$('#dscertContainer').hide();
		}
	}
	
	/**
	 * send 할 메시지를 생성
	 */
	function MakeRequestJsonMessage( functionName, functionParameter, option ){
		var temp = 
			{
				"funcName" : functionName,
				"funcParam" : functionParameter
			}
		return JSON.stringify( temp );
	}
	
	/**
	 * SignedData
	 */
	function MakeSignData( msg , signOpt, callback, isEmbedded){
		
		gpkisecurewebApi.callback = callback;
		var param = defaultOptions.sign;
		param.signType = "MakeSignData";
		
		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
//		if(msg instanceof HTMLFormElement){
		if(typeof(msg) == 'object' && typeof(msg.param) != "undefined"){
			if(typeof(msg.param.length) != "undefined"){
				param.msg = new Array();
				for(var i = 0; i < msg.param.length; i++){
					param.msg[i] = msg.param[i].value;
				}
			}else{
				param.msg = msg.param.value;
			}
		}
		
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
		if(msg.ssn != null && msg.ssn != ""){
			if(msg.ssn.value != null && msg.ssn.value != ""){
				param.idn = msg.ssn.value;
				if(msg.vidType != null && msg.vidType != ""){
					if(msg.vidType.value != null && msg.vidType.value != ""){
						param.vidType = msg.vidType.value;
					}
				}
			}
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		SECURE_sendPostMessage( request, isEmbedded);
	}
	/**
	 * SinatureData
	 */
	function MakeSignatureData( msg , signOpt, callback ){
		gpkisecurewebApi.callback = callback;
		
		var param = defaultOptions.sign;		
		param.signType = "MakeSignData";
		
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
//		if(msg instanceof HTMLFormElement){
		if(typeof(msg) == 'object'){
			param.msg = gpkisecureweb.extraceFormToString(msg);
		}
		
		if(msg.signData != null && msg.signData != ""){
			param.signData = msg.signData.value;
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "sign";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		SECURE_sendPostMessage( request );
	}
	/**
	 * MakeAddSignData
	 */
	function MakeAddSignData( msg , signOpt, callback ){
		
		gpkisecurewebApi.callback = callback;
		var param = defaultOptions.sign;
		param.signType = "MakeSignData";
		
		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
//		if(msg instanceof HTMLFormElement){
		if(typeof(msg) == 'object'){
			//param.msg = gpkisecureweb.extraceFormToString(msg);
			param.msg = msg.signData.value;
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		var funcName = param.signType;
		param.signOpt.ds_pki_signData = param.msg;
		param.signOpt.ds_pki_signdata = param.msg;
		
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		SECURE_sendPostMessage( request );
	}
	
	function keyBoardSecurityUse(strKeyboard, callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			param.strKeyboard = strKeyboard;
			
			var option = null;			
			var request = MakeRequestJsonMessage("keyBoardSecurityUse", param, option);
			
			SECURE_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function tranx2PEM(callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";			
			var option = null;
			
			var request = MakeRequestJsonMessage("tranx2PEM", param, option);			
			SECURE_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
		
	}
	
	function getRandomfromPrivateKey(callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
		
			var param = {};
			param.layer = "UI";
			var option = null;
			
			var request = MakeRequestJsonMessage("getVIDRandom", param, option);
			SECURE_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function setSessionID(strSessionID, callback){		
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			param.strSessionID = strSessionID;
			var option = null;
			
			var request = MakeRequestJsonMessage("setSessionID", param, option);
			SECURE_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}	
	}
	
	function getSignDN(callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			var option = null;
			var request = MakeRequestJsonMessage("getSignDN", param, option);
			
			SECURE_sendUtilMessage(request);
			
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function signatureData(dn, callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
			
			var param = {};
			param.layer = "UI";
			param.msg = dn;
			var option = null;
			
			var request = MakeRequestJsonMessage("signatureData", param, option);
			
			SECURE_sendUtilMessage(request);
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
		
	}
	
	/**
	 * 인증서 저장을 위한 함수
	 */
	function saveCertToStorage(certbag, stgArr, callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){			
			var param = {};						
			param.certbag = certbag;
			param.stgArr  = defaultOptions.saveStorageList;
			
			var option = null;			
			var request = MakeRequestJsonMessage("saveCertToStorage", param, option);			
			addEventLisner( callback );
			SECURE_sendPostMessage( request );
		}else{
			alert('초기화 중입니다. 잠시 후 다시 시도해 주세요.');
		}	
	}
	
	/**
	 * 인증서 이동을 위한 함수
	 */
	function getSelectCert( msg , signOpt, callback ){
		
		gpkisecurewebApi.callback = callback;
		var param = defaultOptions.sign;
		param.signType = "MakeSignData";
		
		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
		if(typeof(msg) == 'object'){
			param.msg = msg.signData.value;
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		// 인증서 이동시 인증서를 불러오기 위한 저장매체 설정 - 인증서내보내기
		param.STORAGELIST			= defaultOptions.exportStorageList;
		param.STORAGESELECT			= defaultOptions.exportStorageSelect;
		param.BROWSER_NOTICE_SHOW	= defaultOptions.browser_notice_show;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		SECURE_sendPostMessage( request );
	}
	
	/**
	 * 특허청 파일 해쉬 전자서명
	 */
	function MakeHashSignData( msg , signOpt, callback ){
		gpkisecurewebApi.callback = callback;
		var param = defaultOptions.kipoSignOpt;
		param.signType = "MakeSignData";
		
		// Param Mapping
		if( msg!=null && typeof(msg)!='undefined' && msg!='' ){
			param.msg = msg;
		}
		
		// 본인확인 (IDN) 입력시 서명 원문 맵핑
		if(typeof(msg) == 'object' && typeof(msg.signData) != "undefined"){
			//param.msg = msg.signData.value;
			
			if(typeof(msg.signData.length) != "undefined"){
				param.msg = new Array();
				for(var i = 0; i < msg.signData.length; i++){
					param.msg[i] = msg.signData[i].value;
				}
			}else{
				param.msg = msg.signData.value;
			}
		}
		
		if(msg.idn != null && msg.idn != ""){
			param.idn = msg.idn.value;
		}
		
		if(msg.vidType != null && msg.vidType != ""){
			param.vidType = msg.vidType.value;							
		}
		
		param.signOpt.ds_pki_sign_type = "signeddata";
		param.signOpt.cert_filter_expire = defaultOptions.certExpirefilter;
		param.signOpt.cert_filter_oid = defaultOptions.certOidfilter;

		param.certOidfilter = defaultOptions.certOidfilter;
		param.certExpirefilter = defaultOptions.certExpirefilter;
		
		var funcName = param.signType;
		var option = null;
		
		var request = MakeRequestJsonMessage(funcName, param, option );
		
		addEventLisner( callback );
		SECURE_sendPostMessage( request );
	}
	
	function closeDialog(event){
		$('#dscertContainer').hide();
		
		var obj = JSON.parse( event.data );
		if( obj.key  == 'closeDialog'){
			$('#dscertContainer').hide();
			obj.code = 999;	// 주석 부분 해제
			gpkisecurewebApi.callback( obj.code , obj );
		}else if( obj.resultMsg != null && obj.resultMsg !== "" ){
			gpkisecurewebApi.callback( obj.code , obj.resultMsg );	
		}else if(obj.opcode != null && obj.opcode !== ""){
			magicmrsApi.callback(obj);
		}else{
			gpkisecurewebApi.callback( obj.code , obj );
		}
	}
	
	function addEventLisner( callback ){
		if(window.addEventListener){
			window.addEventListener("message",closeDialog, false);
		}else if(window.attachEvent){
			window.attachEvent("onmessage", closeDialog );
		}
	}
	
	function SECURE_sendPostMessage ( requestStr, isEmbedded ){
		var dialogTitle = "전자서명";
		$('#dscertContainer').show();
		var iframeWindow = document.getElementById('dscert').contentWindow;
		
		iframeWindow.postMessage(requestStr, mlMainUrl);
	}
	
	function SECURE_sendUtilMessage( requestStr ){
		
		var iframeWindow = document.getElementById('dscert').contentWindow;		
		iframeWindow.postMessage(requestStr, mlMainUrl);
	}
	
	function SECURE_funProcInitCheck (callback){
		gpkisecurewebApi.callback = callback;
		var childUrl = mlMainUrl + mlDirPath + childHtml +"?lgUrl="+cpUrl+"&random=" + Math.random() * 99999;
		$('#dscert').attr("src", childUrl);
		addEventLisner( callback );
	}
	
	function completeInit(){
		gpkisecureweb.is_ML_Sign_Init = true;
		if( typeof gpkisecureweb.initCallback == "function" ){
			gpkisecureweb.initCallback(0, 'completeInit');
		}
		$.unblockUI();
	}
	
	function SECURE_checkInit(){
		setTimeout(function(){
			if( gpkisecureweb.is_ML_Sign_Init ){
				$.unblockUI();
			}else{
				SECURE_checkInit();
			}
		},1500);
	}
	
	/*
	 * jquery 충돌로 인해 blockUI를 업무페이지에서 사용하기 위한 함수
	 */
	function blockUI(){
		$.blockUI({
			message:'<div><div><img src="' + mlDirPath + 'UI/images/loader.gif" alt="로딩중입니다."/></div><p style="display:inline-block; padding-top:4px; font-size:11px; color:#333; font-weight:bold;">잠시만 기다려 주세요.</p></div>',
			css:{left:(($(window).width()/2)-75)+'px'}
		});
	}
	
	function checkInstall(callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
			var param = null;
			var option = null;
			var request = MakeRequestJsonMessage("checkInstall", param, option);
			SECURE_sendUtilMessage(request);
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	function genHash(algorithm, msg, callback){
		gpkisecurewebApi.callback = callback;
		
		if(gpkisecureweb.is_ML_Sign_Init){
			var param = {};
			param.algorithm = algorithm;
			param.msg = msg;
			
			var option = null;
			var request = MakeRequestJsonMessage("genHash", param, option);
			SECURE_sendUtilMessage(request);
		}else{
			alert("초기화 중입니다. 잠시 후 다시 시도해 주세요.");
		}
	}
	
	return {
		MakeSignData:MakeSignData,
		MakeSignatureData:MakeSignatureData,
		MakeAddSignData:MakeAddSignData,		
		MakeRequestJsonMessage:MakeRequestJsonMessage,
		SECURE_sendUtilMessage : SECURE_sendUtilMessage,
		SECURE_funProcInitCheck : SECURE_funProcInitCheck,
		completeInit:completeInit,
		SECURE_checkInit:SECURE_checkInit,
		saveCertToStorage:saveCertToStorage,
		getSelectCert:getSelectCert,
		MakeHashSignData:MakeHashSignData,
		keyBoardSecurityUse:keyBoardSecurityUse,
		tranx2PEM:tranx2PEM,
		getRandomfromPrivateKey:getRandomfromPrivateKey,
		getSignDN:getSignDN,
		signatureData:signatureData,
		setSessionID:setSessionID,		
		blockUI:blockUI,
		checkInstall:checkInstall,
		genHash:genHash
	}
}

gpkisecureweb.uiapi = new gpkisecurewebApi();
var readLength = function(b) {

	  var b2 = b.getByte();
	  if(b2 === 0x80) {
	    return undefined;
	  }

	  // see if the length is "short form" or "long form" (bit 8 set)
	  var length;
	  var longForm = b2 & 0x80;
	  if(!longForm) {
	    // length is just the first byte
	    length = b2;
	  } else {
	    // the number of bytes the length is specified in bits 7 through 1
	    // and each length byte is in big-endian base-256
	    length = b.getInt((b2 & 0x7F) << 3);
	  }
	  return length;
	}


var readValue = function(tag, bytes) {

	if(bytes.length() < 2) {
	    throw new Error('Too few bytes to parse DER.');
	  }

	if (bytes.getByte() != tag) {
	           throw new Error('Invalid format.'); } 
	var length = readLength (bytes); return bytes.getBytes(length); 
}
function getSignedData(sigDataBase64){
	gpkijs.init();
	var sigData = sigDataBase64;
	var decoded = gpkisecureweb.base64Util.decode64(sigData);  // Base64 인코딩되어있는 피노텍 데이터.
	var buff = gpkijs.ByteStringBuffer.create(decoded);
	readValue(0x30, buff); // 
	var signedData = decoded.slice(0, buff.read);  // SignedData 획득 부분입니다.
	signedData = gpkisecureweb.base64Util.encode64(signedData);
	var fileName = gpkijs.utf8.decode(readValue(0x0C, buff)); 
	var fileGenTime = dreamsecurity.asn1.utcTimeToDate(readValue(0x17, buff)); 
	var pdfFile = readValue(0x04, buff);
	document.reqForm.signData.value= gpkisecureweb.base64Util.encode64(pdfFile);
	if(document.getElementById("addSigner").value == null || document.getElementById("addSigner").value == ""){
		document.reqForm.addSigner.value = signedData;
	}
}