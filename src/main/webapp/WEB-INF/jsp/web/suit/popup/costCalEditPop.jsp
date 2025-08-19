<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<style>
	input{width:100px;}
</style>
<script type="text/javascript">
	var gbn = "1";
	
	$(document).ready(function(){
		getCal(gbn);
	});
	
	function getCal(gbn){
		$.ajax({
			url:"<%=CONTEXTPATH%>/web/suit/selectCalList.do",
			dataType:"json",
			data:{gbn:gbn},
			error:function(){
				alert("처리중 오류가 발생하였습니다.");
			},
			success:setCal
		});
	}
	
	function setCal(data){
		$(".calinfo").remove();
		var html = "";
		$.each(data.result, function(index, val){
			html += "<tr class=\"calinfo\">";
			html += "<td>";
			html += "<input type=\"hidden\" id=\"id"+index+"\" value=\""+val.CALFM_MNG_NO+"\">";
			if(val.CALFM_SE == "1"){
				html += "<input type=\"text\" id=\"CAL_BGNG_AMT"+index+"\" value=\""+val.CAL_BGNG_AMT+"\"> 초과 ";
				html += "<input type=\"text\" id=\"CAL_END_AMT"+index+"\" value=\""+val.CAL_END_AMT+"\"> 이하";
			}else{
				html += "<input type=\"text\" id=\"CAL_BGNG_AMT"+index+"\" value=\""+val.CAL_BGNG_AMT+"\"> 초과 ";
				html += "<input type=\"text\" id=\"CAL_END_AMT"+index+"\" value=\""+val.CAL_END_AMT+"\"> 미만";
			}
			html += "</td>";
			html += "<td>";
			html += "<input type=\"text\" id=\"ADD_AMT"+index+"\" value=\""+val.ADD_AMT+"\">";
			html += "</td>";
			html += "<td>";
			html += "<input type=\"text\" id=\"SBTR_AMT"+index+"\" value=\""+val.SBTR_AMT+"\">";
			html += "</td>";
			html += "<td>";
			html += "<input type=\"text\" id=\"CAL_PER"+index+"\" value=\""+val.CAL_PER+"\">";
			html += "</td>";
			html += "<td>";
			html += "<a href=\"#none\" class=\"innerBtn\" type=\"button\" onclick=\"editCal('"+val.CALFM_MNG_NO+"', '"+index+"', '"+val.CALFM_SE+"')\">수정</a>";
			html += "<a href=\"#none\" class=\"innerBtn\" type=\"button\" onclick=\"delCal('"+val.CALFM_MNG_NO+"', '"+val.CALFM_SE+"')\">삭제</a>";
			html += "</td>";
			html += "</tr>";
			$("#cnt").val(index);
			gbn = val.CALFM_SE;
		});
		//$("#viewStandt").append(data.result[0].STANDT + " 기준");
		$("#calInfo").append(html);
	}
	
	function editCal(id, idx, gbn){
		if(confirm("입력 한 정보로 수정하시겠습니까?")){
			$("#CALFM_MNG_NO").val(id);
			$("#CALFM_SE").val(gbn);
			$("#CAL_BGNG_AMT").val($("#CAL_BGNG_AMT"+idx).val());
			$("#CAL_END_AMT").val($("#CAL_END_AMT"+idx).val());
			$("#ADD_AMT").val($("#ADD_AMT"+idx).val());
			$("#SBTR_AMT").val($("#SBTR_AMT"+idx).val());
			$("#CAL_PER").val($("#CAL_PER"+idx).val());
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/insertCalInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					getCal(result.gbn);
					alert(result.msg);
				}
			});
		}
	}
	
	function addCal(){
		var cnt = $("#cnt").val();
		cnt++;
		
		var html = "";
		html += "<tr class=\"calinfo\">";
		html += "<td>";
		if(gbn == "1"){
			html += "<input type=\"text\" id=\"CAL_BGNG_AMT"+cnt+"\" value=\"\"> 초과 ";
			html += "<input type=\"text\" id=\"CAL_END_AMT"+cnt+"\" value=\"\"> 이하";
		}else{
			html += "<input type=\"text\" id=\"CAL_BGNG_AMT"+cnt+"\" value=\"\"> 초과 ";
			html += "<input type=\"text\" id=\"CAL_END_AMT"+cnt+"\" value=\"\"> 미만";
		}
		html += "</td>";
		html += "<td>";
		html += "<input type=\"text\" id=\"ADD_AMT"+cnt+"\" value=\"\">";
		html += "</td>";
		html += "<td>";
		html += "<input type=\"text\" id=\"SBTR_AMT"+cnt+"\" value=\"\">";
		html += "</td>";
		html += "<td>";
		html += "<input type=\"text\" id=\"CAL_PER"+cnt+"\" value=\"\">";
		html += "</td>";
		html += "<td>";
		html += "<a href=\"#none\" class=\"innerBtn\" type=\"button\" onclick=\"calSave('"+cnt+"')\">저장</a>";
		html += "</td>";
		html += "</tr>";
		$("#calInfo").append(html);
		
		$("#cnt").val(cnt);
	}
	
	function delCal(id, gbn){
		if(confirm("정보를 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteCalInfo.do",
				data:{calid:id, gbn:gbn},
				dataType:"json",
				async:false,
				success:function(result){
					getCal(gbn);
					alert(result.msg);
				}
			});
		}
	}
	
	function calSave(idx){
		if(confirm("입력 한 정보를 저장하시겠습니까?")){
			$("#CALFM_SE").val(gbn);
			$("#CAL_BGNG_AMT").val($("#CAL_BGNG_AMT"+idx).val());
			$("#CAL_END_AMT").val($("#CAL_END_AMT"+idx).val());
			$("#ADD_AMT").val($("#ADD_AMT"+idx).val());
			$("#SBTR_AMT").val($("#SBTR_AMT"+idx).val());
			$("#CAL_PER").val($("#CAL_PER"+idx).val());
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/insertCalInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					getCal(result.gbn);
					alert(result.msg);
				}
			});
		}
	}
</script>
<strong class="popTT">
	비용 계산식 관리<!-- <span id="viewStandt" style="font-size:12px"></span> -->
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<input type="hidden" name="CALFM_MNG_NO" id="CALFM_MNG_NO" value="" />
	<input type="hidden" name="CAL_BGNG_AMT" id="CAL_BGNG_AMT" value="" />
	<input type="hidden" name="CAL_END_AMT"  id="CAL_END_AMT"  value="" />
	<input type="hidden" name="ADD_AMT"      id="ADD_AMT"      value="" />
	<input type="hidden" name="SBTR_AMT"     id="SBTR_AMT"     value="" />
	<input type="hidden" name="CAL_PER"      id="CAL_PER"      value="" />
	<input type="hidden" name="CALFM_SE"     id="CALFM_SE"     value="" />
	
	<input type="hidden" name="cnt" id="cnt" value="" />
</form>
<div class="popC">
	<div class="popA">
		<table class="pop_infoTable write">
			<colgroup>
				<col style="width:*;">
			</colgroup>
			<tr>
				<td style="text-align:center;">
					<input type="radio" name="gbn" id="gbn1" value="1" onclick="getCal(this.value);" checked="checked"/> 변호사 보수
					<input type="radio" name="gbn" id="gbn2" value="2" onclick="getCal(this.value);"/> 인지대
				</td>
			</tr>
		</table>
	</div>
	<hr class="margin20">
	<div class="popA">
		<table class="pop_infoTable write">
			<colgroup>
				<col style="width:34.5%;">
				<col style="width:*;">
				<col style="width:*;">
				<col style="width:*;">
				<col style="width:17.8%;">
			</colgroup>
				<tr>
					<th>금액범위</th>
					<th>+ 금액</th>
					<th>- 금액</th>
					<th>%</th>
					<th></th>
				</tr>
		</table>
		<div style="height:322px; overflow-y:scroll;">
			<table class="pop_infoTable write" id="calInfo">
				<colgroup>
					<col style="width:35%;">
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:*;">
				</colgroup>
			</table>
		</div>
	</div>
	<hr class="margin20">
	<div class="subBtnW center">
		<a href="#none" class="sBtn type1" onclick="addCal();">추가</a>
	</div>
</div>