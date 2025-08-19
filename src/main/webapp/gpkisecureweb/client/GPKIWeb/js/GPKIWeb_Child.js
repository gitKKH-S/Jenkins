
//********* child.html *********//

//var lgUrl = "mlweb.dreamsecurity.com:18443";
//var lgUrl = "fido.dreamsecurity.com:9443";
var lgUrl = "";
var chUrl = "";
var mlcertUrl = ""
var is_ML_Sign_Init = false;
if( window.console == undefined ) { console = {log : function(){} }; }	//var console = window.console || {log:function(){}};

var defaultopt = {};
var isEmbedded;
var embeddedHtml = ConfigObject.mlDirPath + ConfigObject.ChildEmbeddedURL;

(function(){

	var currentLocation = document.location.pathname;
	isEmbedded = currentLocation.indexOf(embeddedHtml);
	
	if(isEmbedded == '0' || isEmbedded == 0){
		isEmbedded = true;
	}else{
		isEmbedded = false;
	}
	
	//allowed domains
	var whitelist = ["localhost",
					"127.0.0.1",
					lgUrl];

	function verifyOrigin(origin){
		// origin = https://self001.dreamsecuritytest.com:8443
		//origin = https://self001.dreamsecuritytest.com:8443
		//var domain = origin.replace(/^https?:\/\/|:\d{1,5}$/g, "").toLowerCase(),
		var domain = origin.replace('/^' + GPKISecureWebApi.getProperty('protocoltype') + '?:\/\/|:\d{1,5}$/g', "").toLowerCase(),
		i = 0,
		len = whitelist.length;
		//console.log("[Child] domain === "+domain);
		while(i < len){
			if (whitelist[i] == domain){
				return true;
			}
			i++;
		}

		return false;
	}

})();


$(document).ready(function(){
	
	$("#outside_alert").hide();
	
	childInit.funcProcInit();
	childInit.initEventHandler();
	
});

/**
 * 페이지 시작시 호출되는 객체
 * funcProcInit
 * setViewModeByOs
 * initEventHandler
 * completeMLInit
 * closeMainDialogToChild
 */
var childInit = {
	/**
	 * 바깥 alert 창 정의 (에러창, 안내창 등)
	 */
	funcProcInit : function(){
		var params = location.search.substring(1).split("&");
		$.each(params, function(){
			var arr01 = this.split("=");
			if(arr01[0] == "lgUrl"){
				lgUrl = arr01[1];
			}
		});
		
		// zIndex 값에 의해 div 노출 순서를 정함.
		$("#outside_alert").hide();		
		$('#outside_alert').MLjquiWindow({
			title:'알림',
			resizable: false,
			position: 'center',
			showCloseButton:false,
			showCollapseButton: false,
			maxHeight: 600,
			maxWidth:420,
			minHeight: 200,
			minWidth: 200,
			height: 148,
			width: 368,
			zIndex:99999,
			initContent: function () {
				$('#outside_alert').attr("status","ready");
				$('#outside_alert').MLjquiWindow('close');
			}
		});
	},
	/**
	 * GPKISecureWebApi 초기화
	 */
	initEventHandler : function(){
		// 필요없으면 지움
		$("#stg01").unbind().click(function(){
			
		});
		
		//system lang 설정 & message load
		var lang = navigator.language || navigator.userLanguage;
		MessageVO.loadMessage("ko");
		
		GPKISecureWebApi.init(function(code, obj){
			//GPKISecureWebLog.log("GPKISecureWebApi.init() callback... code ="+code+" / obj="+JSON.stringify(obj));
			// CS 설치체크...
			var os_ver = GPKISecureWebApi.getProperty("os");

			if(code==0){
				//초기화 성공
				childInit.completeMLInit();
			}else if(code==1){
				//초기화 성공
				childInit.completeMLInit();
			}else{
				//error
				childInit.closeMainDialogToChild();
			}
		});
		
	},
	/**
	 * 초기 작업, API 초기화 성공시 ML_Config 에 메시지 전송하는 함수
	 */
	completeMLInit : function(){
		
		is_ML_Sign_Init = true;
		
		chUrl = GPKISecureWebApi.getProperty('baseUrl');
		mlcertUrl = GPKISecureWebApi.getProperty('mlcertUrl');
	
		if(GPKISecureWebApi.getProperty('isUseMLCert')){
			var mlcertFullUrl = "https://"+mlcertUrl+"/ML4-Web/ML4Web/mlcert.html?lgUrl="+lgUrl+"&chUrl="+chUrl+"&random=" + Math.random() * 99999 ;
			$('#dsmlcert').attr("src", mlcertFullUrl);
		}
		
		var requestObj = {
			funcName : "completeInit",
			code: 0,
			data : {}
		};
		
		var requestStr = JSON.stringify(requestObj);
		gpkiSecureController.sendResultMessage(requestStr);
	},
	/**
	 * 인증서 선택창을 닫았을때 필요한 작업 수행
	 */
	closeMainDialogToChild : function(){
		console.log("Child.html closeMainDialogToChild() called...");
		
		$("#selectCertContainer").empty();
		$("#certDetailContainer").empty();
		$("#csContainer").empty();
	
		var requestObj = {
			key : "closeDialog",
			data : "",
			code : 1
		};
		var requestStr = JSON.stringify(requestObj); 
		
		gpkiSecureController.sendResultMessage(requestStr);
	}
}

/**
 * ML_Config.js 의 요청, 결과 처리하는 객체
 * receiveMessage
 * sendResultMessage
 * MakeSignData
 * MakeIrosMultiData
 * XMLSignature
 * keyBoardSecurityUse
 * tranx2PEM
 * getVIDRandom
 * getVIDRandomHash
 * getSignDN
 * setSessionID
 * signatureData
 */
var gpkiSecureController = {
	
	/**
	 * 이벤트 리스너 함수
	 */
	receiveMessage : function(event){
		try{
			var requestStr = event.data;
			var request = JSON.parse(requestStr);
			
			var func = window["gpkiSecureController"][request.funcName];			
			func(request.funcParam);
			
		}catch(e){
			//setError(요청 응답 실패)
			console.log(e.message);
		}
		
	},
	/**
	 * ML_Config 에 메시지 전달하는 함수
	 */
	sendResultMessage : function( result ){
		//기존 정보로 다시 설정
		if(Object.keys(defaultopt).length != 0){
			GPKISecureWebApi.webConfig.storageList			= defaultopt.storageList;
			GPKISecureWebApi.webConfig.defaultStorage		= defaultopt.defaultStorage;
			GPKISecureWebApi.webConfig.useVirtualKeyboard 	= defaultopt.useVirtualKeyboard;
			GPKISecureWebApi.webConfig.virtualKeyboardType = defaultopt.virtualKeyboardType;
			GPKISecureWebApi.MobileOption 					= defaultopt.MobileOption;
			GPKISecureWebApi.ClientVersion					= {};
			GPKISecureWebApi.ClientVersion.Win 			= defaultopt.ClientVersion.Win;
			GPKISecureWebApi.ClientVersion.Mac 			= defaultopt.ClientVersion.Mac;
			GPKISecureWebApi.ClientVersion.Lin64 			= defaultopt.ClientVersion.Lin64;
			GPKISecureWebApi.ClientVersion.Lin32 			= defaultopt.ClientVersion.Lin32;	
		}
		
		try{
			var browser = GPKISecureWebApi.getProperty('browser');
			var ilgURL = "";
			
			if(typeof(lgURL)=='undefined'|| lgURL==null){
				ilgURL = GPKISecureWebUI.funProcInit();
			}else{
				ilgURL = lgURL;
			}
			
			window.parent.postMessage(result, GPKISecureWebApi.getProperty('protocoltype')+"//"+ilgURL);
			
			$("#selectCertContainer").empty();
		}catch(e){
			console.log("88888888888888888="+e.message);
		}
	},
	
	PFXExport : function(param){
		GPKISecureWebUI.init(function(status){
			if(status == 200){
				GPKISecureWebCS.installCheck('main', function(code, obj){
					if(code == 0 || GPKISecureWebLog.getErrCode("CS_Manager_API_checkInstall")){						
						var viewOptObj = {
							defaultStorage : GPKISecureWebApi.getProperty("defaultStorage"), //"web"
							storageList : GPKISecureWebApi.getProperty("storageList"), //["web(+a)","hdd","token","mobile","smartcert"]
							installcheck : obj.is_cs_install,
							updatecheck : obj.is_cs_update,
							browserInfo : GPKISecureWebApi.get_browser_info(),
							certOidfilter : param.certOidfilter,
							certExpirefilter : param.certExpirefilter
						};
						if(obj.is_cs_install == false || obj.is_cs_update == true){
							if(viewOptObj.defaultStorage != "web_kftc"){
								if(viewOptObj.storageList.indexOf("web_kftc") >= 0){
									GPKISecureWebApi.setProperty("defaultStorage", "web_kftc");
									viewOptObj.defaultStorage = "web_kftc";
								} else{
									GPKISecureWebApi.setProperty("defaultStorage", "web");
									viewOptObj.defaultStorage = "web";
								}
							}
						}
						
						GPKISecureWebUI.showCertDiv(viewOptObj, function(code, certObj, saveMsgCheck){
							if(code === 0){																
								GPKISecureWebCert.proceedCert(param, certObj);
							}else{
								GPKISecureWebCert.certErrorHandler(code, certObj);								
							}
						}, isEmbedded);
					}else{ // end if(code == 0)
						//setError("installcheck 에러")
					}
				}); // end of GPKISecureWebCS.installCheck
			}else{
				//setError("UI 초기화 실패");
			}
		}); // end of GPKISecureWebUI.init
	},
	
	/**
	 * 인증서 선택창 호출
	 */
	MakeSignData : function(param){
		gpkiSecureController.setDefaultParam(param);
		GPKISecureWebUI.init(function(status){
			
			if(status == 200){
				
				GPKISecureWebCS.installCheck('main', function(code, obj){
					
					if(code == 0 || GPKISecureWebLog.getErrCode("CS_Manager_API_checkInstall")){
						
						var viewOptObj = {
							defaultStorage : GPKISecureWebApi.getProperty("defaultStorage"), //"web"
							storageList : GPKISecureWebApi.getProperty("storageList"), //["web(+a)","hdd","token","mobile","smartcert"]
							installcheck : obj.is_cs_install,
							updatecheck : obj.is_cs_update,
							browserInfo : GPKISecureWebApi.get_browser_info(),
							certOidfilter : param.certOidfilter,
							certExpirefilter : param.certExpirefilter
						};
						
						if(obj.is_cs_install == false || obj.is_cs_update == true){
							if(viewOptObj.defaultStorage != "web_kftc"){
								if(viewOptObj.defaultStorage == "hdd"){
									  GPKISecureWebApi.setProperty("defaultStorage", "hdd");
									  viewOptObj.defaultStorage = "hdd";
									  $("#in_browser").hide();
									  $("#out_browser").hide();
									  $("#con_browser").hide();
									  installCheck("main");
									}else  if(viewOptObj.storageList.indexOf("web_kftc") >= 0){
									  GPKISecureWebApi.setProperty("defaultStorage", "web_kftc");
									  viewOptObj.defaultStorage = "web_kftc";
									} else{
									  GPKISecureWebApi.setProperty("defaultStorage", "web");
									  viewOptObj.defaultStorage = "web";
									}
							}
						}
						
						GPKISecureWebUI.showCertDiv(viewOptObj, function(code, certObj, saveMsgCheck){
							if(code === 0){
								// 기존 proceedCert
								// jsonObj keys : signcert, signpri, rowData, pw, selectedStg		
								GPKISecureWebCert.proceedCert(param, certObj, saveMsgCheck);
							}else{
								GPKISecureWebCert.certErrorHandler(code, certObj);								

							}
						}, isEmbedded);
							
					}else{ // end if(code==0)
						
					}
					
				}); // end of GPKISecureWebCS.installCheck
				
			}else{
				
				//setError("UI 초기화 실패");
			}
		}, isEmbedded); // end of GPKISecureWebUI.init
		
	},
	MakeIrosMultiData : function(param){
		gpkiSecureController.setDefaultParam(param);
		
		GPKISecureWebUI.init(function(status){
			
			if(status == 200){
			
				GPKISecureWebCS.installCheck('main', function(code, obj){
					
					if(code == 0 || GPKISecureWebLog.getErrCode("CS_Manager_API_checkInstall")){
						
						var viewOptObj = {
							defaultStorage : GPKISecureWebApi.getProperty("defaultStorage"), //"web"
							storageList : GPKISecureWebApi.getProperty("storageList"), //["web(+a)","hdd","token","mobile","smartcert"]
							installcheck : obj.is_cs_install,
							updatecheck : obj.is_cs_update,
							browserInfo : GPKISecureWebApi.get_browser_info(),
							certOidfilter : param.certOidfilter,
							certExpirefilter : param.certExpirefilter
						};
						
						if(obj.is_cs_install == false || obj.is_cs_update == true){
							if(viewOptObj.defaultStorage != "web_kftc"){
								if(viewOptObj.storageList.indexOf("web_kftc") >= 0){
									GPKISecureWebApi.setProperty("defaultStorage", "web_kftc");
									viewOptObj.defaultStorage = "web_kftc";
								} else{
									GPKISecureWebApi.setProperty("defaultStorage", "web");
									viewOptObj.defaultStorage = "web";
								}
							}
						}
						
						GPKISecureWebUI.showCertDiv(viewOptObj, function(code, certObj){							
							if(code == 0){								
								GPKISecureWebCert.proceedCert(param, certObj);
							}else{
								GPKISecureWebCert.certErrorHandler(code, certObj);								
							}							
						}, isEmbedded);
						
						
					}else{ // end if(code == 0)
						//setError("checkinstall 실패");
						
					}
					
				});
				
			}else{ // end if(status == 200)
				
				//setError("UI 초기화 실패");
			}
		});
	},
	
	MakeXMLEncryption : function(param){		
		var certAPI    = new JS_Crypto_API();		
		var randomKey  = certAPI.generateRandom(16);
		var randomIv   = certAPI.generateRandom(16);		
		var tbh		   = gpkiSecureUtil.encodeUtf8Hex(param.msg);
		
		var xmlenc	   = certAPI.encrypt("SEED-CBC", randomKey.result, randomIv.result, tbh);
		var	xmlkey	   = certAPI.asymEncrypt(param.kmCert, gpkijs.hex.decode(randomKey.resulthex), "rsa15");
		var xmlCipher  = randomIv.resulthex.concat(xmlenc.HexResult); 
		var xmlCipherB = gpkijs.base64.encode(gpkijs.hex.decode(xmlCipher));
			
		var requestObj = {
				code 			: 0,
				X509Certificate : param.kmCert,
				Symmetrickey 	: xmlkey,
				CipherValue 	: xmlCipherB
		};
			
		var requestStr = JSON.stringify(requestObj);
		gpkiSecureController.sendResultMessage(requestStr);
	},
	
	/**
	 * 키보드 보안
	 */
	keyBoardSecurityUse : function(param){
		
		var layer 		= param.layer;
		var strKeyBoard = param.strKeyboard;
		var requestObj  = {};
		
		try{
			
			if(layer=="UI"){
				
				requestObj.code = 1;
				requestObj.resultMsg = "";
				requestObj.isUtil = true;
				
			}else{
				
				var resource_api = GPKISecureWebApi.getResourceApi();
			    var message = resource_api.makeCsJsonMessage("keyBoardSecurityUse", strKeyboard);
			    
			    resource_api.csAsyncCall(GPKISecureWebApi.getProperty('CsUrl'), message, function(obj){
			    	requestObj.code = obj.ResultCode;
			    	requestObj.resultMsg = obj;
					requestObj.isUtil = true;
			    });
			}
			
		}catch(e){
			
			requestObj.code = GPKISecureWebLog.getErrCode("SecureWeb_API_keyBoardSecurityUse");
			requestObj.resultMsg = {
				"errCode":e.code,
				"errMsg":e.message
			};
			
		}
		
		var requestStr = JSON.stringify(requestObj);
		gpkiSecureController.sendResultMessage(requestStr);
		
	},
	/**
	 * tranx2PEM 데이터 생성
	 */
	tranx2PEM : function(param){
		GPKISecureWebLog.log("tranx2PEM() called... ");
		var certObj  = GPKISecureWebCert.criteria.certObj;
		var usercert = "";
		
		if (typeof(certObj) == "object" && typeof(certObj.signcert) != "undefined") {			
			usercert = "-----BEGIN CERTIFICATE-----\n";
			for(var i=0; i<certObj.signcert.length; i+=64) {
				usercert += certObj.signcert.substr(i, 64)+"\n";
			}
			usercert += "-----END CERTIFICATE-----\n";
		}
		
		var requestObj = {
				code : 0,
				resultMsg : usercert,
				isUtil : true
		};
			
		var requestStr = JSON.stringify(requestObj);
		gpkiSecureController.sendResultMessage(requestStr);
	},
	/**
	 * 선택한 인증서 정보를 기반으로 VID Random 값 생성
	 */
	getVIDRandom : function(callback, callbackObj, saveMsgCheck){
		
		GPKISecureWebLog.log("getVIDRandom() called... ");
		
		// Mapping #1 : 필요 정보 맵핑
		var certObj 		= GPKISecureWebCert.criteria.certObj;
		var signOpt 		= GPKISecureWebCert.criteria.signOpt;
		var selectedStorage = GPKISecureWebCert.criteria.selectedStorage;		
		var passwd			= certObj.pw;
		
		// Mapping #2 : 함수 맵핑
		var isStorageAPI = (selectedStorage == 'token' || selectedStorage == 'smartcert' || selectedStorage == 'smartcertnx');		
		
		var storageAPI = new Storage_API();
		var cryptoAPI = new JS_Crypto_API();
		var encVidData = '';
		var b64decData = '';
		
		if(isStorageAPI){			
			var storageRawCertIdx =  GPKISecureWebCert.criteria.certObj.rowData.storageRawCertIdx;
			
			storageAPI.getVIDRandom(storageRawCertIdx, passwd, function(code, obj){
				if (code == 0){

					if(typeof(callback.kmCert) == "undefined" || callback.kmCert == "" || callback.kmCert == null){
						encVidData = obj.VIDRandom;
					}else{
						b64decData = gpkijs.base64.decode(obj.VIDRandom);
						encVidData = cryptoAPI.asymEncrypt(callback.kmCert, b64decData, "");						
					}
					
					if(typeof callback === "function"){
						
						callbackObj.vidRandom = encVidData;
						callback(code, callbackObj);
						
					}else{
						var requestObj = {
							code : 0,
							resultMsg : encVidData,
							isUtil : true
						};
								
						var requestStr = JSON.stringify(requestObj);
						gpkiSecureController.sendResultMessage(requestStr);
					}
					
				}else{
					GPKISecureWebCert.certErrorHandler(code, obj);
				}
			});
		}else{ // end if(isStorageAPI)			
			
			cryptoAPI.getVIDRandom(certObj.signpri, passwd, function(code, obj){
				
				if (code == 0){
					
					if(typeof(callback.kmCert) == "undefined" || callback.kmCert == "" || callback.kmCert == null){
						encVidData = obj.result;
					}else{
						b64decData = gpkijs.base64.decode(obj.result);
						encVidData = cryptoAPI.asymEncrypt(callback.kmCert, b64decData, "");
					}
					
					if(typeof callback === "function"){
						
						callbackObj.vidRandom = encVidData;
						callback(code, callbackObj, undefined, saveMsgCheck );
						
					}else{
						var requestObj = {
							code : 0,
							resultMsg : encVidData,
							isUtil : true
						};
								
						var requestStr = JSON.stringify(requestObj);
						gpkiSecureController.sendResultMessage(requestStr);
					}
					
					
				}else{
					GPKISecureWebCert.certErrorHandler(code, obj);
				}
			}, saveMsgCheck);
		}
	},
	/**
	 * 선택된 인증서를 기준으로 VID RandomHash 값 생성
	 */
	getVIDRandomHash : function(callback, callbackObj){
		GPKISecureWebLog.log("getVIDRandomHash() called... ");
		
		// Mapping #1 : 필요 정보 맵핑
		var certObj 		= GPKISecureWebCert.criteria.certObj;
		var signOpt 		= GPKISecureWebCert.criteria.signOpt;
		var selectedStorage = GPKISecureWebCert.criteria.selectedStorage;		
		var idn				= GPKISecureWebCert.criteria.idn;
		var passwd 			= certObj.pw;
		
		// Mapping #2 : 함수 맵핑
		var isStorageAPI = (selectedStorage == 'token' || selectedStorage == 'smartcert' || selectedStorage == 'smartcertnx');		
		
		if(isStorageAPI){
			
			var storageAPI = new Storage_API();
			var stroageRawCertIdx = certObj.rowData.storageRawCertIdx;
			
			storageAPI.getVIDRandomHash(storageRawCertIdx, passwd, idn, function(code, obj){
				
				if(code == 0){
					
					if(typeof callback === "function"){						
						callbackObj.VIDRandomHash = obj.VIDRandomHash;
						callback(code, callbackObj);						
					}else{						
						var requestObj = {
							code : 0,
							resultMsg : obj.VIDRandomHash,
							isUtil : true
						};									
						var requestStr = JSON.stringify(requestObj);
						gpkiSecureController.sendResultMessage(requestStr);
					}
					
				}else{ // end if (code == 0)
					
					GPKISecureWebCert.certErrorHandler(code, obj);
				}
				
				
			});
			
		}else{
			
			var cryptoAPI = new JS_Crypto_API();
			cryptoAPI.getVIDRandomHash(certObj.signpri, passwd, idn, function(code, obj){
			
				if(code == 0){
					
					if(typeof callback === "function"){
						
						callbackObj.VIDRandomHash = obj.result;
						callback(code, callbackObj);
						
					}else{
						var requestObj = {
							code : 0,
							resultMsg : obj.result,
							isUtil : true
						};									
						var requestStr = JSON.stringify(requestObj);
						gpkiSecureController.sendResultMessage(requestStr);
						
					}
					
					
				}else{ // end if (code == 0)
					
					GPKISecureWebCert.certErrorHandler(code, obj);
					
				}
				
			});
			
		}
		
	},
	/**
	 * 선택된 인증서 정보를 기반으로 DN 값 생성
	 */
	getSignDN : function (param){
		var certObj  = GPKISecureWebCert.criteria.certObj;
		var userdn = GPKISecureWebApi.makeReverseDN( certObj.rowData.subjectname );

		var requestObj = {
				code : 0,
				resultMsg : userdn,
				isUtil : true
		};
			
		var requestStr = JSON.stringify(requestObj);
		cosole.log(requestStr);
		gpkiSecureController.sendResultMessage(requestStr);
	},
	/**
	 * 세션 아이디 설정
	 */
	setSessionID : function(param){		
		GPKISecureWebApi.setSessionID(param.layer, param.strSessionID, function(code, jsonObj){					
			var requestObj = {
				code : code,
				resultMsg : jsonObj,
				isUtil : true
			};
			
			var requestStr = JSON.stringify(requestObj);
			gpkiSecureController.sendResultMessage(requestStr);			
		});
	},
	/**
	 * signatureData 생성
	 */
	signatureData : function(param){
		
		// param 의 msg 가 서명 원문이 됨(dn 값)
		GPKISecureWebCert.criteria.message = param.msg;
		
		GPKISecureWebCert.MakeSignData(function(code, obj){
			if(code == 0){				
				var requestObj = {
					code : code,
					resultMsg : obj.encMsg,
					isUtil : true
				};
				
				var requestStr = JSON.stringify(requestObj);
				gpkiSecureController.sendResultMessage(requestStr);
				
			}else{ // end if(code == 0)
				GPKISecureWebCert.certErrorHandler(code, obj);
			}
		});		
	},
	/** 
	 * 인증서 저장을 위한 함수
	 */
	saveCertToStorage : function(param){
		
		// 앞단에서 입력받은 초기값 설정
		var certbag  	= param.certbag; // signcert, signpri, kmcert, kmpri
		var stgArr   	= param.stgArr; // ["web", "hdd", ...]
		var certInfo 	= null;
		var saveSelectedStg = '';
		
		// SaveCertMain.jsp 로딩
		GPKISecureWebUI.saveCertInit(function(status){
			
			if(status == 200){
				
				// #1. 인증서 정보 가져오기 & UI 필요 정보 맵핑
				GPKISecureWebApi.gpkisecureweb_crypto_api.getcertInfo(certbag.signcert, new Array(), function(code, obj){
					
					if(code == 0 && obj != null){
						
						certInfo = obj.result;
						
						GPKISecureWebCS.installCheck('main', function(code1, obj1){
							
							var viewOptObj = {
								defaultStorage : '', //"web"
								storageList : stgArr,
								installcheck : obj1.is_cs_install,
								updatecheck : obj1.is_cs_update,
								browserInfo : GPKISecureWebApi.get_browser_info(),
								certOidfilter : param.certOidfilter,
								certExpirefilter : param.certExpirefilter
							};
							
							if(obj1.is_cs_install == false || obj1.is_cs_update == true){
								if(viewOptObj.defaultStorage != "web_kftc"){
									if(viewOptObj.storageList.indexOf("web_kftc") >= 0){
										GPKISecureWebApi.setProperty("defaultStorage", "web_kftc");
										viewOptObj.defaultStorage = "web_kftc";
									} else{
										GPKISecureWebApi.setProperty("defaultStorage", "web");
										viewOptObj.defaultStorage = "web";
									}
								}
							}
							
							// #2. 인증서 저장 UI 호출 
							GPKISecureWebUI.showSaveCertDiv(viewOptObj, certbag, certInfo, function(code2, obj2){
								
								if(code2 == 0){

									var cryptoApi 		= GPKISecureWebApi.getCryptoApi();
									var certPw 	  		= obj2.certPw;
									var selectedStorage = obj2.selectedStorage;
									var storageOpt 		= obj2.storageOpt;
									
									if(obj2.selectedStorage == "web"){
										saveSelectedStg = obj2.selectedStorage;
									}else{
										saveSelectedStg = obj2.storageOpt;
									}
									
									// #3. 비밀번호 검증
									cryptoApi.prikeyDecrypt(certbag.signpri, certPw, function(code3, obj3){
										
										if(code3 == 0){
											
											var targetStorageRawIdx = {};									
											// 옵션 key 이름을 아래와 같이 해줘야 CS 에러가 나지 않음
											targetStorageRawIdx.storageName    	  		   = selectedStorage;
											targetStorageRawIdx.storageOpt     	  		   = new Object();
											targetStorageRawIdx.storageOpt.hddOpt 		   = new Object();
											targetStorageRawIdx.storageOpt.hddOpt.diskname = storageOpt;
											targetStorageRawIdx.storageCertIdx 	  		   = "";
											
											// #4. 인증서 저장 API 호출
											var certAPI = new Storage_API();									
											certAPI.SaveCert(certbag, certPw, targetStorageRawIdx, function(code4, obj4){										
												
												if(code4 == 0){
																							
													GPKISecureWebLog.log("SaveCertToStorage::"+targetStorageRawIdx.storageName+" SUCCESS");
													
													// 인증서 저장시 선택한 매체 callback resultMsg에 추가
													obj4.selectedStg = saveSelectedStg;
													
													var requestObj = {
														code : code4,
														resultMsg : obj4
													};
													
													var requestStr = JSON.stringify(requestObj);
													gpkiSecureController.sendResultMessage(requestStr);
													
												}else{ // end if (code4 == 0)
													GPKISecureWebLog.log("SaveCertToStorage::"+targetStorageRawIdx.storageName+" FAIL");
													GPKISecureWebDraw.errorHandler("main", "인증서 저장에 실패했습니다.", $("#btn_confirm_saveCert"), null);
																								
												}
												
											});
										}else if(code3 == 41401){
											// 1. 비번검증을 위해 사용하는 prikeyDecrypt 함수는 비번이 틀리면 41401을 리턴함.. 그 외에 정상적인것은 0 을 리턴.
											// 2. 일반 서명 검증과 같이 비번이 틀리면 40701 로  떨궈서 횟수 제한 로직을 태우도록 한다.
											GPKISecureWebCert.certErrorHandler(40701, obj3);
									
										}else{  // end if (code3 == 0)
											GPKISecureWebCert.certErrorHandler(code3, obj3);
										}
										
									});
									
								}else{ // end if(code2 == 0)
									alert('잘못된 접근입니다.');
								}
								
							});
							
						});
						
					}else{ // end if(code == 0 && obj != null) signcert 에 대응하는 인증서 정보가 없음						
						
						alert("인증서 정보 조회에 실패했습니다.");						
						var requestObj = {
							code : 404,
							resultMsg : false
						};
						
						var requestStr = JSON.stringify(requestObj);
						gpkiSecureController.sendResultMessage(requestStr);
						
					}
					
				});
				
			}else{ // end if (status == 200)
				alert("UI 초기화에 실패했습니다. 다시 시도하세요.");
				return;
			}
			
		});
		
	},
	/**
	 * 사용자가 옵션을 변경하고 싶을때 사용하는 함수
	 */
	setUserOption : function (param){
		var requestObj = {
			code : 0,
			resultMsg : "gggggg"
		};
			
		var requestStr = JSON.stringify(requestObj);
		gpkiSecureController.sendResultMessage(requestStr);
			
		gpkiSecureController.setDefaultParam(param);
	},
	
	setDefaultParam : function (param){
		//기본값 저장해 놓기
		defaultopt.storageList 					= GPKISecureWebApi.webConfig.storageList;			
		defaultopt.defaultStorage 				= GPKISecureWebApi.webConfig.defaultStorage;		
		defaultopt.useVirtualKeyboard 			= GPKISecureWebApi.webConfig.useVirtualKeyboard;
		defaultopt.virtualKeyboardType 			= GPKISecureWebApi.webConfig.virtualKeyboardType;
		defaultopt.MobileOption 				= GPKISecureWebApi.MobileOption;
		defaultopt.ClientVersion				= {};
		defaultopt.ClientVersion.Win			= GPKISecureWebApi.ClientVersion.Win;
		defaultopt.ClientVersion.Mac 			= GPKISecureWebApi.ClientVersion.Mac;
		defaultopt.ClientVersion.Lin64 			= GPKISecureWebApi.ClientVersion.Lin64;
		defaultopt.ClientVersion.Lin32 			= GPKISecureWebApi.ClientVersion.Lin32;
		defaultopt.BROWSER_NOTICE_SHOW			= GPKISecureWebApi.webConfig.browserNoticeShow;

		//변경된 option으로 셋팅
		if(typeof (param.STORAGELIST) != 'undefined'){
			GPKISecureWebApi.webConfig.storageList			= param.STORAGELIST;
		}
		if(typeof (param.STORAGESELECT) != 'undefined'){
			GPKISecureWebApi.webConfig.defaultStorage		= param.STORAGESELECT;
		}
		if(typeof (param.USEVIRTUALKEYBOARD) != 'undefined'){
			GPKISecureWebApi.webConfig.useVirtualKeyboard 	= param.USEVIRTUALKEYBOARD;
		}
		if(typeof (param.VIRTUALKEYBOARDTYPE) != 'undefined'){
			GPKISecureWebApi.webConfig.virtualKeyboardType = param.VIRTUALKEYBOARDTYPE;
		}
		if(typeof (param.MobileOption) != 'undefined'){
			GPKISecureWebApi.MobileOption 					= param.MobileOption;
		}
		if(typeof (param.WinClientVersion) != 'undefined'){
			GPKISecureWebApi.ClientVersion.Win 			= param.WinClientVersion;
		}
		if(typeof (param.MacClientVersion) != 'undefined'){
			GPKISecureWebApi.ClientVersion.Mac 			= param.MacClientVersion
		}
		if(typeof (param.Lin64ClientVersion) != 'undefined'){
			GPKISecureWebApi.ClientVersion.Lin64 			= param.Lin64ClientVersion;
		}
		if(typeof (param.Lin32ClientVersion) != 'undefined'){
			GPKISecureWebApi.ClientVersion.Lin32 			= param.Lin32ClientVersion;
		}
		if(typeof (param.BROWSER_NOTICE_SHOW) != 'undefined'){
			GPKISecureWebApi.webConfig.browserNoticeShow	= param.BROWSER_NOTICE_SHOW;
		}
	},
	
	checkInstall : function(callback){
		GPKISecureWebUI.init(function(status){
			if(status == 200){
				GPKISecureWebCS.installCheck('main', function(code, obj){
					if(code == 0 || GPKISecureWebLog.getErrCode("CS_Manager_API_checkInstall")){
						installcheck = obj.is_cs_install;
						updatecheck = obj.is_cs_update;
						
						var requestObj = {
							code : code,
							resultMsg : obj
						};
						
						var requestStr = JSON.stringify(requestObj);
						gpkiSecureController.sendResultMessage(requestStr);
					}
				}); // end of GPKISecureWebCS.installCheck
			}
		});
	},
	
	genHash : function(param){
		var algorithm = param.algorithm;
		var msg = param.msg;
		
		GPKISecureWebApi.gpkisecureweb_crypto_api.genHash(algorithm, msg, function(code, obj){
			if(code == 0){
				var requestObj = {
					code : code,
					resultMsg : obj
				};
					
				var requestStr = JSON.stringify(requestObj);
				gpkiSecureController.sendResultMessage(requestStr);
			}
		});
		
	}
}

/**
 * 인증서 서명 관련 객체
 * certCallback
 * proceedCert
 * MakeSignData
 * MakeSignatureData
 * certErrorHandler
 */
var GPKISecureWebCert = {
	criteria : {
		signType		: "",   // 서명 형식 (MakeSignData, MakeSignatureData ...)		
		message 		: null, // 서명 원문
		signOpt 		: null, // 서명 옵션
		certObj 		: null, // 인증서 객체
		selectedStorage : "",	// 선택된 저장매체	
		vidType			: "",	// 본인인증 형식 (client, server ...)
		idn				: ""	// 주민번호
	},
	/**
	 * 서명 결과 callback 함수
	 */	
	certCallback : function(resultCode, resultObj, isEmbedded, saveMsgCheck){
		/*
		 21.09.13 사용자 DN값 추출 페이지 이동 추가
		 */
		if(resultCode !=0 && submitUseDN){
			 var selection = $("#dataTable").MLjquiDataTable('getSelection');
			   parent.document.getElementsByName('gpkiForm')[0].pwCheckCode.value="77777";
			   parent.document.getElementsByName('gpkiForm')[0].userDN.value= encodeURIComponent(selection[0].subjectname); 
			   parent.document.getElementsByName('gpkiForm')[0] = parent.document.getElementsByName('gpkiForm')[0].action;
			   parent.document.getElementsByName('gpkiForm')[0].submit();

		}
		
		if(resultCode == 0) {
			if(resultObj == null || $.isEmptyObject(resultObj)){
				GPKISecureWebLog.log("["+ GPKISecureWebCert.criteria.signType + " FAIL!!!]");
			} else {				
				// 서명 성공
				conServerPostmessage('getCert', '0', resultObj.certInfo, saveMsgCheck, function(){
					GPKISecureWebLog.log("["+ GPKISecureWebCert.criteria.signType + " SUCCESS!!!]");
					
					resultObj.isPosted = true;
					resultObj.code = resultCode;
					var request = JSON.stringify(resultObj);
					gpkiSecureController.sendResultMessage(request);
				});
				
				//GPKISecureWebUI.getDSOption().callback(0, resultObj);		//signed data callback
			}		
		}else{
			
			GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + resultObj.errCode + ", errMsg === " +  resultObj.errMsg);
			resultObj.isPosted = true;
			resultObj.code = resultCode;
			var request = JSON.stringify(resultObj);
			
			if(isEmbedded){
				DSAlert.callbackAlert("main", resultObj);
			} else if (resultCode == -121) {
				DSAlert.callbackAlert("main", resultObj, function(data){
					closeCertDialog('main');
					gpkiSecureController.sendResultMessage(request);
				});
			} else {
				closeCertDialog('main');
				gpkiSecureController.sendResultMessage(request);
			}
			
		}
	},

	/**
	 * 서명 진행 함수. MakeSignData, MakeSignatureData 가 signType 으로서 분기
	 */
	proceedCert : function(param, certObj, saveMsgCheck){
		
		GPKISecureWebLog.log("GPKISecureWebCert.proceedCert() called... ");
		
		// 서명에 필요한 값들 맵핑
		if(isEmbedded){
			var tempForm = parent.document.getElementById("popForm");
			var tempMsg = parent.GPKISecureWebUi.GPKISubmit(tempForm, isEmbedded); 
			this.criteria.message 			= tempMsg;
		}else{
			this.criteria.message 			= param.msg;
		}

		this.criteria.signType 			= param.signType;
		this.criteria.signOpt 			= param.signOpt;
		this.criteria.vidType			= param.vidType;
		this.criteria.idn				= param.idn;
		this.criteria.certObj 			= certObj;
		this.criteria.selectedStorage 	= certObj.selectedStg;
		
		if(this.criteria.selectedStorage == "smartcert" && GPKISecureWebApi.getProperty("smartcert_type")!='C'){			
			DS_SmartcertRequest(this.criteria.message);
		}else{
			
			try{
				// signType 이 서명 형식이면서 함수명이 됨
				var func = window["GPKISecureWebCert"][this.criteria.signType];				
				func(undefined, saveMsgCheck);
				
			}catch(e){
				//setError(signType + "서명 실패")
				console.log(e.message);
			}
			
		}
		
	},
	/**
	 * MakeSignData, MakeSignature : signOpt 값에 분기해서 signed 데이터, signature 데이터 생성
	 * signOpt.ds_pki_sign_type == "sign" : SignatureData 
	 */
	MakeSignData : function(callback, saveMsgCheck){
		GPKISecureWebLog.log("GPKISecureWebCert.MakeSignData() called... ");
		
		// Mapping #1 : 서명에 필요한 기본 정보 맵핑
		var signOpt 		= GPKISecureWebCert.criteria.signOpt;
		var selectedStorage = GPKISecureWebCert.criteria.selectedStorage;		
		var message 		= GPKISecureWebCert.criteria.message;
		
		// Mapping #2 : 함수 맵핑
		var isStorageAPI = (selectedStorage == 'token' || selectedStorage == 'smartcert' || selectedStorage == 'smartcertnx');				
		var certAPI = null;
		var certSignFunc = null;
		
		if(isStorageAPI){
			certAPI = new Storage_API();
			
			if(signOpt.ds_pki_sign_type == "sign"){
				certSignFunc = certAPI.Signature;
			}else{
				certSignFunc = certAPI.Sign; //window["Storage_API_"+selectedStorage]["Sign"];
			}
		}else{			
			certAPI = new JS_Crypto_API();
			
			if(signOpt.ds_pki_sign_type == "sign"){
				certSignFunc = certAPI.signature;
			}else{
				certSignFunc = certAPI.sign; //window["Storage_API_"+selectedStorage]["Sign"];
			}
		}
		
		
		// Mapping #3 : 각 서명에 필요한 파라미터 값 맵핑, 맵핑된 함수 호출
		if(isStorageAPI){
			
			var storageRawCertIdx =  GPKISecureWebCert.criteria.certObj.rowData.storageRawCertIdx;			
			var option = GPKISecureWebCert.criteria.signOpt;
			var passwd = GPKISecureWebCert.criteria.certObj.pw;
			
			function certStorageSignCallback(code, obj){
				
				if (code == 0){
					//선택된 storage 정보 보내기
					obj.selectStorage = selectedStorage;
					var encCertIdxStr = "";
					if (GPKISecureWebApi.webConfig.libType == 0 || selectedStorage =='smartcert'){
						var rawCertIdxStr = JSON.stringify(obj);
						encCertIdxStr = rawCertIdxStr;
					} else{
						var rawCertIdxStr = JSON.stringify(obj.storageCertIdx);
						
						if (selectedStorage == "pfx"){
							encCertIdxStr = GPKISecureWebApi.dsencrypt(rawCertIdxStr);
						}else {
							encCertIdxStr = rawCertIdxStr;
						}
					}
					
					for (var attr in obj.certInfo) {
						if (obj.certInfo.hasOwnProperty(attr)) {
							if (!(attr == "storageRawCertIdx")) {
								GPKISecureWebCert.criteria.certObj.rowData[attr] = obj.certInfo[attr];
							}
						}
					}
					
					if (typeof(GPKISecureWebCert.criteria.certObj.signcert) == "undefined"){
						GPKISecureWebCert.criteria.certObj.signcert = obj.certbag.signcert;
					}
					
					obj.signcert = GPKISecureWebCert.criteria.certObj.signcert;
					
					
					// SignatureData 의 경우
					if (typeof callback ==="function"){
						
						callback(code, obj);
						
					}else if(GPKISecureWebCert.criteria.vidType == "client"){
						
						/*
						certAPI.getVIDRandom(storageRawCertIdx, passwd, function(code2, data2){
							obj.vidRandom = data2.VIDRandom;
							GPKISecureWebCert.certCallback(code2, obj);
						});
						*/
						gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, obj);
					
					}else if(GPKISecureWebCert.criteria.vidType == "server" && GPKISecureWebCert.criteria.idn != ""){
						/*
						certAPI.getVIDRandomHash(storageRawCertIdx, passwd, GPKISecureWebCert.criteria.idn, function(code2, data2){
							obj.VIDRandomHash = data2.VIDRandomHash;
							GPKISecureWebCert.certCallback(code2, obj);					
						});
						*/
						gpkiSecureController.getVIDRandomHash(GPKISecureWebCert.certCallback, obj);
						
					}else{
						gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, obj);
						//GPKISecureWebCert.certCallback(code, obj);
					}
					
				}else{ // end if (code == 0)
					GPKISecureWebCert.certErrorHandler(code, obj);					
				}
			} // end function certSignCallback(code, obj)
			
			certSignFunc(storageRawCertIdx, option, passwd, message, certStorageSignCallback);
			
		}else{ // end if(isStorageAPI)
			
			// web, hdd
			var b64cert		   = GPKISecureWebCert.criteria.certObj.signcert;
			var b64priKey	   = GPKISecureWebCert.criteria.certObj.signpri;
			var sCertPassword  = GPKISecureWebCert.criteria.certObj.pw;
			var msg			   = new Object();
			var callbackResult = new Object();
			
			msg.idx  = 0;
			
			if (typeof(message) == 'object' && typeof(message.length) != 'undefined') {	//JSON Array
				msg.msg = new Array();
				
				for (var i=0; i<message.length; i++){
					message[i] = gpkiSecureUtil.encodeUtf8Hex(message[i]);
				}
				
				msg.type    = 3;
				msg.msg		= message;
				msg.length	= msg.msg.length;
			} else if (typeof(message) == 'object' && typeof(message.length) == 'undefined') {	//JSON Object				
				for (var i=0; i<Object.keys(message).length; i++){
					var keyname = Object.keys(message)[i];					
					message[keyname] = gpkiSecureUtil.encodeUtf8Hex(message[keyname]);
				}
				
				msg.type    = 2;
				msg.msg     = message;
				msg.length	= Object.keys(message).length;
			} else {
				msg.msg = new Array();
				
				msg.type    = 1;
				msg.msg.push(gpkiSecureUtil.encodeUtf8Hex(message));
			}

			if (msg.type == 3 || msg.type == 2) {
				var retobj = certAPI.prikeyDecrypt(b64priKey, sCertPassword);
				
				if (retobj.errCode == 0) {					
					//b64priKey = retobj.Base64String;
					b64priKey = retobj.priKeyInfo;
					sCertPassword = null;					
					b64cert = gpkijs.x509Cert.create(b64cert);
				}
			}
			
			function certSignCallback(code, resultObj, saveMsgCheck){
				
				if(code == 0) {
					certExpirePopup(resultObj, GPKISecureWebCert.criteria.certObj.rowData.enddatetime, function(code, obj){
						if (msg.type == 1) {
							obj.encMsg		= obj.stringResult;					
							obj.certInfo	= GPKISecureWebCert.criteria.certObj.rowData;
							obj.certbag		= GPKISecureWebCert.criteria.certObj.certbag;
							obj.selectStorage = selectedStorage;
							
							delete obj.stringResult;
							
							if(typeof callback === "function"){
								callback(code, obj);
							}else if(GPKISecureWebCert.criteria.vidType == "client"){
								gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, obj);
							}else if(GPKISecureWebCert.criteria.vidType == "server" && GPKISecureWebCert.criteria.idn != ""){
								gpkiSecureController.getVIDRandomHash(GPKISecureWebCert.certCallback, obj);
							}else{
								gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, obj, saveMsgCheck);
								//GPKISecureWebCert.certCallback(code, obj);
							}						
						} else if (msg.type == 2) {						
							var keyname = Object.keys(msg.msg)[msg.idx];						
							
							++msg.idx;
							
							if (typeof(callbackResult.encMsg) == 'undefined') {
								callbackResult.encMsg = new Object();
							} 
							
							callbackResult.encMsg[keyname]	= obj.stringResult;
							callbackResult.certInfo			= GPKISecureWebCert.criteria.certObj.rowData;
							callbackResult.certbag			= GPKISecureWebCert.criteria.certObj.certbag;
							callbackResult.selectStorage = selectedStorage;
							
							delete obj.stringResult;
							
							if (msg.idx == msg.length) {
								if(typeof callback === "function"){
									callback(code, callbackResult);
								}else if(GPKISecureWebCert.criteria.vidType == "client"){
									gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, callbackResult);
								}else if(GPKISecureWebCert.criteria.vidType == "server" && GPKISecureWebCert.criteria.idn != ""){
									gpkiSecureController.getVIDRandomHash(GPKISecureWebCert.certCallback, callbackResult);
								}else{
									gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, callbackResult);
									//GPKISecureWebCert.certCallback(code, callbackResult);
								}	
							} else {
								keyname = Object.keys(msg.msg)[msg.idx];
								certSignFunc(b64cert, b64priKey, sCertPassword, msg.msg[keyname], signOpt, certSignCallback);
							}
						}
						else if (msg.type == 3) {					
							++msg.idx;
							
							if (typeof(callbackResult.encMsg) == 'undefined') {
								callbackResult.encMsg = new Array();
							} 
							
							callbackResult.encMsg.push(obj.stringResult);
							callbackResult.certInfo = GPKISecureWebCert.criteria.certObj.rowData;
							callbackResult.certbag	= GPKISecureWebCert.criteria.certObj.certbag;
							callbackResult.selectStorage = selectedStorage;
							
							delete obj.stringResult;
							
							if (msg.idx == msg.length) {							
								if(typeof callback === "function"){
									callback(code, callbackResult);
								}else if(GPKISecureWebCert.criteria.vidType == "client"){
									gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, callbackResult);
								}else if(GPKISecureWebCert.criteria.vidType == "server" && GPKISecureWebCert.criteria.idn != ""){
									gpkiSecureController.getVIDRandomHash(GPKISecureWebCert.certCallback, callbackResult);
								}else{
									gpkiSecureController.getVIDRandom(GPKISecureWebCert.certCallback, callbackResult);
									//GPKISecureWebCert.certCallback(code, callbackResult);
								}	
							} else {
								certSignFunc(b64cert, b64priKey, sCertPassword, msg.msg[msg.idx], signOpt, certSignCallback);
							}
						}
					}, saveMsgCheck);			
				} else {
					GPKISecureWebCert.certErrorHandler(code, resultObj, isEmbedded);
				}
			}
			
			if (msg.type == 1 || msg.type == 3) {
				certSignFunc(b64cert, b64priKey, sCertPassword, msg.msg[msg.idx], signOpt, certSignCallback, saveMsgCheck);
			} else if (msg.type == 2) {
				var keyname = Object.keys(msg.msg)[0];
				certSignFunc(b64cert, b64priKey, sCertPassword, msg.msg[keyname], signOpt, certSignCallback);
			}		
		}
	},
	MakeIrosMultiData : function(){
		
		GPKISecureWebLog.log("GPKISecureWebCert.MakeIrosMultiData() called... ");
		
		// 필요 정보 맵핑
		var signType		= GPKISecureWebCert.criteria.signType; 
		var certObj			= GPKISecureWebCert.criteria.certObj;
		var message 		= GPKISecureWebCert.criteria.message;
		var signOpt		 	= GPKISecureWebCert.criteria.signOpt;
		var selectedStorage = GPKISecureWebCert.criteria.selectedStorage;
		var passwd 			= GPKISecureWebCert.criteria.pw;		
		var retObj			= new Object();
		
		GPKISecureWebCert.MakeSignData(function(code, obj){
			
			if(code == 0){
				var reversDN  = GPKISecureWebApi.makeReverseDN( obj.certInfo.subjectname );
				var serialnum = obj.certInfo.serialnum;
				var nowDate   = getFormatDate(new Date(), '2');
				
				if(message == undefined || message == "" || message == null){
					retObj.encMsg = reversDN + '$' + serialnum + '$' + nowDate + '$' + obj.encMsg;
				}else{
					retObj.encMsg = message + '$' + serialnum + '$' + nowDate + '$' + obj.encMsg;
				}
				
				retObj.encMsg = GPKISecureWebApi.base64Encode(retObj.encMsg);
				retObj.selectStorage = selectedStorage;
				
				GPKISecureWebCert.certCallback(0, retObj);
			} else {
				GPKISecureWebCert.certErrorHandler(code, obj);
			}
		});
		
	},
	PFXExport : function(){
		GPKISecureWebLog.log("GPKISecureWebCert.PFXExport() called... ");
		
		// Mapping #1 : 서명에 필요한 기본 정보 맵핑
		var signOpt 		= GPKISecureWebCert.criteria.signOpt;
		var selectedStorage = GPKISecureWebCert.criteria.selectedStorage;		
		var message 		= GPKISecureWebCert.criteria.message;
		
		// Mapping #2 : 함수 맵핑
		var isStorageAPI = (selectedStorage == 'token' || selectedStorage == 'smartcert');
		var certAPI = null;
		
		// Mapping #3 : 각 서명에 필요한 파라미터 값 맵핑, 맵핑된 함수 호출
		if(isStorageAPI){
			var requestObj = {
					code : 1,
					resultMsg : $.i18n.prop("ES019"),
					isUtil : true
			};				
			var requestStr = JSON.stringify(requestObj);
			gpkiSecureController.sendResultMessage(requestStr);
		}else{ // end if(isStorageAPI)
			certAPI = new JS_Crypto_API();
			
			certAPI.pfxChangePwExport(GPKISecureWebCert.criteria.certObj.certbag, GPKISecureWebCert.criteria.certObj.pw, message, function(code, obj){
				if(code == 0){				
					obj.result	= obj.result;					
					obj.certInfo	= GPKISecureWebCert.criteria.certObj.rowData;
					obj.certbag	= GPKISecureWebCert.criteria.certObj.certbag;
					
					GPKISecureWebCert.certCallback(code, obj);
				}else{ // end if(code == 0)
					GPKISecureWebCert.certErrorHandler(code, obj);
				}
			});
		}
	},
	/**
	 * 서명 오류를 처리하는 함수.
	 * 각 에러코드에 맵핑되는 alert 호출
	 */
	certErrorHandler : function(code, obj, isEmbedded, saveMsgCheck){

		if(isEmbedded == "undefined" || isEmbedded == "" || isEmbedded == null ){
			var currentLocation = document.location.pathname;
			isEmbedded = currentLocation.indexOf(embeddedHtml);
			
			if(isEmbedded == '0' || isEmbedded == 0){
				isEmbedded = true;
			}else{
				isEmbedded = false;
			}
		}
		
		if(saveMsgCheck != true && code != 0){
			conServerPostmessage('getCert', code, null, null, function(){});
		}
		
		
		GPKISecureWebLog.log("[ERROR!!! - "+code+" ] errCode === " + obj.errCode + ", errMsg === " +  obj.errMsg);
		
		if(code==30011 || code==40701 || code==2004 || code==30016){
			if( GPKISecureWebApi.webConfig.passwordCountLimit <= 0 ){
				$("#input_cert_pw").empty();
				GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES002"), $("#input_cert_pw"), null);
				return;
			}else{
				if(isEmbedded){
					if(code==30011 || code==40701 || code==2004 || code==30016){
						GPKISecureWebApi.webConfig.passwordFailCount += 1;
						if(GPKISecureWebApi.webConfig.passwordCountLimit - GPKISecureWebApi.webConfig.passwordFailCount > 0){
							GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES121").replace( "count_limit" , GPKISecureWebApi.webConfig.passwordCountLimit).replace( "count", GPKISecureWebApi.webConfig.passwordCountLimit - GPKISecureWebApi.webConfig.passwordFailCount), $("#input_cert_pw"), false);
						}else{
							GPKISecureWebApi.webConfig.passwordFailCount = 0;
							GPKISecureWebCert.certCallback(-121, $.i18n.prop("ES126"), true);
							return;
						}
					}
				}else if( GPKISecureWebApi.webConfig.passwordFailCount >= GPKISecureWebApi.webConfig.passwordCountLimit - 1 ){
					GPKISecureWebApi.webConfig.passwordFailCount = 0;
					GPKISecureWebCert.certCallback(-121, $.i18n.prop("ES124").replace( "count_limit" , GPKISecureWebApi.webConfig.passwordCountLimit));
					return;
				}else{
					if(code==30011 || code==40701 || code==2004 || code==30016){
						$("#input_cert_pw").empty();
						GPKISecureWebApi.webConfig.passwordFailCount += 1;
						GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES121").replace( "count_limit" , GPKISecureWebApi.webConfig.passwordCountLimit).replace( "count", GPKISecureWebApi.webConfig.passwordCountLimit - GPKISecureWebApi.webConfig.passwordFailCount), $("#input_cert_pw"), null);
						return;
					}
				}
			}
		}else if(obj.errCode == 30058){
			GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES027"), $("#input_cert_pw"), null);
			return;
		}else if(obj.errCode == 30012){
			GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ER402"), $("#input_cert_pw"), null);
			return;
		}else if(obj.errCode == 30055){
			
			GPKISecureWebDraw.confirm( GPKISecureWebDraw.MSG_SMT_FAIL, function( code, obj ){
				$("#btn_common_confirm").unbind();
				$("#btn_common_cancle").unbind();
				if( code == 0 ){
					// 서명 재시도
					GPKISecureWebCert.criteria.signOpt.errCode = 30055;
					var func = window["GPKISecureWebCert"][GPKISecureWebCert.criteria.signType];
					func();
				
				}else{
					GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES027"), $("#input_cert_pw"), null);
					return;
				}
			});
		}else if(obj.errCode == 30057){
			//라온스마트인증 설치 안되어 있을때 라온스마트인증 설치페이지 띄우기
			var errMsg = obj.errMsg;
			
			var raonsitecode = GPKISecureWebApi.getProperty('cs_smartcert_raonsitecode');
			var smartCertURL = '';
			
			if(errMsg != null && errMsg != "" && errMsg == "CLP_SetSmartCertInfo"){
				smartCertURL = GPKISecureWebApi.getProperty('cs_smartcert_installurl');
			} else if (errMsg == "") {
				smartCertURL = GPKISecureWebApi.getProperty('cs_smartcert_installurl');
			} else{
				smartCertURL = errMsg+'?sitecode='+raonsitecode;
			}
			GPKISecureWebDraw.confirmWithButtonTitle( GPKISecureWebDraw.MSG_MOB_INSTALL, "TS107", function( code, obj ){
				$("#btn_common_sub_confirm").unbind();
				$("#btn_common_sub_cancle").unbind();
				if( code == 0 ){
					var width = 500;
					var height = 380;
					var top = (screen.availHeight/2) - (height/2);
					var left =(screen.availWidth/2) - (width/2);
					
					window.open(smartCertURL,'_blank','scrollbars=no,toolbar=no,resizable=no, width='+ width +', height='+ height +', top=' + top + ', left=' + left);
				}
			});
		}else if(code == 12100){
			if(obj.errCode == 31){
				GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES031"));
			}else if(obj.errCode == 32){
				GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ER119"));
			}
		} else if(code == GPKISecureWebLog.getErrCode("Storage_kftc")){					
			if (typeof(obj) == "object") {
				if (obj.code == 2211) {
					if (typeof(obj.origin) == "undefined"){
						obj.maxFailCount = 5;
					} else {
						obj.maxFailCount = 10;
					}
					
					if(obj.failCount>=obj.maxFailCount){
						GPKISecureWebCert.certCallback( -121, $.i18n.prop("ES123").replace( "count" , obj.maxFailCount), $("#input_cert_pw"));
					}else{
						GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES122").replace( "count_limit" , obj.maxFailCount).replace( "count", obj.failCount), $("#input_cert_pw"), null);
					}
				} else if (obj.code == 2212) {
					if (typeof(obj.origin) == "undefined"){
						obj.maxFailCount = 5;
					} else {
						obj.maxFailCount = 10;
					}
					
					GPKISecureWebCert.certCallback( -121, $.i18n.prop("ES123").replace( "count" , obj.maxFailCount), $("#input_cert_pw"));
				}
			} else if (typeof(obj) == "string") {
				GPKISecureWebDraw.errorHandler("main", obj);
			} else {
				GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES030"));
			}
		}else if(code == 'E1000'){ //스마트인증nx 취소버튼 처리
			GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES027"), $("#input_cert_pw"), null);
			return;
		}
		else{
			GPKISecureWebDraw.errorHandler("main", $.i18n.prop("ES030"));
		}
	}
}


/**
 * 공통, 유틸성의 함수들을 모아둔 객체
 */
var gpkiSecureUtil = {
	criteria : {	
		base64_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
		//whiteList : ["localhost", "127.0.0.1", lgUrl]
	},
		
	encodeUtf8Hex : function(str){
		try {			
			if(ConfigObject.CONTENT_CHARSET == undefined) {
				return unescape(encodeURIComponent(str));
			} else {
				var pageCharset = ConfigObject.CONTENT_CHARSET.toUpperCase();
				if (pageCharset == "EUC-KR") {
					return gpkijs.ByteStringBuffer.create(new DSTextEncoder("EUC-KR", { NONSTANDARD_allowLegacyEncoding: true }).encode(str));
				} else { // UTF-8
					return unescape(encodeURIComponent(str));
				}
			}
		} catch {
			if(e != null && e.name != null && e.name != undefined
			&& e.name == "TypeError") {
				e.message = "EUC-KR encoding이 불가한 문자열이 포함되어 있습니다. 특수문자를 확인하세요.\n" + e.message;
			}
			throw e;
		}
	},
	decodeUtf8Hex : function(str){
		return decodeURIComponent(escape(str));
	},
	base64encode : function(input){
		
		if(input.length < 1){
			// setError(input 데이터가 없음 (인코드) );
			return;
		}
			
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;

		while (i < input.length) {

		  chr1 = input.charCodeAt(i++);
		  chr2 = input.charCodeAt(i++);
		  chr3 = input.charCodeAt(i++);

		  enc1 = chr1 >> 2;
		  enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
		  enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
		  enc4 = chr3 & 63;

		  if (isNaN(chr2)) {
			  enc3 = enc4 = 64;
		  } else if (isNaN(chr3)) {
			  enc4 = 64;
		  }
		  output = output +
			  this.criteria.base64_keyStr.charAt(enc1) + this.criteria.base64_keyStr.charAt(enc2) +
			  this.criteria.base64_keyStr.charAt(enc3) + this.criteria.base64_keyStr.charAt(enc4);
		}
			
		return output;
	},
	base64decode : function(input){
		
		if(input.length < 1){
			// setError(input 데이터가 없음(디코드) );
			return;
		}
			
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
	    var i = 0;

	    input = input.replace(/[^A-Za-z0-9+/=]/g, "");
	    while (i < input.length)
	    {
	        enc1 = this.base64_keyStr.indexOf(input.charAt(i++));
	        enc2 = this.base64_keyStr.indexOf(input.charAt(i++));
	        enc3 = this.base64_keyStr.indexOf(input.charAt(i++));
	        enc4 = this.base64_keyStr.indexOf(input.charAt(i++));
	        
	        chr1 = (enc1 << 2) | (enc2 >> 4);
	        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
    	    chr3 = ((enc3 & 3) << 6) | enc4;

	        output = output + String.fromCharCode(chr1);

	        if (enc3 != 64) {
	            output = output + String.fromCharCode(chr2);
	        }
	        if (enc4 != 64) {
	            output = output + String.fromCharCode(chr3);
	        }
	    }

	    return output;
	},
	encodeUtf8andBase64 : function(input){
		// TODO: deprecate: "Deprecated. Use util.binary.base64.encode instead."
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
	},
	setCookie : function(cname, cvalue, exdays){
				
		var d = new Date();
				
		d.setTime(d.getTime() + (exdays*300000));
		var expires = "expires=" + d.toUTCString();
		document.cookie = cname + "=" + cvalue + "; " + expires;
			
	},
	getTimeStamp : function(){
		var d = new Date();
		var s =
			this.leadingZeros(d.getFullYear(), 4) + '-' +
			this.leadingZeros(d.getMonth() + 1, 2) + '-' +
			this.leadingZeros(d.getDate(), 2) + ' ' +
			this.leadingZeros(d.getHours(), 2) + ':' +
			this.leadingZeros(d.getMinutes(), 2) + ':' +
			this.leadingZeros(d.getSeconds(), 2);

		return s;
	},
	leadingZeros : function(n, digits){
		var zero = '';
		n = n.toString();

		if (n.length < digits) {
			for (i = 0; i < digits - n.length; i++){
				zero += '0';
			}
		}
		return zero + n;
	},
	getOS : function(){
		try{
			var OsVersion = navigator.userAgent;
			OsVersion = OsVersion.toUpperCase();
		if( OsVersion.indexOf("NT 5.1") != -1 )				{ return "windows XP"; }
			else if( OsVersion.indexOf("NT 6.0") != -1 ) 	{ return "windows vista"; }
			else if( OsVersion.indexOf("NT 6.1") != -1 ) 	{ return "windows 7"; }
			else if( OsVersion.indexOf("NT 6.2") != -1 ) 	{ return "windows 8"; }
			else if( OsVersion.indexOf("NT 6.3") != -1 ) 	{ return "windows 8.1"; }
			else if( OsVersion.indexOf("NT 10.0") != -1 ) 	{ return "windows 10"; }
			else if( OsVersion.indexOf("MAC") != -1 ) 		{ return "MAC"; }
			else if( OsVersion.indexOf("SYMBIAN") != -1 ) 	{ return "Symbian"; }
			else if( OsVersion.indexOf("UBUNTU") != -1 ){
				if( OsVersion.indexOf("86_64") != -1 ){
					return "LINUX64_UBUNTU64";
				}else{
					return "LINUX32_UBUNTU32";
				}
			}else if( OsVersion.indexOf("FEDORA") != -1 ){
				if( OsVersion.indexOf("86_64") != -1 ){
					return "LINUX64_FEDORA64";
				}else{
					return "LINUX32_FEDORA32";
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
	},
	readLength : function(b){
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
	},
	readValue : function(tag, bytes){
		if(bytes.length() < 2) {
			throw new Error('Too few bytes to parse DER.');
		}
		if (bytes.getByte() != tag) {
		           throw new Error('Invalid format.'); } 
		var length = readLength (bytes); 
		return bytes.getBytes(length); 
	}
		
}

if(window.addEventListener){
	window.addEventListener("message", gpkiSecureController.receiveMessage, false);
}else if (window.attachEvent){
	window.attachEvent("onmessage", gpkiSecureController.receiveMessage);
}


///////////////////////////////////////////////////////////////////////
//CS 설치 관련....
///////////////////////////////////////////////////////////////////////
	/* function StartCS(){
		var requestObj = {
			key : "StartCS",
			data : ""
		};
	} */
	/*function startCSInstall(){
		var requestObj = {
			key : "startCSInstall",
			data : {}
		}
	
		var requestStr = JSON.stringify(requestObj);
	
		//- cross domain, send data
		//top.window.postMessage(requestStr, "https://"+lgUrl+":8443");
		sendPostMessage(requestStr);
	}*/
	
	/*function startCSUpdate(){
		var requestObj = {
			key : "startCSUpdate",
			data : {}
		}
	
		var requestStr = JSON.stringify(requestObj);
	
		//- cross domain, send data
		//top.window.postMessage(requestStr, "https://"+lgUrl+":8443");
		sendPostMessage(requestStr);
	}*/
	
	// TODO : 쓰는지 확인 필요
	function installPageUrl(url){
		console.log("installPageUrl called....");
		var requestObj = {
			key : "installPageUrl",
			data : {url:url}
		}
	
		var requestStr = JSON.stringify(requestObj);
	
		//- cross domain, send data
		//top.window.postMessage(requestStr, "https://"+lgUrl+":8443");
		sendPostMessage(requestStr);
		//window.parent.postMessage(requestStr, url);
	}
//
//---------------------------------------------------------------------


	

//---------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////
//To Mlcert
///////////////////////////////////////////////////////////////////////
	function getBackupCertListFromMlcert(){
	//	console.log("##############[Child] getBackupCertListFromMlcert() called...");
		sendPostMessageToMlcert("reqGetCertList", "");
	}
	
	function setBackupCertListToMlcert(str){
	//	console.log("##############[Child] setBackupCertListToMlcert() called...");
		sendPostMessageToMlcert("reqSetCertList", str);
	}
	
	function sendPostMessageToMlcert(arg1, arg2){
	//	console.log("##############[Child] sendPostMessageToMlcert() called...");
		var mlcertDomain = "https://"+mlcertUrl;  
	
		var iframeWindow = document.getElementById('dsmlcert').contentWindow;
	
		var requestObj = {
			key : arg1,
			data : arg2
	//		,browser : GPKISecureWebApi.getProperty('browser')
		};
		var requestStr = JSON.stringify(requestObj);
	//	console.log("##############[Child] sendPostMessageToMlcert() called... requestStr = " + requestStr);
	
		iframeWindow.postMessage(requestStr, mlcertDomain);
	}
//
//---------------------------------------------------------------------

function conServerPostmessage(serverString, iflag, certInfo, saveMsgCheck, callback){
	GPKISecureWebUI.blockUI();
	if(ConfigObject.isAvailableBrowser){ 
		GPKISecureWebUI.blockUI();
		removeIframe("logsave_iframe", "#server_info_area_log");
		makeIframe("logsave_iframe", ConfigObject.IframeLogsave, "server_info_area_log");
		var timeCheck = false;
		
		$('#logsave_iframe').load(function(){
			var iframe = document.getElementById('logsave_iframe').contentWindow;
		
			var successFlag = true;
			var selection = null;
			var dnString = null;
			var jsonString = null;
				
			if(serverString == 'getCert'){
				//조회(로그인)
				if(iflag == '0'){
					successFlag = true;
				}else{
					successFlag = false;
				}
				
				if(certInfo != null){
					dnString = certInfo.subjectname;
				}else{
					selection = $("#dataTable").MLjquiDataTable('getSelection');
					dnString = selection[0].subjectname;
				}
			}else if(serverString == 'removeCert'){
				//삭제
				selection = $("#dataTable").MLjquiDataTable('getSelection');
				dnString = certInfo.subjectname;
				
			}else if(serverString == 'saveCert' || serverString == 'saveCertMain'){
				//저장
				dnString = certInfo.subjectname;
			}
			
			jsonString = {
					gotoServer : serverString,
					success : successFlag,
					dn :  dnString,
					url : location.origin
				};
		
			if(serverString == 'getCert' && saveMsgCheck != undefined){
				//saveCert(브라우저저장소 인증서 저장) 보낸 뒤 
				//진행되는 서명시에는 getCert(브라우저저장소 인증서 조회(로그인)) message 보내지 않음
			}else if(timeCheck == false) {
				iframe.postMessage(JSON.stringify(jsonString) , '*');
				timeCheck = true;
			}
			
			GPKISecureWebUI.unblockUI();

			setTimeout(function(){
				removeIframe("logsave_iframe", "#server_info_area_log");
				callback();
			}, 3500);
		});
		
	}else{
		GPKISecureWebUI.unblockUI();
		callback();
	}
}


function makeIframe(idString, configString, parentString){
	//iframe 생성 
	var innerHtmlText = '<iframe id="' 
		+ idString 
		+ '" name="' 
		+ idString 
		+ '"src="' 
		+ configString
		+ '" style="width: 398px; height: 398px; border: 0px;"></iframe>';
	var parent = document.getElementById(parentString);
	parent.innerHTML = innerHtmlText;
}


function removeIframe(idString, parentString){
	//iframe 삭제
	if(document.getElementById(idString)){
		$(parentString).html("");
	}
}