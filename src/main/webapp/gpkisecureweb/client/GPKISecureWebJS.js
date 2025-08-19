var GPKISecureWebJS = (function(context) {
	var elementCheck = document.getElementById("dscert");
	var currentLocation = document.location.pathname;
	
	if((elementCheck === null || elementCheck === "") ){
		var body   = document.getElementsByTagName('body')[0];
		var div    = document.createElement('div');
		var iframe = document.createElement('iframe');
		
		iframe.setAttribute("id",			"dscert");
		iframe.setAttribute("name",			"dscert");
		iframe.setAttribute("src",			"");
		iframe.setAttribute("frameBorder",	"0");
		iframe.setAttribute("translate", 	"yes");
		
		var embeddedHtml = "";
		var isEmbedded = "";
		
		if(typeof(ConfigObject) == "undefined" || ConfigObject == null){
			//ConfigObject 선언되지 않았을 때는 팝업 처리
			isEmbedded = false;
		}else{
			embeddedHtml = ConfigObject.embeddedHtml;
			isEmbedded = currentLocation.indexOf(embeddedHtml);
		}
		
		if(isEmbedded == '0' || isEmbedded == 0){
			isEmbedded = true;
		}else{
			isEmbedded = false;
		}
		
		if(isEmbedded){
			iframe.setAttribute("scrolling",	"no");
			iframe.setAttribute("width",		"418px");
			iframe.setAttribute("height",		"400px");
		}else{
			iframe.setAttribute("scrolling",	"no%");
			iframe.setAttribute("width",		"100%");
			iframe.setAttribute("height",		"100%");
			iframe.setAttribute("style",		"position:fixed; z-index:100010; top:0px; left:0px; width:100%; height:100%;");

		}
		div.id    = "dscertContainer";
		div.style.display = "none";
		div.appendChild(iframe);
		body.appendChild(div);
	}
	
	var mGpkiJS 		= null;
	var mGpkiJSCrypto	= null;
	var mGenInterface	= null;
	var mSessionID		= null;
	var mServerCert		= null;
	var mSymmetricAlgo	= null;
	var mHashAlgo		= null;
	var mServerEncoding	= 2;
	var mClientEncoding	= 2;	
	var mResultObject	= new Object();
	
	this.Define = {SETPROP			: 0
		, Encoding_949				: 1
		, Encoding_UTF8				: 2
		, SETPROP_WORKDIR			: 1 // WorkDir
		, SETPROP_SERVERCERT		: 2 // ServerCert                                                              
		, SETPROP_SYMALGO			: 3 // Algorithm                                                               
		, SETPROP_HASHALGO			: 4 // Algorithm                                                               
		, SETPROP_LOADCERTTYPE		: 5 // LoadCertType (0:ALL,1:GPKI,2:NPKI,4:MPKI,8:PPKI)                        
		, SETPROP_POLICYID			: 6 // Policy                                                                  
		, SETPROP_SERIALNUM			: 7 // SerialNum                                                               
		, SETPROP_SUBDN				: 8 // SubjectDN                                                               
		, SETPROP_SMCARD			: 9 // SmCard (0:NONE, 1:T0,2:T1,4:금융맵)                                        
		, SETPROP_PHONE				: 10// Phone (0:NONE,1:UbiKey,2:MobileKey,4:PCRO)                              
		, SETPROP_LANGUAGE			: 11// Use Language (0:SYS,1:KOR,2:ENG, ...)                                   
		, SETPROP_APIType			: 12// WorkDir                                                                 
		, SETPROP_UBIKEYSITECODE	: 13// UbiKey(Site Code)                                                       
		, SETPROP_UBIKEYCOMPANYCODE	: 14// UbiKey(Company Code)                                                    
		, SETPROP_UBIKEYKEYBOARDCODE: 15// UbiKey(keyboard Code)                                                   
		, SETPROP_KEYBOARDOPT		: 16// 0:사용안함, 1:가상키패드, 2:키보드 보안                                               
		, SETPROP_UBIKEYVERSION		: 17// UbiKey version                                                          
		, SETPROP_UBIKEYPOPURL		: 18// UbiKey 설치팝업 URL                                                         
		, SETPROP_REPLACEISSUERNAME	: 19// IssuerName 변경 (기존:변경)                                                   
		, SETPROP_TOKENSMCERTHIDE	: 20// 보안토큰 리스트에서 스마트인증 숨기기                                                    
		, SETPROP_SMCERTSERVERDOMAIN: 21// 스마트인증 서버도메인                                                             
		, SETPROP_SMCERTSERVERPORT	: 22// 스마트인증 서버포트                                                              
		, SETPROP_SMCERTRAONCODE	: 23// 라온 SiteCode                                                             
		, SETPROP_SMCERTSUMIONDOMAIN: 24// 수미온 서버도메인                                                               
		, SETPROP_SMCERTSUMIONPORT	: 25// 수미온 서버포트                                                                
		, SETPROP_KEYBOARDSECTYPE	: 26// 키보드 보안 Type (0:none, 1:softcamp, 2:inca, 3:ahnlab, 4:softforum, 5:spacei
		, SETPROP_DS_PKI_CERT_PATH	: 27// 추가인증서 경로 설정                                                             
		, SETPROP_DS_PKI_POLICY_OID	: 28 // 추가인증서 정책 설정
		, PKI_CERT_SIGN_OPT_NONE			: 'OPT_NONE'				// 0
		, PKI_CERT_SIGN_OPT_USE_CONTNET_INFO: 'OPT_USE_CONTNET_INFO'	// 1                 
	    , PKI_CERT_SIGN_OPT_NO_CONTENT		: 'OPT_NO_CONTENT'			// 2                 
        , PKI_CERT_SIGN_OPT_SIGNKOREA_FORMAT: 'OPT_SIGNKOREA_FORMAT'	// 4                 
	    , PKI_CERT_SIGN_OPT_HASHED_CONTENT	: 'OPT_HASHED_CONTENT'		// 18                
	    , PKI_RSA_1_5						: 'rsa15'
	    , PKI_RSA_2_0						: 'rsa20'
	    , PKI_RSA_1_5_STRING				: 'RSASSA-PKCS1-V1_5'		// internal function 
	    , PKI_RSA_2_0_SIGN					: 'RSA-PSS'					// internal function     
	    , PKI_RSA_2_0_ENVELOP				: 'RSA-OAEP'				// internal function
    	/* 해쉬 알고리즘 */
    	//,HASH_ALG_APPLIED					: 'HASH_ALG_APPLIED'		// 0x00100000	/* 지정하는 메시지가 이미 해쉬가 적용되어있는경우 (즉, 원본이 아닌 MessageDigest 입력) 적용된 해쉬 알고리즘을 알수 있도록 해쉬 알고리즘과 함께 사용*/
    	//,HASH_ALG_NONE					: 'HASH_ALG_NONE'			// 0x00000000	/* HASH NONE*/
	    , HASH_ALG_CERT						: 'CertHash'				// 인증서해쉬
	    , HASH_ALG_SHA1						: 'SHA1'					// 0x00000001	/* SAH1 */
    	//,HASH_ALG_MD5						: 'HASH_ALG_MD5'			// 0x00000002	/* MD5 */
    	//,HASH_ALG_HAS160					: 'HASH_ALG_HAS160'			// 0x00000003	/* HAS160 */ 
    	, HASH_ALG_SHA256					: 'SHA256'					// 0x00000004	/* SHA256 */
    	, HASH_ALG_SHA512					: 'SHA512'					// 0x00000005	/* SHA512 */
		/* 대칭키 알고리즘 */
		//,SYM_ALG_DES_CBC					: 'SYM_ALG_DES_CBC'			// 0x10	/* DES CBC */
		, SYM_ALG_3DES_CBC					: 'des-EDE3'				// 0x20	/* 3DES CBC */
		, SYM_ALG_SEED_CBC					: 'seed'					// 0x30	/* SEED CBC */
		, SYM_ALG_ARIA_CBC					: 'aria128'					// 0x40	/* ARIA 128bit key CBC */
		, SYM_ALG_ARIA_192BIT_CBC			: 'aria192'					// 0x41	/* ARIA 192bit key CBC */
		, SYM_ALG_ARIA_256BIT_CBC			: 'aria256'					// 0x42	/* ARIA 256bit key CBC */
		, SYM_ALG_AES_CBC					: 'aes128'					// 0x50	/* AES 128bit key CBC */
		, SYM_ALG_AES_192BIT_CBC			: 'aes192'					// 0x51	/* AES 192bit key CBC */
		, SYM_ALG_AES_256BIT_CBC			: 'aes256'					// 0x52	/* AES 256bit key CBC */
		//,SYM_ALG_RC4_CBC					: 'SYM_ALG_RC4_CBC'			// 0x80	/* RC4 CBC */
		//,SYM_ALG_NEAT_CBC					: 'SYM_ALG_NEAT_CBC'		// 0xE0	/* NEAT CBC */
		//,SYM_ALG_NES_CBC					: 'SYM_ALG_NES_CBC'			// 0xF0	/* NES CBC */
		
	}
	
	this.ErrCode = {AXERR_OK:	0
		// Base64ContentInfo
		, ERR_NONE_EXIST_CONTENT_TYPE 	: {code: 500,	message: 'Content Type Not Found'}
		, ERR_NONE_PREPOSITION_TAG 		: {code: 501,	message: '선행태그를 찾지 못하였습니다.'}
		, ERR_NONE_POSTPOSITION_TAG 	: {code: 502,	message: '후행태그를 찾지 못하였습니다.'}
		// GPKISecureWebXPlugin API
		, AXERR_NOTSETPROPERTY 			: {code: 30001,	message: '초기화 설정에 실패하였습니다.'}		
		, AXERR_INVALIDINPUT 			: {code: 30002,	message: '입력받은 데이터가 올바르지 않습니다.'}
		, AXERR_FAILINITALIZE 			: {code: 30003,	message: '초기화에 실패했습니다.'}			
		, AXERR_LOADLIBIARY	 			: {code: 30004,	message: '라이브러리 로드에 실패했습니다.'}
		, AXERR_NOTSUPPORTALG	 		: {code: 30005,	message: '지원하지 않는 알고리즘입니다.'}
		, AXERR_NOTINITALIZE	 		: {code: 30006,	message: '모듈이 초기화 되지 않았습니다. 초기화후 다시 시도하여주십시오.'}
		, AXERR_DATAENCODING	 		: {code: 30007,	message: '데이터의 인코딩 처리에 실패했습니다.'}
		, AXERR_MEMALLOC		 		: {code: 30008,	message: '메모리 할당에 실패하였습니다.'}
		// UI 관련
		, AXERR_GETSUBMEDIA				: {code: 30011,	message: '저장매체의 서브메뉴정보를 얻는데 실패하였습니다.'}
		, AXERR_NOTSUPPROTOS		 	: {code: 30012,	message: '지원하지 않는 OS 입니다.'}
		, AXERR_FAILLOADCERT		 	: {code: 30013,	message: '인증서 정보를 읽는데 실패하였습니다.'}
		, AXERR_FAILPROCESSCERT			: {code: 30014,	message: '인증서 정보를 처리하는데 실패하였습니다.'}
		, AXERR_LOADPFX					: {code: 30015,	message: 'PFX 파일이 없거나 파일 정보를 설정 하는데 실패하였습니다.'}
		, AXERR_NOCERT					: {code: 30016,	message: '선택한 저장매체에 인증서가 존재하지 않습니다.'}
		, AXERR_NOCERTINFODATA			: {code: 30017,	message: '선택한 인증서의 사용자 정보가 존재하지 않습니다.'}
		, AXERR_NOFIELDDATA				: {code: 30018,	message: '선택한 인증서의 필드값이 존재하지 않습니다.'}
		, AXERR_WRONGPASSWORD		 	: {code: 30019,	message: '잘못된 비밀번호입니다.'}
		, AXERR_NOTSELECTCERT		 	: {code: 30020,	message: '선택한 인증서가 없습니다. 인증서를 선택해 주십시오.'}
		, AXERR_INPUTVITUALPASSWORD		: {code: 30021,	message: '가상키패드를 이용해 비밀번호를 입력하여 주십시오.'}
		, AXERR_PROGRAMFILEPATH			: {code: 30022,	message: '환경정보를 읽는데 실패했습니다(ProgramFile).'}
		, AXERR_SYSTEMPATH				: {code: 30023,	message: '환경정보를 읽는데 실패했습니다(Sytem Directory).'}
		, AXERR_RUNUBIKEY			 	: {code: 30024,	message: '휴대폰 인증서 프로그램을 실행하는데 실패하였습니다.'}
		, AXERR_INSTALLUBIKEY		 	: {code: 30025,	message: '휴대폰 인증서 프로그램이 설치되어 있지 않거나 하위 버전입니다.'}
		, AXERR_INSTALLTOKNE		 	: {code: 30026,	message: '보안토큰 프로그램이 설치되어 있지 않습니다.'}
		, AXERR_INSTALLSMARTCERT	 	: {code: 30027,	message: '스마트인증 프로그램이 설치되어 있지 않거나 하위 버전입니다.'}
		, AXERR_VERIFYPKCS11		 	: {code: 30028,	message: 'PKCS11 프로그램의 서명값 검증에 실패하였습니다.'}
		, AXERR_NOTSUPPORTMEDIA			: {code: 30029,	message: '지원하지 않는 저장매체입니다.'}
		, AXERR_MEDIACONNECTFAIL	 	: {code: 30030,	message: '저장매체 연결에 실패하였습니다.'}
		, AXERR_MEDIAMANYCONNECT	 	: {code: 30031,	message: '저장매체가 하나이상이 연결되어 있습니다.'}
		, AXERR_SEARCHFILE				: {code: 30032,	message: '파일 및 폴더 검색에 실패하였습니다.'}
		, AXERR_GETPKCS12			 	: {code: 30033,	message: 'pfx파일 정보를 처리하는데 실패하였습니다.'}
		, AXERR_WRONGPINNUMBER			: {code: 30034,	message: '잘못된 핀번호 입니다.'}
		, AXERR_CANCEL					: {code: 30035,	message: '작업을 취소하였습니다.'}
		, AXERR_KEYSTROKE			 	: {code: 30036,	message: '키보드보안 모듈 로드에 실패했습니다.'}
		, AXERR_KEYSTROKE_GETFAIL	 	: {code: 30037,	message: '키보드 보안모듈로 부터 비밀번호 획득에 실패했습니다.'}
		// 암호화 관련
		, AXERR_NOTSERVERCERT			: {code: 30050,	message: '웹서버로부터 다운받은 서버인증서가 없습니다.'}
		, AXERR_SETSERVERCERT_FAIL		: {code: 30051,	message: '웹서버로부터 다운받은 서버인증서를 처리하는데 실패하였습니다.'}
		, AXERR_MAKESESSIONID_FAIL		: {code: 30052,	message: '세션정보 생성에 실패하였습니다.'}
		, AXERR_NOTEXISTSESSIONINFO		: {code: 30053,	message: '세션정보가 존재하지 않습니다.로그인후에 다시 이용하십시오.'}
		, AXERR_SETSESSIONINFO_FAIL		: {code: 30054,	message: '세션정보를 설정하는데 실패하였습니다.'}
		, AXERR_ENCRYPT_FAIL			: {code: 30055,	message: '메세지 암호화에 실패하였습니다.'}
		, AXERR_DECRYPT_FAIL			: {code: 30056,	message: '메세지 복호화에 실패하였습니다.'}
		, AXERR_HASH_FAIL				: {code: 30057,	message: '데이터의 해시 생성에 실패하였습니다.'}
		, AXERR_INVALIDHASH_FAIL		: {code: 30058,	message: '데이터 무결성 오류(해쉬값이 일치하지 않습니다)'}
		, AXERR_MAKEKDF_FAIL			: {code: 30059,	message: '서버와 암/복호화시 사용될 통신키 생성에 실패하였습니다.'}
		, AXERR_MAKEMSG_FAIL			: {code: 30060,	message: '서버로 전송할 암호화 메세지 생성에 실패하였습니다. // SignAndEnv, Env,Sign...'}
		, AXERR_PARSEMSG_FAIL			: {code: 30061,	message: '서버로부터 전송받은 메세지가 올바르지 않습니다.'}
		, AXERR_INVALID_DATA			: {code: 30062,	message: '입력받은 데이터가 올바르지 않습니다.'}
		, AXERR_VERIFYVID_FAIL			: {code: 30063,	message: '사용자 본인확인(VID) 검증에 실패하였습니다.'}
	}

	if (context != null && typeof(context) != "undefined" && typeof(context) == "object") {		
		mGpkiJS = context;
	}
	
	var mSessionInfo = {
		getEncryptedCert : function(string){
			try {
				if( string !== null && typeof string !== "undefined" && string !== ""){
					var cipher = gpkijs.cipher.create(true, "SEED-CBC" , gpkijs.hex.decode( "0b9f0bb6f0a89844aedecb9f2508c7e2" ));
					cipher.init( gpkijs.hex.decode( "69068374ba84d85b68eea844d2d2c187" ));
					cipher.update(string);
					cipher.finish();
					return gpkijs.base64.encode(cipher.output);
				}
			} catch (e){
				return string;
			}
		},
		
		getDecryptedCert : function(string){
			try {
				if( string !== null && typeof string !== "undefined" && string !== ""){
					var cipher = gpkijs.cipher.create(false, "SEED-CBC" , gpkijs.hex.decode( "0b9f0bb6f0a89844aedecb9f2508c7e2" ));
					cipher.init(gpkijs.hex.decode( "69068374ba84d85b68eea844d2d2c187" ));
					cipher.update(gpkijs.base64.decode(string));
					cipher.finish();
					return cipher.output.data;
				}
			} catch (e){
				return string;
			}
		},	
		
		findSessionInfo : function(sessionID) {
			var oResult = 0;
			
			try {
				if (typeof(window.localStorage) == "undefined") {
					throw {code: false, message:"not defined window.localStorage"};
				}
				if (sessionID == null || typeof(sessionID) == "undefined") {
					throw {code: false, message:"The input is invalid type.(sessionID)"};
				}
				
				var value = window.localStorage.getItem("GPKISecureWebJS");				
				value = mSessionInfo.getDecryptedCert(value);
				
				if (value == null) {
					throw {code: false, message:"GPKISecureWebJS getItem is null"};
				}
				
				var SessionInfo = JSON.parse(value);
				
				if (SessionInfo.hasOwnProperty(sessionID) == true) {
					var value = JSON.parse(SessionInfo[sessionID]);
					throw {code: true, message: value};
				} else {
					throw {code: false, message:"not find session"};
				}
			} catch (ex) {
				oResult = ex;			
			}
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			
			return oResult;
		},
		
		deleteSessionInfo : function(sessionID) {
			var oResult = 0;
			
			try {
				if (typeof(window.localStorage) == "undefined") {
					throw {code: false, message:"not defined window.localStorage"};
				}
				if (sessionID == null || typeof(sessionID) == "undefined") {
					throw {code: false, message:"The input is invalid type.(sessionID)"};
				}

				var value = window.localStorage.getItem("GPKISecureWebJS");
				value = mSessionInfo.getDecryptedCert(value);

				if (value == null) {
					throw {code: false, message:"GPKISecureWebJS getItem is null"};
				}
				
				var SessionInfo = JSON.parse(value);
				
				if (SessionInfo.hasOwnProperty(sessionID) == true) {
					delete SessionInfo[sessionID];					
					var encdata = mSessionInfo.getEncryptedCert(JSON.stringify(SessionInfo));
					window.localStorage.setItem("GPKISecureWebJS", encdata);					
					throw {code: true, message: "success"};
				}
				
			} catch (ex) {
				oResult = ex;			
			}
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			
			return oResult.code;
		},
	
		insertSessionInfo : function(sessionID, sessionInfo) {
			var oResult = 0;
			
			try {
				if (typeof(window.localStorage) == "undefined") {
					throw {code: false, message:"not defined window.localStorage"};
				}
				if (sessionID == null || typeof(sessionID) == "undefined") {
					throw {code: false, message:"The input is invalid type.(sessionID)"};
				}
				if (sessionInfo == null || typeof(sessionInfo) == "undefined") {
					throw {code: false, message:"The input is invalid type.(sessionInfo)"};
				}
				
				var value = window.localStorage.getItem("GPKISecureWebJS");
				var obj;   
				
				value = mSessionInfo.getDecryptedCert(value);

				if (value == null) {
					obj = new Object();
				} else {
					obj = JSON.parse(value);
				}
				
				obj[sessionID] = JSON.stringify(sessionInfo);
				var session    = JSON.stringify(obj);
				session = mSessionInfo.getEncryptedCert(session);
				
				window.localStorage.setItem("GPKISecureWebJS", session);

				oResult = {code:true, message:""};
			} catch (ex) {
				oResult = ex;			
			}
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			
			return oResult.code;
		}
	}
	
	GPKISecureWebJS.loadJavaScript = function(scriptUrl, className, callback) {
		var head     = document.getElementsByTagName('head')[0];
		var script   = document.createElement('script');
		var objectID = "DS" + className;  

		if (!document.getElementById(objectID)) {
			script.type = "text/javascript";
			script.src  = scriptUrl;
			script.id   = objectID;
			
			head.appendChild(script);
			
			var checkJS = setInterval(function() {			
				var classFunc = window[className];
				if (typeof(classFunc) == "function" || typeof(classFunc) == "object") {				
					clearInterval(checkJS);
					callback({code: 0, message: scriptUrl + " script load success"});
				}
			}, 100);
		} else {
			callback({code: 0, message: scriptUrl + " script already loaded"});
		}
	}
	
	GPKISecureWebJS.prototype.Init = function(callback) {
		var scriptList = [["../client/gpkijs_1.2.1.5.min.js",	"gpkijs"],
						  ["../client/GPKIJS_Crypto.js",		"GPKIJS_Crypto"],
						  ["../client/GenerateContent.js",		"GenInterface"]];
		
		if (document.getElementById("DSgpkijs") && document.getElementById("DSGPKIJS_Crypto") && document.getElementById("DSGenInterface")) {
			loadJavaScriptArraysuccess();
			return 0;
		}
		
		// 스크립트 로드
		loadJavaScriptArray(0, scriptList.length);
		
		function loadJavaScriptArray(index, size) {
			if (index == size) {
				return loadJavaScriptArraysuccess();				 
			} 
			
			GPKISecureWebJS.loadJavaScript(scriptList[index][0], scriptList[index][1], function(GenInterfaceCallback){
				if (GenInterfaceCallback.code == 0) {
					index = index + 1;
				}				
				loadJavaScriptArray(index, size);				
			});
		}
		
		function loadJavaScriptArraysuccess() {
			var license = ConfigObject.GPKIJS_LIC;
			
			mGpkiJS = gpkijs;
			mGpkiJS.init(license);
			
			mGpkiJSCrypto = new GPKIJS_Crypto(mGpkiJS);
			mGenInterface  = new GenInterface(mGpkiJS);
			
			mGenInterface.SetJSCrypto(mGpkiJSCrypto);
			
			if (typeof(callback) == "function") {
				callback(1);
			}
		}
		
		return 1;
	}
	
	GPKISecureWebJS.prototype.UnInit = function() {
		
	}
	
	GPKISecureWebJS.prototype.GetReturnData = function() {
		var obj = new Object();
		
		if (typeof(mResultObject) == "object" && typeof(mResultObject.message) != "undefined") {
			obj.ResultCode    = mResultObject.code;
			obj.ResultMessage = mResultObject.message;	
		}
		
		return JSON.stringify(obj);
	}
	
	GPKISecureWebJS.prototype.SetSessionID = function(sSessionID) {
		var oResult = new Object();
		
		oResult.code    = 0;
		oResult.message = "";
		
		try {
			if (sSessionID == null || typeof(sSessionID) == "undefined") {
				throw {code: GPKIClientJS.ErrCode.AXERR_SETSESSIONINFO_FAIL.code, message:GPKIClientJS.ErrCode.AXERR_SETSESSIONINFO_FAIL.message};
			}
			
			mSessionID = sSessionID;
		} catch(ex) {
			oResult = ex;
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}

		return oResult.code;
	}
	
	GPKISecureWebJS.prototype.SetProperty = function(nType, sInputData){
		if (nType == null || sInputData == null || typeof(sInputData) == "undefined") {
			return;
		}
		
		switch(nType) {
		case this.Define.SETPROP_WORKDIR:	
			break;
		case this.Define.SETPROP_SERVERCERT:
			mServerCert = sInputData;
			break;
		case this.Define.SETPROP_SYMALGO:
			switch(sInputData)
			{
			//case 1:mSymmetricAlgo = SYM_ALG_DES_CBC; break;
			case 2:  mSymmetricAlgo = this.Define.SYM_ALG_3DES_CBC; break;
			case 3:  mSymmetricAlgo = this.Define.SYM_ALG_SEED_CBC; break;
			//case 4:mSymmetricAlgo = SYM_ALG_NEAT_CBC; break;
			case 5:  mSymmetricAlgo = this.Define.SYM_ALG_ARIA_CBC; break;
			//case 6:mSymmetricAlgo = SYM_ALG_NES_CBC; break;
			}
			break;
		case this.Define.SETPROP_HASHALGO:
			switch(sInputData)
			{
			case 1:  mHashAlgo = this.Define.HASH_ALG_SHA1; break;
			//case 2:mHashAlgo = this.Define.HASH_ALG_MD5; break;
			case 3:  mHashAlgo = this.Define.HASH_ALG_HAS160; break;
			case 4:  mHashAlgo = this.Define.HASH_ALG_SHA256; break;			
			}
			break;
		case this.Define.SETPROP_LOADCERTTYPE:
			break;
		case this.Define.SETPROP_POLICYID:
			break;
		case this.Define.SETPROP_SERIALNUM:
			break;
		case this.Define.SETPROP_SUBDN:
			break;
		case this.Define.SETPROP_SMCARD:
			break;
		case this.Define.SETPROP_PHONE:
			break;
		case this.Define.SETPROP_LANGUAGE:
			// default : LANG_KOR
			//m_nLanguageType = LANG_KOR;
			break;
		case this.Define.SETPROP_APIType:
			// default : GPKIAPI
			//m_nAPIType = DSWRAPI_GPKI;
			break;
		case this.Define.SETPROP_UBIKEYSITECODE:
			break;
		case this.Define.SETPROP_UBIKEYCOMPANYCODE:
			break;
		case this.Define.SETPROP_UBIKEYKEYBOARDCODE:
			break;
		case this.Define.SETPROP_KEYBOARDOPT:
			break;
		case this.Define.SETPROP_UBIKEYVERSION:
			break;
		case this.Define.SETPROP_UBIKEYPOPURL:
			break;
		case this.Define.SETPROP_REPLACEISSUERNAME:
			break;
		case this.Define.SETPROP_TOKENSMCERTHIDE:
			break;
		case this.Define.SETPROP_SMCERTSERVERDOMAIN:
			break;
		case this.Define.SETPROP_SMCERTSERVERPORT:
			break;
		case this.Define.SETPROP_SMCERTRAONCODE:
			break;
		case this.Define.SETPROP_SMCERTSUMIONDOMAIN:
			break;
		case this.Define.SETPROP_SMCERTSUMIONPORT:
		case this.Define.SETPROP_KEYBOARDSECTYPE:
			break;
		case this.Define.SETPROP_DS_PKI_CERT_PATH:
			break;
		case this.Define.SETPROP_DS_PKI_POLICY_OID:
			break;
		}
	}
	
	GPKISecureWebJS.prototype.setServerEncoding = function(nEncoding){
		if (nEncoding == null || typeof(nEncoding) == "undefined") {
			return;
		}
		
		mServerEncoding = nEncoding;
	}
	
	GPKISecureWebJS.prototype.setClientEncoding = function(nEncoding){
		if (nEncoding == null || typeof(nEncoding) == "undefined") {
			return;
		}
		
		mClientEncoding = nEncoding;
	}
	
	GPKISecureWebJS.prototype.GetAPIVersion = function(){
		var oResult = 0;
		
		oResult = {code:0, message:"1.2.0.0"};
		
		return oResult;
	}
	
	GPKISecureWebJS.prototype.Login = function(sSiteID, sData, oCertBag, callback, isEmbedded) {
		
		
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			if (mGpkiJSCrypto == null || typeof(mGpkiJSCrypto) == "undefined" || typeof(mGpkiJSCrypto.JS_CMS_MakeSignedData) == "undefined") {
				throw {code:1001, message:"mGpkiJSCrypto API_NOT_INITIALIZED"};
			}
			if (mGenInterface == null || typeof(mGenInterface) == "undefined") {
				throw {code:1001, message:"mGenInterface API_NOT_INITIALIZED"};
			}
			if (mServerCert == null || typeof(mServerCert) == "undefined"){
				throw {code:1001, message:"ERR_NOT_EXIST_SERVER_CERT"};
			}
			
			var signOpt    = { ds_pki_sign:[mGpkiJSCrypto.Define.PKI_CERT_SIGN_OPT_NONE], ds_pki_rsa:mGpkiJSCrypto.Define.PKI_RSA_1_5};
			var envelopOpt = { ds_pki_rsa: mGpkiJSCrypto.Define.PKI_RSA_1_5 };
			
			// 세션찾기			
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == true) {
				mSessionInfo.deleteSessionInfo(sSiteID);				
			}
			
			/*
			//전자서명
			var oSignedData = mGpkiJSCrypto.JS_CMS_MakeSignedData(oCertBag.signcert, oCertBag.signpri, oCertBag.password, signOpt, sData);
			
			if (oSignedData.code != 0) {
				throw oSignedData;
			}*/
			gpkisecureweb.uiapi.MakeSignData( sData, null, function(code, message){
				if(code == 0){
					
					var oSignedData = message.encMsg;
					
					var oSignContentInfo = mGenInterface.MakeSignContentInfo(gpkijs.base64.decode(oSignedData), gpkijs.base64.decode(message.vidRandom));	
					
					if (oSignContentInfo.code != 0) {
						callback( {code: oSignContentInfo.code, message: oSignContentInfo} );
					}
					
					//전자봉투
					var oEnvelopData = mGpkiJSCrypto.JS_CMS_MakeEnvelopedData(mServerCert, mSymmetricAlgo, envelopOpt, oSignContentInfo.message);
					
					if (oEnvelopData.code != 0) {
						callback( {code: oEnvelopData.code, message: oEnvelopData} );
					}
					
					var envelopdataDer = oEnvelopData.message.toDer().data;
					// Make Content
					var oEnvContentInfo = mGenInterface.MakeContentInfo(mGenInterface.Define.LOGIN_ENVELOP_SIGN_DATA, envelopdataDer)
					
					if (oEnvContentInfo.code != 0) {
						callback( {code: oEnvContentInfo.code, message: oEnvContentInfo} );
					}

					// KDF
					var oKDF = mGenInterface.MakeKeyIV(sSiteID, mSymmetricAlgo, mHashAlgo, envelopdataDer);
					
					if (oKDF.code != 0) {
						callback( {code: GPKIClientJS.ErrCode.AXERR_MAKEKDF_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_MAKEKDF_FAIL.message} );
					}
					
					// Insert Sessioninfo
					mSessionInfo.insertSessionInfo(sSiteID, oKDF.message);
					
					oResult = {code:0, message:oEnvContentInfo.message};
					
					if (typeof(callback) == "function") {
						callback(oResult);
					}
					
					Object.assign(mResultObject, oResult);
					
					return oResult.code;
				} else if(code == 999) {
					// Login 함수 close 부분 
				}
			}, isEmbedded);
			
		} catch (ex) {
			oResult = ex;
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			
			Object.assign(mResultObject, oResult);
			
			return oResult.code;
		}
	}
	
	GPKISecureWebJS.prototype.SignedData = function(sSiteID, sData, oCertBag, callback) {
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			if (mGpkiJSCrypto == null || typeof(mGpkiJSCrypto) == "undefined" || typeof(mGpkiJSCrypto.JS_CMS_MakeSignedData) == "undefined") {
				throw {code:1001, message:"mGpkiJSCrypto API_NOT_INITIALIZED"};
			}
			if (mGenInterface == null || typeof(mGenInterface) == "undefined") {
				throw {code:1001, message:"mGenInterface API_NOT_INITIALIZED"};
			}
			if (mServerCert == null || typeof(mServerCert) == "undefined"){
				throw {code:1001, message:"ERR_NOT_EXIST_SERVER_CERT"};
			}
			
			var signOpt = { ds_pki_sign:[mGpkiJSCrypto.Define.PKI_CERT_SIGN_OPT_NONE], ds_pki_rsa:mGpkiJSCrypto.Define.PKI_RSA_1_5};

			// 세션찾기
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == true) {
				mSessionInfo.deleteSessionInfo(sSiteID);				
			}
			
			//전자서명
			/*var oSignedData = mGpkiJSCrypto.JS_CMS_MakeSignedData(oCertBag.signcert, oCertBag.signpri, oCertBag.password, signOpt, sData);
			
			if (oSignedData.code != 0) {
				throw oSignedData;
			}*/
			
			gpkisecureweb.uiapi.MakeSignData( sData, null, function(code, message){
				if(code == 0){
					
					var oSignedData = message.encMsg;
					
					//var oSignedDataMessage = oSignedData.message.toDer().data;
					var oSignedDataMessage = gpkijs.base64.decode(oSignedData);
					
					// Make Content
					var oSignContentInfo = mGenInterface.MakeContentInfo(mGenInterface.Define.SIGNED_DATA, oSignedDataMessage);
					
					if (oSignContentInfo.code != 0) {
						callback( {code: oSignContentInfo.code, message: oSignContentInfo} );
					}
					
					oResult = {code:0, message:oSignContentInfo.message};
				
					if (typeof(callback) == "function") {
						callback(oResult);
					}
					
					Object.assign(mResultObject, oResult);
					
					return oResult.code;
				} else if(code == 999) {
					// SignedData 함수 close 부분
				}
			});
		} catch (ex) {
			oResult = ex;
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			
			Object.assign(mResultObject, oResult);
			
			return oResult.code;
		}
	}
	
	GPKISecureWebJS.prototype.SignedDataWithVIDCheck = function(sSiteID, sData, sIDN, oCertBag, callback) {
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			if (sIDN == null || typeof(sIDN) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sIDN)"};
			}
			if (mGpkiJSCrypto == null || typeof(mGpkiJSCrypto) == "undefined" || typeof(mGpkiJSCrypto.JS_CMS_MakeSignedData) == "undefined") {
				throw {code:1001, message:"mGpkiJSCrypto API_NOT_INITIALIZED"};
			}
			if (mGenInterface == null || typeof(mGenInterface) == "undefined") {
				throw {code:1001, message:"mGenInterface API_NOT_INITIALIZED"};
			}
			if (mServerCert == null || typeof(mServerCert) == "undefined"){
				throw {code:1001, message:"ERR_NOT_EXIST_SERVER_CERT"};
			}
			
			var signOpt = { ds_pki_sign:[mGpkiJSCrypto.Define.PKI_CERT_SIGN_OPT_NONE], ds_pki_rsa:mGpkiJSCrypto.Define.PKI_RSA_1_5};

			// 세션찾기
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == true) {
				mSessionInfo.deleteSessionInfo(sSiteID);				
			}
			
			// 전자서명
			/*var oSignedData = mGpkiJSCrypto.JS_CMS_MakeSignedData(oCertBag.signcert, oCertBag.signpri, oCertBag.password, signOpt, sData);
			
			if (oSignedData.code != 0) {
				throw oSignedData;
			}*/
			gpkisecureweb.uiapi.MakeSignData( sData, null, function(code, message){
				if(code == 0){
					var signcert = message.certbag.signcert;
					// 본인확인
					//var nRandomNum = mGpkiJSCrypto.JS_PRIKEY_Object().message.getRandomNum();
					var nRandomNum = gpkijs.base64.decode(message.vidRandom);
					var oVidVerify = mGpkiJSCrypto.JS_VID_VERIFY(signcert, nRandomNum, sIDN);

					if (oVidVerify.code == false) {
						callback( {code: GPKIClientJS.ErrCode.AXERR_VERIFYVID_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_VERIFYVID_FAIL.message} );
						return;
					}
					
					var oSignedData = message.encMsg;
					
					// Make Content
					var oSignContentInfo = mGenInterface.MakeContentInfo(mGenInterface.Define.SIGNED_DATA, gpkijs.base64.decode(oSignedData));	
					
					if (oSignContentInfo.code != 0) {
						callback( {code:oSignContentInfo.code, message: oSignContentInfo} );
					}
					
					oResult = {code:0, message:oSignContentInfo.message};

					if (typeof(callback) == "function") {
						callback(oResult);
					}
					Object.assign(mResultObject, oResult);
					return oResult.code;
					
				}
			});
		} catch (ex) {
			oResult = ex;
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			Object.assign(mResultObject, oResult);
			return oResult.code;
		}
	}
	
	GPKISecureWebJS.prototype.EnvelopData = function(sSiteID, sData, callback) {
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(sData)"};
			}
			if (mSessionInfo == null || typeof(mSessionInfo) == "undefined" || typeof(mSessionInfo) != "object") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(mSessionInfo)"};
			}
			if (mServerCert == null || typeof(mServerCert) == "undefined"){
				throw {code: GPKIClientJS.ErrCode.AXERR_NOTSERVERCERT.code, message: GPKIClientJS.ErrCode.AXERR_NOTSERVERCERT.message};
			}
			
			var envelopOpt = { ds_pki_rsa: mGpkiJSCrypto.Define.PKI_RSA_1_5 };
			
			// 세션찾기			
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == true) {
				mSessionInfo.deleteSessionInfo(sSiteID);				
			}
			
			// 원본데이터의 해쉬값 생성
			var oDigest = mGpkiJSCrypto.JS_CRYPT_Hash(mGpkiJSCrypto.Define.HASH_ALG_SHA256, sData);
			
			if (oDigest.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.message};
			}
			
			// data + hash(sha256)
			var dataArray  = mGenInterface.StringToArrayBuffer(sData);
			var dataDigest = mGenInterface.StringToArrayBuffer(oDigest.message.data);
			var TBEData	   = mGenInterface.ArrayBufferToString(dataArray.concat(dataDigest));
			
			//전자봉투
			var oEnvelopData = mGpkiJSCrypto.JS_CMS_MakeEnvelopedData(mServerCert, mSymmetricAlgo, envelopOpt, TBEData);
			
			if (oEnvelopData.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.message};
			}

			// Make Content
			var oEnvelopMessage = oEnvelopData.message.toDer().data;
			var oEnvContentInfo = mGenInterface.MakeContentInfo(mGenInterface.Define.ENVELOP_DATA, oEnvelopMessage)
			
			if (oEnvContentInfo.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.message};
			}
			
			// KDF
			var oKDF = mGenInterface.MakeKeyIV(sSiteID, mSymmetricAlgo, mHashAlgo, oEnvelopMessage);
			
			if (oKDF.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_MAKEKDF_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_MAKEKDF_FAIL.message};
			}
			
			// Insert Sessioninfo
			mSessionInfo.insertSessionInfo(sSiteID, oKDF.message);
			
			oResult = {code:0, message:oEnvContentInfo.message};
			
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		Object.assign(mResultObject, oResult);
		
		return oResult.code;
	}
	
	GPKISecureWebJS.prototype.EnvelopedSignData = function(sSiteID, sData, oCertBag, callback) {
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			if (mGpkiJSCrypto == null || typeof(mGpkiJSCrypto) == "undefined" || typeof(mGpkiJSCrypto.JS_CMS_MakeSignedData) == "undefined") {
				throw {code:1001, message:"mGpkiJSCrypto API_NOT_INITIALIZED"};
			}
			if (mGenInterface == null || typeof(mGenInterface) == "undefined") {
				throw {code:1001, message:"mGenInterface API_NOT_INITIALIZED"};
			}
			if (mServerCert == null || typeof(mServerCert) == "undefined"){
				throw {code:1001, message:"ERR_NOT_EXIST_SERVER_CERT"};
			}
			
			var signOpt    = { ds_pki_sign:[mGpkiJSCrypto.Define.PKI_CERT_SIGN_OPT_NONE], ds_pki_rsa:mGpkiJSCrypto.Define.PKI_RSA_1_5};
			var envelopOpt = { ds_pki_rsa: mGpkiJSCrypto.Define.PKI_RSA_1_5 };
			
			// 세션찾기			
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == true) {
				mSessionInfo.deleteSessionInfo(sSiteID);				
			}
			
			//전자서명
			gpkisecureweb.uiapi.MakeSignData( sData, null, function(code, message){
				if(code == 0){
					var oSignedData = message.encMsg;
					
					var oPrikey = mGpkiJSCrypto.JS_PRIKEY_Object();
					var random  = mGpkiJSCrypto.JS_VID_GetRandomFromPriKey(oPrikey.message);
					
					var oSignContentInfo = mGenInterface.MakeSignContentInfo( gpkijs.base64.decode(oSignedData), gpkijs.base64.decode(message.vidRandom));	
					
					if (oSignContentInfo.code != 0) {
						callback( {code: oSignContentInfo.code, message: oSignContentInfo} );
					}
					
					//전자봉투
					var oEnvelopData = mGpkiJSCrypto.JS_CMS_MakeEnvelopedData(mServerCert, mSymmetricAlgo, envelopOpt, oSignContentInfo.message);
					
					if (oEnvelopData.code != 0) {
						callback( {code: oEnvelopData.code, message: oEnvelopData} );
					}
					
					// Make Content
					var oEnvelopMessage = oEnvelopData.message.toDer().data;
					var oEnvContentInfo = mGenInterface.MakeContentInfo(mGenInterface.Define.LOGIN_ENVELOP_SIGN_DATA, oEnvelopMessage);
					
					if (oEnvContentInfo.code != 0) {
						callback( {code: oEnvContentInfo.code, message: oEnvContentInfo} );
					}
					
					// KDF
					var oKDF = mGenInterface.MakeKeyIV(sSiteID, mSymmetricAlgo, mHashAlgo, oEnvelopMessage);
					
					if (oKDF.code != 0) {
						callback( {code: GPKIClientJS.ErrCode.AXERR_MAKEKDF_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_MAKEKDF_FAIL.message} );
					}
					
					// Insert Sessioninfo
					mSessionInfo.insertSessionInfo(sSiteID, oKDF.message);
					
					oResult = {code:0, message:oEnvContentInfo.message};
				
					if (typeof(callback) == "function") {
						callback(oResult);
					}
					
					Object.assign(mResultObject, oResult);
					return oResult.code;
					
				}
			});
		} catch (ex) {
			oResult = ex;
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			
			Object.assign(mResultObject, oResult);
			return oResult.code;
			
		}
	}
	
	GPKISecureWebJS.prototype.EncryptedSignData = function(sSiteID, sData, callback) {
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			if (mGpkiJSCrypto == null || typeof(mGpkiJSCrypto) == "undefined" || typeof(mGpkiJSCrypto.JS_CMS_MakeSignedData) == "undefined") {
				throw {code:1001, message:"mGpkiJSCrypto API_NOT_INITIALIZED"};
			}
			if (mGenInterface == null || typeof(mGenInterface) == "undefined") {
				throw {code:1001, message:"mGenInterface API_NOT_INITIALIZED"};
			}
			if (mServerCert == null || typeof(mServerCert) == "undefined"){
				throw {code:1001, message:"ERR_NOT_EXIST_SERVER_CERT"};
			}
			if (mSessionInfo == null || typeof(mSessionInfo) == "undefined" || typeof(mSessionInfo) != "object") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(mSessionInfo)"};
			}
			
			var signOpt = { ds_pki_sign:[mGpkiJSCrypto.Define.PKI_CERT_SIGN_OPT_NONE], ds_pki_rsa:mGpkiJSCrypto.Define.PKI_RSA_1_5};

			// 세션찾기
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == false) {				
				throw {code: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.code, message: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.message};
			}
			
			oSessionInfo = oSessionInfo.message;

			if (typeof(oSessionInfo.ClientKey) == "undefined" || typeof(oSessionInfo.ClientIv) == "undefined" || oSessionInfo.ClientKey.length == 0 || oSessionInfo.ClientIv.length == 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.code, message: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.message};
			}
			
			// 전자서명
			/*var oSignedData = mGpkiJSCrypto.JS_CMS_MakeSignedData(oCertBag.signcert, oCertBag.signpri, oCertBag.password, signOpt, sData);
			
			if (oSignedData.code != 0) {
				throw oSignedData;
			}*/
			
			gpkisecureweb.uiapi.MakeSignData( sData, null, function(code, message){
				if(code == 0){
					// Make Sign Content
					var oSignedData = message.encMsg;
					var oSignedDataMessage = gpkijs.base64.decode(oSignedData);
					
					var oSignContentInfo = mGenInterface.MakeSignContentInfo(oSignedDataMessage, gpkijs.base64.decode(message.vidRandom));
					
					if (oSignContentInfo.code != 0) {
						callback( {code: oSignContentInfo.code, message: oSignContentInfo} );
					}
					
					// 암호화			
					var ClientKey = mGenInterface.ArrayBufferToString(oSessionInfo.ClientKey);
					var ClientIv  = mGenInterface.ArrayBufferToString(oSessionInfo.ClientIv);
					var oEncrypt  = mGpkiJSCrypto.JS_CRYPT_Encrypt(mSymmetricAlgo, ClientKey, ClientIv, oSignContentInfo.message);
					
					if (oEncrypt.code != 0) {
						callback( {code: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.message} );
					}
					
					// Make Content
					var oEncContentInfo = mGenInterface.MakeContentInfo(mGenInterface.Define.ENCRYPTED_SIGNED_DATA, oEncrypt.message.data);
					
					if (oEncContentInfo.code != 0) {
						callback( {code: GPKIClientJS.ErrCode.AXERR_MAKEMSG_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_MAKEMSG_FAIL.message} );
					}
					
					oResult = {code:0, message:oEncContentInfo.message};
				
					if (typeof(callback) == "function") {
						callback(oResult);
					}
					Object.assign(mResultObject, oResult);
					
					return oResult.code;
					
				}
			});
		} catch (ex) {
			oResult = ex;
			
			if (typeof(callback) == "function") {
				callback(oResult);
			}
			Object.assign(mResultObject, oResult);
			return oResult.code;
			
		}
	}
	
	GPKISecureWebJS.prototype.Encrypt = function(sSiteID, sData, callback) {		
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(sData)"};
			}
			if (mSessionInfo == null || typeof(mSessionInfo) == "undefined" || typeof(mSessionInfo) != "object") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(mSessionInfo)"};
			}
			
			// 세션찾기
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == false) {				
				throw {code: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.code, message: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.message};
			}
			
			oSessionInfo = oSessionInfo.message;

			if (typeof(oSessionInfo.ClientKey) == "undefined" || typeof(oSessionInfo.ClientIv) == "undefined" || oSessionInfo.ClientKey.length == 0 || oSessionInfo.ClientIv.length == 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.code, message: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.message};
			}
			
			// 원본데이터의 해쉬값 생성 
			var oDigest = mGpkiJSCrypto.JS_CRYPT_Hash(mGpkiJSCrypto.Define.HASH_ALG_SHA256, sData);
			
			if (oDigest.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.message};
			}
			
			// data + hash(sha256)
			var dataArray  = mGenInterface.StringToArrayBuffer(sData);
			var dataDigest = mGenInterface.StringToArrayBuffer(oDigest.message.data);
			var TBEData	   = mGenInterface.ArrayBufferToString(dataArray.concat(dataDigest));

			// 암호화			
			var ClientKey = mGenInterface.ArrayBufferToString(oSessionInfo.ClientKey);
			var ClientIv  = mGenInterface.ArrayBufferToString(oSessionInfo.ClientIv);
			var oEncrypt  = mGpkiJSCrypto.JS_CRYPT_Encrypt(mSymmetricAlgo, ClientKey, ClientIv, TBEData);
			
			if (oEncrypt.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_ENCRYPT_FAIL.message};
			}
			
			// Make Content
			var oEncContentInfo = mGenInterface.MakeContentInfo(mGenInterface.Define.ENCRYPTED_DATA, oEncrypt.message.data)
			
			if (oEncContentInfo.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_MAKEMSG_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_MAKEMSG_FAIL.message};
			}
			
			oResult = {code:0, message:oEncContentInfo.message};
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		Object.assign(mResultObject, oResult);
		
		return oResult.code;
	}
	
	GPKISecureWebJS.prototype.Decrypt = function(sSiteID, sData, callback) {		
		var oResult    = 0;
		
		try {			
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(sSiteID)"};
			}
			if (sData == null || typeof(sData) == "undefined") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(sData)"};
			}
			if (mSessionInfo == null || typeof(mSessionInfo) == "undefined" || typeof(mSessionInfo) != "object") {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDINPUT.code, message:"The input is invalid type.(mSessionInfo)"};
			}
			
			// 세션찾기
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == false) {				
				throw {code: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.code, message: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.message};
			}
			
			oSessionInfo = oSessionInfo.message;
			
			if (typeof(oSessionInfo.ClientKey) == "undefined" || typeof(oSessionInfo.ClientIv) == "undefined" || oSessionInfo.ClientKey.length == 0 || oSessionInfo.ClientIv.length == 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.code, message: GPKIClientJS.ErrCode.AXERR_NOTEXISTSESSIONINFO.message};
			}
			
			// Parse Content 
			var oContentInfo = mGenInterface.ParseContentInfo(sData);
			
			if (oContentInfo.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_PARSEMSG_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_PARSEMSG_FAIL.message};
			}
			
			var ContentInfo = oContentInfo.message;
			
			if (ContentInfo.ContentType != mGenInterface.Define.ENCRYPTED_DATA) {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALID_DATA.code, message: GPKIClientJS.ErrCode.AXERR_INVALID_DATA.message};				
			}
			
			// 복호화
//			oSessionInfo.ServerKey = [0xfb,0x1d,0x1a,0x8c,0x8c,0x75,0x51,0x34,0xc6,0xa2,0x52,0xb2,0x54,0x8b,0x5f,0x16];
//			oSessionInfo.ServerIv  = [0xdf,0x22,0x1c,0x96,0xb9,0xb3,0x2d,0x4f,0x3c,0x96,0x20,0xd5,0x8c,0x62,0x6a,0x3f];			
			var ServerKey  = mGenInterface.ArrayBufferToString(oSessionInfo.ServerKey);
			var ServerIv   = mGenInterface.ArrayBufferToString(oSessionInfo.ServerIv);
			var CipherData = ContentInfo.ContentData;
			
			var oDecrypt   = mGpkiJSCrypto.JS_CRYPT_Decrypt(mSymmetricAlgo, ServerKey, ServerIv, CipherData);
			
			if (oDecrypt.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_DECRYPT_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_DECRYPT_FAIL.message};
			}
			
			// data + hash(sha256) 분리
			var ContentData = mGenInterface.StringToArrayBuffer(oDecrypt.message.data);
			var PlainText   = mGenInterface.ArrayBufferToString(ContentData.slice(0, ContentData.length-32));
			var HashData    = mGenInterface.ArrayBufferToString(ContentData.slice(ContentData.length-32, ContentData.length));
			
			var oDigest = mGpkiJSCrypto.JS_CRYPT_Hash(mGpkiJSCrypto.Define.HASH_ALG_SHA256, PlainText);
			
			if (oDigest.code != 0) {
				throw {code: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.message};
			}
			
			if (!(HashData === oDigest.message.data)) {
				throw {code: GPKIClientJS.ErrCode.AXERR_INVALIDHASH_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_INVALIDHASH_FAIL.message};
			}
			
			// 인코딩 처리
			if (mServerEncoding == this.Define.Encoding_UTF8) {
				var UTF8Text = mGpkiJSCrypto.JS_UTF8_Decode(PlainText);								
				
				if (UTF8Text.code != 0) {
					throw {code: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.code, message: GPKIClientJS.ErrCode.AXERR_HASH_FAIL.message};
				}
				
				PlainText = UTF8Text.message;
			}
			
			oResult = {code:0, message:PlainText};
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		Object.assign(mResultObject, oResult);
		
		return oResult.code;
	}
	
	GPKISecureWebJS.prototype.Logout = function(sSiteID, callback){
		var result;
		var oResult = 0;
		
		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sSiteID)"};
			}
			
			// 세션찾기
			var oSessionInfo = mSessionInfo.findSessionInfo(sSiteID);
			
			if (oSessionInfo.code == true) {
				result = mSessionInfo.deleteSessionInfo(sSiteID);
				if(result == true){
					oResult = {code:0, message:"success"};
				}
			}else{
				oResult = {code:0, message:oSessionInfo.message};
			}
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		Object.assign(mResultObject, oResult);
		
		return oResult.code;
			
	}

	GPKISecureWebJS.prototype.gpkiReload = function(){
		var div1 = document.getElementById("gpkiOnload");
		var div2 = document.getElementById("dscertContainer");
		
		div1.appendChild(div2);
	}
});