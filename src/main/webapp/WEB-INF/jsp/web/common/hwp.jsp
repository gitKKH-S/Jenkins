<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String fileName = request.getParameter("fileName")==null?"":request.getParameter("fileName");
%>
<form style="margin:0;" name = "HwpControl">
	<input type="button" value="파일 다운로드" onclick="saveFile('문서.hwp', '<%=fileName%>', 'DOCTYPE')" />
	<OBJECT id="HwpCtrl" style="LEFT: 0px; TOP: 0px"  height="100%" width="100%" align="center"	classid="CLSID:BD9C32DE-3155-4691-8972-097D53B10052">
	<PARAM NAME="_Version" VALUE="65536">
	<PARAM NAME="_ExtentX" VALUE="21167">
	<PARAM NAME="_ExtentY" VALUE="15875">
	<PARAM NAME="_StockProps" VALUE="0">
	<PARAM NAME="FILENAME" VALUE="">
	</OBJECT>
</form>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/mten.util.js"></script>
<script>
// 현재 이 예제 파일이 있는 곳을 지정해 준다.
var BasePath = "";  
var BaseDoc = "";

// 시작시 설정 사항
function OnStart()
{
	InitToolBarJS();
	var uinfo = URLINFO;
	var bRes = HwpControl.HwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModule");
	BaseDoc = uinfo+"/dataFile/doctype/<%=fileName%>";
	HwpControl.HwpCtrl.Open(BaseDoc,"HWP","forceopen:false");
	HwpControl.HwpCtrl.MovePos(2);          // 캐럿을 문서의 처음으로 이동시킨다.
	HwpControl.HwpCtrl.MovePos(27);         // 현재 캐럿의 위치를 화면에 보여준다.
	//HwpControl.HwpCtrl.focus();
	
	
//	HwpControl.HwpCtrl.EditMode = 0;
}


// Toolbar Setting...
function InitToolBarJS()
{
	HwpControl.HwpCtrl.SetToolBar(0, "FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste,"
	+"Separator, ParaNumberBullet, MultiColumn, SpellingCheck, HwpDic, Separator, PictureInsertDialog, MacroPlay1");

	//HwpControl.HwpCtrl.SetToolBar(1, "DrawObjCreatorLine, DrawObjCreatorRectangle, DrawObjCreatorEllipse,"
	//+"DrawObjCreatorArc, DrawObjCreatorPolygon, DrawObjCreatorCurve, DrawObjCreator, DrawObjTemplateLoad,"
	//+"Separator, ShapeObjSelect, ShapeObjGroup, ShapeObjUngroup, Separator, ShapeObjBringToFront,"
	//+"ShapeObjSendToBack, ShapeObjDialog, ShapeObjAttrDialog");

	//HwpControl.HwpCtrl.SetToolBar(2, "StyleCombo, CharShapeLanguage, CharShapeTypeFace, CharShapeHeight,"
	//+"CharShapeBold, CharShapeItalic, CharShapeUnderline, ParagraphShapeAlignJustify, ParagraphShapeAlignLeft,"
	//+"ParagraphShapeAlignCenter, ParagraphShapeAlignRight, Separator, ParaShapeLineSpacing,"
	//+"ParagraphShapeDecreaseLeftMargin, ParagraphShapeIncreaseLeftMargin");
	HwpControl.HwpCtrl.ShowToolBar(true);
}

	function saveFile(viewfilenm, serverfilenm, folder){
		var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("action", CONTEXTPATH+"/Download.do");
		
		var hiddenField = document.createElement("input");
		
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "Serverfile");
		hiddenField.setAttribute("value", serverfilenm);
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "Pcfilename");
		hiddenField.setAttribute("value", viewfilenm);
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "folder");
		hiddenField.setAttribute("value", folder);
		form.appendChild(hiddenField);
		
		document.body.appendChild(form);
		form.submit();
	}

OnStart();
</script>
<body></body>
