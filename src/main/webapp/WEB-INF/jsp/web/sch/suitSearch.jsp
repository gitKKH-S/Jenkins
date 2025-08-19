<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<script>
	$(document).ready(function(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/getSuitTypeInfo.do",
			data:{"gbn":"list"},
			dataType:"json",
			async:false,
			success:function(result){
				var option1 = '<option value="">전체</option>';
				var option2 = '<option value="">전체</option>';
				var option3 = '<option value="">전체</option>';
				for(var i=0; i<result.result.length; i++){
					if(result.result[i].CD_LCLSF_ENG_NM == 'CASECD'){
						option1+="<option value='"+result.result[i].CD_MNG_NO+"'>"+result.result[i].CD_NM+"</option>"
					}else if(result.result[i].CD_LCLSF_ENG_NM == 'LWSTYPECD'){
						option2+="<option value='"+result.result[i].CD_MNG_NO+"'>"+result.result[i].CD_NM+"</option>"
					}else if(result.result[i].CD_LCLSF_ENG_NM == 'JDGMTGBN'){
						option3+="<option value='"+result.result[i].CD_MNG_NO+"'>"+result.result[i].CD_NM+"</option>"
					}
				}
				$("#INST_CD").append(option1);
				$("#LWS_UP_TYPE_CD").append(option2);
				$("#JDGM_UP_TYPE_CD").append(option3);
			}
		});
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/getProgListSch.do",
			dataType:"json",
			async:false,
			success:function(result){
				var option1 = '<option value="">전체</option>';
				for(var i=0; i<result.result.length; i++){
					option1+="<option value='"+result.result[i].CD_MNG_NO+"'>"+result.result[i].CD_NM+"</option>"
				}
				$("#LWS_PRGRS_STTS").append(option1);
			}
		});
		
	});
	
	function chgUpTypeCd (uptypecd) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectLwsLwrTypeCdList.do",
			data: {type:uptypecd},
			dataType:"json",
			async:false,
			success:setOptionList
		});
	}
	
	function setOptionList(data){
		$("#LWS_LWR_TYPE_CD").children('option').remove();
		var html="";
		
		if(data.result.length > 0){
			html += "<option value=''>선택</option>";
			$.each(data.result, function(index, val){
				if(LWS_LWR_TYPE_CD == val.CD_MNG_NO){
					html += "<option value='"+val.CD_MNG_NO+"' selected>"+val.CD_NM+"</option>";
				}else{
					html += "<option value='"+val.CD_MNG_NO+"'>"+val.CD_NM+"</option>";
				}
			});
		}
		
		$("#LWS_LWR_TYPE_CD").append(html);
	}
	
	function goSearchCourt(){
		var cw=500;
		var ch=700;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","courtSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "courtSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchCourtPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	/* function chSchGbn(gbn) {
		if ("S" == gbn) {
			$(".schSuitInfo").css("display", "");
			$(".schSuitFile").css("display", "none");
			$('#schTxt').attr('placeholder', '관리번호, 사건번호, 사건명, 사건개요, 쟁점사항, 비고, 소송상대방');
		} else {
			$(".schSuitInfo").css("display", "none");
			$(".schSuitFile").css("display", "");
			$('#schTxt').attr('placeholder', '검색어를 입력하세요');
		}
	} */
	
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
<script type="text/javascript" src="${resourceUrl}/search/js/common.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/suitSearch.js"></script>

<div class="subCA">
	<div class="subTabW set7">
		<hr class="margin30">
		<ul>
			<li><a href="javascript:sendPost('./search.do')" >전체</a></li>
			<li><a href="javascript:sendPost('./suitSearch.do')" class="active">소송</a></li>
			<li><a href="javascript:sendPost('./consultSearch.do')">자문</a></li>
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
					<input type="radio" name="schGbn" value="" id="schGbn_0" checked  onclick="chSchGbn(this.value);" />기본정보검색(제목+내용+사건번호)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_title" id="schGbn_1" onclick="chSchGbn(this.value);" /> 제목 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_contents" id="schGbn_2" onclick="chSchGbn(this.value);" /> 내용 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="incdnt_no" id="schGbn_3" onclick="chSchGbn(this.value);" /> 사건번호 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					<input type="radio" name="schGbn" value="field_attach" id="schGbn_4" onclick="chSchGbn(this.value);"/> 첨부파일검색
				</td>
				<th>정렬</th>
				<td>
					<select class="sortSelect" id="sortSelect"></select>
				</td>
			</tr>
			
			<tr class="msch">
				<th rowspan="4">기본검색조건</th>
				<th>심급</th>
				<td>
					<select id="INST_CD" name="INST_CD"></select>
				</td>
				<th>소송유형</th>
				<td>
					<select name="LWS_UP_TYPE_CD" id="LWS_UP_TYPE_CD" onchange="chgUpTypeCd(this.value);"></select>
					<select name="LWS_LWR_TYPE_CD" id="LWS_LWR_TYPE_CD"></select>
				</td>
				<th>재판결과</th>
				<td>
					<select id="JDGM_UP_TYPE_CD" name="JDGM_UP_TYPE_CD"></select>
				</td>
			</tr>
			
			<tr class="msch">
				<th>문서번호</th>
				<td>
					<input type="text" name="LWS_NO" id="LWS_NO">
				</td>
				<th>주관부서</th>
				<td>
					<input type="text" name="SPRVSN_DEPT_NM" id="SPRVSN_DEPT_NM">
				</td>
				<th>주관부서 담당자</th>
				<td>
					<input type="text" name="SPRVSN_EMP_NM" id="SPRVSN_EMP_NM">
				</td>
			</tr>
			<tr class="msch">
				<th>내부담당자</th>
				<td>
					<input type="text" name="CHR_EMPNM" id="CHR_EMPNM">
				</td>
				<th>대리인</th>
				<td>
					<input type="text" name="LWYR_NM" id="LWYR_NM">
				</td>
				<th colspan="2"></th>
			</tr>
			<tr class="msch">
				<th>소제기일</th>
				<td>
					<input type="text" class="datepick" style="width:80px;" id="datepickStart"> ~
					<input type="text" class="datepick" style="width:80px;" id="datepickEnd">
				</td>
				<th>관할법원</th>
				<td>
					<input type="hidden" name="CT_CD" id="CT_CD">
					<input type="text"   name="CT_NM" id="CT_NM" readonly="readonly" onclick="goSearchCourt();">
					<a href="#none" class="innerBtn" onclick="goSearchCourt();">검색</a>
				</td>
				<th>진행상태</th>
				<td>
					<select id="LWS_PRGRS_STTS" name="LWS_PRGRS_STTS"></select>
				</td>
			</tr>
			<tr id="fsch" >
				<th>파일유형</th>
				<td colspan="6">
					<input type="checkbox" id="file_gbn_0" name="FILE_SE_NM" value=""> 전체
					<input type="checkbox" id="file_gbn_1" name="FILE_SE_NM" value="입증자료"> 입증자료 &nbsp;
					<input type="checkbox" id="file_gbn_2" name="FILE_SE_NM" value="소장"> 소장 &nbsp;
					<input type="checkbox" id="file_gbn_3" name="FILE_SE_NM" value="판결문"> 판결문 &nbsp;
					<input type="checkbox" id="file_gbn_4" name="FILE_SE_NM" value="제출송달"> 제출송달 &nbsp;
					<input type="checkbox" id="file_gbn_5" name="FILE_SE_NM" value="비용"> 비용 &nbsp;
					<input type="checkbox" id="file_gbn_6" name="FILE_SE_NM" value="위임"> 위임 &nbsp;
					<input type="checkbox" id="file_gbn_7" name="FILE_SE_NM" value="채권"> 채권 &nbsp;
					<input type="checkbox" id="file_gbn_8" name="FILE_SE_NM" value="보고"> 보고 &nbsp;
					<input type="checkbox" id="file_gbn_9" name="FILE_SE_NM" value="검토진행"> 검토진행 &nbsp;
					<input type="checkbox" id="file_gbn_10" name="FILE_SE_NM" value="기타"> 기타
				</td>
			</tr>
			<tr>
				<th>검색어</th>
				<td colspan="6">
				<input style="width:80%" type="text" id="schTxt" name="schTxt" onkeyup="if(event.key === 'Enter') { searchSubmit(); }" placeholder="">
				&nbsp;&nbsp;<input type="checkbox" name="reSearch" value="" id="reSearch" onchange="changeRsCheck();" > 결과내 검색　
				</td>
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a id="searchBtn" onclick="searchSubmit();" class="sBtn type1">검색</a> 
		<a href="javascript:init('');" class="sBtn type2">초기화</a>
	</div>
	<strong class="subTT">소송&nbsp;<span id="suitSearchCnt">(0건)</span></strong>
	<div class="innerB" >
	
		<div class="innerB">
			<div class="srchResultW" id="suit_data_list">
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
	</div>
	
	<div class="innerB">
		<div class="numberingW" id="pagelist">
		</div>
	</div>
</div>