<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018-12-30
  Time: 오후 5:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%
	Map<String,String> param = request.getAttribute("param")==null?new HashMap():(Map)request.getAttribute("param");
	String MENU_MNG_NO = param.get("MENU_MNG_NO")==null?"":param.get("MENU_MNG_NO");
	String MENU_SE_NM = param.get("MENU_SE_NM")==null?"":param.get("MENU_SE_NM");
	String smType = param.get("smType")==null?"":param.get("smType");
	System.out.println("MENU_MNG_NO===>"+MENU_MNG_NO);
%>
<!doctype html>
<html lang="ko">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
	<title><%=SYSTITLE %></title>
	<!--기본css-->
	<%-- 
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/common.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/layout.css">
	 --%>
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/sub.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/table.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/search.css">
	
	<!--아이콘-->
	<!-- <link rel="stylesheet" type="text/css" href="../../../../web-master/src/bold/style.css"> -->
	<!--폰트-->
	<!-- 
	<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/ungveloper/web-fonts/SCoreDream/font-face.css" />
	<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/ungveloper/web-fonts/SCoreDream/font-family.css" />
	 -->
	<tiles:insertAttribute name="meta"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/ext-all-debug.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/src/locale/ext-lang-ko.js"></script>
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/css/ext-all.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/mnview/css/extgrid.css">
	
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/fontawesome/css/all.min.css" />
	
    <script>
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	</script>
	<link rel="icon" type="image/ico" href="${resourceUrl}/mten.ico"/>
	<script src="${resourceUrl}/js/CryptoJSv3.1.2/crypto-js.min.js"></script>
	<script type="text/javascript" src="${resourceUrl}/js/mten.static.js"></script>
	<script type="text/javascript" src="${resourceUrl}/js/mten.util.js"></script>
	<script src="${resourceUrl}/js/CryptoJSv3.1.2/crypto-js.min.js"></script>
	<script type="text/javascript" src="${resourceUrl}/js/mten.session.js"></script>
	<style>
		/* #workPage{min-width:1200px;} */
		.logoW{cursor:pointer;}
		.subTabW ul li {width:5%;}
		.subCA { background-color: #fff; }
	</style>
</head>
<script>
	$(document).ready(function(){
		var MENU_SE_NM = '<%=MENU_SE_NM%>';
		// 화면 사이즈 조정
		var inHei = window.innerHeight;
		var topHei = $(".topW").height();
		//var fooHei = $("#footer").height()+100;
		//$("#container").css("height", inHei);
		//$(".subCW").css("height", inHei-topHei);
		//$(".subCC").css("height", inHei-topHei); //735
		//$("#workPage").css("height", inHei-topHei-2); //730
		$(".subCW").css("width", "98%");
		$(".subCC").css("width", "100%");
		$("#pagenavi").css("width", "100%");
		
		$(".logoW").click(function(){
			location.href="${pageContext.request.contextPath}/web/index.do";
		});
		
		$("#pagenavi").text("법무행정통합지원시스템 > 통합검색");
		$("#workPage").load(function(){
			$("#workPage").get(0).contentWindow.setSubTitle("현행 자치법규");	
		});
		
		$(window).resize(function() {
			var inHei = window.innerHeight;
			var topHei = $(".topW").height();
			//var fooHei = $("#footer").height()+100;
			//$("#container").css("height", inHei);
			//$(".subCW").css("height", inHei-topHei);
			//$(".subCC").css("height", inHei-topHei); //735
			//$("#workPage").css("height", inHei-topHei-2); //730
			$(".subCW").css("width", "98%");
			$(".subCC").css("width", "100%");
			$("#pagenavi").css("width", "100%");
		})
	});

	$(document).ready(function(){

		$.ajaxSetup({
			error : function(xhr, status, error) {
				console.log("에러 발생", xhr.status, xhr.responseText);
				if (xhr.status === 403) {
					const msg = JSON.parse(xhr.responseText);
					if(msg.errorCode=='PRIVACY_DETECTED'){
						alert(msg.message);
						return;
					}
					
				}
			}
		});		
		

		$(".datepick").datepicker({ 
			showOn:"both", 
			buttonImage:"${pageContext.request.contextPath}/resources/seoul/images/btn_calendar.png",
			dateFormat:'yy-mm-dd',
			buttonImageOnly:false,
			changeMonth:true,
			changeYear:true,
			nextText:'다음 달',
			prevText:'이전 달',
			yearRange:'c-100:c+10',
			showMonthAfterYear:true, 
			dayNamesMin:['일','월','화','수','목','금','토'],
			monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		});
		
		$(".ui-datepicker-trigger").css({"vertical-align":"middle","margin-left":"1px"});
		$(".ui-datepicker-trigger").mouseover(function(){
			$(this).css('cursor','pointer');
		});
		jQuery.datepicker.setDefaults(jQuery.datepicker.regional['ko']);
		
		$("input[name='schGbn']").click(function(){
			if(this.value=='META'){
				$(".msch input,selectbox").removeAttr("disabled");
				$(".fsch input").attr("disabled",true);
			}else{
				$(".msch input,selectbox").attr("disabled",true);
				$(".fsch input").removeAttr("disabled"); 
			}
		});
		$(".fsch input").attr("disabled",true);
	});
	
	//searchPageOpen('${lwsMngNo}','${instMngNo}','SUIT')
	function searchPageOpen(pk1,pk2,gbn) {
		if (gbn == "SUIT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","suitSearch",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "suitSearch");
			newForm.attr("action", CONTEXTPATH+"/web/suit/caseViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:pk1}));
			newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:pk2}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "CONSULT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","consultSearch",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "consultSearch");
			newForm.attr("action", CONTEXTPATH+"/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:pk1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "AGREE") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","agreeSearch",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "agreeSearch");
			newForm.attr("action", CONTEXTPATH+"/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:pk1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "PDS") {
			var cw=900;
			var ch=575;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","pdsSearch",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "pdsSearch");
			newForm.attr("action", "<%=CONTEXTPATH%>/web/pds/pdsViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"PST_MNG_NO", value:pk1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}

</script>
<body>
<div id="container">
	<div id="header">	
		<tiles:insertAttribute name="topmenu"/>
	</div>
	<div id="contentW">
		<div class="subCW">
			<div class="subCC no_category">
				<tiles:insertAttribute name="pagenavi"/>
				<tiles:insertAttribute name="content"/>
			</div>
		</div>
	</div>
</div>
</body>
</html>
