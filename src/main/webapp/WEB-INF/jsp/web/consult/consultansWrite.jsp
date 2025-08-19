<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mten.cmn.MtenResultMap"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>

<%
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String inoutcd = ServletRequestUtils.getStringParameter(request, "inoutcd", Constants.Counsel.TYPE_INTN);
	String consultid = ServletRequestUtils.getStringParameter(request, "consultid", "");
	String consultansid = ServletRequestUtils.getStringParameter(request, "consultansid", "");
	String pact = ServletRequestUtils.getStringParameter(request, "pact", "");
	String popyn = ServletRequestUtils.getStringParameter(request, "popyn", "N");
	
	System.out.println(MENU_MNG_NO);
	System.out.println(inoutcd);
	System.out.println("consultid===>"+consultid);
	System.out.println("consultansid===>"+consultansid);
	System.out.println("pact===>"+pact);
	
	
	ConsultService consultService = ConsultServiceHelper.getConsultService(application);
	/* 자문의뢰 */
	String title = "";
	String sasilyoji = "";
	HashMap consult = new HashMap();    
	if (!StringUtil.isEmpty(consultid)) {
	    HashMap param = new HashMap<String, String>();
	    param.put("consultid", consultid);
	    consult = consultService.getConsult(param);
	    /**/
	    consultansid = consult.get("CONSULTANSID")==null?"":consult.get("CONSULTANSID").toString();
	    //inoutcd = consult.getInoutcd() != null && consult.getInoutcd().length()>0? consult.getInoutcd(): inoutcd;
	    title = consult.get("TITLE")==null?"":consult.get("TITLE").toString();
	    sasilyoji = StringUtil.null2space(consult.get("SASIL_KOREO")==null?"":consult.get("SASIL_KOREO").toString());
	    
	    if (sasilyoji.equals("")) {
	    	sasilyoji = StringUtil.null2space(consult.get("YOJI")==null?"":consult.get("YOJI").toString());
	    } else {
	    	sasilyoji = sasilyoji + "\n" + StringUtil.null2space(consult.get("YOJI")==null?"":consult.get("YOJI").toString());
	    }
	}
	if(pact.equals("I")){
		consultansid = "";
	}
	/* 자문의견 */
	HashMap consultans = new HashMap();
	if (!StringUtil.isEmpty(consultansid)) {
	    HashMap param = new HashMap<String, String>();
	    param.put("consultansid", consultansid.trim());
	    consultans = consultService.getConsultans2(param); 
	    /**/
	    title = consultans.get("TITLE")==null?"":consultans.get("TITLE").toString();
	    sasilyoji = StringUtil.nvl(consultans.get("SASILYOJI")==null?"":consultans.get("SASILYOJI").toString(), sasilyoji);
	}
%>

<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
var consultid = "<%=consultid%>";
var consultansid = "<%=consultansid%>";
var popyn = "<%=popyn%>";
var CONSULTCD = "<%=consult.get("CONSULTCD")==null?"":consult.get("CONSULTCD")%>";
$(document).ready(function(){  //문서가 로딩될때
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/web/consult/getConsultCdInfo.do",
		data:{"gbn":"list"},
		dataType:"json",
		async:false,
		success:function(result){
			var option1 = '<option value="">선택</option>';
			for(var i=0; i<result.result.length; i++){
				if(result.result[i].CODENAME == 'CONSULTCD'){
					if(CONSULTCD == result.result[i].CODE){
						option1+="<option value='"+result.result[i].CODE+"' selected>"+result.result[i].CODE+"</option>";
					}else{
						option1+="<option value='"+result.result[i].CODE+"'>"+result.result[i].CODE+"</option>";		
					}
				
				}
			}
			$("#selConsultcd").append(option1);	
		}
	});
	if(consultansid!=''){
		selectFileList();	
	}
	
});

function showEmplSearchPop(){
	///web/consult/chargerSearchPop.do?menu='+'consult';
	var url = '<%=CONTEXTPATH%>/web/consult/chargerSearchPop.do?menu='+'consultans';
	var wth = "1200";
	var hht = "500";
	var pnm = "chargerSerach";
	popOpen(pnm,url,wth,hht);    
}

function saveConsultans() {
 	var frm = document.detailFrm;
 	goSaveInfo();
}

function goSaveInfo(){
	if(confirm("자문의견을 등록 하시겠습니까?")){
		var frm = document.detailFrm;

	   if ($("#selConsultcd").val()=='') {
	       alert("분류를 선택하세요.");
	       return;
	   }
	   if (frm.title.value.length <1) {
	       alert("제목을 입력하세요.");
	       frm.title.focus();
	       return;
	   }
	   if (frm.bubview.value.length <1) {
	       alert("검토의견을 입력하세요.");
	       frm.bubview.focus();
	       return;
	   }
	   /* 분류코드 설정 */
	   frm.consultcd.value = $("#selConsultcd").val();
		   
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/addConsultans.do",
			data:$('#detailFrm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					formData.append("file"+i, fileList[i]);
					formData.append("sourcetableid", result.data.sourcetableid);
					formData.append("filecd", "의견서");
					
					var other_data = $('#detailFrm').serializeArray();
					$.each(other_data,function(key,input){
						if(input.name != 'sourcetableid'){
							formData.append(input.name,input.value);
						}
					});
					
					var status = statusList[i];
					var uploadURL = "${pageContext.request.contextPath}/web/consult/fileUpload.do";
					uploadFileFunction(status, uploadURL, formData);
				}
				
				
				
				if(result.data.msg == 'ok'){
					alert("저장이 완료되었습니다.");
					if(popyn=='' || popyn=='N'){
						goListPage();	
					}else{
						window.close();
					}
					
				}
			}
		});
	}
}

function uploadFileFunction(status, uploadURL, formData){
	var jqXHR = $.ajax({
		xhr:function() {
			var xhrobj = $.ajaxSettings.xhr();
			if (xhrobj.upload) {
				xhrobj.upload.addEventListener('progress', function(event) {
					var percent = 0;
					var position = event.loaded || event.position;
					var total = event.total;
					if (event.lengthComputable) {
						percent = Math.ceil(position / total * 100);
					}
					var progressBarWidth = percent * status.progressBar.width() / 100;
					status.progressBar.find('div').css({width:progressBarWidth}, 10).html(percent + "% ");
					if(parseInt(percent) >= 100){
						status.abort.hide();
					}
				}, true);
			}
			return xhrobj;
		},
		url:uploadURL,
		type:"POST",
		contentType:false,
		processData:false,
		cache:false,
		data:formData,
		async:true,
		success:function(data){
			
		}
	});
	status.setAbort(jqXHR);
}

function goListPage(){
	var frm = document.detailFrm;
	var url = "goConsultList.do";
	frm.action = "${pageContext.request.contextPath}/web/consult/"+url;
	frm.submit();

}

function selectFileList(){
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/web/consult/selectFileList.do",
		data:{sourcetableid:consultansid, filecd:'의견서'},
		//data:{consultid:sourcetableid, filecd:'의견서'},
		dataType:"json",
		async:false,
		success:setFileList
	});
}

function setFileList(data){
	if(data.flist.length != "0"){
		$(".dragAndDropDiv").css("width", "50%");
		$(".dragAndDropDiv").css("font-size", "85%");
	}
	var html = "";
	$.each(data.flist, function(key,input){
		html += "<div class=\"statusbar odd\">";
		html += "<div class=\"filename\" style=\"width:78%;\">";
		html += input.PCFILENAME;
		html += "</div>";
		//html += "<div class=\"abort\" style=\"float:none; width:15%;\" onclick=\"delFile('"+input.FILEID+"', '"+input.SERVERFILENM+"', '"+cnt+"')\">";
		html += "<div class=\"abort\" style=\"float:none; width:20%;\" >";
		html += "<input type=\"checkbox\" name=\"delfile[]\" value=\""+input.FILEID+"\")\"> 삭제";
		html += "</div>";
		html += "</div>";
	});
	$(".hkk").css("width", "50%");
	$(".hkk").append(html);
}
</script>

<body>
<form name="detailFrm" id="detailFrm" method="post" action="">
<input type="hidden" name="inoutcd"         value="<%=inoutcd%>" />
<input type="hidden" name="consultid" id="consultid" value="<%=consultid%>"/>
<input type="hidden" name="refconsultid" id="refconsultid" value="<%=StringUtil.null2space(consult.get("REFCONSULTID")==null?"":consult.get("REFCONSULTID").toString())%>"/>
<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
<input type="hidden" name="consultcd"       value="<%=StringUtil.null2space(consult.get("CONSULTCD")==null?"":consult.get("CONSULTCD").toString()) %>" />
<input type="hidden" name="consultcatcd"    value="<%=StringUtil.null2space(consult.get("CONSULTCATCD")==null?"":consult.get("CONSULTCATCD").toString()) %>" />

<input type="hidden" name="consultansid" id="consultansid" value="<%=consultansid%>"/>
<input type="hidden" id="bubmusenginsabun" name="bubmusenginsabun"    value="<%=StringUtil.null2space(consultans.get("BUBMUSENGINSABUN")==null?"":consultans.get("BUBMUSENGINSABUN").toString())%>"/>

	<div class="subCA">

		<strong class="subST">자문의견서등록(내부)</strong>
		<hr class="margin40">
		<strong class="subTT">법률자문 의견서</strong>
		<div class="subBtnC right">
			<a href="#none" class="sBtn type1" onclick="saveConsultans()">저장</a>
			<%if(!popyn.equals("Y")){ %> 
			<a href="#none" onclick="goListPage()" class="sBtn type2">목록</a>
			<%} %>
		</div>
		<div class="innerB">
			<table class="infoTable write">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 10%;">
					<col style="width: *;">
					<col style="width: 10%;">
					<col style="width: *;">
				</colgroup>
				<tr>
					<th rowspan="4">의뢰정보</th>
					<th>접수일자</th>
					<td><input type="text" class="datepick" id="jeobsudt" name="jeobsudt" value="<%=StringUtil.changeToWebDate(consult.get("JEOBSUDT")==null?"":consult.get("JEOBSUDT").toString())%>" readOnly></td>
					<th>의뢰부서명</th>
					<td><input type="text" id="dept" name="dept" value="<%=consult.get("DEPT") %>" readOnly></td>
				</tr>
				<tr>
					<th>분류</th>
					<td colspan="3">
					<select id="selConsultcd" name="selConsultcd"></select>
					</td>
				</tr>
				
				<%  
					String dbinoutcd = consult.get("INOUTCD")==null?"":consult.get("INOUTCD").toString();
				    if (Constants.Counsel.TYPE_EXTN.equals(dbinoutcd)) {
				    	
				    	HashMap lawyer = new HashMap();
				    	String bublawyerid = consult.get("BUBLAWYERID")==null?"":consult.get("BUBLAWYERID").toString();
				    	String bname = "";
				    	String bsosok = "";
				    	String bemail = "";
				    	String bphone = "";
				    	String bhphone = "";
				        if(bublawyerid.length() >0){
				        	lawyer = consultService.getLawyer(bublawyerid);
				        	if(lawyer!=null){
					            bname = lawyer.get("LAWYERNAME")==null?"":lawyer.get("LAWYERNAME").toString();		
					            bsosok = lawyer.get("OFFICE")==null?"":lawyer.get("OFFICE").toString();		
					    		bemail = lawyer.get("EMAIL")==null?"":lawyer.get("EMAIL").toString();		
					    		bphone = lawyer.get("PHONE")==null?"":lawyer.get("PHONE").toString();		    
					    		bhphone = lawyer.get("CELLPHONE")==null?"":lawyer.get("CELLPHONE").toString();
				        	}
				        }
				%>
				<tr>
					<th rowspan="2">변호사</th>
					<th>변호사명</th>
					<td>
						<input name="bublawyerid" type="hidden" value="<%=StringUtil.null2space(bublawyerid) %>" />
                    	<%=StringUtil.null2space(bname) %>
					</td>
					<th>소속</th>
					<td><%=StringUtil.null2space(bsosok) %></td>
				</tr>	
				<tr>
					<th>이메일</th>
					<td><%=StringUtil.null2space(bemail) %></td>
					<th>연락처</th>
					<td><%=StringUtil.null2space(bphone) %> / <%=StringUtil.null2space(bhphone) %></td>
				</tr>
				<tr>
	                <th scope="row">수신일자</th>
	                <td class="txt_l" colspan="3">                    
	                    <input name="emailsusindt" type="text" class="input_txt wd200px" value="<%=DateUtil.getDateString()%>" />
	                </td>
	            </tr>
			    <%
					}
				%>  
			</table>
			
			
			
			
			<table class="infoTable write">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: *;">
					<col style="width: 10%;">
					<col style="width: *;">
				</colgroup>
				<tr>
					<th>제목</th>
					<td colspan="3"><input type="text" id="title" style='width:90%' name="title" value="<%=title%>"></td>
				</tr>
				<tr>
					<th>사실관계 </br>및 질의 요지
					</th>
					<td colspan="3"><textarea id="sasilyoji" name="sasilyoji"><%=sasilyoji%></textarea></td>
				</tr>
				<tr>
					<th>검토의견</th>
					<td colspan="3"><textarea id="bubview" name="bubview"><%=StringUtil.null2space(consultans.get("BUBVIEW")==null?"":consultans.get("BUBVIEW").toString())%></textarea></td>
				</tr>
				<tr>
							<th>파일첨부</th>
							<td colspan="3">
								<div id="fileUpload" class="dragAndDropDiv">
									<input type="file" multiple style="display:none" id="fileadd"/>
									<label for="fileadd"><strong>업로드 할 파일을 선택 하세요</strong></label>
									<label for="fileadd">(드래그 앤 드롭으로 파일 첨부가 가능합니다.)</label>
								</div>
								<div id="fileList">
									<input type="hidden" />
								</div>
								<div id="hkk" class="hkk">
								</div>
							</td>
				</tr>
				<tr>
					<th>승인자</th>
					<td><input type="text" id="bubmusenginname" name="bubmusenginname" readOnly><a href="#none" class="innerBtn" onclick="showEmplSearchPop();">검색</a></td>
					<th>승인여부</th>
					<td><input type="text" id="consultstatecd" name="consultstatecd" readOnly value="<%=StringUtil.null2space(consult.get("CONSULTSTATECD")==null?"":consult.get("CONSULTSTATECD").toString())%>" ></td>
				</tr>
			</table>
		</div>
		<hr class="margin30">
	</div>
	</form>
</body>
</html>