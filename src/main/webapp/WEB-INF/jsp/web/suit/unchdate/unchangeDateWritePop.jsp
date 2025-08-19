<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String UNCH_DATE_MNG_NO = request.getAttribute("UNCH_DATE_MNG_NO")==null?"":request.getAttribute("UNCH_DATE_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	HashMap map = request.getAttribute("map")==null?new HashMap():(HashMap)request.getAttribute("map");
	String REL_ARTCL_SE = map.get("REL_ARTCL_SE")==null?"":map.get("REL_ARTCL_SE").toString();
	String REL_ARTCL_TYPE_CD = map.get("REL_ARTCL_TYPE_CD")==null?"":map.get("REL_ARTCL_TYPE_CD").toString();
	String INV_SE = map.get("INV_SE")==null?"":map.get("INV_SE").toString();
	String NOTI_YN = map.get("NOTI_YN")==null?"":map.get("NOTI_YN").toString();
	String USE_YN = map.get("USE_YN")==null?"":map.get("USE_YN").toString();
	String NOTI_INV = map.get("NOTI_INV")==null?"":map.get("NOTI_INV").toString();
%>
<script type="text/javascript">
	var UNCH_DATE_MNG_NO = "<%=UNCH_DATE_MNG_NO%>";
	var REL_ARTCL_SE = "<%=REL_ARTCL_SE%>";
	var REL_ARTCL_TYPE_CD = "<%=REL_ARTCL_TYPE_CD%>";
	var NOTI_INV = "<%=NOTI_INV%>";
	
	$(document).ready(function(){
		setRelCode(REL_ARTCL_SE);
		
		if(UNCH_DATE_MNG_NO != "") {
			var term = document.getElementsByName("noticeterm[]");
			var leng = term.length;
			var cnt = 0;
			for(var i=0; i < leng; i++ ){
				if(NOTI_INV.indexOf(term[i].value) > -1){
					term[i].checked = true;
				}
			}
		}
	});
	
	function setRelCode(gbn){
		$("#REL_ARTCL_TYPE_CD").children('option').remove();
		
		var type;
		if(gbn == "DATE" || gbn == ""){
			type = "DATEGBN";
		}else{
			type = "DOCGBN";
		}
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectOptionList.do",
			data:{"type":type},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				html += "<option value=\"\">선택</option>";
				for(var i=0; i<result.result.length; i++){
					html += "<option value='"+result.result[i].CD_MNG_NO+"'>"+result.result[i].CD_NM+"</option>"
				}
				$("#REL_ARTCL_TYPE_CD").append(html);
				
				if(REL_ARTCL_TYPE_CD != ""){
					$("#REL_ARTCL_TYPE_CD").val(REL_ARTCL_TYPE_CD).prop("selected", true);
				}
			}
		});
	}
	
	function infoSave(){
		var INV_DAY_CNT_IN = $("#INV_DAY_CNT_IN").val();
		var INV_SE = $("#INV_SE option:selected").val();
		var REL_ARTCL_TYPE_CD = $("#REL_ARTCL_TYPE_CD").val();
		
		var numbers = /^[-+]?[0-9]+$/;
		
		var term = document.getElementsByName("noticeterm[]");
		var leng = term.length;
		var cnt = 0;
		for(var i=0; i < leng; i++ ){
			if(term[i].checked == true){
				cnt += 1;
			}
		}
		
		if($("#UNCH_DATE_NM").val() == "") {
			return alert("불변기일명을 입력 해 주세요");
		}
		
		if(INV_DAY_CNT_IN == "" || INV_SE == ""){
			return alert("기간을 정확히 입력 해 주세요");
		}
		
		if(INV_DAY_CNT_IN.match(numbers) == null){
			return alert("기간은 숫자로 입력하세요");
		}
		
		if(REL_ARTCL_TYPE_CD == "" || REL_ARTCL_TYPE_CD == null){
			return alert("기일을 적용 할 기일/서면 종류를 선택하세요");
		}
		
		if ($("#NOTI_YN").val() == "Y" && cnt == 0){
			return alert("알림 간격을 입력하세요");
		}
		
		var termday;
		if(INV_SE == 'M'){
			termday = INV_DAY_CNT_IN * 30;
		}else if(INV_SE == 'Y'){
			termday = INV_DAY_CNT_IN * 30 * 12;
		}else{
			termday = INV_DAY_CNT_IN;
		}
		$("#INV_DAY_CNT").val(termday);
		
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/UnchDateInfoSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				opener.goReLoad();
				window.close();
			}
		});
	}
</script>
<style>
	#noti {color:white; display: inline; position: relative; top: 6px; margin-left: 10px; font-size: 12px;}
</style>
<strong class="popTT">
	불변 기일 정보
	<p id="noti">* 표시는 필수입력사항입니다.</p>
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="INV_DAY_CNT"        id="INV_DAY_CNT"        value="" />
	<input type="hidden" name="UNCH_DATE_MNG_NO"   id="UNCH_DATE_MNG_NO"   value="<%=UNCH_DATE_MNG_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"           id="WRTR_EMP_NM"           value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"         id="WRTR_EMP_NO"         value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"           id="WRT_DEPT_NO"           value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"         id="WRT_DEPT_NM"         value="<%=WRT_DEPT_NM%>" />
	<div class="popC" style="height:500px;">
		<div class="popA">
			<table class="pop_infoTable write" style="width:100%;">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>불변기일명 <sup>*</sup></th>
					<td colspan="3">
						<input type="text" style="width:90%" name="UNCH_DATE_NM" id="UNCH_DATE_NM" value="<%=map.get("UNCH_DATE_NM")==null?"":map.get("UNCH_DATE_NM").toString()%>" />
					</td>
				</tr>
				<tr>
					<th>구분 <sup>*</sup></th>
					<td>
						<input type="radio" name="REL_ARTCL_SE" id='relgbnD' value="DATE" onclick="setRelCode(this.value);" <%if("DATE".equals(REL_ARTCL_SE) || REL_ARTCL_SE.equals("")) out.println("checked");%>> 기일
						<input type="radio" name="REL_ARTCL_SE" id='relgbnO' value="DOC"  onclick="setRelCode(this.value);" <%if("DOC".equals(REL_ARTCL_SE)) out.println("checked");%>> 서면
					</td>
					<th>종류 <sup>*</sup></th>
					<td>
						<select id="REL_ARTCL_TYPE_CD" name="REL_ARTCL_TYPE_CD"></select>
					</td>
				</tr>
				<tr>
					<th>기간 <sup>*</sup></th>
					<td colspan="3" id="term">
 						<input type="text" id="INV_DAY_CNT_IN" name="INV_DAY_CNT_IN" value="<%=map.get("INV_DAY_CNT")==null?"":map.get("INV_DAY_CNT").toString()%>"/>
						<select id="INV_SE" name="INV_SE">
							<option value="D"  <%if("D".equals(INV_SE) || INV_SE.equals("")) out.println("selected");%>>일</option>
							<option value="M"  <%if("M".equals(INV_SE)) out.println("selected");%>>개월</option>
							<option value="Y"  <%if("Y".equals(INV_SE)) out.println("selected");%>>년</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>설명</th>
					<td colspan="3">
						<textarea rows="" cols="" name="UNCH_DATE_CN" id="UNCH_DATE_CN"><%=map.get("UNCH_DATE_CN")==null?"":map.get("UNCH_DATE_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>사용여부 <sup>*</sup></th>
					<td>
						<select name="USE_YN" id="USE_YN">
							<option value="Y" <%if("Y".equals(USE_YN) || USE_YN.equals("")) out.println("selected");%>>Y</option>
							<option value="N" <%if("N".equals(USE_YN)) out.println("selected");%>>N</option>
						</select>
					</td>
					<th>알림여부 <sup>*</sup></th>
					<td>
						<select name="NOTI_YN" id="NOTI_YN">
							<option value="Y" <%if("Y".equals(NOTI_YN) || NOTI_YN.equals("")) out.println("selected");%>>Y</option>
							<option value="N" <%if("N".equals(NOTI_YN)) out.println("selected");%>>N</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>알림간격 <sup>*</sup></th>
					<td colspan="3">
						<input type="checkbox" name="noticeterm[]" value="0"> 당일
						<input type="checkbox" name="noticeterm[]" value="1"> 1일 전
						<input type="checkbox" name="noticeterm[]" value="2"> 2일 전
						<input type="checkbox" name="noticeterm[]" value="3"> 3일 전
						<input type="checkbox" name="noticeterm[]" value="4"> 4일 전
						<input type="checkbox" name="noticeterm[]" value="5"> 5일 전
						<input type="checkbox" name="noticeterm[]" value="6"> 6일 전
						<input type="checkbox" name="noticeterm[]" value="7"> 7일 전
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" id="saveBtn" onclick="infoSave();"><i class="fa-solid fa-file-import"></i> 등록</a>
		</div>
	</div>
</form>