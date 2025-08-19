<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String RVW_MNG_NO = request.getAttribute("RVW_MNG_NO")==null?"":request.getAttribute("RVW_MNG_NO").toString();
	String UP_RVW_MNG_NO = request.getAttribute("UP_RVW_MNG_NO")==null?"":request.getAttribute("UP_RVW_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	
	HashMap chkMap = request.getAttribute("chkMap")==null?new HashMap():(HashMap)request.getAttribute("chkMap");
	HashMap upChkMap = request.getAttribute("upChkMap")==null?new HashMap():(HashMap)request.getAttribute("upChkMap");
	List chkFile = request.getAttribute("chkFile")==null?new ArrayList():(ArrayList)request.getAttribute("chkFile");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var RVW_MNG_NO = "<%=RVW_MNG_NO%>";
	var UP_RVW_MNG_NO = "<%=UP_RVW_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var gbn = "<%=gbn%>";
	
	$(document).ready(function(){
		
	});
	
	function editChkProg(gbn){
		opener.goTabWrite(RVW_MNG_NO, RVW_MNG_NO, gbn);
		window.close();
	}
	
	function delChkProg(){
		if(confirm("첨부파일이 함께 삭제됩니다. 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteChkInfo.do",
				data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO, RVW_MNG_NO:RVW_MNG_NO},
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
</script>
<style>
	.popW{height:100%; min-width:580px;}
	.filename{cursor:pointer;}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="RVW_MNG_NO"      id="RVW_MNG_NO"      value="<%=RVW_MNG_NO%>"/>
	<input type="hidden" name="UP_RVW_MNG_NO"   id="UP_RVW_MNG_NO"   value="<%=UP_RVW_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="gbn"             id="gbn"             value="<%=gbn%>"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<strong class="popTT">
		검토 진행 관리
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC" style="height:80%">
		<div class="popA" style="height:95%">
			<table class="pop_infoTable write" style="height:100%">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>작성자</th>
					<td>
						<%=chkMap.get("WRTR_EMP_NM")==null?"":chkMap.get("WRTR_EMP_NM").toString()%>
					</td>
					<th>작성일</th>
					<td>
						<%=chkMap.get("WRT_YMD")==null?"":chkMap.get("WRT_YMD").toString()%>
					</td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="3">
						<%=chkMap.get("RVW_DMND_TTL")==null?"":chkMap.get("RVW_DMND_TTL").toString()%>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3" id="chkCont" style="height:200px;">
						<%=chkMap.get("RVW_DMND_CN")==null?"":chkMap.get("RVW_DMND_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="fileList" height="150px" colspan="3">
					<%
						for(int f=0; f<chkFile.size(); f++) {
							HashMap file = (HashMap)chkFile.get(f);
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
			<a href="#none" class="sBtn type1" onclick="editChkProg('reply');">답변</a>
			<a href="#none" class="sBtn type2" onclick="editChkProg('update');">수정</a>
			<a href="#none" class="sBtn type3" onclick="delChkProg();">삭제</a>
		</div>
	</div>
</form>
