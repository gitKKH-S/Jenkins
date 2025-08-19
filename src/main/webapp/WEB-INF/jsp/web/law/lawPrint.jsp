<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.io.StringReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="javax.xml.transform.stream.StreamSource"%>
<%@page import="javax.xml.transform.stream.StreamResult"%>
<%@page import="javax.xml.transform.Templates"%>
<%@page import="javax.xml.transform.Transformer"%>
<%@page import="javax.xml.transform.TransformerFactory"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.jdom.Document"%>
<%@page import="org.jdom.Element"%>
<%@page import="org.jdom.input.SAXBuilder"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.io.IOException"%>
<%@ page import="com.mten.util.MakeHan"%>
<%
	HashMap bonInfo = request.getAttribute("bonInfo")==null?new HashMap() : (HashMap)request.getAttribute("bonInfo");
	HashMap param = bonInfo.get("param")==null?new HashMap() : (HashMap)bonInfo.get("param");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="${resourceUrl}/js/mten.static.js"></script>
<SCRIPT language="JavaScript">
window.focus();
function InitToolBarJS()
{
	HwpControl.HwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAs");
	HwpControl.HwpCtrl.SetToolBar(0, "FilePreview, Print,FileSaveAs");
	HwpControl.HwpCtrl.ShowStatusBar(0);
	HwpControl.HwpCtrl.AutoShowHideToolBar = true;
	HwpControl.HwpCtrl.ShowToolBar(true);
	
}


    
function mergeHwp()
{
   
	HwpControl.HwpCtrl.SetTextFile(HwpControl.txtarea.value,'HTML', "INSERT");

	ActHwp = HwpControl.HwpCtrl.CreateAction("PageSetup");
	SetHwp = ActHwp.CreateSet();
	SetHwp2 = SetHwp.CreateItemSet("PageDef", "PageDef");
	SetHwp.SetItem("ApplyTo", 3); // 적용범위 0 = 선택된 구역/1 = 선택된 문자열/2 = 현재 구역/3 = 문서전체/4 = 새 구역 : 현재 위치부터 새로
    // 1mm = 283.465 HWPUNITs
    SetHwp2.SetItem("TopMargin", 8500);    //30
    SetHwp2.SetItem("BottomMargin", 4251); //15
    SetHwp2.SetItem("LeftMargin", 5670);   //20
    SetHwp2.SetItem("RightMargin", 4251);  //15
    SetHwp2.SetItem("HeaderLen", 0);
    SetHwp2.SetItem("FooterLen", 0);
    SetHwp2.SetItem("GutterLen", 0);
    ActHwp.Execute(SetHwp);

	//쪽테두리 및 배경
	//ActHwp = HwpControl.HwpCtrl.CreateAction("PageBorder");
	//SetHwp = HwpControl.HwpCtrl.CreateSet("SecDef");
	//SetHwp.SetItem("FillArea","1");     
	//SetHwp.SetItem("FileName","http://localhost:8080/lawkorea/jsp/high1lms/images/mlogo.jpg");
	//ActHwp.Execute(SetHwp);

	//HwpControl.HwpCtrl.InsertPicture("http://localhost:8080/lawkorea/jsp/high1lms/images/mlogo.jpg", 0, 3, 0, 0,80, 80);
	//쪽번호 매기기
	ActHwp = HwpControl.HwpCtrl.CreateAction("PageNumPos");
	SetHwp = HwpControl.HwpCtrl.CreateSet("PageNumPos");
	SetHwp.SetItem("DrawPos","5");     
	ActHwp.Execute(SetHwp);

	//머릿말 , 꼬리말 넣기
	//ActHwp = HwpControl.HwpCtrl.CreateAction("HeaderFooter");
	//SetHwp = HwpControl.HwpCtrl.CreateSet("HeaderFooter");
	//HwpControl.HwpCtrl.MovePos(2);
	//SetHwp.SetItem("CtrlType","0");   
	//SetHwp.SetItem("Text","23452350");     
	//ActHwp.Execute(SetHwp);

	//배경화면넣기
	
	
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
	//SetHwp.SetItem('BreakLatinWord',2);              
	//SetHwp.SetItem('BreakNonLatinWord',true);
	ActHwp.Execute(SetHwp);
	HwpControl.HwpCtrl.MovePos(2);
}

function PrintToPrinter()
{
 var dact = HwpControl.HwpCtrl.CreateAction("Print");
 var dset = dact.CreateSet();
 dact.GetDefault(dset);
 dset.SetItem("Device", 0); 
 if (dact.Execute(dset))
 {
  alert("인쇄하였습니다.");
 }
 else
 {
  alert("저장 실패");
 }
} 

var BaseDoc = "";
//시작시 설정 사항
function OnStart(){
	InitToolBarJS();
	var bRes = HwpControl.HwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModule");
	var uinfo = URLINFO;
	BaseDoc = uinfo+"/dataFile/law/attach/blank.hwp";
	 if(!HwpControl.HwpCtrl.Open(BaseDoc))
	 {
	  alert("Base Path가 잘못 지정된 것 같습니다. 소스에서 BasePath 를 수정하십시요"+BaseDoc);
	 }

	 mergeHwp();
	 document.HwpCtrl.Path = "C:\\"
}
function saveAsCom(){
	document.HwpCtrl.SaveAs('<%=param.get("LAWNAME")%>.hwp');
}
</script>
</head>
<body onload = "OnStart();" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<span style="font-size:11px;cursor:pointer;font-family:NotoSansKR,Dotum,Gulim,Roboto,Arial,sans-serif;padding:0 10px;display:inline-block;line-height:25px;height:25px;background:#0066b3;color:#fff;border-radius:5px;vertical-align:middle;" onclick="saveAsCom()">바탕화면 파일 저장</span>
<form name="HwpControl">
<OBJECT id="HwpCtrl" style="LEFT: 0px; TOP: 0px" height="600" width="700" align="center" classid="CLSID:BD9C32DE-3155-4691-8972-097D53B10052">
 <PARAM NAME="_Version" VALUE="65536">
 <PARAM NAME="_ExtentX" VALUE="21167">
 <PARAM NAME="_ExtentY" VALUE="15875">
 <PARAM NAME="_StockProps" VALUE="0">
 <PARAM NAME="FILENAME" VALUE="">
 </OBJECT>
 <textarea name="txtarea" style="display:none">
<%
	String xmlData = param.get("LAWBON").toString();
	try{
		SAXBuilder parser = new SAXBuilder();
	 	Document doc = parser.build(new java.io.StringReader(xmlData));
	 	Element root = doc.getRootElement();
	 	Element de = root.getChild("기본정보");
	 	Element t1 = de.getChild("법령명_한글");
	 	Element t2 = de.getChild("시행일자");
	 	Element t3 = de.getChild("법종구분");
	 	Element t4 = de.getChild("소관부처");
	 	Element t5 = de.getChild("공포번호");
	 	Element t6 = de.getChild("제개정구분");
	 	Element t7 = de.getChild("공포일자");
	 	out.println("<div style='text-align:center;width:100%;font-size:20px;font-weight:bold;'>"+t1.getText()+"</div>");
	 	out.println("<div style='text-align:center;width:100%;font-size:12px;'>");
	 	out.println("[시행"+t2.getText().substring(0, 4)+"."+t2.getText().substring(4, 6)+"."+t2.getText().substring(6, 8)+".]");
	 	out.println("["+t4.getText()+t3.getText()+" "+t5.getText()+", "+t7.getText().substring(0, 4)+"."+t7.getText().substring(4, 6)+"."+t7.getText().substring(6, 8)+". ,"+t6.getText()+"]");
	 	out.println("</div>");
	 	Element joE = root.getChild("조문");
	 	List jo = joE.getChildren("조문단위");
	 	out.println("<br/>");
	 	out.println("<br/>");
	 	for(int i=0; i<jo.size(); i++){
	 		Element sjo = (Element)jo.get(i);
	 		
	 		List joTag = sjo.getChildren();
	 		for(int k=0; k<joTag.size(); k++){
	 			Element djo = (Element)joTag.get(k);
	 			String tagT = djo.getName();
		 		if(tagT.equals("조문내용")){
		 			String jBon = djo.getText();
		 			String sPattern1 = "^제.*?[편장절관조]";
			 		Pattern pattern = Pattern.compile(sPattern1);
			 		Matcher matcher1 = null;
			 		matcher1 = pattern.matcher(jBon.replaceAll(" ", ""));
			 		String align = "left";
			 		if (matcher1.find()) {
						String sValue = "";
						try {// 미스 매치시 오류 발생하므로 빈값을 던져 준다.
							sValue = matcher1.group(); // 제1장
							System.out.println(sValue);
						} catch (NullPointerException e) {
							sValue = "";
						}
						if (jBon.indexOf("(") > 0) {
							String jt = jBon.substring(0,jBon.indexOf(")") + 1);
							jBon = jBon.replace(jt, "<div style='font-size: 15px;color:#06C;font-weight:bold;'><a name='"+jt+"'>"+jt+"</a></div>");
							System.out.println(jBon);
						}else{
							if(sValue.contains("조")){
								jBon = jBon.replace(sValue, "<div style='font-size: 15px;color:#06C;font-weight:bold;'>"+sValue+"</div>");
							}else{
								System.out.println(jBon);
								jBon = "<div style='font-size:18px;font-weight:bold;'><a name='"+jBon+"'>"+jBon+"</a></div>";
								align = "center";
							}
							
						}
			 		}
			 		out.println("<div style='white-space:pre-wrap;text-align:"+align+";padding:15px;font-size: 16px;'>"+jBon+"</div>");
		 		}
		 		if(tagT.equals("항")){
		 			List hang = djo.getChildren();
		 			for(int h=0; h<hang.size(); h++){
		 				Element dhang = (Element)hang.get(h);
			 			String tagH = dhang.getName();
			 			if(tagH.equals("항내용")){
			 				out.println("<div style='margin-left: 1em;font-size: 16px;'>"+dhang.getText().trim()+"</div>");
			 			}
			 			if(tagH.equals("호")){
				 			List ho = dhang.getChildren();
				 			for(int l=0; l<ho.size(); l++){
				 				Element dho = (Element)ho.get(l);
					 			String tagHo = dho.getName();
					 			if(tagHo.equals("호내용")){
					 				out.println("<div style='margin-left: 2em;font-size: 16px;>"+dho.getText().trim()+"</div>");
					 			}
					 			
					 			if(tagHo.equals("목")){
						 			List mok = dho.getChildren();
						 			for(int m=0; m<mok.size(); m++){
						 				Element dmok = (Element)mok.get(m);
							 			String tagMok = dmok.getName();
							 			if(tagMok.equals("목내용")){
							 				out.println("<div style='margin-left: 3em;font-size: 16px;>"+dmok.getText().trim()+"</div>");
							 			}
							 			
							 			if(tagMok.equals("단")){
								 			List dan = dmok.getChildren();
								 			for(int n=0; n<dan.size(); n++){
								 				Element ddan = (Element)dan.get(n);
									 			String tagDan = ddan.getName();
									 			if(tagDan.equals("단내용")){
									 				out.println("<div style='margin-left: 4em;font-size: 16px;>"+ddan.getText().trim()+"</div>");
									 			}
								 			}
								 		}
						 			}
						 		}
				 			}
				 		}
		 			}
		 		}
	 		}
	 		out.println("<br/>");
	 	}
	 	Element bu = root.getChild("부칙");
	 	List bul = bu.getChildren("부칙단위");
	 	for(int i=0; i<bul.size(); i++){
	 		Element bjo = (Element)bul.get(i);
	 		List sbul = bjo.getChildren();
	 		for(int k=0; k<sbul.size(); k++){
	 			Element sbjo = (Element)sbul.get(k);	
	 			if(sbjo.getName().equals("부칙내용")){
	 				List ss = sbjo.getContent();
	 				for(int hk=0; hk<ss.size(); hk++){
	 					if(ss.get(hk).getClass().toString().indexOf("CDATA")>-1){
	 						org.jdom.CDATA cd = (org.jdom.CDATA)ss.get(hk);
	 						out.println("<pre style='text-align:left;padding:15px'>"+(cd.getTextTrim().replaceAll("\\<", "\\(").replaceAll("\\>", "\\)"))+"</pre>");
	 					}
	 				}
	 			}
	 		}
	 		out.println("<br/>");
	 	}
	}catch(IOException e){
		System.out.println("비정형문서는 xml데이터 관리대상이 아니다.");
	}
%>
</textarea>
</form>
</body>
</html>