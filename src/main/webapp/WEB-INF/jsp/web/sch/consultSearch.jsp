<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
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
<script>
	$(document).ready(function(){
		$("#txtSearchBar").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("#searchBtn").click(function(){
			$(".subTT").html("자문");
			searchSubmit();
		});
	});
</script>
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
<script type="text/javascript" src="${resourceUrl}/search/js/common.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/consultSearch.js"></script>
<div class="subCA">
	<div class="subTabW set7">
		<hr class="margin30">
		<ul>
			<li><a href="javascript:sendPost('./search.do')">전체</a></li>
			<li><a href="javascript:sendPost('./suitSearch.do')">소송</a></li>
			<li><a href="javascript:sendPost('./consultSearch.do')" class="active">자문</a></li>
			<li><a href="javascript:sendPost('./agreeSearch.do')">협약</a></li>
			<li><a href="javascript:sendPost('./lawSearch.do')">법률정보</a></li>
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
			<th>검색조건</th>
				<td colspan="4"> 
					<input type="radio" name="schGbn" value="" id="schGbn_0"  onclick="chSchGbn(this.value);" checked />기본정보검색(제목+내용)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_title" id="schGbn_1" onclick="chSchGbn(this.value);"  /> 제목 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_contents" id="schGbn_2" onclick="chSchGbn(this.value);" /> 내용 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_attach" id="schGbn_3" onclick="chSchGbn(this.value);" /> 첨부파일검색
				</td>
				<th>정렬</th>
				<td>
					<select class="sortSelect" id="sortSelect"></select>
				</td>
			</tr>
			
			<tr class="msch">
				<th rowspan="3">기본검색조건</th>
				<th>자문구분</th>
				<td>
					<input type="checkbox" name="INSD_OTSD_TASK_SE" value=""  id="consult_gbn_0">전체 &nbsp;
					<input type="checkbox" name="INSD_OTSD_TASK_SE" value="I"  id="consult_gbn_1">내부자문 &nbsp;
					<input type="checkbox" name="INSD_OTSD_TASK_SE" value="O" id="consult_gbn_2">외부자문
				</td>
				<th>구분</th>
				<td>
					<input type="checkbox" name="CNSTN_GBN" value="" checked="checked" id="doc_gbn_0">전체&nbsp;
					<input type="checkbox" name="CNSTN_GBN" value="자문의뢰"  id="doc_gbn_1">자문의뢰&nbsp;
					<input type="checkbox" name="CNSTN_GBN" value="자문검토의견" id="doc_gbn_2">자문검토의견
				</td>
				<th>의뢰일</th>
				<td>
					<input type="text" class="datepick" style="width:80px;" id="datepickStart"> ~
					<input type="text" class="datepick" style="width:80px;" id="datepickEnd">
				</td>
			</tr>
			
			<tr class="msch">
				<th>법률/계약전문관</th>
				<td>
					<input type="text" name="CNSTN_TKCG_EMP_NM" id="CNSTN_TKCG_EMP_NM">
				</td>
				<th>위임/자문변호사</th>
				<td>
					<input type="text" name="JDAF_CORP_EMP_NMS" id="JDAF_CORP_EMP_NMS">
				</td>
				<th colspan="2"></th>
			</tr>
			<tr class="msch">
				<th>의뢰부서</th>
				<td>
					<input type="text" name="CNSTN_RQST_DEPT_NM" id="CNSTN_RQST_DEPT_NM">
				</td>
				<th>의뢰자</th>
				<td>
					<input type="text" name="CNSTN_RQST_EMP_NM" id="CNSTN_RQST_EMP_NM">
				</td>
				<th>관리번호</th>
				<td>
					<input type="text" name="CNSTN_DOC_NO" id="CNSTN_DOC_NO">
				</td>
			</tr>
			
			<tr class="fsch">
				<th>파일유형</th>
				<td colspan="6">
					<input type="checkbox" name="FILE_SE_NM" value="" checked="checked" id="file_gbn_0">전체&nbsp;
					<input type="checkbox" name="FILE_SE_NM" value="자문의뢰" 	id="file_gbn_1">자문의뢰&nbsp;
					<input type="checkbox" name="FILE_SE_NM" value="자문답변" 	id="file_gbn_2">자문답변&nbsp;
					<input type="checkbox" name="FILE_SE_NM" value="기타" 	id="file_gbn_2">기타
				</td>
				<!-- <th>정렬</th>
				<td>
					<select id="sortSelect" class="sortSelect"></select>
				</td> -->
			</tr>
			<tr>
				<th>검색어</th>
				<td colspan="6">
					<input style="width:80%" type="text" id="schTxt" name="schTxt" onkeyup="if(event.key === 'Enter') { searchSubmit(); }" placeholder="관리번호, 사건번호, 사건명, 사건개요, 쟁점사항, 비고, 원고, 피고">
					&nbsp;&nbsp;<input type="checkbox" name="reSearch" value="" id="reSearch" onchange="changeRsCheck();" > 결과내 검색　
				</td>
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a id="searchBtn" onclick="searchSubmit();" class="sBtn type1">검색</a>
		<a href="javascript:init('');" class="sBtn type2">초기화</a>
	</div>
	<strong class="subTT">자문&nbsp;<span id="cnsultSearchCnt">(0건)</span></strong>
	<div class="innerB" >
		<div class="srchResultW" id="consult_data_list">
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