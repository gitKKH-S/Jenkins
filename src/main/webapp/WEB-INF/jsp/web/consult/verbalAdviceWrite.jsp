<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>

<%

	HashMap se = (HashMap)session.getAttribute("userInfo");
	System.out.println(se);
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String OPHONE = se.get("INPHONE")==null?"":se.get("INPHONE").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTNAME = se.get("DEPTNAME")==null?"":se.get("DEPTNAME").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	
	// 구두 자문 기본 정보
	HashMap consultinfo = request.getAttribute("consultinfo")==null?new HashMap():(HashMap)request.getAttribute("consultinfo");
	String consultid = consultinfo.get("CNSTN_MNG_NO")==null?"":consultinfo.get("CNSTN_MNG_NO").toString();
	String cnstn_cmptn_ymd = consultinfo.get("CNSTN_CMPTN_YMD")==null?"":consultinfo.get("CNSTN_CMPTN_YMD").toString();
	String cnstn_rqst_dept_nm = consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString();
	String cnstn_rqst_dept_no = consultinfo.get("CNSTN_RQST_DEPT_NO")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NO").toString();
	String cnstn_rqst_emp_nm = consultinfo.get("CNSTN_RQST_EMP_NM")==null?"":consultinfo.get("CNSTN_RQST_EMP_NM").toString();
	String cnstn_rqst_emp_no = consultinfo.get("CNSTN_RQST_EMP_NO")==null?"":consultinfo.get("CNSTN_RQST_EMP_NO").toString();
	String dscsn_type_nm = consultinfo.get("DSCSN_TYPE_NM")==null?"":consultinfo.get("DSCSN_TYPE_NM").toString();
	String cnstn_tkcg_emp_nm = consultinfo.get("CNSTN_TKCG_EMP_NM")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NM").toString();
	String cnstn_tkcg_emp_no = consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString();
	String cnstn_ttl = consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString();

	
	String rls_yn = consultinfo.get("RLS_YN")==null?"":consultinfo.get("RLS_YN").toString();
	String insd_otsd_task_se = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
// 	String phone = consult.get("PHONE")==null?"":consult.get("PHONE").toString();
	String emrg_yn = consultinfo.get("EMRG_YN")==null?"":consultinfo.get("EMRG_YN").toString();
	String rqst_dept_last_aprvr_jbps_nm = consultinfo.get("RQST_DEPT_LAST_APRVR_JBPS_NM")==null?"":consultinfo.get("RQST_DEPT_LAST_APRVR_JBPS_NM").toString();
	String prvt_srch_kywd_cn = consultinfo.get("PRVT_SRCH_KYWD_CN")==null?"":consultinfo.get("PRVT_SRCH_KYWD_CN").toString();
	String otsd_rqst_rsn = consultinfo.get("OTSD_RQST_RSN")==null?"":consultinfo.get("OTSD_RQST_RSN").toString();
	String cnstn_rqst_cn = consultinfo.get("CNSTN_RQST_CN")==null?"":consultinfo.get("CNSTN_RQST_CN").toString();
	String cnstn_rqst_subst_cn = consultinfo.get("CNSTN_RQST_SUBST_CN")==null?"":consultinfo.get("CNSTN_RQST_SUBST_CN").toString();
	String rmrk_cn = consultinfo.get("RMRK_CN")==null?"":consultinfo.get("RMRK_CN").toString();
	String cnstn_rqst_dept_tmldr_nm = consultinfo.get("CNSTN_RQST_DEPT_TMLDR_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_NM").toString();
	String cnstn_rqst_dept_tmldr_emp_no = consultinfo.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO").toString();
	
	// 의뢰서 작성시 등록일 위한 날짜 구하기
    LocalDate today = LocalDate.now();
    // 원하는 포맷 지정
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    String regDate = today.format(formatter);
	
	//구두 자문 파일 정보
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");
	
	String writer = "";
	String writerId = "";
	writer = USERNAME;
	writerId = USERNO;
	
	String CNSTN_CMPTN_YMD = regDate;
	
	if(consultinfo!=null && consultinfo.size()>0){

		CNSTN_CMPTN_YMD = cnstn_cmptn_ymd;
		regDate = consultinfo.get("WRT_YMD")==null?"":consultinfo.get("WRT_YMD").toString();
		writer = consultinfo.get("CNSTN_TKCG_EMP_NM")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NM").toString();
		writerId = consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString();
		
	}
	
%>


<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<script type="text/javascript" src="${resourceUrl}/js/plugin/jquery.number.js"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	$(document).ready(function(){
		$("#savebtn").click(function(){
			if(confirm("등록 하시겠습니까?")){
				if($("#cnstn_ttl").val()==''){
					alert('구두자문 안건을 입력하세요.');
					return;
				}
				$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
				$("#consultid").val('<%=consultid%>');
				$("#wrt_ymd").val('<%=regDate%>');
				$.ajax({
					type:"POST",
					url : "${pageContext.request.contextPath}/web/consult/verbalAdviceSave.do",
					data : $('#wform').serializeArray(),
					dataType: "json",
					async: false,
					success : function(result){
						$("#consultid").val(result.data.gbnid);
						
						if(fileList.length > 0){
							for(var i=0; i<fileList.length; i++){
								
								var formData = new FormData();
								formData.append('file'+i, fileList[i]);
								//formData.append("filenm", $("#filename"+i).val());
								formData.append('gbnid', result.data.gbnid);
								formData.append('filegbn', 'CONSULT');
								
								var other_data = $('#wform').serializeArray();
								$.each(other_data,function(key,input){
									if(input.name != 'consultid'){
										formData.append(input.name, input.value);
									}
								});
								
								var status = statusList[i];
								uploadFile(status, formData, i, fileList.length);
							}
						}else{
							alert("저장되었습니다.");
							wform.consultid.value = result.data.gbnid;
							wform.action = "${pageContext.request.contextPath}/web/consult/verbalAdviceView.do";
							wform.submit();
						}
					}
				});
			}
		});
		var jbAry = new Array();
		var jbAry2 = new Array();
		function uploadFile(status,formData, idx, maxidx){
			var uploadURL = "${pageContext.request.contextPath}/web/consult/fileUploadconsult.do"; //Upload URL
			var extraData ={}; //Extra Data.
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
					if(idx == (maxidx-1)){
						var frm = document.wform;
						alert("저장되었습니다.");
						wform.action = "${pageContext.request.contextPath}/web/consult/verbalAdviceView.do";
						wform.submit();
					}
				}
			});
			status.setAbort(jqXHR);
		}
		
		$("#listbtn").click(function(){
			var frm = document.wform;
			frm.action = "${pageContext.request.contextPath}/web/consult/goVerbalAdviceList.do";
			frm.submit();
		});
		$("#hwpBtn").click(function(){
			
			downFile("법률자문의뢰서.hwp",'10000.hwp','CONSULT');
			
		});
	});
	
	function searchDept(idx){
		var cw=1000;
		var ch=900;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","relViewPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "relViewPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/searchDeptPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"menu", value:idx}));
		newForm.append($("<input/>", {type:"hidden", name:"deptno", value:""}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
</script>
<style>
	.innerBtn {
		display: inline-block;
		height: 25px;
		line-height: 25px;
		text-align: center;
		padding: 0 10px;
		border-radius: 15px;
		background: #fff;
		font-size: 11px;
		border: 1px solid #009475;
		color: #009475;
		font-weight: bold;
	}
	.innerBtn {float: right;}
	
	.flex-align {
		
	  	display: flex;
	  	align-items: center; /* 수직 가운데 정렬 */
	  	gap: 8px; /* 간격 여유 */
	}
	.flex-align input[type="text"] {
	  	flex: 1;
	}
	
	table:not(.x-toolbar-right) {
    width: 100%;                    /* 콘텐츠 기반 auto의 반대 */
/*     table-layout: fixed;           /* unset 해제 후 고정 레이아웃 */ */
/*     box-sizing: border-box;        /* revert 대신 명시적 border-box */ */
/*     -webkit-box-sizing: border-box; */
	}
</style>

<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">구두법률자문 관리대장 등록</strong>
		</div>
		<div class="subBtnC right" id="test">
			<a href="#none" class="sBtn type1" id="savebtn">저장</a>
			<a href="#none"class="sBtn type2" id="listbtn">목록</a>
		</div>
		
	</div>	
	<hr class="margin40">
	<div class="innerB" >
		<form name="wform" id="wform" method="post" action="${pageContext.request.contextPath}/web/consult/verbalAdviceSave.do">
			<input type="hidden" name="searchForm" id="searchForm" value="<%=searchForm%>"/>
			<input type="hidden" name="consultid"  id="consultid"  value="<%=consultid%>"/>
			<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=MENU_MNG_NO%>">
			<input type="hidden" name="INSD_OTSD_TASK_SE"     id="INSD_OTSD_TASK_SE"     value="V">
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width:10%;">
				<col style="width:23%;">
				<col style="width:10%;">
				<col style="width:23%;">
				<col style="width:10%;">
				<col style="width:24%;">
			</colgroup>
			<tr>
				<th>상담일자</th>
				<td>
					<input type="text" name="cnstn_cmptn_ymd" id="cnstn_cmptn_ymd" class="datepick" value="<%= CNSTN_CMPTN_YMD%>" readonly="readonly">
				</td>
				<th>상담유형</th>
				<td>
					<select id="dscsn_type_nm" name="dscsn_type_nm" style="width: 50%;">
						<option value="유선" <%if("유선".equals(dscsn_type_nm) || dscsn_type_nm.equals("")) out.println("selected");%>>유선</option>
						<option value="방문" <%if("방문".equals(dscsn_type_nm)) out.println("selected");%>>방문</option>
						<option value="메일" <%if("메일".equals(dscsn_type_nm)) out.println("selected");%>>메일</option>
						<option value="메신저" <%if("메신저".equals(dscsn_type_nm)) out.println("selected");%>>메신저</option>
					</select>
				</td>
				<th>답변자</th>
				<td>
					<input type="text" name="cnstn_tkcg_emp_nm" id="cnstn_tkcg_emp_nm" value="<%=writer%>" onclick="searchDept('verAd2');" readonly="readonly"style="width:100%"/>
					<input type="hidden" name="cnstn_tkcg_emp_no" id="cnstn_tkcg_emp_no" value="<%=writerId %>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>의뢰부서</th>
				<td>
					<input type="text" name="cnstn_rqst_dept_nm" id="cnstn_rqst_dept_nm" value="<%=cnstn_rqst_dept_nm%>" onclick="searchDept('verAd1');" readonly="readonly"style="width:100%"/>
					<input type="hidden" name="cnstn_rqst_dept_no" id="cnstn_rqst_dept_no" value="<%=cnstn_rqst_dept_no %>" readonly="readonly">
				</td>
				<th>의뢰인</th>
				<td>
					<input type="text" name="cnstn_rqst_emp_nm" id="cnstn_rqst_emp_nm" value="<%=cnstn_rqst_emp_nm%>" onclick="searchDept('verAd1');" readonly="readonly"style="width:100%"/>
					<input type="hidden" name="cnstn_rqst_emp_no" id="cnstn_rqst_emp_no" value="<%=cnstn_rqst_emp_no %>" readonly="readonly">
				</td>
				<th>등록일자</th>
				<td>
					<input type="text" name="wrt_ymd" id="wrt_ymd" value="<%=regDate %>" style="width: 100%;" readonly="readonly" />
				</td>
			</tr>
<!-- 			<tr> -->
<!-- 				<th>관리자 검색 키워드</th> -->
<!-- 				<td colspan="5"> -->
<%-- 					<input type="text" id="prvt_srch_kywd_cn" name="prvt_srch_kywd_cn" style="width:100%;" value="<%=prvt_srch_kywd_cn%>"/> --%>
<!-- 				</td> -->
<!-- 			</tr> -->
			<tr>
				<th>안건<sup><font color=red>*</font></sup></th>
				<td colspan="5">
					<input type="text" id="cnstn_ttl" name="cnstn_ttl" style="width:100%;" value="<%=cnstn_ttl%>"/>
				</td>
				
			</tr>
<!-- 		    <tr> -->
<!-- 		    	<th>구두 자문 내용</th> -->
<%-- 		        <td colspan="5"><textarea id="cnstn_rqst_cn" name="cnstn_rqst_cn" rows="8" cols=""><%=cnstn_rqst_cn%></textarea></td> --%>
<!-- 		    </tr> -->
	     	<tr>
		    	<th>비고(특이사항)</th>
		        <td colspan="5"><textarea id="rmrk_cn" name="rmrk_cn" rows="8" cols="" style="width: 100%;"><%=rmrk_cn%></textarea></td>
		    </tr>
		</table>
		</form>
	</div>
</div>
