<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	int suitid = ServletRequestUtils.getIntParameter(request, "suitid", 0);
	int caseid = ServletRequestUtils.getIntParameter(request, "caseid", 0);
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":(String)request.getAttribute("WRTR_EMP_NM");
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":(String)request.getAttribute("WRTR_EMP_NO");
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":(String)request.getAttribute("WRT_DEPT_NM");
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":(String)request.getAttribute("WRT_DEPT_NO");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var suitid = "<%=suitid%>";
	var caseid = "<%=caseid%>";
	
	var lawyerids = "";
	var lawyernms = "";
	
	var lawyeridArr = new Array();
	var lawfirmidArr = new Array();
	var delChrgidArr = new Array();
	var chrgidArr = new Array();
	
	var selLawyerArr = new Array();
	
	var idx = 0;
	var delidx = 0;
	var selidx = 0;
	
	var mergeyn = opener.document.getElementById("mergeyn").value;
	
	$(document).ready(function(){
		getChrgLawyerList();
		
		$("#schTxt").keyup(function(){
			var k = $(this).val();
			$("#lawyerList > tbody > .lawyerinfo").hide();
			var temp = $("#lawyerList > tbody > .lawyerinfo > #lawyernm:nth-child(2n+2):contains('" + k + "')");
			$(temp).parent().show();
		});
	});
	
	function getChrgLawyerList(){
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectChgLawyerList.do",
			dataType:"json",
			data:{suitid:suitid, caseid:caseid, mergeyn:mergeyn},
			async:false,
			success:function(result){
				$.each(result.result, function(index, val){
					lawfirmidArr[idx] = String(val.LAWFIRMID);
					lawyeridArr[idx] = String(val.LAWYERID);
					chrgidArr[idx] = val.CHRGLAWYERID;
					
					goSelect(idx, val.LAWYERID, val.LAWYERNAME, val.LAWFIRMNAME, val.LAWFIRMID, val.CHRGLAWYERID);
					
					idx = idx + 1;
					
				});
				selectLawfirmList();
			}
		});
	}
	
	function selectLawfirmList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectLawfirmPopList.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:setLawfirmList
		});
	}
	
	function setLawfirmList(data){
		var cnt = 0;
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				//html += "<tr class=\"lawfirmInfo\"><td id=\"selLawfirm\" onclick=\"goSelect('"+val.LAWFIRMID+"', '"+val.OFFICE+"')\">"+val.OFFICE+"</td></tr>";
				if(lawfirmidArr.indexOf(val.LAWFIRMID) > -1){
					html += "<tr class=\"lawfirmInfo\" id=\"lawfirm"+cnt+"\" style=\"display:none;\">";
				}else{
					html += "<tr class=\"lawfirmInfo\" id=\"lawfirm"+cnt+"\">";
				}
				html += "<td id=\"selLawfirm\" onclick=\"getLawyer('"+val.LAWFIRMID+"')\">"+val.OFFICE+"</td>";
				html += "<td><a href=\"#none\" class=\"innerBtn center\" onclick=\"goSelect('"+cnt+"','','', '"+val.OFFICE+"','"+val.LAWFIRMID+"','')\">선택</a></td>";
				html += "</tr>";
				cnt = cnt + 1;
			});
		}
		$("#lawfirmList").append(html);
	}
	
	function getLawyer(lawfirmid){
		$(".lawyerinfo").remove();
		var cnt = 0;
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectChrgLawyer.do",
			data:{lawfirmid:lawfirmid},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				$.each(result.result, function(index, val){
					if(lawyeridArr.indexOf(val.LAWYERID) > -1 || selLawyerArr.indexOf(val.LAWYERID) > -1){
						html += "<tr class=\"lawyerinfo\" id=\"lawyer"+cnt+"\" style=\"display:none;\">";
					}else{
						html += "<tr class=\"lawyerinfo\" id=\"lawyer"+cnt+"\">";
					}
					/* html += "<td>"+val.OFFICE+"</td>"; */
					html += "<td id=\"lawyernm\">"+val.LAWYERNAME+"</td>";
					html += "<td><a href=\"#none\" class=\"innerBtn center\" onclick=\"goSelect('"+cnt+"','"+val.LAWYERID+"','"+val.LAWYERNAME+"', '"+val.OFFICE+"','"+val.LAWFIRMID+"','')\">선택</a></td>";
					html += "</tr>";
					cnt = cnt+1;
					console.log(cnt);
				});
				$("#lawyerList").append(html);
			}
		});
	}

	
	function goSelect(cnt, lawyerid, lawyernm, office, lawfirmid, chrgid){
		
		if(lawyerid == ""){
			$("#lawfirm"+cnt).css("display","none");
		}else{
			selLawyerArr[selidx] = Number(lawyerid);
			selidx = selidx + 1;
			$("#lawyer"+cnt).css("display","none");
		}
		
		var i = $("#cnt").val() * 1;
		i++;
		$("#cnt").val(i);
		var html = "";
		
		html += "<tr id=\"tr"+i+"\">";
		html += "<td>"+office+"</td>";
		html += "<td>"+lawyernm+"</td>";
		html += "<td><a href=\"#none\" class=\"innerBtn center\" onclick=\"goRemove('"+i+"', '"+cnt+"', '"+lawyerid+"','"+chrgid+"')\">삭제</a></td>";
		html += "<input type=\"hidden\" id=\"lawyerid"+i+"\"  name=\"lawyerid"+i+"\"  value=\""+lawyerid+"\"/>";
		html += "<input type=\"hidden\" id=\"lawyernm"+i+"\"  name=\"lawyernm"+i+"\"  value=\""+lawyernm+"\"/>";
		html += "<input type=\"hidden\" id=\"lawfirmid"+i+"\" name=\"lawfirmid"+i+"\" value=\""+lawfirmid+"\"/>";
		html += "<input type=\"hidden\" id=\"office"+i+"\"    name=\"office"+i+"\"    value=\""+office+"\"/>";
		html += "<input type=\"hidden\" id=\"chrgid"+i+"\"    name=\"chrgid"+i+"\"    value=\""+chrgid+"\"/>";
		html += "</tr>";
		
		$("#selLaw").append(html);
	}
	
	function goRemove(idx, getcnt, lawyerid, chrgid){
		$("#tr"+idx).remove();
		$("#lawyer"+getcnt).css("display","");
		$("#cnt").val($("#cnt").val()-1);
		
		if(lawyeridArr.indexOf(lawyerid) != -1){
			
			delChrgidArr[delidx] = chrgid;
			delidx = delidx+1;
		}
	}
	
	function goSave(){
		var frm = document.frm;
		var cnt = $("#cnt").val();
		for(i=0; i<cnt+1; i++){
			try{
				if (eval('frm.lawyerid'+i+'.value').length > 0){
					if(frm.lawyerids.value.length == 0){
						frm.lawyerids.value = eval('frm.lawyerid'+i+'.value');
					}else{
						frm.lawyerids.value = frm.lawyerids.value + ','+ eval('frm.lawyerid'+i+'.value');
					}
				}
			}catch(e){ }
			try{
				if (eval('frm.lawyernm'+i+'.value').length > 0){
					if(frm.lawyernms.value.length == 0){
						frm.lawyernms.value = eval('frm.lawyernm'+i+'.value');
					}else{
						frm.lawyernms.value = frm.lawyernms.value + ','+ eval('frm.lawyernm'+i+'.value');
					}
				}
			}catch(e){ }
			try{
				if (eval('frm.lawfirmid'+i+'.value').length > 0){
					if(frm.lawfirmids.value.length == 0){
						frm.lawfirmids.value = eval('frm.lawfirmid'+i+'.value');
					}else{
						frm.lawfirmids.value = frm.lawfirmids.value + ','+ eval('frm.lawfirmid'+i+'.value');
					}
				}
			}catch(e){ }
			try{
				if (eval('frm.office'+i+'.value').length > 0){
					if(frm.lawfirmnms.value.length == 0){
						frm.lawfirmnms.value = eval('frm.office'+i+'.value');
					}else{
						frm.lawfirmnms.value = frm.lawfirmnms.value + ','+ eval('frm.office'+i+'.value');
					}
				}
			}catch(e){ }
		}
		opener.document.getElementById("lawyerids").value = $("#lawyerids").val();
		opener.document.getElementById("lawyernms").value = $("#lawyernms").val();
		opener.document.getElementById("lawfirmids").value = $("#lawfirmids").val();
		opener.document.getElementById("lawfirmnms").value = $("#lawfirmnms").val();
		
		// 저장되어있는 대리인 중 삭제할 list를 caseWrite 페이지로 넘긴다.
		opener.document.getElementById("delChrgidArr").value = delChrgidArr;
		
		alert("대리인 선택이 완료되었습니다.\n대리인 비용관련 내용은 소송위임 화면에서 등록 해 주세요.");
		window.close();
	}
</script>
<style>
	.chrgLawInfo{width:80%;}
	.filename{width:130px;}
</style>
<strong class="popTT">
	소송 위임 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="suitid"    id="suitid"    value="<%=suitid%>"/>
	<input type="hidden" name="caseid"    id="caseid"    value="<%=caseid%>"/>
	
	<input type="hidden" name="WRTR_EMP_NM"    id="WRTR_EMP_NM"    value="<%=WRTR_EMP_NM%>"/>
	<input type="hidden" name="WRTR_EMP_NO"  id="WRTR_EMP_NO"  value="<%=WRTR_EMP_NO%>"/>

	<input type="hidden" name="cnt" id="cnt" value="0"/>
	<input type="hidden" name="lawyerids" id="lawyerids" value="" />
	<input type="hidden" name="lawyernms" id="lawyernms" value="" />
	<input type="hidden" name="lawfirmids" id="lawfirmids" value="" />
	<input type="hidden" name="lawfirmnms" id="lawfirmnms" value="" />

	<div class="popC left">
		<div class="popSrchW">
			<input type="text" id="schTxt" placeholder="법무법인명을 입력하세요">
		</div>
		<div class="popA" style="height:250px">
			<table class="pop_listTable" id="lawfirmList">
				<colgroup>
					<col style="width:*;">
					<col style="width:40%;">
					<col style="width:10%;">
				</colgroup>
				<tr>
					<th>법무법인</th>
					<th>선택</th>
				</tr>
			</table>
		</div>
	</div>
	<div class="popC right">
		<div class="popSrchW">
			<input type="text" id="schTxt" placeholder="변호사명을 입력하세요">
		</div>
		<div class="popA" style="height:250px">
			<table class="pop_listTable" id="lawyerList">
				<colgroup>
					<col style="width:*;">
					<col style="width:40%;">
					<col style="width:10%;">
				</colgroup>
				<tr>
					<th>변호사</th>
					<th>선택</th>
				</tr>
			</table>
		</div>
	</div>
	<hr class="margin20">
	<div class="popA" style="height:245px;">
		<table class="pop_listTable" id="selLaw">
			<colgroup>
				<col style="width:*;">
				<col style="width:40%;">
				<col style="width:10%;">
			</colgroup>
			<tr>
				<th>법무법인</th>
				<th>변호사</th>
				<th>선택</th>
			</tr>
		</table>
	</div>
	<hr class="margin20">
	<div class="subBtnW center">
		<a href="#none" class="sBtn type1" onclick="goSave();">등록</a>
	</div>

</form>