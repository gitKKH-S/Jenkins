<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String filePath = request.getAttribute("filePath")==null?"":request.getAttribute("filePath").toString();
%>
<style>
	.popW{height:100%}
	th{text-align:center;}
	#innerbody{height:720px;}
	.hkk{overflow-y:scroll}
</style>

<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/PDFObject-master/pdfobject.min.js" type="text/javascript"></script>
<script type="text/javascript">
	var LWS_MNG_NO  = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var fileidList = new Array();
	
	$(document).ready(function(){
		schFile();
		
		$(".docChk").change(function(e){
			if(this.id != "doctypeAll"){
				// 전체가 아닌 항목 선택 시 "전체" 체크 해제
				$("input:checkbox[id='doctypeAll']").attr("checked", false);
			}else{
				// 전체 체크 시 모든 체크 된 항목 체크 해제
				for(var i=1; i<3; i++){
					$("input:checkbox[id='doctype"+i+"']").attr("checked", false);
				}
			}
		});
	});
	
	function schFile(){
		$('.coFileList').remove();
		
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectCourtFileList.do",
			data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				if(result.flist.length > 0){
					var cnt = 1;
					$.each(result.flist, function(index, val){
						html += "<tr class=\"coFileList\">";
						html += "<td><input type='checkbox' class='chkFiles' name='chkFile' id='chkFile"+val.LWS_DOC_MNG_NO+"' value='"+val.LWS_DOC_MNG_NO+"'></td>";
						html += "<td>"+cnt+"</td>";
						html += "<td>"+val.DOC_CRTR_YMD+"</td>";
						html += "<td class='docgbn'>"+val.DOC_KND_NM+"</td>";
						html += "<td class='viewname'>";
						html += "<a href=\"#none\" onclick=\"goView('"+val.SRVR_FILE_NM+"','"+val.ORGNL_FILE_NM+"')\">"+val.DOC_NM+"</a>";
						html += "</td>";
						html += "<td>"+val.VIEW_SZ+"</td>";
						html += "<td>";
						html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"downFile('"+val.ORGNL_FILE_NM+"','"+val.SRVR_FILE_NM+"','SUIT')\">다운로드</a>";
						html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"delCourFile('"+val.LWS_DOC_MNG_NO+"','"+val.SRVR_FILE_NM+"')\">삭제</a>";
						html += "</td>";
						html += "</tr>";
						cnt ++;
					});
				}else{
					html += "<tr class=\"coFileList\"><td colspan='5'>등록 된 전자소송 파일이 없습니다.</td></tr>";
				}
				
				$("#courtFileList").append(html);
			}
		});
	}
	
	function delCourFile(LWS_DOC_MNG_NO, serverfilenm){
		if(confirm("파일을 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/courtFileDelete.do",
				data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO, LWS_DOC_MNG_NO:LWS_DOC_MNG_NO},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					location.reload();
				}
			});
		}
	}
	
	function goView(serverfilenm, viewfilenm){
		var idx = serverfilenm.lastIndexOf(".");
		var ext = serverfilenm.substring(idx+1);
		
		var filenm = serverfilenm.substring(0, idx);
		
		if(ext == "zip" || ext == "ZIP" || ext == "alz" || ext == "EGG" || ext == "MPG" || ext == "mp3" || ext == "mp4" || ext == "avi"){
			return alert("확장자 " + ext + " 형식의 파일은 미리보기를 지원하지 않습니다.");
		}
		
		var location = "";
		if(ext == "PDF" || ext == "pdf"){
			$("#viewEtc").html("<div id='innerbody'></div>");
			var options = {
					height : $("#viewEtc").css("height"),
					page : '2',
					pdfOpenParams : {
						view : 'FitV',
						pagemode : 'thumbs'
					}
				};
			PDFObject.embed("${pageContext.request.contextPath}/dataFile/suit/"+serverfilenm, "#innerbody");
		}else if(ext == "hwp" || ext == "HWP" || ext == "doc" || ext == "DOC"){
			$.ajax({
				url : '${pageContext.request.contextPath}/web/suit/goHwp.do',
				dataType : "html",
				type : "post", // post 또는 get
				data : { fileName : serverfilenm}, // 호출할 url 에 있는 페이지로 넘길 파라메터
				success : function(result){
					$("#viewEtc").html(result);
				}
			});
		}
	}
	
	function fileUpload(){
		var cw=800;
		var ch=400;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","uploadPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "uploadPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/courtFileUploadPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"court"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function reLoadPop(){
		location.reload(true);
	}
	
	function fileDownload() {
		var chkFile = [];
		$("input[name=chkFile]:checked").each(function(){
			var chk = $(this).val();
			chkFile.push(chk);
		});
		
		if (chkFile != "") {
			var newForm = $('<form></form>');
			newForm.attr("name", "down");
			newForm.attr("method", "post");
			newForm.attr("action", CONTEXTPATH+"/web/suit/allCourtFileDownload.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
			newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
			newForm.append($("<input/>", {type:"hidden", name:"chkFile", value:chkFile}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
		} else {
			return alert("선택 된 파일이 없습니다.");
		}
	}
	
	function fileDelete() {
		if(confirm("선택 한 파일을 삭제하시겠습니까?")){
			var chkFiles = "";
			$("input[name=chkFile]:checked").each(function(){
				var chk = $(this).val();
				//chkFiles.push(chk);
				chkFiles += chk + ",";
			});
			
			var chkFileList = chkFiles;
			
			if (chkFileList != "") {
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/suit/allCourtFileDelete.do",
					data:{chkFile:chkFileList, LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO},
					dataType:"json",
					async:false,
					success:function(result){
						alert(result.msg);
						var frm = document.frm;
						frm.action = "${pageContext.request.contextPath}/web/suit/courtFileViewPop.do";
						frm.submit();
					}
				});
			} else {
				return alert("선택 된 파일이 없습니다.");
			}
		}
	}
</script>
<strong class="popTT">
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<!-- 일괄 다운로드 -->
<form id="frm" name="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" id="doctype" name="doctype" value="" />
	<input type="hidden" id="schtxt" name="schtxt" value="" />
	
</form>
<!-- 개별 다운로드 -->
<form id="filefrm" name="filefrm" method="post" action="">
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	
	<input type="hidden" name="Serverfile" id="Serverfile" value=""/>
	<input type="hidden" name="Pcfilename" id="Pcfilename" value=""/>
	<input type="hidden" name="folder" id="folder" value="SUIT" />
</form>
<hr class="margin10">
<div class="subBtnW side" style="margin:15px">
	<div class="subBtnC left">
		<a href="#none" class="sBtn type1" onclick="fileUpload();">파일업로드</a>
		
		<a href="#none" class="sBtn type1" onclick="fileDownload();">선택파일다운로드</a>
		<a href="#none" class="sBtn type1" onclick="fileDelete();">선택파일삭제</a>
	</div>
	<div class="subBtnC right">
		
	</div>
</div>
<div class="popC left" style="height:745px;">
	<div class="popA">
		<table class="pop_listTable" style="width: 99.9%">
			<colgroup>
				<col style="width:4%;">
				<col style="width:6%;">
				<col style="width:12%;">
				<col style="width:18%;">
				<col style="width:*;">
				<col style="width:6%;">
				<col style="width:24%;">
			</colgroup>
			<tr>
				<th>
					<input type="checkbox" class="chkFiles" name="chkFile" id="chkFileAll" value="0">
				</th>
				<th>NO</th>
				<th>기준일자</th>
				<th>종류</th>
				<th>문서명</th>
				<th>파일크기</th>
				<th>다운로드</th>
			</tr>
		</table>
	</div>
	<div class="popA" style="height:680px; max-height:800px; overflow-y:scroll;">
		<table class="pop_listTable" id="courtFileList">
			<colgroup>
				<col style="width:4.1%;">
				<col style="width:6.1%;">
				<col style="width:12.5%;">
				<col style="width:18.4%;">
				<col style="width:*;">
				<col style="width:6.1%;">
				<col style="width:22%;">
			</colgroup>
		</table>
	</div>
</div>
<div class="popC right" style="height:720px; width:45%;">
	<div class="popA" style="overflow-y:hidden; max-height:720px;">
		<div id="viewEtc"></div>
	</div>
</div>