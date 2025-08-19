<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@ page import="com.mten.util.*"%>
<%@ page import="net.sf.json.JSONObject"%>  
<%
    String consultid  = ServletRequestUtils.getStringParameter(request, "consultid", "").trim();
	String statecd  = ServletRequestUtils.getStringParameter(request, "statecd", "").trim();
	String inoutcd  = MakeHan.toKorean2(ServletRequestUtils.getStringParameter(request, "inoutcd", "").trim());
System.out.println("inoutcd===>"+inoutcd);
	String filename = "";
	if (inoutcd.equals("내부")){
		filename = "inApply.hwp";
	}else if (inoutcd.indexOf("외부")>-1){
		filename = "outApply.hwp";
	}else if (statecd.equals("contractinspection")){
		filename = "contractInspectionApply.hwp";
	}else {
		filename = "caseApply.hwp";
	}
    
	ConsultService consultService = ConsultServiceHelper.getConsultService(application);
    HashMap param = new HashMap();
    param.put("consultid", consultid);
    HashMap consult = consultService.getConsult(param);
	String story = consult.get("SASIL_KOREO")==null?"":consult.get("SASIL_KOREO").toString();
	System.out.println(story);
	String ask = consult.get("YOJI")==null?"":consult.get("YOJI").toString();
	String date = consult.get("BALSINDT")==null?"":consult.get("BALSINDT").toString();

	if (date == null || date.equals("")){
		java.util.Date d = new java.util.Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		date = df.format(d);
	}
	date = date.substring(0, 4)+". "+date.substring(4, 6)+". "+date.substring(6, 8);
	
%>
<HTML>
<HEAD>
<META content="text/html; charset=ks_c_5601-1987" http-equiv=Content-Type>
<link href="../css/staly.css" rel="stylesheet" type="text/css">
<style xmlns:fo="http://www.w3.org/1999/XSL/Format" type="text/css">
	A:link    {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
	A:visited {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
	A:active  {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
	A:hover   {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
</style>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
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
	BaseDoc = uinfo+"/dataFile/hwpstyle/<%=filename%>";
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
	 HwpControl.HwpCtrl.PutFieldText('dept', document.getElementById('sdept').value);
	}
	if (document.getElementById('deptsenginname').value!=null && document.getElementById('deptsenginname').value !=''){
		HwpControl.HwpCtrl.PutFieldText('deptsenginname', document.getElementById('deptsenginname').value);
	}
	if (document.getElementById('title').value!=null && document.getElementById('title').value !=''){
		HwpControl.HwpCtrl.PutFieldText('title', document.getElementById('title').value);
	}
	
	if (document.getElementById('story').value!=null && document.getElementById('story').value !=''){
		HwpControl.HwpCtrl.PutFieldText('story', document.getElementById('story').value);
	}
	if (document.getElementById('ask').value!=null && document.getElementById('ask').value !=''){
		HwpControl.HwpCtrl.PutFieldText('ask', document.getElementById('ask').value);
	}
	if (document.getElementById('opinion').value!=null && document.getElementById('opinion').value !=''){	
		HwpControl.HwpCtrl.PutFieldText('opinion', document.getElementById('opinion').value);
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
</HEAD>
<BODY onload = "OnStart();MakeVersionHmlFiles();" >
		<textarea id='date' style='display:none'><%=date%></textarea>
		<textarea id='story' style='display:none'><%=story%></textarea><!-- .replaceAll("\n","\r\n") -->
		<textarea id='ask' style='display:none'><%=ask%></textarea>
		<textarea id='title' style='display:none'><%=consult.get("TITLE")==null?"":consult.get("TITLE")%></textarea>
		<textarea id='opinion' style='display:none'><%=consult.get("DEPTVIEW")==null?"":consult.get("DEPTVIEW")%></textarea>
		<textarea id='sdept' style='display:none'><%=consult.get("DEPT")==null?"":consult.get("DEPT")%></textarea>
		<textarea id='deptsenginname' style='display:none'><%=consult.get("DEPTSENGINNAME")==null?consult.get("JILMUNNAME"):consult.get("DEPTSENGINNAME")%></textarea>
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
</HTML>
