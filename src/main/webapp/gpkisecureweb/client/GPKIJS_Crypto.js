/**************************************************
 * 
 */
var GPKIJS_Crypto = (function(context) {
	var gpkijs      = null;
	var mPrikeyInfo  = null;
	var mContentInfo = null;

	if (typeof(Object.assign) != 'function') {
		Object.assign = function(target, varArgs) { // .length of function is 2
			'use strict';
			if (target == null) { // TypeError if undefined or null
				throw new TypeError('Cannot convert undefined or null to object');
			}
			var to = Object(target);
			for (var index = 1; index < arguments.length; index++) {
				var nextSource = arguments[index];
				if (nextSource != null) { // Skip over if undefined or null
					for (var nextKey in nextSource) {
						// Avoid bugs when hasOwnProperty is shadowed
						if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
							to[nextKey] = nextSource[nextKey];
						}
					}
				}
			}
			return to;
		};
	}

	this.Define = {PKI_OPT					: 0
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
	
	if (context != null && typeof(context) != "undefined" && typeof(context) == "object") {
		gpkijs = context;
	}
	
	GPKIJS_Crypto.prototype.Init = function(context) {
		if (context != null && typeof(context) != "undefined" && typeof(context) == "object") {
			gpkijs = context;
		}
	}

	/* 4. 개인키 */
	GPKIJS_Crypto.prototype.JS_PRIKEY_Object = function() {
		var oResult = 0;
		
		if (mPrikeyInfo != null && typeof(mPrikeyInfo) != "undefined" && typeof(mPrikeyInfo) == "object") {
			oResult = {code:0, message:mPrikeyInfo};			
		} else {
			oResult = {code:2507, message:"error read prikey"};			
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_PRIKEY_Decrypt= function(sPassword, sEncPriKey, callback) {
		var oResult = 0;
		var priKeyInfo;

		try {
			if (typeof(sPassword) == "undefined") {
				throw {code:1004, message:"The input is invalid type."};
			}
			if (typeof(sEncPriKey) == "undefined") {
				throw {code:1004, message:"The input is invalid type."};
			}
			
			priKeyInfo = gpkijs.pkcs5.decrypt(sEncPriKey, sPassword);			
			oResult = {code:0, message:priKeyInfo};
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	/* 6. 암호 메시지 (CMS) */
	GPKIJS_Crypto.prototype.JS_CMS_MakeSignedData = function(sCert, sPriKey, sPassword, oSignOpt, sTBSData, callback) {
		var oResult	   = 0;
		var signOption = new Object();

		mPrikeyInfo = null;
		
		try {
			if (typeof(sCert) == "undefined") {
				throw {code:1004, message:"The input is invalid type."};
			}
			if (typeof(sPriKey) == "undefined") {
				throw {code:1004, message:"The input is invalid type."};
			}
			if (typeof(sPassword) == "undefined") {
				throw {code:1004, message:"The input is invalid type."};
			}
			
			// 해시 알고리즘 설정 (CertHash, SHA1, SHA256)
			if (oSignOpt != null && typeof(oSignOpt) != "undefined" && typeof(oSignOpt.ds_pki_hash) != "undefined") {
				if (oSignOpt.ds_pki_hash !== this.Define.HASH_ALG_CERT) {
					signOption.md = oSignOpt.ds_pki_hash;
				}
			}

			if (oSignOpt != null && typeof(oSignOpt) != "undefined" && typeof(oSignOpt.ds_pki_rsa) != "undefined") {
				if (oSignOpt.ds_pki_rsa == this.Define.PKI_RSA_2_0) {
					signOption.scheme = this.Define.PKI_RSA_2_0_SIGN;
				} else {
					signOption.scheme = this.Define.PKI_RSA_1_5_STRING;
				} 
			} else {
				signOption.scheme = this.Define.PKI_RSA_1_5_STRING;
			}

			// 서명 옵션
			if (oSignOpt != null && typeof(oSignOpt) != "undefined" && typeof(oSignOpt.ds_pki_sign) != "undefined") {
				var iformat      = 0;
				var selectformat = 0;
				
				for (var idx=0; idx<oSignOpt.ds_pki_sign.length; idx++){
					switch(oSignOpt.ds_pki_sign[idx]){
						case this.Define.PKI_CERT_SIGN_OPT_NONE:
							selectformat = gpkijs.pkcs7.signedData.format.none;
							break;
						case this.Define.PKI_CERT_SIGN_OPT_USE_CONTNET_INFO:
							selectformat = gpkijs.pkcs7.signedData.format.useContentInfo;
							break;
						case this.Define.PKI_CERT_SIGN_OPT_NO_CONTENT:
							selectformat = gpkijs.pkcs7.signedData.format.noContent;
							break;
						case this.Define.PKI_CERT_SIGN_OPT_SIGNKOREA_FORMAT:
							selectformat = gpkijs.pkcs7.signedData.format.signGateFormat;
							break;
						case this.Define.PKI_CERT_SIGN_OPT_HASHED_CONTENT:
							selectformat = gpkijs.pkcs7.signedData.format.hashedContent;
							break;
					}
					
					iformat = iformat | selectformat;
				}
				
				signOption.format = iformat;
			} else{
				signOption.format = gpkijs.pkcs7.signedData.format.none;
			}
			
			// 공개키 설정
			var x509Cert = gpkijs.x509Cert.create(sCert);
			
			// 개인키 복호화
			var prikey = this.JS_PRIKEY_Decrypt(sPassword, sPriKey);
			
			if (prikey.code != 0) {
				throw prikey;
			}

			mPrikeyInfo = new Object();
			Object.assign(mPrikeyInfo, prikey.message);
			
			var signedData = gpkijs.pkcs7.signedData.create();
			signedData.content = sTBSData; //gpkijs.utf8.encode(sTBSData);
			
			signedData.sign(x509Cert, prikey.message, signOption);
			oResult = {code:0, message:signedData};			
		} catch (ex) {
			oResult = ex;
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_CMS_MakeEnvelopedData = function(sKMCert, sAlgo, oEnvelopOpt, sPlainText, callback) {
		var oResult  	  = 0;
		var envelopData	  = new Object();
		var envelopOption = new Object();
		
		mContentInfo = null;
		
		try {
			if (sKMCert == null || typeof(sKMCert) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sKMCert)"};
			}
			if (sAlgo == null || typeof(sAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sAlgo)"};
			}
			if (sPlainText == null || typeof(sPlainText) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sPlainText)"};
			}
			
			if (!(sAlgo === this.Define.SYM_ALG_3DES_CBC 
				|| sAlgo === this.Define.SYM_ALG_SEED_CBC 
				|| sAlgo === this.Define.SYM_ALG_ARIA_CBC 
				|| sAlgo === this.Define.SYM_ALG_ARIA_192BIT_CBC
				|| sAlgo === this.Define.SYM_ALG_ARIA_256BIT_CBC
				|| sAlgo === this.Define.SYM_ALG_AES_CBC 
				|| sAlgo === this.Define.SYM_ALG_AES_192BIT_CBC
				|| sAlgo === this.Define.SYM_ALG_AES_256BIT_CBC)) {
				throw {code:1004, message:"Not Support Algorithm " + sAlgo};
			}
			
			var x509KMCert		= gpkijs.x509Cert.create(sKMCert);
			var envelopData		= gpkijs.pkcs7.envelopedData.create();
			envelopData.content = sPlainText; //gpkijs.utf8.encode(sPlainText);
			
			// 서명 알고리즘 설정	
			if (oEnvelopOpt != null && typeof(oEnvelopOpt) != "undefined" && typeof(oEnvelopOpt.ds_pki_rsa) != "undefined") {
				if (oEnvelopOpt.ds_pki_rsa == this.Define.PKI_RSA_2_0) {
					envelopOption.scheme = this.Define.PKI_RSA_2_0_ENVELOP;
				} else {
					envelopOption.scheme = this.Define.PKI_RSA_1_5_STRING;
				} 
			} else {
				envelopOption.scheme = this.Define.PKI_RSA_1_5_STRING;
			}
			
			if (envelopOption.scheme === this.Define.PKI_RSA_2_0_ENVELOP) {
				// 해시 알고리즘 설정 (CertHash, SHA1, SHA256)
				if (oEnvelopOpt != null && typeof(oEnvelopOpt) != "undefined" && typeof(oEnvelopOpt.ds_pki_hash) != "undefined") {
					if (oEnvelopOpt.ds_pki_hash !== this.Define.HASH_ALG_CERT) {
						envelopOption.md = oSignOpt.ds_pki_hash;
					}
				}
			}
			
			var contentEncAlgo = sAlgo + "-CBC";
			
			envelopData.addRecipient(x509KMCert, envelopOption);
			envelopData.encrypt(contentEncAlgo);
			
			mContentInfo = new Object();
			Object.assign(mContentInfo, envelopData.contentEncInfo);
			
			oResult = {code:0, message:envelopData};
			
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}

	/* 7. 본인확인 (VID) */
	GPKIJS_Crypto.prototype.JS_VID_GetRandomFromPriKey = function(oPriKey, callback) {
		var oResult = 0;
		
		try {
			if (oPriKey == null || typeof(oPriKey) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(oPriKey)"};
			}
			if (typeof(oPriKey.getRandomNum) != "function") {
				throw {code:1004, message:"The input is invalid type. (oPriKey.getRandomNum)"};
			}
			
			oResult = {code:0, message:oPriKey.getRandomNum()};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_VID_VERIFY = function(sCert, nRandomNum, sIDN, callback) {
		var oResult = 0;
		
		try {
			if (typeof(sCert) == "undefined") {
				throw {code:1004, message:"The input is invalid type."};
			}
			
			var X509Cert = gpkijs.x509Cert.create(sCert);
			
			var verify = X509Cert.verifyVID(nRandomNum, sIDN);
			
			if (verify == true) {
				oResult = {code:verify, message:"success"};
			} else {
				oResult = {code:verify, message:"fail"};
			}							
		} catch (ex) {
			oResult = ex;			
		}
		
		return oResult;
	}
	
	/* 13. 암호 알고리즘 */
	GPKIJS_Crypto.prototype.JS_CRYPT_GetKeyAndIV = function(callback) {
		var oResult = 0;
		
		try {
			if (mContentInfo == null || typeof(mContentInfo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(mContentInfo)"};
			}
			
			oResult = {code:0, message:mContentInfo};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_CRYPT_Encrypt = function(sAlgo, sKey, sIv, sPlainText, callback) {
		var oResult = 0;
		
		try {
			if (sAlgo == null || typeof(sAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sAlgo)"};
			}
			if (sKey == null || typeof(sKey) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sKey)"};
			}
			if (sIv == null || typeof(sIv) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sIv)"};
			}
			if (sPlainText == null || typeof(sPlainText) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sPlainText)"};
			}

			var cipherAlgo = sAlgo.toUpperCase() + "-CBC";
			
			var cipher = gpkijs.cipher.create(true, cipherAlgo, sKey);
			cipher.init(sIv);
			cipher.update(sPlainText); //cipher.update(gpkijs.utf8.encode(sPlainText));
			var encrypted = cipher.finish();
			
			oResult = {code:0, message:encrypted};				
		} catch (ex) {
			oResult = ex;
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_CRYPT_Decrypt = function(sAlgo, sKey, sIv, sCipherText, callback) {
		var oResult = 0;
		
		try {
			if (sAlgo == null || typeof(sAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sAlgo)"};
			}
			if (sKey == null || typeof(sKey) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sKey)"};
			}
			if (sIv == null || typeof(sIv) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sIv)"};
			}
			if (sCipherText == null || typeof(sCipherText) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sCipherText)"};
			}

			var cipherAlgo = sAlgo.toUpperCase() + "-CBC";
			
			var cipher = gpkijs.cipher.create(false, cipherAlgo, sKey);
			cipher.init(sIv);
			cipher.update(sCipherText);
			var decrypted = cipher.finish();
			
			oResult = {code:0, message:decrypted};				
		} catch (ex) {
			oResult = ex;
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_CRYPT_Hash = function(sAlgo, sTBHData, callback) {
		var oResult = 0;
		
		try {
			if (sAlgo == null || typeof(sAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sAlgo)"};
			}
			if (sTBHData == null || typeof(sTBHData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sTBHData)"};
			}
			
			if (!(sAlgo === this.Define.HASH_ALG_SHA1 
					|| sAlgo === this.Define.HASH_ALG_SHA256 
					|| sAlgo === this.Define.HASH_ALG_SHA512)) {
					throw {code:1004, message:"Not Support Algorithm " + sAlgo};
				}
			
			var oDigest = gpkijs.md.create(sAlgo);			
			
			oDigest.init();
			oDigest.update(sTBHData);
			var sDigest = oDigest.digest();
			
			oResult = {code:0, message:sDigest};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	/* 14. BASE64 */
	GPKIJS_Crypto.prototype.JS_BASE64_Encode = function(sData, callback) {
		var oResult = 0;
		
		try {
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			
			var b64encode = gpkijs.base64.encode(sData);
			
			oResult = {code:0, message:b64encode};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_BASE64_Decode = function(sEncData, callback) {
		var oResult = 0;
		
		try {
			if (sEncData == null || typeof(sEncData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sEncData)"};
			}
			
			var b64decode = gpkijs.base64.decode(sEncData);
			
			oResult = {code:0, message:b64decode};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	/* 14. UTF8 */
	GPKIJS_Crypto.prototype.JS_UTF8_Encode = function(sData, callback) {
		var oResult = 0;
		
		try {
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			
			var utf8data = gpkijs.utf8.encode(sData);
			
			oResult = {code:0, message:utf8data};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GPKIJS_Crypto.prototype.JS_UTF8_Decode = function(sData, callback) {
		var oResult = 0;
		
		try {
			if (sData == null || typeof(sData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sData)"};
			}
			
			var utf8data = gpkijs.utf8.decode(sData);
			
			oResult = {code:0, message:utf8data};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
});



