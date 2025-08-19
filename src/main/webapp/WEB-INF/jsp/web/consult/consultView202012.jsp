<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@page import="java.text.DecimalFormat"%>
<%
	ConsultService consultService = ConsultServiceHelper.getConsultService(application);
	HashMap consultinfo = request.getAttribute("consultinfo")==null?new HashMap():(HashMap)request.getAttribute("consultinfo");
		
	//자문 기본 정보
	HashMap consult = consultinfo.get("consult")==null?new HashMap():(HashMap)consultinfo.get("consult");
	//자문의뢰서 첨부파일
	List fconsultlist = consultinfo.get("fconsultlist")==null?new ArrayList():(ArrayList)consultinfo.get("fconsultlist");
	//자문변호사 리스트
	List consultLawyerList = consultinfo.get("consultLawyerList")==null?new ArrayList():(ArrayList)consultinfo.get("consultLawyerList");
	//자문답변
	List opinionlist = consultinfo.get("opinionlist")==null?new ArrayList():(ArrayList)consultinfo.get("opinionlist");
	// 자문료 청구 금액, 자문료 지급액 정보 등록됐는지 체크
	List ccostList = consultinfo.get("ccostList")==null?new ArrayList():(ArrayList)consultinfo.get("ccostList");
	// 만족도평가 정보
	List satisList = consultinfo.get("satisList")==null?new ArrayList():(ArrayList)consultinfo.get("satisList");
	
	/*자문요청내용*/
	String consultid = consult.get("CONSULTID")==null?"":consult.get("CONSULTID").toString();
	String title = consult.get("TITLE")==null?"":consult.get("TITLE").toString();
	String consultno = consult.get("CONSULTNO")==null?"":consult.get("CONSULTNO").toString();
	String writer = consult.get("WRITER")==null?"":consult.get("WRITER").toString();
	String writerempno = consult.get("WRITEREMPNO")==null?"":consult.get("WRITEREMPNO").toString();
	String writerdeptnm = consult.get("WRITERDEPTNM")==null?"":consult.get("WRITERDEPTNM").toString();
	String phone = consult.get("PHONE")==null?"":consult.get("PHONE").toString();
	String cellphone = consult.get("CELLPHONE")==null?"":consult.get("CELLPHONE").toString();
	String reqcsttypecd = consult.get("REQCSTTYPECD")==null?"":consult.get("REQCSTTYPECD").toString();
	String openyn = consult.get("OPENYN")==null?"":consult.get("OPENYN").toString();
	String cstsumry = consult.get("CSTSUMRY")==null?"":consult.get("CSTSUMRY").toString();
	String reqconst = consult.get("REQCONST")==null?"":consult.get("REQCONST").toString();
	String aprvmemo = consult.get("APRVMEMO")==null?"":consult.get("APRVMEMO").toString();
	String chrgempno = consult.get("CHRGEMPNO")==null?"":consult.get("CHRGEMPNO").toString();
	String chrgempnm = consult.get("CHRGEMPNM")==null?"":consult.get("CHRGEMPNM").toString();
	String statcd = consult.get("STATCD")==null?"":consult.get("STATCD").toString();
	String inoutcon = consult.get("INOUTCON")==null?"":consult.get("INOUTCON").toString();
	String basis = consult.get("BASIS")==null?"":consult.get("BASIS").toString();
	String refcd = consult.get("REFCD")==null?"":consult.get("REFCD").toString();
	String writedt = consult.get("WRITEDT")==null?"":consult.get("WRITEDT").toString();
	writedt = writedt.replaceAll("-",".");
	String reqdt = consult.get("REQDT")==null?"":consult.get("REQDT").toString();
	String senddt = consult.get("SENDDT")==null?"":consult.get("SENDDT").toString();
	String writerdeptcd = consult.get("WRITERDEPTCD")==null?"":consult.get("WRITERDEPTCD").toString();
	String lawfirmOffice[] = new String[100];
	String apprCost[] = new String[100];
	String apprBank[] = new String[100];
	String apprAccount[] = new String[100];
	String apprOwner[] = new String[100];
	
	
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();	
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	
	boolean chkCCost = false;
	boolean chkKCost = false;
	
	if (ccostList.size() > 0 && ccostList.size() == opinionlist.size()) {
		for (int i=0; i<ccostList.size(); i++) {
			HashMap ccost = (HashMap) ccostList.get(i);
			
			if (ccost.get("CONSULTANTCOST") == null) {
				chkCCost = false;
				break;
			}
			chkCCost = true;

			if (ccost.get("KORAILCOST") == null) {
				chkKCost = false;
				break;
			}
			chkKCost = true;
		}
	}
%>
<style>
.infoTable.write th {
	background: #d6d9dc;
}
</style>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#listbtn").click(function(){
		var frm = document.detailFrm;
		frm.action = "${pageContext.request.contextPath}/web/consult/goConsultList.do";
		frm.submit();
	});
});
function hwpDownload() {
	var frm = document.detailFrm;
	frm.action = "${pageContext.request.contextPath}/web/consult/hwpDownload.do";
	frm.submit();
}

//자문변호사 선택
function selectLawyerPop(){
	var frm = detailFrm;
	cw = 1000;
	ch = 830;
	sw = screen.availWidth;
	sh = screen.availHeight;
	px = (sw-cw)/2;
	py = (sh-ch)/2;
	
	var param = "?consultid="+$("#consultid").val()+"&inoutcon="+$("#inoutcon").val();
	var property = "left="+px+", top="+py+", width="+cw+"px, height="+ch+"px, ";
    property += "scrollbars=auto, resizable=no, status=no, toolbar=no, location=no";

    window.open("${pageContext.request.contextPath}/web/consult/selectLawyerPop.do"+param,"",property); 

}

function goMakeGian(gbn,docgbn){
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
}

function gotowrite(){
	var frm = document.detailFrm;
	frm.action = "consultWrite.do";
	frm.submit();
}

function gotoview(){
	var frm = document.detailFrm;
	frm.action = "consultView.do";
	frm.submit();
}

function nextStepconsult(key){
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/web/consult/nextStepconsult.do",
		data : {
			consultid:$("#consultid").val(),
			statcd : key
		},
		datatype: "json",
		error: function(){},
		success:function(data){
			$("#listbtn").trigger('click');
		}
	});
}

//자문작성자 변호사 게시판
function chckBoardPop(id){
	var param = '';
	if(id){
		param  = "?consultid="+ $("#consultid").val()+"&chckid="+id;
	}else{
		param  = "?consultid="+ $("#consultid").val();
	}
	popOpen($("#consultid").val(),"chckBoardWritePop.do"+param,"820","550");
}

function removeConsult(){
	
}

function editV(){
	$("#resultSenddt").css("display", "none");
	$("#saveSenddt").css("display", "block");
}

function btnAnsDel_onClick( chckid ) {
	/*
		검토의견은 "진행상태 : 검토의견작성중"에서만 등록 가능하게 되어 있다.
		만약 다른 진행상태로 변경되어 있는 상태에서 검토의견을 삭제하면, 다시 등록할 수도 없고 다음 단계로 진행할 수도 없으므로 함부로 삭제해서는 안된다.
		특수한 상황, 예를 들어 한 법무법인이 검토의견을 등록하는 과정에서 네트워크 오류 등의 이유로 두 개의 검토의견이 등록된 상황 등이 아니면
		삭제를 이용해서는 안된다.
	*/
	var confirmMsg = "검토의견을 삭제 하시겠습니까?\n\n※ 삭제 시, 문제가 발생할 수 있으니\n관리자에게 문의 후 진행하시기 바랍니다.";
	
	if ( confirm( confirmMsg ) ) {
		$.ajax( {
				url: "${pageContext.request.contextPath}/web/consult/deleteChck4Ajax.do"
			,	data: { "consultid": $("#consultid").val() , "chckid": chckid }
			,	dataType: "json"
			,	method: "post"
			,	error: function( jqXHR , textStatus , errorThrown ) {
					console.log( "ERROR - \n" + errorThrown );
					alert( "처리 중 오류가 발생하였습니다." );
				}
			,	success: function( result ) {
					alert( "정상 처리 되었습니다." );
					gotoview();
				}
		} );
	}
}

//외부변호사 만족도평가 팝업
function satisfactionPop(gbn){
    var param = "?writercd="+gbn+"&consultid="+$("#consultid").val();
    popOpen($("#consultid").val(),"satisfactionPop.do"+param,"900","360");
}

//외부변호사 자문비용 팝업
function outerConsultantCostPop(lawfirmid, chckid, consultantid){
	var param = "?consultantid="+ consultantid +"&consultid="+$("#consultid").val()+"&chckid="+chckid+"&lawfirmid="+lawfirmid;
    popOpen($("#consultid").val(),"outerConsultantCostPop.do"+param,"720","520");
}

//만족도평가내역 보기/숨기기
var slToggle = 0;
function satisListToggle() {
	
	if (slToggle == 0) {
		slToggle = 1;
		$("#satisList").css("display", "block");
		$( "#btnSatisListView" ).text( "만족도평가내역  ▲" );
	} else {
		slToggle = 0;
		$("#satisList").css("display", "none");
		$( "#btnSatisListView" ).text( "만족도평가내역  ▼" );
	}
}

//자문비용 팝업
function consultantCostPop(){
	
	// 자문료 요청 / 지급 정보 확인
	if (<%=!chkCCost%> && <%=inoutcon.equals("O")%>) {
		alert("법무법인의 자문료 청구가 완료되지 않았습니다.");
		return;
	}
	var param = "?consultid="+$("#consultid").val();
    popOpen($("#consultid").val(),"consultantCostPop.do"+param,"700","590");
}
</script>

<form name="detailFrm" id="detailFrm" method="post">
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="consultid"   id="consultid" value="<%=consultid%>"/>
	<input type="hidden" name="inoutcon"   id="inoutcon" value="<%=inoutcon%>"/>

	
 	
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">자문 상세내용</strong>
		</div>
		<div class="subBtnC right" id="test">
<!-- <a href="#none" class="sBtn type1" onclick="javascript:hwpDownload();">자문요청서</a> -->		
		<% if ( statcd.equals( "작성중" ) ) { // 진행단계 : 작성중 %>
			<% if ( USERNO.equals( writerempno ) || GRPCD.indexOf("Y") > -1) { // 현재 사용자 == 작성자 %>
				<%if(inoutcon.equals("O")){ %>
				<a href="#none" class="sBtn type1" onclick="javascript:alert('전자결재');nextStepconsult('송무팀접수대기');">자문요청결재</a>
				<%}else{ %>
				<a href="#none" class="sBtn type1" onclick="javascript:nextStepconsult('송무팀접수대기');">송무팀검토요청</a>
				<%} %>
				<a href="#none" class="sBtn type4" onclick="javascript:goMakeGian('co1','자문요청서');">자문요청서 작성</a>
				<a href="#none" class="sBtn type1" onclick="javascript:gotowrite();">수정</a>
				<a href="#none" class="sBtn type1" onclick="javascript:removeConsult();">삭제</a>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( statcd.equals( "송무팀접수대기" ) ) { // 진행상태 : 송무팀접수대기 %>
			<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 현재 사용자 == 자문 담당자 %>
				<a href="#none" class="sBtn type1" onclick="javascript:selectLawyerPop();">접수</a>
				<a href="#none" class="sBtn type1" onclick="javascript:nextStepconsult('작성중');">반려</a>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( statcd.equals( "송무팀접수완료" ) ) { // 진행상태 : 송무팀접수완료 %>
			<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 현재 사용자 == 자문 담당자 %>
				<a href="#none" class="sBtn type1" onclick="javascript:selectLawyerPop();">법무법인변경</a>
				<a href="#none" class="sBtn type1" onclick="javascript:alert('전자결재여부');nextStepconsult('검토의견작성중');">법무법인선택완료</a>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( statcd.equals( "검토의견작성중") ) { // 진행상태 : 검토의견작성중 %>
			<% if ( "O".equals( inoutcon ) && ( GRPCD.indexOf( "L" ) > -1 || GRPCD.indexOf( "Y" ) > -1 ) ) { // 외부자문 && 현재 사용자 == 법무법인 or 관리자 %>
				<%
					if ( opinionlist.size() == 0 ) { // 등록된 검토의견 없을 시
				%>
					<a href="#none" class="sBtn type1" onclick="javascript:chckBoardPop();">검토의견등록(외부)</a>
				<%
					}
					else if ( opinionlist.size() != consultLawyerList.size() ) { // 등록된 검토의견 있으나, 모든 법무법인이 검토의견 등록하지 않았을 시
						boolean bool = true;
						for ( int i=0; i<opinionlist.size(); i++ ) {
							HashMap chck = (HashMap) opinionlist.get( i );
							if ( USERNO.equals( chck.get("WRITERID") ) && !( GRPCD.indexOf( "Y" ) > -1 ) ) { // 변호사ID(Writerno) == 검토의견 작성자ID && 현재 사용자 != 관리자
								bool = false;
							}
						}
						
						if ( bool ) {
				%>
						<a href="#none" class="sBtn type1" onclick="javascript:chckBoardPop();">검토의견등록(외부)</a>
				<%
						}
					}
				%>
			<% } %>
			
			<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 현재 사용자 == 자문 담당자 %>
				<% if ( "I".equals( inoutcon ) && opinionlist.size() == 0 ) { // 내부자문 && 등록된 검토의견 없을 시 %>
					<a href="#none" class="sBtn type1" onclick="javascript:chckBoardPop();">검토의견등록</a>
				<% } else if ( "O".equals( inoutcon ) && opinionlist.size() == 0 ) { // 외부자문 && 등록된 검토의견 없을 시 %>
					<a href="#none" class="sBtn type1" onclick="javascript:selectLawyerPop();">법무법인변경</a>
				<% } %>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( statcd.equals( "검토의견작성완료" ) ) { // 진행상태 : 검토의견작성완료 %>
			<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 현재 사용자 == 자문 담당자 %>
				<% if ( "I".equals( inoutcon ) && opinionlist.size() > 0 ) { // 내부자문 && 등록된 검토의견 존재 시 %>
					<a href="#none" class="sBtn type1" onclick="javascript:nextStepconsult('만족도평가필요');">의견회신</a>
				<% } else if ( "O".equals( inoutcon ) && opinionlist.size() == consultLawyerList.size() ) { // 외부자문 && 등록된 검토의견 == 자문법인 개수 %>
					<a href="#none" class="sBtn type1" onclick="javascript:nextStepconsult('만족도평가필요');">의견회신</a>
				<% } %>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( statcd.equals( "의견회신요청중" ) ) { // 진행상태 : 검토의견작성완료 %>
			<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 현재 사용자 == 자문 담당자 %>
					<a href="#none" class="sBtn type1" onclick="javascript:alert('부서장결재');nextStepconsult('만족도평가필요');">승인(임시)</a>
					<a href="#none" class="sBtn type1" onclick="javascript:alert('부서장결재');nextStepconsult('검토의견작성완료');">승인(반려)</a>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( statcd.equals( "만족도평가필요" ) ) { // 진행상태 : 만족도평가필요 %>
			<% if ( USERNO.equals( writerempno ) ) { // 현재 사용자 == 작성자 %>
				<a href="#none" class="sBtn type1" onclick="javascript:satisfactionPop('N');">만족도평가(부서)</a>
			<% } %>
			
			<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 현재 사용자 == 자문 담당자 %>
				<a href="#none" class="sBtn type1" onclick="javascript:satisfactionPop('L');">만족도평가(법무)</a>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( statcd.equals( "만족도평가완료" ) ) { // 진행상태 : 만족도평가완료 %>
			<% if ( USERNO.equals( writerempno ) ) { // 현재 사용자 == 작성자 %>
				<a href="#none" class="sBtn type1" onclick="javascript:consultantCostPop();">자문료지급정보</a>
			<% } %>
		<% } %>
<%-- ========== --%>
		<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 관리자 전용 버튼 %>
			<% if ( "O".equals( inoutcon ) && statcd.equals( "만족도평가완료" ) ) { // 외부자문일 시(기안문서 첨부할 수 있도록 수정권한 부여) && 진행상태 : 만족도평가완료 %>
				<a href="#none" class="sBtn type3" onclick="javascript:consultantCostAdminPop();">관리자 완료처리</a>
			<% } %>
		<% } %>
		<% if ( ( GRPCD.indexOf( "Y" ) > -1 || GRPCD.indexOf( "Y" ) > -1 ) && satisList.size() > 0 ) { // 현재 사용자 == 자문 담당자 or 관리자 && 만족도조사 리스트 존재 시 %>
			<a href="#none" class="sBtn type1" id="btnSatisListView" onclick="javascript:satisListToggle();">만족도평가내역  ▼</a>
		<% } %>
		
		<%
			// 전체 관리자 혹은 소송 담당자만 권한관리 버튼을 활성화 시킨다.
			if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1){
		%>
			<a href="#none" class="sBtn type1" onclick="consultRoleEdit();">권한관리</a>
		<%
			}
		%>	 				 
			<a href="#none"class="sBtn type5" id="listbtn">목록</a>
		 				 
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
				<th>의뢰부서</th>
				<td>
					<%=writerdeptnm %>
				</td>
				
				<th>의뢰인</th>
				<td>
					<div style="float: left;">
						<%=writer %>
					</div>
					<div style="float: right;">
						<% if ( GRPCD.indexOf( "Y" ) > -1 || USERNO.equals( writerempno ) ) { %><span style="cursor: hand;" onclick="selectEmpUsrInfo( 'writerInfoCallback' )">[인수인계]</span><% } %>
					</div>
				</td>
				
				<th>연락처</th>
				<td>
					<%=phone %>
				</td>
			</tr>
			<tr>
				<th>자문구분</th>
				<td>
					<%=reqcsttypecd %>
				</td>
				<th>자문유형</th>
				<td>
					<%="I".equals(inoutcon)?"내부검토":"외부자문" %>
				</td>
				<th>보안여부</th>
				<td>
					<%=openyn.equals("Y")?"공개":"비공개" %>
				</td>
			</tr>
			<tr>
				<th>자문번호</th>
				<td>
					<%=consultno %>
				</td>
				
				<th>담당자</th>
				<td>
					<div style="float: left;">
					<%=chrgempnm %>
					</div>
					<div style="float: right;">
					<% if ( ( GRPCD.indexOf( "Y" ) > -1 || USERNO.equals( chrgempno ) ) && ( chrgempno != null && !"".equals( chrgempno ) ) ) { %><span style="cursor: hand;" onclick="selectEmpUsrInfo( 'chrgempInfoCallback' )">[담당자 변경]</span><% } %>
					</div>
				</td>
				
				<th>자문법인</th>
				<td>
					<%
					String office[] = new String[5];
					for (int i=0; i<consultLawyerList.size();i++){
						HashMap consultLawyer = (HashMap)consultLawyerList.get(i);
						office[i] = consultLawyer.get("OFFICE")==null?"":consultLawyer.get("OFFICE").toString();
						String email = consultLawyer.get("EMAIL")==null?"":consultLawyer.get("EMAIL").toString();
						StringBuffer outPrint = new StringBuffer();
						outPrint.append("<div>").append(consultLawyer.get("OFFICE")==null?"":consultLawyer.get("OFFICE").toString());
						if (!email.equals("")) {
							outPrint.append("(").append(email).append(")");
						}
						outPrint.append("</div>");
	
						out.print(outPrint.toString());
						
					} %>
				</td>
			</tr>
			<tr>
				<th>의뢰일자</th>
				<td>
					<%= reqdt %>
				</td>
				
				<th>회신일자</th>
				<td>
					<span id="resultSenddt" style=""><div style="float: left;"><%=senddt %></div><!-- &nbsp;&nbsp;&nbsp;  -->
						<div style="float: right;"><%if( ( GRPCD.indexOf( "Y" ) > -1 || USERNO.equals( chrgempno ) ) && ( senddt != null && !"".equals( senddt ) )){ %><span onclick="editV()" style="cursor: hand;">[회신일자 조회]</span><%} %></div>
					</span>
					<span id="saveSenddt" style="display:none">
						<input type="text" id="senddt" value="<%=senddt %>" style="width:100"/>
						<span onclick="senddtSave()" style="cursor: hand;">[저장]</span>
					</span>
				</td>
				
				<th>진행상태</th>
				<%
					String statSatisNeed = "";
					HashMap para = new HashMap();
					para.put("consultid", consultid);
					if ( statcd.equals( Constants.Counsel.PRGS_STAT_LAW_REJT ) ) { // 진행상태 : 만족도평가필요
						statSatisNeed = consultService.getSatisNeedState( para );
					}
				%>
				<td>
					<%=statcd %>
					<% if ( ! "".equals( statSatisNeed ) && ( GRPCD.indexOf( "C" ) > -1 || GRPCD.indexOf( "Y" ) > -1 || USERNO.equals( writerempno ) ) ) { %>
						<br/>
						<span style="color: red;"><%= statSatisNeed %></span>
					<% } %>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="3">
					<%=title %>
				</td>
				<th>관련법령</th>
				<td>
					<%=basis %>
				</td>
			</tr>
			<tr>
				<th>송무팀 전달사항</th>
				<td colspan="5">
					<textarea id="aprvmemo" name="aprvmemo" readonly="readonly" rows="8" cols=""><%=aprvmemo %></textarea>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="5">
					<ul class="fileList">
	
	<%				
					if(fconsultlist != null & fconsultlist.size()>0){
	%>
						<% if ( fconsultlist.size() > 1 ) { %>
						<li style="padding-bottom: 10px;">
							<a href="#" onclick="downloadAllFiles()"><span style="color: blue; font-weight: bold;">첨부파일 전체 다운로드</span></a>
						</li>
						<% } %>
	<%
						for(int i=0; i<fconsultlist.size();i++){
							HashMap consultFile = (HashMap)fconsultlist.get(i);
	%>
						<li>
							<a href="#" onclick="downFile('<%=consultFile.get("VIEWFILENM") %>','<%=consultFile.get("SERVERFILENM") %>','CONSULT')"><%=consultFile.get("VIEWFILENM")%></a>
						</li>
	<%				
				}
			}
	%>		
					</ul>
				</td>
			</tr>
		</table>
	</div>
	<hr class="margin20">
	<% if ( ( GRPCD.indexOf( "C" ) > -1 || GRPCD.indexOf( "Y" ) > -1 ) && satisList.size() > 0 ) { %>
	<div id="satisList" style="display:none;">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">만족도평가정보</strong>
		</div>
	</div>
	<div class="innerB" >
		<table class="infoTable">
			<colgroup>
				<col style="width: 10%;">
				<col style="width: 40%;">
				<col style="width: 15%;">
				<col style="width: 10%;">
				<col style="width: 15%;">
				<col style="width: 10%;">
			</colgroup>
			<tr>
				<th>구분</th>
				<th>만족도평가 구분</th>
				<th>평가 결과</th>
				<th>평가 점수</th>
				<th>법무법인</th>
				<th>평가자</th>
			</tr>
			
			<%
				for ( int i=0; i<satisList.size(); i++ ) {
					HashMap satisInfo = (HashMap) satisList.get(i);
					if ( satisInfo.get( "satisfactionid" ) == null ) {
						continue;
					}
					
					int ansNum = Integer.parseInt( String.valueOf( satisInfo.get( "satislevel" ) ) ) / 5;
					if ( ansNum == 5 ) { ansNum = 1; }
					else if ( ansNum == 4 ) { ansNum = 2; }
					else if ( ansNum == 2 ) { ansNum = 4; }
					else if ( ansNum == 1 ) { ansNum = 5; }
					
					String lawfirmOfficeNm = "";
					for ( int j=0; j<consultLawyerList.size(); j++ ) {
						HashMap lawfirmInfo = (HashMap) consultLawyerList.get( j );
						String as1 = lawfirmInfo.get("LAWFIRMID")==null?"":lawfirmInfo.get("LAWFIRMID").toString();
						if ( as1.equals( String.valueOf( satisInfo.get( "lawfirmid" ) ) ) ) {
							lawfirmOfficeNm = lawfirmInfo.get("OFFICE")==null?"":lawfirmInfo.get("OFFICE").toString();
						}
					}
			%>
			<tr>
				<td style="text-align: center;"><%= satisInfo.get( "writercd" ) == null ? "":( "L".equals( String.valueOf( satisInfo.get( "writercd" ) ) ) ? "송무팀":"의뢰부서" ) %></td>
				<td style="text-align: left;"><%= satisInfo.get( "item" ) == null ? "":( satisInfo.get( "itemtype" ) + " : " + satisInfo.get( "item" ) ) %></td>
				<td style="text-align: left;"><%= satisInfo.get( "satislevel" ) == null ? "":satisInfo.get( "ans" + ansNum ) %></td>
				<td style="text-align: center;"><%= satisInfo.get( "satislevel" ) == null ? "":satisInfo.get( "satislevel" ) + " 점" %></td>
				<td style="text-align: left;"><%= satisInfo.get( "lawfirmid" ) == null ? "":lawfirmOfficeNm%></td>
				<td style="text-align: center;"><%= satisInfo.get( "writer" ) == null ? "":satisInfo.get( "writer" ) %></td>
			</tr>
			<%
				}
			%>
		</table>
	</div>
	</div>
	<%} %>
	<hr class="margin20">
	<%if(opinionlist.size()>0){ %>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">검토의견</strong>
		</div>
	</div>
	<div class="innerB" >
	 	<%
	 	System.out.println("opinionlist.size()===>"+opinionlist.size());
	 	for (int i=0; i<opinionlist.size(); i++){
	 		HashMap chck = (HashMap)opinionlist.get(i);
	 		if (!USERNO.equals(chck.get("WRITERID")) && GRPCD.indexOf("L")>-1){ //Empno : 변호사아이디
	 			continue;
	 		}
	 		
	 		lawfirmOffice[i] = chck.get("WRITER")==null?"":chck.get("WRITER").toString();
	 		List chckFileList = new ArrayList();
	 		
	 		HashMap map = new HashMap();
	 		map.put("consultid",consultid);
	 		map.put("chckid",chck.get("CHCKID"));
	 		map.put("gbnid",chck.get("CHCKID"));
	 		
	 		chckFileList = consultService.selectFileList(map);
	 		HashMap consultansFile = new HashMap();
	 	%>
	
				<table class="infoTable write">
					<colgroup>
						<col style="width:15%;">
						<col style="width:35%;">
						<col style="width:15%;">
						<col style="width:35%;">
					</colgroup>
					<tr>
						<% if ( "O".equals( inoutcon ) ) { %>
						<th>자문인</th>
						<td><%=chck.get("WRITER") %></td>
						<th>회신일자</th>
						<td><%=chck.get("WRITEDT") %></td>
						<%
	 						  }
							  else {
						%>
						<th>자문인</th>
						<td colspan="3"><%=chck.get("WRITER") %></td>
						<% } %>
					</tr>
					<tr>
						<th>주요의견</th>
						<td colspan="3">
							<textarea id="chckconts" name="chckconts" readonly="readonly" rows="8" cols=""><%=chck.get("CHCKCONTS") %></textarea>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td colspan="3">
							<ul class="fileList">
			<%
								if(chckFileList.size()>0 & chckFileList != null){
									for(int k=0;k<chckFileList.size();k++){
										consultansFile = (HashMap)chckFileList.get(k);
			%>
											<li><a href="#" onclick="downFile('<%=consultansFile.get("VIEWFILENM") %>','<%=consultansFile.get("SERVERFILENM") %>','CONSULT')"><%=consultansFile.get("VIEWFILENM")%></a></li>
			<%						
									}
								}
			%>				
							</ul>
						</td>
					</tr>
				</table>
				
				<%
				if (chck.get("CONSULTANTID") != null && chck.get("CONSULTANTID").toString().length() > 0){
					map.put("consultantid", chck.get("CONSULTANTID"));
					HashMap consultant = consultService.getConsultant2(map);
					
					String consultantcost = consultant.get("CONSULTANTCOST")==null?"":consultant.get("CONSULTANTCOST").toString(); 
					String bankname = consultant.get("BANKNAME")==null?"":consultant.get("BANKNAME").toString();
					String account = consultant.get("ACCOUNT")==null?"":consultant.get("ACCOUNT").toString();
					String accountowner = consultant.get("ACCOUNTOWNER")==null?"":consultant.get("ACCOUNTOWNER").toString();
					String korailcost = consultant.get("KORAILCOST")==null?"":consultant.get("KORAILCOST").toString();
					String answerdt = consultant.get("ANSWERDT")==null?"":consultant.get("ANSWERDT").toString();
					
					//=========================================================================================================================
					// consultantcost, korailcost 3자리마다 콤마 처리
					DecimalFormat df = new DecimalFormat("#,##0");
					consultantcost = consultantcost.equals("") ? "":df.format(Double.parseDouble(consultantcost));
					korailcost = korailcost.equals("") ? "":df.format(Double.parseDouble(korailcost));
					//=========================================================================================================================
							
					apprCost[i] = korailcost;
					apprBank[i] = bankname;
					apprAccount[i] = account;
					apprOwner[i] = accountowner;
					
					map.put("consultid",consultid);
			 		map.put("chckid",chck.get("CHCKID"));
			 		map.put("gbnid",chck.get("CONSULTANTID"));
			 		
			 		List consultantFileList = consultService.selectFileList(map);
				 %>
				<!-- 자문료  -->
				<table class="infoTable write">
					<colgroup>
						<col style="width:15%;">
						<col style="width:35%;">
						<col style="width:15%;">
						<col style="width:35%;">
					</colgroup>
					<tr>
						<th>자문료 청구액</th>
						<td colspan="3"><%=consultantcost %></td>
					</tr>
					<tr>
						<th>자문료 지급액</th>
						<td><%=korailcost %></td>
						<th>지급결재일</th>
						<td><%=answerdt %></td>					
					</tr>
					<tr>
						<th>은행명</th>
						<td><%=bankname %></td>
						<th>계좌번호</th>
						<td><%=account %></td>
					</tr>
					<tr>
						<th>예금주</th>
						<td><%=accountowner %></td>
						<th>첨부파일</th>
						<td>
							<ul class="fileList">
			<%
								if(consultantFileList.size()>0 & consultantFileList != null){
									for(int k=0;k<consultantFileList.size();k++){
										consultansFile = (HashMap)consultantFileList.get(k);
			%>
											<li><a href="#" onclick="downFile('<%=consultansFile.get("VIEWFILENM") %>','<%=consultansFile.get("SERVERFILENM") %>'),'CONSULT'"><%=consultansFile.get("VIEWFILENM")%></a></li>
			<%						
									}
								}
			%>				
							</ul>
						</td>
					</tr>
				</table>
				<%} %>			
				<hr class="margin10">
				<div style="text-align:right;">
					<% if ( "O".equals( inoutcon ) ) { // 외부자문 %>
						<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 법무법인 %>
							<% if ( statcd.equals( "검토의견작성중" ) || statcd.equals( "검토의견작성완료" ) ) { // 진행상태 : 검토의견작성중 or 검토의견작성완료 %>
								<a href="#none" class="sBtn type1" onclick="javascript:outerConsultantCostPop('<%=chck.get("WRITERID") %>','<%=chck.get("CHCKID") %>','<%=chck.get("CONSULTANTID")==null?"":chck.get("CONSULTANTID") %>');">자문료 청구</a>
								<a href="#none" class="sBtn type1" onclick="javascript:chckBoardPop('<%=chck.get("CHCKID") %>');">검토의견 수정</a>
							<% } %>
							
							<% if ( statcd.equals("만족도평가필요")	|| statcd.equals("만족도평가완료") || statcd.equals("의견회신요청중") ) { // 진행상태 : 만족도평가필요 or 만족도평가완료 or 의견회신요청중 %>
								<a href="#none" class="sBtn type1" onclick="javascript:outerConsultantCostPop('<%=chck.get("WRITERID") %>','<%=chck.get("CHCKID") %>','<%=chck.get("CONSULTANTID")==null?"":chck.get("CONSULTANTID") %>');">자문료 청구</a>
							<% } %>
							<a href="#none" class="sBtn type1" onClick="btnAnsDel_onClick('<%=chck.get("CHCKID") %>')">검토의견 삭제</a>
						<% } %>
					<% } else { %>
						<% if ( GRPCD.indexOf( "Y" ) > -1 ) { // 현재 사용자 == 자문 담당자 %>
							<% if ( statcd.equals( "검토의견작성중" ) || statcd.equals( "검토의견작성완료" ) ) { // 진행상태 : 검토의견작성중 or 검토의견작성완료 %>
								<a href="#none" class="sBtn type1" onclick="javascript:chckBoardPop('<%=chck.get("CHCKID") %>');">검토의견 수정</a>
								<a href="#none" class="sBtn type1" onClick="btnAnsDel_onClick('<%=chck.get("CHCKID") %>')">검토의견 삭제</a>
							<% } %>
						<% } %>
					<% } %>
				</div>
				<hr class="margin10">
	 	<%} %>
	</div>
	<%} %> 
</div>
</form>
