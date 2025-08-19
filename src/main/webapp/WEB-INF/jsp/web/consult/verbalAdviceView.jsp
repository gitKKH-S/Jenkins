<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@page import="java.text.DecimalFormat"%>
<%
	ConsultService consultService = ConsultServiceHelper.getConsultService(application);
	//구두 자문 기본 정보
	HashMap consult = request.getAttribute("consultinfo")==null?new HashMap():(HashMap)request.getAttribute("consultinfo");
	//구두 자문 첨부파일
	List confileList = request.getAttribute("confileList")==null?new ArrayList():(ArrayList)request.getAttribute("confileList");
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String filePath = request.getParameter("filePath")==null?"":request.getParameter("filePath").toString();
	
	/* 구두자문 내용 */
	String cnstn_mng_no   = consult.get("CNSTN_MNG_NO")==null?"":consult.get("CNSTN_MNG_NO").toString();
	String menu_mng_no   = consult.get("MENU_MNG_NO")==null?"":consult.get("MENU_MNG_NO").toString();
	String cnstn_cmptn_ymd   = consult.get("CNSTN_CMPTN_YMD")==null?"":consult.get("CNSTN_CMPTN_YMD").toString();
	String cnstn_rqst_dept_no   = consult.get("CNSTN_RQST_DEPT_NO")==null?"":consult.get("CNSTN_RQST_DEPT_NO").toString();
	String cnstn_rqst_dept_nm   = consult.get("CNSTN_RQST_DEPT_NM")==null?"":consult.get("CNSTN_RQST_DEPT_NM").toString();
	String cnstn_rqst_emp_no   = consult.get("CNSTN_RQST_EMP_NO")==null?"":consult.get("CNSTN_RQST_EMP_NO").toString();
	String cnstn_rqst_emp_nm   = consult.get("CNSTN_RQST_EMP_NM")==null?"":consult.get("CNSTN_RQST_EMP_NM").toString();
	String dscsn_type_nm   = consult.get("DSCSN_TYPE_NM")==null?"":consult.get("DSCSN_TYPE_NM").toString();
	String cnstn_tkcg_emp_no   = consult.get("CNSTN_TKCG_EMP_NO")==null?"":consult.get("CNSTN_TKCG_EMP_NO").toString();
	String cnstn_tkcg_emp_nm   = consult.get("CNSTN_TKCG_EMP_NM")==null?"":consult.get("CNSTN_TKCG_EMP_NM").toString();
	String wrt_ymd   = consult.get("WRT_YMD")==null?"":consult.get("WRT_YMD").toString();
	
	
	String cnstn_doc_no   = consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString();
	String prgrs_stts_se_nm   = consult.get("PRGRS_STTS_SE_NM")==null?"":consult.get("PRGRS_STTS_SE_NM").toString();
	String rls_yn   = consult.get("RLS_YN")==null?"":consult.get("RLS_YN").toString();
	String insd_otsd_task_se   = consult.get("INSD_OTSD_TASK_SE")==null?"":consult.get("INSD_OTSD_TASK_SE").toString();
	String otsd_rqst_rsn   = consult.get("OTSD_RQST_RSN")==null?"":consult.get("OTSD_RQST_RSN").toString();
	String cnstn_ttl   = consult.get("CNSTN_TTL")==null?"":consult.get("CNSTN_TTL").toString();
	String cnstn_rqst_dept_tmldr_emp_no   = consult.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO")==null?"":consult.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO").toString();
	String cnstn_rqst_dept_tmldr_nm   = consult.get("CNSTN_RQST_DEPT_TMLDR_NM")==null?"":consult.get("CNSTN_RQST_DEPT_TMLDR_NM").toString();
	String rqst_dept_last_aprvr_jbps_nm   = consult.get("RQST_DEPT_LAST_APRVR_JBPS_NM")==null?"":consult.get("RQST_DEPT_LAST_APRVR_JBPS_NM").toString();
	String cnstn_rqst_reg_ymd   = consult.get("CNSTN_RQST_REG_YMD")==null?"":consult.get("CNSTN_RQST_REG_YMD").toString();
	String cnstn_rqst_ymd   = consult.get("CNSTN_RQST_YMD")==null?"":consult.get("CNSTN_RQST_YMD").toString();
	String cnstn_rqst_cn   = consult.get("CNSTN_RQST_CN")==null?"":consult.get("CNSTN_RQST_CN").toString().replaceAll("\n","<br/>");
	String cnstn_rqst_subst_cn   = consult.get("CNSTN_RQST_SUBST_CN")==null?"":consult.get("CNSTN_RQST_SUBST_CN").toString().replaceAll("\n","<br/>");
	String rmrk_cn   = consult.get("RMRK_CN")==null?"":consult.get("RMRK_CN").toString().replaceAll("\n","<br/>");
	String cnstn_hope_rply_ymd   = consult.get("CNSTN_HOPE_RPLY_YMD")==null?"":consult.get("CNSTN_HOPE_RPLY_YMD").toString();
	String cnstn_rcpt_ymd   = consult.get("CNSTN_RCPT_YMD")==null?"":consult.get("CNSTN_RCPT_YMD").toString();
	String cnstn_rply_ymd   = consult.get("CNSTN_RPLY_YMD")==null?"":consult.get("CNSTN_RPLY_YMD").toString();
	String prvt_srch_kywd_cn   = consult.get("PRVT_SRCH_KYWD_CN")==null?"":consult.get("PRVT_SRCH_KYWD_CN").toString();
	String emrg_yn   = consult.get("EMRG_YN")==null?"":consult.get("EMRG_YN").toString();
	String del_yn   = consult.get("DEL_YN")==null?"":consult.get("DEL_YN").toString();
	String wrtr_emp_nm   = consult.get("WRTR_EMP_NM")==null?"":consult.get("WRTR_EMP_NM").toString();
	String wrtr_emp_no   = consult.get("WRTR_EMP_NO")==null?"":consult.get("WRTR_EMP_NO").toString();
	String wrt_dept_nm   = consult.get("WRT_DEPT_NM")==null?"":consult.get("WRT_DEPT_NM").toString();
	String wrt_dept_no   = consult.get("WRT_DEPT_NO")==null?"":consult.get("WRT_DEPT_NO").toString();
	String mdfcn_emp_nm   = consult.get("MDFCN_EMP_NM")==null?"":consult.get("MDFCN_EMP_NM").toString();
	String mdfcn_emp_no   = consult.get("MDFCN_EMP_NO")==null?"":consult.get("MDFCN_EMP_NO").toString();
	String mdfcn_ymd   = consult.get("MDFCN_YMD")==null?"":consult.get("MDFCN_YMD").toString();
	String mdfcn_dept_nm   = consult.get("MDFCN_DEPT_NM")==null?"":consult.get("MDFCN_DEPT_NM").toString();
	String mdfcn_dept_no   = consult.get("MDFCN_DEPT_NO")==null?"":consult.get("MDFCN_DEPT_NO").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	String JIKGUB_NM = se.get("JIKGUB_NM")==null?"":se.get("JIKGUB_NM").toString();
	String JIKCHK_NM = se.get("JIKCHK_NM")==null?"":se.get("JIKCHK_NM").toString();
	String ISDEVICE = se.get("ISDEVICE")==null?"":se.get("ISDEVICE").toString();
	ISDEVICE = "P"; // 임시로 고정해둔 값 나중에 공통부분 어떻게 수정되는지에 따라 지우거나 수정해야함.
	String teamA = "";	// 팀장
	String teamB = "";	// 부장
	
// 	for(int a=0; a<agreelist.size(); a++) {
// 		HashMap aMap = (HashMap) agreelist.get(a);
// 		String aGbn = aMap.get("GBN")==null?"":aMap.get("GBN").toString();
		
// 		if ( "MAPP".equals(aGbn) ){
// 			teamA = aMap.get("USER_ID")==null?"":aMap.get("USER_ID").toString();
// 		} else if ( "TAPP".equals(aGbn) ){
// 			teamB = aMap.get("USER_ID")==null?"":aMap.get("USER_ID").toString();
// 		}
// 	}
	
	String oldno = consult.get("OLDCONSULTNO")==null?"":consult.get("OLDCONSULTNO").toString();
	
		String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
%>
<style>
	.infoTable.write th {
		background: #d6d9dc;
	}
	.innerBtn {float: right;}
	html {overflow-y: auto;}
</style>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/plugin/jquery.number.js"></script>
<script type="text/javascript">
	var consultid = "<%=cnstn_mng_no%>";
	var statcd = "<%=prgrs_stts_se_nm%>";
	var inoutcon = "<%=insd_otsd_task_se%>";
	var menu_mng_no = "<%=MENU_MNG_NO%>";
	
	// 목록 화면 이동
	function verbalAdviceList() {
		var frm = document.detailFrm;
		$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
		$("#consultid").val(consultid);
		$("#inoutcon").val('<%=insd_otsd_task_se%>');
		frm.action = "${pageContext.request.contextPath}/web/consult/goVerbalAdviceList.do";
		frm.submit();
	}
	
	$(document).ready(function(){
	
		var statcd = "<%=prgrs_stts_se_nm%>";
		
// 		$("#chgState").val(statcd).attr("selected", "selected");// psy

		// 수정 화면 이동
		$("#uBtn").click(function(){
			var frm = document.detailFrm;
			$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
			$("#consultid").val(consultid);
			$("#inoutcon").val('<%=insd_otsd_task_se%>');
			frm.action="${pageContext.request.contextPath}/web/consult/verbalAdviceWritePage.do";
			frm.submit();
		});
		
		$("#dBtn").click(function(){
			if(confirm("구두자문 정보를 모두 삭제하시겠습니까?")) {
				$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
				$("#consultid").val(consultid);
				$("#inoutcon").val('<%=insd_otsd_task_se%>');
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/consult/verbalAdviceDelete.do",
					data:$('#detailFrm').serializeArray(),
					dataType:"json",
					async:false,
					success:function(result){
						alert("구두자문이 삭제되었습니다.");
						verbalAdviceList();
					}
				});
			}
		});
		
		$("#lBtn").click(function(){
			verbalAdviceList();
		});
		
		var inHei = window.innerHeight;
		$(".hkkresult").css("height", inHei-380);
		$(".hkkresult").css("overflow-y", "auto");
		
		$(window).resize(function() {
			var inHei = window.innerHeight;
			$(".hkkresult").css("height", inHei-240);
			$(".hkkresult").css("overflow-y", "auto");
		});
		
	});
	
	function goMakeGian(gbn,docgbn) {
		var menuid = $("#Menuid").val();
		if(menuid=='<%=Constants.Counsel.INOUT_I_MENUID%>' || menuid=='<%=Constants.Counsel.INOUT_O_MENUID%>'){
			docgbn = '자문요청서';
		}else if(menuid=='<%=Constants.Counsel.INOUT_E_MENUID%>'){
			docgbn = '전문분야자문요청서';
		}
		
		$('#myModal').hide();
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/goMakeGian.do",
			data : {
				consultid:$("#consultid").val(),
				gbn : gbn,
				docgbn : docgbn
			},
			datatype: "json",
			error: function(){},
			success:function(data){
				data = Ext.util.JSON.decode(data);
				var obj = new HashMap();
				obj.put("private","1");
				obj.put("write","1");
				obj.put("file",URLINFO + "/dataFile/doctype/"+data.fnm);
				obj.put("gianurl","/dll/SaveContentDoc.do");
				obj.put("saveurl",URLINFO + "/dll/SaveContentDoc.do");
				obj.put("AutoReport",data.id);
				chkSetUp(makeDocXML(obj));	
				
				Ext.Msg.alert('Status', '자문요청서 작성완료후 확인버튼을 클릭 바랍니다.', function(btn, text){
					if (btn == 'ok') {
						gotoview();
					}
				});
			}
		});
	};
	
	//첨부파일 전체 다운로드
	function downloadAllFiles() {
		var frm = document.detailFrm;
		frm.whereFrom.value = "consult";
		frm.gbn.value = gbn;
		frm.action = "${pageContext.request.contextPath}/web/consult/downloadAllFiles.do";
		frm.submit();
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
<style>
	/* The Modal (background) */
	.modal {
		display: none; /* Hidden by default */
		position: fixed; /* Stay in place */
		z-index: 1; /* Sit on top */
		left: 0;
		top: 0;
		width: 100%; /* Full width */
		height: 100%; /* Full height */
		overflow: auto; /* Enable scroll if needed */
		background-color: rgb(0,0,0); /* Fallback color */
		background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
	}
	
	/* Modal Content/Box */
	.modal-content {
		background-color: #fefefe;
		margin: 10% auto; /* 15% from the top and centered */
		padding: 20px;
		border: 1px solid #888;
		width: 45%; /* Could be more or less, depending on screen size */                          
	}
</style>
<form name="ViewForm" method="post">
	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<form name="detailFrm" id="detailFrm" method="post">
<%-- 	<input type="hidden" name="searchForm" id="searchForm" value="<%=searchForm%>"/> --%>
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="consultid"   id="consultid" value="<%=cnstn_mng_no%>"/>
	<input type="hidden" name="inoutcon"   id="inoutcon" value="<%=insd_otsd_task_se%>"/>
	<input type="hidden" name="searchForm" id="searchForm" value="<%=searchForm%>"/>
<!-- 	<input type="hidden" id="whereFrom" name="whereFrom" /> -->
<!-- 	<input type="hidden" id="gbn" name="gbn" /> -->
	<div class="subCA">
		<div class="hkkresult">
			<hr class="margin40">
			<strong class="subST">구두 자문</strong>
			<div class="subBtnW side">
				<div class="subBtnC right">
					<%
					if(USERNO.equals(wrtr_emp_nm) || GRPCD.indexOf("Y")>-1){
					%>
						<a href="#" id="uBtn" class="sBtn type1">수정</a>
						<a href="#" id="dBtn" class="sBtn type1">삭제</a>
					<%
					}
					%>
					<a href="#" id="lBtn" class="sBtn type1">목록</a>
				</div>
			</div>
			<div class="innerB" >
				<table class="infoTable write" style="width: 100%">
					<colgroup>
						<col style="width:15%;">
						<col style="width:22%;">
						<col style="width:10%;">
						<col style="width:22%;">
						<col style="width:9%;">
						<col style="width:22%;">
					</colgroup>
					<tr>
						<th>상담일자</th>
						<td>
							<%=cnstn_cmptn_ymd %>
						</td>
						<th>상담유형</th>
						<td>
						<%
							if ("방문".equals(dscsn_type_nm)) {
								out.println("방문");
							} else if ("유선".equals(dscsn_type_nm)) {
								out.println("유선");
							} else if ("메일".equals(dscsn_type_nm)) {
								out.println("메일");
							} else if ("메신저".equals(dscsn_type_nm)) {
								out.println("메신저");
							} else {
								out.println("미지정");
							}
						%>
						</td>
						<th>답변자</th>
						<td>
							<%=cnstn_tkcg_emp_nm %>
						</td>
					</tr>
					<tr>
						<th>의뢰부서</th>
						<td>
							<%=cnstn_rqst_dept_nm %>
						</td>
						
						<th>의뢰인</th>
						<td>
							<%=cnstn_rqst_emp_nm %>
						</td>
						<th>등록일자</th>
						<td>
							<%=wrt_ymd %>
						</td>
					</tr>
					<tr>
						<th>안건</th>
						<td colspan="5">
							<%= cnstn_ttl %>
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td colspan="5">
							<%= rmrk_cn %>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</form>