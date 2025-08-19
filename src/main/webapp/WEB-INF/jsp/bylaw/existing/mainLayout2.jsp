<%@ page language="java"  pageEncoding="UTF-8"%>
<%
	String stateCd = request.getAttribute("stateCd")==null?"":(String)request.getAttribute("stateCd");
	String stateid = "";
	if(stateCd.equals("H")){
		stateid = "5000";
		stateCd = "현행";
	}else if(stateCd.equals("C")){
		stateid = "6000";
		stateCd = "폐지";
	}
%>
	<script>
		stateCd = '<%=stateCd%>';
		var stateidM = '<%=stateid%>';
		var bonValue='xml';
	</script>
 	<!-- ENDLIBS -->
    <script src="${resourceUrl}/appjs/existing/history.js" type="text/javascript"></script>
    <script src="${resourceUrl}/appjs/existing/search.js" type="text/javascript"></script>
    <script src="${resourceUrl}/PDFObject-master/pdfobject.min.js" type="text/javascript"></script>
	<style type="text/css">
	* {
		font-family: "굴림", "돋움";
		color: #333;
	}

    .settings {
        background-image:url(${resourceUrl}/extjs/examples/shared/icons/fam/folder_wrench.png);
    }
    .nav {
        background-image:url(${resourceUrl}/extjs/examples/shared/icons/fam/folder_go.png);
    }
    .oldbutton{padding-top:1px;}
    .mten {font-size:9pt; font-weight:bold; text-decoration:underline;color: #daa520;}
	.mten1 {font-size:9pt; font-weight:bold; color:#008b8b;}
	.list_title{font-size:9pt; font-weight:bold; color:#008b8b;height: 20px;padding: 5px;}		
	.list_03{text-align:center;font-size:9pt;}
	.list_03_1{text-align:center;font-size:9pt;font-weight:bold}
	.list_04 p{ width:20px;text-align:center}
	.verticalAlignTop{ vertical-align:top;}
    </style>
	<script src="${resourceUrl}/appjs/existing/mainLayout.js" type="text/javascript"></script>
	<script src="${resourceUrl}/appjs/existing/tree.js" type="text/javascript"></script>
	<script src="${resourceUrl}/appjs/existing/noForm.js" type="text/javascript"></script>
	<link href="${resourceUrl}/appjs/existing/tree.css" rel="stylesheet" type="text/css">
	<link href="${resourceUrl}/mnview/css/catTree.css" rel="stylesheet" type="text/css">
	<link href="${resourceUrl}/mnview/css/view.css" rel="stylesheet" type="text/css">
	<link href="${resourceUrl}/mnview/css/viewEtc.css" rel="stylesheet" type="text/css">
	<link href="${resourceUrl}/mnview/css/main.css" rel="stylesheet" type="text/css" media="screen">
	<style type="text/css">
		.jotag{
			padding-left:20px;
			color:blue;
		}
		.jotag2{
			color:blue;
		}
		#loading ,#loading2{
			width: 100%;
			height: 100%;
			top: 0px;
			left: 0px;
			position: fixed;
			display: block;
			opacity: 0.7;
			background-color: #fff;
			z-index: 99;
			text-align: center;
		}
		
		#loading-image {
			position: absolute;
			top: 50%;
			left: 50%;
			z-index: 100;
		}
		.fileIng a span{
			color:red;
		}
	</style>
	<script>
	var win;
	function close(){
		win.close();
	}
	function treload(){
		tree.root.reload();
	}
	function msgbox(){
		Ext.MessageBox.wait('자료를 저장중입니다. ...','Wait',{interval:20,timeout:3000000000, text:'자료를 저장중입니다~!'});
	}
	function msgbox2(bookid,noformyn,statehistoryid){
		Ext.MessageBox.alert('확인', '저장되었습니다.', function(btn){  
		    if (btn == 'ok') {  
	    		getDocInfo(bookid,noformyn);
		    }
		});  
	}
	function msghidden(){
		Ext.MessageBox.hide();
	}
	
	function old(bookid,contno,contsubno,allcha,bcontid){
		//새창의 크기
		cw=502;
		ch=320;
		//스크린의 크기
		sw=screen.availWidth;
		sh=screen.availHeight;
		//열 창의 포지션
		px=(sw-cw)/2;
		py=(sh-ch)/2;
		//창을 여는부분
		property="left="+px+",top="+py+",width=820,height=320,scrollbars=yes,resizable=yes,status=no,toolbar=no";
		form=document.revi;
		window.open("${pageContext.request.contextPath}/web/regulation/joPop.do?Bookid="+bookid+"&Contno="+contno+"&Contsubno="+contsubno+"&allcha="+allcha+"&bcontid="+bcontid, contno, property);
	}
	function downpage(Pcfilename,Serverfile,folder){
		form=document.ViewForm;
		form.Pcfilename.value=Pcfilename;
		form.Serverfile.value=Serverfile;
		form.folder.value=folder;
		form.action="${pageContext.request.contextPath}/Download.do";
		form.submit();
	}
	function link(lawcode,jo){
		//새창의 크기
		 cw=1200;
		 ch=900;
		  //스크린의 크기
		 sw=screen.availWidth;
		 sh=screen.availHeight;
		 //열 창의 포지션
		 px=(sw-cw)/2;
		 py=(sh-ch)/2;
		 //창을 여는부분
		property="left="+px+",top="+py+",width=1500,height=900,scrollbars=no,resizable=yes,status=no,toolbar=no";
		window.open("${pageContext.request.contextPath}/web/regulation/regulationViewPop.do?OBOOKID="+lawcode+"#"+jo, "ocase",property);
	}
	function link_law(lawcode,jo){
		var url = "${pageContext.request.contextPath}/web/law/lawViewPagePop.do?LAWID="+lawcode;
		if(jo!='000100'){
			//url = url + "#"+jo+"1";
			url = url + "&JO="+jo;
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
		property="left="+px+",top="+py+",width=1300,height=870,scrollbars=no,resizable=yes,status=no,toolbar=no";
		
		var pop_f;
		
		pop_f = window.open(url,'klaw',property);
		pop_f.focus();
	}
	function contfileView(contid){
		var url = "${pageContext.request.contextPath}/web/regulation/joFileList.do?contid="+contid;
		//새창의 크기
		 cw=550;
		 ch=370;
		  //스크린의 크기
		 sw=screen.availWidth;
		 sh=screen.availHeight;
		 //열 창의 포지션
		 px=(sw-cw)/2;
		 py=(sh-ch)/2;
		 //창을 여는부분
		property="left="+px+",top="+py+",width=550,height=370,scrollbars=no,resizable=yes,status=no,toolbar=no";
		
		var pop_f;
		
		pop_f = window.open(url,contid,property);
		pop_f.focus();
	}
	</script>
 <div id="mytraditionalform"></div>
	<div id="west">
		<div id="treeHolder"></div>
		<div id="westbottom"></div>
		<div id="westSearch"></div>
	</div>
	<div id="east"></div>
	<div id="easttab"></div>
  <div id="center2" style="padding: 3px 3px 3px 3px;">
        <div id="myButton"></div>
        <div id="sarra"></div> 
  </div>
  <div id="center1" style="overflow-x:hidden;"></div>
  <div id="center3"></div>
  <div id="center0"></div>
  <div id="center4"></div>
  <div id="center5"></div>
  <div id="props-panel" style="width:200px;height:200px;overflow:hidden;"></div>
  <div id="south"></div>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>