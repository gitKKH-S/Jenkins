<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	int pagesize = 10;
	int pageno = ServletRequestUtils.getIntParameter(request, "pageno", 1);
	
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	
	String schOrd = request.getAttribute("schOrd")==null?"":request.getAttribute("schOrd").toString();
	String lawyerid = request.getAttribute("lawyerid")==null?"":request.getAttribute("lawyerid").toString();
	String lawyernm = request.getAttribute("lawyernm")==null?"":request.getAttribute("lawyernm").toString();
	
	String INSD_OTSD_TASK_SE = request.getParameter("INSD_OTSD_TASK_SE")==null?"I":request.getParameter("INSD_OTSD_TASK_SE");
	String CVTN_MNG_NO = request.getParameter("CVTN_MNG_NO")==null?"":request.getParameter("CVTN_MNG_NO");
	String office = request.getParameter("office")==null?"":request.getParameter("office");
	
	List agreeLawyerList = request.getAttribute("consultLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("consultLawyerList");
	List lawyerList = request.getAttribute("lawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("lawyerList");
	int tot = request.getAttribute("tot")==null?0:Integer.parseInt(request.getAttribute("tot").toString());
	
	int pageCnt;
	if (tot%pagesize==0){
		pageCnt = tot/pagesize;
	}else{
		pageCnt = tot/pagesize+1;
	}
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();	
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	
%>
<script language="javascript" src="${resourceUrl}/js/mten.pagenav.js"></script>
<script src="${resourceUrl}/js/mten.static.js"></script>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css3/table.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css3/popup.css">
<script type="text/javascript">
	var CVTN_MNG_NO = "<%=CVTN_MNG_NO%>";
	var INSD_OTSD_TASK_SE = "<%=INSD_OTSD_TASK_SE%>";
	var cnt = "<%=agreeLawyerList.size()%>";
	var idx = parseInt(cnt);
	var bonIdx = parseInt(cnt);
	
	var lawyerid = "<%=lawyerid%>";
	var lawyeridList = lawyerid.split(",");
	var lawyernm = "<%=lawyernm%>";
	var lawyernmList = lawyernm.split(",");
	
	$(document).ready(function() {
		sendInoutcon(INSD_OTSD_TASK_SE);
		
		console.log(lawyeridList.length);
		for(var i=0; i<lawyeridList.length; i++) {
			if (lawyeridList[i] != "") {
				selectLawyer(lawyeridList[i], lawyernmList[i]);
			}
		}
		
		
		$("#office").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#schBtn').trigger('click');
			}
		});
	});
	
	function sendInoutcon(inoutcon){
		if(inoutcon == "O"){
			$("#lawyerlist").show();
		}else{
// 			$("#lawyerlist").hide();
// 			$(".lawli").remove();
		}
	}
	
	function selectLawyer(lawyerid_sel, name) {
		var html = "";
		html += "<li class='lawli' id='law"+idx+"'>";
		html += "<input type='hidden' id='lawid"+idx+"' value='"+lawyerid_sel+"' />";
		html += "<input type='hidden' id='lawnm"+idx+"' value='"+name+"' />";
		html += name;
		html += "<a href='#none' class='innerBtn law' onclick='javascript:delLaw("+idx+");'>삭제</a>";
		html += "</li>";
		$("#consultlawList").append(html);
		idx = idx+1;
	}
	
	function delLaw(i) {
		$("#law"+i).remove();
	}
	
	function saveAgreeLawyer() {
		var lawyer = "";
		if (idx > 0) {
			for(var i=0; i<idx; i++) {
				lawyer = $("#lawid"+i).val();
				if(lawyer != undefined) {
					if(lawyer.length > 0) {
						if ($("#lawyerid").val().length == 0) {
							$("#lawyerid").val(lawyer);
						} else {
							$("#lawyerid").val($("#lawyerid").val() + "," + lawyer);
						}
					}
				}
			}
		}
		
		if ($("#lawyerid").val().length == 0 && cnt == 0) {
			return alert("자문위원을 지정하세요");
		}
		
		if ($("#lawyerid").val().length == 0 && cnt > 0) {
			opener.viewReload();
			window.close();
			return alert("저장이 완료되었습니다.");
		}
		
		$("#CVTN_MNG_NO").val(CVTN_MNG_NO);
		$("#INSD_OTSD_TASK_SE").val(INSD_OTSD_TASK_SE);
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/agree/agreeLawInfoSave.do",
			data:$('#frm').serializeArray(),
// 			beforeSend : function(xhr){
// 				xhr.setRequestHeader(header,token);	
// 			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("저장이 완료되었습니다.");
				opener.viewReload();
				window.close();
			},
			error:function(request, status, error){
				alert("저장에 실패하였습니다. 관리자에게 문의바랍니다.");
			}
		});
	}
	
	function deleteAgreeLawyer(consultLawyerid) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/agree/deleteAgreeLawyer.do",
			data:{
				CVTN_MNG_NO:$("#CVTN_MNG_NO").val(),
				consultLawyerid:consultLawyerid
			},
// 			beforeSend : function(xhr){
// 				xhr.setRequestHeader(header,token);	
// 			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("삭제가 완료되었습니다.");
				opener.viewReload();
				document.frm.action="<%=CONTEXTPATH%>/web/agree/selectAgreeRvwPicPop.do";
				document.frm.submit();
			},
			error:function(request, status, error){
				alert("저장에 실패하였습니다. 관리자에게 문의바랍니다.");
			}
		});
	}
	
	function searchLaw() {
		if (idx - bonIdx > 0) {
			for(var i=bonIdx; i<idx; i++) {
				lawyer = $("#lawid"+i).val();
				lawyernm = $("#lawnm"+i).val();
				if(lawyer != undefined) {
					if(lawyer.length > 0) {
						if ($("#lawyerid").val().length == 0) {
							$("#lawyerid").val(lawyer);
							$("#lawyernm").val(lawyernm);
						} else {
							$("#lawyerid").val($("#lawyerid").val() + "," + lawyer);
							$("#lawyernm").val($("#lawyernm").val() + "," + lawyernm);
						}
					}
				}
			}
		}
		
		document.frm.action="<%=CONTEXTPATH%>/web/agree/selectAgreeRvwPicPop.do";
		document.frm.submit();
	}
	
	function setChrg(userno, usernm){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/agree/setAgreeRvwPic.do",
			data:{
				"userno" : userno,
				"usernm" : usernm,
				"CVTN_MNG_NO" : "<%=CVTN_MNG_NO%>"
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("담당자 변경이 완료되었습니다.");
				opener.viewReload();
				window.close();
			}
		});
	}
	
	function goLawyerInfo(LWYR_MNG_NO) {
		var cw=1200;
		var ch=600;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","lawyerInfo",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "lawyerInfo");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/lawyerViewPagePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWYR_MNG_NO",        value:LWYR_MNG_NO}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function checkSel(lawyerid_sel, name){
		var isDuplicate = false;
		
		$('.lawli').each(function(){
			var val = $(this).find('input:first').val();
			if (val === lawyerid_sel) {
				alert('이미 선택된 변호사 입니다.');
				isDuplicate = true;
				return false;
			}
		});
		
		if (!isDuplicate) {
			selectLawyer(lawyerid_sel, name);
		}
	}
	
</script>
<style>
	#srchTxt1{width:90%; height:30px; line-height:0px; margin-top:3px;}
	#srchTxt2{width:90%; height:30px; line-height:0px; margin-top:3px;}
	.popW{height:100%}
	#hidden{display:none;}
	.selTd{cursor:pointer;}
	.law{height:17px; line-height:16px;}
	/* .lawli{margin:3px;} */
	#consultlawList {height: 75px; overflow-y:scroll;}
	#consultlawList li {float:left; margin-right:15px; margin-bottom:15px;}
	.lawyernm:hover{
		cursor:pointer;
		text-decoration:underline;
	}
	
	#ordDiv{
		width:200px;
		float:left;
	}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="lawyerid"  id="lawyerid" />
	<input type="hidden" name="lawyernm"  id="lawyernm" />
	<input type="hidden" name="statcd"    id="statcd"    value="접수"/>
	<input type="hidden" name="CVTN_MNG_NO" id="CVTN_MNG_NO" value="<%=CVTN_MNG_NO%>"/>
	<input type="hidden" name="INSD_OTSD_TASK_SE"  id="INSD_OTSD_TASK_SE"  value="<%=INSD_OTSD_TASK_SE%>"/>
	<input type="hidden" name="writerid"  id="writerid"  value="<%=writerid%>" />
	<input type="hidden" name="writer"    id="writer"    value="<%=writer%>" />
	<input type="hidden" name="deptid"    id="deptid"    value="<%=deptid%>" />
	<input type="hidden" name="deptname"  id="deptname"  value="<%=deptname%>" />
	<strong class="popTT">
		담당 고문변호사 관리
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div style="height:74%">
		<div class="popC">
			<div class="popSrchW">
				<div id="ordDiv">
					<input type="radio" name="schOrd" id="schOrd"   value=""   <%if(schOrd.equals("")) out.println("checked");%>   onchange="searchLaw();"/> 전체
					<input type="radio" name="schOrd" id="schOrd5"  value="5"  <%if("5".equals(schOrd)) out.println("checked");%>  onchange="searchLaw();"/> 5건
					<input type="radio" name="schOrd" id="schOrd10" value="10" <%if("10".equals(schOrd)) out.println("checked");%> onchange="searchLaw();"/> 10건
				</div>
				<input type="text" id="office" name="office" value="<%=office%>" style="width:720px;" placeholder="검색 할 법인명을 입력해주세요">
				<a href="#none" class="sBtn type1" onclick="javascript:searchLaw();" id="schBtn"><i class="fa-solid fa-magnifying-glass"></i> 검색</a>
				<a href="#none" class="sBtn type3" onclick="javascript:saveAgreeLawyer();"><i class="fa-regular fa-floppy-disk"></i> 저장</a>
			</div>
			<div class="popA" style="max-height:900px;">
			<div class="popA" style="max-height:900px;">
				<div class="tableW">
					<table class="infoTable pop" style="border-top:2px solid #000; width:100%;">
						<colgroup>
							<col style="width:20%;">
							<col style="width:70%;">
						</colgroup>
						<tr>
							<th style="background:#f3f6f7;text-align:center;color:#000;">자문법인</th>
							<td>
								<ul id="consultlawList">
							<%
								if (agreeLawyerList.size() > 0) {
									for (int i=0; i<agreeLawyerList.size();i++){
										HashMap consult = (HashMap)agreeLawyerList.get(i);
							%>
									<li class='lawli' id='law<%=i%>'>
										<input type='hidden' id='lawid<%=i%>' value='<%=consult.get("RVW_TKCG_EMP_NO")==null?"":consult.get("RVW_TKCG_EMP_NO").toString()%>' />
										<%=consult.get("RVW_TKCG_EMP_NM")==null?"":consult.get("RVW_TKCG_EMP_NM").toString()%>
										<%if (consult.get("OFC_TELNO") != null) {%>
											<%=consult.get("OFC_TELNO")==null?"":consult.get("OFC_TELNO").toString()%>
										<%}%>
										&nbsp;
										<a href='#none' class='innerBtn law' onclick="deleteAgreeLawyer('<%=consult.get("RVW_TKCG_MNG_NO")==null?"":consult.get("RVW_TKCG_MNG_NO").toString()%>');">삭제</a>
									</li>
									&nbsp;&nbsp;&nbsp;
							<%
									}
								}
							%>
								</ul>
							</td>
						</tr>
					</table>
				</div>
				<div style="height:15px;"></div>
				<div>
					<table class="infoTable pop" style="width:98.8%;">
						<colgroup>
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
						</colgroup>	
						<tr style="background:#f3f6f7;text-align:center;color:#000;">
							<th style="background:#f3f6f7;text-align:center;color:#000;">법무법인명</th>
							<th style="background:#f3f6f7;text-align:center;color:#000;">변호사명</th>
							<th style="background:#f3f6f7;text-align:center;color:#000;">전화번호</th>
							<th style="background:#f3f6f7;text-align:center;color:#000;">전문분야</th>
							
							<th style="background:#f3f6f7;text-align:center;color:#000;">평균답변일</th>
							<th style="background:#f3f6f7;text-align:center;color:#000;">평균만족도</th>
							
							<th style="background:#f3f6f7;text-align:center;color:#000;">소송</th>
							<th style="background:#f3f6f7;text-align:center;color:#000;">자문</th>
							<th style="background:#f3f6f7;text-align:center;color:#000;">협약</th>
							<th style="background:#f3f6f7;text-align:center;color:#000;"></th>
						</tr>
					</table>
				</div>
				<div id = "lawyerlist" class="tableW" style="max-height:400px; overflow-y:scroll;">
					<table class="infoTable pop" style="border-top:2px solid #000; width:100%;">
						<colgroup>
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
						</colgroup>	
						<%
							if(lawyerList != null && lawyerList.size() > 0) {
								for(int i=0; i<lawyerList.size(); i++) {
									HashMap lawyer = (HashMap)lawyerList.get(i);
									
									String LWYR_MNG_NO = lawyer.get("LWYR_MNG_NO")==null?"":lawyer.get("LWYR_MNG_NO").toString();
											
									for (int j=0; j<agreeLawyerList.size(); j++) {
										HashMap consult = (HashMap)agreeLawyerList.get(j);
										if (lawyer.get("LWYR_MNG_NO").equals(consult.get("RVW_TKCG_EMP_NO"))){
											break;
										}
										
									}
						%>
							<tr id="lawTr<%=lawyer.get("LWYR_MNG_NO")%>">
								<td style="text-align:center;"><%=lawyer.get("JDAF_CORP_NM")==null?"&nbsp":lawyer.get("JDAF_CORP_NM") %></td>
								<td class="lawyernm" style="text-align:center;" onclick="goLawyerInfo('<%=LWYR_MNG_NO%>');"><%=lawyer.get("LWYR_NM")==null?"&nbsp":lawyer.get("LWYR_NM") %></td>
								<td style="text-align:center;"><%=lawyer.get("MBL_TELNO")==null?"&nbsp":lawyer.get("MBL_TELNO") %></td>
								<td style="text-align:center;"><%=lawyer.get("ARSP_CN")==null?"&nbsp":lawyer.get("ARSP_CN") %></td>
								
								<td style="text-align:center;"><%=lawyer.get("RETURNDATE")==null?"-":lawyer.get("RETURNDATE") %>일</td>
								<td style="text-align:center;"><%=lawyer.get("SATI_SCR")==null?"-":lawyer.get("SATI_SCR") %>점</td>
								
								<td style="text-align:center;"><%=lawyer.get("SCNT")==null?"&nbsp":lawyer.get("SCNT") %></td>
								<td style="text-align:center;"><%=lawyer.get("CCNT")==null?"&nbsp":lawyer.get("CCNT") %></td>
								<td style="text-align:center;"><%=lawyer.get("ACNT")==null?"&nbsp":lawyer.get("ACNT") %></td>
								
								<td style="text-align:center;">
<%-- 									<a href="#none" class="innerBtn" onclick="selectLawyer('<%=lawyer.get("LWYR_MNG_NO")%>', '<%=lawyer.get("LWYR_NM")%>');">선택</a> --%>
									<a href="#none" class="innerBtn" onclick="checkSel('<%=lawyer.get("LWYR_MNG_NO")%>', '<%=lawyer.get("LWYR_NM")%>');">선택</a>
								</td>
							</tr>
						<%
								}
							}else{
						%>
								<tr align="center">
									<td colspan="10">결과가 존재하지 않습니다.</td>
								</tr>
						<%
							}
						%>
					</table>
				</div>
			</div>
		</div>
	</div>
</form>