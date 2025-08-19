//=================================================================================================================
// 사이트 환경 정보 설정 영역
//=================================================================================================================

//-----------------------------------------------------------------------------------------------------------------
// 0. 운영 환경 정보
var aspxXSSvalidate = true;                        // <gpki:ENCRYPTED DATA></gpki:ENCRYPTED DATA> 태그를 xss 로 인식하는 환경에서는 true로 지정.

//-----------------------------------------------------------------------------------------------------------------
// 1. 기본 경로 설정 
var host           = location.host;
var ServerAddr     = host;
var serverLangExt  = "jsp";                         		// * 개발언어 확장자. html에 매칭되는 예제 서버스크립트 파일 이름을 만들 때,
                                                    		// 인증서창에서 가상키보드를 사용할 때 키교환페이지의 파일 이름을 만들 때 사용. jsp, php, asp, aspx
var gpkiScriptBase   = '/gpkisecureweb/client';     		// * 스크립트에서 사용하는 클라이언트 모듈의 기본 경로 (var.js의 경로)
var clientModulePath = gpkiScriptBase + '/setup';			// * 클라이언트 설치 파일의 게시 경로. (cab, exe, dmg, rpm, deb)
var ServiceStartPageURL = '/gpkisecureweb/index.html';		// * 설치완료후 이동할 페이지
var clientInstallPath = '/gpkisecureweb/install.html';  	// * 설치 페이지 경로 
var smartCertUse = true;									// * true : used   false : not used   저장매체 스마트인증 이용 여부
var mobileUse = false;										// * true : used   false : not used   저장매체 휴대폰 이용 여부
var storageCount = 6;										// * 사용할 스토리지의 개수  5(휴대전화 제외) or 6 
var tokenDriverSetupPage = 'http://rootca.kisa.or.kr/kor/hsm/hsm.jsp'; // 토큰 구동 프로그램 설치 경로 설정
var versionUse = true;										// * 인증서 선택창 하단에 버전 정보 표기 여부      true :표기, false :미표기 
var passwordCount = 1;								        // * 인증서 비밀번호 입력 오류 체크 횟수 // 0: 체크 안함, 1 이상 : 해당 횟수만큼 비밀번호 입력 오류 시 인증서 선택창 종료
var checkCount = 0;
var pwCountArr = null;
var submitUseDN = false;									// 비빌번호 입력 오류 시 사용자DN 서버로 전송
var userDN = "";                                            // 비밀번호 입력 오류 시 사용자DN 추출
//-----------------------------------------------------------------------------------------------------------------
// 2. 클라이언트 정보
var WorkDir        = 'GPKISecurewebNP';          // * 작업 디렉터리 (클라이언트 모듈이 설치될 PC의 폴더 이름)
var clientVersion     = '1.1.2.8';				// * 클라이언트 버전. 버전 정보는 ','로 자리 구분. ( 21.09.15 1.1.2.6_ver 클라이언트 변경  )
var CsUrl		   = 'https://127.0.0.1:'
var CsPort		   = '12233'
var Version		   = '1.2.0.0'
var setSessionTimeout = '60'
var isCookie 	   = 'true'
var session		   = '';
var ServiceID = "GPKISecureWeb";
var SiteID        = 'gpki';                // * SiteID : 세션정보를 관리하는 고유 ID. 사이트 별로 고유 이름을 설정
//-----------------------------------------------------------------------------------------------------------------
// 3. 암호화 처리 옵션

// 3-1. 서버인증서(Base64Encode)
var ServerCert     = 'MIIEzDCCA7SgAwIBAgIUAgzktw6XHXIsFxBLFqD0ha2hSNQwDQYJKoZIhvcNAQELBQAwUDELMAkGA1UEBhMCS1IxHDAaBgNVBAoME0dvdmVybm1lbnQgb2YgS29yZWExDTALBgNVBAsMBEdQS0kxFDASBgNVBAMMC0NBMTMxMTAwMDAxMB4XDTI1MDMxODA3NTE1N1oXDTI3MDYxODE0NTk1OVowXTELMAkGA1UEBhMCS1IxHDAaBgNVBAoME0dvdmVybm1lbnQgb2YgS29yZWExGDAWBgNVBAsMD0dyb3VwIG9mIFNlcnZlcjEWMBQGA1UEAwwNU1ZSNjExMzUxNjAwMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL8FXbxcpmqMAci82hgN0cSIEiUWZlSOxHdbjK5XPQmm3tj3Za0H6yfI1sOI7HKlPXCASi0frUD33p/+4m8hN0yYy46QQMAf+flHEcXd4RdhbJM0zHr7aetXAQCY84dRyxesw0LDjVoyyRFRHbQVLeGHwpY6bQ0UdvcyT5usEQ3WoLFmgVYxr6/WqrsO42IbfpKUlBikUkLuPzm0DhV5CGNG319at7AWpUeHPZbvZGC2qqQu3MZDbVv/jAKT7UTkJcphNfJzE9FO9ZKpLLzaQ3M+E1QX0ht8byMA7Ud4fI08/06kTL/EyKTozsmhbBWmmAh3SCG8+qIxRzrfGYDvbCECAwEAAaOCAY8wggGLMHkGA1UdIwRyMHCAFJKkeBexqi8Z2Cs/ubMrIxWD1Zc1oVSkUjBQMQswCQYDVQQGEwJLUjEcMBoGA1UECgwTR292ZXJubWVudCBvZiBLb3JlYTENMAsGA1UECwwER1BLSTEUMBIGA1UEAwwLR1BLSVJvb3RDQTGCAicSMB0GA1UdDgQWBBQq6uA2VSxP0LwAuvGWlADk85YvyDAOBgNVHQ8BAf8EBAMCBDAwFgYDVR0gBA8wDTALBgkqgxqGjSECAQIwgY4GA1UdHwSBhjCBgzCBgKB+oHyGemxkYXA6Ly9jZW4uZGlyLmdvLmtyOjM4OS9jbj1jcmwxcDFkcDE0Nixjbj1DQTEzMTEwMDAwMSxvdT1HUEtJLG89R292ZXJubWVudCBvZiBLb3JlYSxjPUtSP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q7YmluYXJ5MDYGCCsGAQUFBwEBBCowKDAmBggrBgEFBQcwAYYaaHR0cDovL2d2YS5ncGtpLmdvLmtyOjgwMDAwDQYJKoZIhvcNAQELBQADggEBADm0B2djq6PjlkFdDU/59UMXCOAdh89Dc1gi5IsA06HlZVT/vxAkXJ4A00oucYBzQWBbaKCfyu1PHGBjBtazPYgXbNriPNwOALsftxVPYce9dBcTz+jny5R/DoEEktzOcwLIQjKAzj1ICjMQRzwPBam6eIxF4/10LxtvS8stmh6V6LOw2phA3bPSWztEw9BNVY2djdiuBSL7YRF4LpxfjXvmXrSx0r0E4HCwWyuItkVhgh2sX8vkTLPwtJVd/kFo9qUeVAYi3E6hcjqmQU4VV08mQ1Kt2n4vjLO5H0kjcFDsfusKWrPyYbq93eDNmFV6kS94wksQw7+WBC9DIWL0wyw=';

// 3-2. 암호 알고리즘 지정
var AlgoMode       = 3;                         // * 대칭키 암호화 알고리즘 지정 (3:SEED, 5:ARIA. 그 외의 알고리즘은 사용 안함)
var HashAlg        = 4;                         // * 해쉬 알고리즘 지정 (4:SHA256. 그 외의 알고리즘은 사용 안함)


//-----------------------------------------------------------------------------------------------------------------
// 4. 인증서 저장 매체 선택 및 처리 옵션

// 4-1. 읽어들일 인증서의 종류 및 정책
var GNCertType     = 0x03;                      // * 인증서 도메인 설정 (GPKI:0x01, NPKI:0x02. 2개이상 사용시 '+'연산하여 사용)
var ValidCertInfo  = '';   						// * 특정인증서만 로딩 할 경우에 아래 예와 같이 정책코드를 나열한다.	마지막 문자열에 '|' 반드시 포함.
                                                //   var ValidCertInfo = '1 2 410 100001 2 2 1|1 2 410 100001 2 1 2|1 2 410 200005 1 1 5|';
var ReadCertType   = 0x01;                      // * 읽어들일 인증서의 종류. (서명용인증서 : 0x01, 암호키분배용 인증서 : 0x02)
// 4-2. 인증서 저장매체 지정
var smartCardOpt   = 0x00;                      // * 지원하는 스마트카드 종류. 2개 이상 지원할 경우 + 연산해서 설정. (none:0x00, T0:0x01, T1:0x02, 금융:0x04)
var CertOption     = 0x01;                      // * 전자서명 옵션. (0x00: 로그인에 사용한 인증서(세션에 있는 인증서)만 사용. 해당 인증서만 읽어들임,
                                                //   0x01: 읽어들일 인증서의 종류 및 정책에 부합하는 모든 인증서를 읽어 들여서 목록에 표시.)
var phoneOpt       = 0;                         // * 휴대폰인증서 저장매체 사용. (0: 사용하지 않음, 1: Ubikey)

// 4-3. Ubikey 모듈 설정 (phoneOpt=1 일 경우만 해당)
// * Ubikey 사용 시 (주)인포바인에 요청해서 사이트(기관)ID(UbikeyWParam) 및 모듈 게시 정보를 발급받아서 설정해야 한다.
var	UbikeyVersion     = '1044';                 // * Ubikey 모듈 버전
var UbikeyPopupURL    = 'http://download.hometax.go.kr.krweb.nefficient.com/hts1/infovine/download.html';
                                                // * Ubikey 모듈의 게시 위치
var	UbikeyWParam      = 'NOSITE';              // * Ubikey를 사용하는 사이트(기관)ID
var UbikeyCompany     = 'NOCOMPANY';        // * Ubikey 모듈을 사용하는 인증서 사용자 인터페이스의 제작사
var UbikeyKeyboardSec = 'NOKEYBOARD';            // * Ubikey UI에 적용될 키보드보안 모듈의 종류

// 4-4. 입력 보안 (인증서 비밀번호 입력란에 적용할 보안)
var keysecOpt         = 0;                    // * (0: 사용하지 않음, 1: 가상키보드 사용, 2:키보드보안)
var keyboardSecOpt	  = 0; 					   // *키보드보안 제품 설정  0:NONE, 1:SOFTCAMP, 2:INCA , 3:AHNLAB , 4:SOFTFORUM, 5:SPACEIN 
// 4-5. 기타 옵션
var langOpt       = 1;                          // * 인증서 사용자 인터페이스에 적용된 언어. (1:한글)
var secureApiOpt  = 1;                          // * 기반 PKI 라이브러리 종류 (1: GPKI표준보안API)
var serverCharEnc = 2;                          // * server character encoding (0: System Default, 1: KSC-5601/MS949 (EUC-KR), 2: UTF8)
var LogoURL		  = "/image/certificate/GPKI_Logo.bmp";

//INIPASS
var DS_PKI_CERT_PATH 	= {"GPKI":[], "NPKI":['INIPASS'], "MPKI":[], "PPKI":[]};
var DS_PKI_POLICY_OID	= { "1.2.410.200004.5.5.1.1":"범용(개인)"
											,"1.2.410.200004.5.5.1.2":"범용(기업)"
											,"1.2.410.200004.5.5.1.3.1":"제휴기관용(개인)"
											,"1.2.410.200004.5.5.1.4.1":"제휴기관용(기업)" 
											,"1.2.410.200004.5.5.1.4.2":"전자세금용(기업)" };

//=================================================================================================================
// 설정이 필요없는 영역
//=================================================================================================================
var gpSessionId   = '';
var embededWin;

var clientCharEnc = 2;                          // * client character encoding on Windows (0: System Default, 1: KSC-5601/MS949 (EUC-KR), 2: UTF8)

var SetupOffLineFilePath   = '';
var CLASSID                = '';
var CodeBase_GPKIInstaller = '';
var Object_GPKIInstaller   = '';

var PLATFORM_UNKNOWN      = 0x0000;
var PLATFORM_WIN_X64      = 0x0001;
var PLATFORM_WIN_X86      = 0x0002;
var PLATFORM_MAC          = 0x0004;
var PLATFORM_LINUX_FEDORA = 0x0008;
var PLATFORM_LINUX_UBUNTU = 0x000F;

var BROWSER_UNKNOWN = 0x0000;
var BROWSER_IE      = 0x0100;
var BROWSER_CHROME  = 0x0200;
var BROWSER_FIREFOX = 0x0400;
var BROWSER_SAFARI  = 0x0800;
var BROWSER_OPERA   = 0x0F00;


var browserType = getBrowserType();
var browserPlatform = getBrowserPlatform();

//
// Determine OS Version from a Script
function getBrowserType()
{
	var browserType = BROWSER_UNKNOWN;
	if ((navigator.userAgent.toLowerCase().indexOf('msie') > -1) || (navigator.userAgent.toLowerCase().indexOf('trident') > -1)){
		browserType = BROWSER_IE;
	}     // originally MSIE, Trident
	else if (window.navigator.vendor.toLowerCase().indexOf('google') > -1){
		browserType = BROWSER_CHROME;
	}                                                           // originally Chrome, Google Inc.
	else if (navigator.userAgent.toLowerCase().indexOf('firefox') > -1){
		browserType = BROWSER_FIREFOX;
	}                                                              // originally Chrome
	else if (window.navigator.vendor.toLowerCase().indexOf('apple') > -1){
		browserType = BROWSER_SAFARI;
	}                                                            // originally Apple Computer, Inc.
	else if (window.navigator.vendor.toLowerCase().indexOf('opera') > -1){
		browserType = BROWSER_OPERA;
	}                                                            // originally Opera Software ASA.
	else{
		browserType = BROWSER_UNKNOWN;
	}
	
	//BrowserType = browserType;
	return browserType;
}

function getBrowserPlatform()
{
	var browerPlatform = PLATFORM_UNKNOWN;
	
	if (window.navigator.platform.toLowerCase() == 'win64'.toLowerCase())    // originally Win64
		browerPlatform = PLATFORM_WIN_X64;
	if (window.navigator.platform.toLowerCase() == 'win32'.toLowerCase())    // originally Win32
		browerPlatform = PLATFORM_WIN_X86;
	if (window.navigator.platform.toLowerCase().indexOf('mac') > -1)	     // originally Mac
		browerPlatform = PLATFORM_MAC;
	if (window.navigator.platform.toLowerCase() == 'linux'.toLowerCase()) {  // originally Linux
		if (navigator.userAgent.indexOf('Fedora') > - 1)
			browerPlatform = PLATFORM_LINUX_FEDORA;
		else
			browerPlatform = PLATFORM_LINUX_UBUNTU;
	}
	
	return browerPlatform;
}

function needInstall()
{
	var installedVersion;
	var deployVersion;

	try{
		installedVersion = canonicalizeInstalledVersion(GPKISecureWeb.GetAPIVersion());
	} catch(err) {
		return true;
	}
	
	deployVersion = getDeployVersion();

	if (installedVersion < deployVersion){
		return true;
	}
	else{
		return false;
	}
}

function canonicalizeInstalledVersion(version)
{
	if (version == null)
		throw 'unknown version.';

	version = version.toString();

	if (version.indexOf(',') > 0 || version.indexOf('.') > 0) // , or . index cannot be 0
		return version;

	// 수정 전 (1,0,0,10 또는 그 이전) GetVersion() API의 버전 정보.
	var sep;
	if (browserType == BROWSER_IE) {
		sep = ',';
	} else {
		sep = '.';
	}

	version = version.charAt(0) + sep + version.charAt(1) + sep + version.charAt(2) + sep + version.charAt(3) + (version.length == 5 ? version.charAt(4) : '');
	return version;
}

function getDeployVersion()
{
	var version;
	if (browserType == BROWSER_IE) {
		version = clientVersion;
	} else {
		if (browserPlatform == PLATFORM_MAC) {
			version = verOSX;
		} else if (browserPlatform == PLATFORM_LINUX_FEDORA) {
			version = verLinuxFedora;
		} else if (browserPlatform == PLATFORM_LINUX_UBUNTU) {
			version = verLinuxUbuntu;
		} else { // for Non-IE browser on Windows.
			version = clientVersion;
		}
	}
	return version;
}

function canonicalizeVersion(version)
{
	return version.replace(/[.,]/gi, '');	// version 문자열에 포함된 '.', ',' 를 공백으로 대체.
}

if (browserType == BROWSER_IE) {
	if (browserPlatform == PLATFORM_WIN_X64) {
		SetupOffLineFilePath   = clientModulePath + '/GPKISecureWebXPlugin64.exe';
		CLASSID                = 'CLSID:6EDB7AB0-FFB4-4BFA-B9FC-2FFAA89122DD';
		CodeBase_GPKIInstaller = 'CODEBASE= "http://' + ServerAddr + clientModulePath + '/GPKISecureWebXPlugin64.cab#version=' + clientVersion + '"';
	} else if (browserPlatform == PLATFORM_WIN_X86) {
		SetupOffLineFilePath   = clientModulePath + '/GPKISecureWebXPlugin.exe';
		CLASSID                = 'CLSID:4C0CDE5E-071B-4BA9-98DC-5D410973FCB6';
		CodeBase_GPKIInstaller = 'CODEBASE= "http://' + ServerAddr + clientModulePath + '/GPKISecureWebXPlugin.cab#version=' + clientVersion + '"';
	}
	
	Object_GPKIInstaller =  '<OBJECT ID="GPKISecureWebX" CLASSID="' + CLASSID + '" WIDTH = 0 HEIGHT = 0 ';
	Object_GPKIInstaller += CodeBase_GPKIInstaller;
	Object_GPKIInstaller += "></OBJECT >";
} else {
	if (browserPlatform == PLATFORM_MAC) {
		SetupOffLineFilePath = clientModulePath + '/GPKISecureWebPlugin.pkg';
	} else if (browserPlatform == PLATFORM_LINUX_FEDORA) {
		SetupOffLineFilePath = clientModulePath + '/GPKISecureWebPlugin-' + verLinuxFedora + '-1.i386.rpm';
	} else if (browserPlatform == PLATFORM_LINUX_UBUNTU) {
		SetupOffLineFilePath = clientModulePath + '/GPKISecureWebPlugin-' + verLinuxUbuntu + '-1.i386.deb';
	} else {
		SetupOffLineFilePath = clientModulePath + '/GPKISecureWebXPlugin.exe'; // for Non-IE browser on Windows.
	}

	Object_GPKIInstaller = '<embed id="GPKISecureWebX" type="application/mozilla-npGPKISecureWebPlugin-scriptable-plugin" WIDTH = 0 HEIGHT = 0>';
}

document.write("<link rel='shortcut icon' href='" + gpkiScriptBase + "/image/install/favicon.ico'	type='image/x-icon' />");

