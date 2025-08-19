<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String DOC_MNG_NO = request.getAttribute("DOC_MNG_NO")==null?"":request.getAttribute("DOC_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	HashMap docMap = request.getAttribute("docMap")==null?new HashMap():(HashMap)request.getAttribute("docMap");
	List docFile = request.getAttribute("docFile")==null?new ArrayList():(ArrayList)request.getAttribute("docFile");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr" />
<style>
	.selFileDiv{cursor:pointer; text-decoration:underline;}
	.subBtnW{margin-bottom:0px;}
	.popW{height:100%}
</style>
<script type="text/javascript">
	var DOC_MNG_NO = "<%=DOC_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	
	function editDocInfo(){
		opener.goTabWrite(DOC_MNG_NO);
		window.close();
	}
	
	function delDocInfo(){
		if(confirm("첨부파일도 함께 삭제됩니다.\n삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteDocInfo.do",
				data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO, DOC_MNG_NO:DOC_MNG_NO},
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
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="DOC_MNG_NO"  id="DOC_MNG_NO"  value="<%=DOC_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<strong class="popTT"> 제출/송달 서면 관리 <a href="#none"
		class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA" style="max-height:405px;">
			<table class="pop_infoTable">
				<colgroup>
					<col style="width: 18%;">
					<col style="width: *;">
					<col style="width: 18%;">
					<col style="width: *;">
				</colgroup>
				<tr>
					<th>관련기일</th>
					<td>
<%
					String ddate = docMap.get("DATE_YMD")==null?"":docMap.get("DATE_YMD").toString();
					if(!ddate.equals("")){
%>
						<%=ddate%> - <%=docMap.get("DATE_TYPE_NM")==null?"":docMap.get("DATE_TYPE_NM").toString()%>
<%
					}else{
%>
						관련기일없음
<%
					}
%>
					</td>
					<th>제출/송달일자</th>
					<td><%=docMap.get("DOC_YMD")==null?"":docMap.get("DOC_YMD").toString()%></td>
				</tr>
				<tr>
					<th>문서 구분</th>
					<td>
						<%=docMap.get("DOC_SE")==null?"":docMap.get("DOC_SE").toString()%>
					</td>
					<th>문서 종류</th>
					<td>
						<%=docMap.get("DOC_TYPE_NM")==null?"":docMap.get("DOC_TYPE_NM").toString()%>
					</td>
				</tr>
				<tr>
					<th>문서결과</th>
					<td colspan="3">
						<%= docMap.get("DOC_RSLT_CN")==null?"":docMap.get("DOC_RSLT_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>문서내용</th>
					<td colspan="3">
						<%= docMap.get("DOC_CN")==null?"":docMap.get("DOC_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<%= docMap.get("RMRK_CN")==null?"":docMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="fileList" height="150px" colspan="3">
					<%
						for(int f=0; f<docFile.size(); f++) {
							HashMap file = (HashMap)docFile.get(f);
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
			<a href="#none" class="sBtn type2" onclick="editDocInfo();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delDocInfo();">삭제</a>
		</div>
	</div>
</form>
