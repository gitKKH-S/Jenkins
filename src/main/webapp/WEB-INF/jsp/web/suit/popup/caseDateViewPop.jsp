<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String DATE_MNG_NO = request.getAttribute("DATE_MNG_NO")==null?"":request.getAttribute("DATE_MNG_NO").toString();
	String LWS_MNG_NO  = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	HashMap dateinfo = request.getAttribute("dateinfo")==null?new HashMap():(HashMap)request.getAttribute("dateinfo");
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
%>
<style>
	th{text-align:center;}
	.selFileDiv{cursor:pointer; text-decoration:underline;}
	.right{margin-bottom:0px}
</style>
<script type="text/javascript">
	var DATE_MNG_NO = "<%=DATE_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	$(document).ready(function(){
		
	});
	
	function downFile(serverfilenm, viewfilenm){
		var frm = document.frm;
		frm.Serverfile.value = serverfilenm;
		frm.Pcfilename.value = viewfilenm;
		//frm.fkey.value = "SUIT";
		frm.action = "${pageContext.request.contextPath}/Download.do";
		frm.submit();
	}
	
	function dateDel(){
		if(confirm("등록 된 제출/송달서면도 함께 삭제됩니다.\n삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteCaseDate.do",
				data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO, DATE_MNG_NO:DATE_MNG_NO},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					opener.goReLoad();
					window.close();
				}
			});
		}
	}
	
	function goDateEdit(){
		opener.goTabWrite(DATE_MNG_NO);
		window.close();
	}
</script>
<strong class="popTT">
	기일 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="DATE_MNG_NO" id="DATE_MNG_NO" value="<%=DATE_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO" id="LWS_MNG_NO" value="<%=LWS_MNG_NO%>"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<input type="hidden" name="Serverfile" id="Serverfile" value="" />
	<input type="hidden" name="Pcfilename" id="Pcfilename" value="" />
	<input type="hidden" name="folder" id="folder" value="SUIT" />

	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>기일종류</th>
					<td><%=dateinfo.get("DATE_TYPE_NM")==null?"":dateinfo.get("DATE_TYPE_NM").toString()%></td>
					<th>일자</th>
					<td><%=dateinfo.get("DATE_YMD")==null?"":dateinfo.get("DATE_YMD").toString()%></td>
					<th>시간</th>
					<td><%=dateinfo.get("VIEWTIME")==null?"":dateinfo.get("VIEWTIME").toString()%></td>
				</tr>
				<tr>
					<th>장소</th>
					<td colspan="5"><%=dateinfo.get("DATE_PLC_NM")==null?"":dateinfo.get("DATE_PLC_NM").toString()%></td>
				</tr>
				<tr>
					<th>기일결과</th>
					<td colspan="5">
						<%= dateinfo.get("DATE_RSLT_CN")==null?"":dateinfo.get("DATE_RSLT_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>결과메모</th>
					<td colspan="5">
						<%= dateinfo.get("DATE_RSLT_MEMO_CN")==null?"":dateinfo.get("DATE_RSLT_MEMO_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="5">
						<%= dateinfo.get("DATE_CN")==null?"":dateinfo.get("DATE_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="5">
						<%= dateinfo.get("RMRK_CN")==null?"":dateinfo.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>알림유무</th>
					<td><%=dateinfo.get("NOTI_YN")==null?"":dateinfo.get("NOTI_YN").toString()%></td>
					<th>알림간격</th>
					<td colspan="3">
				<%
					String [] term = (dateinfo.get("NOTI_INV")==null?"":dateinfo.get("NOTI_INV").toString()).split(",");
					String termText = "";
					if(term[0] != ""){
						for(int i=0; i<term.length; i++){
							if("0".equals(term[i])){
								termText += "당일";
							}else{
								termText += term[i] + "일전";
							}
							if(i+1 != term.length){
								termText += ", ";
							}
						}
					}else{
						termText = "알림없음";
					}
				%>
					<%=termText%>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="fileList" height="150px" colspan="5">
					<%
						for(int f=0; f<fileList.size(); f++) {
							HashMap file = (HashMap)fileList.get(f);
					%>
							<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
								<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
							</div>
					<%
						}
					%>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type2" onclick="goDateEdit();">수정</a>
			<a href="#none" class="sBtn type3" onclick="dateDel();">삭제</a>
		</div>
	</div>
</form>