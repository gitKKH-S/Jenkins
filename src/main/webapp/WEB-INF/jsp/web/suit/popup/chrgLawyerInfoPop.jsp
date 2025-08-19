<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String AGT_MNG_NO = request.getAttribute("AGT_MNG_NO")==null?"":request.getAttribute("AGT_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":(String)request.getAttribute("WRTR_EMP_NM");
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":(String)request.getAttribute("WRTR_EMP_NO");
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":(String)request.getAttribute("WRT_DEPT_NM");
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":(String)request.getAttribute("WRT_DEPT_NO");
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":(String)request.getAttribute("MENU_MNG_NO");
	
	HashMap chrgMap = request.getAttribute("chrgMap")==null?new HashMap():(HashMap)request.getAttribute("chrgMap");
	List chrgFile = request.getAttribute("chrgFile")==null?new ArrayList():(ArrayList)request.getAttribute("chrgFile");
	
	String ACAP_AMT = chrgMap.get("ACAP_AMT")==null?"":chrgMap.get("ACAP_AMT").toString();
	
	Date now = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
	String formatedNow = formatter.format(now);
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<style>
	#loading{
		height:100%;left:0px;position:fixed;_position:absolute;top:0px;
		width:100%;filter:alpha(opacity=50);-moz-opacity:0.5;opacity:0.5;
	}
	.loading{background-color:white;z-index:9998;}
	#loading_img{
		position:absolute;top:50%;left:50%;height:35px;
		margin-top:-25px;margin-left:0px;z-index:9999;
	}
</style>
<script type="text/javascript">
	var AGT_MNG_NO = "<%=AGT_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function reload() {
		document.frm.action="${pageContext.request.contextPath}/web/suit/chrgLawyerInfoPop.do";
		document.frm.submit();
	}
	
	function goInfoEdit(){
		opener.goTabWrite(AGT_MNG_NO);
		window.close();
	}
	
	function goInfoDel(){
		if(confirm("대리인을 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteChrgLawyer.do",
				data:{
					LWS_MNG_NO:LWS_MNG_NO,
					INST_MNG_NO:INST_MNG_NO,
					AGT_MNG_NO:AGT_MNG_NO
				},
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
	
	// 비용 승인여부 처리
	function amtAprv(gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmt.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				AGT_MNG_NO:AGT_MNG_NO,
				APRV_YN:gbn
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				reload();
			}
		});
	}
	
	// 비용 지급여부 처리
	function amtGive(gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmt.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				AGT_MNG_NO:AGT_MNG_NO,
				GIVE_YN:gbn
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				reload();
			}
		});
	}
	
	// 비용 지급일자 처리
	function amtGiveYmd(gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmt.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				AGT_MNG_NO:AGT_MNG_NO,
				GIVE_YMD:$("#GIVE_YMD").val()
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				reload();
			}
		});
	}
	
	function goMakeGianDoc() {
		var formatedNow = "<%=formatedNow%>";
		
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/goMakeGian.do",
			data : {
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				AGT_MNG_NO:AGT_MNG_NO,
				GETDATE:formatedNow,
				gbn:'SO4',
				docgbn:'SUIT',
				writegbn:'1',
				DOC_SE:'SO4'
			},
			datatype: "json",
			error: function(){},
			success:function(data){
				data = Ext.util.JSON.decode(data);
				
				var fileid = data.fnm.split(",");
				
				var obj = new HashMap();
				obj.put("write",      '1');
				obj.put("file",       URLINFO + "/dataFile/doctype/"+fileid[0]);
				obj.put("gianurl",    "/dll/SaveContentDoc.do");
				obj.put("saveurl",    URLINFO + "/dll/SaveContentDoc.do");
				obj.put("AutoReport", data.id);
				chkSetUp(makeDocXML(obj));
				
				Ext.MessageBox.show({
					title : "알림",
					msg : "<span id=\"msgTxt\">문서를 서버에 저장한 후 확인 버튼을 클릭하세요.<br/>※ 미리 누르면 문서가 저장되지 않습니다.</span>",
					icon : Ext.MessageBox.WARNING,
					buttons:Ext.MessageBox.OK,
					width:410,
					fn:function(btn){
						if(btn == "ok"){
							alert("저장 한 문서는 양식관리 화면에서 확인하세요.");
							reload();
						}
					}
				});
			}
		});
	}
</script>
<strong class="popTT">
	소송 위임 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="AGT_MNG_NO"  id="AGT_MNG_NO"  value="<%=AGT_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>소속</th>
					<td>
						<%=chrgMap.get("JDAF_CORP_NM")==null?"":chrgMap.get("JDAF_CORP_NM").toString()%>
					</td>
					<th>변호사명</th>
					<td>
						<%=chrgMap.get("LWYR_NM")==null?"":chrgMap.get("LWYR_NM").toString()%>
					</td>
					<th>위임상태</th>
					<td>
						<%=chrgMap.get("ENDYN")==null?"":chrgMap.get("ENDYN").toString()%>
					</td>
				</tr>
				<tr>
					<th>위임일</th>
					<td>
						<%=chrgMap.get("DLGT_YMD")==null?"":chrgMap.get("DLGT_YMD").toString()%>
					</td>
					<th>위임종료일</th>
					<td>
						<%=chrgMap.get("DLGT_END_YMD")==null?"":chrgMap.get("DLGT_END_YMD").toString()%>
					</td>
					<th>접수여부</th>
					<td><%=chrgMap.get("RCPT_YN")==null?"":chrgMap.get("RCPT_YN").toString()%></td>
				</tr>
				<%
					String rcptYn = chrgMap.get("RCPT_YN")==null?"":chrgMap.get("RCPT_YN").toString();
					if ("N".equals(rcptYn)) {
				%>
				<tr>
					<th>거부사유</th>
					<td colspan="5">
						<%=chrgMap.get("RFSL_RSN")==null?"":chrgMap.get("RFSL_RSN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<%
					}
				%>
				
			<%
				if(!ACAP_AMT.equals("")) {
			%>
				<tr>
					<th>착수금</th>
					<td>
						<%=chrgMap.get("OTST_AMT")==null?"":chrgMap.get("OTST_AMT").toString()%>
					</td>
					<th>성공보수</th>
					<td>
						<%=chrgMap.get("SCS_PAY_AMT")==null?"":chrgMap.get("SCS_PAY_AMT").toString()%>
					</td>
					<th>수임료</th>
					<td>
						<%=chrgMap.get("ACAP_AMT")==null?"":chrgMap.get("ACAP_AMT").toString()%>
					</td>
				</tr>
				<tr>
					<th>수임료 승인</th>
					<td>
					<%
						String APRV_YN = chrgMap.get("APRV_YN")==null?"":chrgMap.get("APRV_YN").toString();
						if (("G".equals(APRV_YN) || "T".equals(APRV_YN)) && !GRPCD.equals("X") &&
								(GRPCD.indexOf("D") > -1 || GRPCD.indexOf("C") > -1 || GRPCD.indexOf("Y") > -1)) {
					%>
						<a href="#none" class="innerBtn" onclick="amtAprv('Y');">승인</a>
						<a href="#none" class="innerBtn" onclick="amtAprv('R');">보완</a>
					<%
						} else {
					%>
						<%=APRV_YN%>
					<%
						}
					%>
					</td>
					<th>지급여부</th>
					<td>
					<%
						String GIVE_YN = chrgMap.get("GIVE_YN")==null?"":chrgMap.get("GIVE_YN").toString();
						if ("Y".equals(APRV_YN) && "N".equals(GIVE_YN) && !GRPCD.equals("X") &&
								(GRPCD.indexOf("D") > -1 || GRPCD.indexOf("C") > -1 || GRPCD.indexOf("Y") > -1)) {
					%>
						<a href="#none" class="innerBtn" onclick="amtGive('Y');">지급</a>
					<%
						} else {
					%>
						<%=GIVE_YN%>
					<%
						}
					%>
					</td>
					<th>지급일자</th>
					<td>
					<%
						if ("N".equals(GIVE_YN)) {
							out.println("미지급");
						} else {
							if (!GRPCD.equals("X") &&
									(GRPCD.indexOf("D") > -1 || GRPCD.indexOf("C") > -1 || GRPCD.indexOf("Y") > -1)) {
					%>
						<input type="text" class="datepick" id="GIVE_YMD" name="GIVE_YMD" style="width: 80px;" value="<%=chrgMap.get("GIVE_YMD")==null?"":chrgMap.get("GIVE_YMD").toString()%>">
						<a href="#none" class="innerBtn" onclick="amtGiveYmd();">저장</a>
					<%
							} else {
					%>
						<%=chrgMap.get("GIVE_YMD")==null?"":chrgMap.get("GIVE_YMD").toString()%>
					<%
							}
						}
					%>
					</td>
				</tr>
			<%
				} else {
			%>
				<tr>
					<td colspan="6" style="font-weight:bold; text-align:center;">
						수임료 정보가 입력되지 않았습니다.<br/>
						대리인이 수임료 정보를 입력한 후 비용을 처리하세요.
					</td>
				</tr>
			<%
				}
			%>
				<tr>
					<th>비고</th>
					<td height="100px" colspan="5">
						<%= chrgMap.get("RMRK_CN")==null?"":chrgMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="fileList" height="150px" colspan="5">
					<%
						for(int f=0; f<chrgFile.size(); f++) {
							HashMap file = (HashMap)chrgFile.get(f);
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
		<div class="subBtnW center">
			<a href="#none" class="sBtn type4" onclick="goMakeGianDoc();">협조요청문 생성</a>
			<a href="#none" class="sBtn type2" onclick="goInfoEdit();">수정</a>
			<a href="#none" class="sBtn type3" onclick="goInfoDel();">삭제</a>
		</div>
	</div>
</form>