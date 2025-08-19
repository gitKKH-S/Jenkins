<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String reviewid = request.getAttribute("reviewid")==null?"":request.getAttribute("reviewid").toString();
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String WRTR_EMP_NM = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String WRTR_EMP_NO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String WRT_DEPT_NM = se.get("WRT_DEPT_NM")==null?"":se.get("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = se.get("WRT_DEPT_NO")==null?"":se.get("WRT_DEPT_NO").toString();
	String Menuid = request.getParameter("Menuid")==null?"":request.getParameter("Menuid");
%>
<script type="text/javascript">
	$(document).ready(function(){
		getComiUserList();
	});
	function getComiUserList(){
		$("#cInfoTr").remove();
		$(".comInfo").remove();
		var reviewid = $("#reviewid").val();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectreviewComiList.do",
			data:{reviewid:reviewid},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				if(result.result.length > 0){
					$.each(result.result, function(index, val){
						html += "<tr class=\"comInfo\" id=\"comiInfo"+val.ROWN+"\">";
						html += "<td>"+val.USER_NM+"</td>"; // user nm
						html += "<td>"+val.JIKNM+"</td>";
						html += "<td>"+val.DEPT_NAME+"</td>";
						html += "<td>";
						html += "<a href=\"#none\" class=\"innerBtn center\" onclick=\"delCommi('"+val.ROWN+"')\">삭제</a>";
						html += "<input type=\"hidden\" name=\"committeeid\" id=\"committeeid\" value=\""+val.COMMITTEEID+"\" />";
						html += "<input type=\"hidden\" name=\"usernm\" id=\"usernm\" value=\""+val.USER_NM+"\" />";
						html += "<input type=\"hidden\" name=\"userid\" id=\"userid\" value=\""+val.USER_ID+"\" />";
						html += "<input type=\"hidden\" name=\"sosoknm\" id=\"sosoknm\" value=\""+val.DEPT_NAME+"\" />";
						html += "<input type=\"hidden\" name=\"sosokcd\" id=\"sosokcd\" value=\""+val.DEPT_CODE+"\" />";
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
				html += "<input type=\"text\" name=\"usernm\" id=\"usernm\" value=\"\" onclick=\"searchDeptPop('"+cnt+"')\" readonly=\"readonly\"/>";
				html += "<input type=\"hidden\" name=\"userid\" id=\"userid\" value=\"\" />";
			}else{
				html += "<input type=\"text\" name=\"usernm\" id=\"usernm\" value=\"\" />";
				html += "<input type=\"hidden\" name=\"userid\" id=\"userid\" value=\"0\" />";
			}
			html += "</td>";
			if(gbn == "in"){
				html += "<td>";
				html += "<input type=\"text\" name=\"jiknm\" id=\"jiknm\" value=\"\" readonly=\"readonly\">";
				html += "</td>";
			}else{
				html += "<td></td>";
			}
			html += "<td>";
			if(gbn == "in"){
				html += "<input type=\"text\" name=\"sosoknm\" id=\"sosoknm\" value=\"\" readonly=\"readonly\"/>";
				html += "<input type=\"hidden\" name=\"sosokcd\" id=\"sosokcd\" value=\"0\" />";
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
		var url = '<%=CONTEXTPATH%>/web/suit/searchDeptPop.do?menu=comi&cnt='+idx;
		var wth = "800";
		var hht = "900";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
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
	<input type="hidden" name="reviewid"   id="reviewid"   value="<%=reviewid%>"/>
	<input type="hidden" name="Menuid"     id="Menuid"     value="<%=Menuid%>"/>
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"   id="WRTR_EMP_NO"   value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"   id="WRT_DEPT_NM"   value="<%=WRT_DEPT_NM%>" />
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
