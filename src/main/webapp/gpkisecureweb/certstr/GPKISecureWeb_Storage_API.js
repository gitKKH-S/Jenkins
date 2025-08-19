var Storage_API_web = {
	selectCertString:'',
	selectCertIdx:'',
	crypto_api:null, 
	storageName:'GPKIPUBLIC',
		
	setCrypto_api : function(obj) {
		crypto_api = obj;
	},
	
	getSecureWebCert : function() {
		var GPKISecureWebCertObj = {};
		var certBaglist   = "[]";

		if (typeof(localStorage) != "undefined" ){
			var certlist = localStorage.getItem(Storage_API_web.storageName);
			
			if (certlist != null && typeof(certlist) != "undefined" && typeof(certlist) == "string") {
				certlist = crypto_api.getDecryptedCert(certlist);
				certlist = JSON.parse(certlist);
			}
			
			if (certlist != null && typeof(certlist) != "undefined" && typeof(certlist) == "object") {							
				if (typeof(certlist.ver) != "undefined" && certlist.ver == "v1") {
					certBaglist = certlist.certBaglist;
				}				
			} 
		}
		
		return certBaglist; 
	},
	
	setSecureWebCert : function(certlist) {
		var GPKISecureWebCertObj = {};
		var cipher_cert = [];
		
		GPKISecureWebCertObj.ver  		  = "v1";
		GPKISecureWebCertObj.time		  = new Date().getTime();
		GPKISecureWebCertObj.certBaglist = cipher_cert;		
		
		if (certlist != null && typeof(certlist) != "undefined" && typeof(certlist) == "string") {
			GPKISecureWebCertObj.certBaglist = certlist;
			cipher_cert = crypto_api.getEncryptedCert(JSON.stringify(GPKISecureWebCertObj));
		}
		
		if (typeof(localStorage) != "undefined" ){
			localStorage.setItem(Storage_API_web.storageName, cipher_cert);
		}
	},
	
	delGPKISecureWebCert : function() {
		if (typeof(localStorage) != "undefined" ){
			localStorage.removeItem(Storage_API_web.storageName);
		} 		
	},
	
	getSelectCert : function( storageRawCertIdx ){
		GPKISecureWebLog.log("Storage_API_web.getSelectCert() called...");		
		var cert =  { code : 0, signcert : "",  signpri : "", message: ""};
		try{
			if(Storage_API_web.selectCertString.length!=0 && Storage_API_web.selectCertString.storageCertIdx == storageRawCertIdx.storageCertIdx){
				cert.signcert = Storage_API_web.selectCertString.signcert
				cert.signpri = Storage_API_web.selectCertString.signpri
			}else{
				var certBaglist = Storage_API_web.getSecureWebCert();
				var isExit = false;
				if( certBaglist != null ){
					var certBaglistObj = JSON.parse(certBaglist);
					var selectCertBag ={};
					var certBaglistObjCnt = certBaglistObj.length;
					
					for(var i=0; i<certBaglistObjCnt; i++){
						if( certBaglistObj[i].storageCertIdx == storageRawCertIdx.storageCertIdx ){
							selectCertBag =  certBaglistObj[i];
							isExit = true;
						}
					}
					if(isExit){
						cert.signcert = selectCertBag.signcert;
						cert.signpri = selectCertBag.signpri;
					}else{
						if(typeof( storageRawCertIdx.browserSaveYn ) != 'undefined'){
							cert.signcert = storageRawCertIdx.signcert
							cert.signpri = storageRawCertIdx.signpri
						}else if( storageRawCertIdx.browserSaveYn === true ){
							
						}
					}
				}else{
					cert.signcert = storageRawCertIdx.signcert
					cert.signpri = storageRawCertIdx.signpri;
				}
			}
			return cert;
		}catch( e ){
			cert.code = e.code;
			cert.message = "certBaglist error message : "+ e.message;
			return cert;
		}
	},
	SelectStorageInfo : function(storageName, callback){
		GPKISecureWebLog.log("Storage_API_web.SelectStorageInfo() called..."); 

		var storageInfo = {};

		if(true){
			//ex. 정상 callback
			callback(0, storageInfo);
		}else{
			//ex. error callback
			callback( 201, {"errCode": 201, "errMsg": $.i18n.prop("ER201")});
		}
	},
	GetCertList : function(callback){
		
		GPKISecureWebLog.log("Storage_API_web.GetCertList() called...");		
		var cert_list = [];
		var storageOpt = new Object();
		var CertBagList = Storage_API_web.getSecureWebCert();
		var CertBagObjList = CertBagList!=null ? JSON.parse(CertBagList) : [];
		
		storageOpt.storageName = "web";
		
		if(CertBagList!=null && CertBagObjList.length>0){
			var certBagArray = JSON.parse(CertBagList);

			if(typeof(certBagArray)==null || certBagArray==null ){
				callback(202, {"errCode": 202, "errMsg": $.i18n.prop("ER202")});
			}else{
				var certBagArrCnt = certBagArray.length;
				
				for(var i=0; i<certBagArrCnt; i++){
					
					Storage_API_web.selectCertString = certBagArray[i];
					var signCert = certBagArray[i].signcert;

					// 인증서 식별 정보를 SerialNum으로 설정
					var certFields = [];
					var certbag = new Object();
					
					if (typeof(certBagArray[i].signcert) != "undefined") {
						certbag.signcert = certBagArray[i].signcert;
					}
					if (typeof(certBagArray[i].signpri) != "undefined") {
						certbag.signpri = certBagArray[i].signpri;
					}
					if (typeof(certBagArray[i].kmcert) != "undefined") {
						certbag.kmcert = certBagArray[i].kmcert;
					}
					if (typeof(certBagArray[i].kmpri) != "undefined") {
						certbag.kmpri = certBagArray[i].kmpri;
					}
					
					var oCertInfo = crypto_api.getcertInfo(signCert, certFields);
					
					if (oCertInfo.errCode == 0) {
						var storageRawIdxObj = {storageName:"web",storageOpt:{}};

						storageRawIdxObj.storageCertIdx = oCertInfo.result.subkeyid;
						Storage_API_web.selectCertIdx = oCertInfo.result.subkeyid;

						oCertInfo.result.storageRawCertIdx = storageRawIdxObj;
						oCertInfo.result.certbag = certbag;

						cert_list[i] = oCertInfo.result;

						if(certBagArrCnt == cert_list.length){
							if (typeof(callback) == "undefined"){
								return {"errCode":0, "cert_list": cert_list};
							} else {
								callback(0, {"cert_list": cert_list});
							}
						}
					} else {
						if (typeof(callback) == "undefined"){
							return {"errCode":0, "errMsg": oCertInfo.message};
						} else {
							callback( code, {"errCode": code, "errMsg": oCertInfo.message});
						}
					}
				}
			}
		}else{
			GPKISecureWebLog.log("Storage_API_web.GetCertList() GPKISecureWebCert null...");
			if (typeof(callback) == "undefined"){
				return {"errCode":0, "cert_list": []};
			} else {
				callback(0, {"cert_list": []});
			}
		}
	},
	SaveCert : function(certBag, passwd){
		GPKISecureWebLog.log("Storage_API_web.SaveCert() called...");		
		var storageRawCertIdx       = new Object();
		var verifyPassword 			= false; 
		
		storageRawCertIdx.storageCertIdx = "";
		storageRawCertIdx.storageName = "web";
		storageRawCertIdx.storageOpt = "{}";
		
		var fields					= ["startdatetime", "enddatetime", "issuername", "subjectname", "policyid", "subkeyid", "serialnum"];
		var signCert				= certBag.signcert;
		var pre_storageRawCertIdx	= storageRawCertIdx;
		var accesstime				= "";

		if (typeof(certBag.accesstime) != "undefined"){
			accesstime = certBag.accesstime;
		} else {
			accesstime = new Date().getTime();
		}
		
		var orgSignPri = crypto_api.prikeyDecrypt(certBag.signpri, passwd);
		
		if (passwd.length == 0) {
			verifyPassword = true;
		}
		
		if (orgSignPri.errCode == 0 || verifyPassword == true) {
			var oCertInfo = crypto_api.getcertInfo(signCert, fields);
			
			if (oCertInfo.errCode == 0) {
				var storageCertIdx = "";
				var base64decodeCert =  gpkijs.base64.decode(certBag.signcert);
				var certfingerprint	 = crypto_api.genHash("sha1", base64decodeCert);
				var message = oCertInfo.result;
				
				var kftcobj = new Object();
				
				kftcobj.fingerprint		= certfingerprint.resulthex;							
				kftcobj.timestamp		= accesstime;														
				kftcobj.status			= "SAVE";
				kftcobj.notBefore		= message.startdatetime;
				kftcobj.notAfter		= message.enddatetime;
				kftcobj.issuer			= encodeURIComponent(message.issuername);
				kftcobj.subject			= encodeURIComponent(message.subjectname);
				kftcobj.policyOID		= message.policyid;
				kftcobj.serial			= message.serialnum;
				kftcobj.source			= "LOCAL";
				
				certBag.storageCertIdx	= oCertInfo.result.subkeyid;
				certBag.kftc = kftcobj;
				
				pre_storageRawCertIdx.storageCertIdx = oCertInfo.result.subkeyid;
				
				var oDeleteCert = Storage_API_web.DeleteCert(pre_storageRawCertIdx);					
				
				if(oDeleteCert.errCode == 0){

					var newLocalCertList = [];
					
					var crtLocalCertList = Storage_API_web.getSecureWebCert();
					if(crtLocalCertList != null && crtLocalCertList != ""){
						newLocalCertList = JSON.parse(crtLocalCertList);
					}
					
					newLocalCertList.push(certBag);
					var newLocalCertListStr = JSON.stringify(newLocalCertList);
					
					Storage_API_web.setSecureWebCert(newLocalCertListStr);

					return 0;
				}else{									
					return oDeleteCert.errCode;
				}
				
			} else {
				return oCertInfo.errCode;
			}
		} else {
			return orgSignPri.errCode;
		}
	},
	
	GetCertString : function(storageRawCertIdx, callback){		
		GPKISecureWebLog.log("Storage_API_web.GetCertString() called...");
		var cert_string = "";	//Base64 value

		var certBaglist = Storage_API_web.getSecureWebCert();

		if(typeof(certBaglist)==null || certBaglist==null ){
			callback( GPKISecureWebLog.getErrCode("Storage_Web_GetCertString"), {"errCode": 201, "errMsg": $.i18n.prop("ER201")});
		}else{
			GPKISecureWebLog.log("Storage_API_web.GetCertString certbag Text ="+certBaglist);
			var certBaglistObj = JSON.parse(certBaglist);
			GPKISecureWebLog.log("Storage_API_web.GetCertString localStorageNum ="+certBaglistObj.length);
			GPKISecureWebLog.log("Storage_API_web.GetCertString parameter ="+storageRawCertIdx.storageCertIdx+" "+certBaglistObj.storageCertIdx);
			var selectCertBag ={};
			
			var certBaglistObjCnt = certBaglistObj.length;
			for(var i=0; i<certBaglistObjCnt; i++){
				GPKISecureWebLog.log("Storage_API_web.GetCertString="+certBaglistObj[i].storageCertIdx);
//				GPKISecureWebLog.log("Storage_API_web.GetCertString="+storageRawCertIdx.storageCertIdx);
				if(certBaglistObj[i].storageCertIdx==storageRawCertIdx.storageCertIdx){
					selectCertBag = certBaglistObj[i];
					break;
				}
			}

			var resultCode = false;
			if(typeof(selectCertBag.signcert)!=null){
//				delete selectCertBag[storageCertIdx];
				delete selectCertBag["storageCertIdx"];
				//cert_string = JSON.stringify(selectCertBag);
				resultCode = true;
			}

			if(resultCode){
				//callback(0, {"cert": cert_string});
				callback(0, {"cert": selectCertBag});
			}else{
				callback( GPKISecureWebLog.getErrCode("Storage_Web_GetCertString"), {"errCode": 201, "errMsg": $.i18n.prop("ER201")});
			}
		}
	},
	
	DeleteCert : function(storageRawCertIdx, callback){
		GPKISecureWebLog.log("Storage_API_web.DeleteCert() called...");
		
		// 로컬 스토리지에 제거하기
		try{
			var certBaglist		= Storage_API_web.getSecureWebCert();
			var certBaglistObj	= certBaglist!=null ? JSON.parse(certBaglist) : [];					
			var selectCertBag	= {};
			var certInfo		= false;			
			var cert_list		= [];
			var certBaglistObjCnt = certBaglistObj.length;
			
			for(var i=certBaglistObjCnt-1; i>=0; i--){				
				if( certBaglistObj[i].storageCertIdx==storageRawCertIdx.storageCertIdx ){
					certBaglistObj.splice(i, 1);
				}else{
					var cert_length = cert_list.length;
					cert_list[cert_length] = certBaglistObj[i];
				}
			}
			
			Storage_API_web.delGPKISecureWebCert();
			
			if(cert_list.length>0){
				Storage_API_web.setSecureWebCert(JSON.stringify(cert_list));
			}else{
				Storage_API_web.setSecureWebCert('[]');
			}
			
			
			if (typeof(callback) == "undefined"){
				return {"errCode":0, "result":true};
			} else {
				callback(0, {"result":true});
			}
		}catch(e){
			if (typeof(callback) == "undefined"){
				GPKISecureWebLog.log('- Storage_Web_DeleteCert Error = ' + e.message);
				return {"errCode":e.code, "errMsg": e.message};
			}else{
				callback(e.code, {"errCode": 888, "errMsg": e.message} );
			}		
		}
	},
	ChangePassword : function(storageRawCertIdx, passwdPre, passwdNext, callback){		
		GPKISecureWebLog.log("Storage_API_web.ChangePassword() called...");

		try{
			var certBaglist = Storage_API_web.getSecureWebCert();
			var certBaglistObj = JSON.parse(certBaglist);
			var selectCertBag ={};

			var certInfo = null;
			var certBaglistObjCnt = certBaglistObj.length;
			
			if(certBaglistObj!=null && certBaglistObjCnt >0){
				for(var i=0; i<certBaglistObjCnt; i++){
					if(certBaglistObj[i].storageCertIdx == storageRawCertIdx.storageCertIdx){
						//change pw
						var certbag = certBaglistObj[i];
					
							crypto_api.prikeyDecrypt(certbag.signpri, passwdPre, function(code, orgSignPri){
								if(code==0){
									crypto_api.prikeyEncrypt(orgSignPri.Base64String, passwdNext, null, function(code2,encSignPri){
										if(code2==0){
											if(GPKISecureWebApi.getProperty("libType") == 0){
												certbag.signpri = encSignPri;
											}else{
												certbag.signpri = encSignPri.Base64String;
											}
											
											// 변경된 Encrypt 데이터 저장
											if(certbag.kmpri){
												crypto_api.prikeyDecrypt(certbag.kmpri, passwdPre, function(code3, orgKmPri){
													if(code3==0){
														crypto_api.prikeyEncrypt(orgKmPri.Base64String, passwdNext, null, function(code4,encKmPri){
															if(code4==0){
																// 변경된 Encrypt 데이터 저장
																if(GPKISecureWebApi.getProperty("libType") == 0){
																	certbag.kmpri = encKmPri;
																}else{
																	certbag.kmpri = encKmPri.Base64String;
																}
																//var stringCertIdx = JSON.stringify(storageRawCertIdx);
																var func = Storage_API_web.SaveCert
																//func(certbag,passwdNext,stringCertIdx,function(code5, message){
																func(certbag, passwdNext, storageRawCertIdx, function(code5, message){
																	if(code5==0){
																		callback(0, {"result":true});
																	}else{
																		//fail to SaveCert
																		callback( code5, {"errCode": code5, "errMsg": message.errMsg});
																	}
																});
																
															}else{
																//fail to prikeyEncrypt for kmpri
																callback( code4, {"errCode": code4, "errMsg": $.i18n.prop("ER201")});
															}
														});
													}else{
														//fail to prikeyDecrypt for kmpri
														callback( code3, {"errCode": code3, "errMsg": $.i18n.prop("ER201")});
													}
												});
											}else{
												// 변경된 Encrypt 데이터 저장
												var stringCertIdx = JSON.stringify(storageRawCertIdx);
												//Storage_API_web.SaveCert(certbag,passwdNext,stringCertIdx,function(code6, message){
												Storage_API_web.SaveCert(certbag, passwdNext, storageRawCertIdx, function(code6, message){
													if(code6==0){
														callback(0, {"result":true});
													}else{
														callback( code6, {"errCode": code6, "errMsg": message.errMsg});
													}
												});
											}
										}else{
											//fail to prikeyEncrypt for signPri
											callback( code2, {"errCode": code2, "errMsg": $.i18n.prop("ER201")});
										}
									});
								}else{
									//fail to prikeyDecrypt for signPri
									callback( code, {"errCode": code, "errMsg": $.i18n.prop("ER201")});
								}
							});
					}else{
					}
				}

			}else{
				//no exist cert
				callback( 204, {"errCode": 204, "errMsg": $.i18n.prop("ER204")});
			}

		}catch(e){
			callback( 888, {"errCode": 888, "errMsg": e.message});
		}


	},
	verifyVID : function(storageRawCertIdx, passwd, Idn, callback){		
		GPKISecureWebLog.log("Storage_API_web.verifyVID() called...");

		//var cert_list = [];
		var isExit = false;

		var certBaglist = Storage_API_web.getSecureWebCert();
		var certBaglistObj = certBaglist!=null ? JSON.parse(certBaglist) : [];
		
		var selectCertBag ={};

		var certBaglistObjCnt = certBaglistObj.length;
		
		for(var i=0; i<certBaglistObjCnt; i++){
			if( certBaglistObj[i].storageCertIdx==storageRawCertIdx.storageCertIdx ){
				selectCertBag =  certBaglistObj[i];
				isExit = true;
			}
		}

		if(isExit){
			crypto_api.verifyVID(selectCertBag.signcert, selectCertBag.signpri, passwd, Idn, function(code, message){
				if(code==0){
					if(message.result == true){
						callback(0, message);
					}else{
						callback( code, {"errCode": code, "errMsg": $.i18n.prop("ES022")});
					}
				}else{
					callback( code, {"errCode": code, "errMsg": $.i18n.prop("ES022")});
				}
			});
		}else{
			//ex. error callback
			callback( 201, {"errCode": 201, "errMsg": $.i18n.prop("ER201")});
		}
	}
};