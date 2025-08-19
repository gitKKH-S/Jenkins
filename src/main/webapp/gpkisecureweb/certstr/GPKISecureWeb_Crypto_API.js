if (typeof GPKISecureWebLog === "undefined" || $.isEmptyObject(GPKISecureWebLog) || GPKISecureWebLog===null) {
	//console.log("_GPKISecureWebLog.log() init() called...  logType = " + GPKISecureWebApi.webConfig.logType);
	var errorCodeObject =  {};
	var _GPKISecureWebLog = {
		init : function() {			
		},
		log : function(text) {
			var logTxt = "[GPKISecureWebLog]:: "+text;
			console.log( logTxt );
		},
		getErrCode : function(key) {
			return errorCodeObject[key];
		}
	};
	
	window.GPKISecureWebLog = _GPKISecureWebLog;
}


var JS_Crypto_API = (function(){
	function init(callback){
		GPKISecureWebLog.log("JS_Crypto_API Init() start...");
		
		// gpkijs_1.2.1.3.min.js
		gpkijs.init("QIzXQvZfuJEf1Y11am1DUSt9670RUOkRrVqXA+oSx1zCG3xdIP7i+2/AW5ZhjOMiPyNRMpB3k5e3V3dgXyLKdOXctfX3KVMzMr1j0og4EfzFEtvnkmIcYO+pPHqx6wHqqFt/adMorr2kWnYl2iRzUMA3APyIUjEgMEFY9jWDnzplispqoeX72673SROXcxfzYet0YYWVHnmYGfoafHLyApl6UopXGWuQDMxD3n9nEAh8YUxR9J83UQVlg6OhbbDCDKxpnpzv6AdZfz1xq/8tAcMvkogAzAtJrcnFKQZ9hOnLrzVHJd4AhDfHEkpPtTz7f0mIwfILw0DJMi74QZwOXw==");
		
		if (typeof(callback) == "function") {
			callback(0, {"result":"JS_Crypto_API init success..."});
		} else {
			return 0;
		}
		
	}
	
	function base64encode(sMsg, callback){
		GPKISecureWebLog.log('base64encode by javascript');
		var Base64Result = "";
		
		try{
			var Base64Result = gpkijs.base64.encode(sMsg);
			
			if( typeof callback === 'function'){
				callback( 0, {"result": Base64Result} );
			} else {
				return Base64Result;
			}	
		} catch (e){
			if( typeof callback === 'function'){
				callback(e.code, {"errCode": 888, "errMsg": e.message});
			} else {
				return Base64Result;
			}		
		}		
	}
	
	function base64decode(sMsg, callback){
		GPKISecureWebLog.log('base64decode by javascript');
		
		var Base64Result = "";
		
		try{
			var Base64Result = gpkijs.base64.decode(sMsg);
			
			if( typeof callback === 'function'){
				callback( 0, {"result": Base64Result} );
			} else {
				return Base64Result;
			}	
		} catch (e){
			if( typeof callback === 'function'){
				callback(e.code, {"errCode": 888, "errMsg": e.message});
			} else {
				return Base64Result;
			}		
		}	
	}
	
	function genHmac(sAlg, sBase64Password, sMsg, callback){
		GPKISecureWebLog.log('genHmac by javascript');

		try {
			var hmac1 = gpkijs.hmac.create(sAlg);
			hmac1.init( gpkijs.base64.decode(sBase64Password) );
			hmac1.update(sMsg);	// To be mac data.
			var hamcValue = hmac1.generate();

			var Base64Result = gpkijs.base64.encode(hamcValue);

			callback( 0, {"Base64Result": Base64Result} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_genHmac"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function verifyHmac(sAlg, sBase64Password, sMsg, hamcValue, callback){
		GPKISecureWebLog.log('verifyHmac by javascript');
		try {
			var hmac2 = gpkijs.hmac.create(sAlg);
			hmac2.init(gpkijs.base64.decode(sBase64Password));		// Mac key.
			hmac2.update(sMsg);	// To be mac data.

			var result =  hmac2.verify(gpkijs.base64.decode(hamcValue)); //true or false
			callback( 0, {"result": result} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_verifyHmac"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	/*
	 * symmOpt - symmetric cipher alg,padding
	 */
	function encrypt(sAlg, b64key, b64iv, sMsg, callback){
		GPKISecureWebLog.log('encrypt by javascript');

		try {
			var cipher = gpkijs.cipher.create(true, sAlg , gpkijs.base64.decode( b64key ));
			cipher.init( gpkijs.base64.decode( b64iv ));
			cipher.update(sMsg);
			cipher.finish();

			var Base64Result = gpkijs.base64.encode(cipher.output);
			var HexResult	 = gpkijs.hex.encode(cipher.output); 
			
			if (typeof(callback) == "undefined"){
				return {"errCode":0, "Base64Result": Base64Result, "HexResult":HexResult};				
			} else {
				callback( 0, {"Base64Result": Base64Result, "HexResult":HexResult} );
			}
		} catch (e){
			if (typeof(callback) == "undefined"){
				GPKISecureWebLog.log('- encrypt Error = ' + e.message);
				return {"errCode":GPKISecureWebLog.getErrCode("Crypto_JS_encrypt"), "errMsg": e.message};
			}else{
				callback( GPKISecureWebLog.getErrCode("Crypto_JS_encrypt"), {"errCode": 888, "errMsg": e.message} );
			}
		}
	}

	function decrypt(sAlg, b64key, b64iv, b64EncryptMsg, callback){
		GPKISecureWebLog.log('decrypt by javascript');

		try {
			var cipher = gpkijs.cipher.create(false, sAlg , gpkijs.base64.decode( b64key ));
			cipher.init( gpkijs.base64.decode( b64iv ));
			cipher.update(gpkijs.base64.decode(b64EncryptMsg));
			cipher.finish();

			var stringResult = cipher.output.data;

			callback( 0, {"stringResult": stringResult} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_decrypt"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function sign (b64cert, b64priKey, sCertPassword, signData, signOpt, callback) {
		GPKISecureWebLog.log('sign by javascript');
		
		try {
			// Decrypt certificate
			//var priKey = gpkijs.priKey.create(b64priKey);
			//var priKeyInfo = gpkijs.pkcs5.decrypt(b64priKey, sCertPassword);
			//var x509Cert = gpkijs.x509Cert.create(b64cert);
			
			// Decrypt certificate			
			var priKeyInfo = "";
						
			if (sCertPassword != null) {
				//sCertPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sCertPassword);
				priKeyInfo = gpkijs.pkcs5.decrypt(b64priKey, sCertPassword);
			} else{				
				if (typeof(b64priKey) =="string") {
					priKeyInfo = gpkijs.priKey.create(b64priKey);
				} else {
					priKeyInfo = b64priKey;
				}
			}
			
			var x509Cert = "";
			var opts = {};
			
			if (typeof(b64cert) =="string") {
				x509Cert = gpkijs.x509Cert.create(b64cert);
			} else {
				x509Cert = b64cert;
			}
			
			var opts = {};
		/*	if( signData === null || signData === "" ){
				signOpt.ds_pki_sign[0] = "OPT_NO_CONTENT";
			}*/
			if(signOpt != null || signOpt != undefined){
				// Certificate Option (Set to JS toolkit)
				var PKI_CERT_SIGN_OPT_NONE					= 'OPT_NONE';					// 0
				var PKI_CERT_SIGN_OPT_USE_CONTNET_INFO		= 'OPT_USE_CONTNET_INFO';		// 1
				var PKI_CERT_SIGN_OPT_NO_CONTENT			= 'OPT_NO_CONTENT';				// 2
				var PKI_CERT_SIGN_OPT_SIGNKOREA_FORMAT		= 'OPT_SIGNKOREA_FORMAT';		// 4
				var PKI_CERT_SIGN_OPT_HASHED_CONTENT		= 'OPT_HASHED_CONTENT';			// 18
				
				var PKI_RSA_1_5								= 'rsa15';
				var PKI_RSA_2_0								= 'rsa20';
				var PKI_RSA_1_5_STRING						= 'RSASSA-PKCS1-V1_5';		// internal function
				var PKI_RSA_2_0_SIGN						= 'RSA-PSS';				// internal function
				var PKI_RSA_2_0_ENVELOP						= 'RSA-OAEP';				// internal function

				if( signOpt.ds_pki_sign != undefined ){
					var iformat = 0;
					var selectformat = 0;

					for(var li=0;li<signOpt.ds_pki_sign.length;li++){
						switch(signOpt.ds_pki_sign[li]){
								case PKI_CERT_SIGN_OPT_NONE:
										selectformat = gpkijs.pkcs7.signedData.format.none;
										break;
								case PKI_CERT_SIGN_OPT_USE_CONTNET_INFO:
										selectformat = gpkijs.pkcs7.signedData.format.useContentInfo;
										break;
								case PKI_CERT_SIGN_OPT_NO_CONTENT:
										selectformat = gpkijs.pkcs7.signedData.format.noContent;
										break;
								case PKI_CERT_SIGN_OPT_SIGNKOREA_FORMAT:
										selectformat = gpkijs.pkcs7.signedData.format.signGateFormat;
										break;
								case PKI_CERT_SIGN_OPT_HASHED_CONTENT:
										selectformat = gpkijs.pkcs7.signedData.format.hashedContent;
										break;
						}

						if(li == 0){
							iformat = selectformat;
						}else{
							iformat = iformat | selectformat;
						}
					}
					
					opts.format = iformat;
				}
				
				if(signOpt.ds_pki_rsa != undefined){
					if(signOpt.ds_pki_rsa == PKI_RSA_2_0){
						opts.scheme = PKI_RSA_2_0_SIGN;
						
						if(signOpt.ds_pki_hash != undefined){
							opts.md = signOpt.ds_pki_hash;
						}
					}else{
						opts.scheme = PKI_RSA_1_5_STRING;
					}
				}
			}

			GPKISecureWebLog.log('sign by javascript : Option ' +JSON.stringify(opts));
			
			var signedData = null;
			
			if(signOpt.ds_pki_signdata != ''){
				signedData = gpkijs.pkcs7.signedData.create(signOpt.ds_pki_signdata);
			}else{
				signedData = gpkijs.pkcs7.signedData.create();
			}
			
			if(signOpt.ds_msg_decode == "true"){
				signedData.content = gpkijs.base64.decode(signData);
			}else if(signOpt.ds_msg_decode == "hash"){
				signedData.content = gpkijs.hex.decode(signData);
			}else{
				signedData.content = signData;
			}
			
			var stringResult = null
			
			if(signOpt.ds_pki_signdata != '' && signOpt.ds_pki_signData !== undefined ){
				signedData.addSign(x509Cert, priKeyInfo, opts);
				stringResult = gpkijs.base64.encode(signedData.toDer().data);
			}else{
				signedData.sign(x509Cert, priKeyInfo, opts);
				stringResult = gpkijs.base64.encode(signedData.toDer().data);
			}
			if( typeof callback === 'function'){
				callback( 0, {"stringResult": stringResult} );
			}else{
				return {"code" : 0 , "data" : stringResult};
			}
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_sign"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	
	
	
	
	function signature(b64cert, b64priKey, sCertPassword, signData, signOpt, callback) {
					
		GPKISecureWebLog.log('signature by javascript');
		
		try {
			// Decrypt certificate			
			var priKeyInfo = "";
						
			if (sCertPassword != null) {
				//sCertPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sCertPassword);
				priKeyInfo = gpkijs.pkcs5.decrypt(b64priKey, sCertPassword);
			} else{				
				if (typeof(b64priKey) =="string") {
					priKeyInfo = gpkijs.priKey.create(b64priKey);
				} else {
					priKeyInfo = b64priKey;
				}
			}
			
			var x509Cert = "";
			var opts = {};
			
			if (typeof(b64cert) =="string") {
				x509Cert = gpkijs.x509Cert.create(b64cert);
			} else {
				x509Cert = b64cert;
			}
			
			if (priKeyInfo.algorithm == 'kcdsa'){
				opts.pubKey = x509Cert.pubKey;
				
				if(signOpt.ds_pki_hash != undefined){
					opts.md = signOpt.ds_pki_hash;
				}
			}else{ // RSA
				if(signOpt != null || signOpt != undefined){
					// Certificate Option (Set to JS toolkit)
					var PKI_RSA_1_5								= 'rsa15';
					var PKI_RSA_2_0								= 'rsa20';
					var PKI_RSA_1_5_STRING						= 'RSASSA-PKCS1-V1_5';		// internal function
					var PKI_RSA_2_0_SIGN						= 'RSA-PSS';				// internal function
					var PKI_RSA_2_0_ENVELOP						= 'RSA-OAEP';				// internal function
	
					if( signOpt.ds_pki_sign != undefined ){
						var iformat = 0;
						var selectformat = 0;
					}
					
					if(signOpt.ds_pki_rsa != undefined){
						if(signOpt.ds_pki_rsa == PKI_RSA_2_0){
							opts.scheme = PKI_RSA_2_0_SIGN;
							
							if(signOpt.ds_pki_hash != undefined){
								opts.md = signOpt.ds_pki_hash;
							}
						}else{
							opts.scheme = PKI_RSA_1_5_STRING;
						
							if(signOpt.ds_pki_hash != undefined){
								opts.md = signOpt.ds_pki_hash;
							}
						}
					}
				}
			}
			if( signData === null || signData === "" ){
				var temp = x509Cert.subject;
				signData = GPKISecureWebApi.makeReverseDN( temp );
				
			}
			//GPKISecureWebLog.log('sign by javascript : Option ' +JSON.stringify(opts));
			
			//var stringResult = gpkijs.base64.encode(signedData.toDer().data);
			var stringResult = gpkijs.base64.encode(priKeyInfo.generateSignature(signData, opts.md, opts));
			
			callback( 0, {"stringResult": stringResult} );
			
			
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_sign"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	
	/*
	 * envelopedData : KM ?�증?�로 ?�호 ?�이?��??�성?�다
	 *				- sAlg 			: ?�고리즘 ('SEED-CBC', '3DES-CBC', 'AES-CBC', 'AES192-CBC', 'AES256-CBC')
	 *				- b64key 				: ?�호 KEY (Base64 String)
	 *				- b64iv 				: ?�호 IV  (Base64 String)
	 *				- b64EncryptMsg	: ?�호?�이?� (Base64 String)
	 *	output
	 *				- return : String Result  (null error)
	 */
	function envelopedData(b64KMCert, sPlainText , sAlgo, envelopOption, callback){
		GPKISecureWebLog.log('envelopedData by javascript');

		try {
			var x509Cert = gpkijs.x509Cert.create(b64KMCert);
			var envData = gpkijs.pkcs7.envelopedData.create();
			envData.content = sPlainText;

			// Set option
			var opts = null;
			if (envelopOption == null) {
				opts = {scheme : 'RSAES-PKCS1-V1_5'};
			} else {
				opts = envelopOption;
			}

			opts = {scheme : 'RSAES-PKCS1-V1_5'};

			envData.addRecipient(x509Cert, opts);
			envData.encrypt(sAlgo);

			var stringResult = gpkijs.base64.encode (envData.toDer().data);

			callback( 0, {"stringResult": stringResult} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_envelopedData"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function signedEnvelopedData(b64KMCert, b64SignCert, b64SignPri, sSignCertPassword, sPlainText , sAlgo, sSignEnvelopOption, callback){
		GPKISecureWebLog.log('signedEnvelopedData by javascript');

		try {
			var x509KMCert 			= gpkijs.x509Cert.create(b64KMCert);
			var x509SignCert 		= gpkijs.x509Cert.create(b64SignCert);

			var decSignPriKey = gpkijs.pkcs5.decrypt(b64SignPri, sSignCertPassword);

			var encopts = {};
			var opts = {};

			var PKI_CERT_SIGN_OPT_NONE							= 'OPT_NONE';		// 0
			var PKI_CERT_SIGN_OPT_USE_CONTNET_INFO				= 'OPT_USE_CONTNET_INFO';		// 1
			var PKI_CERT_SIGN_OPT_NO_CONTENT					= 'OPT_NO_CONTENT';			// 2
			var PKI_CERT_SIGN_OPT_SIGNKOREA_FORMAT				= 'OPT_SIGNKOREA_FORMAT';		// 4

			var PKI_RSA_1_5										= 'rsa15';
			var PKI_RSA_2_0										= 'rsa20';
			var PKI_RSA_1_5_STRING								= 'RSASSA-PKCS1-V1_5';	// internal funcion
			var PKI_RSA_2_0_SIGN								= 'RSA-PSS';			// internal funcion
			var PKI_RSA_2_0_ENVELOP								= 'RSA-OAEP';			// internal funcion

			encopts.scheme = PKI_RSA_1_5_STRING;
			opts.scheme = PKI_RSA_1_5_STRING;
			if (sSignEnvelopOption != null || sSignEnvelopOption != undefined)
			{
				if (sSignEnvelopOption.ds_pki_rsa != undefined)
				{
					if (  sSignEnvelopOption.ds_pki_rsa == PKI_RSA_2_0	)
					{
						encopts.scheme = PKI_RSA_2_0_ENVELOP;
						opts.scheme = PKI_RSA_2_0_SIGN;

						if (sSignEnvelopOption.ds_pki_hash != undefined)
						{
							encopts.md = sSignEnvelopOption.ds_pki_hash;
							opts.md = sSignEnvelopOption.ds_pki_hash;
						}
					}
				}
			}

			var signedAndEnvData = gpkijs.pkcs7.signedAndEnvData.create();
			signedAndEnvData.content = sPlainText;

			signedAndEnvData.addRecipient(x509KMCert, encopts);
			signedAndEnvData.signAndEnv(x509SignCert, decSignPriKey, sAlgo, opts);

			callback( 0, {"stringResult": gpkijs.base64.encode (signedAndEnvData.toPem())} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_signedEnvelopedData"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function verifyVID(b64SignCert, b64SignPri, sCertPassword, sIDN, callback){
		GPKISecureWebLog.log('verifyVID by javascript');

		try {
			// Decrypt certificate
			var priKeyInfo = gpkijs.pkcs5.decrypt(b64SignPri, sCertPassword);
			var x509Cert = gpkijs.x509Cert.create(b64SignCert);

			var result = x509Cert.verifyVID(priKeyInfo.getRandomNum(), sIDN);	//true or false

			callback( 0, {"result": result} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_verifyVID"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function generateRandom(size, callback){
		GPKISecureWebLog.log('generateRandom by javascript');

		try {
			var rand = gpkijs.generateRandomBytes(size);
			var result = gpkijs.base64.encode(rand);
			var resulthex = gpkijs.hex.encode(rand);
			

			if (typeof(callback) == "undefined"){
				return {"errCode":0, "result": result, "resulthex":resulthex};				
			} else {
				callback( 0, {"result": result, "resulthex":resulthex});
			}
		} catch (e){
			if (typeof(callback) == "undefined"){
				GPKISecureWebLog.log('- genHash Error = ' + e.message);
				return {"errCode":GPKISecureWebLog.getErrCode("Crypto_JS_generateRandom"), "errMsg": e.message};
			}else{
				callback( GPKISecureWebLog.getErrCode("Crypto_JS_generateRandom"), {"errCode": 888, "errMsg": e.message} );
			}			
		}
	}

	function genKeypair(sAlgo, iKeyLenth, callback){
		GPKISecureWebLog.log('genKeypair by javascript');

		try {
			var keypair = gpkijs.generateKeyPair(sAlgo, {bits:iKeyLenth});

			var jsonReturn = {};
			jsonReturn.ds_pki_pubkey = gpkijs.base64.encode(keypair.publicKey.toDer().data);
			jsonReturn.ds_pki_prikey = gpkijs.base64.encode(keypair.privateKey.toDer().data);


			callback( 0, {"result": jsonReturn} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_genKeypair"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function genHash(sAlg, oMsg, callback){
		GPKISecureWebLog.log('genHash by javascript');
		try {
			var md = gpkijs.md.create(sAlg);
			md.update(oMsg);
			var digest = md.digest();

			var Base64Result = gpkijs.base64.encode(digest);
			var resulthex = gpkijs.hex.encode(digest);
			
			if (typeof(callback) == "undefined"){
				return {"errCode":0, "hash": Base64Result, "resulthex":resulthex};				
			} else {
				callback( 0, {"hash": Base64Result, "resulthex":resulthex});
			}
		} catch (e){
			if (typeof(callback) == "undefined"){
				GPKISecureWebLog.log('- genHash Error = ' + e.message);
				return {"errCode":GPKISecureWebLog.getErrCode("Crypto_JS_genHash"), "errMsg": e.message};
			}else{
				callback( GPKISecureWebLog.getErrCode("Crypto_JS_genHash"), {"errCode": 888, "errMsg": e.message} );
			}
		}
	}
	
	function genHashCount(sAlg, oMsg, count, callback){
		GPKISecureWebLog.log('genHashCount by javascript');
		try {
			var md = gpkijs.md.create(sAlg);
			var digest = oMsg;
			
			while(count--){
				digest = md.digest(digest);
			}
			
			var Base64Result = gpkijs.base64.encode(digest);
			var resulthex = gpkijs.hex.encode(digest);

			callback( 0, {"hash": Base64Result, "resulthex":resulthex});
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_genHash"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	
	function prikeyDecrypt(b64CertPri, sCertPassword, callback){
		GPKISecureWebLog.log('prikeyDecrypt by javascript');

		//sCertPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sCertPassword);
		
		try {
			var priKeyInfo = gpkijs.pkcs5.decrypt( b64CertPri, sCertPassword );
			var Base64String = gpkijs.base64.encode (priKeyInfo.toDer().data);

			if (typeof(callback) == "undefined"){
				return {"errCode":0, "Base64String": Base64String, "priKeyInfo":priKeyInfo};
			} else {
				callback( 0, {"Base64String": Base64String});
			}
		} catch (e){
			if (typeof(callback) == "undefined"){
				GPKISecureWebLog.log('- prikeyDecrypt Error = ' + e.message);
				return {"errCode":e.code, "errMsg": e.message};
			}else{
				callback(e.code, {"errCode": 888, "errMsg": e.message} );
			}			
		}
	}
	
	function prikeyEncrypt(b64certPriDec, sCertPassword, oOption, callback){
		GPKISecureWebLog.log('prikeyEncrypt by javascript');

		try {
			var options = null;

			if (oOption == null) {
				options = {};
				options.algorithm = 'seed';
//				options.count = keyInfo.count.value;
//				options.saltSize = keyInfo.saltSize.value;
			} else {
				options.algorithm = oOption;
			}

			var priKey = gpkijs.priKey.create(b64certPriDec);
			var encPriKey = gpkijs.pkcs5.encrypt( priKey, sCertPassword, options);

//			var Base64String = gpkijs.base64.encode( gpkijs.pem.decode(encPriKey).body );
			// 20160601-tamrin
			// remove pem
			var Base64String = gpkijs.base64.encode( encPriKey );

			callback( 0, {"Base64String": Base64String});
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_prikeyEncrypt"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	function getVIDRandom(b64SignPri , sCertPassword, callback){
		GPKISecureWebLog.log('getVIDRandom by javascript');
		try {
			// decrypt certificate
			
			//sCertPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sCertPassword);
			
			var priKeyInfo = gpkijs.pkcs5.decrypt(b64SignPri, sCertPassword);

			var result = gpkijs.base64.encode (priKeyInfo.getRandomNum());

			callback( 0, {"result": result});
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_getVIDRandom"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	function getVIDRandomHash(b64SignCert ,b64SignPri , sCertPassword, sIDN, callback){
			GPKISecureWebLog.log('getVIDRandomHash by javascript');
			try {
			var certificate = gpkijs.x509Cert.create(b64SignCert); 
			
			// ?�증??복호??
			var priKeyInfo = gpkijs.pkcs5.decrypt(b64SignPri, sCertPassword);
			var randomNum = priKeyInfo.getRandomNum();
			if (randomNum == null)
		 		return null;
		 
			// H(H(IDN + R))
			var vid_hash2 = certificate.makeVID(randomNum, sIDN, 2);
	
			var vidResult = gpkijs.base64.encode (vid_hash2);
	
			callback( 0, {"result": vidResult});
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_getVIDRandom"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	/*
	 * Encrypt certificate by public key
	 */
	function asymEncrypt(b64CertString, sPlaintext, oAlgo, callback){
		GPKISecureWebLog.log('asymEncrypt by javascript');
		try {
			var encrypted = null;

			var opts = {};
			if (oAlgo != null || oAlgo != undefined)
			{
				var PKI_RSA_1_5											= 'rsa15';
				var PKI_RSA_2_0											= 'rsa20';
				var PKI_RSA_1_5_STRING									= 'RSASSA-PKCS1-V1_5';	// internal function
				var PKI_RSA_2_0_SIGN									= 'RSA-PSS';			// internal function
				var PKI_RSA_2_0_ENVELOP									= 'RSA-OAEP';			// internal function

				if (oAlgo.ds_pki_rsa != undefined)
				{
					if ( oAlgo.ds_pki_rsa == PKI_RSA_2_0 )
					{
						opts.scheme = PKI_RSA_2_0_ENVELOP;
						if (oAlgo.ds_pki_hash != undefined)
							opts.md = oAlgo.ds_pki_hash;
					} else {
						opts.scheme = PKI_RSA_1_5_STRING;
					}
				}
			}

		 	GPKISecureWebLog.log('- asymEncrypt Option = '+JSON.stringify(opts));

			var certificate = gpkijs.x509Cert.create(b64CertString);
			var publicKey = certificate.pubKey;
			encrypted = publicKey.encrypt(sPlaintext, opts);
			var b64result =  gpkijs.base64.encode(encrypted);

			if (typeof(callback) == "undefined"){
				return b64result;
			} else {
				callback( 0, {"result": b64result});
			}			
		} catch (e){
			if (typeof(callback) == "undefined"){
				GPKISecureWebLog.log('- asymEncrypt Error = ' + e.message);
				return GPKISecureWebLog.getErrCode("Crypto_JS_asymEncrypt");
			}else{
				callback( GPKISecureWebLog.getErrCode("Crypto_JS_asymEncrypt"), {"errCode": 888, "errMsg": e.message} );
			}
		}
	}

	/*
	 * Decrypt certificate by public key
	 */
	function asymDecrypt(b64EncryptedKey, sCertPassword, sEncryptext, oAlgo, callback){
		GPKISecureWebLog.log('asymDecrypt by javascript');
		try {
			var opts = {};
				if (oAlgo != null || oAlgo != undefined)
				{
					var PKI_RSA_1_5											= 'rsa15';
					var PKI_RSA_2_0											= 'rsa20';
					var PKI_RSA_1_5_STRING									= 'RSASSA-PKCS1-V1_5';	// internal fuction
					var PKI_RSA_2_0_SIGN									= 'RSA-PSS';			// internal fuction
					var PKI_RSA_2_0_ENVELOP									= 'RSA-OAEP';			// internal fuction

					if (oAlgo.ds_pki_rsa != undefined)
					{
						if (  oAlgo.ds_pki_rsa == PKI_RSA_2_0	)
						{
							opts.scheme = PKI_RSA_2_0_ENVELOP;
							if (oAlgo.ds_pki_hash != undefined)
								opts.md = oAlgo.ds_pki_hash;
						} else {
							opts.scheme = PKI_RSA_1_5_STRING;
						}
					}

				}
		 		GPKISecureWebLog.log('- asymDecrypt Option = '+JSON.stringify(opts));

				var privateKey = gpkijs.pkcs5.decrypt(b64EncryptedKey, sCertPassword);
				var plainText = null;
				plainText = privateKey.decrypt( gpkijs.base64.decode (sEncryptext), opts);

			callback( 0, {"result": plainText});
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_asymDecrypt"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function pfxImport(b64Pfx, sPassword, callback){
		GPKISecureWebLog.log('pfxImport by javascript');
		
		
		//sPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sPassword);

		try {
			var pfx = gpkijs.pkcs12.create(b64Pfx);
				pfx.importPfx(sPassword);
				var oJsonCert = {};
				
				if(pfx.safeContents.length < 1){
					callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": 888, "errMsg": 'pfx is empty'} );
				}
				
				if(pfx.safeContents.length == 1){
					getcertInfo(pfx.safeContents[0].cert.toPem(),['keyusage'],function(code, jsonResponse){
						if(code==0){
							if (jsonResponse.result.keyusage.indexOf('digitalSignature') != -1) { // SignCert
								oJsonCert.signcert = gpkijs.base64.encode( pfx.safeContents[0].cert.toDer() );
								//oJsonCert.signpri =  prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[0].priKey.toDer()) , sPassword);
								prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[0].priKey.toDer()), sPassword, null, function(code, message){
									if(code == '0'){
										oJsonCert.signpri = message.Base64String;
									}else{
										callback( GPKISecureWebLog.getErrCode("Crypto_JS_prikeyEncrypt"), {"errCode": code, "errMsg": message});
									}
								});
								callback( 0, {"result": oJsonCert} );
							}else{
								callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": 888, "errMsg": 'digitalSignature is empty'} );
							}
						}else{
							callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": code, "errMsg": jsonResponse.errMsg} );
						}
					});
				}else{
					getcertInfo(pfx.safeContents[0].cert.toPem(),['keyusage'],function(code,jsonResponse){
						if(code==0){
							if(jsonResponse.result.keyusage.indexOf('digitalSignature') != -1){
								// SignCert
								oJsonCert.signcert = gpkijs.base64.encode( pfx.safeContents[0].cert.toDer() );
								//oJsonCert.signpri =  prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[0].priKey.toDer()) , sPassword);
								prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[0].priKey.toDer()), sPassword, null, function(code, message){
									if(code == '0'){
										oJsonCert.signpri = message.Base64String;

										// kmCert
										oJsonCert.kmcert = gpkijs.base64.encode( pfx.safeContents[1].cert.toDer() );
										//oJsonCert.kmpri =  prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[1].priKey.toDer()) , sPassword);
										prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[1].priKey.toDer()), sPassword, null, function(code, message){
											if(code == '0'){
												oJsonCert.kmpri = message.Base64String;
												callback( 0, {"result": oJsonCert} );
											}else{
												callback( GPKISecureWebLog.getErrCode("Crypto_JS_prikeyEncrypt"), {"errCode": code, "errMsg": message});
											}
										});
									}else{
										callback( GPKISecureWebLog.getErrCode("Crypto_JS_prikeyEncrypt"), {"errCode": code, "errMsg": message});
									}
								});
							}else{
								// SignCert
								oJsonCert.signcert = gpkijs.base64.encode( pfx.safeContents[1].cert.toDer() );
								//oJsonCert.signpri =  prikeyEncrypt(gpkijs.base64.encode(  pfx.safeContents[1].priKey.toDer()) , sPassword);
								prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[1].priKey.toDer()), sPassword, null, function(code, message){
									if(code == '0'){
										oJsonCert.signpri = message.Base64String;

										// kmCert
										oJsonCert.kmcert = gpkijs.base64.encode( pfx.safeContents[0].cert.toDer() );
										//oJsonCert.kmpri =  prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[0].priKey.toDer()) , sPassword);
										prikeyEncrypt(gpkijs.base64.encode(pfx.safeContents[0].priKey.toDer()), sPassword, null, function(code, message){
											if(code == '0'){
												oJsonCert.kmpri = message.Base64String;
												callback( 0, {"result": oJsonCert} );
											}else{
												callback( GPKISecureWebLog.getErrCode("Crypto_JS_prikeyEncrypt"), {"errCode": code, "errMsg": message});
											}
										});
									}else{
										callback( GPKISecureWebLog.getErrCode("Crypto_JS_prikeyEncrypt"), {"errCode": code, "errMsg": message});
									}
								});
							}
						}else{
							callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": code, "errMsg":  jsonResponse.errMsg} );
						}
					});
				}

			//callback( 0, {"result": oJsonCert} );
		} catch (e){
			if (e.code == 184573952){
				sPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.HD_api(sPassword);
				pfxImport_withOption(b64Pfx, sPassword, callback);
			} else{
				callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": 888, "errMsg": e.message} );
			}			
		}
	}
	
	function pfxImport_withOption(b64Pfx, sPassword, callback){
		GPKISecureWebLog.log('pfxImport by javascript');
		
		//sPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sPassword);

		try {
			var opts = {format : gpkijs.pkcs12.format.encPriKey};
			var pfx = gpkijs.pkcs12.create(b64Pfx);
				pfx.importPfx(sPassword, opts);
				var oJsonCert = {};
				
				if(pfx.safeContents.length < 1){
					callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": 888, "errMsg": 'pfx is empty'} );
				}
				
				if(pfx.safeContents.length == 1){
					getcertInfo(pfx.safeContents[0].cert.toPem(),['keyusage'],function(code, jsonResponse){
						if(code==0){
							if (jsonResponse.result.keyusage.indexOf('digitalSignature') != -1) { // SignCert
								oJsonCert.signcert = gpkijs.base64.encode( pfx.safeContents[0].cert.toDer() );
								oJsonCert.signpri = gpkijs.base64.encode( pfx.safeContents[0].priKey );
								
								callback( 0, {"result": oJsonCert} );
							}else{
								callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": 888, "errMsg": 'digitalSignature is empty'} );
							}
						}else{
							callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": code, "errMsg": jsonResponse.errMsg} );
						}
					});
				}else{
					getcertInfo(pfx.safeContents[0].cert.toPem(),['keyusage'],function(code,jsonResponse){
						if(code==0){
							if(jsonResponse.result.keyusage.indexOf('digitalSignature') != -1){
								// SignCert
								oJsonCert.signcert = gpkijs.base64.encode( pfx.safeContents[0].cert.toDer() );
								oJsonCert.signpri = gpkijs.base64.encode( pfx.safeContents[0].priKey );
								
								if (pfx.safeContents.length > 1) {
									oJsonCert.kmcert = gpkijs.base64.encode( pfx.safeContents[1].cert.toDer() );
									oJsonCert.kmpri = gpkijs.base64.encode( pfx.safeContents[1].priKey );
								}
								
								callback( 0, {"result": oJsonCert} );
							}else{
								// SignCert
								oJsonCert.signcert = gpkijs.base64.encode( pfx.safeContents[1].cert.toDer() );
								oJsonCert.signpri = gpkijs.base64.encode( pfx.safeContents[1].priKey );
								
								oJsonCert.kmcert = gpkijs.base64.encode( pfx.safeContents[0].cert.toDer() );
								oJsonCert.kmpri = gpkijs.base64.encode( pfx.safeContents[0].priKey );
								
								callback( 0, {"result": oJsonCert} );
							}
						}else{
							callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": code, "errMsg":  jsonResponse.errMsg} );
						}
					});
				}

			//callback( 0, {"result": oJsonCert} );
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxImport"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	
	function pfxExport(jsonCert, sPassword, callback){
		GPKISecureWebLog.log('pfxExport by javascript');
		//sPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sPassword);
		
		try {
			var pfx = gpkijs.pkcs12.create();

			var signcert = gpkijs.x509Cert.create(jsonCert.signcert);
			var signpri = "";
			
			if (typeof(jsonCert.pkcs5decrypt) == "undefined"  || jsonCert.pkcs5decrypt == true){
				signpri = gpkijs.pkcs5.decrypt(jsonCert.signpri, sPassword);
			} else {
				signpri = jsonCert.signpri;
			}
			
			pfx.safeContents.push({cert : signcert, priKey : signpri});

			// 20160823-tamrin
			// Error Fix
			if (jsonCert.kmcert != null && jsonCert.kmcert != undefined && jsonCert.kmcert.length !=0)
			{
					var kmcert = gpkijs.x509Cert.create(jsonCert.kmcert);
					var kmpri  = "";
					
					if (typeof(jsonCert.pkcs5decrypt) == "undefined" || jsonCert.pkcs5decrypt == true){
						kmpri = gpkijs.pkcs5.decrypt(jsonCert.kmpri, sPassword);
					} else {
						kmpri = jsonCert.kmpri;
					}
					
					pfx.safeContents.push({cert : kmcert, priKey : kmpri});
			}

			if (typeof(jsonCert.pkcs5decrypt) == "undefined"  || jsonCert.pkcs5decrypt == true){
				pfx.exportPfx(sPassword, {algorithm : 'des-EDE3'});
			} else {
				pfx.exportPfx(sPassword, {algorithm : 'des-EDE3', format:gpkijs.pkcs12.format.encPriKey});
			}
			
			var b64Result =  gpkijs.base64.encode(pfx.toDer());

			callback( 0, {"result": b64Result} );

		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxExport"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	
	function pfxChangePwExport(jsonCert, sPassword, sNewPassword, callback){
		GPKISecureWebLog.log('pfxChangePwExport by javascript');
		
		//sPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sPassword);
		
		try {
			var pfx = gpkijs.pkcs12.create();

			var signcert = gpkijs.x509Cert.create(jsonCert.signcert);
			var signpri = gpkijs.pkcs5.decrypt(jsonCert.signpri, sPassword);
			pfx.safeContents.push({cert : signcert, priKey : signpri});

			// 20160823-tamrin
			// Error Fix
			if (jsonCert.kmcert != null && jsonCert.kmcert != undefined && jsonCert.kmcert.length !=0)
			{
					var kmcert = gpkijs.x509Cert.create(jsonCert.kmcert);
					var kmpri  = gpkijs.pkcs5.decrypt(jsonCert.kmpri,sPassword);
					pfx.safeContents.push({cert : kmcert, priKey : kmpri});
			}

			pfx.exportPfx(sNewPassword, {algorithm : 'des-EDE3'});

			var b64Result =  gpkijs.base64.encode(pfx.toDer());

			callback( 0, {"result": b64Result} );

		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_pfxChangePwExport"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	
	function getcertInfo(b64Cert, jsonOption, callback){		
		GPKISecureWebLog.log('getcertInfo by javascript');
		try {
			var LCERT_INFO_VERSION             = 'version'           ;
			var LCERT_INFO_SERIALNUM           = 'serialnum'         ;
			var LCERT_INFO_SIGNATUREALGORITHM  = 'signaturealgorithm';
			var LCERT_INFO_ISSUERNAME          = 'issuername'        ;
			var LCERT_INFO_STARTDATE           = 'startdate'         ;
			var LCERT_INFO_ENDDATE             = 'enddate'           ;
			var LCERT_INFO_STARTDATETIME       = 'startdatetime'     ;
			var LCERT_INFO_ENDDATETIME         = 'enddatetime'       ;
			var LCERT_INFO_SUBJECTNAME         = 'subjectname'       ;
			var LCERT_INFO_PUBKEY              = 'pubkey'            ;
			var LCERT_INFO_PUBKEYALGORITHM     = 'pubkeyalgorithm'   ;
			var LCERT_INFO_KEYUSAGE            = 'keyusage'          ;
			var LCERT_INFO_CERTPOLICY          = 'certpolicy'        ;
			var LCERT_INFO_POLICYID            = 'policyid'          ;
			var LCERT_INFO_POLICYNOTICE        = 'policynotice'      ;
			var LCERT_INFO_SUBJECTALTNAME      = 'subjectaltname'    ;
			var LCERT_INFO_AUTHKEYID           = 'authkeyid'         ;
			var LCERT_INFO_SUBKEYID            = 'subkeyid'          ;
			var LCERT_INFO_CRLDP               = 'crldp'             ;
			var LCERT_INFO_AIA                 = 'aia'               ;
			var LCERT_INFO_REALNAME            = 'realname'          ;

			var x509Cert = gpkijs.x509Cert.create(b64Cert);

			var jsonReturn = {};
			var certData ={};
			var x509ExtensionsCnt = x509Cert.extensions.length;
			
			if (jsonOption.length == 0) {
				jsonOption.push('version');
				jsonOption.push('serialnum');
				jsonOption.push('signaturealgorithm');
				jsonOption.push('issuername');
				jsonOption.push('startdate');
				jsonOption.push('enddate');
				jsonOption.push('subjectname');
				jsonOption.push('pubkey');
				jsonOption.push('pubkeyalgorithm');
				jsonOption.push('keyusage');
				jsonOption.push('certpolicy');
				jsonOption.push('policyid');
				jsonOption.push('policynotice');
				jsonOption.push('subjectaltname');
				jsonOption.push('authkeyid');
				jsonOption.push('subkeyid');
				jsonOption.push('crldp');
				jsonOption.push('aia');
				jsonOption.push('realname');
				jsonOption.push('startdatetime');
				jsonOption.push('enddatetime');
			}
			
			if (x509ExtensionsCnt > 0){
				for (var i=0; i < x509ExtensionsCnt; i++){
					// authorityKeyIdentifier
					if (x509Cert.extensions[i].aki != null){
						certData.aki = "KeyID="+x509Cert.extensions[i].aki.keyIdentifier.toHex()+",\nCertificate Issuer:\n"+x509Cert.extensions[i].aki.authorityCertIssuer+",\nCertificate SerialNumber:\n"+x509Cert.extensions[i].aki.authorityCertIssuer;
					// subjectKeyIdentifier
					} else if (x509Cert.extensions[i].ski != null) {
						certData.subkeyid = x509Cert.extensions[i].ski.toHex();
					// keyUsage
					} else if (x509Cert.extensions[i].keyUsage != null) {
						certData.keyusage = keyUsage2Str(x509Cert.extensions[i].keyUsage);
					// certificatePolicies
					} else if (x509Cert.extensions[i].certPolicies != null) {
						var cps = null;
						var unotice = null;
						var x509PoliciesCnt = x509Cert.extensions[i].certPolicies.length;
						
						for (var j=0; j<x509PoliciesCnt; j++) {
							certData.policyid = x509Cert.extensions[i].certPolicies[j].policyIdentifier;
							
							if (x509Cert.extensions[i].certPolicies[j].cps != null) {
								cps = x509Cert.extensions[i].certPolicies[j].cps;
							}
							
							if (x509Cert.extensions[i].certPolicies[j].unotice !=null && x509Cert.extensions[i].certPolicies[j].unotice.explicitText != null){
								unotice = x509Cert.extensions[i].certPolicies[j].unotice.explicitText;
							}
						}
						
						certData.policynotice = unotice;
						certData.certpolicy = 'policyID = ' + certData.policyid +',\n'
								+'cpsUri  = ' + cps +',\n'+'UserNotice  = ' + unotice +',\n';
						
					// subjectAltNames / issuerAltNames
					} else if (x509Cert.extensions[i].subjectAltName != null || x509Cert.extensions[i].issuertAltName != null) {
						var altName = null;
						
						if (x509Cert.extensions[i].subjectAltName != null){
							altName = x509Cert.extensions[i].subjectAltName;
						}else{
							altName = x509Cert.extensions[i].issuertAltName;
						}
						
						var altNameCnt = altName.length;
						
						for (var j=0; j<altNameCnt; j++) {
							if (altName[j].otherName != null) {
								certData.subjectaltname  = '-identifyData\n- realName= ' + altName[j].otherName.realName;
								certData.realname = altName[j].otherName.realName;
								if (altName[j].otherName.vid != null) {
									certData.subjectaltname += '- vid (' + altName[j].otherName.vid.hashAlg + ')= ' + altName[j].otherName.vid.value.toHex();
								}
							}
						}
						
					// cRLDistributionPoints
					} else if (x509Cert.extensions[i].crlDPs != null) {
						var crldp = '';
						var x509CrlDpsCnt = x509Cert.extensions[i].crlDPs.length;
						
						for (var j=0; j<x509CrlDpsCnt; j++) {
							crldp += x509Cert.extensions[i].crlDPs[j].distributionPoint[0].uri+' ';
						}
						
						certData.crldp = crldp;
					// authorityInfoAccess
					} else if (x509Cert.extensions[i].aia != null) {
						var aia = '';
						
						if (x509Cert.extensions[i].aia.ocsp != null){
							//aia += 'ocsp  = ' + x509Cert.extensions[i].aia.ocsp.uri;
							aia += x509Cert.extensions[i].aia.ocsp.uri;
						}
						
		//				if (x509Cert.extensions[i].aia.caIssuer != null)
		//					aia += '<br>caIssuers  = ' + x509Cert.extensions[i].aia.caIssuer.uri;
						
						certData.aia = aia;
					}
				}
			}
			
			var jsonOptCnt = jsonOption.length;
			
			for (var i=0;i<jsonOptCnt; i++){
				var slResult = null;
				
				switch (jsonOption[i]) {
					case LCERT_INFO_VERSION :
						jsonReturn.version = x509Cert.version;
						break;
					case LCERT_INFO_SERIALNUM :
						jsonReturn.serialnum = x509Cert.serialNum;
						break;
					case LCERT_INFO_SIGNATUREALGORITHM :
						jsonReturn.signaturealgorithm = x509Cert.signAlg.name;
						break;
					case LCERT_INFO_ISSUERNAME :
						jsonReturn.issuername = x509Cert.issuer;
						break;
					case LCERT_INFO_STARTDATE :
						var lMonth = x509Cert.validity.notBefore.getMonth()+1;
						jsonReturn.startdate = x509Cert.validity.notBefore.getFullYear()+'-'+lMonth+'-'+x509Cert.validity.notBefore.getDate();
						break;
					case LCERT_INFO_ENDDATE :
						var lMonth = x509Cert.validity.notAfter.getMonth()+1;
						jsonReturn.enddate = x509Cert.validity.notAfter.getFullYear()+'-'+lMonth+'-'+x509Cert.validity.notAfter.getDate();
						break;
					case LCERT_INFO_STARTDATETIME :
						var lMonth = x509Cert.validity.notBefore.getMonth()+1;
						jsonReturn.startdatetime = x509Cert.validity.notBefore.getFullYear()+'-'+lMonth+'-'+x509Cert.validity.notBefore.getDate()    +' '+x509Cert.validity.notBefore.getHours()   +':'+x509Cert.validity.notBefore.getMinutes()    +':'+x509Cert.validity.notBefore.getSeconds();
					case LCERT_INFO_ENDDATETIME :
						var lMonth = x509Cert.validity.notAfter.getMonth()+1;
						jsonReturn.enddatetime = x509Cert.validity.notAfter.getFullYear()+'-'+lMonth+'-'+x509Cert.validity.notAfter.getDate()   +' '+x509Cert.validity.notAfter.getHours()   +':'+x509Cert.validity.notAfter.getMinutes()   +':'+x509Cert.validity.notAfter.getSeconds();
						break;
					case LCERT_INFO_SUBJECTNAME :
						jsonReturn.subjectname = x509Cert.subject;
						break;
					case LCERT_INFO_PUBKEY :
						jsonReturn.pubkey = x509Cert.pubKey.toDer().toHex();
						break;
					case LCERT_INFO_PUBKEYALGORITHM :
						jsonReturn.pubkeyalgorithm = x509Cert.pubKey.algorithm + ' (' + x509Cert.pubKey.keyLength + ' bits)';
						break;
					case LCERT_INFO_KEYUSAGE :
						jsonReturn.keyusage = certData.keyusage;
						break;
					case LCERT_INFO_CERTPOLICY :
						jsonReturn.certpolicy = certData.certpolicy;
						break;
					case LCERT_INFO_POLICYID :
						jsonReturn.policyid = certData.policyid;
						break;
					case LCERT_INFO_SUBJECTALTNAME :
						jsonReturn.subjectaltname = certData.subjectaltname;
						break;
					case LCERT_INFO_AUTHKEYID :
						jsonReturn.authkeyid = certData.authkeyid;
						break;
					case LCERT_INFO_SUBKEYID :
						jsonReturn.subkeyid = certData.subkeyid;
						break;
					case LCERT_INFO_CRLDP :
						jsonReturn.crldp = certData.crldp;
						break;
					case LCERT_INFO_AIA :
						jsonReturn.aia = certData.aia;
						break;
					case LCERT_INFO_REALNAME :
						jsonReturn.realname = certData.realname;
						break;
					case LCERT_INFO_POLICYNOTICE :
						jsonReturn.policynotice = certData.policynotice ;
						break;
				}
			}
			
			if (typeof(callback) == "undefined"){
				return {"errCode":0, "result": jsonReturn};
			} else {
				callback( 0, {"result": jsonReturn} );
			}
		} catch (e){
			if (typeof(callback) == "undefined"){
				GPKISecureWebLog.log('- getcertInfo Error = ' + e.message);
				return {"errCode":e.code, "errMsg": e.message};
			}else{
				callback( 42201, {"errCode": 888, "errMsg": e.message} );
			}
		}
	}

	function prikeyChangePassword (b64certPriEnc, sOldPassword, sNewPassword, oOption, callback){
		GPKISecureWebLog.log('prikeyChangePassword by javascript');
		try {
			var encPriKey = gpkijs.pkcs5.changePassword(b64certPriEnc, sOldPassword, sNewPassword);
			callback( 0, {"result": gpkijs.base64.encode( encPriKey )});
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_prikeyChangePassword"), {"errCode": 888, "errMsg": e.message} );
		}
	}

	function certChangePassword (jsonCert, sOldPassword, sNewPassword, oOption, callback){
		GPKISecureWebLog.log('certChangePassword by javascript');
		
		try {
			if (jsonCert == null || $.isEmptyObject(jsonCert)){
				GPKISecureWebLog.log("invalid param : jsonCert");
				callback(100, $.i18n.prop("ER100") + "[jsonCert]");
				return;
			} else if (sOldPassword == null || sOldPassword == ""){
				GPKISecureWebLog.log("invalid param : sOldPassword");
				callback(100, $.i18n.prop("ER100") + "[sOldPassword]");
				return;
			} else if (sNewPassword == null || sNewPassword == ""){
				GPKISecureWebLog.log("invalid param : sNewPassword");
				callback(100, $.i18n.prop("ER100") + "[sNewPassword]");
				return;
			} else if(typeof(jsonCert.signpri) == 'undefined' || typeof(jsonCert.signpri) != "string"){
				GPKISecureWebLog.log("invalid param : jsonCert.signpri");
				callback(100, $.i18n.prop("ER100") + "[jsonCert.signpri]");
				return;
			}
			
			//sOldPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sOldPassword);
			//sNewPassword = GPKISecureWebApi.gpkisecureweb_crypto_api.SD_api(sNewPassword);
			
			jsonCert.signpri = gpkijs.base64.encode( gpkijs.pkcs5.changePassword(jsonCert.signpri, sOldPassword, sNewPassword) );
			
			if(typeof(jsonCert.kmpri) != 'undefined' && typeof(jsonCert.kmpri) == "string"){
				jsonCert.kmpri   = gpkijs.base64.encode( gpkijs.pkcs5.changePassword(jsonCert.kmpri, sOldPassword, sNewPassword) );
			}
			
			callback( 0, {"result": jsonCert});
		} catch (e){
			callback( GPKISecureWebLog.getErrCode("Crypto_JS_certChangePassword"), {"errCode": 888, "errMsg": e.message} );
		}
	}
	function keyUsage2Str(keyUsage)
	{
		var str = '';

		if (keyUsage.cRLSign) 							{			str += 'cRLSign';					}
		if (keyUsage.dataEncipherment)			{
			if (str.length)				str += ',';
			str += 'dataEncipherment';
		}

		if (keyUsage.decipherOnly) {
			if (str.length)				str += ',';
			str += 'decipherOnly';
		}

		if (keyUsage.digitalSignature) {
			if (str.length)				str += ',';
			str += 'digitalSignature';
		}

		if (keyUsage.encipherOnly) {
			if (str.length)				str += ',';
			str += 'encipherOnly';
		}

		if (keyUsage.keyAgreenment) {
			if (str.length)				str += ',';
			str += 'keyAgreenment';
		}

		if (keyUsage.keyCertSign) {
			if (str.length)				str += ',';
			str += 'keyCertSign';
		}

		if (keyUsage.keyEncipherment) {
			if (str.length)				str += ',';
			str += 'keyEncipherment';
		}

		if (keyUsage.nonRepudiation) {
			if (str.length)				str += ',';
			str += 'nonRepudiation';
		}

		return str;
	}
	function signedAttributes(msgType, data) {		
		var signedData = gpkijs.pkcs7.signedData.create();
		var opts = '';
		var tbsData = '';
		var digestInfo = '';
		var mAlg = 'sha256';
		var mIntegrity = data; // data 형태 : {"signTime":"2018-12-11 12:12:12","plainText":"smartCert"}
		var signTime;
		// msgType 따른 분기 처리 필요
		if(msgType == 'signedAttribute'){
			if(mIntegrity.signTime.indexOf('T') < 0){
				mIntegrity.signTime = mIntegrity.signTime.replace(' ', 'T');
			}
			
			signTime = new Date(mIntegrity.signTime);
			// Safari 브라우저의 경우 시간이 UTC로 인식되기 때문에 KST와 맟추려면 -9시간을 해야함
			browser = GPKISecureWebApi.get_browser_info();
			browserName = browser.name;
			if((browserName.toLowerCase().indexOf('safari') > -1)){
				signTime = new Date(signTime.setTime(signTime - (9*60*60*1000)));
			}
			
			opts = {
				signingTime : signTime
			}
			
			tbsData = signedData.makeTBSData(gpkijs.utf8.encode(mIntegrity.plainText), mAlg, opts);
		}else{
			tbsData = gpkijs.utf8.encode(mIntegrity.plainText);
		}
		
		digestInfo = '3031300d060960864801650304020105000420' + messageDigest(tbsData);
		GPKISecureWebLog.log('digestInfo : ' + digestInfo);
		digestInfo = gpkijs.base64.encode(digestInfo);
		GPKISecureWebLog.log('base64 encoding digestInfo : ' + digestInfo);
		
		return digestInfo;
	}

	function messageDigest(msg) {
		var md = gpkijs.md.create('sha256');
		md.init();
		var digest = md.digest(msg);
		
		return digest.toHex();
	}
	
	function pkcs7(cert, msgType, plainText, signature, signTime){
		var x509Cert = gpkijs.x509Cert.create(cert);
		var signAlg = "RSASSA-PKCS1-V1_5";
		var mdAlg = "sha256";
		var signedData = gpkijs.pkcs7.signedData.create();
	
		var encodeArr = convertEncode(plainText);
		var tbsOpts;
		if(msgType === 'originHash') {
			tbsOpts = {signingTime : undefined};
		}else{
			tbsOpts = {signingTime : signTime};
		}
		var tbsData = signedData.makeTBSData(encodeArr, mdAlg, tbsOpts);
	
		// 서명 옵션
		var opts = {scheme : signAlg, md : mdAlg, cert : x509Cert};
		if(msgType === 'originHash') {
			opts.format = gpkijs.pkcs7.signedData.format.noSignedAttributes;
		}
		signedData.compose(1, opts, encodeArr, tbsData, gpkijs.base64.decode(signature));
	
		return gpkijs.base64.encode(signedData.toDer())
	}
	
	function convertEncode(tbdata){
		tbhdata =  gpkijs.utf8.encode(tbdata);
		var tbdata_bin = stringToBytes(tbhdata);
		return String.fromCharCode.apply(null, tbdata_bin);
	}

	function stringToBytes(param) {
		var schar, string_test, result = [], j=0;
		for (var i = 0; i < param.length; i++ ) {
			schar = param.charCodeAt(i);
			if(schar < 127){
				result[j++] = schar & 0xFF;
			}else {
				string_test = [];
				do {
					string_test.push( schar & 0xFF );
					schar = schar >> 8;
				} while ( schar );
				string_test = string_test.reverse();
				
				for(var k=0;k<string_test.length; ++k)
					result[j++] = string_test[k];
			}
		}
		return result;
	}
	
	function getEncryptedCert(string) {
		try {
			if( string !== null && typeof string !== "undefined" && string !== ""){
				var cipher = gpkijs.cipher.create(true, "SEED-CBC" , gpkijs.hex.decode( "0b9f0bb6f0a89844aedecb9f2508c7e2" ));
				cipher.init( gpkijs.hex.decode( "69068374ba84d85b68eea844d2d2c187" ));
				cipher.update(string);
				cipher.finish();
				return gpkijs.base64.encode(cipher.output);
			}
		} catch (e){
			return "";
		}
	}
	
	function getDecryptedCert(string){
		try {
			if( string !== null && typeof string !== "undefined" && string !== ""){
				var cipher = gpkijs.cipher.create(false, "SEED-CBC" , gpkijs.hex.decode( "0b9f0bb6f0a89844aedecb9f2508c7e2" ));
				cipher.init(gpkijs.hex.decode( "69068374ba84d85b68eea844d2d2c187" ));
				cipher.update(gpkijs.base64.decode(string));
				cipher.finish();
				return cipher.output.data;
			}
		} catch (e){
			return "";
		}
	}
	
	return{
		init:init,
//		getMDMsg:getMDMsg,
		base64encode:base64encode,
		base64decode:base64decode,
		genHmac:genHmac,
		verifyHmac:verifyHmac,
		encrypt:encrypt,
		decrypt:decrypt,
		sign:sign,
		envelopedData:envelopedData,
		signedEnvelopedData:signedEnvelopedData,
		verifyVID:verifyVID,
		getVIDRandom:getVIDRandom,
		getVIDRandomHash:getVIDRandomHash,
		generateRandom:generateRandom,
		genKeypair:genKeypair,
		genHash:genHash,
		genHashCount:genHashCount,
		prikeyDecrypt:prikeyDecrypt,
		prikeyEncrypt:prikeyEncrypt,
		getVIDRandom:getVIDRandom,
		asymEncrypt:asymEncrypt,
		asymDecrypt:asymDecrypt,
		pfxImport:pfxImport,
		pfxImport_withOption:pfxImport_withOption,
		pfxExport:pfxExport,
		pfxChangePwExport:pfxChangePwExport,
		getcertInfo:getcertInfo,
		prikeyChangePassword:prikeyChangePassword,
		certChangePassword:certChangePassword,
		signature:signature,
		signedAttributes:signedAttributes,
		pkcs7:pkcs7,
		getEncryptedCert:getEncryptedCert,
		getDecryptedCert:getDecryptedCert		
	};
});