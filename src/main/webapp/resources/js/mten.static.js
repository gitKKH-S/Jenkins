var CONTEXTPATH = window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
if(CONTEXTPATH!='/kcousult'){
	CONTEXTPATH = ""
}
var URLINFO = window.location.protocol+"//"+window.location.host+CONTEXTPATH;

