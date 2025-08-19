<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String cnt = request.getAttribute("CNT")==null?"":request.getAttribute("CNT").toString();
	String menu = request.getAttribute("menu")==null?"":request.getAttribute("menu").toString();
	System.out.println(cnt + "/" + menu);
%>
<script type="text/javascript">
	var cnt = '<%=cnt%>';
	var menu = '<%=menu%>';
	$(document).ready(function(){
		getLawyer();
		
		$("#srchTxt1").on('keyup',function(){
			var k = $(this).val();
			$("#lawyerlist > tbody > .lawyerinfo").hide();
			var temp = $("#lawyerlist > tbody > .lawyerinfo > #usernm:nth-child(1n+1):contains('" + k + "')");
			$(temp).parent().show();
		});
		
		$("#srchTxt2").on('keyup',function(){
			var k = $(this).val();
			$("#lawyerlist > tbody > .lawyerinfo").hide();
			var temp = $("#lawyerlist > tbody > .lawyerinfo > #ofnm:nth-child(1n+1):contains('" + k + "')");
			$(temp).parent().show();
		});
	});
	
	function getLawyer(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/selectLawyerList.do",
			dataType:"json",
			async:false,
			success:selectLawyerCallBack
		});
	}
	
	function selectLawyerCallBack(data){
		console.log(data);
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				
				if(!val.USER_ID){
					val.USER_ID = '';
				}
				if(!val.LAWYERNAME){
					val.LAWYERNAME = '';
				}
				if(!val.LAWYERGBN){
					val.LAWYERGBN = '';
				}
				if(!val.OFFICE){
					val.OFFICE = '';
				}
				if(!val.CELLPHONE){
					val.CELLPHONE = '';
				}
				if(!val.PHONE){
					val.PHONE = '';
				}
				if(!val.EMAIL){
					val.EMAIL = '';
				}
				html += "<tr class=\"lawyerinfo\" onclick=\"selectUser('"+val.USER_ID+"','"+val.LAWYERNAME+"','"+val.OFFICE+"','"+val.CELLPHONE+"','"+val.PHONE+"','"+val.EMAIL+"')\">";
				html += "<td class=\"selTd\" id=\"lawyerinfo\">"+val.RNUM+"</td>";
				html += "<td class=\"selTd\" id=\"usernm\">"+val.LAWYERNAME+"</td>";
				html += "<td class=\"selTd\" id=\"lawyerinfo\">"+val.LAWYERGBN+"</td>";
				html += "<td class=\"selTd\" id=\"ofnm\">"+val.OFFICE+"</td>";
				html += "<td class=\"selTd\" id=\"lawyerinfo\">"+val.CELLPHONE+"</td>";
				html += "<td class=\"selTd\" id=\"lawyerinfo\">"+val.EMAIL+"</td>";
				html += "</tr>";
			});
		}else{
			html += "<tr><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
		}
		$("#lawyerlist").append(html);
	}
	
	
	function selectUser(userid, usernm, sosoknm, cellphone,PHONE, email){
			opener.document.getElementById("bublawyerid").value = userid;
			opener.document.getElementById("bname").value = usernm;
			opener.document.getElementById("bsosok").value = sosoknm;
			opener.document.getElementById("bphone").value = PHONE;
			opener.document.getElementById("bhphone").value = cellphone;
			opener.document.getElementById("bemail").value = email;
			
		alert(usernm+"이(가) 선택되었습니다.");
		window.close();
	}



</script>
<style>
	#srchTxt1{width:90%; height:30px; line-height:0px; margin-top:3px;}
	#srchTxt2{width:90%; height:30px; line-height:0px; margin-top:3px;}
	.popW{height:100%}
	#hidden{display:none;}
	.selTd{cursor:pointer;}
</style>
<div class="popW">
		<strong class="popTT">
			변호사 찾기
			<a href="#none" class="popClose" onclick="window.close();">닫기</a>
		</strong>
		<div class="popC" style='height:90%'>
			<div class="popSrchW">
				<input type="text" id="srchTxt1" placeholder="변호사명">
				<hr class="lineH">
				<input type="text" id="srchTxt2" placeholder="소속"><a href="#none" class="popSrch_btn">검색</a>
			</div>
			<div class="popA">
				<table class="pop_listTable" id="lawyerlist" style="width: 100%">
					<colgroup>
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
						
					</colgroup>
					<tr>
					<th></th>
					<th>이름</th>
					<th>구분</th>
					<th>소속</th>
					<th>핸드폰</th>
					<th>이메일</th>
					</tr>
				</table>
			</div>
		</div>
	</div>
</body>
</html>