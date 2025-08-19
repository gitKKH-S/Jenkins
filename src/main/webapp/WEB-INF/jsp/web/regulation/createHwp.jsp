<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.bylawweb.service.*"%>
<%@ page import="com.mten.util.MakeHan"%>
<%
	String Bookid = request.getParameter("Bookid")==null?"10018633":request.getParameter("Bookid");
	BylawwebService service = BylawwebServiceHelper.getBylawwebService(application);

	HashMap param = new HashMap();
	param.put("bookid", Bookid);
	HashMap bylaw = service.BookInfo(param);	//문서정보

	StreamSource xml = null;
	String XSLURL = MakeHan.File_url("XSL");
	String xslurl =XSLURL+"test.xsl";
	System.out.println(bylaw.get("XMLDATA"));
	xml = new StreamSource(new StringReader(bylaw.get("XMLDATA").toString()));
	xslurl =XSLURL+"test.xsl";
	
	System.out.println("---------------------------");
	File xsl = new File(xslurl);
	TransformerFactory tFactory = TransformerFactory.newInstance(); 
	Transformer transformer = tFactory.newTransformer(new StreamSource(xsl)); 
	transformer.setParameter("bookid",bylaw.get("BOOKID").toString());
	transformer.setParameter("revcha",bylaw.get("REVCHA").toString());
	
	StringWriter stringWriter = new StringWriter();
	transformer.transform(xml, new StreamResult(stringWriter));
	String result = stringWriter.toString();
%>
<HTML>
<HEAD>
<META content="text/html; charset=ks_c_5601-1987" http-equiv=Content-Type>
<!--link href="../css/staly.css" rel="stylesheet" type="text/css"-->

<style xmlns:fo="http://www.w3.org/1999/XSL/Format" type="text/css">
	A:link    {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
	A:visited {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
	A:active  {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
	A:hover   {color:#000000;font-family:굴림;font-size:9pt;text-decoration:none} 
	.hwpTitle {font-size:20pt; font-weight:bold; text-align:center; }
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
<SCRIPT language="JavaScript">

// 현재 이 예제 파일이 있는 곳을 지정해 준다.
var BasePath = "";  
var BaseDoc = "";

// 시작시 설정 사항
function OnStart()
{
	InitToolBarJS();
	//var bRes = HwpControl.HwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
	var uinfo = URLINFO;
	BaseDoc = uinfo+"/dataFile/law/attach/test.hwp";//BasePath + "2211.hwp";
	HwpControl.HwpCtrl.EditMode=1;
	if(!HwpControl.HwpCtrl.Open(BaseDoc,"forceopen:true"))
	{
		//alert(BaseDoc);
		//alert("Base Path가 잘못 지정된 것 같습니다. 소스에서 BasePath 를 수정하십시요");
	}
	
	

		
//	HwpControl.HwpCtrl.EditMode = 0;
}
function findword(){
	 
/*******
var dact = HwpControl.HwpCtrl.CreateAction("FindDlg");
    var dset = dact.CreateSet();//FindDlg/FindReplace
    
    dact.GetDefault(dset);
    dact.Execute(dset);

    
HwpControl.HwpCtrl.MovePos(2); //문서의 시작으로 이동
	  
	  while (1) // 검색이 끝날때 까지 반복
	  {   
	   var act = HwpControl.HwpCtrl.CreateAction("RepeatFind");
	   var set = act.CreateSet();
	   act.GetDefault(set);
	   set.SetItem("FindString", "정관"); //찾을 문자열
	   set.SetItem("IgnoreMessage", false);   //검색 종료 다이얼로그 보이지 않음
	   if (!act.Execute(set))      //검색이 끝났을때
	   { 
	    HwpControl.HwpCtrl.MovePos(2);     //문서의 시작으로 이동
	    act.Execute(set);      //다시한번 문자 검색 (처음 검색 된 문자로 이동 됨)
	    HwpControl.HwpCtrl.focus();
	    return;
	   }
	   
	   var act2 = HwpControl.HwpCtrl.CreateAction("CharShape"); // 검색된 문자에 하이라이트
	   var set2 = act2.CreateSet();
	   act2.GetDefault(set2);
	   set2.SetItem("ShadowColor", 0x00e9d7c7);  // 문자의 음영색
	   act2.Execute(set2);
	  }

	  ****/
}
function SetTextFile()
{
	InitToolBarJS();
	HwpControl.HwpCtrl.SetTextFile(HwpControl.txtarea.value,'HTML', "INSERT");
	ActHwp = HwpControl.HwpCtrl.CreateAction("AllReplace");
	SetHwp = HwpControl.HwpCtrl.CreateSet("FindReplace");
	HwpControl.HwpCtrl.MovePos(2);
	SetHwp.SetItem("FindString","[[");              //"찾을 문자열  <-----이부분에서 에러가 나고요...
	SetHwp.SetItem("ReplaceString","<");      //"바꿀 문자열
	SetHwp.SetItem('IgnoreMessage', true);              //"메세지 무시
	SetHwp.SetItem("Direction",2);                     //"찾을 방향 (0:앞, 1:뒤, 2:전체)
	SetHwp.SetItem('SeveralWords',true);            //"여러 단어 찾기 (True/False)
	ActHwp.Execute(SetHwp);

	HwpControl.HwpCtrl.MovePos(2);
	SetHwp.SetItem("FindString","]]");              //"찾을 문자열  <-----이부분에서 에러가 나고요...
	SetHwp.SetItem("ReplaceString",">");        //"바꿀 문자열
	SetHwp.SetItem('IgnoreMessage', true);              //"메세지 무시
	SetHwp.SetItem("Direction",2);                     //"찾을 방향 (0:앞, 1:뒤, 2:전체)
	SetHwp.SetItem('SeveralWords',true);              //"여러 단어 찾기 (True/False)
	ActHwp.Execute(SetHwp);
	HwpControl.HwpCtrl.MovePos(2);

	HwpControl.HwpCtrl.Run("MoveSelListBegin");
	HwpControl.HwpCtrl.Run("SelectAll");
	HwpControl.HwpCtrl.Run("MoveSelListEnd");
	ActHwp = HwpControl.HwpCtrl.CreateAction("ParagraphShape");
	SetHwp = HwpControl.HwpCtrl.CreateSet("ParagraphShapeAlignJustify");
	SetHwp.SetItem('BreakLatinWord',2);              
	SetHwp.SetItem('BreakNonLatinWord',true);
	ActHwp.Execute(SetHwp);

	HwpControl.HwpCtrl.MovePos(2);

}

// Toolbar Setting...
function InitToolBarJS()
{
	
	HwpControl.HwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAs");
	HwpControl.HwpCtrl.SetToolBar(0, "FindDlg,FileSaveAs,FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste"
			+"Separator, ParaNumberBullet, MultiColumn, SpellingCheck, HwpDic, Separator, PictureInsertDialog, MacroPlay1");
	
	HwpControl.HwpCtrl.ShowToolBar(true);
}


</SCRIPT>
</HEAD>
<BODY onload = "SetTextFile()" >
<form name = "HwpControl">
<OBJECT id="HwpCtrl" style="LEFT: 0px; TOP: 0px"  height="100%" width="100%" align="center" 
	classid="CLSID:BD9C32DE-3155-4691-8972-097D53B10052">
	<PARAM NAME="_Version" VALUE="65536">
	<PARAM NAME="_ExtentX" VALUE="21167">
	<PARAM NAME="_ExtentY" VALUE="15875">
	<PARAM NAME="_StockProps" VALUE="0">
	<PARAM NAME="FILENAME" VALUE=""></OBJECT>
<!--div style="display:none;"-->
<textarea name="txtarea" style="display:none">
<%= result.replaceAll("&gt;","]]").replaceAll("&lt;","[[") %>
</textarea>
<!--/div-->
</form>

</BODY>
</HTML>