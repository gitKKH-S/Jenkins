<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>

<%

	String Grpcd = request.getAttribute("Grpcd")==null?"":request.getAttribute("Grpcd").toString();
	
	String writer = request.getAttribute("writer")==null?"":(String)request.getAttribute("writer");
	String writerid = request.getAttribute("writerid")==null?"":(String)request.getAttribute("writerid");
	String deptname = request.getAttribute("deptname")==null?"":(String)request.getAttribute("deptname");
	String deptid = request.getAttribute("deptid")==null?"":(String)request.getAttribute("deptid");
	String MENU_MNG_NO   = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	String satisitemid = request.getAttribute("satisitemid")==null?"":request.getAttribute("satisitemid").toString();
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	
%>

<script >


var consultid = "<%=consultid%>";
$(document).ready(function(){
	console.log("condkfjkdfdfd:"+consultid);
	getQuestion();
});




function getQuestion() {
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/web/consult/getQuestion.do",
		//data:{item:item},
		dataType:"json",
		async:false,
		success:setQuestion
	});
}

function setQuestion(data){
	//console.log(data);
	//console.log(data.result);
	var html = "<tr><th colspan='3'>설문조사</th>";
	$.each(data.result, function(key,input){
		//console.log(key);
		//console.log(input);
		//console.log("testr======>"+input.ITEM);
		
		var num = key+1;
		//console.log(num);
		var satisitemid = "satisitemid"+num;
		//console.log(satisitemid);
		var satislevel = "satislevel"+num;

		
		
		html += "<tr>";
		html += "<td>";
		html += "<input type='hidden' name='satisitemid' id='"+satisitemid+"' value='"+input.SATISITEMID+"'>";
		html += input.SATISITEMID;
		html += "</td>";
		html += "<td>";
		html += input.ITEM ;
		html += "</td>";
		html += "<td><select id='satislevel' name='satislevel' onchange='javascript:researchSave(this);'>";
		html += "<option value='5'>매우 그렇다</option>";
		html += "<option value='4'>그렇다</option>";
		html += "<option value='3'>보통이다</option>";
		html += "<option value='2'>그렇지 않다</option>";
		html += "<option value='1'>전혀 그렇지 않다</option>";
		html += "</select>";
		html += "</tr>";

		
	});

	$("#test").append(html);
}




function researchSave() {

	var satislevel = new Array();
	var satisitemid = new Array();
	var itemSize = $("input[name=satisitemid]").length;

	console.log("itemSize:"+itemSize);
	
	for(i=0; i<itemSize; i++){
		//satisitemid[i] = satisitemid[i].value;
		satisitemid[i] = $("#satisitemid").value;
		//satislevel[i] = goList.satislevel
		//satisitemid[i] = $("#satisitemid").val();
		satislevel[i] = $("select[id=satislevel"+i+1+"]").val();
		//satislevel[i] = $("select[id=satislevel"+i+"]").value;
			
	}
	goList.satisitemid.value = satisitemid;
	goList.satislevel.value = satislevel;
	
	console.log("satisitemid:"+satisitemid+"satislevel:"+satislevel);
	
	
	//var test123 = $("select[name=satislevel]").val();
	//console.log(test123);
	
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/web/consult/researchSave.do",
		data:$('#goList').serializeArray(), 
		dataType:"json",
		async:false,
		success:function(result){
			if(result.data.msg == 'ok'){
				alert("저장이 완료되었습니다.");
				location.href = "<%=CONTEXTPATH%>/web/consult/goConsultList.do";
			}
		}
	});
}

</script>
 
<form name="goList" method="post">	
		<input type="hidden" name="consultid" id="consultid" value="<%=consultid%>" /> 

 
 <div class="popW">
		<strong class="popTT">
			설문조사
			<a href="#none" class="popClose" onclick="window.close();">닫기</a>
		</strong>
		<div class="popC">
			<div class="popA">
			
			<table class="pop_infoTable write" id="test">
					<colgroup>
						<col width="5%" />
						<col width="40%" />
						<col width="20%" />

					</colgroup>

					
				</table>
				

			<table class="pop_infoTable write">
					<colgroup>
						<col width="15%" />
						<col width="85%" />

					</colgroup>
					<tr>
					<td>기타의견</td>
					<td><input type="text" id="opinion" name="opinion" style="width: 100%;"></td>
					</tr>
				</table>
			</div>
			<hr class="margin20">
			<div class="subBtnW center">
				<input type="button" class="sBtn type1" onclick="researchSave()" value="등록">
			</div>

			</div>
		</div>

 </form>
 