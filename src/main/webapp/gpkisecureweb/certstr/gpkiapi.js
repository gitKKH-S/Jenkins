var GPKIAPIController = {
	JS_Crypto : "",
		
	postMessage : function(message, targetOrigin) {
		try{
			window.parent.postMessage(message, targetOrigin);
		} catch(e){ console.log("GPKI API Error"); }
	},
	
	responseMessage : function(event) {
		console.log("[responseMessage] event.origin : " + event.origin);
		console.log("[responseMessage] event.data   : " + event.data);
		
		try{
			var returnObj = new Object();
			
			if (typeof(event.data) == "undefined" || typeof(event.data) != "object") {
				return;
			}
			
			returnObj.protocol = event.data.protocol;
			
			if (event.data.protocol == "init") {
				JS_Crypto = new JS_Crypto_API();
				JS_Crypto.init();
				Storage_API_web.setCrypto_api(JS_Crypto);
				
				returnObj.resultCode = 0;
			} else if (event.data.protocol == "SaveCert") {
				var saveCode = Storage_API_web.SaveCert(event.data.certbag, event.data.password);
				
				returnObj.resultCode = saveCode;
			}  else if (event.data.protocol == "DeleteCert") {
				var deleteCode = Storage_API_web.DeleteCert(event.data.storageCertIdx);
				
				returnObj.resultCode = deleteCode.errCode;
			} else if (event.data.protocol == "GetCertList") {
				var cert_list = Storage_API_web.GetCertList();
				
				returnObj.resultCode = 0;
				returnObj.result = cert_list.cert_list; 
			}
			
			GPKIAPIController.postMessage(returnObj, event.origin);		
		} catch(e){ console.log("GPKI API Error"); }
	}
}

if (window.addEventListener){
	window.addEventListener("message", GPKIAPIController.responseMessage, false);
} else if (window.attachEvent){
	window.attachEvent("onmessage", GPKIAPIController.responseMessage);
}

window.onload = function() {
	try {	
		gpkijs.init("QIzXQvZfuJEf1Y11am1DUSt9670RUOkRrVqXA+oSx1zCG3xdIP7i+2/AW5ZhjOMiPyNRMpB3k5e3V3dgXyLKdOXctfX3KVMzMr1j0og4EfzFEtvnkmIcYO+pPHqx6wHqqFt/adMorr2kWnYl2iRzUMA3APyIUjEgMEFY9jWDnzplispqoeX72673SROXcxfzYet0YYWVHnmYGfoafHLyApl6UopXGWuQDMxD3n9nEAh8YUxR9J83UQVlg6OhbbDCDKxpnpzv6AdZfz1xq/8tAcMvkogAzAtJrcnFKQZ9hOnLrzVHJd4AhDfHEkpPtTz7f0mIwfILw0DJMi74QZwOXw==");
	} catch (ex) { console.log("GPKI API Error"); }	
}