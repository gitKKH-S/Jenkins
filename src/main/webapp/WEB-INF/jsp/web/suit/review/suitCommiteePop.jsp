<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String LWS_DLBR_MNG_NO = request.getAttribute("LWS_DLBR_MNG_NO")==null?"":request.getAttribute("LWS_DLBR_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script type="text/javascript">
	$(document).ready(function(){
		getComiUserList();
	});
	function getComiUserList(){
		$("#cInfoTr").remove();
		$(".comInfo").remove();
		var LWS_DLBR_MNG_NO = $("#LWS_DLBR_MNG_NO").val();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectreviewComiList.do",
			data:{LWS_DLBR_MNG_NO:LWS_DLBR_MNG_NO},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				if(result.result.length > 0){
					$.each(result.result, function(index, val){
						html += "<tr class=\"comInfo\" id=\"comiInfo"+val.ROWN+"\">";
						html += "<td>"+val.DLBR_MBCMT_EMP_NM+"</td>"; // user nm
						html += "<td>"+val.JIKNM+"</td>";
						html += "<td>"+val.DLBR_MBCMT_DEPT_NM+"</td>";
						html += "<td>";
						html += "<a href=\"#none\" class=\"innerBtn center\" onclick=\"delCommi('"+val.ROWN+"')\">삭제</a>";
						html += "<input type=\"hidden\" name=\"committeeid\" id=\"committeeid\" value=\""+val.DLBR_CMT_MNG_NO+"\" />";
						html += "<input type=\"hidden\" name=\"usernm\" id=\"usernm\" value=\""+val.DLBR_MBCMT_EMP_NM+"\" />";
						html += "<input type=\"hidden\" name=\"userid\" id=\"userid\" value=\""+val.DLBR_MBCMT_EMP_NO+"\" />";
						html += "<input type=\"hidden\" name=\"sosoknm\" id=\"sosoknm\" value=\""+val.DLBR_MBCMT_DEPT_NM+"\" />";
						html += "<input type=\"hidden\" name=\"sosokcd\" id=\"sosokcd\" value=\""+val.DLBR_MBCMT_DEPT_NO+"\" />";
						html += "</td>";
						html += "</tr>";
					});
				}else{
					html += "<tr class=\"cInfoTr\"><td colspan=\"4\">지정 된 위원회 목록이 없습니다.</td></tr>";
				}
				$("#comCnt").val(result.result.length+1);
				$("#comList").append(html);
			}
		});
	}
	
	function delCommi(cnt){
		$("#comiInfo"+cnt).remove();
		//$("#comCnt").val(($("#comCnt").val()*1)-1);
	}
	
	function addComi(gbn){
		//var cnt = $("#comCnt").val()*1;
		var cnt = $("input[name=usernm]").length;
		if(cnt < 11){
			$("#cInfoTr").remove();
			var html = "";
			html += "<tr class=\"comInfo\" id=\"comiInfo"+cnt+"\">";
			html += "<td>";
			if(gbn == "in"){
				html += "<input type=\"text\" name=\"usernm\" id=\"usernm"+cnt+"\" value=\"\" onclick=\"searchDeptPop('"+cnt+"')\" readonly=\"readonly\"/>";
				html += "<input type=\"hidden\" name=\"userid\" id=\"userid"+cnt+"\" value=\"\" />";
			}else{
				html += "<input type=\"text\" name=\"usernm\" id=\"usernm"+cnt+"\" value=\"\" />";
				html += "<input type=\"hidden\" name=\"userid\" id=\"userid\" value=\"0\" />";
			}
			html += "</td>";
			if(gbn == "in"){
				html += "<td>";
				html += "<input type=\"text\" name=\"jiknm\" id=\"jiknm"+cnt+"\" value=\"\" readonly=\"readonly\">";
				html += "</td>";
			}else{
				html += "<td></td>";
			}
			html += "<td>";
			if(gbn == "in"){
				html += "<input type=\"text\" name=\"sosoknm\" id=\"sosoknm"+cnt+"\" value=\"\" readonly=\"readonly\"/>";
				html += "<input type=\"hidden\" name=\"sosokcd\" id=\"sosokcd"+cnt+"\" value=\"0\" />";
			}else{
				html += "<input type=\"text\" name=\"sosoknm\" id=\"sosoknm\" value=\"\" />";
				html += "<input type=\"hidden\" name=\"sosokcd\" id=\"sosokcd\" value=\"0\" />";
			}
			html += "<input type=\"hidden\" name=\"committeeid\" id=\"committeeid\" value=\"0\" />";
			html += "</td>";
			html += "<td>";
			html += "<a href=\"#none\" class=\"innerBtn center\" onclick=\"delCommi('"+cnt+"')\">삭제</a>"
			html += "</td>";
			html += "</tr>";
			$("#comCnt").val(cnt+1);
			$("#comList").append(html);
		}else{
			alert("위원회 인원은 10명까지만 지정할 수 있습니다.");
		}
	}
	
	function searchDeptPop(idx){
		var cw=900;
		var ch=900;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","deptsearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "deptsearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchDeptPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"menu", value:"comi"}));
		newForm.append($("<input/>", {type:"hidden", name:"cnt", value:idx}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function saveComiInfo(gbn){
		var useridList = new Array();
		var usernmList = new Array();
		var sosoknmList = new Array();
		var sosokcdList = new Array();
		var commidList = new Array();
		
		for(var i=0; i<$("input[name=usernm]").length; i++){
			console.log($("input[name=usernm]").eq(i).val());
			useridList[i] = $("input[name=userid]").eq(i).val();
			usernmList[i] = $("input[name=usernm]").eq(i).val();
			sosokcdList[i] = $("input[name=sosokcd]").eq(i).val();
			sosoknmList[i] = $("input[name=sosoknm]").eq(i).val();
			commidList[i] = $("input[name=committeeid]").eq(i).val();
		}
		
		$("#comUserid").val(useridList);
		$("#comUsernm").val(usernmList);
		$("#comSosokcd").val(sosokcdList);
		$("#comSosoknm").val(sosoknmList);
		$("#comCommid").val(commidList);
		
		$("#savegbn").val(gbn);
		
		var msg = "";
		if(gbn == 'save'){
			msg = "위원 목록을 저장하시겠습니까?";
		}else{
			msg = "위원 목록을 저장한 후 다음 단계로 진행하시겠습니까?";
		}
		
		if(confirm(msg)){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/reviewComiSave.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					opener.goReload();
					window.close();
				}
			});
		}
	}
</script>
<style>
	.popW{height:100%}
	.subTTW{margin:0px 15px 0px 15px;}
	.popA{margin:10px 15px 0px 15px;}
</style>
<strong class="popTT">
	소송 심의위원회 구성
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="LWS_DLBR_MNG_NO" id="LWS_DLBR_MNG_NO" value="<%=LWS_DLBR_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="state"      id="state"      value="심의위원회구성" />
	<input type="hidden" name="comCnt"     id="comCnt"     value="0" />
	<input type="hidden" name="comUserid"  id="comUserid"  value="" />
	<input type="hidden" name="comUsernm"  id="comUsernm"  value="" />
	<input type="hidden" name="comSosokcd" id="comSosokcd" value="" />
	<input type="hidden" name="comSosoknm" id="comSosoknm" value="" />
	<input type="hidden" name="comCommid"  id="comCommid"  value="" />
	<input type="hidden" name="savegbn"    id="savegbn"    value="" />
	
	<div>
		<div class="popA" style="height:452px; overflow-y:scroll;">
			<table class="pop_listTable" id="comList">
				<colgroup>
					<col style="width:25%;">
					<col style="width:25%;">
					<col style="width:35%;">
					<col style="width:15%;">
				</colgroup>
				<tr>
					<th>이름</th>
					<th>직책</th>
					<th>부서</th>
					<th></th>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subTTW">
			<div class="subBtnC left">
				<a href="#none" class="sBtn type2" onclick="saveComiInfo('save');">저장</a>
				<a href="#none" class="sBtn type2" onclick="saveComiInfo('next');">다음단계로</a>
			</div>
			<div class="subTTC right">
				<a href="#none" class="sBtn type1" onclick="addComi('in');">내부 위원 추가</a>
				<a href="#none" class="sBtn type1" onclick="addComi('out');">외부 위원 추가</a>
			</div>
		</div>
	</div>
</form>
