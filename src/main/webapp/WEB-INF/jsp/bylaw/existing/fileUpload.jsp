<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="com.mten.bylaw.bylaw.service.*"%>
<%@ page import="java.util.*"%>
<%
	String Bookid = request.getParameter("Bookid")==null?"":request.getParameter("Bookid");
	String noFormYn = request.getParameter("noFormYn")==null?"":request.getParameter("noFormYn");
	String statehistoryid = request.getParameter("statehistoryid")==null?"":request.getParameter("statehistoryid");
	
	HashMap doc0 = null;//개정안
	HashMap doc1 = null;//개정문
	HashMap doc2 = null;//전문
	HashMap doc3 = null;//신구조문
	HashMap doc4 = null;//개정이유
	HashMap doc5 = null;//의견서
	String doc0FileId="";
	String doc1FileId="";
	String doc2FileId="";
	String doc3FileId="";
	String doc4FileId="";
	String doc5FileId="";
	
	ArrayList byulList = new ArrayList();	//별표
	
	ArrayList etcList = new ArrayList();	//관련문서
	
	
	BylawService blService = BylawServiceHelper.getBylawService(application);
	HashMap para = new HashMap();
	para.put("bookid", Bookid);
	para.put("statehistoryid", statehistoryid);
	List attList = blService.getAttList(para);
	
	List imList = blService.getSIMlist(Bookid);
	
	int attListSize = attList.size();
	if(attList !=null && attListSize>0){
		for(int i=0; i<attListSize; i++){
			HashMap tmpBean = (HashMap)attList.get(i);
			String fileCd = tmpBean.get("FILECD")==null?"":tmpBean.get("FILECD").toString();
			String contId = tmpBean.get("CONTID")==null?"":tmpBean.get("CONTID").toString();
			if(fileCd.equals("AN")){
				doc0 = tmpBean;
				doc0FileId = doc0.get("FILEID")==null?"":doc0.get("FILEID").toString();
			}else if(fileCd.equals("GAE")){
				doc1 = tmpBean;
				doc1FileId = doc1.get("FILEID")==null?"":doc1.get("FILEID").toString();
			}else if(fileCd.equals("JUN")){
				doc2 = tmpBean;
				doc2FileId = doc2.get("FILEID")==null?"":doc2.get("FILEID").toString();
			}else if(fileCd.equals("SIN")){
				doc3 = tmpBean;
				doc3FileId = doc3.get("FILEID")==null?"":doc3.get("FILEID").toString();
			}else if(fileCd.equals("REA")){
				doc4 = tmpBean;
				doc4FileId = doc4.get("FILEID")==null?"":doc4.get("FILEID").toString();
			}else if(fileCd.equals("VIEW")){
				doc5 = tmpBean;
				doc5FileId = doc5.get("FILEID")==null?"":doc5.get("FILEID").toString();		
			}else if((contId.equals("") || contId.equals("0")) &&(fileCd.equals("별표")|| fileCd.equals("BYUL"))){
				byulList.add(tmpBean);
			}else if(fileCd.equals("ETC")||fileCd.equals("BUSIN")||fileCd.equals("BURES")||fileCd.equals("SIMSAVIEW")){
				etcList.add(tmpBean);
			}
		}
	}
%>
<script type="text/javascript">
var isDoc0 = false;
var isDoc1 = false;
var isDoc2 = false;
var isDoc3 = false;
var isDoc4 = false;
var isDoc5 = false;
<% if(doc0!=null) {%>isDoc0 = true;<%}%>
<% if(doc1!=null) {%>isDoc1 = true;<%}%>
<% if(doc2!=null) {%>isDoc2 = true;<%}%>
<% if(doc3!=null) {%>isDoc3 = true;<%}%>
<% if(doc4!=null) {%>isDoc4 = true;<%}%>
<% if(doc5!=null) {%>isDoc5 = true;<%}%>
var byulNum = 1;
var etcNum = 1;
var extArray = new Array("txt", "pdf", "doc", "docx", "hwp", "hwx", "hox", "tif", "xls", "xlsx", "ppt", "pptx", "gif","rtf", "jpg","zip");
function LimitAttach(form,file) {
	allowSubmit = false;
	if (!file){
		allowSubmit = false;
		return allowSubmit;
	}
	var firstList = file.split(".");
	var ext = "."+firstList[1];
	for (var i = 0; i < extArray.length; i++) {
		if (extArray[i] == firstList[firstList.length-1].toLowerCase()) {
			allowSubmit = true;
			break;
		}
	}
	if(!allowSubmit){
		alert("죄송합니다.업로드가 지원되는 파일형식은 "
				+ (extArray.join(" ")) + " 입니다."
				+ "파일형식을 확인해보시기 바랍니다.");
		dell(form.id);
		
	}
	return allowSubmit;
}
function dell(id){
	if(id=='ffDoc_001' || id=='ffDoc_002' || id=='ffDoc_003' || id=='ffDoc_004'|| id=='ffDoc_006' || id=='ffDoc_006'){
		var tdTmp = document.getElementById(id).parentNode;
		var html='<input onchange="LimitAttach(this,this.value)" type="file" name="'+id+'" id="'+id+'" />';
		tdTmp.innerHTML = html; 
	}else if(id=='ffDoc_007'){
		var divTmp = document.getElementById(id).parentNode;
		var html='<input onchange="LimitAttach(this,this.value)" style="width:470px; margin:3px 0 3px 0;" type="file" name="ffDoc_007" id="ffDoc_007" /><img onclick="addByul();" style="cursor: pointer;" src="${resourceUrl}/images/common/button/but-addfile-small.gif" alt="추가" align="absmiddle" />';
		divTmp.innerHTML = html;
	}else{
		var divTmp = document.getElementById(id).parentNode;
		var html='<input onchange="LimitAttach(this,this.value)" style="width:470px; margin:3px 0 3px 0;" type="file" name="'+id+'" id="'+id+'" /><img onclick="delByul(this);" style="cursor: pointer;" src="${resourceUrl}/images/common/button/but-delfile-small.gif" alt="삭제" align="absmiddle" />';
		divTmp.innerHTML = html;
	}
 }

function addByul(){
	var byulDiv = document.createElement('div');
	byulDiv.id = 'byul_'+byulNum;
	var html = '<input onchange="LimitAttach(this,this.value)" style="width:570px;margin:3px 0 3px 0;" type="file" name="ffDoc_007_'+byulNum+'" id="ffDoc_007_'+byulNum+'" />'+
				'<img onclick="delByul(this);" style="cursor:pointer;" src="${resourceUrl}/images/common/button/but-delfile-small.gif" alt="삭제" align="absmiddle" />';
	byulNum++;
	byulDiv.innerHTML=html;
	var byulTD = document.getElementById('td_byul');
	byulTD.appendChild(byulDiv);

}
function delByul(obj){
	var byulTD = document.getElementById('td_byul');
	var delDiv = obj.parentNode;
	byulTD.removeChild(delDiv);
}
function addEtc(){
	var etcDiv = document.createElement('div');
	etcDiv.id = 'etc_'+etcNum;
	var html = '<input onchange="LimitAttach(this,this.value)" style="width:570px;margin:3px 0 3px 0;" type="file" name="ffDoc_008_'+etcNum+'" id="ffDoc_008_'+etcNum+'" />'+
				'<img onclick="delEtc(this);" style="cursor:pointer;" src="${resourceUrl}/images/common/button/but-delfile-small.gif" alt="삭제" align="absmiddle" />';
	etcNum++;
	etcDiv.innerHTML=html;
	var etcTD = document.getElementById('td_etc');
	etcTD.appendChild(etcDiv);

}
function delEtc(obj){
	var etcTD = document.getElementById('td_etc');
	var delDiv = obj.parentNode;
	etcTD.removeChild(delDiv);
}
function showFileForm(obj){
	var chkId = obj.id;
	var isChecked = obj.checked;
	if(chkId =='chk_doc0'){
		if(isChecked){
			if(isDoc0){
				if(confirm('이미 등록된 파일이 있습니다. 삭제하시겠습니까?')){
					delFile(<%=doc0FileId%>);
				}else{
					obj.checked = false;
				}
			}else{
				document.getElementById('div_doc001').style.display='';			
			}
		}else{
			var html='<input onchange="LimitAttach(this,this.value)" type="file" name="ffDoc_001" id="ffDoc_001" />';
			document.getElementById('td_doc001').innerHTML = html;
			document.getElementById('div_doc001').style.display='none';
		}
	}else if(chkId =='chk_doc1'){
		if(isChecked){
			if(isDoc1){
				if(confirm('이미 등록된 파일이 있습니다. 삭제하시겠습니까?')){
					delFile(<%=doc1FileId%>);
				}else{
					obj.checked = false;
				}
			}else{
				document.getElementById('div_doc002').style.display='';			
			}
		}else{
			var html='<input onchange="LimitAttach(this,this.value)" type="file" name="ffDoc_002" id="ffDoc_002" />';
			document.getElementById('td_doc002').innerHTML = html;
			document.getElementById('div_doc002').style.display='none';
		}

	}else if(chkId =='chk_doc2'){
		if(isChecked){
			if(isDoc2){
				if(confirm('이미 등록된 파일이 있습니다. 삭제하시겠습니까?')){
					delFile(<%=doc2FileId%>);
				}else{
					obj.checked = false;
				}
			}else{
				document.getElementById('div_doc003').style.display='';			
			}			
		}else{
			var html='<input onchange="LimitAttach(this,this.value)" type="file" name="ffDoc_003" id="ffDoc_003" />';
			document.getElementById('td_doc003').innerHTML = html;
			document.getElementById('div_doc003').style.display='none';
		}

	}else if(chkId =='chk_doc3'){
		if(isChecked){
			if(isDoc3){
				if(confirm('이미 등록된 파일이 있습니다. 삭제하시겠습니까?')){
					delFile(<%=doc3FileId%>);
				}else{
					obj.checked = false;
				}
			}else{
				document.getElementById('div_doc004').style.display='';			
			}			
		}else{
			var html='<input onchange="LimitAttach(this,this.value)" type="file" name="ffDoc_004" id="ffDoc_004" />';
			document.getElementById('td_doc004').innerHTML = html;
			document.getElementById('div_doc004').style.display='none';
		}
	}else if(chkId =='chk_doc4'){
		if(isChecked){
			if(isDoc4){
				if(confirm('이미 등록된 파일이 있습니다. 삭제하시겠습니까?')){
					delFile(<%=doc4FileId%>);
				}else{
					obj.checked = false;
				}
			}else{
				document.getElementById('div_doc005').style.display='';			
			}			
		}else{
			var html='<input onchange="LimitAttach(this,this.value)" type="file" name="ffDoc_005" id="ffDoc_005" />';
			document.getElementById('td_doc005').innerHTML = html;
			document.getElementById('div_doc005').style.display='none';
		}
	}else if(chkId =='chk_doc5'){
		if(isChecked){
			if(isDoc5){
				if(confirm('이미 등록된 파일이 있습니다. 삭제하시겠습니까?')){
					delFile(<%=doc5FileId%>);
				}else{
					obj.checked = false;
				}
			}else{
				document.getElementById('div_doc006').style.display='';			
			}			
		}else{
			var html='<input onchange="LimitAttach(this,this.value)" type="file" name="ffDoc_006" id="ffDoc_006" />';
			document.getElementById('td_doc006').innerHTML = html;
			document.getElementById('div_doc006').style.display='none';
		}
	}else if(chkId =='chk_doc6'){
		if(isChecked){
			document.getElementById('div_doc007').style.display='';			
		}else{
			document.getElementById('div_doc007').style.display='none';
		}
	}else if(chkId =='chk_doc7'){
		if(isChecked){
			document.getElementById('div_doc008').style.display='';			
		}else{
			document.getElementById('div_doc008').style.display='none';
		}
	}
}
function submitForm(){
	var fileNum=0;
	 var fileList = document.getElementsByTagName("input");
	 for (var i=0; i < fileList.length ;i++ ){
	     if(fileList[i].type == "file" && fileList[i].value!=''){ 
	       fileNum++;
	     }
	   }
	if(fileNum>0){
		document.getElementById('byulNum').value=byulNum;
		document.getElementById('etcNum').value=etcNum;
		document.lawfile.submit();
	}else{
		alert('등록할 파일이 없습니다. ');
	}
}

//파일 다운로드
function downpage(Pcfilename,Serverfile,folder){
	form=document.ViewForm;
	form.Pcfilename.value=Pcfilename;
	form.Serverfile.value=Serverfile;
	form.folder.value=folder;
	form.action="<%=CONTEXTPATH %>/Download.do";
	form.submit();
}

//별표삭제
function delFile(fileId){
	if(confirm('정말로 삭제하시겠습니까?')){
		var frm = document.ByulForm;
		frm.action="delByulProc.do?fileId="+fileId+"&statehistoryid=<%=statehistoryid%>";
		frm.submit();
	}
}
function goHistory(statehistoryid){
	var frm = document.ByulForm;
	frm.action="fileUpload.do?statehistoryid="+statehistoryid;
	frm.submit();
}
</script>
<style type="text/css">
* {
	font-family:  "돋움", "굴림"; font-size: 12px; color: #333;
	margin:0; padding:0;
}
IMG {
	border: none;
}
.notTop {
	background:url(${resourceUrl}/images/common/icon_notice.gif) no-repeat left center;
	font-weight:bold; font-size:12px; color:#06C; padding:5px 5px 3px 20px; margin:0 0 0 10px;
}
.flTop {
	background:url(${resourceUrl}/images/common/bullet_disk.gif) no-repeat left center;
	font-weight:bold; font-size:12px; color:#06C; padding:5px 5px 3px 20px; margin:0 0 0 10px;
}
.setDoc {
	padding:5px 0 5px 15px; color:#333; border-bottom:#CCC 1px dotted; background-color:#efefef;
}
.setDoc LABEL {
	font-size:12px;  padding:0 0 0 15px; background:url(${resourceUrl}/images/common/dot_black.gif) no-repeat left center;
	
}
.tb_fileUp TD{
	border-bottom:#ececec 1px solid;
}
.tb_fileUp INPUT {
	font-size:12px; color:#666; width:510px;
}

.doc_type0 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc0.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.doc_type1 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc0.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.doc_type2 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc1.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.doc_type3 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc1.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.doc_type4 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc2.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.doc_type5 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc2.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.doc_type6 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc2.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.doc_type7 {
	margin:5px 0 5px 15px; background:url(${resourceUrl}/images/common/icon_doc2.gif) no-repeat left center;
	padding:0 0 0 20px; color:#666; font-weight:bold;
}
.tb_fileList {
	
}
.tb_fileList TD {border-bottom:#FFF 1px solid; }
</style>
</head>
<body>
<form name="lawfile" action="fileUploadProc.do" enctype="multipart/form-data" method="post">
<input type="hidden" name="statehistoryid" value="<%=statehistoryid%>"/>
	<div id="attList" style="width:98%;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><p class="flTop">등록된 파일 리스트</p></td>
			</tr>
			<tr>
				<td style="border-bottom:#CCC 1px dotted; border-top:#CCC 1px dotted; background-color:#EFEFEF;">
					<div style="overflow-x:hidden; overflow-y:auto; height:150px;">
						<table class="tb_fileList" width="100%" border="0" cellspacing="0" cellpadding="0">
<%if(doc0 == null && doc1 == null && doc2 == null && doc3 == null && doc4 == null && doc5 == null && byulList.size()==0 && etcList.size() == 0){ %>
							<tr><td style="border-bottom: none;" colspan="2" height="68px" align="center">등록된 파일이 없습니다.</td></tr>
<%
}
%>
<%if(doc0!=null){%>
							<tr>
								<td width="110"><p class="doc_type0">개정안</p></td>
								<td><a href="javascript:downpage('<%=doc0.get("PCFILENAME") %>','<%=doc0.get("SERVERFILE") %>','ATTACH');"><%=doc0.get("PCFILENAME") %></a>&nbsp;<img onclick="delFile('<%=doc0.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /></td>
								</tr>
<%} %>
<%if(doc1!=null){%>
							<tr>
								<td width="110"><p class="doc_type1">개정문</p></td>
								<td><a href="javascript:downpage('<%=doc1.get("PCFILENAME") %>','<%=doc1.get("SERVERFILE") %>','ATTACH');"><%=doc1.get("PCFILENAME") %></a>&nbsp;<img onclick="delFile('<%=doc1.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /></td>
								</tr>
<%} %>
<%if(doc2!=null){%>
							<tr>
								<td width="110"><p class="doc_type2">전문</p></td>
								<td><a href="javascript:downpage('<%=doc2.get("PCFILENAME") %>','<%=doc2.get("SERVERFILE") %>','ATTACH');"><%=doc2.get("PCFILENAME") %></a>&nbsp;<img onclick="delFile('<%=doc2.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /></td>
								</tr>
<%} %>
<%if(doc3!=null){%>
							<tr>
								<td width="110"><p class="doc_type3">신구조문</p></td>
								<td><a href="javascript:downpage('<%=doc3.get("PCFILENAME") %>','<%=doc3.get("SERVERFILE") %>','ATTACH');"><%=doc3.get("PCFILENAME") %></a>&nbsp;<img onclick="delFile('<%=doc3.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /></td>
								</tr>
<%} %>
<%if(doc4!=null){%>
							<tr>
								<td width="110"><p class="doc_type4">개정이유</p></td>
								<td><a href="javascript:downpage('<%=doc4.get("PCFILENAME") %>','<%=doc4.get("SERVERFILE") %>','ATTACH');"><%=doc4.get("PCFILENAME") %></a>&nbsp;<img onclick="delFile('<%=doc4.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /></td>
								</tr>
<%} %>
<%if(doc5!=null){%>
							<tr>
								<td width="110"><p class="doc_type5">의견서</p></td>
								<td><a href="javascript:downpage('<%=doc5.get("PCFILENAME") %>','<%=doc5.get("SERVERFILE") %>','ATTACH');"><%=doc5.get("PCFILENAME") %></a>&nbsp;<img onclick="delFile('<%=doc5.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /></td>
								</tr>
<%} %>
							<%if(byulList.size()>0){ %>
							<tr>
								<td width="110"><p class="doc_type6">별표</p></td>
								<td>
								<%for(int i=0; i<byulList.size();i++){ HashMap tBean = (HashMap)byulList.get(i);%>
								<a href="javascript:downpage('<%=tBean.get("PCFILENAME") %>','<%=tBean.get("SERVERFILE") %>','ATTACH');"><%=tBean.get("PCFILENAME")%></a>&nbsp;<img onclick="delFile('<%=tBean.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /><br />
								<%} %></td>
							</tr>
							<%} %>
							<%if(etcList.size()>0){ %>
							<tr>
								<td width="110"><p class="doc_type7">관련문서</p></td>
								<td>
								<%for(int i=0; i<etcList.size();i++){ HashMap tBean = (HashMap)etcList.get(i);%>
								<a href="javascript:downpage('<%=tBean.get("PCFILENAME") %>','<%=tBean.get("SERVERFILE") %>','ATTACH');"><%=tBean.get("PCFILENAME")%></a>&nbsp;<img onclick="delFile('<%=tBean.get("FILEID") %>');" style="cursor: pointer;" src="${resourceUrl}/images/common/delete.gif" alt="삭제" width="16" height="16" align="absmiddle" /><br />
								<%} %></td>
							</tr>
							<%} %>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="fileUpload" style="width:98%;background-color: #ffffff;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td style="border-bottom:#CCC 1px dotted;"><p class="notTop">등록하실 파일의 종류를 선택해 주세요.</p></td>
			</tr>
			<tr>
				<td class="setDoc">
					<label for="chk_docType">개정안 </label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc0" id="chk_doc0" />&nbsp;&nbsp;&nbsp;
					<label for="chk_docType">개정문 </label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc1" id="chk_doc1" />&nbsp;&nbsp;&nbsp;
					<label for="chk_docType">전문 </label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc2" id="chk_doc2" />&nbsp;&nbsp;&nbsp;
					<label for="chk_docType">신구조문 </label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc3" id="chk_doc3" />&nbsp;&nbsp;&nbsp;
					<label for="chk_docType">개정이유 </label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc4" id="chk_doc4" />&nbsp;&nbsp;&nbsp;
					<label for="chk_docType">의견서 </label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc5" id="chk_doc5" />&nbsp;&nbsp;&nbsp;	
<%
	if(noFormYn.equals("Y")){	
%>									
					<label for="chk_docType">별표 </label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc6" id="chk_doc6" />
<%} %>
					<label for="chk_docType">관련문서</label><input onclick="showFileForm(this);" type="checkbox" name="chk_doc7" id="chk_doc7" />
<%
	if(!noFormYn.equals("Y")){
%>
					<label for="chk_docType">단계 : </label>
					<select name="Simsastatecd" onchange="goHistory(this.value)">
						<%
							for (int i=0; i<imList.size(); i++){
								HashMap re = (HashMap)imList.get(i);
						%>
							<option value="<%=re.get("STATEHISTORYID")%>" <%if(re.get("STATEHISTORYID").toString().equals(statehistoryid))out.println("selected"); %>><%=re.get("STATECD") %></option>
						<%
							}
						%>
					</select>
<%
	}else{
%>	
					<input type="hidden" name="Simsastatecd" value="SIME" />
<%
	}
%>
					
				</td>
			</tr>
		</table>
	</div>
	<div id="fileCont" 
		style="width:98%; height:200px; margin:3px 0 3px 0; border:#ececec 1px dotted;border-left:#ececec 1px solid;
		padding:1px 1px 1px 1px; overflow-x:hidden; overflow-y:auto;">
	<div id="div_doc001" style="display:none;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type0">개정안</p></td>
				<td id="td_doc001"><input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_001" id="ffDoc_001" /></td>
			</tr>
		</table>
	</div>
	<div id="div_doc002" style="display:none;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type1">개정문</p></td>
				<td id="td_doc002"><input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_002" id="ffDoc_002" /></td>
			</tr>
		</table>
	</div>
	<div id="div_doc003" style="display:none;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type2">전문</p></td>
				<td id="td_doc003"><input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_003" id="ffDoc_003" /></td>
			</tr>
		</table>
	</div>
	<div id="div_doc004" style="display:none;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type3">신구조문</p></td>
				<td id="td_doc004"><input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_004" id="ffDoc_004" /></td>
			</tr>
		</table>
	</div>
	<div id="div_doc005" style="display:none;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type4">개정이유</p></td>
				<td id="td_doc005"><input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_005" id="ffDoc_005" /></td>
			</tr>
		</table>
	</div>
	<div id="div_doc006" style="display:none;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type5">의견서</p></td>
				<td id="td_doc006"><input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_006" id="ffDoc_006" /></td>
			</tr>
		</table>
	</div>			
<%
	if(noFormYn.equals("Y")){	
%>
	<div id="div_doc007" style="display:none;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type3">별표</p></td>
				<td id="td_byul">
					<div id="byul_0">
						<input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_007_0" id="ffDoc_007_0" /><img onclick="addByul();" style="cursor: pointer;" src="${resourceUrl}/images/common/button/but-addfile-small.gif" alt="추가" align="absmiddle" />
					</div>
				</td>
			</tr>
		</table>
	</div>
<%
	}
%>
	<div id="div_doc008" style="display:none;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tb_fileUp">
			<tr>
				<td width="110"><p class="doc_type3">관련문서</p></td>
				<td id="td_etc">
					<div id="etc_0">
						<input onchange="LimitAttach(this,this.value)" style="width:570px; margin:3px 0 3px 0;" type="file" name="ffDoc_008_0" id="ffDoc_008_0" /><img onclick="addEtc();" style="cursor: pointer;" src="${resourceUrl}/images/common/button/but-addfile-small.gif" alt="추가" align="absmiddle" />
					</div>
				</td>
			</tr>
		</table>
	</div>


</div>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div id="div_but" style="padding:5px 0 5px;text-align:center; border-top:#ccc 1px solid;border-bottom:#ccc 1px solid;" >
				<img onclick="submitForm();" style="cursor: pointer;" src="${resourceUrl}/images/common/button/but-upload-ok.gif" alt="파일업로드" /> 
			</div>
			
		</td>
	</tr>
</table>
<input type="hidden" name="Bookid" value="<%=Bookid %>" />
<input type="hidden" name="noFormYn" value="<%=noFormYn %>" />
<input type="hidden" id="byulNum" name="byulNum" value="" />
<input type="hidden" id="etcNum" name="etcNum" value="" />
</form>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<form name="ByulForm" method="post">
	<input type="hidden" name="Bookid" value="<%=Bookid %>"/>
	<input type="hidden" name="noFormYn" value="<%=noFormYn %>"/>
</form>