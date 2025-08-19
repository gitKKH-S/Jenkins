var ML_Default_Set = {
	protocolType				: location.protocol.indexOf(":")<=-1?location.protocol+=":":location.protocol, // "http:" 또는 "https:"
	// 로컬
	cpUrl						: location.port != ""?location.hostname+":"+location.port:location.hostname,
	mlMainUrl					: location.port != ""?location.hostname+":"+location.port:location.hostname, //GPKISecure Web 기본 URL
	mlDirPath 					: "/gpkisecureweb/client/GPKIWeb/",

	mlCertUrl					: "mlcert.dreamsecurity.com", //MLCert 기본 URL(로컬스토리지 인증서 백업목적)
	cryptoType					: 1, //암호라이브러리 선택 (0=CS, 1=JS, 2=ETC...)
	cs_install_type				: "download", //설치페이지 사용여부 true/false/download (바로다운로드)
	smartcert_type				: "C" //C or JS
}

var ConfigObject = {
	//1. GPKISecure Web
	ProtocolType				: ML_Default_Set.protocolType,	//protocolType
	DirPath						: ML_Default_Set.mlDirPath,	//GPKI 디렉토리
	BaseURL						: ML_Default_Set.mlMainUrl,	//GPKI 기본 URL	
	MLCertURL					: ML_Default_Set.mlCertUrl,	//MLCert 기본 URL(로컬스토리지 인증서 백업목적)
	isUseMLCert					: false,	//로컬스토리지 인증서 백업 기능 사용 여부
	STORAGELIST					: ["web","hdd","token","mobile","smartcert"],	//지원 스토리지 리스트 ( 순서대로 UI 그림, JSON)
	STORAGELISTMGMT				: ["web","hdd"],//지원 스토리지 리스트 (인증서 관리창)
	saveStorageList				: ["web","hdd"],//인증서 저장기능 지원 가능 스토리지 리스트
	STORAGESELECT				: "hdd",	//인증서 선택창 초기화 할 때, 기본 선택 스토리지
	CRYPTO						: ML_Default_Set.cryptoType,	//암호라이브러리 선택 (0=CS, 1=JS, 2=ETC...)
	banner						: true,	//인증서 선택창 배너 이미지 노출 여부
	adminBanner					: true,	//인증서 관리창 배너 이미지 노출 여부
	logType						: "console",	//"console", "alert" or no log
	ServiceID					: "GPKISecureWeb_HTML5",
	CsServiceID					: "GPKISecureWeb_HTML5",
	SessionID					: "",
	MessageID					: "",
	CsUrl 						: "https://127.0.0.1:12233",
	//CsUrl 						: "https://10.10.30.156:42235",
	PfxExportDownloadUrl		: ML_Default_Set.protocolType + "://" + ML_Default_Set.cpUrl + ML_Default_Set.mlDirPath + "install_bin/pfxexport/MagicPFXExport.exe",
	isUseDomainStorage			: false,	//공동 저장소 사용 여부 (gpkicert.js 와 매칭)
	isAvailableBrowser			: false, //DONT_TOUCH
	mlDirPath 					: ML_Default_Set.mlDirPath,
	embeddedHtml 				: "/gpkisecureweb/jsp/createSecureSession_1_3.jsp",
	
	//-- UI 
	passwordCountLimit			: 10, 	//TODO-비밀번호 오류 카운트. 횟 수  초과시 정책에 따라 조치. 
	SIGN_OPTION					: {ds_pki_sign:['OPT_USE_CONTNET_INFO'], ds_pki_rsa:'rsa15', ds_pki_hash:'sha256'}, // 서명 기본 옵션
	ENVELOP_OPTION				: {ds_pki_rsa:'rsa15'}, // Envelop 기본 옵션
	SIGNENVELOP_OPTION			: {ds_pki_sign:['OPT_USE_CONTNET_INFO'], ds_pki_rsa:'rsa15', ds_pki_algo:'SEED-CBC'}, // Sign&Envelop 기본 옵션
	ASYMENCRYPT_OPTION			: {ds_pki_rsa:'rsa15'},
	ASYMDECRYPT_OPTION			: {ds_pki_rsa:'rsa15'},
	LANGUAGE					: "ko", //언어팩 옵션
	USEVIRTUALKEYBOARD			: false, 	//가상키보드 사용 여부 true,false
	VIRTUALKEYBOARDTYPE			: "", 	//가상키보드 사용 여부 NSHC,RAON,INCA
	
	BROWSER_NOTICE_SHOW			: true, // 브라우저 저장소 클릭시 안내 이미지 출력 여부 true, false
	
	eOption						: false, //true or false
	kOption						: "",	// "", "dream"

	//Client version
	WinClientVersion 			: "1.1.2.8",
	//MacClientVersion 			: "1.0.0.13",
	//Lin64ClientVersion 			: "1.0.0.12",
	//Lin32ClientVersion 			: "1.0.0.12",
	
	MobileOption				: ["ubikey"], // ["ubikey", "dreamCS"]
		
	//2. CS 연동 관련
	CS_PORT						: "12233", // CS PORT("42235", "55533")
	CS_PORT_SELECT 				: "12233", // CS PORT 선택
	CS_UR						: "https://127.0.0.1:",
	//CS_UR						: "https://10.10.30.156:",
	CS_DOWNLOAD_WIN				: ML_Default_Set.protocolType + "//" + ML_Default_Set.mlMainUrl + "/gpkisecureweb/client/setup/GPKISecureWebSetup.exe",		//윈도우용 CS 설치 파일 주소
	CS_DOWNLOAD_MAC				: "",		//MAC용 CS 설치 파일 주소
	CS_DOWNLOAD_LINUX_FEDORA64	: "",	//LINUX(Fedora/openSUSE) 64bit CS 설치 파일 주소 
	CS_DOWNLOAD_LINUX_FEDORA32	: "",	//LINUX(Fedora/openSUSE) 32bit CS 설치 파일 주소 
	CS_DOWNLOAD_LINUX_UBUNTU64	: "",	//LINUX(Debian/Ubuntu) 64bit CS 설치 파일 주소
	CS_DOWNLOAD_LINUX_UBUNTU32	: "",	//LINUX(Debian/Ubuntu) 32bit CS 설치 파일 주소
	//CS_AUTHSERVER_URL			: "https://ml4web.dreamsecurity.com:8443/ML4-Web/ServerPage/jsp/",	//인증서버 URL
	CS_AUTHSERVER_URL			: location.protocol + '//' + location.host + ML_Default_Set.mlDirPath + "ServerPage/jsp/",	//인증서버 URL
	CS_AUTHSERVER_CERT			: "MIIEgjCCA+ugAwIBAgICB6AwDQYJKoZIhvcNAQEFBQAwRDELMAkGA1UEBhMCS1IxFjAUBgNVBAoTDURyZWFtU2VjdXJpdHkxDjAMBgNVBAsTBVdpcmVkMQ0wCwYDVQQDEwRST09UMB4XDTA0MDUxNzA2MDMwMloXDTA1MDUxNzA2MDMwMlowTjELMAkGA1UEBhMCS1IxFjAUBgNVBAoTDURyZWFtU2VjdXJpdHkxDjAMBgNVBAsTBVdpcmVkMRcwFQYDVQQDDA5BTllfMDAwMDAwMTM3NDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA8oiK9s24U15Zc27yPSXvruwlgsngL9+dGiALMSG0ug3U9yUdJ+NqgBfMTvu2LE2EgoVObbwEWfdMCE8xmjlWVJzQRQATtvlGHiKXvAIwSjZq/gBIKLdKYmHQxBJk9NNE1nhHE6u0dlvVulNpDqO8hPj0P0OplWxHFZtEBpkSsDECAwEAAaOCAncwggJzMGwGA1UdIwRlMGOAFIwdeyOqAicpnNHLlhqKYmCRRZpBoUikRjBEMQswCQYDVQQGEwJLUjEWMBQGA1UEChMNRHJlYW1TZWN1cml0eTEOMAwGA1UECxMFV2lyZWQxDTALBgNVBAMTBFJPT1SCAQMwHQYDVR0OBBYEFL+l1vv7eUOivC/pmfP4xbZtjJW3MA4GA1UdDwEB/wQEAwIAMDB7BgNVHSAEdDByMHAGCiqDGoyaRAUCPAEwYjBgBggrBgEFBQcCAjBUMBQaDURyZWFtU2VjdXJpdHkwAwIBARo8VGhpcyBDZXJ0aWZpY2F0ZSBpcyBnZW5lcmF0ZWQgYnkgRHJlYW1zZWN1cml0eSBmb3IgQ0Fvc19YNTA5MCEGA1UdEQQaMBigFgYJKoMajJpECgEBoAkwBwwDQU5ZMAAwgecGA1UdHwSB3zCB3DBRoE+gTYZLbGRhcDovL2Nhb3MuZHJlYW1zZWN1cml0eS5jb206Mzg5L2NuPWNybDExZHAyLG91PVdpcmVkLG89RHJlYW1TZWN1cml0eSxjPUtSMIGGoIGDoIGAhn5odHRwOi8vY2Fvcy5kcmVhbXNlY3VyaXR5LmNvbS9jcmw/aWg9b0N4RlRlMWFtZGdoV3NrbnlGdmt2ZG4yRG9nJTNkJmRwPWNuJTNkY3JsMTFkcDIlMmNvdSUzZFdpcmVkJTJjbyUzZERyZWFtU2VjdXJpdHklMmNjJTNkS1IwSgYIKwYBBQUHAQEEPjA8MDoGCCsGAQUFBzABhi5odHRwOi8vY2Fvcy5kcmVhbXNlY3VyaXR5LmNvbToxNDIwMy9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBBQUAA4GBACYZfFj6/Ixe3VViMpURAyYX7zBnoUDbCputCTuETzWMEuAc7/ciMGrnGVXitbRmpFlRINWnvDbrwHGF88xCRM1MTzEbLaBcDIMMCvIerUSW2/ocwd/vY6RRN38RAvVuYyNogbphVPaHJv85ivmdT47F7WcvyTz2XCAOJY5QJnJ5",
	CS_TIMEOUT					: 60,	//CS Timeout 시간 / 분단위
	CS_URL_SCHEME				: "gpkisecurewebnp://",
	CS_INSTALL_TYPE				: ML_Default_Set.cs_install_type, //설치페이지 사용여부 true/false/download (바로다운로드)
	CS_INSTALL_PAGE_URL			: ML_Default_Set.protocolType + "://" + ML_Default_Set.cpUrl + ML_Default_Set.mlDirPath + "install_page/gpkisecureweb_Install.html",

	//4. 인증서 필터
	CERT_BASE_URL				: "",          // JSON 인증서 저장 경로 (브라우저 인증서)
	CERT_BASE_DIR				: "",          // 인증서 억세스 기본 DIR - (JSON형태, CS HDD 일때만 허용)
	CERT_FILTER_TYPE			: 15,          // '1':GPKI, '2':NPKI, '4':MPKI, '8:'PPKI(사설인증서)
	CERT_FILTER_USE_TYPE		: "",          // '1':서명용,암호화용, '2':서명용+암호화용 모두 있는경우만
	CERT_OID_NAME				: "",          // OID , OID 이름 (JSON) ex)1.2.410.200005.1.1.4
	CERT_ISSUER_NAME			: "",          // 인증서 발급사 매칭 (JSON) ex)signGATE CA2
	
	//unused path
	CERT_FILTER_PATH			: [ ], // 기본 [], [ "Program Files" ] : Program Files 경로 제외, [ "GPKI" ] : GPKI 경로 제외, [ "Users" ] : Users 경로 제외

	//5. 스마트인증CS 옵션   
	SMARTCERT_TYPE				: ML_Default_Set.smartcert_type,	//C or JS
	CS_SMARTCERT_ServerIP		: "center.smartcert.kr",      // 중계서버 IP
	CS_SMARTCERT_ServerPort		: "443",                      // 중계서버 Port
	CS_SMARTCERT_SiteDomain		: "www.dreamsecurity.com",    // 도메인정보
	CS_SMARTCERT_InstallURL		: "http://ids.smartcert.kr",
	CS_SMARTCERT_SIZE			: "width=500, height=380",
	CS_SMARTCERT_Filter_Expired	: "1",
	CS_SMARTCERT_Filter_OID		: "NONE",
	CS_SMARTCERT_Filter_CA		: "NONE",
	CS_SMARTCERT_Filter_User	: "NONE",
	CS_SMARTCERT_HideTokenList	: false,       // 보안토큰 목록에서 스마트인증 숨기기
	CS_SMARTCERT_SignOrgView	: false,       // false:서명원문보여주지않기, true:서명원문보여주기
	CS_SMARTCERT_RaonSiteCode	: 609100014,                       // 라온사이트코드
	
	// 스마트인증NX 옵션
	WEB_SMARTCERT_MultisignYn		: 'N',
	WEB_SMARTCERT_Subject			: '',
	WEB_SMARTCERT_Issuer			: '',
	WEB_SMARTCERT_Serial			: '',
	WEB_SMARTCERT_Validate			: true,
	WEB_SMARTCERT_URL				: "", // "https://cdn.smartcert.kr/SmartCertWeb/API/js/jSmartCertNP2.js"
	
	//20200324 token filter
	TOKEN_FILTER					: [ "SmartSign" ],
	TOKEN_DOWNLOAD_URL			: "http://rootca.kisa.or.kr/kor/hsm/hsm.jsp", //210806 추가
	
	//6. UBIKEY 옵션
	CS_PHONE_TYPE				: "", // 휴대폰 종류
	CS_UBIKEY_Version			: "-1", // 휴대폰 인증서 저장서비스 버전
	CS_UBIKEY_PopupURL			: "http://www.ubikey.co.kr/infovine/download.html", // UBIKEY 다운로드 주소
	CS_UBIKEY_wParam			: "INFOVINE", // UBIKEY 설정 값
	CS_UBIKEY_lParam			: "DREAMSECURITY|KINGS_INFOVINE", // UBIKEY 설정 값
	CS_UBIKEY_URL				: "", // /UBikeyWeb/js/infovineHTML.js
	
	//7. 스마트카드
	CS_SMARTCARD_TYPE			: "",   //'1':금융카드, '2':공무원카드T0, '3':공무원카드T1, '4':마거
	
	//8. 금결원 공동인증서비스 옵션
	KFTC_SCRIPT_URL_RELAY		: "https://fidoweb.yessign.or.kr:3100/v2/relay.js", //https://fidoweb.yessign.or.kr:3100/v2/relay.js
	KFTC_SCRIPT_URL_OPENCERT	: "https://fidoweb.yessign.or.kr:3100/v2/opencert.js", //https://fidoweb.yessign.or.kr:3100/v2/opencert.js
	KFTC_CORP_CODE				: "099", //ex) 099
	KFTC_APIKEY					: "zCwXuELy29jPsSBNxN4RKlJBQcHuvvliScZEUJD5lKFrIYmnpEwi2JdMq5x5QmPL",
	
	DS_PKI_CERT_PATH			: {"GPKI":[], "NPKI":['INIPASS'], "MPKI":[], "PPKI":[]},
	DS_PKI_POLICY_OID			: {	 "1.2.410.200004.5.5.1.1":"범용(개인)"
									,"1.2.410.200004.5.5.1.2":"범용(기업)"
									,"1.2.410.200004.5.5.1.3.1":"제휴기관용(개인)"
									,"1.2.410.200004.5.5.1.4.1":"제휴기관용(기업)" 
									,"1.2.410.200004.5.5.1.4.2":"전자세금용(기업)" },
									
	//gpkijs license
	GPKIJS_LIC					: "MIG3MGMCAQAEB0dQS0lBUEkECrytv+/Gr7qwvcMEI0dQS0lBUEktVEVNUE9SQVJZLTIwMjUwMzE3LTAwMDAxMDIxoyQwIhgPMjAyNTAzMTcwNzUwNDdaGA8yMDI1MDYxNzA3NTA0N1owDQYJKoZIhvcNAQEFBQADQQCK244x79cyfCFuP8OOf5uOHZ0RCctSPsAc0H7ac5ODIzyx1GbuI/Lszw3LrrWStLuShASJo/1gZkYtORO2Kr/Q",
	
    // 서버저장소 관련 도메인 설정
	IframeServer				: "",//서버저장소 이용을 위한 주소 설정
	IframeLogsave				: "",//서버저장소 이용을 위한 주소 설정(로그)

	// 공동저장소 관련 도메인 설정
	targetOrigin 				: "http://localhost:8080", //실 사용하는 공동저장소 주소로 변경 필요(공유 오피스 ip로 임시 변경)
	targetSrc    				: "/gpkisecureweb/certstr/gpkiapi.html", //실 사용하는 공동저장소 주소로 변경

	// 공동저장소 URL 설정
	StorageCertURL				: "/gpkisecureweb/client/gpkicert.js",

	// GPKI사용자용 표준보안API 인증서 팝업 페이지 URL 설정
	ChildURL					: "Child.html",
	// 	GPKI사용자용 표준보안API 인증서 임베디드 페이지 URL 설정
	ChildEmbeddedURL			: "Child_Embedded.html",
	
	// API.js 설정
	GPKIWEB_API_URL				: "js/GPKIWeb_Config.js",
	GPKIWEB_API_GPKIJS_URL		: 'js/crypto/gpkijs_1.2.1.5.min.js',
	GPKIWEB_API_PATH			: 'js/message/',
	GPKIWEB_API_ERROR_CODE		: "js/util/GPKIWeb_ErrorCode.js",
										
	
	result:"load"
}
