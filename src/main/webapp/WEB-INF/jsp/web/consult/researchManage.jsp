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

%>

<script >



$(document).ready(function(){
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

	var html = "";
	$.each(data.result, function(key,input){
		console.log(key);
		console.log(input);
		console.log("testr======>"+input.ITEM);

		var writercd_1 = input.WRITERCD;
		var writercd = "";
		if(writercd_1 =='U'){
			writercd = "사용자"
		} else {
			writercd = "담당자"
		}
		
		
		html += "<tr>";
		html += "<td>";
		html += input.SATISITEMID;
		html += "</td>";
		html += "<td>";
		html += input.ITEM ;
		html += "</td>";
		html += "<td>";
		html += input.USEYN;
		html += "</td>";
		html += "<td>";
		//html += input.WRITERCD;
		html += writercd;
		html += "</td>";
		html += "<td>";
		html += "<input type=\"button\" class=\"innerBtn\" value=\"관리\" onclick=\"itemManage('"+input.SATISITEMID+"')\">";
		html += "</td>";
		html += "</tr>";
	});

	$("#test").append(html);
}

function itemManage(itemid) {
	var url = '<%=CONTEXTPATH%>/web/consult/researchEditPop.do?itemid='+itemid;
	var wth = "980";
	var hht = "300";
	var pnm = "newEdit";
	popOpen(pnm,url,wth,hht);
}

function researchWritePop() {
	var url = '<%=CONTEXTPATH%>/web/consult/researchWritePop.do';
	var wth = "980";
	var hht = "300";
	var pnm = "newEdit";
	popOpen(pnm,url,wth,hht);
}

function goReLoad(){
	document.frm.action = "<%=CONTEXTPATH%>/web/consult/goResearchManage.do";
	document.frm.submit();
}

</script>
 
<form name="frm" id="frm" method="post" action="">
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<div class="popC">
			<div class="popA">
				<table class="pop_infoTable write" id="test">
					<colgroup>
						<col width="10%" />
						<col width="70%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
					</colgroup>
					
				</table>
			</div>
			<hr class="margin20">
			<div class="subBtnW left">
				<input type="button" class="sBtn type1" onclick="researchWritePop()" value="질문추가">
			</div>
		</div>
	</div>
</div>
</form>