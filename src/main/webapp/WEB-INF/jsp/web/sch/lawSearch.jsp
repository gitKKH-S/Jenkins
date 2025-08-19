<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	String query = request.getParameter("param_pQuery_tmp")==null?"":request.getParameter("param_pQuery_tmp");
%>
<style>
	#workPage{min-width:1200px;}
	.logoW{cursor:pointer;}
	.tbl_tx_type{color:red;}
	
	.innerBtn{
		border:0px;
		color:black;
	}
	.active{background:#004998; color: white;}
</style>
<!--# 디자인 맞추기  -->
<script>
	$(document).ready(function(){
		var Menucd = '';
		// 화면 사이즈 조정
		var inHei = window.innerHeight;
		var topHei = $(".topW").height();
		//var fooHei = $("#footer").height()+100;
		$("#container").css("height", inHei);
		$(".subCW").css("height", inHei-topHei);
		$(".subCC").css("height", inHei-topHei); //735
		$("#workPage").css("height", inHei-topHei-2); //730
		
		$(".logoW").click(function(){
			location.href="/web/index.do";
		});
		
		$("#pagenavi").text("법무행정통합지원시스템 > 통합검색");
		$("#workPage").load(function(){
			$("#workPage").get(0).contentWindow.setSubTitle("현행규정");	
		});
		
		$("#txtSearchBar").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("#searchBtn").click(function(){
			goSubSch();
		});
		
		$(window).resize(function() {
			var inHei = window.innerHeight;
			var topHei = $(".topW").height();
			//var fooHei = $("#footer").height()+100;
			$("#container").css("height", inHei);
			$(".subCW").css("height", inHei-topHei);
			$(".subCC").css("height", inHei-topHei); //735
			$("#workPage").css("height", inHei-topHei-2); //730
		})
		
		goSubSch();
	});
	function goSubSch(){
		goApi('law',"법령",1);
		goApi('bylaw',"행정규칙",1);
		goApi('slaw',"자치법규",1);
		goApi('byul',"별표서식",1);
		goApi('pan',"판례",1);
		goApi('lawex',"법령해석례",1);
		goApi('lawex2',"헌재결정례",1);
		goApi('lawex3',"행정심판재결례",1);
		goApi('joyak',"조약",1);
		goApi('word',"법령용어",1);
	}
	
	function goApi(datacd,gbn,pageno){
		$("#"+datacd+"_datalist").empty();
		$("#"+datacd+"_pagelist").empty();
		var start = 0;
		if(pageno>1){
			start = 15*(pageno-1);
		}
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/lawapi/apiData.do",
			data : {
				query:$("#query").val(),
				search:$("input[name='schGbn']:checked").val(),
				datacd:datacd,
				pageno:pageno,
				start : start 
			},
			datatype: "json",
			error: function(){},
			success:function(data){
				data = Ext.util.JSON.decode(data);
				$("#"+datacd+"tit").text(gbn+" "+data.total+"건");
				for(i=0; i<data.result.length; i++){
					console.log("data.result[i]");
					console.log(data.result[i]);
					console.log("===========================================");
					var dlink = "http://law.go.kr"+data.result[i].dlink;
					var title = data.result[i].title;
					if(datacd=='byul'){
						title = data.result[i].byult + " :: " + data.result[i].lawt;
					}
					$("#"+datacd+"_datalist").append('<a href="javascript:openApi(\''+dlink+'\')"><h3 class="subSSTitle">'+title+'</h3></a>');	
				}
				var nvi = pageNav( "goPageNvi", pageno, 15, data.total ,datacd);
				$("#"+datacd+"_pagelist").append(nvi);
			}
		});
	}
	
	function goPageNvi(num,datacd){
		if(datacd=='law'){
			goApi(datacd,"법령",num);	
		}else if(datacd=='bylaw'){
			goApi(datacd,"행정규칙",num);	
		}else if(datacd=='slaw'){
			goApi(datacd,"자치법규",num);	
		}else if(datacd=='byul'){
			goApi(datacd,"별표서식",num);	
		}else if(datacd=='pan'){
			goApi(datacd,"판례",num);	
		}else if(datacd=='lawex'){
			goApi(datacd,"법령해석례",num);	
		}else if(datacd=='lawex2'){
			goApi(datacd,"헌재결정례",num);	
		}else if(datacd=='lawex3'){
			goApi(datacd,"행정심판재결례",num);	
		}else if(datacd=='joyak'){
			goApi(datacd,"조약",num);	
		}else if(datacd=='word'){
			goApi(datacd,"법령용어",num);	
		}
		
	}
	//function openApi(addr){
	//	window.open(addr,'','width=1200,height=1000');
	//}
	var urlInfo;
	function openApi(addr){
		urlInfo = addr
		console.log("openApi urlInfo : " + urlInfo);
		//window.open(addr,'','width=1200,height=1000');
		 cw=562;
		 ch=420;
		  //스크린의 크기
		 sw=screen.availWidth;
		 sh=screen.availHeight;
		 //열 창의 포지션
		 px=(sw-cw)/2;
		 py=(sh-ch)/2;
		 //창을 여는부분
		property="left="+px+",top="+py+",width=1300,height=900,scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var pop_f;
		
		pop_f = window.open("popView.do",'klaw',property);
		//pop_f = window.open("popView.do",'klaw',property);
	}
	$(document).ready(function(){
		$(".datepick").datepicker({ 
			showOn:"both", 
			buttonImage:"./resources/images/btn_calendar.png",
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
		
	});

</script>
<%!
	private String trim(Object value) {
		return trim((String) value);
	}

	private String trimAndDot(Object value) {
		return trimAndDot((String) value);
	}

	private String trim(String value) {
		if (value == null || value.equals("null") || value.equals("NULL")) {
			return "";
		}
		return value.trim();
	}
%>
<%
request.setCharacterEncoding("utf-8");
String param_yn= trim(request.getParameter("param_yn"));
String param_index = trim(request.getParameter("param_index"));
String param_query = trim(request.getParameter("param_query"));
String param_pQuery_tmp = trim(request.getParameter("param_pQuery_tmp"));
String param_pageNo = trim(request.getParameter("param_pageNo"));
String param_listSize = trim(request.getParameter("param_listSize"));
String param_sort = trim(request.getParameter("param_sort"));
%>


<input type="hidden" id="hidden_schGbn"  />
<input type="hidden" id="hidden_consultGbn"  />
<input type="hidden" id="hidden_docGbn"  />
<input type="hidden" id="hidden_datepickStart"  />
<input type="hidden" id="hidden_datepickEnd"  />
<input type="hidden" id="hidden_fileGbn"  />
<input type="hidden" id="hidden_sortGbn"  value="<%=param_sort %>" />
<input type="hidden" id="hidden_txtSearchBar"  />
<input type="hidden" id="hidden_pastQuery" value="<%=param_query %>"/>
<input type="hidden" id="hidden_pQuery_tmp" value="<%=param_pQuery_tmp %>"/>
<input type="hidden" id="hidden_paramYN" value="<%=param_yn %>" />

<input type="hidden" id="hidden_indexKey" value="" />
<input type="hidden" id="hidden_pageNum" value="1" />
<input type="hidden" id="hidden_listNum" value="3" />


<script type="text/javascript" src="${resourceUrl}/search/js/search.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/param.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/mten.pagenav2.js"></script>
<div class="subCA">
	<div class="subTabW set7">
		<hr class="margin30">
		<ul>
			<li><a href="javascript:sendPost('./search.do')">전체</a></li>
			<li><a href="javascript:sendPost('./suitSearch.do')">소송</a></li>
			<li><a href="javascript:sendPost('./consultSearch.do')">자문</a></li>
			<li><a href="javascript:sendPost('./agreeSearch.do')">협약</a></li>
			<li><a href="javascript:sendPost('./lawSearch.do')" class="active">법률정보</a></li>
			<li><a href="javascript:sendPost('./pdsSearch.do')">자료실</a></li>
		</ul>
	</div>
	<div class="innerB">
		<table class="infoTable write">
			<colgroup>
				<col style="width: 10%; background-color:#e0e6ea;">
				<col style="width: 10%;">
				<col style="width: *;">
				<col style="width: 10%;">
				<col style="width: *;">
				<col style="width: 10%;">
				<col style="width: *;">
			</colgroup>
			<tr>
				<th>검색 조건</th>
				<td colspan="6">
					<input type="radio" name="schGbn" value="1" checked/> 제목　　
					<input type="radio" name="schGbn" value="2" /> 내용
				</td>
			</tr>
			<tr>
				<th>검색어</th>
				<td colspan="6">
					<input type="text" style="width:90%;" id="query" value="<%=query%>">
				</td>
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a href="javascript:void(0);" id="searchBtn" class="sBtn type1">검색</a> 
		<a href="javascript:init('');" class="sBtn type2">초기화</a>
	</div>
	<strong class="subTT" id="lawtit"></strong>
	<div>
		<div class="innerB srchResultW" id="law_datalist"></div>
		<div class="numberingW" id="law_pagelist"></div>
	</div>
	<strong class="subTT" id="bylawtit"></strong>
	<div>
		<div class="innerB srchResultW" id="bylaw_datalist"></div>
		<div class="numberingW" id="bylaw_pagelist"></div>
	</div>
	<strong class="subTT" id="slawtit"></strong>
	<div>
		<div class="innerB srchResultW" id="slaw_datalist"></div>
		<div class="numberingW" id="slaw_pagelist"></div>
	</div>
	<strong class="subTT" id="byultit"></strong>
	<div>
		<div class="innerB srchResultW" id="byul_datalist"></div>
		<div class="numberingW" id="byul_pagelist"></div>
	</div>
	<strong class="subTT" id="pantit"></strong>
	<div>
		<div class="innerB srchResultW" id="pan_datalist"></div>
		<div class="numberingW" id="pan_pagelist"></div>
	</div>
	<strong class="subTT" id="lawextit"></strong>
	<div>
		<div class="innerB srchResultW" id="lawex_datalist"></div>
		<div class="numberingW" id="lawex_pagelist"></div>
	</div>
	<!-- <strong class="subTT" id="lawex2tit"></strong>
	<div>
		<div class="innerB srchResultW" id="lawex2_datalist"></div>
		<div class="numberingW" id="lawex2_pagelist"></div>
	</div> -->
	<strong class="subTT" id="lawex3tit"></strong>
	<div>
		<div class="innerB srchResultW" id="lawex3_datalist"></div>
		<div class="numberingW" id="lawex3_pagelist"></div>
	</div>
	<strong class="subTT" id="joyaktit"></strong>
	<div>
		<div class="innerB srchResultW" id="joyak_datalist"></div>
		<div class="numberingW" id="joyak_pagelist"></div>
	</div>
	<strong class="subTT" id="wordtit"></strong>
	<div>
		<div class="innerB srchResultW" id="word_datalist"></div>
		<div class="numberingW" id="word_pagelist"></div>
	</div>
	
</div>