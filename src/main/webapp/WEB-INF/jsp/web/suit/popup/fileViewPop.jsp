<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String ordgbn = request.getAttribute("ordgbn")==null?"":request.getAttribute("ordgbn").toString();
	String filePath = request.getAttribute("filePath")==null?"":request.getAttribute("filePath").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String schTxt = request.getAttribute("schTxt")==null?"":request.getAttribute("schTxt").toString();
	
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");
%>
<style>
	.popW{height:100%}
	#innerbody{height:720px;}
	th{text-align:center}
	select{width:80%}
	#gbnCh{cursor:pointer; text-decorjation:underline;}
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
	var ordgbn = "<%=ordgbn%>";
	
	var serfileList = new Array();
	var viewfileList = new Array();
	var delFileidList = new Array();
	var allDelList = new Array();
	var delFileIndex = 0;
	
	$(document).ready(function(){
		if(ordgbn != "") {
			var ordList = ordgbn.split(",");
			$("input:checkbox[id='ordgbn0']").attr("checked", false);
			
			for(var i=0; i<=ordList.length; i++) {
				$("input:checkbox[name='ordgbn"+(ordList[i])+"']").attr("checked", true);
			}
		}
		
		$(".ordchk").change(function(e){
			if(this.id != "ordgbn0"){
				// 전체가 아닌 항목 선택 시 "전체" 체크 해제
				$("input:checkbox[id='ordgbn0']").attr("checked", false);
			}else{
				// 전체 체크 시 모든 체크 된 항목 체크 해제
				for(var i=1; i<11; i++){
					$("input:checkbox[id='ordgbn"+i+"']").attr("checked", false);
				}
			}
		});
		
		$("#sschTxt").keydown(function(key) {
			if (key.keyCode == 13) {
				schFile();
			}
		});
	});
	
	// 선택 파일 list화
	function delChk(fileid, serverfilenm){
		delFileidList[delFileIndex] = fileid+","+serverfilenm;
		delFileIndex = delFileIndex+1;
	}
	
	// 선택 파일 삭제
	function fileChkDelete(){
		if(document.getElementById("allChk").checked == true){
			var cnt = $("#cnt").val();
			for(var i=0; i<(cnt+1); i++){
				var splVal = allDelList[i].split(',');
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/suit/fileDelete.do",
					data:{fileid:splVal[0], serverfilenm:splVal[1]},
					dataType:"json",
					async:false,
					success:function(result){
						if(i == (cnt-1)){
							alert("삭제 되었습니다.");
							reLoadPop();
						}
					}
				});
			}
		} else {
			for(var i=0; i<delFileIndex; i++){
				var splVal = delFileidList[i].split(',');
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/suit/fileDelete.do",
					data:{fileid:splVal[0], serverfilenm:splVal[1]},
					dataType:"json",
					async:false,
					success:function(result){
						if(i == (delFileIndex-1)){
							alert("삭제 되었습니다.");
							reLoadPop();
						}
					}
				});
			}
		}
		
	}
	
	function delFile(fileid, serverfilenm){
		if(confirm("파일을 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/fileDelete.do",
				data:{FILE_MNG_NO:fileid, serverfilenm:serverfilenm},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					location.reload();
				}
			});
		}
	}
	
	function download(serverfilenm, viewfilenm){
		var frm = document.frm;
		frm.Serverfile.value = serverfilenm;
		frm.Pcfilename.value = viewfilenm;
		frm.action = "${pageContext.request.contextPath}/Download.do";
		frm.submit();
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
					height : '700px',
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
				data : { fileName : serverfilenm, gbn : 'fileview'}, // 호출할 url 에 있는 페이지로 넘길 파라메터
				success : function(result){
					$("#viewEtc").html(result);
					//document.getElementsByName("HwpControl").style("height", "745px;");
				}
			});
		}else if(ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG"){
			$("#viewEtc").html("<img id='innerbody' style='width:95%'></img>");
			$("#innerbody").attr("src", "${pageContext.request.contextPath}/dataFile/suit/"+serverfilenm);
		}
	}
	
	function fileAllDown(){
		var ordgbn = "";
		if(!$("#ordgbn0").is(":checked")){
			for(var i=1; i<=10; i++){
				if($("#ordgbn"+i).is(":checked")){
					$("input:checkbox[id='ordgbn"+i+"']").val(1);
					ordgbn += i +",";
				}
			}
			if(ordgbn.length > 1){
				$("#ordgbn").val(ordgbn.substring(0,ordgbn.length-1));
			}
		}else{
			$("#ordgbn").val("");
		}
		
		var ordgbn = $("#ordgbn").val();
		var docgbncd = $("#docgbncd").val();
		
		var chkfile = "";
		if(delFileIndex > 0){
			for(var i=0; i<delFileIndex; i++){
				var splVal = delFileidList[i].split(',');
				chkfile += splVal[0] + ",";
			}
			if(chkfile.length > 1){
				$("#chkfile").val(chkfile.substring(0, chkfile.length-1));
			}
		}
		
		var frm = document.filefrm;
		frm.ordgbn.value = ordgbn;
		frm.action = "${pageContext.request.contextPath}/web/suit/allFileDownload.do";
		frm.submit();
	}
	
	function reLoadPop(){
		location.reload(true);
	}
	
	function selectAllFile(){
		if(document.getElementById("allChk").checked == true){
			$("input:checkbox[id='delfile']").prop("checked", true);
		}else{
			$("input:checkbox[id='delfile']").prop("checked", false);
		}
	}
	
	function schFile() {
		var gordgbn = "";
		if(!$("#ordgbn0").is(":checked")){
			for(var i=1; i<=10; i++){
				if($("#ordgbn"+i).is(":checked")){
					gordgbn += $("input:checkbox[id='ordgbn"+i+"']").val() +",";
				}
			}
			
			console.log("gordgbn : " + gordgbn);
			
			if(gordgbn.length > 1){
				$("#ordgbn").val(gordgbn.substring(0, gordgbn.length-1));
			}
		}else{
			$("#ordgbn").val("");
		}
		
		document.filefrm.schTxt = $("#sschTxt").val();
		document.filefrm.ordgbn = $("#ordgbn").val();
		document.filefrm.action="${pageContext.request.contextPath}/web/suit/fileViewPop.do";
		document.filefrm.submit();
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="Serverfile"  id="Serverfile"  value=""/>
	<input type="hidden" name="Pcfilename"  id="Pcfilename"  value=""/>
	<input type="hidden" name="folder"      id="folder"      value="SUIT" />
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="fordgbn"     id="fordgbn"     value=""/>
	<input type="hidden" name="fdocgbncd"   id="fdocgbncd"   value=""/>
	<input type="hidden" name="schTxt"      id="schTxt"      value=""/>
</form>
<strong class="popTT">
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="filefrm" name="filefrm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="ordgbn"      id="ordgbn"      value=""/>
	<input type="hidden" name="chkfile"     id="chkfile"     value=""/>
	<input type="hidden" name="cnt"         id="cnt"         value="0"/>
	
	<hr class="margin10">
	<div class="subBtnW side" style="margin:15px">
		<div class="subBtnC left">
			<a href="#none" class="sBtn type1" onclick="fileAllDown();">전체파일다운로드</a>
			<a href="#none" class="sBtn type1" onclick="fileChkDelete();">선택파일삭제</a>
		</div>
		<div class="subBtnC right" style="width:78%">
			<label><input type="checkbox" class="ordchk" name="ordgbnALL"      id="ordgbn0"   value=""        checked="checked">&nbsp;전체</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnCONF"     id="ordgbn1"   value="CONF"    >&nbsp;입증자료(피소)</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnCONT"     id="ordgbn2"   value="CONT"    >&nbsp;입증자료(제소)</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnINST"     id="ordgbn3"   value="INST"    >&nbsp;소장</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnRES"      id="ordgbn4"   value="RES"     >&nbsp;판결문</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnDOC"      id="ordgbn5"   value="DOC"     >&nbsp;제출송달</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnCOST"     id="ordgbn6"   value="COST"    >&nbsp;비용</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnCHRG"     id="ordgbn7"   value="CHRG"    >&nbsp;위임</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnBOND"     id="ordgbn8"   value="BOND"    >&nbsp;채권</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnREP"      id="ordgbn9"   value="REP"     >&nbsp;보고</label>&nbsp;
			<label><input type="checkbox" class="ordchk" name="ordgbnCHK"      id="ordgbn10"  value="CHK"     >&nbsp;검토진행</label>&nbsp;
			<input type="text" id="sschTxt" name="sschTxt" onkeydown="" value="<%=schTxt%>" style="margin-left:20px;"/>
			<a href="#none" class="sBtn type1" onclick="schFile();">검색</a>
		</div>
	</div>
	<span style="font-size:13px; color:#57b9ba; margin-left:20px;">※ pdf 뷰어가 실행되지 않는 경우, 추가 기능 관리에서 Adobe PDF Reader를 사용함으로 변경 해 주세요</span>
	<hr class="margin10">
	<div class="popC left" style="height:700px; width:50%;">
		<div class="popA" style="max-height: 700px">
			<table class="pop_listTable" id="fileList">
				<colgroup>
					<col style="width:5%;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:5%;">
					<col style="width:25%;">
				</colgroup>
				<tr>
					<th><input type="checkbox" id="allChk" name="allChk" onclick="selectAllFile();"></th>
					<th>종류</th>
					<th>파일명</th>
					<th>파일크기</th>
					<th>다운로드</th>
				</tr>
			<%
				if (fileList.size() > 0) {
					for(int f=0; f<fileList.size(); f++) {
						HashMap files = (HashMap) fileList.get(f);
			%>
				<tr>
					<td>
						<input type="checkbox" id="delfile" name="delfile" onchange="delChk('<%=files.get("FILE_MNG_NO").toString()%>', '<%=files.get("SRVR_FILE_NM").toString()%>')" />
					</td>
					<td><%=files.get("FILE_SE_NM")==null?"":files.get("FILE_SE_NM").toString()%></td>
					<td style="text-align:left;">
						<a href="#none" onclick="goView('<%=files.get("SRVR_FILE_NM").toString()%>', '<%=files.get("PHYS_FILE_NM").toString()%>')">
							<%=files.get("PHYS_FILE_NM").toString()%>
						</a>
					</td>
					<td><%=files.get("VIEW_SZ")==null?"":files.get("VIEW_SZ").toString()%></td>
					<td>
						<a href="#none" class="innerBtn" onclick="downFile('<%=files.get("PHYS_FILE_NM").toString()%>','<%=files.get("SRVR_FILE_NM").toString()%>','SUIT')">
							다운로드
						</a>
						<a href="#none" class="innerBtn" onclick="delFile('<%=files.get("FILE_MNG_NO").toString()%>', '<%=files.get("SRVR_FILE_NM").toString()%>')">
							삭제
						</a>
					</td>
				</tr>
			<%
					}
				} else {
			%>
				<tr>
					<td colspan="3">저장 된 파일이 없습니다.</td>
				</tr>
			<%
				}
			%>
			</table>
		</div>
	</div>
	<div class="popC right" style="height:700px; width:45%;">
		<div class="popA" style="overflow-y:hidden; max-height:720px;">
			<div id="viewEtc"></div>
		</div>
	</div>
</form>