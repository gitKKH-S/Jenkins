<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mten.bylaw.*" %>
<%@ page import="com.mten.bylaw.bylaw.service.*" %>
<%
	BylawService service = BylawServiceHelper.getBylawService(application);
	HashMap dpara = new HashMap();
	dpara.put("root", ConstantCode.DEPTROOT);
	dpara.put("dept", "");
	String deptselectbox = service.setDeptNameList(dpara);
%>
<link href="${resourceUrl}/select2-4.0.1/dist/css/select2.min.css" type="text/css" rel="stylesheet" />
<%-- <script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/jquery.min.js"></script> --%>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/dist/js/select2.full.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/prettify.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/placeholders.jquery.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/dist/js/i18n/es.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/dist/js/select2.js"></script> 
<script type="text/javascript" src="${resourceUrl}/high1/js/jquery.form.js"></script>
<script>
	Ext.BLANK_IMAGE_URL = "./resources/images/default/s.gif";
</script>
<link rel="icon" type="image/ico" href="./resources/images/mten.ico"/>

<style>
	#workPage{min-width:1200px;}
	.logoW{cursor:pointer;}
</style>
<!--# 디자인 맞추기  -->


<style>
	 .select2-container .select2-selection--single{
	 	height:30px;
	 	border-radius:0px;
	 }
</style>
<script>
	$(document).ready(function() { 
		$("#ehkk").select2();		// ???
				
		$("#txtSearchBar").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("#searchBtn").click(function(){
			$(".subTT").html("자치법규");
			searchSubmit();
		});
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
<style>
	#clickImg{
		height:20px;
		position:absolute;
		margin-left:10px;
	}
</style>

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

<input type="hidden" id="hidden_indexKey" />
<input type="hidden" id="hidden_pageNum" value="1" />
<input type="hidden" id="hidden_listNum" value="10" />

<script type="text/javascript" src="${resourceUrl}/search/js/regulationSearch.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/param.js"></script>
<div class="subCA">
	<div class="subTabW set7">
		<hr class="margin30">
		<ul>
			<li><a href="javascript:sendPost('./search.do')">전체</a></li>
			<li><a href="javascript:sendPost('./suitSearch.do')">소송·심판</a></li>
			<li><a href="javascript:sendPost('./consultSearch.do')">자문</a></li>
			<li><a href="javascript:sendPost('./agreeSearch.do')">협약</a></li>
			<li><a href="javascript:sendPost('./regulationSearch.do')" class="active">자치법규</a></li>
			<li><a href="javascript:sendPost('./lawSearch.do')">법률정보<img id="clickImg" alt="Click" src="${resourceUrl}/images/tap2.png" /></a></li>
			<li><a href="javascript:sendPost('./pdsSearch.do')">자료실</a></li>
			<li><a href="javascript:sendPost('./contractSearch.do')">게시판</a></li>
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
			</colgroup>
			<tr>
				<th>검색조건</th>
				<td colspan="4">
					<input type="radio" name="schGbn" value="META" id="schGbn_0" checked/>기본정보검색(제목+내용)   
					<input type="radio" name="schGbn" value="META" id="schGbn_1"/> 제목　　　　
					<input type="radio" name="schGbn" value="META" id="schGbn_2"/> 내용　　　　
					<input type="radio" value="FILE" name="schGbn" id="schGbn_3"/> 첨부파일검색
				</td>
			</tr>
			<tr class="msch">
				<th rowspan="2">기본검색조건</th>
				<th>자치법규 구분</th>
				<td>
					<input type="checkbox" name="docgbn" value=""
					 id="ruleGbn_0" onchange="checkboxChanged(this)">전체　
					<input type="checkbox" name="docgbn" value="" 
					id="ruleGbn_1" onchange="checkboxChanged(this)">조례　
					<input type="checkbox" name="docgbn" value=""
					 id="ruleGbn_2" onchange="checkboxChanged(this)">훈령
					<input type="checkbox" name="docgbn" value=""
					 id="ruleGbn_3" onchange="checkboxChanged(this)">규정
					<input type="checkbox" name="docgbn" value=""
					 id="ruleGbn_4" onchange="checkboxChanged(this)">규칙
					<input type="checkbox" name="docgbn" value=""
					 id="ruleGbn_5" onchange="checkboxChanged(this)">예규
					<input type="checkbox" name="docgbn" value=""
					 id="ruleGbn_6" onchange="checkboxChanged(this)">의회규칙
					<input type="checkbox" name="docgbn" value=""
					 id="ruleGbn_7" onchange="checkboxChanged(this)">의회훈령
				</td>
				<th>소관부서</th>
				<td>
					<select name="DeptnameSel"  id="ehkk" style="width:205px">
						<%=deptselectbox %>
					</select>
				</td>
			</tr>
			<tr class="msch">
				<th>연혁 구분</th>
				<td>
					<input type="checkbox" name="docgbn" value=""
					 id="stateGbn_0"  onchange="checkboxChanged(this)">전체　
					<input type="checkbox" name="docgbn" value=""
					 id="stateGbn_1"  onchange="checkboxChanged(this)">현행　
					<input type="checkbox" name="docgbn" value=""
					 id="stateGbn_2"  onchange="checkboxChanged(this)">페지　
					<input type="checkbox" name="docgbn" value=""
					 id="stateGbn_3"  onchange="checkboxChanged(this)">연혁
				</td>
				<th>공포일</th>
				<td>
					<input type="text" class="datepick" style="width:80px;" id="datepickStart"> ~
					<input type="text" class="datepick" style="width:80px;" id="datepickEnd">
				</td>
			</tr>
			<tr class="fsch">
				<th>첨부파일</th>
				<td colspan="2">
					<input type="checkbox" name="docgbn" value="" onchange="checkboxChanged(this)"
					id="file_gbn_0">전체　
					<input type="checkbox" name="docgbn" value="" onchange="checkboxChanged(this)"
					id="file_gbn_1">별표　
					<input type="checkbox" name="docgbn" value="" onchange="checkboxChanged(this)"
					id="file_gbn_2">별지서식　
					<input type="checkbox" name="docgbn" value="" onchange="checkboxChanged(this)"
					id="file_gbn_3">별첨　
				</td>
				<th>정렬</th>
				<td>
					<select class="sortSelect" id="sortSelect"></select>
				</td>
			</tr>
			<tr>
				<th>검색어</th>
				<td colspan="4">
				<input type="text" style="width:90%;" id="txtSearchBar">&nbsp;&nbsp;
					<input type="checkbox" name="reSearch" value="" id="reSearch"> 결과내 검색
				</td>
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a id="searchBtn" class="sBtn type1">검색</a> 
		<a href="javascript:init('');" class="sBtn type2">초기화</a>
	</div>
	<strong class="subTT">자치법규</strong>
	<div class="innerB" id="rule_data_list"></div>
	<div class="innerB">
		<div class="numberingW" id="pagelist">
			<!-- <span class="n_first"><a href="">처음</a></span>
			<span class="n_before"><a href="">이전</a></span>
			<ul>
				<li><a href="">《</a></li>
				<li><a href="">〈</a></li>
				<li class="active"><a href="">1</a></li>
				<li><a href="">2</a></li>
				<li><a href="">3</a></li>
				<li><a href="">4</a></li>
				<li><a href="">5</a></li>
				<li><a href="">6</a></li>
				<li><a href="">〉</a></li>
				<li><a href="">》</a></li>
			</ul>
			<span class="n_next"><a href="">다음</a></span>
			<span class="n_last"><a href="">끝</a></span> -->
		</div>
	</div>
</div>