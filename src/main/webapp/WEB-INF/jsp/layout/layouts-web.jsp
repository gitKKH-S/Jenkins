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
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MENU_MNG_NO : " + MENU_MNG_NO);
	String SUB_MENU_MNG_NO = param.get("SUB_MENU_MNG_NO")==null?"":param.get("SUB_MENU_MNG_NO");
	String MENU_SE_NM = param.get("MENU_SE_NM")==null?"":param.get("MENU_SE_NM");
	String smType = param.get("smType")==null?"":param.get("smType");
	String addParam1 = param.get("addParam1")==null?"":param.get("addParam1");
	String addParam2 = param.get("addParam2")==null?"":param.get("addParam2");
	String searchForm = param.get("searchForm")==null?"":param.get("searchForm");
	String addParam3 = param.get("addParam3")==null?"":param.get("addParam3");
	System.out.println("MENU_MNG_NO===>"+MENU_MNG_NO);
	System.out.println("addParam1===>"+addParam1);
	if(!SUB_MENU_MNG_NO.equals("")){
		MENU_MNG_NO = SUB_MENU_MNG_NO;
	}
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
%>
<!doctype html>
<html lang="ko">
<head>
	<title><%=SYSTITLE %></title>
	<tiles:insertAttribute name="meta"/>
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/${DMI}/css/sub.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/ext-all-debug.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/src/locale/ext-lang-ko.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/css/ext-all.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/mnview/css/extgrid.css">
	
	<script>
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	</script>
	<link rel="icon" type="image/ico" href="${resourceUrl}/mten.ico"/>
	
	<style>
		#workPage{min-width:1126px;}
		.logoW{cursor:pointer;}
	</style>
</head>
<script>
	$(document).ready(function(){
		var MENU_SE_NM = '<%=MENU_SE_NM%>';
		var smType = '<%=smType%>';
		var addParam1 = '<%=addParam1%>';
		var addParam2 = '<%=addParam2%>';
		var searchForm = '<%=searchForm%>';
		var addParam3 = '<%=addParam3%>';
		// 화면 사이즈 조정
		var inHei = window.innerHeight;
		var inWid = window.innerWidth;
		var topHei = $("#header").height();
		var cateWidth = $(".categoryW").width()+17;
		var leftOffset = $('.naviW').offset().left;
		$(".categoryW").css("width",leftOffset-5);
		$("#container").css("height", inHei-30);
		$(".subCW").css("width", "100%");
		$(".subCW").css("height", inHei-topHei-2);
		$(".naviW").css("width", $("#workPage").width());
		$(".subCC").css("width", inWid-cateWidth);
		$(".subCC").css("height", "100%"); //735
		$("#workPage").css("height", inHei-topHei-200); //730
		$(".categoryW").css("height", $("#workPage").height());
		
		if($("#topW").width()<1400){
			$(".innerW").css("width", "95%");
			$(".sitemapW").css("width", "95%");
		}else{
			$(".innerW").css("width", "1320");
			$(".sitemapW").css("width", "1320");
		}
		

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
		
		$.ajax({
			type:'post',
			url:'${pageContext.request.contextPath}/web/getPageNavi.do',
			dataType: "json",
			data : {
				MENU_MNG_NO:"<%=MENU_MNG_NO%>"
				, MENU_SE_NM:"<%=MENU_SE_NM%>"
			},
			async: false,
			success:function(data){
				if(MENU_SE_NM!='BYLAW' && MENU_SE_NM!='WORK' && MENU_SE_NM!='CAL'){
					$("#pagenavi").text(data.PATH);
					$('#MENU_MNG_NO').val(data.MENU_MNG_NO);
					$('#addParam1').val(addParam1);
					$('#addParam2').val(addParam2);
					$('#searchForm').val(searchForm);
					$('#addParam3').val(addParam3);
					var frm = document.pageT;
					frm.target="workPage";
					frm.action="${pageContext.request.contextPath}"+data.URL_INFO_CN;
					frm.submit();
				}else if(MENU_SE_NM=='BYLAW'){
					if(smType=='recent'){
						$("#pagenavi").text("자치법규 > 최근 제·개정 자치법규");
						$("#workPage").load(function(){
							$("#workPage").get(0).contentWindow.setSubTitle("최근 제·개정 자치법규");	
						});
						
						$('#mtype').val('recent');
					}else{
						$("#pagenavi").text("자치법규 > 현행 자치법규");
						$("#workPage").load(function(){
							$("#workPage").get(0).contentWindow.setSubTitle("현행 자치법규 (자치법규 제·개정 권한문의 : 법제지원팀)");
						});
						
						$('#mtype').val('htree');
					}
					
					var frm = document.pageT;
					frm.target="workPage";
					frm.action="${pageContext.request.contextPath}/web/regulation/regulationList.do";
					frm.submit();
				}else if(MENU_SE_NM=='WORK'){
					$(".categoryW").css("display","none");
					$(".contC").css("margin-left","40px");
					$(".subCC").css("margin-left","0");
					$(".subCC").css("width", "100%");
					$("#pagenavi").css("width", "100%");
					$("#pagenavi").text("HOME > 업무현황");
					$("#workPage").load(function(){
						$("#workPage").get(0).contentWindow.setSubTitle("업무현황");
					});
					
					var frm = document.pageT;
					frm.target="workPage";
					frm.action="${pageContext.request.contextPath}/web/workList.do";
					frm.submit();					
				} else if(MENU_SE_NM=='CAL'){
					$(".categoryW").css("display","none");
					$(".contC").css("margin-left","40px");
					$(".subCC").css("margin-left","0");
					$(".subCC").css("width", "100%");
					$("#pagenavi").css("width", "100%");
					$("#pagenavi").text("HOME > 일정관리");
					$("#workPage").load(function(){
						//$("#workPage").get(0).contentWindow.setSubTitle("일정관리");
					});
					$('#addParam1').val(addParam1);
					$('#addParam2').val(addParam2);
					var frm = document.pageT;
					frm.target="workPage";
					frm.action="${pageContext.request.contextPath}/web/suit/fullcalendar.do";
					frm.submit();
				}
			},
			error:function(e){
				alert("페이지 정보를 불러올수 없습니다.");
			}
		})
		
		$(".logoW").click(function(){
			location.href="${pageContext.request.contextPath}/web/index.do";
		});
		
		$.ajax({
			type:'post',
			url:'${pageContext.request.contextPath}/web/suit/getLeftDate.do',
			dataType: "json",
			data : { },
			async: false,
			success:function(data){
				console.log("layouts-web leftDate get!");
				console.log(data.result);
				
				$("#DATE_CNT").text(data.result.DATE_CNT);
				$("#DATE_CNT_7").text(data.result.DATE_CNT_7);
				$("#DATE_CNT_3").text(data.result.DATE_CNT_3);
				
				$("#DOC_CNT").text(data.result.DOC_CNT);
				$("#DOC_CNT_3").text(data.result.DOC_CNT_3);
				$("#DOC_CNT_7").text(data.result.DOC_CNT_7);
				
				$("#UNCH_DATE_CNT").text(data.result.UNCH_DATE_CNT);
				$("#UNCH_DATE_CNT_3").text(data.result.UNCH_DATE_CNT_3);
				$("#UNCH_DATE_CNT_7").text(data.result.UNCH_DATE_CNT_7);
			},
			error:function(e){
				alert("페이지 정보를 불러올수 없습니다.");
			}
		});
		
		$(window).resize(function() {
			var inHei = window.innerHeight;
			var inWid = window.innerWidth;
			var topHei = $("#header").height();
			var cateWidth = $(".categoryW").width()+17;
			$("#container").css("height", inHei-30);
			$(".subCW").css("width", "100%");
			$(".subCW").css("height", inHei-topHei-2);
			$(".naviW").css("width", $("#workPage").width());
			$(".subCC").css("width", inWid-cateWidth);
			$(".subCC").css("height", "100%"); //735
			$("#workPage").css("height", inHei-topHei-200); //730
			$(".categoryW").css("height", $("#workPage").height());
			var leftOffset = $('.naviW').offset().left;
			$(".categoryW").css("width",leftOffset-5);
			if($("#topW").width()<1400){
				$(".innerW").css("width", "95%");
				$(".sitemapW").css("width", "95%");
			}else{
				$(".innerW").css("width", "1320");
				$(".sitemapW").css("width", "1320");
			}
			if(MENU_SE_NM=='WORK'){
				$(".subCC").css("width", "100%");
				$("#pagenavi").css("width", "100%");
			}
		})
	});
</script>
<style>
	#cattit{
		font-size: 16px;
	    background: #3F5FCE;
	    border-radius: 0 8px 8px 0;
	    color: #fff;
	    padding: 8px 16px;
	    font-weight: 600;
	}
</style>
<body><!--  style="-ms-overflow-style:none;" -->
<div id="container">
	<tiles:insertAttribute name="topmenu"/>
	<div class="categoryW">
		<div class="setW">
			<div id="cattit"><span><i id="tcls" class="ph-bold"></i> </span><span id="scatit"></span></div>
			<tiles:insertAttribute name="treemenu"/>
		</div>
	<%
		if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("C")>-1 || GRPCD.indexOf("L")>-1 ||
			GRPCD.indexOf("G")>-1 || GRPCD.indexOf("B")>-1 || GRPCD.indexOf("D")>-1) {
	%>
		<div class="setW">
			<h2 class="type1">불변기일 현황</h2>
			<div class="listSW">
				<dl>
					<dt>3일이내</dt>
					<dd class="lbDate" id="UNCH_DATE_CNT_3" vo4="bul" vo5="3" vo6="bul" vo7="3"></dd>
				</dl>
				<dl>
					<dt>7일이내</dt>
					<dd class="lbDate" id="UNCH_DATE_CNT_7" vo4="bul" vo5="7" vo6="bul" vo7="7"></dd>
				</dl>
				<dl>
					<dt>전체</dt>
					<dd class="lbDate" id="UNCH_DATE_CNT" vo4="bul" vo5="" vo6="bul" vo7=""></dd>
				</dl>
			</div>
		</div>
		<div class="setW">
			<h2 class="type2">서면제출 업무 현황</h2>
			<div class="listSW">
				<dl>
					<dt>3일이내</dt>
					<dd class="lbDate" id="DOC_CNT_3" vo4="doc" vo5="3" vo6="doc" vo7="3"></dd>
				</dl>
				<dl>
					<dt>7일이내</dt>
					<dd class="lbDate" id="DOC_CNT_7" vo4="doc" vo5="7" vo6="doc" vo7="7"></dd>
				</dl>
				<dl>
					<dt>전체</dt>
					<dd class="lbDate" id="DOC_CNT" vo4="doc" vo5="" vo6="doc" vo7=""></dd>
				</dl>
			</div>
		</div>
		<div class="setW">
			<h2 class="type3">기일 업무 현황</h2>
			<div class="listSW">
				<dl>
					<dt>3일이내</dt>
					<dd class="lbDate" id="DATE_CNT_3" vo4="date" vo5="3" vo6="date" vo7="3"></dd>
				</dl>
				<dl>
					<dt>7일이내</dt>
					<dd class="lbDate" id="DATE_CNT_7" vo4="date" vo5="7" vo6="date" vo7="7"></dd>
				</dl>
				<dl>
					<dt>전체</dt>
					<dd class="lbDate" id="DATE_CNT" vo4="date" vo5="" vo6="date" vo7=""></dd>
				</dl>
			</div>
		</div>
	<%
		}
	%>
	</div>
		<div class="contC">
			<tiles:insertAttribute name="pagenavi"/>
			<iframe id="workPage" name="workPage" src="" style="width:100%;height:100%;" ></iframe>
		</div>
	</div>
</div>
</body>
</html>
