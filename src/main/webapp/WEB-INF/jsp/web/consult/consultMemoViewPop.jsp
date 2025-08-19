<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	
// 	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
// 	String memoid = request.getAttribute("memoid")==null?"":request.getAttribute("memoid").toString();
	String CNSTN_MNG_NO = request.getAttribute("CNSTN_MNG_NO")==null?"":request.getAttribute("CNSTN_MNG_NO").toString();
	String CNSTN_MEMO_MNG_NO = request.getAttribute("CNSTN_MEMO_MNG_NO")==null?"":request.getAttribute("CNSTN_MEMO_MNG_NO").toString();
	
	HashMap memoMap = request.getAttribute("memo")==null?new HashMap():(HashMap)request.getAttribute("memo");
	List fconsultlist = request.getAttribute("filelist")==null?new ArrayList():(ArrayList)request.getAttribute("filelist");
	
	String memoWriter = memoMap.get("WRTR_EMP_NO")==null?"":memoMap.get("WRTR_EMP_NO").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr" />
<style>
	.selFileDiv{cursor:pointer; text-decoration:underline;}
	.subBtnW{margin-bottom:0px;}
	.popW{height:100%}
</style>
<script type="text/javascript">
	var CNSTN_MEMO_MNG_NO  = "<%=CNSTN_MEMO_MNG_NO%>";
	var CNSTN_MNG_NO = "<%=CNSTN_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function editDocInfo(){
		opener.memoWrite(CNSTN_MEMO_MNG_NO);
		window.close();
	}
	
	function delDocInfo(){
		if(confirm("첨부파일도 함께 삭제됩니다.\n삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/consult/deleteMemo.do",
// 				data:{memoid:memoid, consultid:consultid},
				data:{CNSTN_MEMO_MNG_NO:CNSTN_MEMO_MNG_NO, CNSTN_MNG_NO:CNSTN_MNG_NO},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					closePop();
				}
			});
		}
	}
	
	function closePop() {
		opener.viewReload();
		window.close();
	}
	
	function downFile(Pcfilename,Serverfile,folder){
		form=document.ViewForm;
		form.Pcfilename.value=Pcfilename;
		form.Serverfile.value=Serverfile;
		form.folder.value=folder;
		form.action="${pageContext.request.contextPath}/Download.do";
		form.submit();
	}
</script>
<form name="ViewForm" method="post">
	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<form id="frm" name="frm" method="post" action="">
<%-- 	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
<%-- 	<input type="hidden" name="progid"     id="progid"     value="<%=memoid%>"/> --%>
<%-- 	<input type="hidden" name="consultid"  id="consultid"  value="<%=consultid%>"/> --%>
	<input type="hidden" name="CNSTN_MEMO_MNG_NO"     id="CNSTN_MEMO_MNG_NO"     value="<%=CNSTN_MEMO_MNG_NO%>"/>
	<input type="hidden" name="CNSTN_MNG_NO"  id="CNSTN_MNG_NO"  value="<%=CNSTN_MNG_NO%>"/>
	<input type="hidden" name="writerid"   id="writerid"   value="<%=writerid%>" />
	<input type="hidden" name="writer"     id="writer"     value="<%=writer%>" />
	<input type="hidden" name="deptname"   id="deptname"   value="<%=deptname%>" />
	<input type="hidden" name="deptid"     id="deptid"     value="<%=deptid%>" />
	<input type="hidden" name="Serverfile" id="Serverfile" value="" />
	<input type="hidden" name="Pcfilename" id="Pcfilename" value="" />
	<input type="hidden" name="folder"     id="folder"     value="CONSULT" />
	
	<strong class="popTT"> 자문 메모 관리 <a href="#none"
		class="popClose" onclick="closePop();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable">
				<colgroup>
					<col style="width: 18%;">
					<col style="width: *;">
					<col style="width: 18%;">
					<col style="width: *;">
					<col style="width: 18%;">
					<col style="width: *;">
				</colgroup>
				<tr>
					<th>제목</th>
					<td colspan="5">
						<%=memoMap.get("MEMO_TTL")==null?"":memoMap.get("MEMO_TTL").toString()%>
					</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td>
						<%=memoMap.get("WRTR_EMP_NM")==null?"":memoMap.get("WRTR_EMP_NM").toString()%>
					</td>
					
					<th>작성부서</th>
					<td>
						<%=memoMap.get("WRT_DEPT_NM")==null?"":memoMap.get("WRT_DEPT_NM").toString()%>
					</td>
					
					<th>작성일</th>
					<td>
						<%=memoMap.get("WRT_YMD")==null?"":memoMap.get("WRT_YMD").toString()%>
					</td>
				</tr>
				
				
				<tr>
					<th>내용</th>
					<td colspan="5" style="height:200px;">
						<%=memoMap.get("MEMO_CN")==null?"":memoMap.get("MEMO_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				
				
				<tr>
					<th>첨부파일</th>
					<td colspan="5">
						<div  id="fileList1" style="height: 200px; overflow-y: scroll;">
<%
					if (fconsultlist.size() > 0) {
						for(int f=0; f<fconsultlist.size(); f++) {
							HashMap files = (HashMap) fconsultlist.get(f);
%>
							<div class="selFileDiv" onclick="downFile('<%=files.get("DWNLD_FILE_NM").toString()%>', '<%=files.get("SRVR_FILE_NM").toString()%>', 'CONSULT')">
								<%=files.get("DWNLD_FILE_NM").toString()%> (<%=files.get("VIEW_SZ").toString()%>)
							</div>
<%
						}
					}
%>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
<%
		if(USERNO.equals(memoWriter)){
%>
			<a href="#none" class="sBtn type2" onclick="editDocInfo();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delDocInfo();">삭제</a>
<%
		}
%>
		</div>
	</div>
</form>
