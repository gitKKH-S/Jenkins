<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%
	String consultid       = ServletRequestUtils.getStringParameter(request, "consultid", "").trim();;
	String consultansid    = ServletRequestUtils.getStringParameter(request, "consultansid", "").trim();;
	String refconsultid    = ServletRequestUtils.getStringParameter(request, "refconsultid", "").trim();;
    String inoutcd = StringUtil.nvl(request.getParameter("inoutcd"), Constants.Counsel.TYPE_INTN);
    ConsultService consultService = ConsultServiceHelper.getConsultService(application);
	/**/
	HashMap consult = new HashMap();    
	if (consultid.length() >0) {
	    HashMap param = new HashMap<String, String>();
	    param.put("consultid", consultid.trim());
	    consult = consultService.getConsult(param);
	}
	HashMap consultans = new HashMap();
	List fileList = new ArrayList();
	if (consultansid.length() >0 || refconsultid.length() >0) {
	    HashMap param = new HashMap<String, String>();
	    param.put("consultansid", consultansid.trim());
	    consultans = consultService.getConsultans2(param);
	    /**/
        param = new HashMap<String, String>();
        param.put("sourcetableid", consultansid);
        param.put("filecd", "의견서");
        fileList = consultService.getFileList2(param);
	}
	/* 소송코드서비스 */
	//CCodeService ccodeService = CCodeServiceHelper.getCCodeService(application);
	
    String openyn = consultans.get("OPENYN")==null?"N":consultans.get("OPENYN").toString();
    String CONSULTSTATECD = consult.get("CONSULTSTATECD")==null?"":consult.get("CONSULTSTATECD").toString();
    String JILMUNSABUN = consult.get("JILMUNSABUN")==null?"":consult.get("JILMUNSABUN").toString();
    String BUBMUSENGINSABUN = consultans.get("BUBMUSENGINSABUN")==null?"":consultans.get("BUBMUSENGINSABUN").toString();
    String BANREASON = consultans.get("BANREASON")==null?"":consultans.get("BANREASON").toString();
    
    
    
    HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();	
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
%>

<style>
.infoTable.write th {
    padding: 5px 10px;
}
.infoTable textarea {
    background: #f1f4f7;
    border-radius: 2px;
    width: 100%;
}


</style>

<script type="text/javascript">
$(document).ready(function(){
	$('.wrap').on('keyup', 'textarea', function (e) {
		$(this).css('height', 'auto');
		$(this).height(this.scrollHeight);
	});
	$('.wrap').find('textarea').keyup();
});

/**
* 만족도 조사 
* 
*/


function goResearch(){
	var frm = document.detailFrm;

	var url = '<%=CONTEXTPATH%>/web/consult/researchPop.do';
	var wth = "1200";
	var hht = "500";
	var pnm = "research";
	popOpen(pnm,url,wth,hht); 


}

	function aprvConsult(aprv) {
	   /**/
	   var charger = "<%=StringUtil.null2space(consultans.get("BUBMUSENGINNAME")==null?"":consultans.get("BUBMUSENGINNAME").toString()) %>";
	   if (charger.length <1) {
	       alert("승인자 지정되어야 합니다.");
	       return;
	   }
	   $("#consultstatecd").val(aprv);
	   $.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/aprvConsult4Ajax.do",
			data:$('#detailFrm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if(result.msg == 'ok'){
					alert("정상 처리 되었습니다.");
			        var frm = document.detailFrm;
			        frm.action = "${pageContext.request.contextPath}/web/consult/consultansViewPage.do";
			        frm.submit();
				}
			}
		});
	}
	
	function go2AnsWrite() {	
		var frm = document.detailFrm;
		frm.popyn.value = 'Y';
	    frm.action = "consultansWritePage.do";
	    frm.submit();
	}
	function banReasonViewPop(paramType) {
		var consultansid = $("#consultansid").val();
		var url = '${pageContext.request.contextPath}/web/consult/banReasonViewPop.do?paramType='+paramType+'&consultansid='+consultansid;
		var wth = "800";
		var hht = "400";
		var pnm = "newEdit2";
		popOpen(pnm,url,wth,hht);
	}
	
	function banReasonWritePop(paramType) {
		var consultid = $("#consultid").val();
		var consultansid = $("#consultansid").val();
		var url = '${pageContext.request.contextPath}/web/consult/banReasonWritePop.do?paramType='+paramType+'&consultansid='+consultansid+'&consultid='+consultid;
		var wth = "800";
		var hht = "400";
		var pnm = "newEdit2";
		popOpen(pnm,url,wth,hht);
	}
	function downpage(pcfilename, serverfile){
	    form=document.fileFrm;
	    form.Pcfilename.value=pcfilename;
	    form.Serverfile.value=serverfile;
	    form.folder.value="CONSULT";
	    form.action="${pageContext.request.contextPath}/Download.do";
	    form.submit();
	}
	function pagereload(){
		var frm = document.detailFrm;
		frm.action = "${pageContext.request.contextPath}/web/consult/consultansViewPage.do";
		frm.submit();
	}
	function setOpenyn(openyn) {
	    var frm = document.detailFrm;
	    frm.openyn.value = openyn;

	    $.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/setOpenyn.do",
			data:$('#detailFrm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if(result.msg == 'ok'){
					alert("정상 처리 되었습니다.");
			        var frm = document.detailFrm;
			        frm.action = "${pageContext.request.contextPath}/web/consult/consultansViewPage.do";
			        frm.submit();
				}
			}
		});
	}
	function print(consultansid){
	    cw=500;
	    ch=600;
	    sw=screen.availWidth;
	    sh=screen.availHeight;
	    px=(sw-cw)/2;
	    py=(sh-ch)/2;
	    property = "dialogLeft:"+px+"; dialogTop:"+py+"; dialogWidth:"+cw+"px; dialogHeight:"+ch+"px;";
	    property += "scrollbars=no, resizable=no, status=no, toolbar=no, menubar=no, location=no";
	    var frm = document.detailFrm;
	    var param = "?consultansid="+consultansid;
	    var result = window.open("<%=CONTEXTPATH%>/web/consult/PrintByHangul.do"+param, "", property);	
	    
	}
	/**
	* 자문의뢰 삭제
	*/
	function removeConsultans() {
	   /**/
	   if (confirm("삭제하시겠습니까?")) {
		   $.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/consult/removeConsultans4Ajax.do",
				data:$('#detailFrm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					if(result.msg == 'ok'){
						alert("삭제 처리 되었습니다.");
						opener.pagereload();
				        window.close();
					}
				}
			});
	   }
	}
</script>
<form name="fileFrm" id="fileFrm" method="post" >
    <input type="hidden" name="Serverfile" />
    <input type="hidden" name="Pcfilename" />
    <input type="hidden" name="folder" />
</form>
<form name="detailFrm" id="detailFrm" method="post" >  
    <input type="hidden" name="consultid"   id="consultid"   value="<%=consultid%>"/>
    <input type="hidden" name="consultansid"   id="consultansid"   value="<%=consultansid%>"/>
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="consultstatecd" id="consultstatecd"    value="<%=CONSULTSTATECD%>" />
	<input type="hidden" name="popyn"/>
	<input type="hidden" name="openyn"/>
	

	<div class="subCA">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">자문의견서보기(<%=inoutcd%>)</strong>
			</div>
			<div class="subBtnC right">
				<% 
				if ( (Constants.Counsel.PRGS_STAT_LAW_APRV.equals(CONSULTSTATECD) ||
					  Constants.Counsel.PRGS_STAT_USER_SAT.equals(CONSULTSTATECD) ||
					  Constants.Counsel.PRGS_STAT_CON_TRACT.equals(CONSULTSTATECD))
					&& (GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1)){
				%>
				       <a href="#none" class="sBtn type1" onclick="javascript:print(<%=consultansid %>);">PRINT</a>
				      <%  if (openyn.equals("Y")){%>
				        <a href="#none"class="sBtn type4" onclick="javascript:setOpenyn('N');">비공개로 전환</a>
				      <%  }else{%>
				        <a href="#none"class="sBtn type4" onclick="javascript:setOpenyn('Y');">공개로 전환</a>
				      <%  } %> 
				<% 
				}       
				if (Constants.Counsel.PRGS_STAT_LAW_APRV.equals(CONSULTSTATECD) && USERNO.equals(JILMUNSABUN)){
				%>
				       <span class="button">
				       		<button type="button" onclick="javascript:goResearch('write','U');">만족도조사</button>
				       </span>
				<% 
				}
				if (Constants.Counsel.PRGS_STAT_USER_SAT.equals(CONSULTSTATECD) && (!USERNO.equals(JILMUNSABUN)||(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1))){
				%>
				    <span class="button">
				    		<button type="button" onclick="javascript:goResearch('write','L');">만족도조사</button>
				    </span>
				<% 	
				}
				if (Constants.Counsel.PRGS_STAT_CON_TRACT.equals(CONSULTSTATECD) && (GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1)){
				%>
					       <span class="button">
					       		<button type="button" onclick="javascript:goResearch('read','L');">만족도조회</button>
					       </span>
				<% 
				}
				if ((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1)) {
					if (!StringUtil.isEmpty(BANREASON)
					) {
				%>
				        <a href="#none"class="sBtn type4" onclick="javascript:banReasonViewPop();">반려사유확인</a>
				<%      
				    } 
					//if (EMPLOYEE_NUMBER.equals(consult.getBubsabun())) {
						if(Constants.Counsel.PRGS_STAT_LAW_RECPT.equals(CONSULTSTATECD) ){
				%>
						<a href="#none"class="sBtn type4" onclick="javascript:aprvConsult('<%=Constants.Counsel.PRGS_STAT_LAW_REQM%>');">승인요청</a>
				<%      
						} 
						if(Constants.Counsel.PRGS_STAT_LAW_REJT.equals(CONSULTSTATECD)){
				%>
				        
				        <a href="#none"class="sBtn type4" onclick="javascript:aprvConsult('<%=Constants.Counsel.PRGS_STAT_LAW_REQM%>');">재승인요청</a>
				<%
						} 
				        if(Constants.Counsel.PRGS_STAT_LAW_REQM.equals(CONSULTSTATECD)){
				%>
				        <a href="#none"class="sBtn type4" onclick="javascript:aprvConsult('<%=Constants.Counsel.PRGS_STAT_LAW_RECPT%>');">회수</a>
				<%
				        } 
					    if ((Constants.Counsel.PRGS_STAT_LAW_REJT.equals(CONSULTSTATECD) 
					             || Constants.Counsel.PRGS_STAT_LAW_RECPT.equals(CONSULTSTATECD)) 
					            //&& EMPLOYEE_NUMBER.equals(consult.getBubsabun())
					    ) {
				%>
				        <a href="#none"class="sBtn type3"  onclick="javascript:go2AnsWrite();">수정</a>
	 					<a href="#none"class="sBtn type2" onclick="javascript:removeConsultans();">삭제</a>
				<%        
				        }
					//}
				}	
				%>
				<%
				if (Constants.Counsel.PRGS_STAT_LAW_REQM.equals(CONSULTSTATECD)
				        && USERNO.equals(BUBMUSENGINSABUN)
				) {
				%> 
				        <a href="#none"class="sBtn type4" onclick="javascript:aprvConsult('<%=Constants.Counsel.PRGS_STAT_LAW_APRV%>');">승인</a>
				        <a href="#none"class="sBtn type4" onclick="javascript:banReasonWritePop();">반려</a>
				<%
				}
				%>
						<a href="#none" onclick="window.close()" class="sBtn type2">닫기</a>
			</div>
		</div>


		<!-- <strong class="subTT"></strong> -->
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
					<td><%=StringUtil.changeToWebDate(consult.get("JEOBSUDT")==null?"":consult.get("JEOBSUDT").toString())%></td>
					<th>의뢰부서명</th>
					<td><%=consult.get("DEPT")==null?"":consult.get("DEPT") %></td>
				</tr>
				<tr>
					<th>분류</th>
					<td colspan="3"><%=consult.get("CONSULTCD")==null?"":consult.get("CONSULTCD") %></td>
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
	                	<%=StringUtil.changeToWebDate(consultans.get("EMAILSUSINDT")==null?"":consultans.get("EMAILSUSINDT").toString())%>            
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
					<td colspan="3"><%=consultans.get("TITLE")==null?"":consultans.get("TITLE")  %></td>
				</tr>
				<tr>
					<th>사실관계 및</br> 질의 요지
					</th>
					<td colspan="3" class="wrap">
						<textarea style="background:#fff; color: #666;  overflow: hidden;" readonly><%=consultans.get("SASILYOJI")==null?"":consultans.get("SASILYOJI") %></textarea>
					</td>
				</tr>
				<tr>
					<th>검토의견</th>
					<td colspan="3" class="wrap">
						<textarea style="background:#fff; color: #666;  overflow: hidden;" readonly><%=consultans.get("BUBVIEW")==null?"":consultans.get("BUBVIEW") %></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="3">
				<% for(int i=0; i<fileList.size(); i++){
					String pcfilename = ((HashMap)fileList.get(i)).get("PCFILENAME").toString();
					String serverfile = ((HashMap)fileList.get(i)).get("SERVERFILENAME").toString();
				%>
				<label ><a href="javascript:downpage('<%=pcfilename%>','<%=serverfile%>')"><%=pcfilename%></a></label>
				<br/>
				<%}%>
					</td>
				</tr>
				<tr>
					<th>승인자</th>
					<td><%= consultans.get("BUBMUSENGINNAME")==null?"":consultans.get("BUBMUSENGINNAME").toString()%></td>
					<th>승인여부</th>
					<td><%=StringUtil.null2space(consult.get("CONSULTSTATECD")==null?"":consult.get("CONSULTSTATECD").toString())%></td>
				</tr>
			</table>
		</div>
	
	</div>
	</form>


</html>