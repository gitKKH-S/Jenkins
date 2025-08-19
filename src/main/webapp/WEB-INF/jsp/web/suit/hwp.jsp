<%@ page language="java"  pageEncoding="UTF-8"%>
<%
	String fileName = request.getParameter("fileName")==null?"":request.getParameter("fileName");
	String gbn = request.getParameter("gbn")==null?"":request.getParameter("gbn");
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>> " + gbn);
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script>
$(document).ready(function(){
	OnStart();
	$("#HwpCtrl").css("height",'700px');
	$(window).resize(function() {
	});
})
// 현재 이 예제 파일이 있는 곳을 지정해 준다.
var BasePath = "";  
var BaseDoc = "";

// 시작시 설정 사항
function OnStart()
{
	InitToolBarJS();
	var uinfo = URLINFO;
	var bRes = HwpControl.HwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModule");
	BaseDoc = uinfo+"/dataFile/suit/<%=fileName%>";//BasePath + "2211.hwp";
	HwpControl.HwpCtrl.Open(BaseDoc,"HWP","forceopen:false");
	HwpControl.HwpCtrl.MovePos(2);          // 캐럿을 문서의 처음으로 이동시킨다.
	HwpControl.HwpCtrl.MovePos(27);         // 현재 캐럿의 위치를 화면에 보여준다.
	//HwpControl.HwpCtrl.focus();
//	HwpControl.HwpCtrl.EditMode = 0;
}


// Toolbar Setting...
//function InitToolBarJS()
//{
//	HwpControl.HwpCtrl.SetToolBar(0, "FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste,"
//	+"Separator, ParaNumberBullet, MultiColumn, SpellingCheck, HwpDic, Separator, PictureInsertDialog, MacroPlay1");
//
//	//HwpControl.HwpCtrl.SetToolBar(1, "DrawObjCreatorLine, DrawObjCreatorRectangle, DrawObjCreatorEllipse,"
//	//+"DrawObjCreatorArc, DrawObjCreatorPolygon, DrawObjCreatorCurve, DrawObjCreator, DrawObjTemplateLoad,"
//	//+"Separator, ShapeObjSelect, ShapeObjGroup, ShapeObjUngroup, Separator, ShapeObjBringToFront,"
//	//+"ShapeObjSendToBack, ShapeObjDialog, ShapeObjAttrDialog");
//
//	//HwpControl.HwpCtrl.SetToolBar(2, "StyleCombo, CharShapeLanguage, CharShapeTypeFace, CharShapeHeight,"
//	//+"CharShapeBold, CharShapeItalic, CharShapeUnderline, ParagraphShapeAlignJustify, ParagraphShapeAlignLeft,"
//	//+"ParagraphShapeAlignCenter, ParagraphShapeAlignRight, Separator, ParaShapeLineSpacing,"
//	//+"ParagraphShapeDecreaseLeftMargin, ParagraphShapeIncreaseLeftMargin");
//	
//	HwpControl.HwpCtrl.ShowToolBar(true);
//}
	function InitToolBarJS(){
		var gbn = "<%=gbn%>";
		console.log(gbn);
		if(gbn == "list"){
			OnShowToolBarAll();
			
			vHwpCtrl.ReplaceAction("FileNew", "HwpCtrlFileNew");
			vHwpCtrl.ReplaceAction("FileSave", "HwpCtrlFileSave");
			vHwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAs");
			vHwpCtrl.ReplaceAction("FileOpen", "HwpCtrlFileOpen");
			
			vHwpCtrl.ShowStatusBar(0);
			vHwpCtrl.AutoShowHideToolBar = true; //    해당 기능사용시 도구상자를 보여 줌.
		}else{
			HwpControl.HwpCtrl.SetToolBar(0, "FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste,"
					+"Separator, ParaNumberBullet, MultiColumn, SpellingCheck, HwpDic, Separator, PictureInsertDialog, MacroPlay1");
			HwpControl.HwpCtrl.ShowToolBar(true);
		}
	}
	
	function OnShowToolBarAll() {
		vHwpCtrl.SetToolBar(-1, "#2;1:TOOLBAR_FORMAT");         // 2
		vHwpCtrl.SetToolBar(-1, "#4;1:TOOLBAR_TABLE");         // 4
		vHwpCtrl.SetToolBar(-1, "#7;1:TOOLBAR_HEADER_FOOTER"); // 6
		vHwpCtrl.SetToolBar(-1, "#8;1:TOOLBAR_MASTERPAGE");     // 7
		vHwpCtrl.ShowToolBar(true);
	}

</script>
<form style="margin:0;" name = "HwpControl">
	<OBJECT id="HwpCtrl" style="LEFT: 0px; TOP: 0px"  height="100%" width="100%" align="center"	classid="CLSID:BD9C32DE-3155-4691-8972-097D53B10052">
	<PARAM NAME="_Version" VALUE="65536">
	<PARAM NAME="_ExtentX" VALUE="21167">
	<PARAM NAME="_ExtentY" VALUE="15875">
	<PARAM NAME="_StockProps" VALUE="0">
	<PARAM NAME="FILENAME" VALUE=""></OBJECT>
</form>