<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	DecimalFormat formatter = new DecimalFormat("###,###");
	
	String BND_MNG_NO = request.getAttribute("BND_MNG_NO")==null?"":request.getAttribute("BND_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap bondMap = request.getAttribute("bondMap")==null?new HashMap():(HashMap)request.getAttribute("bondMap");
	List recList = request.getAttribute("recList")==null?new ArrayList():(ArrayList)request.getAttribute("recList");
	List bondFile = request.getAttribute("bondFile")==null?new ArrayList():(ArrayList)request.getAttribute("bondFile");
	
	String BND_DBT_SE = bondMap.get("BND_DBT_SE")==null?"":bondMap.get("BND_DBT_SE").toString();
	String BND_AMT = bondMap.get("BND_AMT")==null?"":bondMap.get("BND_AMT").toString();
	
	String TXTN_NO = bondMap.get("TXTN_NO")==null?"":bondMap.get("TXTN_NO").toString();
	String SYS_ID = bondMap.get("SYS_ID")==null?"":bondMap.get("SYS_ID").toString();
	
	int BONDBAL = bondMap.get("BND_AMT")==null?0:Integer.parseInt(bondMap.get("BND_AMT").toString());
%>
<style>
	.popW{min-width:400px; height:100%;}
	th{text-align:center;}
	#suitnm{cursor:pointer;}
	.filename{text-align:left; margin-left:15px; cursor:pointer;}
	.selFileDiv{cursor:pointer; text-decoration:underline;}
	#selInfrm {
		cursor:pointer; text-decoration:underline;
	}
</style>
<script type="text/javascript">
	var BND_MNG_NO = "<%=BND_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var BND_DBT_SE = "<%=BND_DBT_SE%>";
	var BND_AMT = "<%=BND_AMT%>";
	var BONDBAL = "<%=BONDBAL%>";
	
	$(document).ready(function(){
		
	});
	
	function addRecove(){
		var bondbal = "<%=BONDBAL%>";
		if(bondbal=="0"){
			return alert("채권(채무) 잔액이 0원 입니다.");
		}
		var cw=800;
		var ch=225;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","RecEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "RecEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/bondRecEditPop.do");
		
		newForm.append($("<input/>", {type:"hidden", name:"BND_RTRVL_MNG_NO", value:""}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_MNG_NO", value:BND_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_AMT", value:BND_AMT}));
		newForm.append($("<input/>", {type:"hidden", name:"BONDBAL", value:BONDBAL}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_DBT_SE", value:BND_DBT_SE}));
		
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function editRec(BND_RTRVL_MNG_NO){
		var cw=800;
		var ch=350;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","RecEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "RecEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/bondRecEditPop.do");
		
		newForm.append($("<input/>", {type:"hidden", name:"BND_RTRVL_MNG_NO", value:BND_RTRVL_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_MNG_NO", value:BND_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_AMT", value:BND_AMT}));
		newForm.append($("<input/>", {type:"hidden", name:"BONDBAL", value:BONDBAL}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_DBT_SE", value:BND_DBT_SE}));
		
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function delRec(recoveid){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/deleteRecInfo.do",
			data:{BND_RTRVL_MNG_NO:BND_RTRVL_MNG_NO, BND_MNG_NO:BND_MNG_NO},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				reLoadPop();
			}
		});
	}
	
	function editBondInfo(){
		opener.goWritePage(BND_MNG_NO);
		window.close();
	}
	
	function reLoadPop(){
		location.reload(true);
	}
	
	function delBondInfo(){
		var msg = "";
		if(gbn == "B"){
			msg = "채권정보 및 회수정보가 삭제됩니다. 삭제 하시겠습니까?";
		}else{
			msg = "채무정보 및 지급정보가 삭제됩니다. 삭제 하시겠습니까?";
		}
		
		if(confirm(msg)){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteBondInfo.do",
				data:{bondid:bondid},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					opener.goReLoad();
					window.close();
				}
			});
		}
	}
	
	function goBuga() {
		$.ajax({
			type : "POST",
			data:{
				BND_MNG_NO  : BND_MNG_NO,
				LWS_MNG_NO  : LWS_MNG_NO,
				INST_MNG_NO : INST_MNG_NO
			},
			dataType:"json",
			url : "<%=CONTEXTPATH %>/web/suit/bondBugaInsert.do",
			success : function(data) {
				console.log(data);
				alert(data.msg);
				reLoadPop();
			}
		});
	}
	
	function getBuga() {
		$.ajax({
			type : "POST",
			data:{
				BND_MNG_NO  : BND_MNG_NO,
				LWS_MNG_NO  : LWS_MNG_NO,
				INST_MNG_NO : INST_MNG_NO
			},
			dataType:"json",
			url : "<%=CONTEXTPATH %>/web/suit/bondBugaUpdate.do",
			success : function(data) {
				alert("진행상태가 동기화되었습니다.");
				reLoadPop();
			}
		});
	}
	
	function viewInfrmNo(infrmNo) {
		if (infrmNo != "") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","viewInfrmInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "viewFrm");
			newForm.attr("method", "get");
			newForm.attr("target", "viewInfrmInfo");
			newForm.attr("action", "https://etax.seoul.go.kr/jsp/gojilink.jsp?nap_no="+infrmNo);
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else {
			return alert("고지번호가 수신되지 않았습니다.\n세외수입시스템 확인 후, 부과정보동기화를 수행하세요.");
		}
	}
</script>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="BND_MNG_NO"      id="BND_MNG_NO"      value="<%=BND_MNG_NO%>" />
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="SYS_ID"          id="SYS_ID"          value="<%=SYS_ID%>"/>
	
	<strong class="popTT">
		<%if("B".equals(BND_DBT_SE)){ %>
		채권 관리
		<%}else{ %>
		채무 관리
		<%} %>
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div>
		<div class="popC">
			<div class="popA">
				<table class="pop_listTable" id="infoList">
					<colgroup>
						<col style="width:10%;">
						<col style="width:*;">
						<col style="width:10%;">
						<col style="width:*;">
					</colgroup>
					<tr>
						<th>구분</th>
						<td>
							<%=bondMap.get("BND_DBT_SE_NM")==null?"":bondMap.get("BND_DBT_SE_NM").toString()%>
						</td>
						<%if("B".equals(BND_DBT_SE)){ %>
						<th>채권금액</th>
						<%}else{ %>
						<th>채무금액</th>
						<%} %>
						<td>
							<%=bondMap.get("BND_AMT")==null?"":bondMap.get("BND_AMT").toString()%>
						</td>
					</tr>
					<tr>
						<th>당사자명</th>
						<td>
							(<%=bondMap.get("TXPR_SE_NM")==null?"":bondMap.get("TXPR_SE_NM").toString()%>)
							<%=bondMap.get("CNCPR_NM")==null?"":bondMap.get("CNCPR_NM").toString()%>
						</td>
						<th>당사자전화번호</th>
						<td>
							<%=bondMap.get("CNCPR_TELNO")==null?"":bondMap.get("CNCPR_TELNO").toString()%>
						</td>
					</tr>
					<tr>
						<th>당사자 우편번호</th>
						<td>
							<%=bondMap.get("CNCPR_ZIP")==null?"":bondMap.get("CNCPR_ZIP").toString()%>
						</td>
						<th>당사자 주소</th>
						<td>
							<%=bondMap.get("CNCPR_ADDR")==null?"":bondMap.get("CNCPR_ADDR").toString()%>
						</td>
					</tr>
					<tr>
						<th>채권발행일</th>
						<td>
							<%=bondMap.get("BND_PBLCN_YMD")==null?"":bondMap.get("BND_PBLCN_YMD").toString()%>
						</td>
						<th>판결확정일</th>
						<td>
							<%=bondMap.get("JDGM_CFMTN_YMD")==null?"":bondMap.get("JDGM_CFMTN_YMD").toString()%>
						</td>
					</tr>
					<tr>
						<th colspan="4">세외수입 부과정보</th>
					</tr>
					<tr>
						<th>부과상태</th>
						<td colspan="3">
							<%=bondMap.get("PRGRS_STTS_SE_NM")==null?"":bondMap.get("PRGRS_STTS_SE_NM").toString()%>
						</td>
					</tr>
					<tr>
						<th>과세번호</th>
						<td>
							<%=bondMap.get("TXTN_NO")==null?"":bondMap.get("TXTN_NO").toString()%>
						</td>
						<th>고지번호</th>
						<td id="selInfrm" onclick="viewInfrmNo('<%=bondMap.get("INFRM_NO")==null?"":bondMap.get("INFRM_NO").toString()%>');">
							<%=bondMap.get("INFRM_NO")==null?"":bondMap.get("INFRM_NO").toString()%>
						</td>
					</tr>
					<tr>
						<th>과세일자</th>
						<td>
							<%=bondMap.get("TXTN_YMD")==null?"":bondMap.get("TXTN_YMD").toString()%>
						</td>
						<th>납기일자</th>
						<td>
							<%=bondMap.get("DUDT_YMD")==null?"":bondMap.get("DUDT_YMD").toString()%>
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td colspan="3">
							<%=bondMap.get("RMRK_CN")==null?"":bondMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td id="fileList" height="150px" colspan="3">
						<%
							for(int f=0; f<bondFile.size(); f++) {
								HashMap file = (HashMap)bondFile.get(f);
						%>
								<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
									<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
								</div>
						<%
							}
						%>
						</td>
					</tr>
				</table>
			</div>
			<hr class="margin20">
			<div class="subBtnW side">
				<div class="subBtnC right">
			<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 || GRPCD.indexOf("B") > -1 || GRPCD.indexOf("G") > -1 || GRPCD.indexOf("E") > -1) {%>
				<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("E") > -1) { %>
					<%if(TXTN_NO.equals("") && !SYS_ID.equals("")){%>
					<a href="#none" class="sBtn type2" onclick="goBuga();">비용부과</a>
					<%}else{%>
					<a href="#none" class="sBtn type2" onclick="getBuga();">부과정보동기화</a>
					<%}%>
				<%}%>
					<a href="#none" class="sBtn type2" onclick="editBondInfo();">수정</a>
					<a href="#none" class="sBtn type3" onclick="delBondInfo();">삭제</a>
			<%}%>
				</div>
			</div>
			<div class="popA">
				<table class="pop_listTable" id="recovList">
					<colgroup>
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:15%;">
					</colgroup>
					<tr>
					<%if("B".equals(BND_DBT_SE)){ %>
						<th>채권총액</th>
						<th>회수금액</th>
						<th>회수일자</th>
						<th>채권잔액</th>
						<th></th>
					<%}else{ %>
						<th>채무총액</th>
						<th>지급금액</th>
						<th>지급일자</th>
						<th>채무잔액</th>
						<th></th>
					<%} %>
					</tr>
<%
					System.out.println("?????????????? 3 " + recList.size());
					if(recList.size() > 0){
						for(int i=0; i<recList.size(); i++){
							HashMap reinfo = (HashMap)recList.get(i);
							String BND_RTRVL_MNG_NO = reinfo.get("BND_RTRVL_MNG_NO")==null?"":reinfo.get("BND_RTRVL_MNG_NO").toString();
							
							int GIVE_RTRVL_AMT = reinfo.get("GIVE_RTRVL_AMT")==null?0:Integer.parseInt(reinfo.get("GIVE_RTRVL_AMT").toString());
							
							BONDBAL = BONDBAL-GIVE_RTRVL_AMT;
%>
					<tr>
						<td><%=formatter.format(Integer.valueOf(bondMap.get("BND_AMT")==null?"":bondMap.get("BND_AMT").toString()))%></td>
						<td><%=formatter.format(Integer.valueOf(reinfo.get("GIVE_RTRVL_AMT")==null?"":reinfo.get("GIVE_RTRVL_AMT").toString()))%></td>
						<td><%=reinfo.get("GIVE_RTRVL_YMD")==null?"":reinfo.get("GIVE_RTRVL_YMD").toString()%></td>
						<td><%=formatter.format(BONDBAL)%></td>
						<td>
							<a href="#none" class="innerBtn" onclick="editRec('<%=BND_RTRVL_MNG_NO%>');">수정</a>
							<a href="#none" class="innerBtn" onclick="delRec('<%=BND_RTRVL_MNG_NO%>');">삭제</a>
						</td>
					</tr>
<%
						}
					}else{
%>
					<tr>
						<%
							if("B".equals(BND_DBT_SE)){
						%>
						<td colspan="5">등록 된 회수정보가 없습니다.</td>
						<%
							}else{
						%>
						<td colspan="5">등록 된 지급정보가 없습니다.</td>
						<%
							}
						%>
					</tr>
<%
					}
%>
				</table>
			</div>
			<hr class="margin20">
			<div class="subBtnW side">
				<div class="subBtnC right">
			<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 || GRPCD.indexOf("B") > -1 || GRPCD.indexOf("G") > -1 || GRPCD.indexOf("E") > -1) {%>
				<%if("B".equals(BND_DBT_SE)){ %>
					<a href="#none" class="sBtn type1" onclick="addRecove();">회수금 등록</a>
				<%}else{ %>
					<a href="#none" class="sBtn type1" onclick="addRecove();">지급금 등록</a>
				<%} %>
			<%} %>
				</div>
			</div>
			<div class="popA">
				<table class="pop_listTable" id="infoList">
					<colgroup>
						<col style="width:10%;">
						<col style="width:*;">
						<col style="width:10%;">
						<col style="width:*;">
						<col style="width:10%;">
						<col style="width:*;">
					</colgroup>
					<tr>
						<%if("B".equals(BND_DBT_SE)){ %>
						<th>채권금액</th>
						<%}else{ %>
						<th>채무금액</th>
						<%} %>
						<td id="bondamt"><%=formatter.format(Integer.valueOf(bondMap.get("BND_AMT")==null?"":bondMap.get("BND_AMT").toString()))%></td>
						<%if("B".equals(BND_DBT_SE)){ %>
						<th>총 회수금액</th>
						<%}else{ %>
						<th>총 지급금액</th>
						<%} %>
						<td id="recoveamt"><%=formatter.format(Integer.valueOf(bondMap.get("GIVE_RTRVL_AMT")==null?"":bondMap.get("GIVE_RTRVL_AMT").toString()))%></td>
						<%if("B".equals(BND_DBT_SE)){ %>
						<th>채권잔액</th>
						<%}else{ %>
						<th>채무잔액</th>
						<%} %>
						<td id="bondbal"><%=formatter.format(Integer.valueOf(bondMap.get("BND_BLNC")==null?"":bondMap.get("BND_BLNC").toString()))%></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</form>