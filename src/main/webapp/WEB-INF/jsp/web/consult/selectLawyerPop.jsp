<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String inoutcon = request.getParameter("inoutcon")==null?"":request.getParameter("inoutcon");
	String consultid = request.getParameter("consultid")==null?"":request.getParameter("consultid");
	String office = request.getParameter("office")==null?"":request.getParameter("office");
	int pagesize = 10;
	int pageno = ServletRequestUtils.getIntParameter(request, "pageno", 1);
	
	List consultLawyerList = request.getAttribute("consultLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("consultLawyerList");
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
<script type="text/javascript">
function sendInoutcon(inoutcon){
	var frm = document.lawSch;
	frm.inoutcon.value = inoutcon;
	/* if (inoutcon == 'I'){
		if(confirm("내부검토가 선택되었습니다. 저장된 법무법인 정보는 모두 삭제됩니다.")){
			
		}else{
			
			return;
		}
	}else{
		alert('외부자문이 선택되었습니다. 법무법인을 선택해 주세요.');
	}
	 */
	sendInoutcon4Ajax(inoutcon);
}

function sendInoutcon4Ajax(inoutcon){
	var MENU_MNG_NO = '';
	if(inoutcon=='I'){
		MENU_MNG_NO = '<%=Constants.Counsel.INOUT_I_MENUID%>';
	}else if(inoutcon=='O'){
		MENU_MNG_NO = '<%=Constants.Counsel.INOUT_O_MENUID%>';
	}else if(inoutcon=='E'){
		MENU_MNG_NO = '<%=Constants.Counsel.INOUT_E_MENUID%>';
	}
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/web/consult/sendInoutcon4Ajax.do",
		data : {
			inoutcon : inoutcon,
			MENU_MNG_NO : MENU_MNG_NO,
			consultid : $("#consultid").val()
		},
		datatype: "json",
		error: function(){},
		success:function(data){
			data = Ext.util.JSON.decode(data);
			opener.gotoview();
			window.focus();
			gotolist();
		},
		error:function(request,status,error){
			alert("오류발생");
		}
	});
}

function insetConsultLawyer4Ajax(lawyerid, lawyernm){
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/web/consult/insetConsultLawyer4Ajax.do",
		data : {
			lawyerid:lawyerid,
			lawyernm:lawyernm,
			consultid:$("#consultid").val()
		},
		datatype: "json",
		error: function(){},
		success:function(data){
			data = Ext.util.JSON.decode(data);
			 gotolist();
		},
		error:function(request,status,error){
			alert("오류발생");
		}
	});
}

function deleteConsultLawyer4Ajax(lawyerid){
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/web/consult/deleteConsultLawyer4Ajax.do",
		data : {
			consultlawyerid : lawyerid
		},
		datatype: "json",
		error: function(){},
		success:function(data){
			data = Ext.util.JSON.decode(data);
			 gotolist();
		},
		error:function(request,status,error){
			alert("오류발생");
		}
	});
}

function jubsu(){
	var frm = document.lawSch;
	if (frm.inoutcon.value == 'I'){
		jubsu4Ajax();
	}else if(frm.inoutcon.value == 'O'){
		if(<%=consultLawyerList.size()%> == 0){
			//alert('법무법인를 선택해주세요.');
			jubsu4Ajax();
		}else{
			jubsu4Ajax();
		}
	}else if (frm.inoutcon.value == 'E'){
		jubsu4Ajax2();
	}else{
		alert('자문구분을 선택해주세요.');
	}
}

function jubsu4Ajax(){
	var inoutcon = $("#inoutcon").val();
	var MENU_MNG_NO = '';
	if(inoutcon=='I'){
		MENU_MNG_NO = '100000131';
	}else if(inoutcon=='O'){
		MENU_MNG_NO = '10118690';
	}else if(inoutcon=='E'){
		MENU_MNG_NO = '10118691';
	}
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/web/consult/jubsu4Ajax.do",
		data : {
			consultid : $("#consultid").val(),
			inoutcon : $("#inoutcon").val(),
			MENU_MNG_NO : MENU_MNG_NO
			//chrgempno : $("#chrgempno").val(),
			//chrgempnm : $("#chrgempnm").val()
		},
		datatype: "json",
		error: function(){},
		success:function(data){
			data = Ext.util.JSON.decode(data);
			opener.gotoview();
			window.close();
		},
		error:function(request,status,error){
			alert("오류발생");
		}
	});	
}
function jubsu4Ajax2(){
	var inoutcon = $("#inoutcon").val();
	var MENU_MNG_NO = '';
	if(inoutcon=='I'){
		MENU_MNG_NO = '100000131';
	}else if(inoutcon=='O'){
		MENU_MNG_NO = '10118690';
	}else if(inoutcon=='E'){
		MENU_MNG_NO = '10118691';
	}
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/web/consult/jubsu4Ajax.do",
		data : {
			consultid : $("#consultid").val(),
			inoutcon : $("#inoutcon").val(),
			MENU_MNG_NO : MENU_MNG_NO,
			chrgempno : $("#chrgempno").val(),
			chrgempnm : $("#chrgempnm").val(),
			chrgregdt : 'today'
		},
		datatype: "json",
		error: function(){},
		success:function(data){
			data = Ext.util.JSON.decode(data);
			opener.gotoview();
			window.close();
		},
		error:function(request,status,error){
			alert("오류발생");
		}
	});
}
function gotolist(){
	var frm = document.lawSch;
	frm.pageno.value="1";
	if(frm.inoutcon.value == 'I'){
		frm.lawyergbn.value = '내부';
	}else{
		frm.lawyergbn.value = '고문';
	}
	frm.action = "selectLawyerPop.do";
	frm.submit();
}
function saveOffice(){
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/web/consult/saveOffice.do",
		data : {
			officename : $("#officename").val(),
			consultid : $("#consultid").val()
		},
		datatype: "json",
		error: function(){},
		success:function(data){
			data = Ext.util.JSON.decode(data);
			 gotolist();
		},
		error:function(request,status,error){
			alert("오류발생");
		}
	});
}
</script>
<style>
	#srchTxt1{width:90%; height:30px; line-height:0px; margin-top:3px;}
	#srchTxt2{width:90%; height:30px; line-height:0px; margin-top:3px;}
	.popW{height:100%}
	#hidden{display:none;}
	.selTd{cursor:pointer;}
</style>
<form name="lawSch" id="lawSch" method="post" action="selectLawyerPop.do">
	<input type="hidden" name="pageno" value="<%=pageno%>"/>
	<input type="hidden" name="lawyerid"/>
	<input type="hidden" name="lawyernm"/>
	<input type="hidden" name="lawyergbn"/>
	<input type="hidden" name="consultid" id="consultid" value="<%=consultid%>"/>	
	<input type="hidden" name="consultlawyerid"/>	
	<input type="hidden" name="chrgempno" id="chrgempno" value="<%=USERNO%>"/>
	<input type="hidden" name="chrgempnm" id="chrgempnm" value="<%=USERNAME%>"/>	
	<input type="hidden" name="inoutcon" id="inoutcon" value="<%=inoutcon%>"/>	
<strong class="popTT">
	법무법인 지정
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div style="height:74%">
	<div class="popC">
		<div class="popSrchW">
			<input type="text" id="office" name="office" value="<%=office %>" style="width:720px;" placeholder="검색 할 법인명을 입력해주세요">
			<a href="#none" class="sBtn type1" onclick="javascript:gotolist();">검색</a>
			<a href="#none" class="sBtn type3" onclick="javascript:jubsu();">접수완료</a>
		</div>
		<div class="popA" style="max-height:900px;">
			<div class="tableW">
				<table class="infoTable pop" style="border-top:2px solid #000;">
					<colgroup>
						<col style="width:20%;">
						<col style="width:70%;">				
					</colgroup>	
					<tr>
						<th style="background:#f3f6f7;text-align:center;color:#000;">자문구분</th>
						<td align="center">
							<input type="radio" name="inoutconTmp" value="I" <%if ("I".equals(inoutcon)){out.print("checked");} %> onclick="sendInoutcon(this.value);"/> 내부검토 &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="inoutconTmp" value="O" <%if ("O".equals(inoutcon)){out.print("checked");} %> onclick="sendInoutcon(this.value);"/> 외부자문&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="inoutconTmp" value="E" <%if ("E".equals(inoutcon)){out.print("checked");} %> onclick="sendInoutcon(this.value);"/> 전문분야외부자문
						</td>
					</tr>	
					<tr>
						<th style="background:#f3f6f7;text-align:center;color:#000;">자문법인</th>
						<td>
							<ul>
							<%for (int i=0; i<consultLawyerList.size();i++){ 
								HashMap consult = (HashMap)consultLawyerList.get(i);
								
								StringBuffer outPrint = new StringBuffer();
								outPrint.append("<li>").append(consult.get("OFFICE"));
								if (consult.get("EMAIL") != null) {
									outPrint.append("(").append(consult.get("EMAIL")).append(")");
								}
								outPrint.append("&nbsp;<img src=\""+request.getContextPath()+"/resources/images/common/button/but-delfile-small.gif\" onclick=\"javascript:deleteConsultLawyer4Ajax('");
								outPrint.append(consult.get("CONSULTLAWYERID")).append("');\"/></li>&nbsp;&nbsp;&nbsp;");

								out.print(outPrint.toString());
							} %>
							</ul>
							<%if(inoutcon.equals("E") && consultLawyerList.size()==0){ %>
							<input type="text" name="officename" id="officename" style="width:70%" placeholder="법인명"><a href="#none" class="sBtn type1" onclick="javascript:saveOffice();">법인저장</a>
							<%} %>
						</td>
					</tr>
				</table>
			</div>
			<div style="height:15px;"></div>
			<div class="tableW">
				<table class="infoTable pop" style="border-top:2px solid #000;">
					<colgroup>
						<col style="width:10%;">
						<col style="width:20%;">
						<col style="width:20%;">	
						<col style="width:20%;">
						<col style="width:30%;">			
					</colgroup>	
					<tr style="background:#f3f6f7;text-align:center;color:#000;">
						<th style="background:#f3f6f7;text-align:center;color:#000;">번호</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">법무법인명</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">담당자</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">전화번호</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">이메일</th>
					</tr>	
					<%
						if(lawyerList != null & lawyerList.size()>0){
							for(int i=0;i<lawyerList.size();i++){
								HashMap lawyer = (HashMap)lawyerList.get(i);
								boolean p = false;
								for (int j=0; j<consultLawyerList.size();j++){ 
									HashMap consult = (HashMap)consultLawyerList.get(j);
									if (lawyer.get("LAWFIRMID").equals(consult.get("lawfirmid"))){
										p = true;
										break;
									}
								}
								if (p){
									%>
									<tr style="cursor:pointer;" onclick="alert('이미 선택한 법인입니다.');">
										<td style="text-align:center;"><%=tot - i -(pageno-1)*pagesize %></td>	
										<td style="text-align:center;"><%=lawyer.get("OFFICE")==null?"&nbsp":lawyer.get("OFFICE") %></td>
										<td style="text-align:center;"><%=lawyer.get("LAWYERNAME")==null?"&nbsp":lawyer.get("LAWYERNAME") %></td>
										<td style="text-align:center;"><%=lawyer.get("PHONE")==null?"&nbsp":lawyer.get("PHONE") %></td>
										<td style="text-align:center;"><%=lawyer.get("EMAIL")==null?"&nbsp":lawyer.get("EMAIL") %></td>	
									</tr>
						<%
								}else{
							
					%>
								<tr style="cursor:pointer;" onclick="insetConsultLawyer4Ajax('<%=lawyer.get("LAWYERID")%>','<%=lawyer.get("LAWYERNAME")%>')">
									<td style="text-align:center;"><%=tot - i -(pageno-1)*pagesize %></td>	
									<td style="text-align:center;"><%=lawyer.get("OFFICE")==null?"&nbsp":lawyer.get("OFFICE") %></td>
									<td style="text-align:center;"><%=lawyer.get("LAWYERNAME")==null?"&nbsp":lawyer.get("LAWYERNAME") %></td>
									<td style="text-align:center;"><%=lawyer.get("PHONE")==null?"&nbsp":lawyer.get("PHONE") %></td>
									<td style="text-align:center;"><%=lawyer.get("EMAIL")==null?"&nbsp":lawyer.get("EMAIL") %></td>	
								</tr>
					<%
								}
							}
						}else{
					%>
							<tr align="center">
					    		<td colspan="10">검색결과가 존재하지 않습니다.</td>
							</tr>
					<%		
						}
					
					%>
				</table>
				<br/>
				<!-- 페이지 네비게이터-->
				<table id="pageNavi" align="center" width="98%" cellpadding="0" cellspacing="0">
					<tr>
						<td align="center">
							<div>
								<script type="text/javascript">
								document.write(pageNav( "gotoPage", <%=pageno%>, <%=pagesize%>, <%=tot%> ));
								</script>
							</div>			
						</td>
					</tr>
					
				</table>
			</div>
		</div>
	</div>
</div>
</form>