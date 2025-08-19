var _GPKIApiCertJS = (function(context) {
	var targetOrigin = ConfigObject.targetOrigin;
	var targetSrc    = ConfigObject.targetOrigin + ConfigObject.targetSrc;
	
	_GPKIApiCertJS.addEventListener = function(message, callback) {
		if (window.addEventListener) {
	  		window.addEventListener("message", callback, false);
	  	} else if(window.attachEvent) {
	  		window.attachEvent("onmessage", callback );
	  	}
		
		var iframeWindow = document.getElementById('GPKIcert').contentWindow;		
		iframeWindow.postMessage(message, targetOrigin);
	}
	
	_GPKIApiCertJS.removeEventListener = function(callback) {
		if (window.addEventListener) {
	  		window.removeEventListener("message", callback, false);
	  	} else if(window.attachEvent) {
	  		window.detachEvent("onmessage", callback );
	  	}
	}
	
	_GPKIApiCertJS.prototype.init = function(callback) {
		var body   = document.getElementsByTagName('body')[0];
		var div    = document.createElement('div');
		var iframe = document.createElement('iframe');

		iframe.setAttribute("id",          "GPKIcert");
		iframe.setAttribute("name",        "GPKIcert");
		iframe.setAttribute("src",         targetSrc);
		iframe.setAttribute("scrolling",   "no");
		iframe.setAttribute("width",       "100%");
		iframe.setAttribute("height",      "100%");
		iframe.setAttribute("frameBorder", "2");
		iframe.setAttribute("translate",   "yes");
		iframe.setAttribute("style",       "position:fixed; z-index:100010; top:0px; left:0px; width:100%; height:100%;");
		iframe.onload = iniComplete;
		
		div.id    = "GPKIcertContainer";
		div.style.display = "none";
		div.appendChild(iframe);
		
		body.appendChild(div);

		function iniComplete() {
			var request = new Object();
			
			request.protocol = "init";
	
			_GPKIApiCertJS.addEventListener(request, function(event){
				_GPKIApiCertJS.removeEventListener(arguments.callee);				
				
				if (typeof(callback) == "function" && typeof(event.data)) {
					callback(event.data);
				}
			});
		}
		
		return 0;
	}
	
	_GPKIApiCertJS.prototype.SaveCert = function(certbag, password, callback) {				
		var request = new Object();
		
		request.protocol  = "SaveCert";
		request.certbag   = certbag;
		request.password  = password;
		
		_GPKIApiCertJS.addEventListener(request, function(event){			
			_GPKIApiCertJS.removeEventListener(arguments.callee);
			
			if (typeof(callback) == "function" && typeof(event.data)) {
				callback(event.data);
			}
		});
	}
	
	_GPKIApiCertJS.prototype.GetCertList = function(callback) {				
		var request = new Object();
		
		request.protocol = "GetCertList";
		
		_GPKIApiCertJS.addEventListener(request, function(event){			
			_GPKIApiCertJS.removeEventListener(arguments.callee);
			
			if (typeof(callback) == "function" && typeof(event.data)) {
				callback(event.data);
			}
		});
	}
	
	_GPKIApiCertJS.prototype.DeleteCert = function(storageCertIdx, callback) {				
		var request = new Object();
		
		request.protocol = "DeleteCert";
		request.storageCertIdx = storageCertIdx;
		
		_GPKIApiCertJS.addEventListener(request, function(event){			
			_GPKIApiCertJS.removeEventListener(arguments.callee);
			
			if (typeof(callback) == "function" && typeof(event.data)) {
				callback(event.data);
			}
		});
	}
});

if(ConfigObject.isUseDomainStorage){
	if (!window.GPKICERTJS) {
		var _GPKICERTJS = new _GPKIApiCertJS();
		window.GPKICERTJS = _GPKICERTJS;
	} else {
		delete window.GPKICERTJS;
		window.GPKICERTJS = new _GPKIApiCertJS();
	}	
}