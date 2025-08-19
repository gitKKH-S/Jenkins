var agent = navigator.userAgent.toLowerCase();
var isChrome = agent.indexOf("chrome") != -1?true:false,
  isOpera = (!!window.opr && !!opr.addons) || !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0,
  isFirefox =  agent.indexOf("firefox") != -1?true:false,
  isSafari = agent.indexOf("safari") != -1?true:false,
  isIE = /*@cc_on!@*/false || !!document.documentMode,
  isEdge = !isIE && !!window.StyleMedia,
  isBlink = (isChrome || isOpera) && !!window.CSS;

function startExe(xml){
	if(xml){
		var dummyscript = document.createElement('iframe');
		dummyscript.setAttribute("id","lkrms");
		dummyscript.setAttribute("style","display:none");
		document.body.appendChild(dummyscript);
		document.getElementById("lkrms").setAttribute('src', "lkrms5::/"+xml);
		
		// 2초 후 iframe remove
		var removeSec = setTimeout(function(){
			var doc = document.getElementById("lkrms");
			document.body.removeChild(doc);
		}, 2000)
	}
}

function chkSetUp(xml){
	if(isChrome){
		startExe(xml);
	}
	
	if(isIE || isEdge){
		startExe(xml);
		
		//try{
		//	var fso = new ActiveXObject("Scripting.FileSystemObject");
		//	var fn = "C:/mten/exe/LawXml.exe";
		//	console.log("state : " + fso.FileExists(fn));
		//	if(!fso.FileExists(fn)){
		//		alert("원할한 규정관리시스템 이용을 위하여 mtenViewer.exe를 설치 하시기 바랍니다.");
		//		window.open(CONTEXTPATH+"/resources/edit/mtenViewer.exe");
		//	}else{
		//		startExe(xml);
		//	}
		//}catch(e){
		//	alert("원할한 시스템 이용을 위하여 mtenViewer.exe를 설치 하시기 바랍니다.");
		//	window.open(CONTEXTPATH+"/resources/edit/mtenViewer.exe");
		//}
	}
	
	if(isFirefox){
		var dummyscript = document.createElement('script');
		dummyscript.onerror = function() {
			if (dummyscript.onerror){
				alert("원할한 규정관리시스템 이용을 위하여 mtenViewer.exe를 설치 하시기 바랍니다.");
				window.open(CONTEXTPATH+"/resources/edit/mtenViewer.exe");
			}
		}
		
		dummyscript.onload = function() {
			startExe(xml);
		}
		dummyscript.src = "file:///C:/mten/exe/ver_210105.txt";
		//dummyscript.src = "file:///C:/mten/exe/ver_200624.txt";
		//document.body.appendChild(dummyscript);
		var body = document.getElementById("body");
		body.appendChild(dummyscript);
		var removeSec = setTimeout(function(){
			body.removeChild(dummyscript);
		}, 2000);
	}
	
}

