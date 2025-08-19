<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String filePath = request.getAttribute("filePath")==null?"":request.getAttribute("filePath").toString();
	
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");
	

	Date now = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
	String formatedNow = formatter.format(now);
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
%>
<style>
	th {text-align: center;}
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
	var formatedNow = "<%=formatedNow%>";
	var serfileList = new Array();
	var viewfileList = new Array();
	var delFileidList = new Array();
	var delFileIndex = 0;
	
	$(document).ready(function(){
		$("#loading").hide();
		
		var dummyscript = document.createElement('iframe');
		dummyscript.setAttribute("id","lkrms");
		dummyscript.setAttribute("style","display:none");
		document.body.appendChild(dummyscript);
		document.getElementById("lkrms").setAttribute('src', 'lkrms6::/<data><exeform>check</exeform><callUrl>'+URLINFO+'/dll/<%=USERNO%>/setSession.do</callUrl></data>');
		
		setTimeout(function(){
			$.ajax({
				type : "POST",
				url : CONTEXTPATH + "/dll/InstallChk.do",
				datatype: "json",
				error: function(){
					
				},
				success:function(data){
					var result = JSON.parse(data);
					if(result.result=='X'){
						alert("원할한 원규관리시스템 이용을 위하여 mtenViewer.exe를 설치 하시기 바랍니다.");
						window.open(CONTEXTPATH+"/resources/edit/mtenViewer.exe");
					}
				}
			});
		}, 3000);
	});
	
	// 선택 파일 list화
	function delChk(fileid, serverfilenm){
		delFileidList[delFileIndex] = fileid+","+serverfilenm;
		delFileIndex = delFileIndex+1;
	}
	
	function reLoadPop(){
		location.reload(true);
	}
	
	// 선택 파일 삭제
	function fileChkDelete(){
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
	
	function goMakeGian(writegbn, gbn, docgbn){
		
		var urlInfo = '';
		var path = '';
		if(writegbn == '1'){
			urlInfo = "SaveContentDoc.do";
			path = 'doctype';
		}else{
			urlInfo = "UpdateContentDoc.do";
			path = 'suit';
		}
		
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/goMakeGian.do",
			data : {
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				GETDATE:formatedNow,
				gbn:gbn,
				docgbn:'SUIT',
				writegbn:writegbn,
				DOC_SE:gbn
			},
			datatype: "json",
			error: function(){},
			success:function(data){
				data = Ext.util.JSON.decode(data);
				
				var fileid = data.fnm.split(",");
				
				var obj = new HashMap();
				obj.put("write",      writegbn);
				obj.put("file",       URLINFO + "/dataFile/"+path+"/"+fileid[0]);
				obj.put("gianurl",    "/dll/SaveContentDoc.do");
				obj.put("saveurl",    URLINFO + "/dll/"+urlInfo);
				obj.put("AutoReport", data.id);
				chkSetUp(makeDocXML(obj));
				
				Ext.MessageBox.show({
					title : "알림",
					msg : "<span id=\"msgTxt\">문서를 서버에 저장한 후 확인 버튼을 클릭하세요.<br/>※ 미리 누르면 문서가 저장되지 않습니다.</span>",
					icon : Ext.MessageBox.WARNING,
					buttons:Ext.MessageBox.OK,
					width:410,
					fn:function(btn){
						console.log(btn);
						if(btn == "ok"){
							reLoadPop();
						}
					}
				});
			}
		});
	}
	
	function getChkFile(){
		console.log(delFileidList);
		var len = delFileIndex;
		for(var i=0; i<len; i++){
			console.log(delFileidList[i]);
		}
	}
	
	function goSelGianFile(giangbn) {
		var cw=800;
		var ch=500;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","newEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "newEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/gianSelFilePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"giangbn", value:giangbn}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
		
		//goOnsStart(giangbn)
	}
	
	function goOnsStart(giangbn, viewFile, serverFile){
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/gian/ons/gianOnsStart.do",
			data : {
				LWS_MNG_NO  : $("#LWS_MNG_NO").val(),
				INST_MNG_NO : $("#INST_MNG_NO").val(),
				DOCGBN    : 'SUIT',
				DOCID     : $("#LWS_MNG_NO").val(),
				SUBDOCID  : $("#INST_MNG_NO").val(),
				FPATH     : 'SUIT',
				STATECD   : '',
				NSTATECD  : '완료',
				OKSTATECD : '완료',
				NOSTATECD : '완료',
				giangbn   : giangbn,
				FNM       : viewFile,
				SNM       : serverFile
			},
			datatype: "json",
			async:true,
			error: function(){},
			success:function(data){
				$("#loading").hide();
				alert("결재문서가 생성되었습니다. 문서함을 확인하세요");
			},
			beforeSend:function(){
				$("#loading").show();
			},
			complete:function(){
				$("#loading").hide();
			}
		});
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="Serverfile"  id="Serverfile"  value=""/>
	<input type="hidden" name="Pcfilename"  id="Pcfilename"  value=""/>
	<input type="hidden" name="folder"      id="folder"      value="SUIT" />
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>" />
	<input type="hidden" name="fordgbn"     id="fordgbn"     value=""/>
	<input type="hidden" name="fdocgbncd"   id="fdocgbncd"   value=""/>
</form>
<strong class="popTT">
	소송문서양식관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="filefrm" name="filefrm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>" />
	<input type="hidden" name="ordgbn"      id="ordgbn"      value=""/>
	<input type="hidden" name="chkfile"     id="chkfile"     value=""/>
	<input type="hidden" name="cnt"         id="cnt"         value="0"/>
	
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	<div id="exeChk"><a id="aExeChk" href=""></a></div>
	
	<div class="popC left" style="height:800px; width:50%;">
		<div id="subTitle" style="margin:0px 0px 15px 15px;"><strong class="countT">결재문서</strong></div>
		<table class="pop_listTable">
			<colgroup>
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>문서 종류</th>
			</tr>
		</table>
		<div class="popA" style="height:350px; overflow-y:scroll;">
			<table class="pop_listTable">
				<colgroup>
					<col style="width:*;">
				</colgroup>
				<tr>
					<td style="text-align:left">
						<a href="#none" class="sBtn type1" id="so1" onclick="goMakeGian('1', 'SO1', '소송사무보고');">소송사무보고</a>
					</td>
				</tr>
				<tr>
					<td style="text-align:left">
						<a href="#none" class="sBtn type1" id="so1" onclick="goMakeGian('1', 'SO2', '소송진행상황보고');">소송진행상황보고</a>
					</td>
				</tr>
				<tr>
					<td style="text-align:left">
						<a href="#none" class="sBtn type1" id="so1" onclick="goMakeGian('1', 'SO3', '응소관련 자료제출 양식');">응소관련 자료제출 양식</a>
					</td>
				</tr>
				<tr>
					<td style="text-align:left">
						<a href="#none" class="sBtn type1" id="so1" onclick="goMakeGian('1', 'SO4', '협조요청문');">협조요청문</a>
					</td>
				</tr>
				<tr>
					<td style="text-align:left">
						<a href="#none" class="sBtn type1" id="so1" onclick="goMakeGian('1', 'SO5', '판결문 접수에 따른 지원부서 의견요청');">판결문 접수에 따른 지원부서 의견요청</a>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin10">
		<div class="popA">
			<div class="subBtnW side" style="margin:15px">
				<div class="subBtnC left" style="width:35%">
					<div id="subTitle"><strong class="countT">저장 된 결재문서</strong></div>
				</div>
				<div class="subBtnC right" style="width:65%">
					<a href="#none" class="sBtn type1" onclick="fileChkDelete();" style="float:right;">선택파일삭제</a>
				</div>
			</div>
			<table class="pop_listTable">
				<colgroup>
					<col style="width:5%;">
					<col style="width:*;">
					<col style="width:22%;">
				</colgroup>
				<tr>
					<th></th>
					<th>파일명</th>
					<th></th>
				</tr>
			</table>
			<div style="max-height:262px; overflow-y:scroll;">
				<table class="pop_listTable" id="fileList">
					<colgroup>
						<col style="width:5%;">
						<col style="width:*;">
						<col style="width:20%;">
					</colgroup>
			<%
				if (fileList.size() > 0) {
					for(int f=0; f<fileList.size(); f++) {
						HashMap files = (HashMap) fileList.get(f);
			%>
					<tr>
						<td>
							<input type="checkbox" id="delfile" name="delfile" onchange="delChk('<%=files.get("FILE_MNG_NO").toString()%>', '<%=files.get("SRVR_FILE_NM").toString()%>')" />
						</td>
						<td>
							<%=files.get("FILE_SE_NM").toString()%>
						</td>
						<td>
							<a href="#none" class="innerBtn" onclick="goMakeGian('3', '<%=files.get("FILE_SE").toString()%>', '<%=files.get("PHYS_FILE_NM").toString()%>')">기안수정</a>
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
	</div>
	<div class="popC right" style="height:800px; width:45%;">
		<div id="subTitle" style="margin:0px 0px 15px 15px;"><strong class="countT">전자결재</strong></div>
		<table class="pop_listTable">
			<colgroup>
				<col style="width:58%;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>결재명</th>
				<th>결재신청</th>
			</tr>
		</table>
		<div class="popA" style="overflow-y:scroll; max-height:730px;">
			<table class="pop_listTable">
				<colgroup>
					<col style="width:60%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<td>소송사무보고(소장 접수)</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT1');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>소장 접수에 따른 입증자료 제출 요청</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT2');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>소장 접수에 따른 입증자료 제출</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT3');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>응소방침</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT4');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>대리인(변호사) 및 소송담당자 지정 통보</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT5');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>소송수행자 지정 통보</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT6');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>진행상황 통보</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT7');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>소송사무보고(변론기일 출석)</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT8');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>소송사무보고(판결문 접수)</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT9');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>판결문 접수에 따른 상고(포기)여부 의견제출 요청</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT10');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>판결문 접수에 따른 의견제출</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT11');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>즉시항고 포기방침</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT12');">결재문서생성</a></td>
				</tr>
				<tr>
					<td>소송사무보고(종결)</td>
					<td><a href="#none" class="sBtn type1" onclick="goSelGianFile('SUIT13');">결재문서생성</a></td>
				</tr>
			</table>
		</div>
	</div>
</form>