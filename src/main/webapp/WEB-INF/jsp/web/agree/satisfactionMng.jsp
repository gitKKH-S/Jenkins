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
	
	ConsultService consultService = ConsultServiceHelper.getConsultService(application);
	HashMap param = new HashMap();
	List list = consultService.getSatisitemList(param);
	
	String gbn = "AGREE";
%>
<script>
function saveSatisitem4Ajax(){
	
	$("#gbn").val("<%=gbn%>");
	
	$.ajax({
        type:"POST",
        url : "${pageContext.request.contextPath}/web/agree/saveSatisitem4Ajax.do",
        data : $('#inputFrm').serializeArray(),
        dataType: "json",
        async: false,
        success : function(result){
            if(result.data.msg =='ok'){
            	alert("저장되었습니다.");
            	document.inputFrm.reset();
            }
        }
    })
}

function inputForm(satisitemid,writercd,itemtype,item,useyn,ans1,ans2,ans3,ans4,ans5){
	var frm = document.inputFrm;
	frm.satisitemid.value = satisitemid;
	frm.writercd.value = writercd;
	frm.itemtype.value = itemtype;
	frm.item.value = item;
	frm.useyn.value = useyn;
	frm.ans1.value = ans1;
	frm.ans2.value = ans2;
	frm.ans3.value = ans3;
	frm.ans4.value = ans4;
	frm.ans5.value = ans5;
}

</script>
<form name="inputFrm" id="inputFrm" method="post">
	<input type="hidden" name="satisitemid" id="satisitemid" />
	<input type="hidden" name="gbn" id="gbn" value="<%=gbn%>"/>
	<div class="subCA">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">만족도평가 항목관리</strong>
			</div>
		</div>	
		<hr class="margin40">
		<div class="innerB" >
			<table class="infoTable write">
				<colgroup>
					<col style="width:10%;">
					<col style="width:20%;">
					<col style="width:50%;">
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
				<%for (int i=0; i<list.size();i++){ 
					HashMap map = (HashMap)list.get(i);
				%>
				<tr>
					<td align="center" rowspan="2"><%="L".equals(map.get("writercd").toString())?"주관부서(송무팀)":"소관부서" %></td>
					<td align="center" rowspan="2"><%=map.get("itemtype") %></td>
					<td><%=map.get("item") %></td>
					<td align="center" rowspan="2"><%="Y".equals(map.get("useyn").toString())?"사용":"사용안함" %></td>
					<td align="center" rowspan="2"><a href="#none" class="sBtn type1" onclick="inputForm('<%=map.get("satisitemid")%>','<%=map.get("writercd")%>','<%=map.get("itemtype")%>','<%=map.get("item")%>','<%=map.get("useyn")%>','<%=map.get("ans1")%>','<%=map.get("ans2")%>','<%=map.get("ans3")%>','<%=map.get("ans4")%>','<%=map.get("ans5")%>');">수정</a></td>
				</tr>
				<tr>
					<td>1) <%=map.get("ans1") %>&nbsp; 2) <%=map.get("ans2") %>&nbsp; 3) <%=map.get("ans3") %>&nbsp; 4)<%=map.get("ans4") %>&nbsp; 5) <%=map.get("ans5") %></td>
				</tr>
				<%} %>
				

	   		</table>
			<hr class="margin20">
			<table class="infoTable write">
				<colgroup>
					<col style="width:20%;">
					<col style="width:30%;">
					<col style="width:20%;">
					<col style="width:30%;">
				</colgroup>
				<tr>
					<th>작성부서</th>
					<td>
						<select name="writercd" style="width:50%;">
							<option value="L">주관부서(송무팀)</option>
							<option value="N">소관부서</option>
						</select>
					</td>
					<th>사용여부</th>
					<td>
						<select name="useyn">
							<option value="Y">사용</option>
							<option value="N">사용안함</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>평가유형</th>
					<td colspan="3"><input type="text" id="itemtype" name="itemtype" style="width:90%;" /></td>
				</tr>
				<tr>
					<th>질문지</th>
					<td colspan="3"><input type="text" id="item" name="item" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지1 (25)</th>
					<td colspan="3"><input type="text" id="ans1" name="ans1" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지2 (20)</th>
					<td colspan="3"><input type="text" id="ans2" name="ans2" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지3 (15)</th>
					<td colspan="3"><input type="text" id="ans3" name="ans3" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지4 (10)</th>
					<td colspan="3"><input type="text" id="ans4" name="ans4" style="width:90%;"/></td>
				</tr>
				<tr>
					<th>답지5 (5)</th>
					<td colspan="3"><input type="text" id="ans5" name="ans5" style="width:90%;"/></td>
				</tr>
	   		</table>
			<hr class="margin10">
			<div style="text-align: right;">
			    <a href="#none" class="sBtn type1" onclick="javascript:saveSatisitem4Ajax();">저장</a>
			    <a href="#none" class="sBtn type1" onclick="javascript:document.inputFrm.reset();">취소</a>
			</div>
		</div>
	</div>	
</form>