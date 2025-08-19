var GenInterface = function(context) {
	var gpkijs 	 	= null;
	var mGpkiJSCrypto	= null;
	var mMajorVersion	= 1;
	var mMinorVersion 	= 0;
	var mAlgoMode		= 0;
	
	this.Define = { NONE:0
	  , ENCRYPTED_DATA		 		: 0 
	  , ENCRYPTED_SIGNED_DATA		: 1
	  , SIGNED_DATA			 		: 20
	  , SIGNED_CONTENT 				: 30
	  , ENVELOP_DATA 		 		: 21
	  , WAP_ENVELOP_DATA 			: 31
	  , ENVELOP_SIGN_DATA 			: 22
	  , ENVELOP_WAP_SIGN_DATA 		: 32
	  , LOGIN_ENVELOP_SIGN_DATA		: 23
	  , LOGIN_ENVELOP_WAP_SIGN_DATA	: 33
	}
	
	if (context != null && typeof(context) != "undefined" && typeof(context) == "object") {		
		gpkijs = context;
	}
	
	function GetStringToArrayBuffer(value) {
		var arrayBuffer = [];
		
		for (var i=0; i<value.length; i++) {
			arrayBuffer[i] = value.charCodeAt(i);
		}
		
		return arrayBuffer;
	}
	
	function GetArrayBufferToString(value) {
		var result;
		
		result = String.fromCharCode.apply(null, value);
		
		return result;
	}
	
	function GetIntegerToArrayBuffer(value, size) {
		var arrayBuffer = [];
		var idx = size;
		var result;
		
		do {
			arrayBuffer[--idx] = value & (255);
			value = value >> 8;
		} while (idx);
		
		return arrayBuffer;
	}
	
	function GetArrayBufferToInteger(value) {
		var result = 0;
	    
		for (var i=0; i<value.length; ++i) {        
			result += value[i];        
	        if (i<value.length-1) {
	        	result = result << 8;
	        }
	    }
	    
		return result;
	}
	
    function MakeKeyBlock(sAlgo, sMasterSecret, sClientMsg, callback) {
    	var oResult = 0;
    	var KeyBlock = new Array(4);
    	var MasterSecret;
    	var ClientMsg;
		var TempData = [];
		var HashData;
		var TotalKeyBlock = [];
		
		try {
			if (sAlgo == null || typeof(sAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sAlgo)"};
			}
			if (sMasterSecret == null || typeof(sMasterSecret) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sMasterSecret)"};
			}
			if (sClientMsg == null || typeof(sClientMsg) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sClientMsg)"};
			}
			
			KeyBlock[0] = GetStringToArrayBuffer("A");
	    	KeyBlock[1] = GetStringToArrayBuffer("BB");
	    	KeyBlock[2] = GetStringToArrayBuffer("CCC");
	    	KeyBlock[3] = GetStringToArrayBuffer("DDDD");
	    	
	    	MasterSecret = GetStringToArrayBuffer(sMasterSecret);
	    	ClientMsg = GetStringToArrayBuffer(sClientMsg);
	    	
	    	for (var i=0; i<KeyBlock.length; i++) {
	    		// SHA1("A" + master_secret + Cleint_Message)
	    		TempData[0] = KeyBlock[i].concat(MasterSecret).concat(ClientMsg);
	    		TempData[1] = GetArrayBufferToString(TempData[0]);
	    		HashData = mGpkiJSCrypto.JS_CRYPT_Hash(mGpkiJSCrypto.Define.HASH_ALG_SHA1, TempData[1]);
	    		
	    		// MD5(master_secret + SHA1(..) )
	    		TempData[0] = GetStringToArrayBuffer(HashData.message.data);
	    		TempData[1] = MasterSecret.concat(TempData[0]);
	    		TempData[0] = GetArrayBufferToString(TempData[1]);	    		
	    		HashData = mGpkiJSCrypto.JS_CRYPT_Hash(sAlgo, TempData[0]);
	    		
	    		// SHA256
	    		TempData[0] = HashData.message.data;	    		
	    		HashData = mGpkiJSCrypto.JS_CRYPT_Hash(mGpkiJSCrypto.Define.HASH_ALG_SHA256, TempData[0]);
	    		TempData[1] = GetStringToArrayBuffer(HashData.message.data);
	    		
	    		TotalKeyBlock = TotalKeyBlock.concat(TempData[1]);	    		
	    	}
	    	
	    	TempData = null;
	    	KeyBlock = GetArrayBufferToString(TotalKeyBlock);
	    	
			oResult = {code:0, message:KeyBlock};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
    	
    }
	
	GenInterface.prototype.SetJSCrypto = function(object) {
		if (object != null && typeof(object) != "undefined" && typeof(object) == "object") {		
			mGpkiJSCrypto = object;
		}
	}
	
	GenInterface.prototype.StringToArrayBuffer = function(value) {
		return GetStringToArrayBuffer(value);
	}
	
	GenInterface.prototype.ArrayBufferToString = function(value) {
		return GetArrayBufferToString(value);
	}
	
	GenInterface.prototype.IntegerToArrayBuffer = function(value, size) {
		return GetIntegerToArrayBuffer(value, size);
	}
	
	GenInterface.prototype.MakeKDF = function(data, key, iv, hashAlgo, callback) {
		var oResult = 0;
		
		try {
			if (data == null || typeof(data) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(data)"};
			}
			if (key == null || typeof(key) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(key)"};
			}
			if (iv == null || typeof(iv) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(iv)"};
			}
			if (hashAlgo == null || typeof(hashAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(hashAlgo)"};
			}
			
			// 수정
			var oDigest = mGpkiJSCrypto.JS_CRYPT_Hash(mGpkiJSCrypto.Define.HASH_ALG_SHA256, data);
			
			if (oDigest.code != 0) {
				throw oDigest;
			}
			
			var KeyArray   	  = GetStringToArrayBuffer(key);
			var IvArray  	  = GetStringToArrayBuffer(iv);
			var MasterSecret  = KeyArray.concat(IvArray);
			var ClientMsg	  = oDigest.message.data;
			var MasterSecretS = GetArrayBufferToString(MasterSecret);
			var	KeyBlock	  = MakeKeyBlock(hashAlgo, MasterSecretS, ClientMsg);
			
			if (KeyBlock.code != 0) {
				throw KeyBlock;
			}
			
			oResult = {code:0, message:KeyBlock.message};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GenInterface.prototype.GetSessionKey = function(sSiteID, sAlgo, sKeyBlock, callback) {
		var oResult = 0;

		try {
			if (sAlgo == null || typeof(sAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sAlgo)"};
			}
			
			if ((sAlgo === mGpkiJSCrypto.Define.SYM_ALG_3DES_CBC)) {
				throw {code:1004, message:"Not Support Algorithm " + sAlgo};
			}
			
			var KeyBlock	= GetStringToArrayBuffer(sKeyBlock);
			var ClientKey	= KeyBlock.slice(0,  16);
			var ClientIv	= KeyBlock.slice(16, 32);
			var ServerKey	= KeyBlock.slice(32, 48);
			var ServerIv	= KeyBlock.slice(48, 64);
			var SessionInfo = new Object();
			
			SessionInfo.SiteID	  = sSiteID;
			SessionInfo.SessionID = sSiteID;
			SessionInfo.ClientKey = ClientKey;
			SessionInfo.ClientIv  = ClientIv;
			SessionInfo.ServerKey = ServerKey;
			SessionInfo.ServerIv  = ServerIv;
			
			oResult = {code:0, message:SessionInfo};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GenInterface.prototype.MakeKeyIV = function(sSiteID, symmetricAlgo, hashAlgo, data, callback) {
		var oResult = 0;

		try {
			if (sSiteID == null || typeof(sSiteID) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(sSiteID)"};
			}
			if (symmetricAlgo == null || typeof(symmetricAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(symmetricAlgo)"};
			}
			if (hashAlgo == null || typeof(hashAlgo) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(hashAlgo)"};
			}
			if (data == null || typeof(data) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(data)"};
			}
			
			var oContentInfo = mGpkiJSCrypto.JS_CRYPT_GetKeyAndIV();
			
			if (oContentInfo.code != 0) {
				throw oContentInfo;
			}
			
			var kkey = oContentInfo.message.key.data;
			var iiv = oContentInfo.message.iv.data;
			
			var KeyBlock = this.MakeKDF(data, kkey, iiv, hashAlgo);
			
			if (KeyBlock.code != 0) {
				throw KeyBlock;
			}
			
			var oSessionInfo = this.GetSessionKey(sSiteID, symmetricAlgo, KeyBlock.message);

			if (oSessionInfo.code != 0) {
				throw oSessionInfo;
			}
			
			oResult = {code:0, message:oSessionInfo.message};				
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	/////////////////////////////////////////////////////////////////////////////////////
	GenInterface.prototype.MakeSignContentInfo = function(oSignData, oRandom, callback) {
		var oResult = 0;
		
		try {
			if (oSignData == null || typeof(oSignData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(oSignData)"};
			}
			if (oRandom == null || typeof(oRandom) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(oRandom)"};
			}
			
			var RandomL     = GetIntegerToArrayBuffer(oRandom.length, 2);
			var RandomV     = GetStringToArrayBuffer(oRandom);
			var SignDataL   = GetIntegerToArrayBuffer(oSignData.length, 4);
			var SignDataV   = GetStringToArrayBuffer(oSignData);			
			var ContentInfo = RandomL.concat(RandomV).concat(SignDataL).concat(SignDataV);			
			var ContentInfoS = GetArrayBufferToString(ContentInfo);
			
			oResult = {code:0, message:ContentInfoS};
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GenInterface.prototype.ParseContentInfo = function(oData, callback) {
		var oResult = 0;
		
		try {
			if (oData == null || typeof(oData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(oData)"};
			}

			var RemoveTagInfo = oData.replace("<gpki:ENCRYPTED DATA>","").replace("</gpki:ENCRYPTED DATA>","");
			var ContentInfo   = mGpkiJSCrypto.JS_BASE64_Decode(RemoveTagInfo);
			
			if (ContentInfo.code != 0) {
				throw ContentInfo;
			}
			
			ContentInfo = GetStringToArrayBuffer(ContentInfo.message);
			
			var MajorVersion  = ContentInfo[0];
			var MinorVersion  = ContentInfo[1];
			var ContentType   = ContentInfo[2];
			var ContentLength = GetArrayBufferToInteger(ContentInfo.slice(3, 7));			
			var ContentData   = ContentInfo.slice(7, 7+ContentLength);
			var ContentInfoS  = new Object();
			
			ContentInfoS.ContentType   = ContentType;
			ContentInfoS.ContentLength = ContentLength;
			ContentInfoS.ContentData   = GetArrayBufferToString(ContentData);
			
			oResult = {code:0, message:ContentInfoS};
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GenInterface.prototype.MakeContent = function(contentType, oData, callback) {
		var oResult = 0;
		
		try {
			if (contentType == null || typeof(contentType) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(contentType)"};
			}
			if (oData == null || typeof(oData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(oData)"};
			}
			
			var ContentType = GetIntegerToArrayBuffer(contentType,  1);
			var DataLengthL = GetIntegerToArrayBuffer(oData.length, 4);
			var DataLengthV = GetStringToArrayBuffer(oData);
			var Content 	= ContentType.concat(DataLengthL).concat(DataLengthV);			
			var ContentS 	= GetArrayBufferToString(Content);
			
			oResult = {code:0, message:ContentS};
			
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GenInterface.prototype.MakeBaseContentInfo = function(contentType, oData, callback) {
		var oResult = 0;
		
		try {
			if (contentType == null || typeof(contentType) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(contentType)"};
			}
			if (oData == null || typeof(oData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(oData)"};
			}
			
			var HeaderMajor	= GetIntegerToArrayBuffer(mMajorVersion, 1);
			var HeaderMinor	= GetIntegerToArrayBuffer(mMinorVersion, 1);
			var Content 	 = this.MakeContent(contentType, oData);
			var ContentV 	 = GetStringToArrayBuffer(Content.message);
			var ContentInfo	 = HeaderMajor.concat(HeaderMinor).concat(ContentV);			
			var ContentInfoS = GetArrayBufferToString(ContentInfo);

			oResult = {code:0, message:ContentInfoS};
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
	
	GenInterface.prototype.MakeContentInfo = function(contentType, oData, callback) {
		var oResult = 0;
		
		try {
			if (contentType == null || typeof(contentType) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(contentType)"};
			}
			if (oData == null || typeof(oData) == "undefined") {
				throw {code:1004, message:"The input is invalid type.(oData)"};
			}
			
			var BaseContentInfo = this.MakeBaseContentInfo(contentType, oData);
			var ContentSTag		= "<gpki:ENCRYPTED DATA>"; 
			var ContentData		= gpkijs.base64.encode(BaseContentInfo.message);
			var ContentETag		= "</gpki:ENCRYPTED DATA>";
			var message			= ContentSTag.concat(ContentData).concat(ContentETag);
			
			oResult = {code:0, message:message};
		} catch (ex) {
			oResult = ex;			
		}
		
		if (typeof(callback) == "function") {
			callback(oResult);
		}
		
		return oResult;
	}
}