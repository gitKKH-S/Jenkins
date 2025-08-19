<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>


<script type="text/javascript" src="./resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="./resources/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="./resources/js/ext-base.js"></script>
<script type="text/javascript" src="./resources/js/ext-all-debug.js"></script>
<script type="text/javascript" src="./resources/js/ext-lang-ko.js"></script>

<link rel="stylesheet" href="./resources/css/jquery-ui.min.css">
<link rel="stylesheet" type="text/css" href="./resources/css/sub.css">
<link rel="stylesheet" type="text/css" href="./resources/css/table.css">
<link rel="stylesheet" type="text/css" href="./resources/css/extgrid.css">
<link rel="stylesheet" type="text/css" href="./resources/css/all.min.css" />
<link rel="stylesheet" type="text/css" href="./resources/css/search.css">
<link rel="stylesheet" href="./resources/css/ext-all.css">
<script>
	Ext.BLANK_IMAGE_URL = "./resources/images/default/s.gif";
</script>
<link rel="icon" type="image/ico" href="./resources/images/mten.ico"/>

<style>
	#workPage{min-width:1200px;}
	.logoW{cursor:pointer;}
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
		
		//$(".logoW").click(function(){
		//	location.href="/seoul/web/index.do";
		//});
		
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
			$(".subTT").html("자료실");
			searchSubmit();
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
	});

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
String pQuery_tmp = trim(request.getParameter("pQuery_tmp"));
%>
<input type="hidden" id="pQuery_tmp" value="<%=pQuery_tmp %>"/>

<input type="hidden" id="indexKey" />
<input type="hidden" id="pageNum" value="1" />
<input type="hidden" id="listNum" value="10" />

<input type="hidden" id="old_keyword" />
<input type="hidden" id="old_pQuery_tmp" />

<script type="text/javascript" src="${resourceUrl}/search/js/sweetalert2.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/param.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/pdsSearch.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/common.js"></script>

<div class="subCA">
	<div class="subTabW set7">
		<hr class="margin30">
		<ul>
			<li><a href="javascript:sendPost('./search.do')">전체</a></li>
			<li><a href="javascript:sendPost('./suitSearch.do')">소송</a></li>
			<li><a href="javascript:sendPost('./consultSearch.do')">자문</a></li>
			<li><a href="javascript:sendPost('./agreeSearch.do')">협약</a></li>
			<li><a href="javascript:sendPost('./lawSearch.do')">법률정보</a></li>
			<li><a href="javascript:sendPost('./pdsSearch.do')" class="active">자료실</a></li>
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
				<td colspan="4">
					<input type="radio" name="schGbn" value="" id="schGbn_0" checked/> 기본정보검색(제목+내용+작성자)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_title" id="schGbn_1" /> 제목&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_contents" id="schGbn_2" /> 내용&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="writer" id="schGbn_3" /> 작성자&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_attach" id="schGbn_4"/> 첨부파일검색
				</td>
				<th>정렬</th>
				<td>
					<select class="sortSelect" id="sortSelect"></select>
				</td>
			</tr>
			<tr>
				<th>검색어</th>
				<td colspan="6"><input type="text" style="width:80%;" id="schTxt" onkeyup="if(event.key === 'Enter') { searchSubmit(); }" placeholder="">&nbsp;&nbsp;
					<input type="checkbox" name="reSearch" value="" id="reSearch" onchange="changeRsCheck();" > 결과내 검색
				</td>
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a id="searchBtn" onclick="searchSubmit();" class="sBtn type1">검색</a> 
		<a href="javascript:init('');" class="sBtn type2">초기화</a>
	</div>
	<strong class="subTT">자료실&nbsp;<span id="pdsSearchCnt">(0건)</span></strong>
	<div class="innerB">
		<div class="srchResultW"  id="pds_data_list">
			<div class="ts_lt2"  style="text-align: center;">
				<div style="margin: 20px 0 20px 0;">
					<i data-feather="alert-circle" class="alert_icon"></i>
					<p style=" font-size: 20px; font-weight: 600; margin-bottom: 20px;"><span style=" color: #f62812; background-color: #fdf9be;"  id="noResultsKeyword"></span> 검색결과가 없습니다.</p>
					<p style="line-height: 180%;">단어의 철자가 정확한지 확인해 보세요.</p>
					<p style="line-height: 180%;">두 단어 이상의 검색어인 경우, 띄어쓰기를 확인해 보세요.</p>
					<p style="line-height: 180%;">검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해 보세요.</p>
				</div>
			</div>
		</div>
	</div>
	<div class="innerB">
		<div class="numberingW" id="pagelist">
		</div>
	</div>
</div>