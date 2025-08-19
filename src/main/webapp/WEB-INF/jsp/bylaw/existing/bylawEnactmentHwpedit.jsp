<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%
	String Bookcode = ServletRequestUtils.getStringParameter(request, "BOOKCODE", "");				//내규코드
	String Title = ServletRequestUtils.getStringParameter(request,"TITLE", "");						//내규명
	String Mainpith = ServletRequestUtils.getStringParameter(request,"MAINPITH", "");				//예규호수
	String subTitle = ServletRequestUtils.getStringParameter(request,"SUBTITLE", "");				//제정코드
	String Bookcd = ServletRequestUtils.getStringParameter(request,"BOOKCD", "");					//내규구분
	String Booksubcd = ServletRequestUtils.getStringParameter(request,"BOOKSUBCD", "");					//내규구분
	String Revcd = ServletRequestUtils.getStringParameter(request,"REVCD", "");						//제개정구분
	String Revcha = ServletRequestUtils.getStringParameter(request,"REVCHA", "");					//개정차수
	String Promulno = ServletRequestUtils.getStringParameter(request,"PROMULNO", "");				//공포번호
	String Promuldt = ServletRequestUtils.getStringParameter(request,"PROMULDT", "7777-12-31");				//공포일
	if(Promuldt.equals(""))Promuldt="7777-12-31";
	String Startdt = ServletRequestUtils.getStringParameter(request,"STARTDT", "6666-12-31");					//시행일
	if(Startdt.equals(""))Startdt="6666-12-31";
	
	String Enddt = ServletRequestUtils.getStringParameter(request,"ENDDT", "5555-12-31");						//종료일
	if(Enddt.equals(""))Enddt="5555-12-31";
	String Ord = ServletRequestUtils.getStringParameter(request,"ORD", "0");						//정렬순서
	String Otherlaw = ServletRequestUtils.getStringParameter(request,"OTHERLAW", "");				//타법
	String Deptname = ServletRequestUtils.getStringParameter(request,"DEPTNAME", "");				//부서명
	String dept = ServletRequestUtils.getStringParameter(request,"DEPT", "");				//부서id
	String Legislator = ServletRequestUtils.getStringParameter(request,"LEGISLATOR", "");			//제정권자
	String bylawFileUrl = ServletRequestUtils.getStringParameter(request,"BYLAWFILEURL", "");		//파일경로
	String bylawFilename = ServletRequestUtils.getStringParameter(request,"BYLAWFILENAME", "");		//파일명
	String fileName = ServletRequestUtils.getStringParameter(request,"FILENAME", "");				//파일명
	String Statecd = ServletRequestUtils.getStringParameter(request,"STATECD", "1000");				//내규상태
	String Pcatid = ServletRequestUtils.getStringParameter(request,"PCATID", "");					//트리로부터 넘어온 값
	String Noformyn = ServletRequestUtils.getStringParameter(request,"NOFORMYN", "N");				//트리로부터 넘어온 값
	String noFormYn_tree = ServletRequestUtils.getStringParameter(request,"NOFORMYN", "N");	//트리로부터 넘어온 값
	String state = ServletRequestUtils.getStringParameter(request,"STATE", "");						//페이지상태
	String pstate = ServletRequestUtils.getStringParameter(request,"PSTATE", "");					//등록,수정,개정여부
	String Obookid = ServletRequestUtils.getStringParameter(request,"OBOOKID", "");					//
	String Bookid = ServletRequestUtils.getStringParameter(request,"BOOKID", "");					//
	String username = ServletRequestUtils.getStringParameter(request,"USERNAME", "");					//
	String userid = ServletRequestUtils.getStringParameter(request,"USERID", "");					//
	String phone = ServletRequestUtils.getStringParameter(request,"PHONE", "");					//
	String CHG = ServletRequestUtils.getStringParameter(request,"CHG", "");					//개정을 전부개정처럼 하는지 체크
	String buyn = ServletRequestUtils.getStringParameter(request,"BUYN", "");
	String actionyn = ServletRequestUtils.getStringParameter(request,"ACTIONYN", "");
	String grade = ServletRequestUtils.getStringParameter(request,"GRADE", "");
	String approverid = ServletRequestUtils.getStringParameter(request,"APPROVERID", "");
	String buchkyn = ServletRequestUtils.getStringParameter(request,"BUCHKYN", "");
	String prelawyn = ServletRequestUtils.getStringParameter(request,"PRELAWYN", "");
	String homeyn = ServletRequestUtils.getStringParameter(request,"HOMEYN", "");
	String openyn = ServletRequestUtils.getStringParameter(request,"OPENYN", "");
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<SCRIPT language="JavaScript">
// 현재 이 예제 파일이 있는 곳을 지정해 준다.
var BasePath = "";  
var BaseDoc = "";
var saveBl = true;
// 시작시 설정 사항
function OnStart()
{
	//BasePath를 구한다.
	BasePath  = _GetBasePath();

//HwpControl.HwpCtrl.SetClientName("DEBUG"); //For debug message
	
	InitToolBarJS();
	var bRes = HwpControl.HwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModule");
	var uinfo = URLINFO;
	
	BaseDoc = uinfo+"/dataFile/law/attachtmp/"+"<%=fileName%>";
	 if(!HwpControl.HwpCtrl.Open(BaseDoc))
	 {
	  alert("Base Path가 잘못 지정된 것 같습니다. 소스에서 BasePath 를 수정하십시요"+BaseDoc);
	 }

	 //HwpControl.HwpCtrl.SaveAs("c:/mten/1235555555555555.txt", "TEXT",'') ;

	// GetTextFile();
}
var data;
function GetTextFile()
{
	data = HwpControl.HwpCtrl.GetTextFile("TEXT", "");
	document.forms[0].all.bontxt.style.display='';
	document.forms[0].all.HwpCtrl.style.display='none';
	HwpControl.bontxt.value = data;
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
	HwpControl.HwpCtrl.ReplaceAction("FileNew", "HwpCtrlFileNew");
	HwpControl.HwpCtrl.ReplaceAction("FileSave", "HwpCtrlFileSave");
	HwpControl.HwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAs");
	HwpControl.HwpCtrl.SetToolBar(1,"FileNew,FileSave,FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste"
								+"Separator, ParaNumberBullet, MultiColumn, SpellingCheck, HwpDic, Separator, PictureInsertDialog, MacroPlay1");
	HwpControl.HwpCtrl.ShowToolBar(true);
}

function MakeVersionHmlFiles()
{

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
function chk(){
	 var set = HwpControl.HwpCtrl.GetVersionInfo(0);
	 var str = set.Item("SaveFilePath");
	 alert(str);
}
function SavePartAsFile(somePart){
	 //HwpControl.document.write(somePart);
	 HwpControl.HwpCtrl.SaveAs("C:/ver.hwp");
	// alert();
	// HwpControl.document.close();
	 //alert();
	 //HwpControl.focus();
	 
	 //document.execCommand('SaveAs',true,'text.txt');

	}
function SavePartAs(){
	if(saveBl){
		if(document.forms[0].bontxt.value==''){
			data = HwpControl.HwpCtrl.GetTextFile("TEXT", "");
			data2 = HwpControl.HwpCtrl.GetTextFile("HTML", "");
			HwpControl.bontxt.value = data;
			HwpControl.bonhtml.value = data2;
		}	
		document.forms[0].action='${pageContext.request.contextPath}/bylaw/adm/EgcProc.do';
		document.forms[0].submit();
		saveBl = false;
	}

}
$(document).ready(function() { 
	OnStart();
	MakeVersionHmlFiles();
});
</SCRIPT>
<form name = "HwpControl" method="post">
<div align="center">
<span onclick="SavePartAs();"><img src="${resourceUrl}/images/ext/but-save-works.gif"/></span>
<!-- span onclick="GetTextFile();"><img src="${resourceUrl}/images/ext/but-trans-text.gif"/></span> -->
</div>
<input type="hidden" name="BUYN" value="<%=buyn %>"/>
<input type="hidden" name="ACTIONYN" value="<%=actionyn %>"/>
<input type="hidden" name="GRADE" value="<%=grade %>"/>
<input type="hidden" name="BOOKCODE" value="<%=Bookcode %>"/>
<input type="hidden" name="TITLE" value="<%=Title %>"/>
<input type="hidden" name="MAINPITH" value="<%=Mainpith %>"/>
<input type="hidden" name="BOOKCD" value="<%=Bookcd %>"/>
<input type="hidden" name="BOOKSUBCD" value="<%=Booksubcd %>"/>
<input type="hidden" name="REVCD" value="<%=Revcd %>"/>
<input type="hidden" name="REVCHA" value="<%=Revcha %>"/>
<input type="hidden" name="PROMULNO" value="<%=Promulno %>"/>
<input type="hidden" name="PROMULDT" value="<%=Promuldt %>"/>
<input type="hidden" name="STARTDT" value="<%=Startdt %>"/>
<input type="hidden" name="ENDDT" value="<%=Enddt %>"/>
<input type="hidden" name="OTHERLAW" value="<%=Otherlaw %>"/>
<input type="hidden" name="DEPTNAME" value="<%=Deptname %>"/>
<input type="hidden" name="DEPT" value="<%=dept %>"/>
<input type="hidden" name="LEGISLATOR" value="<%=Legislator %>"/>
<input type="hidden" name="BYLAWFILEURL" value="<%=bylawFileUrl %>"/>
<input type="hidden" name="BYLAWFILENAME" value="<%=bylawFilename %>"/>
<input type="hidden" name="STATECD" value="<%=Statecd %>"/>
<input type="hidden" name="STATE" value="<%=state %>"/>
<input type="hidden" name="NOFORMYN" value="<%=Noformyn %>"/>
<input type="hidden" name="PCATID" value="<%=Pcatid %>"/>
<input type="hidden" name="PSTATE" value="<%=pstate %>"/>
<input type="hidden" name="BOOKID" value="<%=Bookid %>"/>
<input type="hidden" name="OBOOKID" value="<%=Obookid %>"/>
<input type="hidden" name="ORD" value="<%=Ord %>"/>
<input type="hidden" name="NOFORMYN_TREE" value="<%=noFormYn_tree %>"/>
<input type="hidden" name="SUBTITLE" value="<%=subTitle %>"/>	
<input type="hidden" name="USERNAME" value="<%=username %>"/>
<input type="hidden" name="USERID" value="<%=userid %>"/>
<input type="hidden" name="PHONE" value="<%=phone %>"/>
<input type="hidden" name="CHG" value="<%=CHG %>"/>
<input type="hidden" name="APPROVERID" value="<%=approverid %>"/>
<input type="hidden" name="BUCHKYN" value="<%=buchkyn %>"/>
<input type="hidden" name="PRELAWYN" value="<%=prelawyn %>"/>
<input type="hidden" name="HOMEYN" value="<%=homeyn %>"/>
<input type="hidden" name="OPENYN" value="<%=openyn %>"/>
<textarea name="bontxt" cols="100%" rows ="100%"  style="display: none;"></textarea>
<textarea name="bonhtml" cols="100%" rows ="100%"  style="display: none;"></textarea>
<OBJECT name="HwpCtrl" id="HwpCtrl" style="LEFT: 0px; TOP: 0px"  height="100%" width="100%" align="center" 
	classid="CLSID:BD9C32DE-3155-4691-8972-097D53B10052" style="display:'';">
	<PARAM NAME="_Version" VALUE="65536">
	<PARAM NAME="_ExtentX" VALUE="21167">
	<PARAM NAME="_ExtentY" VALUE="15875">
	<PARAM NAME="_StockProps" VALUE="0">
	<PARAM NAME="FILENAME" VALUE=""></OBJECT>

</form>
