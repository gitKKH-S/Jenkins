<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String giangbn = request.getAttribute("giangbn")==null?"":request.getAttribute("giangbn").toString();
	String filePath = request.getAttribute("filePath")==null?"":request.getAttribute("filePath").toString();
	
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");

	Date now = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
	String formatedNow = formatter.format(now);
%>
<style>
	
</style>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script src="${resourceUrl}/PDFObject-master/pdfobject.min.js" type="text/javascript"></script>
<script type="text/javascript">
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var giangbn = "<%=giangbn%>";
	
	function fileSelConfirm() {
		var fileDoc = document.getElementsByName("selfile");
		var leng = fileDoc.length;
		var sFileList = "";	// vo1값 구분자 | 로 이어넣기
		var vFileList = "";
		
		for(var i=0; i<leng; i++) {
			if(fileDoc[i].checked == true) {
				vFileList += $(fileDoc[i]).attr('vo1')+"|";
				sFileList += $(fileDoc[i]).attr('vo2')+"|";
			}
		}
		
		if (vFileList.endsWith("|")) {
			vFileList = vFileList.slice(0, -1);
		}
		
		if (sFileList.endsWith("|")) {
			sFileList = sFileList.slice(0, -1);
		}
		
		if(vFileList == "") {
			if(confirm("첨부문서 없이 결재를 수행하시겠습니까?")){
				opener.goOnsStart(giangbn, vFileList, sFileList);
				window.close();
			}
		} else {
			opener.goOnsStart(giangbn, vFileList, sFileList);
			window.close();
		}
		
	}
</script>
<strong class="popTT">
	결재문서선택
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="filefrm" name="filefrm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>" />
	<div class="popC">
		<div class="popA">
			<div>
				<table class="pop_listTable" id="fileList">
					<colgroup>
						<col style="width:5%;">
						<col style="width:*;">
					</colgroup>
			<%
				if (fileList.size() > 0) {
					for(int f=0; f<fileList.size(); f++) {
						HashMap files = (HashMap) fileList.get(f);
			%>
					<tr>
						<td>
							<input type="checkbox" id="selfile" name="selfile" vo1="<%=files.get("PHYS_FILE_NM").toString()%>" vo2="<%=files.get("SRVR_FILE_NM").toString()%>"/>
						</td>
						<td>
							<%=files.get("FILE_SE_NM").toString()%>
						</td>
					</tr>
			<%
					}
				} else {
			%>
				<tr>
					<td colspan="2">저장 된 파일이 없습니다.</td>
				</tr>
			<%
				}
			%>
				</table>
			</div>
		</div>
	</div>
	
	<hr class="margin40">
	<div class="subBtnW center">
		<a href="#none" class="sBtn type1" onclick="fileSelConfirm();"><i class="fa-regular fa-floppy-disk"></i>선택완료</a>
	</div>
</form>