<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	HashMap bookInfo = request.getAttribute("bookInfo")==null?new HashMap():(HashMap)request.getAttribute("bookInfo");

	String Book_id_r = param.get("Book_id_r")==null?"":param.get("Book_id_r").toString();
	String Book_id_r2 = param.get("Book_id_r2")==null?"":param.get("Book_id_r2").toString();
	String Book_id_c = param.get("Book_id_c")==null?"":param.get("Book_id_c").toString();
	String Book_id_l = param.get("Book_id_l")==null?"":param.get("Book_id_l").toString();
	String gbn = param.get("gbn")==null?"":param.get("gbn").toString();
	String Bookid="";
	String subGbn="left";
	String target="a2";
	if(gbn.equals("center")){
		Bookid = Book_id_c; 
	}
	if(gbn.equals("left")){
		Bookid = Book_id_l;
	}
	if(gbn.equals("right")){
		Bookid = Book_id_r;
		subGbn="center";
		target="b2";
	}
	if(gbn.equals("right2")){
		Bookid = Book_id_r2;
		subGbn="right";
		target="c2";
	}
%>
<html>
	<head>
		<title>:::2단보기:::</title>
	</head>
	<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.js" type="text/javascript"></script>
	<link rel="stylesheet" href="${resourceUrl}/mnview/css/view13pt.css">
	<link rel="stylesheet" href="${resourceUrl}/mnview/css/viewEtc.css">
    <script src="${resourceUrl}/PDFObject-master/pdfobject.min.js" type="text/javascript"></script>
<style type="text/css">
<!--
* {
	font-family:  "돋움", "굴림";
	color: #333;
	margin:0px;
	padding:0px;
	font-size:12px;
}
-->
</style>
	
	<script language="JavaScript" type="text/JavaScript">
		<!--
		window.focus();
		
		
		function link_law(lawcode,jo){
			var url = "<%=CONTEXTPATH %>/jsp/bylaw/regulation/jsp/law/lawviewPop.jsp?gbn=law&lawsid="+lawcode;
			if(jo!='000100'){
				url = url + "#"+jo
			}
			//새창의 크기
			 cw=880;
			 ch=670;
			  //스크린의 크기
			 sw=screen.availWidth;
			 sh=screen.availHeight;
			 //열 창의 포지션
			 px=(sw-cw)/2;
			 py=(sh-ch)/2;
			 //창을 여는부분
			property="left="+px+",top="+py+",width=880,height=670,scrollbars=yes,resizable=no,status=no,toolbar=no";
			
			var pop_f;
			
			pop_f = window.open(url,'klaw',property);
			pop_f.focus();
		}   
	
		function link(lawcode,name){
			parent.<%=target%>.location.href="frameBon.jsp?Book_id_l=<%=Book_id_l%>&Book_id_r=<%=Book_id_r%>&Book_id_c=<%=Book_id_c%>&gbn=<%=subGbn%>#"+name;
		}		
				
		function downpage(Pcfilename,Serverfile,folder){
			form=document.forms[0];
			form.Pcfilename.value=Pcfilename;
			form.Serverfile.value=Serverfile;
			form.folder.value=folder;
			form.action="<%=CONTEXTPATH %>/bylaw/Download.do";
			form.submit();
		}
		
		function printJo(Bookid,Contid,cont,bcontid){
			var Contno;
			var Contsubno;
			
			cw=502;
			 ch=320;
			  //스크린의 크기
			 sw=screen.availWidth;
			 sh=screen.availHeight;
			 //열 창의 포지션
			 px=(sw-cw)/2;
			 py=(sh-ch)/2;
			 //창을 여는부분	
			 if(cont.indexOf('bu')>0){
				 var contarr = cont.split('bu');
				 Contno = contarr[0].substring(3,contarr[0].length);
				 //alert(contarr[1]);
				 Contsubno = contarr[1];
			 }else{
				 Contno = cont.substring(3,cont.length);
			 }
			//var Contno = contno.substring(3,contno.length);
			//alert(Contno);
			property="left="+px+",top="+py+",width=502,height=320,scrollbars=yes,resizable=no,status=no,toolbar=no";
			//form=document.revi;
			window.open("${pageContext.request.contextPath}/web/regulation/printJoPop.do?bookid="+Bookid+"&Contid="+Contid+"&Contno="+Contno+"&Contsubno="+Contsubno+"&print=P"+"&bcontid="+bcontid, Bookid, property);
		}
//-->
	</script>

	<div id="popbon"></div>	
</html>
<form name="con" method="post" style="margin:0px">
    <input type="hidden" name="Serverfile">
	<input type="hidden" name="Pcfilename">
	<input type="hidden" name="folder">
</form>
<script>
var BOOKID = '<%=bookInfo.get("BOOKID")%>';
var NOFORMYN = '<%=bookInfo.get("NOFORMYN")%>';
var TITLE = '<%=bookInfo.get("TITLE")%>';
$.ajax({
    url : "${pageContext.request.contextPath}/web/regulation/bonPop.do",
    dataType : "html",
    type : "POST",  // post 또는 get
    data : { bookid:BOOKID, NOFORMYN:NOFORMYN},   // 호출할 url 에 있는 페이지로 넘길 파라메터
    success : function(result){
        //overflow-y: scroll;align-items:center;display:flex;flex-direction:column; justify-content: flex-start;
    
    	
            	if(NOFORMYN=='N'){
            		$("#popbon").html(result);
                    $("#popbon").css("overflow-y","auto");
                    
                    var height = window.innerHeight;
                	$('.innerbody').css('height',height-90);	
            	}else{
            		if($.trim(result).toUpperCase().indexOf("HWP")>-1 || $.trim(result).toUpperCase().indexOf("DOC")>-1){
            			$.ajax({
            	            url : '${pageContext.request.contextPath}/bylaw/adm/goHwp.do',
            	            dataType : "html",
            	            type : "post",  // post 또는 get
            	            data : { fileName : $.trim(result)},   // 호출할 url 에 있는 페이지로 넘길 파라메터
            	            success : function(hwpbon){
            	            	$("#popbon").html("<p class='title'>"+TITLE+"</p>"+hwpbon);
            	            	var height = window.innerHeight;
            	            	$("form[name='HwpControl']").css("height",height-122);
            	            }
            	        });
            		}else if($.trim(result).toUpperCase().indexOf("PDF")>-1){
            			$("#popbon").html("<p class='title'>"+TITLE+"</p><form id='fpopbon' name='HwpControl'></form>");
            			var height = window.innerHeight;
            			var options = {
            				    height : height-122,
            					page : '2',
            					pdfOpenParams : {
            						view : 'FitV',
            						pagemode : 'thumbs'
            					}
            				};
            			PDFObject.embed("${pageContext.request.contextPath}/dataFile/law/attach/"+$.trim(result), "#fpopbon");
            			$("form[name='HwpControl']").css("height",height-122);
            		}else{
            			$("#popbon").html("<div id='innerbody' style='padding:50px;'>미리보기를 지원하지 않는 파일 형식 입니다.</div>");
            		}
            	}
    }
});

</script>
