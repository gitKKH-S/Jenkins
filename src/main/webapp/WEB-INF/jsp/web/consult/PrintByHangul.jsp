<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@ page import="net.sf.json.JSONObject"%>  
<%
    String consultansid  = ServletRequestUtils.getStringParameter(request, "consultansid", "").trim();
    
	ConsultService consultService = ConsultServiceHelper.getConsultService(application);
    HashMap param = new HashMap();
    param.put("consultansid", consultansid.trim());
    JSONObject consultans = consultService.getConsultans(param);
	String story = consultans.get("SASILYOJI")==null?"":consultans.get("SASILYOJI").toString();
	String date = consultans.get("HOISINDT")==null?"":consultans.get("HOISINDT").toString();
	String sdept = consultans.get("DEPT")==null?"":consultans.get("DEPT").toString();
	
	if (date == null){
		java.util.Date d = new java.util.Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		date = df.format(d);
	}
	date = date.substring(0, 4)+". "+date.substring(4, 6)+". "+date.substring(6, 8);
	
	String fn = consultans.get("BUBMUSENGINNAME")==null?"":consultans.get("BUBMUSENGINNAME").toString();
	if(fn.equals("김광녕")){
		fn = "3";
	}else if(fn.equals("한상익")){
		fn = "2";
	}else if(fn.equals("한선우")){
		fn = "1";
	}else if(fn.equals("김경윤")||fn.equals("김준엽")||fn.equals("조중제")||fn.equals("조남진")||fn.equals("이재창")||fn.equals("간동호")
			||fn.equals("이동혁")||fn.equals("이상미")||fn.equals("류지연")){
		fn = "4";
	}
%>

<script src="${resourceUrl}/js/mten.static.js"></script>
<script language="JavaScript">

// 현재 이 예제 파일이 있는 곳을 지정해 준다.
var BasePath = "";  
var BaseDoc = "";
var d = new Date();

// 시작시 설정 사항
function OnStart()
{
	
	InitToolBarJS();
	var uinfo = URLINFO;
	BaseDoc = uinfo+"/dataFile/hwpstyle/consultReport<%=fn%>.hwp";
	if(!HwpControl.HwpCtrl.Open(BaseDoc,"HWP","forceopen:false")){
	  alert("Base Path가 잘못 지정된 것 같습니다. 소스에서 BasePath 를 수정하십시요"+BaseDoc);
	 }
	HwpControl.HwpCtrl.Open(BaseDoc,"HWP","forceopen:false");
	HwpControl.HwpCtrl.MovePos(2);          // 캐럿을 문서의 처음으로 이동시킨다.
	HwpControl.HwpCtrl.MovePos(27);         // 현재 캐럿의 위치를 화면에 보여준다.
	if (document.getElementById('date').value!=null && document.getElementById('date').value !=''){
		HwpControl.HwpCtrl.PutFieldText('date', document.getElementById('date').value);
	}
	if (document.getElementById('sdept').value!=null && document.getElementById('sdept').value !=''){
		HwpControl.HwpCtrl.PutFieldText('susin', document.getElementById('sdept').value);
	}
	if (document.getElementById('title').value!=null && document.getElementById('title').value !=''){
		HwpControl.HwpCtrl.PutFieldText('title', document.getElementById('title').value);
	}
	if (document.getElementById('story').value!=null && document.getElementById('story').value !=''){
		HwpControl.HwpCtrl.PutFieldText('story', document.getElementById('story').value);	
	}
	if (document.getElementById('opinion').value!=null && document.getElementById('opinion').value !=''){
		HwpControl.HwpCtrl.PutFieldText('opinion', document.getElementById('opinion').value);
	}
	if (document.getElementById('s1').value!=null && document.getElementById('s1').value !=''){
		HwpControl.HwpCtrl.PutFieldText('s1', document.getElementById('s1').value);
	}
	HwpControl.HwpCtrl.focus();

	
	
//	HwpControl.HwpCtrl.EditMode = 0;
	

}

function _GetBasePath()
{
	//BasePath를 구한다.
	var loc = unescape(document.location.href);
	var lowercase = loc.toLowerCase(loc);
	if (lowercase.indexOf("http://") == 0) // Internet
	{
		return loc.substr(0,loc.lastIndexOf("/") + 1);//BasePath 생성
	}
	else // local
	{
		var path;
		path = loc.replace(/.{2,}:\/{2,}/, ""); // file:/// 를 지워버린다.
		return path.substr(0,path.lastIndexOf("/") + 1);//BasePath 생성
	}
}

// Toolbar Setting...
function InitToolBarJS()
{
	HwpControl.HwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAs");
	HwpControl.HwpCtrl.SetToolBar(0, "FileSaveAs,FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste"
			+"Separator, ParaNumberBullet, MultiColumn, SpellingCheck, HwpDic, Separator, PictureInsertDialog, MacroPlay1");

	HwpControl.HwpCtrl.ShowToolBar(true);
}

function MakeVersionHmlFiles()
{
	/*********
	var VerIndex = 0;
	var VersionCnt = 0;
	var VerText = 0;
	var StrComboTag;
	
	var InfoSet = HwpControl.HwpCtrl.MakeVersionDiffAll(BasePath);		// 시스템의 임시폴더에 버전별 hml 파일을 만든다. 
	var TempPathArr = InfoSet.Item("TempFilePath");						  // 만들어진 Path Array를 가지고 온다.

	if (InfoSet.Count > 0)
	{ 
		StrComboTag = "<Select Name='VersionSelect'>";
		StrComboTag += "<Option value='" + BaseDoc + "'>원본문서";
	}
	
	for (VerIndex = 0; VerIndex < TempPathArr.Count-1; VerIndex++)
	{
				
		VerText = VerIndex+1;
		
		StrComboTag += "<Option value='" + TempPathArr.Item(VerIndex) + "'>버전" + VerText;			
	}
	
	StrComboTag += "</Select>";
	
	VersionCnt = HwpControl.HwpCtrl.GetVersionHistoryCount();
	
	StrComboTag += "&nbsp;<font color=#ffffff>(현재문서에는 " + VersionCnt + "개의 버전정보가 있습니다.)</font>";
	
	//document.getElementById("VersionCombo").innerHTML = StrComboTag;
	*************/
}

function GotoOrginDoc()
{
	if(!HwpControl.HwpCtrl.Open(BaseDoc))
	{
		alert("Base Path가 잘못 지정된 것 같습니다. 소스에서 BasePath 를 수정하십시요");
	}
}

function GotoVersionDoc(VerPath)
{
	if (!HwpControl.HwpCtrl.open(VerPath))
	{
		alert("Base Path가 잘못 지정된 것 같습니다. 소스에서 BasePath 를 수정하십시요");
	}
	
	if (VerPath != BaseDoc)
	{
//		HwpControl.HwpCtrl.EditMode = 0;
	}	
}

function SaveVersion(flagover)
{
	var writer = HwpControl.writer.value;
	var desc = HwpControl.desc.value;
	
	HwpControl.HwpCtrl.VersionSave("", flagover, 0, writer, desc);
	
	window.location.reload();
}

function GetVersionInfo()
{
	var set;
	var strinfo;
	
	var selidx = HwpControl.VersionSelect.options.selectedIndex -1;
	
	GotoVersionDoc(BaseDoc);
	
	if (selidx >= 0)
	{
		set = HwpControl.HwpCtrl.GetVersionInfo(selidx);
	
		strinfo = "지은이:" + set.Item("ItemInfoWriter");
		strinfo += "\r\n설명:" + set.Item("ItemInfoDescription");
		strinfo += "\r\n덮어쓰기:" + set.Item("ItemOverWrite");
		strinfo += "\r\n삭제인덱스:" + set.Item("ItemInfoIndex");
		strinfo += "\r\n날짜정보LO:" + set.Item("ItemInfoTimeLo");
		strinfo += "\r\n날짜정보HI:" + set.Item("ItemInfoTimeHi");
		strinfo += "\r\n버전정보잠그기:" + set.Item("ItemInfoLock");
	}
	else
	{
		strinfo = "원본문서입니다";
	}

	HwpControl.versioninfo.value = strinfo;
}

function DelCurVersion()
{
	var selidx = HwpControl.VersionSelect.options.selectedIndex -1;
	
	if (selidx < 0)
		return;
		
	if(confirm("현재 선택된 버전을 삭제하시겠습니까?"))
	{
		HwpControl.HwpCtrl.VersionDelete(selidx);
		window.location.reload();
	}
}

function DelAllVersion()
{
	var cnt = HwpControl.HwpCtrl.GetVersionHistoryCount();
	
	if(!confirm("모든 버전 정보를 삭제하시겠습니까?"))
		return;
		
	while(cnt > 0)
	{
		HwpControl.HwpCtrl.VersionDelete(cnt-1);
		cnt--;
	}
	
	window.location.reload();
}

</script>
<BODY onload = "OnStart();MakeVersionHmlFiles();" >
		<textarea id='date' style='display:none'><%=date%></textarea>
		<textarea id='story' style='display:none'><%=story%></textarea>
		<textarea id='title' style='display:none'><%=consultans.get("TITLE")%></textarea>
		<textarea id='opinion' style='display:none'><%=consultans.get("BUBVIEW")%></textarea>
		<textarea id='sdept' style='display:none'><%=consultans.get("DEPT")%></textarea>
		<textarea id='s1' style='display:none'><%=consultans.get("BUBMUSENGINNAME")%></textarea>
	    <form style="margin:0;" name = "HwpControl">
	    	<OBJECT id=HwpCtrl style="LEFT: 0px; TOP: 0px"  height=100% width=100% align=center 
			classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052>
			<PARAM NAME="_Version" VALUE="65536">
			<PARAM NAME="_ExtentX" VALUE="21167">
			<PARAM NAME="_ExtentY" VALUE="15875">
			<PARAM NAME="_StockProps" VALUE="0">
			<PARAM NAME="FILENAME" VALUE=""></OBJECT>
		</form>
</BODY>

