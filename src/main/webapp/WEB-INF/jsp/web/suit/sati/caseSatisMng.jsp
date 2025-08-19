<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%
	String satisitemid = "";
	String item = "";
	String useyn = "";
	String writercd = "";
	String itemtype = "";
	
	String suitid = request.getAttribute("suitid")==null?"0":request.getAttribute("suitid").toString();
	String caseid = request.getAttribute("caseid")==null?"0":request.getAttribute("caseid").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	List satisList = request.getAttribute("satisMap")==null?new ArrayList():(ArrayList)request.getAttribute("satisMap");
%>
<script>
	function insertSatisitem(){
		$("#gbn").val("<%=gbn%>");
		
		$.ajax({
			type:"POST",
			url : "${pageContext.request.contextPath}/web/suit/insertSatisitem.do",
			data : $('#inputFrm').serializeArray(),
			dataType: "json",
			async: false,
			success : function(result){
				alert(result.msg);
				location.reload();
			}
		});
	}
	
	function reset() {
		document.inputFrm.reset();
		$("#DGSTFN_SRVY_MNG_NO").val("");
	}
	
	function inputForm (DGSTFN_SRVY_MNG_NO,DGSTFN_SRVY_TRGT_SE,DGSTFN_EVL_TYPE_NM,DGSTFN_SRVY_CN,USE_YN,
			FST_ANS_ARTCL_NM, SEC_ANS_ARTCL_NM, THR_ANS_ARTCL_NM, FOUR_ANS_ARTCL_NM, FIFTH_ANS_ARTCL_NM){
		var frm = document.inputFrm;
		frm.DGSTFN_SRVY_MNG_NO.value  = DGSTFN_SRVY_MNG_NO;
		frm.DGSTFN_SRVY_TRGT_SE.value = DGSTFN_SRVY_TRGT_SE;
		frm.DGSTFN_EVL_TYPE_NM.value  = DGSTFN_EVL_TYPE_NM;
		frm.DGSTFN_SRVY_CN.value      = DGSTFN_SRVY_CN;
		frm.USE_YN.value              = USE_YN;
		frm.FST_ANS_ARTCL_NM.value    = FST_ANS_ARTCL_NM;
		frm.SEC_ANS_ARTCL_NM.value    = SEC_ANS_ARTCL_NM;
		frm.THR_ANS_ARTCL_NM.value    = THR_ANS_ARTCL_NM;
		frm.FOUR_ANS_ARTCL_NM.value   = FOUR_ANS_ARTCL_NM;
		frm.FIFTH_ANS_ARTCL_NM.value  = FIFTH_ANS_ARTCL_NM;
	}
</script>
<form name="inputFrm" id="inputFrm" method="post">
	<input type="hidden" name="DGSTFN_SRVY_MNG_NO" id="DGSTFN_SRVY_MNG_NO" value=""/>
	<input type="hidden" name="SRVY_SE"            id="SRVY_SE"            value="<%=gbn%>"/>
	<input type="hidden" name="gbn"                id="gbn"                value="<%=gbn%>"/>
	<input type="hidden" name="WRTR_EMP_NM"        id="WRTR_EMP_NM"        value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"        id="WRTR_EMP_NO"        value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"        id="WRT_DEPT_NO"        value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"        id="WRT_DEPT_NM"        value="<%=WRT_DEPT_NM%>" />
	<div class="subCA">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">만족도평가 항목관리</strong>
			</div>
		</div>	
		<hr class="margin40">
		<div class="innerB" >
			<table class="infoTable write" style="width:100%;">
				<colgroup>
					<col style="width:10%;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:10%;">
				</colgroup>
				<tr>
					<th>작성부서</th>
					<th>평가유형</th>
					<th>질문/답변</th>
					<th>사용여부</th>
					<th>수정</th>
				</tr>
				<%
				for (int i=0; i<satisList.size();i++){ 
					HashMap map = (HashMap)satisList.get(i);
					System.out.println(map);
				%>
				<tr>
					<td align="center" rowspan="2"><%=map.get("DGSTFN_SRVY_TRGT_NM") %></td>
					<td align="center" rowspan="2"><%=map.get("DGSTFN_EVL_TYPE_NM") %></td>
					<td align="center" ><%=map.get("DGSTFN_SRVY_CN") %></td>
					<td align="center" rowspan="2"><%="Y".equals(map.get("USE_YN").toString())?"사용":"사용안함" %></td>
					<td align="center" rowspan="2">
						<a href="#none" class="sBtn type1"
						 onclick="inputForm('<%=map.get("DGSTFN_SRVY_MNG_NO")%>','<%=map.get("DGSTFN_SRVY_TRGT_SE")%>','<%=map.get("DGSTFN_EVL_TYPE_NM")%>','<%=map.get("DGSTFN_SRVY_CN")%>',
						      '<%=map.get("USE_YN")%>','<%=map.get("FST_ANS_ARTCL_NM")%>','<%=map.get("SEC_ANS_ARTCL_NM")%>','<%=map.get("THR_ANS_ARTCL_NM")%>','<%=map.get("FOUR_ANS_ARTCL_NM")%>','<%=map.get("FIFTH_ANS_ARTCL_NM")%>');">수정</a>
					</td>
				</tr>
				<tr>
					<td>1) <%=map.get("FST_ANS_ARTCL_NM") %>&nbsp; 2) <%=map.get("SEC_ANS_ARTCL_NM") %>&nbsp; 3) <%=map.get("THR_ANS_ARTCL_NM") %>&nbsp; 4)<%=map.get("FOUR_ANS_ARTCL_NM") %>&nbsp; 5) <%=map.get("FIFTH_ANS_ARTCL_NM") %></td>
				</tr>
				<%} %>
			</table>
			<hr class="margin20">
			<table class="infoTable write" style="width:100%;">
				<colgroup>
					<col style="width:20%;">
					<col style="width:30%;">
					<col style="width:20%;">
					<col style="width:30%;">
				</colgroup>
				<tr>
					<th>작성부서</th>
					<td>
						<select name="DGSTFN_SRVY_TRGT_SE" style="width:50%;">
							<option value="L">법무팀</option>
							<option value="N">수행부서</option>
						</select>
					</td>
					<th>사용여부</th>
					<td>
						<select name="USE_YN">
							<option value="Y">사용</option>
							<option value="N">사용안함</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>평가유형</th>
					<td colspan="3"><input type="text" id="DGSTFN_EVL_TYPE_NM" name="DGSTFN_EVL_TYPE_NM" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>질문지</th>
					<td colspan="3"><input type="text" id="DGSTFN_SRVY_CN" name="DGSTFN_SRVY_CN" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지1 (5)</th>
					<td colspan="3"><input type="text" id="FST_ANS_ARTCL_NM" name="FST_ANS_ARTCL_NM" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지2 (4)</th>
					<td colspan="3"><input type="text" id="SEC_ANS_ARTCL_NM" name="SEC_ANS_ARTCL_NM" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지3 (3)</th>
					<td colspan="3"><input type="text" id="THR_ANS_ARTCL_NM" name="THR_ANS_ARTCL_NM" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지4 (2)</th>
					<td colspan="3"><input type="text" id="FOUR_ANS_ARTCL_NM" name="FOUR_ANS_ARTCL_NM" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지5 (1)</th>
					<td colspan="3"><input type="text" id="FIFTH_ANS_ARTCL_NM" name="FIFTH_ANS_ARTCL_NM" style="width:90%;"/></td>
				</tr>
			</table>
			<hr class="margin10">
			<div style="text-align: right;">
				<a href="#none" class="sBtn type1" onclick="javascript:insertSatisitem();">저장</a>
				<a href="#none" class="sBtn type1" onclick="javascript:reset();">취소</a>
			</div>
		</div>
	</div>	
</form>