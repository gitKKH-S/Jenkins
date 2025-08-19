/*GPKIWeb_UI.js_23.10.27*/
(function(jQuery) {
	if (typeof jQuery === "undefined") alert("jQuery is not available!!!");

	if (typeof GPKISecureWebUI === "undefined") {
		var _GPKISecureWebUI = {
			api: {},
			initCallbackFunction: {},
			DSOption : {
				callback : function(){},
				option : {},
				message : "",
				certIdx : "",
				idn    : "",
				vidType : "",
				strVal : ""
			},
			mgmtDialogName : "",
			VestCertStorageOption : "HddMode",
			orignal : "서명메세지",
			funProcInit : function(){
				var params =  location.search.substring(1).split("&");
				var lgUrl = "";
				$.each(params, function(){
					var arr01 = this.split("=");
					if(arr01[0] == "lgUrl"){
						lgUrl = arr01[1];
					}
				});	
				return lgUrl;
			},
			defOption : {
				storage : "web",
				storageList : ["web","hdd","token","mobile","smartcert"] //[]
			},
			selectedStorage : {},
			Storage : {
				option : {},
				current_option : {},
				certificates: {
					certi_list : []
				},
				listeners : {},
				Add : function(obj) {
					this.certificates.certi_list.push(obj);
					this.dispatch("certi-add");	//Add event listener
				},
				AddList: function(list) {
					var listCnt = list.length;
					if(listCnt>0){
						for(var i=0 ; i<listCnt; i++){
							this.certificates.certi_list.push(list[i]);
						}
						this.dispatch("certi-add");	//Add event listener
					}
				},
				Empty : function(){
					this.certificates.certi_list = [];
				},
				Count : function(){
					return this.certificates.certi_list.length;
				},
				Get : function( idx ){
					if( idx > -1 && idx < this.certificates.certi_list.length ){
						return this.certificates.certi_list[ idx ];
					}
				},
				GetEncCertList: function( idx ){
					var certiListCnt = this.certificates.certi_list.length;
					if( this.certificates.certi_list!=null && certiListCnt>0){
						for(var i=0 ; i<certiListCnt; i++){
							var idx = this.certificates.certi_list[i].storagecertIdx;
							var rawCertIdx = {
								storageName:this.key,
								storageOpt: this.option,
								storagecertIdx : idx
							};
							this.certificates.certi_list[i].storageRawCertIdx = JSON.stringify(rawCertIdx);
						}
					}
				},
				Insert : function( obj, idx ){
					var pointer = -1;
					if( idx === 0 ){
						this.certificates.certi_list.unshift( obj );
						pointer = idx;
					}else if( idx === this.certificates.certi_list.length ){
						this.certificates.certi_list.push( obj );
						pointer = idx;
					}

					return pointer;
				},
				IndexOf : function( obj, startIndex ){
					var i = startIndex, pointer = -1;

					while( i < this.certificates.certi_list.length ){
						if( this.certificates.certi_list[i] === obj ){
							pointer = i;
						}
						i++;
					}

					return pointer;
				},
				RemoveAt: function(idx) {
					if( idx === 0 ){
						this.certificates.certi_list.shift();
					}else if( idx === this.certificates.certi_list.length -1 ){
						this.certificates.certi_list.pop();
					}
				},
				on: function(eventName, listener) {
					if(this.listeners == undefined) this.listeners = new Object();
					if(!this.listeners[eventName]) this.listeners[eventName] = [];
					this.listeners[eventName].push(listener);
				},
				dispatch: function(eventName) {
					var eventNmCnt = this.listeners[eventName].length;
					if(this.listeners[eventName]) {
						for(var i=0; i<eventNmCnt; i++) {
							this.listeners[eventName][i](this);
						}
					}
				},
				makeStorage : function(o){
					GPKISecureWebLog.log( "GPKISecureWebApi.makeStorage() called... ");
					var i = 0;
					for(var i in Storage){
						if(Storage.hasOwnProperty(i) && typeof Storage[i] === "function"){
							o[i] = Storage[i];
						}
					}
					o.certificates = { certi_list: [] };
				}
			},
			blockUI : function (){
				$.blockUI({
					message:'<div><div><img src="' + GPKISecureWebApi.getProperty("dirpath") + 'UI/images/loader.gif" alt="로딩중입니다."/></div><p style="display:inline-block; padding-top:4px; font-size:11px; color:#333; font-weight:bold;">'+$.i18n.prop("ES044")+'</p></div>',
					baseZ: 100005,
					css:{left:(($(window).width()/2)-75)+'px'}
					
				});
			},
			unblockUI : function(){
				$.unblockUI();
			},
			callback : "",
			showCertMana : function(viewoptObj, callback){
				GPKISecureWebDraw.MakeStorageListDiv("mgmt");
			},
			showCertDiv : function(viewoptObj, callback, isEmbedded){
				GPKISecureWebLog.log("GPKISecureWebUI.showCertDiv() called...");
				/*
				viewoptObj.defaultStorage;
				viewoptObj.storageList; //[]
				viewoptObj.installcheck;
				viewoptObj.updatecheck;
				viewoptObj.browserInfo;
				*/
				var defaultStg = viewoptObj.defaultStorage;
				var browserInfo = viewoptObj.browserInfo;
				browserVersion = browserInfo.version;
				
				if(viewoptObj.defaultStorage == "" || viewoptObj.defaultStorage == null){
					GPKISecureWebLog.log("[value check] default storage value is null!! - set default option");
					viewoptObj.defaultStorage = this.defOption.storage;
					
					var checkarr = Array.isArray(viewoptObj.storageList);
					if(!checkarr){
						GPKISecureWebLog.log("[value check] storage list is not array!! - set default option");
						viewoptObj.storageList = this.defOption.storageList;
					}
				}
				
				if((browserInfo.name.indexOf("IE") > -1 && browserVersion < 11) ||
					(browserInfo.name.indexOf("Edge") > -1 && browserVersion < 12))
				{
					if(viewoptObj.defaultStorage == "web_kftc" || viewoptObj.defaultStorage == "kftc"){
						GPKISecureWebApi.setProperty("defaultStorage", this.defOption.storage);
						viewoptObj.defaultStorage = this.defOption.storage;
					}
					if(viewoptObj.storageList.indexOf("web_kftc") > -1 || viewoptObj.storageList.indexOf("kftc") > -1)
					{
						var idx = viewoptObj.storageList.indexOf("web_kftc");
						if(idx > -1){
							viewoptObj.storageList.splice(idx, 1, "web");
						}
					}
				}
				
				GPKISecureWebApi.setProperty("cert_filter_expire", viewoptObj.certExpirefilter);
				GPKISecureWebApi.setProperty("cert_filter_oid", viewoptObj.certOidfilter);
				
				Storage_API_filter.init(function(code, result){
					GPKISecureWebDraw.MakeStorageListDiv(viewoptObj);
					GPKISecureWebUI.unblockUI();
				   	$("#ML_window").MLjquiWindow({modalOpacity: 0.3});
					$("#ML_window").MLjquiWindow('open', function(e){
						GPKISecureWebDraw.initWebMainEvent(isEmbedded);
						
						if(viewoptObj.defaultStorage != null){
							$("#stg_" + viewoptObj.defaultStorage).click();
						}
						GPKISecureWebUI.callback = callback;
						
					});
				})
			},
			/**
			 * 인증서 저장 기능을 수행할 UI를 호출
			 */
			showSaveCertDiv : function(viewoptObj, certbag, certInfo, callback){
				GPKISecureWebLog.log("GPKISecureWebUI.showSaveCertDiv() called...");
				
				var defaultStg = viewoptObj.defaultStorage;
				var browserInfo = viewoptObj.browserInfo;
				browserVersion = browserInfo.version;
				
				if(viewoptObj.defaultStorage == "" || viewoptObj.defaultStorage == null){
					GPKISecureWebLog.log("[value check] default storage value is null!! - set default option");
					viewoptObj.defaultStorage = this.defOption.storage;
					
					var checkarr = Array.isArray(viewoptObj.storageList);
					if(!checkarr){
						GPKISecureWebLog.log("[value check] storage list is not array!! - set default option");
						viewoptObj.storageList = this.defOption.storageList;
					}
				}
			
				if((browserInfo.name.indexOf("IE") > -1 && browserVersion < 11) ||
					(browserInfo.name.indexOf("Edge") > -1 && browserVersion < 12))
				{
					if(viewoptObj.defaultStorage == "web_kftc" || viewoptObj.defaultStorage == "kftc"){
						viewoptObj.defaultStorage = this.defOption.storage;
					}
					if(viewoptObj.storageList.indexOf("web_kftc") > -1 || viewoptObj.storageList.indexOf("kftc") > -1)
					{
						var idx = viewoptObj.storageList.indexOf("web_kftc");
						if(idx > -1){
							viewoptObj.storageList.splice(idx, 1, "web");
						}
					}
				}
				
				GPKISecureWebApi.setProperty("cert_filter_expire", viewoptObj.certExpirefilter);
				GPKISecureWebApi.setProperty("cert_filter_oid", viewoptObj.certOidfilter);
				
				Storage_API_filter.init(function(code, result){
					GPKISecureWebDraw.MakeStorageListDiv(viewoptObj);
					GPKISecureWebUI.unblockUI();
					$("#ML_window").MLjquiWindow({modalOpacity: 0.3});
					$("#ML_window").MLjquiWindow('open', function(e){
						GPKISecureWebSaveCertDraw.MakeSaveCertDiv(certInfo);
						
						if(viewoptObj.defaultStorage != null){
							$("#stg_" + viewoptObj.defaultStorage).click();
						}
						GPKISecureWebUI.callback = callback;
						
					});
				})
			},
			selectStorageInfo : function(key, callback){
				if(key != 'smartcertnx'){
					GPKISecureWebUI.blockUI();
				}
				GPKISecureWebLog.log("GPKISecureWebUI.selectStorageInfo() called...");
				setTimeout(function(){
					if(key == null || key == ""){
						callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_selectStorageInfo"), {"errCode": 100, "errMsg": $.i18n.prop('ER100')});
						return;
					}else if( typeof callback != 'function' || callback == null || callback == ""){
						callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_selectStorageInfo"), {"errCode": 103, "errMsg": $.i18n.prop('ER103')});
						return;
					}

					GPKISecureWebUI.selectedStorage = {};

					switch(key){
						case 'web_kftc':
							GPKISecureWebUI.selectedStorage = {
								key:"web_kftc",
								name : $.i18n.prop('TS701'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'kftc':
							GPKISecureWebUI.selectedStorage = {
								key:"kftc",
								name : $.i18n.prop('TS701'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'web':
							GPKISecureWebUI.selectedStorage = {
								key:"web",
								name : $.i18n.prop('TS701'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};

							break;
						case 'pfx':
							GPKISecureWebUI.selectedStorage = {
								key:"pfx",
								name : $.i18n.prop('TS702'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'hdd':
							GPKISecureWebUI.selectedStorage = {
								key:"hdd",
								name : $.i18n.prop('TS703'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							//
							break;
						case 'shdd':
							GPKISecureWebUI.selectedStorage = {
								key:"shdd",
								name : $.i18n.prop('TS704'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'token':
							GPKISecureWebUI.selectedStorage = {
								key:"token",
								name : $.i18n.prop('TS705'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'mobile':
							GPKISecureWebUI.selectedStorage = {
								key:"mobile",
								name : $.i18n.prop('TS706'),
								isPwdRequired : function() {
									return true;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'smartcert':
							GPKISecureWebUI.selectedStorage = {
								key:"smartcert",
								name : $.i18n.prop('TS707'),
								isPwdRequired : function() {
									return false;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'smartcertnx':
							GPKISecureWebUI.selectedStorage = {
								key:"smartcertnx",
								name : $.i18n.prop('TS707'),
								isPwdRequired : function() {
									return false;
								},
								AddCertificates : function( certi ){
									GPKISecureWebUI.Storage.Add( certi );
								},
								RemoveCertificates : function( certi ){
									GPKISecureWebUI.Storage.RemoveAt( this.IndexOf( certi, 0 ) );
								}
							};
							break;
						case 'cloud':
							break;
						default:
							GPKISecureWebLog.log("[Error] Not Support Storage.");
							break;
					}

					// 공인인증서 가져오기에서 '브라우저에 인증서 저장' 체크하고 비밀번호 틀린 후, 전자서명 시 비밀번호 틀림 알림 뜨지 않거나 전자서명 되지 않는 오류 수정 
					if(key != 'hdd'){
						var certOpt = {"storageName":key};
						
						GPKISecureWebUI.selectedStorage.current_option = certOpt;
						certOpt.DS_PKI_CERT_PATH = encodeURIComponent(JSON.stringify(GPKISecureWebApi.DS_PKI_CERT_PATH));
						certOpt.DS_PKI_POLICY_OID = encodeURIComponent(JSON.stringify(GPKISecureWebApi.DS_PKI_POLICY_OID));
					}
					
					//create default selectedStorage
					GPKISecureWebUI.Storage.makeStorage( GPKISecureWebUI.selectedStorage );

					//create event listener(like callback) name of "certi-add"
					GPKISecureWebUI.Storage.on("certi-add", function() {
						//
					});

					GPKISecureWebApi.gpkisecureweb_storage_api.SelectStorageInfo(key, function(resultCode, jsonObj){
						GPKISecureWebLog.log("%%%%% select storageinfo : " + key + ", " + JSON.stringify(jsonObj));
						if(resultCode == 0){
							if(jsonObj != null){
								GPKISecureWebUI.selectedStorage.option = jsonObj;
								callback(0, jsonObj);
								var temp = $('#temp').val();
								if(GPKISecureWebUI.selectedStorage.key != "hdd" || (temp != '' && temp != 0 )){
									GPKISecureWebUI.unblockUI();
								}
							}else{
								//no list
								callback(0, null);
								GPKISecureWebUI.unblockUI();
							}
						}else{
							callback(GPKISecureWebLog.getErrCode("SecureWeb_UI_selectStorageInfo"), {"errCode": jsonObj.errCode, "errMsg": jsonObj.errMsg});
							GPKISecureWebUI.unblockUI();
							return;
						}
					});
				},200);
			},
			
			getStorageCertList : function( certOpt, callback ){
				GPKISecureWebLog.log("GPKISecureWebUI.getStorageCertList() called..."); 

				if( certOpt == null || $.isEmptyObject(certOpt)){
					certOpt = GPKISecureWebUI.selectedStorage.current_option;
				}else if( typeof callback != 'function' || callback == null || callback == "" ){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_getStorageCertList"), {"errCode": 103, "errMsg": $.i18n.prop('ER103')});
					return;
				}

				try{
					GPKISecureWebUI.selectedStorage.current_option = certOpt;
					certOpt.DS_PKI_CERT_PATH = encodeURIComponent(JSON.stringify(GPKISecureWebApi.DS_PKI_CERT_PATH));
					certOpt.DS_PKI_POLICY_OID = encodeURIComponent(JSON.stringify(GPKISecureWebApi.DS_PKI_POLICY_OID));

					GPKISecureWebApi.gpkisecureweb_storage_api.GetCertList(certOpt, function(resultCode, jsonObj){
						GPKISecureWebLog.log("gpkisecureweb_storage_api.GetCertList resultCode :: " + resultCode);
						if(resultCode == 0){
							var cert_list = jsonObj.cert_list;
							if(cert_list!=null && cert_list.length>0){
								var tempArr = [];
								var certListCnt = cert_list.length;
								for(var i=0 ; i<certListCnt; i++){
									var tempCertObj = cert_list[i];
									var rawCertIdxObj = tempCertObj.storageRawCertIdx;
									
									if(typeof(rawCertIdxObj.storageOpt) == "string"){
										var obj = JSON.parse(rawCertIdxObj.storageOpt);
										rawCertIdxObj.storageOpt = obj;
									}
									
									var rawCertIdxStr = JSON.stringify(rawCertIdxObj);
									var encCertIdx = "";
									if(GPKISecureWebApi.webConfig.libType == 0 || GPKISecureWebApi.getProperty('selectedStorage').key=='smartcert'){
										encCertIdx = rawCertIdxStr;
									}else{
										if(GPKISecureWebUI.selectedStorage.current_option.storageName == "web"
											|| GPKISecureWebUI.selectedStorage.current_option.storageName == "kftc"
											|| GPKISecureWebUI.selectedStorage.current_option.storageName == "web_kftc"
											|| GPKISecureWebUI.selectedStorage.current_option.storageName == "pfx"){
											encCertIdx = GPKISecureWebApi.dsencrypt(rawCertIdxStr);
										}else{
											encCertIdx = rawCertIdxStr;
										}
									}
									
									if(rawCertIdxObj.storageName == "pfx"){ // pfx 파일 하위 브라우저(IE 8, 9) 브라우저 인증서 저장
										if(rawCertIdxObj.storageOpt.pfxOpt.libType == "c" && rawCertIdxObj.storageOpt.pfxOpt.SaveCert == "true"){
											HandleApi.getCertString(encCertIdx, function(code, obj){
												if(code == 0) {
													var certbag = [];
													
													obj.cert.storageCertIdx = tempCertObj.subkeyid;
													certbag.push(obj.cert);
													
													var targetStorage = "web";
													var targetStorageOpt = '{}';

													GPKISecureWebUI.saveCertToStorage(obj.cert, "aaa", targetStorage, targetStorageOpt, function(code2, obj2){
														if(code2 != 0){
															GPKISecureWebLog.log("save cert failed in webStorage ");
														}
													});
												}else{
													callback(GPKISecureWebLog.getErrCode("SecureWeb_UI_getStorageCertList"), {"errCode": 888, "errMsg": e.message});
												}
											});
										}
									}
									
									delete tempCertObj["storageRawCertIdx"];
									tempCertObj["storageEncCertIdx"] = encCertIdx;
									
									tempArr[i] = tempCertObj;
									
									GPKISecureWebUI.selectedStorage.AddCertificates(tempCertObj);
								}

								jsonObj.cert_list = tempArr;
								callback(resultCode, jsonObj);
							}else{
								//목록없음.
								callback(GPKISecureWebLog.getErrCode("SecureWeb_UI_getStorageCertList"), {"errCode": 202, "errMsg": $.i18n.prop("ER202")});
								return;
							}
						}else{
							callback(resultCode, {"errCode": jsonObj.errCode, "errMsg": jsonObj.errMsg});
							return;
						}
					});
				}catch( e ){
					callback(GPKISecureWebLog.getErrCode("SecureWeb_UI_getStorageCertList"), {"errCode": 888, "errMsg": e.message});
					return;
				}
			},
			
			getCertString : function(certInfo, callback){
				GPKISecureWebLog.log("GPKISecureWebUI.getCertString() called... ");
				if(certInfo == null || certInfo == "" ){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_getCertString"), {"errCode": 100, "errMsg": $.i18n.prop("ER100")});
					return;
				}else if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_getCertString"), {"errCode": 103, "errMsg": $.i18n.prop("ER103")});
					return;
				}

				var storageRawCertIdx = "";
				if(GPKISecureWebApi.webConfig.libType == 0 || GPKISecureWebApi.getProperty('selectedStorage').key=='smartcert'){
					storageRawCertIdx = JSON.parse(certInfo);
				}else{
					if(GPKISecureWebUI.selectedStorage.current_option.storageName == "web"
						|| GPKISecureWebUI.selectedStorage.current_option.storageName == "web_kftc"
						|| GPKISecureWebUI.selectedStorage.current_option.storageName == "kftc"
						||	GPKISecureWebUI.selectedStorage.current_option.storageName == "pfx")
					{
						storageRawCertIdx = JSON.parse(GPKISecureWebApi.dsDecrypt(certInfo));
					}else{
						storageRawCertIdx = JSON.parse(certInfo);
					}
				}

				try{
					GPKISecureWebApi.gpkisecureweb_storage_api.GetCertString(storageRawCertIdx, function(resultCode, resultObj){
						if( resultCode == 0) {
							callback(0, resultObj);
						}else{
							callback(resultCode, resultObj);
						}
					});
				}catch( e ){
					callback(GPKISecureWebLog.getErrCode("SecureWeb_UI_getCertString"), {"errCode": 888, "errMsg": e.message});
				}

			},
			
			saveCertToStorage : function(certbag, passwd, targetStorage, targetStorageOpt, callback){
				GPKISecureWebLog.log("GPKISecureWebUI.saveCertToStorage() called... ");
				//GPKISecureWebLog.log("GPKISecureWebApi.saveCertToStorage().certbag === "+JSON.stringify(certbag));
				//GPKISecureWebLog.log("GPKISecureWebApi.saveCertToStorage().passwd === "+passwd);
				//GPKISecureWebLog.log("GPKISecureWebApi.saveCertToStorage().targetStorage === "+targetStorage);
				//GPKISecureWebLog.log("GPKISecureWebApi.saveCertToStorage().targetStorageOpt === "+JSON.stringify(targetStorageOpt));

				if(certbag == null || $.isEmptyObject(certbag)){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_saveCertToStorage"), {"errCode": 100, "errMsg": $.i18n.prop("ER100")});
					return;
				}else if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_saveCertToStorage"), {"errCode": 103, "errMsg": $.i18n.prop("ER103")});
					return;
				}

				var targetStorageRawIdx = {}
				targetStorageRawIdx.storageName = targetStorage;
				targetStorageRawIdx.storageOpt =  targetStorageOpt;
				targetStorageRawIdx.storageCertIdx = "";
				targetStorageRawIdx.type = "saveGPKI";

				GPKISecureWebApi.gpkisecureweb_storage_api.SaveCert (certbag, passwd, targetStorageRawIdx, callback);
			},
			
			deleteStorageCert : function( certInfo, passwd, callback ) {
				GPKISecureWebLog.log("GPKISecureWebUI.deleteStorageCert() called...");

				if( certInfo == null || certInfo==""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_DeleteStorageCert"), {"errCode": 100, "errMsg": $.i18n.prop("ER100")});
					return;
				} else if ( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_DeleteStorageCert"), {"errCode": 103, "errMsg": $.i18n.prop("ER103")});
					return;
				}

				//- certInfo = storageEncCertIdx
				var storageRawCertIdx;
				if(GPKISecureWebApi.webConfig.libType == 0 || GPKISecureWebApi.getProperty('selectedStorage').key=='smartcert'){
					storageRawCertIdx = JSON.parse(certInfo);
				}else{
					if(GPKISecureWebUI.selectedStorage.current_option.storageName == "web" || GPKISecureWebUI.selectedStorage.current_option.storageName == "pfx" || GPKISecureWebUI.selectedStorage.current_option.storageName == "web_kftc"){
						storageRawCertIdx = JSON.parse(GPKISecureWebApi.dsDecrypt(certInfo));
					}else{
						storageRawCertIdx = JSON.parse(certInfo);
					}
				}
				var stgKey = GPKISecureWebUI.selectedStorage.current_option.storageName;
				
				if(stgKey === "web_kftc"){
					storageRawCertIdx.storageName = "web_kftc";
				}
				
				if(stgKey == "token"){ // 토큰일 경우 pin 필요
					GPKISecureWebApi.gpkisecureweb_storage_api.DeleteCert_Token( storageRawCertIdx, passwd, callback );
				}else{
					GPKISecureWebApi.gpkisecureweb_storage_api.DeleteCert( storageRawCertIdx, callback );
				}
			},
			
			changeStorageCertPasswd : function( certInfo, passwdPre, passwdNext, callback ) {
				GPKISecureWebLog.log("GPKISecureWebUI.changeStorageCertPasswd() called... ");

				if( certInfo == null || certInfo==""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_ChageStorageCertPasswd"), {"errCode": 100, "errMsg": $.i18n.prop("ER100")});
					return;
				}else if( passwdPre == null || passwdPre==""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_ChageStorageCertPasswd"), {"errCode": 100, "errMsg": $.i18n.prop("ER100")});
					return;
				}else if( passwdNext == null || passwdNext==""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_ChageStorageCertPasswd"), {"errCode": 100, "errMsg": $.i18n.prop("ER100")});
					return;
				}else if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_ChageStorageCertPasswd"), {"errCode": 103, "errMsg": $.i18n.prop("ER103")});
					return;
				}

				//GPKISecureWebLog.log("GPKISecureWebApi.changeStorageCertPasswd()  certInfo === " + certInfo);
				//GPKISecureWebLog.log("GPKISecureWebApi.changeStorageCertPasswd()  passwdPre === " + passwdPre);
				//GPKISecureWebLog.log("GPKISecureWebApi.changeStorageCertPasswd()  passwdNext === " + passwdNext);

				var storageRawCertIdx;
				if(GPKISecureWebApi.webConfig.libType == 0 || GPKISecureWebApi.getProperty('selectedStorage').key=='smartcert'){
					storageRawCertIdx = JSON.parse(certInfo);
				}else{
					if(GPKISecureWebUI.selectedStorage.current_option.storageName == "web" || GPKISecureWebUI.selectedStorage.current_option.storageName == "pfx"){
						storageRawCertIdx = JSON.parse(GPKISecureWebApi.dsDecrypt(certInfo));
					}else{
						storageRawCertIdx = JSON.parse(certInfo);
					}
				}
				
				GPKISecureWebApi.gpkisecureweb_storage_api.ChangePassword(storageRawCertIdx, passwdPre, passwdNext, callback);
			},
			init : function(callback, isEmbedded){
				if(isEmbedded){
					$("#selectCertContainer").load("UI/GPKIWeb_Main_Embedded.jsp?random=" + Math.random() * 99999, function(){
						callback(200);
					});
				}else{
					$("#selectCertContainer").load("UI/GPKIWeb_Main.jsp?random=" + Math.random() * 99999, function(){
						callback(200);
					});
				}
			},
			// 인증서 저장 init : 다른 jsp 를 로드
			saveCertInit : function(callback){
				$("#selectCertContainer").load("UI/GPKIWeb_SaveCertMain.jsp?random=" + Math.random() * 99999, function(){
					callback(200);
				});
			},
			MakeExtentionData : function(msg, option, callback){// 창 열기-확장기능

			},
			MgmtDialog : function(callback){// 창 열기-인증서관리기능 전체
				if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_MgmtDialog"), {"errCode": 103, "errMsg": "callback 값이 null이거나  함수가 아닙니다."});
					return;
				}

				this.mgmtDialogName = "mgmtAll";

				try{
					if ( $("#ML_window_admin").length > 0 ) {
						$('#ML_window_admin').MLjquiWindow('title', '인증서관리');
						$('#ML_window_admin').MLjquiWindow('open', function(e){
							//$('#certaction').val('Mgmt');
						});
					}else{
						$("#selectCertContainer").load("UI/GPKIWeb_Mgmt.html", function(){
							$('#ML_window_admin').MLjquiWindow('open', function(e){
								//$('#certaction').val('Mgmt');
							});
						});
					}
				}catch(ex){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_MgmtDialog"), {"errCode": 888, "errMsg": ex.message});
				}
			},
			getCertManager : function(dialogName, callback){
				if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_getCertManager"), {"errCode": 103, "errMsg": $.i18n.prop("ER103")});
					return;
				}

				this.mgmtDialogName = dialogName;

				try{
					switch(dialogName){
						case 'all':
							this.MgmtDialog(callback);
							break;
						case 'delete':
							this.DeleteDialog(callback);
							break;
						case 'import':
							this.ImportDialog(callback);
							break;
						case 'export':

							break;
						case 'changePw':
							this.PWChangeDialog(callback);
							break;
						default:
							callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_getCertManager"), {"errCode": 104, "errMsg": $.i18n.prop("ER104")});
							break;
					}
				}catch(ex){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_getCertManager"), {"errCode": 888, "errMsg": ex.message});
				}
			},
			PWChangeDialog : function(callback){// 창 열기-인증서 비밀번호 변경
				if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_MgmtDialog"), {"errCode": 103, "errMsg": "callback 값이 null이거나  함수가 아닙니다."});
					return;
				}

				try{
					$("#selectCertContainer").empty();

					if ( $("#ML_window_admin").length > 0 ) {
						$('#ML_window_admin').MLjquiWindow('title', '인증서관리');
						$('#ML_window_admin').MLjquiWindow('open', function(e){
							//$('#certaction').val('Mgmt');
						});
					}else{
						$("#selectCertContainer").load("UI/GPKIWeb_Mgmt.html", function(){
							$('#ML_window_admin').MLjquiWindow('open', function(e){
								//$('#certaction').val('Mgmt');
							});
						});
					}
				}catch(ex){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_MgmtDialog"), {"errCode": 888, "errMsg": ex.message});
				}
			},
			DeleteDialog : function(callback){// 창 열기-인증서삭제
				if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_DeleteDialog"), {"errCode": 103, "errMsg": "callback 값이 null이거나  함수가 아닙니다."});
					return;
				}

				try{
					$("#selectCertContainer").empty();

					if ( $("#ML_window_admin").length > 0 ) {
						$('#ML_window_admin').MLjquiWindow('title', '인증서관리');
						$('#ML_window_admin').MLjquiWindow('open', function(e){
							//$('#certaction').val('Mgmt');
						});
					}else{
						$("#selectCertContainer").load("UI/GPKIWeb_Mgmt.html", function(){
							$('#ML_window_admin').MLjquiWindow('open', function(e){
								//$('#certaction').val('Mgmt');
							});
						});
					}
				}catch(ex){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_DeleteDialog"), {"errCode": 888, "errMsg": ex.message});
				}
			},
			ImportDialog : function(callback){// 창 열기-인증서가져오기
				if( typeof callback != 'function' || callback == null || callback == ""){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_ImportDialog"), {"errCode": 103, "errMsg": "callback 값이 null이거나  함수가 아닙니다."});
					return;
				}

				try{
					$("#selectCertContainer").empty();

					if ( $("#ML_window_admin").length > 0 ) {
						$('#ML_window_admin').MLjquiWindow('title', '인증서관리');
						$('#ML_window_admin').MLjquiWindow('open', function(e){
							//$('#certaction').val('Mgmt');
						});
					}else{
						$("#selectCertContainer").load("UI/GPKIWeb_Mgmt.html", function(){
							$('#ML_window_admin').MLjquiWindow('open', function(e){
								//$('#certaction').val('Mgmt');
							});
						});
					}
					
				}catch(ex){
					callback( GPKISecureWebLog.getErrCode("SecureWeb_UI_ImportDialog"), {"errCode": 888, "errMsg": ex.message});
				}
			},
			ExportDialog : function(callback){// 창 열기-인증서내보내기

			},
			closeMainDialog : function (mode){
				GPKISecureWebLog.log("GPKISecureWebUI.closeMainDialog() called... mode ===");
				if(mode == "main") {
					
				}else if(mode == "mgmt"){

				}else if(mode == "cs"){

				}

				childInit.closeMainDialogToChild();
				
			},
			getSelectCert : function(callback){//인증서 정보 조회
				//
			},
			setDSOption: function(key, value){
				this.DSOption[key] = value;
			},
			getDSOption: function(){
				return this.DSOption;
			},
			getDialogName: function(){
				return this.mgmtDialogName;
			}
		};

		if(!window.GPKISecureWebUI) window.GPKISecureWebUI = _GPKISecureWebUI;

		function popMainDialog(){
			GPKISecureWebLog.log("GPKISecureWebUI.popMainDialog called...");
		}

		function popMgmtDialog(key, callback){
			GPKISecureWebLog.log("GPKISecureWebUI.popMgmtDialog called...");
		}
	}

	if (typeof GPKISecureWebUtil === "undefined") {
		var _GPKISecureWebUtil = {
			getBackupCertList : function(){
				GPKISecureWebLog.log("GPKISecureWebUtil.getBackupCertList called...");
				if(GPKISecureWebApi.getProperty('isUseMLCert')){
					getBackupCertListFromMlcert();
				}
			},
			setBackupCertList : function(backupCertList){
				GPKISecureWebLog.log("GPKISecureWebUtil.setBackupCertList called...");
				if(GPKISecureWebApi.getProperty('isUseMLCert')){
					if(backupCertList!=null){
						setBackupCertListToMlcert(backupCertList);
					}else{
						setBackupCertListToMlcert(localStorage.getItem('DreamWebCert'));
					}
				}
			},
			syncLocalStorage : function(backupCertList ){
				if(GPKISecureWebApi.getProperty('isUseMLCert')){
					var CertBagList = localStorage.getItem('DreamWebCert');

					var arr1 = (backupCertList!=null && backupCertList!="null") ? JSON.parse(backupCertList) : [];
					var arr2 = (CertBagList!=null && CertBagList!="null") ? JSON.parse(CertBagList) : [];
					var arr = $.merge(arr1, arr2); 

					var result = [];
					$.each(arr, function(index, element) {
						var orgin_str = JSON.stringify(result);
						var elm_str = JSON.stringify(element);
						if (orgin_str.indexOf(elm_str) < 0){
							result.push(element);  
						}
					});

					//GPKISecureWebLog.log("GPKISecureWebUtil.syncLocalStorage result = " + JSON.stringify(result));

					// localStorage - gpkiweb
					localStorage.removeItem('DreamWebCert');
					localStorage.setItem('DreamWebCert', JSON.stringify(result));
					
					// localStorage - gpkicert
					setBackupCertListToMlcert(JSON.stringify(result));
				}
			},
			saveCertValue : function( key,value ){
				if(window.localStorage){
					localStorage.setItem( key, value );
				} else{
					if(window.sessionStorage){
						sessionStorage.setItem( key, value );
					}else{
						var Cert = encodeURI( value );
						this.setCookie( key, "", -1 );
						this.setCookie( key, Cert, 1);
					}
				}
			},
			loadCertValue : function( key ){
				try{
					if(window.localStorage){
						return localStorage.getItem( key );
					} else{
						if(window.sessionStorage){
							return sessionStorage.getItem( key );
						}else{
							var cert = this.getCookie( key );
							return decodeURI( cert );
						}
					}
				}catch( e ){
					GPKISecureWebLog.log("[ERROR]GPKISecureWebUtil.loadValue  ===" + e.message);
					return "";
				}
			},
			setCookie : function(cname, cvalue, exdays){
				var d = new Date();
				
				d.setTime(d.getTime() + (exdays*300000));
				var expires = "expires=" + d.toUTCString();
				document.cookie = cname + "=" + cvalue + "; " + expires;
			},
			getCookie : function(cname){
				var name = cname + "=";
				var ca = document.cookie.split(';');
				for(var i=0; i<ca.length; i++) {
					var c = ca[i];
					while (c.charAt(0)==' ') c = c.substring(1);
					if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
				}
				return "";
			},
			checkPasswordValidation : function(password, callback ) {
				if( password.length<8 || password.length > 20 ) {
					callback(1, {"msg":"비밀번호는 소문자, 대문자, 숫자, 특수문자의 조합으로 9~20자리로 입력해주세요."});
					return;
				}

				var passwd = password;
				var chk_num = passwd.search(/[0-9]{2,}/g);
				var chk_eng = passwd.search(/[a-z]{2,}/g);
				var chk_Beng = passwd.search(/[A-Z]{2,}/g);
				var chk_spc = passwd.search(/[`!@$%^&*()<>|\\\'\";:\/?]{2,}/i);
				//alert("chk_num :"+chk_num+"\n"+"chk_eng :"+chk_eng+"\n"+"chk_Beng :"+chk_Beng+"\n"+"chk_spc :"+chk_spc+"\n");

				if((chk_num < 0)) {
					 callback(1, {"msg":"숫자가 2자 이상 포함되어 있어야 합니다."});
					 return;
				}
				if((chk_eng < 0)) {
					callback(1, {"msg":"소문자가 2자 이상 포함되어 있어야 합니다."});
					return;
				}
				if((chk_Beng < 0)) {
					callback(1, {"msg":"대문자가 2자 이상 포함되어 있어야 합니다."});
					return;
				}
				if((chk_spc < 0)) {
					callback(1, {"msg":"기호가 2자 이상 포함되어야 합니다."});
					return;
				}

				var SamePass_0 = 0; //동일문자 카운트
				var SamePass_1 = 0; //연속성(+) 카운드
				var SamePass_2 = 0; //연속성(-) 카운드

				var chr_pass_0;
				var chr_pass_1;
				var chr_pass_2;

				for(var i=0; i < password.length; i++) {
					chr_pass_0 = password.charAt(i);
					chr_pass_1 = password.charAt(i+1);

					//동일문자 카운트
					if(chr_pass_0 == chr_pass_1) {
						SamePass_0 = SamePass_0 + 1;
					}

					chr_pass_2 = password.charAt(i+2);
					//연속성(+) 카운드

					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
						SamePass_1 = SamePass_1 + 1;
					}

					//연속성(-) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
						SamePass_2 = SamePass_2 + 1;
					}
				}

				if(SamePass_0 > 1) {
					callback(1, {"msg":"동일문자를 3번 이상 사용할 수 없습니다."});
					return;
				}

				if(SamePass_1 >= 1 || SamePass_2 >= 1 ) {
					callback(1, {"msg":"연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다."});
					return;
				}

				callback(0, {"msg":"성공"});
			},
			isDateExpired : function(dateStr){
				var dateArr = dateStr.split("-");
				var today = new Date();
				var a = dateStr.split(" ");
				var d = a[0].split("-");
				var t = a[1].split(":");
				var endDate = new Date(d[0],(d[1]-1),d[2],t[0],t[1],t[2]);

				if (today < endDate) {
					return false;
				} else {
					return true;
				}
			},
			getTimeStamp : function() {
			  var d = new Date();

			  var s =
				leadingZeros(d.getFullYear(), 4) + '-' +
				leadingZeros(d.getMonth() + 1, 2) + '-' +
				leadingZeros(d.getDate(), 2) + ' ' +

				leadingZeros(d.getHours(), 2) + ':' +
				leadingZeros(d.getMinutes(), 2) + ':' +
				leadingZeros(d.getSeconds(), 2);

			  return s;
			},
			leadingZeros : function (n, digits) {
			  var zero = '';
			  n = n.toString();

			  if (n.length < digits) {
				for (i = 0; i < digits - n.length; i++)
				  zero += '0';
			  }
			  return zero + n;
			},
			isDateCompare : function(dtmfrom, dtmto){
				return new Date(dtmfrom).getTime() >=  new Date(dtmto).getTime() ;
			},
			yyyymmdd : function(dateIn) {
				var yyyy = dateIn.getFullYear();
				var mm = dateIn.getMonth()+1; // getMonth() is zero-based
				var dd  = dateIn.getDate();
				return String(10000*yyyy + 100*mm + dd); // Leading zeros for mm and dd
			}
		};

		window.GPKISecureWebUtil = _GPKISecureWebUtil;
	}
	jQuery(document).ready(function() {
	});
	
	$.cachedScript = function(url, options){
		options = $.extend(options || {}, {
			DataType : "script",
			cache : true,
			url : url
		});
		return jQuery.ajax(options);
	}
	$.nonCachedScript = function(url, options){
		options = $.extend(options || {}, {
			DataType : "script",
			cache : false,
			url : url
		});
		return jQuery.ajax(options);
	}
})(jQuery);
