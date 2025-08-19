<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap dateinfo = request.getAttribute("dateinfo")==null?new HashMap():(HashMap)request.getAttribute("dateinfo");
	String DATE_TYPE_CD = dateinfo.get("DATE_TYPE_CD")==null?"":dateinfo.get("DATE_TYPE_CD").toString();
	String NOTI_YN      = dateinfo.get("NOTI_YN")==null?"":dateinfo.get("NOTI_YN").toString();
	String DATE_RSLT_CN = dateinfo.get("DATE_RSLT_CN")==null?"":dateinfo.get("DATE_RSLT_CN").toString();
	String time1        = dateinfo.get("FTIME")==null?"":dateinfo.get("FTIME").toString();
	String time2        = dateinfo.get("BTIME")==null?"":dateinfo.get("BTIME").toString();
	String NOTI_INV     = dateinfo.get("NOTI_INV")==null?"":dateinfo.get("NOTI_INV").toString();
	
	List codeList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList)request.getAttribute("codeList");
	
	String DATE_MNG_NO = request.getAttribute("DATE_MNG_NO")==null?"":request.getAttribute("DATE_MNG_NO").toString();
	String LWS_MNG_NO  = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String WRTR_EMP_NM      = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO    = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM    = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO      = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO      = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
%>
<script type="text/javascript">
	var DATE_MNG_NO  = "<%=DATE_MNG_NO%>";
	var LWS_MNG_NO   = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO  = "<%=INST_MNG_NO%>";
	var MENU_MNG_NO  = "<%=MENU_MNG_NO%>";
	var DATE_TYPE_CD = "<%=DATE_TYPE_CD%>";
	var NOTI_YN      = "<%=NOTI_YN%>";
	var NOTI_INV     = "<%=NOTI_INV%>";
	
	$(document).ready(function(){
		if(DATE_MNG_NO != ""){
			var term = document.getElementsByName("noticeterm[]");
			var leng = term.length;
			var cnt = 0;
			for(var i=0; i < leng; i++ ){
				if(NOTI_INV.indexOf(term[i].value) > -1){
					term[i].checked = true;
				}
			}
			
			setTermTr(NOTI_YN);
		}
	});
	
	function saveDate(){
		var notiyn = $("#NOTI_YN").val();
		
		if($("#DATE_TYPE_CD").val() == ""){
			return alert("기일 종류를 선택하세요");
		}
		
		if($("#DATE_YMD").val() == ""){
			return alert("일자를 입력하세요");
		}
		
		var term = document.getElementsByName("noticeterm[]");
		var leng = term.length;
		var cnt = 0;
		for(var i=0; i < leng; i++ ){
			if(term[i].checked == true){
				cnt += 1;
			}
		}
		
		if(notiyn=="Y" && cnt == 0){
			return alert("알림 간격을 선택하세요");
		}
		
		var time = $("#time1").val() + $("#time2").val();
		$("#time").val(time);
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertDateInfo.do",
			data: $("#frm").serialize(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				opener.document.getElementById("focus").value = "1";
				opener.goReLoad();
				window.close();
			},
			error:function(request, status, error){
				alert("저장에 실패하였습니다. 관리자에게 문의바랍니다.");
			}
		});
	}
	
	function setTermTr(gbn){
		if(gbn == "Y"){
			$(".noTerm").css("display","table-cell");
		}else{
			var term = document.getElementsByName("noticeterm[]");
			var leng = term.length;
			for(var i=0; i < leng; i++ ){
				term[i].checked = false;
			}
			
			$(".noTerm").css("display","none");
		}
	}
</script>
<style>
	.noTerm{display:none;}
	#noti {color: lightblue; display: inline; position: relative; top: 6px; margin-left: 10px; font-size: 12px;}
</style>
<strong class="popTT">
	기일 관리<p id="noti">* 표시는 필수입력사항입니다.</p>
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="DATE_MNG_NO" id="DATE_MNG_NO"   value="<%=DATE_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO"   value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"    value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="HWRT_REG_YN" id="HWRT_REG_YN"   value="Y"/>
	<input type="hidden" name="WRTR_EMP_NO"    id="WRTR_EMP_NO"      value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"      id="WRTR_EMP_NM"        value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM"    id="WRT_DEPT_NM"      value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"      id="WRT_DEPT_NO"        value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="time"        id="time"          value="" />
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:15%;">
					<col style="width:30%;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>기일종류 *</th>
					<td>
						<select id="DATE_TYPE_CD" name="DATE_TYPE_CD">
							<option value="">선택</option>
						<%
							for(int i=0; i<codeList.size(); i++) {
								HashMap code = (HashMap) codeList.get(i);
								if ("DATEGBN".equals(code.get("CD_LCLSF_ENG_NM"))){
									String codeid = code.get("CD_MNG_NO").toString();
						%>
								<option value="<%=code.get("CD_MNG_NO")%>" <%if(DATE_TYPE_CD.equals(codeid)) out.println("selected");%>>
									<%=code.get("CD_NM")%>
								</option>
						<%
								}
							}
						%>
						</select>
					</td>
					<th>일자 *</th>
					<td>
						<input type="text" class="datepick" id="DATE_YMD" name="DATE_YMD" value="<%=dateinfo.get("DATE_YMD")==null?"":dateinfo.get("DATE_YMD").toString()%>" readonly="readonly" style="width:55%">
					</td>
				</tr>
				<tr>
					<th>시간</th>
					<td>
						<input type="text" id="time1" name="time1" style="width:20%" value="<%=time1%>" maxlength="2" onkeyup="numFormat(this);">시 
						<input type="text" id="time2" name="time2" style="width:20%" value="<%=time2%>" maxlength="2" onkeyup="numFormat(this);">분
					</td>
					<th>장소</th>
					<td><input type="text" id="DATE_PLC_NM" name="DATE_PLC_NM" value="<%=dateinfo.get("DATE_PLC_NM")==null?"":dateinfo.get("DATE_PLC_NM").toString()%>" maxlength="200"></td>
				</tr>
				<tr>
					<th>기일결과</th>
					<td colspan="3">
						<textarea rows="1" cols="20" id="DATE_RSLT_CN" name="DATE_RSLT_CN" style="min-height:60px;"><%=dateinfo.get("DATE_RSLT_CN")==null?"":dateinfo.get("DATE_RSLT_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>결과메모</th>
					<td colspan="3">
						<textarea rows="1" cols="20" id="DATE_RSLT_MEMO_CN" name="DATE_RSLT_MEMO_CN"  style="min-height:60px;"><%=dateinfo.get("DATE_RSLT_MEMO_CN")==null?"":dateinfo.get("DATE_RSLT_MEMO_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3">
						<textarea rows="3" cols="20" id="DATE_CN" name="DATE_CN"><%=dateinfo.get("DATE_CN")==null?"":dateinfo.get("DATE_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<textarea rows="3" cols="20" id="RMRK_CN" name="RMRK_CN"><%=dateinfo.get("RMRK_CN")==null?"":dateinfo.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>알림유무</th>
					<td>
						<select id="NOTI_YN" name="NOTI_YN" onchange="setTermTr(this.value);">
							<option value="N"<%if(NOTI_YN.equals("") || NOTI_YN.equals("N")) out.println("selected");%>>N</option>
							<option value="Y"<%if(NOTI_YN.equals("Y")) out.println("selected");%>>Y</option>
						</select>
					</td>
					<th class="noTerm">알림간격 *</th>
					<td class="noTerm">
						<input type="checkbox" name="noticeterm[]" value="0"> 당일
						<input type="checkbox" name="noticeterm[]" value="1"> 1일 전
						<input type="checkbox" name="noticeterm[]" value="2"> 2일 전
						<input type="checkbox" name="noticeterm[]" value="3"> 3일 전
						<input type="checkbox" name="noticeterm[]" value="4"> 4일 전
						<input type="checkbox" name="noticeterm[]" value="5"> 5일 전
						<input type="checkbox" name="noticeterm[]" value="6"> 6일 전
						<input type="checkbox" name="noticeterm[]" value="7"> 7일 전
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="saveDate();">등록</a>
		</div>
	</div>
</form>