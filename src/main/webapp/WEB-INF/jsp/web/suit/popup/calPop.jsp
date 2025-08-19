<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	int getGbn = 1;
	String title = "";
	
	if("10001101".equals(gbn)){
		title = "변호사 보수 소송비용액 자동계산";
		getGbn = 1;
	} else if("10001103".equals(gbn)) {
		title = "인지대 자동계산";
		getGbn = 2;
	} else {
		title = "송달료 자동계산";
		getGbn = 3;
	}
%>
<style>

</style>
<script type="text/javascript">
	
	$(document).ready(function(){
		
	});
	
	function autoCal(){
		$("#soga").text(uncomma($("#soga_input").val()));
		
		var gbn = "<%=getGbn%>";
		//var gbn = $("#gbn").val();
		var cal = uncomma($("#soga_input").val());
		var totalValue = "";
		
		if(cal == "" || cal == null || isNaN(cal)){
			alert("숫자를 입력하세요.");
			
			$("#plus").text("");
			$("#soga").text("");
			$("#percent").text("");
			$("#total").text("");
			
			if(gbn == "1"){
				$("#daller").text("");
			}
			return;
		}
		
		$.ajax({
			url:"<%=CONTEXTPATH%>/web/suit/selectCalList.do",
			dataType:"json",
			data:{gbn:gbn, amt:cal},
			error:function(){
				alert("처리중 오류가 발생하였습니다.");
			},
			success:function(result){
				if(result.result.length == 0){
					alert("등록 된 계산 공식이 없습니다.");
				}else{
					$.each(result.result, function(index, val){
						if(gbn == "1"){
							$("#plus").text(comma(val.ADD_AMT));
							$("#daller").text(comma(val.SBTR_AMT));
							$("#percent").text(val.CAL_PER/100);
							totalValue = val.ADD_AMT+(cal-val.SBTR_AMT)*val.CAL_PER/100;
						}else if(gbn == "2"){
							$("#percent").text(val.CAL_PER/10000);
							$("#plus").text(comma(val.ADD_AMT));
							totalValue = cal*(val.CAL_PER/10000)+val.ADD_AMT;
						}
						$("#total").val(comma(totalValue));
						showtime.style.display = 'block';
					});
				}
			}
		});
		$("#total").val(comma(totalValue));
		showtime.style.display = 'block';
	}
	
	function selectGbn(){
		var sel = $("#hangjung").val();
		var num1 = 0;
		var peonum1 = 0;
		var numto1 = "";
		var amt = $("#amt").val();
		var Re1 = /[^0-9]/g;
		var ReN1 = /(-?[0-9]+)([0-9]{3})/;
		
		var songdal="1";
		if(sel == 1 || sel == 2 || sel == 9 || sel == 15)
			songdal = "10";
		else if(sel == 3 || sel == 13)
			songdal = "8";
		else if(sel == 4 || sel == 6 || sel == 7)
			songdal = "3";
		else if(sel == 8)
			songdal = "2";
		else if(sel == 14 || sel == 5)
			songdal = "5";
		else if(sel == 12)
			songdal = "12";
		else if(sel == 11)
			songdal = "15";
		
		$("#songdal").text(songdal);
		
		if($("#people").val() != "" && $("#people").val() != null){
			num1 = parseInt($("#songdal").text());
			peonum1 = parseInt($("#people").val());
			numto1 = peonum1*num1*amt;
			
			$("#total").val(numto1);
		}
	}
	
	function autoCal2(){
		var peo = $("#people").val();
		var amt = $("#amt").val();
		var num = 0;
		var peonum = 0;
		var numto = "";
		var Re = /[^0-9]/g;
		var ReN = /(-?[0-9]+)([0-9]{3})/;
		var song = $("#songdal").text();
		
		if(isNaN(peo)){
			$("#people").val("");
			return alert("숫자를 입력하세요");
		}
		
		if(amt == ""){
			return alert("계산 금액을 입력하세요");
		}
		
		num = parseInt(song);
		peonum = parseInt(peo);
		numto = peonum * num * amt;
		
		
		$("#amt").val(comma(amt));
		$("#total").val(comma(numto));
	}
	
	function setTotal(){
		if($("#total").val() == ""){
			alert("계산 된 값이 없습니다.");
			return false;
		}
		
		opener.document.getElementById("PRCS_AMT").value = $("#total").val();
		window.close();
	}
</script>
<style>
	.popW{min-width:470px;}
</style>
<form id="frm" name="frm" method="post" action="">
	<strong class="popTT">
		<%=title%>
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC" style="height:270px;">
		<div class="popA">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:25%;">
					<col style="width:75%;">
				</colgroup>
<%
					//착수금, 인지대 계산
				if(getGbn == 1 || getGbn == 2){ 
%>
				<tr>
					<th>소송가액</th>
					<td>
						<input type="text" name="soga_input" id="soga_input" style="width: 150px;" onkeyup="numFormat(this);">
						<a href="#none" class="innerBtn" type="button" onclick="autoCal()">계산하기</a>
						<br/><font color="red">(* 소송가액을 입력하시면 자동계산 결과를 확인할 수 있습니다.)</font>
					</td>
				</tr>
				<tr>
					<th>자동계산공식</th>
					<td>
						<div id="showtime" style="display:none">
						<%if(getGbn == 1){ %>
							<span id="plus"></span> + (<span id="soga"></span> - <span id="daller"></span>) * <span id="percent"></span>
						<%}else{ %>
							<span id="soga"></span> * <span id="percent"></span> + <span id="plus"></span>
						<%} %>
						</div>
					</td>
				</tr>
				<tr>
					<th>결과값</th>
					<td>
						<input type="text" name="total" id="total" readonly="readonly" style="width: 150px;"> 원
					</td>
				</tr>
<%
				//송달료 계산
				}else{ 
%>
				<tr>
					<td>유형</td>
					<td>
						<select name="hangjung" id="hangjung" onChange="selectGbn()" style="width: 50%;">
							<option value="0">선택하세요</option>
							<option value="1">행정제1심사건(구단,구합)</option>
							<option value="2">행정항소사건(누)</option>
							<option value="3">행정상고사건(두)</option>
							<option value="4">행정항고사건(루)</option>
							<option value="5">행정재항고사건(무)</option>
							<option value="6">행정특별항고사건(부)</option>
							<option value="7">행정준항고사건(사)</option>
							<option value="8">행정신청사건(아)</option>
							<option value="9">민사 제1심 소액사건</option>
							<option value="10">민사 제1심 단독사건</option>
							<option value="11">민사 제1심 합의사건</option>
							<option value="12">민사항소사건</option>
							<option value="13">민사 상고사건(다)</option>
							<option value="14">민사 조정사건(머)</option>
							<option value="15">부동산 등 경매사건(타경)</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="bo_text_right">자동계산공식</td>
					<td class="bo_left">
						<input type="text" name="people" id="people" size="5" onKeyUp="autoCal2(this);" style="width: 50px;"> 명 * <span id="songdal"></span> 회분 * 
						<input type="text" name="amt" id="amt" onKeyUp="autoCal2(this);" style="width: 50px;" />(1회분)
					</td>
				</tr>
				<tr>
					<td>결과값</td>
					<td><input type="text" name="total" id="total" readonly="readonly">원</td>
				</tr>
<%
				}
%>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center" style="margin-bottom:0px;">
			<a href="#none" onclick="setTotal();" class="sBtn type1">반영</a>
		</div>
	</div>
</form>