<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018-12-30
  Time: 오후 5:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.web.service.*" %>
<%@ page import="java.util.*" %>
<%
	WebService service = WebServiceHelper.getWebService(application);
	List mlist = service.getTopMenu(request);
	Map<String,String> param = request.getAttribute("param")==null?new HashMap():(Map)request.getAttribute("param");
	String MENU_MNG_NO = param.get("MENU_MNG_NO")==null?"":param.get("MENU_MNG_NO");
	String MENU_SE_NM = param.get("MENU_SE_NM")==null?"":param.get("MENU_SE_NM");
	String pQuery_tmp = request.getParameter("pQuery_tmp")==null?"":request.getParameter("pQuery_tmp");
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String DEPTNAME = se.get("DEPTNAME")==null?"":se.get("DEPTNAME").toString();
	
	
	System.out.println("::::::::::::::::::::: ");
	System.out.println(se);
	//List appList = service.getApproveList(request);
%>
<style>
	.topBtnW .topBtn {
		display: inline-block;
		height: 40px;
		color: #fff;
		border-radius: 20px;
		overflow: hidden;
		font-size: 15px;
		padding: 0 15px;
		line-height: 40px;
		margin-left: 4px;
	}
	
	#admin:hover{
		cursor:pointer;
	}
	
	.selDoc:hover{cursor:pointer;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$("#schTxtTop").keypress(function(e) { 
			if (e.keyCode == 13){
				goSch();
			}
		});
		
		$("#schBtn").click(function(e) {
			goSch();
		});
		
		$('#admin').click(function(e) {
			e.stopPropagation(); 
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/web/statistics/setMenuLog.do",
				data : {"MENU_MNG_NO":"10000014"},
				datatype: "json",
				error: function(){},
				success:function(data){}
			});
			$('#MENU_MNG_NO').val("10000014");
			$('#MENU_SE_NM').val("ADMIN");
			
			var frm = document.pageT;
			frm.target="";
			frm.action="${pageContext.request.contextPath}/bylaw/user/userMn.do";
			frm.submit();
		});
		
		$('.gnb li').click(function(e) {
			e.stopPropagation(); 
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/web/statistics/setMenuLog.do",
				data : {"MENU_MNG_NO":this.id},
				datatype: "json",
				error: function(){},
				success:function(data){}
			});
			$('#MENU_MNG_NO').val(this.id);
			$('#MENU_SE_NM').val($(this).attr("vo1"));
			$('#addParam1').val('');
			$('#addParam2').val('');
			$('#searchForm').val('');
			$('#addParam3').val('');
			var frm = document.pageT;
			frm.target="";
			frm.action="${pageContext.request.contextPath}"+$(this).attr("vo");
			frm.submit();
		});
		
		$(".logoW").click(function(){
			location.href="${pageContext.request.contextPath}/web/index.do";
		});
		
		
		$("#txSimpleSearch1").keypress(function(e) { 
		    if (e.keyCode == 13){
		    	goSch();
		    }    
		});
		
		$('.sitemapC li').click(function(e) {
			e.stopPropagation(); 
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/web/statistics/setMenuLog.do",
				data : {"MENU_MNG_NO":this.id},
				datatype: "json",
				error: function(){},
				success:function(data){}
			});
			$('#MENU_MNG_NO').val(this.id);
			$('#MENU_SE_NM').val($(this).attr("vo1"));
			$('#SUB_MENU_MNG_NO').val($(this).attr("vo2"));
			var frm = document.pageT;
			frm.target="";
			frm.action="${pageContext.request.contextPath}"+$(this).attr("vo");
			frm.submit();
		});
		
		$(".lbDate").click(function(e){
			e.stopPropagation(); 
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/web/statistics/setMenuLog.do",
				data : {"MENUID":'100003228'},
				datatype: "json",
				error: function(){},
				success:function(data){}
			});
			$('#MENU_MNG_NO').val('100003228');
			$('#MENU_SE_NM').val('CAL');
			$('#SUB_MENU_MNG_NO').val('0');
			$('#addParam1').val($(this).attr("vo4"));
			$('#addParam2').val($(this).attr("vo5"));
			$('#searchForm').val("docGbn|"+$(this).attr("vo6")+",dateGbn|"+$(this).attr("vo7"));
			
			var frm = document.pageT;
			frm.target="";
			frm.action="${pageContext.request.contextPath}/web/suit/fullcalendarMain.do";
			frm.submit();
		});
	});
	
	function goMainEdit(MENU_MNG_NO,MENU_SE_NM){
		$('#MENU_MNG_NO').val(MENU_MNG_NO);
		$('#MENU_SE_NM').val(MENU_SE_NM);
		var frm = document.pageT;
		frm.target="";
		frm.action="${pageContext.request.contextPath}/web/pds/goPdsMain.do";
		frm.submit();
	}
	
	function goSch(){
		if($("#schTxtTop").val()!=''){
			var frm = document.MainSch;
			frm.pQuery_tmp.value = $("#schTxtTop").val();
			frm.action="${pageContext.request.contextPath}/web/search.do";
			frm.submit();
		}else{
			alert('검색어를 입력해주시기 바랍니다.');
		}
	}
	
	function menual(){
		window.open("${pageContext.request.contextPath}/dataFile/totalManual.pdf", "approval", "scrollbar=yes,width=1200,height=800,resizable=yes");
	}
	
	function setTopBtnLog(id){
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/statistics/setMenuLog.do",
			data : {"MENU_MNG_NO":id},
			datatype: "json",
			error: function(){},
			success:function(data){}
		});
	}
	
	function goDoc(pk, gbn1, gbn2) {
		var url = "";
		if (gbn2 == "CONSULT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","cInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "cInfo");
			newForm.attr("action", "${pageContext.request.contextPath}/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:pk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn2 == "AGREE") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","aInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "aInfo");
			newForm.attr("action", "${pageContext.request.contextPath}/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:pk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
</script>
<!-- JavaScript -->
<script>
$(document).ready(function() {
    // 알림 아이콘 클릭 시 모달 열기
    $('.ph-bell').click(function() {
      $('#notification-modal').fadeIn();
    });

    // 모달 닫기 버튼 클릭 시 모달 닫기
    $('#close-modal').click(function() {
      $('#notification-modal').fadeOut();
    });

    // 모달 외부 클릭 시 모달 닫기
    $(window).click(function(e) {
      if ($(e.target).is('#notification-modal')) {
        $('#notification-modal').fadeOut();
      }
    });
    
    $('#navV').click(function() {
        $('.sitemapW').fadeIn();
        $('.sitemapW').css("display","flex");
    });
    
    $('.ph-x').click(function() {
        $('.sitemapW').fadeOut();
    });
    
	$('.quick_linkW .ql').click(function(e) {
		e.stopPropagation(); 
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/web/statistics/setMenuLog.do",
				data : {"MENU_MNG_NO":$(this).attr("vo")},
				datatype: "json",
				error: function(){},
				success:function(data){}
			});
			$('#MENU_MNG_NO').val($(this).attr("vo"));
			$('#MENU_SE_NM').val($(this).attr("vo1"));
			$('#SUB_MENU_MNG_NO').val($(this).attr("vo2"));
			$('#addParam1').val($(this).attr("vo4"));
			$('#addParam2').val($(this).attr("vo5"));
			$('#searchForm').val("IMPT_LWS_YN|"+$(this).attr("vo6")+",INCDNT_SE_CD|"+$(this).attr("vo7"));
			var frm = document.pageT;
			frm.target="";
			frm.action="${pageContext.request.contextPath}"+$(this).attr("vo3");
			frm.submit();
	});
    
	$('.countC_inner .cnt_link').click(function(e) {
		e.stopPropagation(); 
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/web/statistics/setMenuLog.do",
				data : {"MENU_MNG_NO":$(this).attr("vo")},
				datatype: "json",
				error: function(){},
				success:function(data){}
			});
			$('#MENU_MNG_NO').val($(this).attr("vo"));
			$('#MENU_SE_NM').val($(this).attr("vo1"));
			$('#SUB_MENU_MNG_NO').val($(this).attr("vo2"));
			$('#addParam1').val($(this).attr("vo4"));
			$('#addParam2').val($(this).attr("vo5"));
			var searchFormVal = "IMPT_LWS_YN|"+$(this).attr("vo6")+",INCDNT_SE_CD|"+$(this).attr("vo7");
			if ($(this).attr("vo1") == 'COUNSEL') {
				searchFormVal += ",prgrs_stts_se_nm|"+$(this).attr("vo8");
			}else if ($(this).attr("vo1") == 'AGREE') {
				searchFormVal += ",PRGRS_STTS_SE_NM|"+$(this).attr("vo8");
			}
// 			$('#searchForm').val("IMPT_LWS_YN|"+$(this).attr("vo6")+",INCDNT_SE_CD|"+$(this).attr("vo7")); // +",prgrs_stts_se_nm|"+$(this).attr("vo8"));
			$('#searchForm').val(searchFormVal);
// 			$('#addParam3').val($(this).attr("vo8"));
			var frm = document.pageT;
			frm.target="";
			frm.action="${pageContext.request.contextPath}"+$(this).attr("vo3");
			frm.submit();
	});
    
  });
</script>
<form method="post" name="MainSch" style="margin:0">
	<input type="hidden" name="pQuery_tmp" id="pQuery_tmp" value="<%=pQuery_tmp%>"/>
</form>
<form method="post" name="pageT" style="margin:0">
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO"/>
	<input type="hidden" name="SUB_MENU_MNG_NO" id="SUB_MENU_MNG_NO"/>
	<input type="hidden" name="MENU_SE_NM" id="MENU_SE_NM"/>
	<input type="hidden" name="mtype" id="mtype"/>
	<input type="hidden" name="gbnid" id="gbnid"/>
	<input type="hidden" name="addParam1" id="addParam1"/>
	<input type="hidden" name="addParam2" id="addParam2"/>
	<input type="hidden" name="searchForm" id="searchForm"/>
	<input type="hidden" name="addParam3" id="addParam3"/>
</form>
<div class="modal" id="notification-modal">
	<div class="modal-content">
		<span class="close-btn" id="close-modal">&times;</span>
		<h2 style="margin-bottom:15px;">결재 대기중 목록</h2>
		<div class="innerB" >
			<table class="infoTable" style="font-size: 14px;">
				<tr>
					<th>결재문서</th>
					<th>결재요청일</th>
				</tr>
	<%
		//if(appList.size() > 0) {
		//	for(int i=0; i<appList.size(); i++) {
		//		HashMap appMap = (HashMap)appList.get(i);
		//		
		//		String ATRZ_DMND_PST_MNG_NO = appMap.get("ATRZ_DMND_PST_MNG_NO")==null?"":appMap.get("ATRZ_DMND_PST_MNG_NO").toString();
		//		String DOC_GBN = appMap.get("DOC_GBN")==null?"":appMap.get("DOC_GBN").toString();
		//		String ATRZ_SE_NM = appMap.get("ATRZ_SE_NM")==null?"":appMap.get("ATRZ_SE_NM").toString();
				
	%>
	<%-- 
				<tr class="selDoc" onclick="goDoc('<%=ATRZ_DMND_PST_MNG_NO%>','<%=DOC_GBN%>','<%=ATRZ_SE_NM%>')">
					<td><%=appMap.get("DOC_NM")==null?"":appMap.get("DOC_NM").toString()%></td>
					<td><%=appMap.get("ATRZ_DMND_DT")==null?"":appMap.get("ATRZ_DMND_DT").toString()%></td>
				</tr>
	--%>
	<%
		//	}
		//} else {
	%>
				<tr>
					<td colspan="2">결재 대기중인 문서가 없습니다.</td>
				</tr>
	<%
		//}
	%>
			</table>
		</div>
	</div>
</div>
<header id="topW">
	<div class="innerW">
		<div class="logoW">
			<h1 class="logo">서울특별시 법률지원통합시스템</h1>
		</div>
		<div class="infoW">
			<div class="srchW">
				<select>
					<option>전체</option>
				</select>
				<input type="text" placeholder="검색어를 입력해주세요." id="schTxtTop" value="<%=pQuery_tmp%>"/>
				<button type="submit" id="schBtn"><i class="ph-bold ph-magnifying-glass"></i></button>
			</div>
			<div class="infoC user" style="width:35%"><span><i class="ph-bold ph-user"></i></span> [<%=DEPTNAME%>] <%=USERNAME%>님</div>
			<%-- 
			<div class="infoC date">
				<span class="box"><i class="ph-bold ph-bell"></i></span>
				<span class="notification-badge" style="position: absolute; top: -5px; background-color: red; color: white; font-size: 10px;
					font-weight: bold; padding: 2px 5px; border-radius: 999px; line-height: 1; min-width: 18px; text-align: center; width:17px; height:17px;"><%=appList.size()%></span>
			</div>
			 --%>
			<div class="infoC date" style="width:5%" id="navV"><span class="box"><i class="ph-bold ph-list"></i></span></div>
			<%
				if(GRPCD.indexOf("Y") > -1) {
			%>
			<div class="infoC user" style="width:5%" id="admin"><span class="box"><i class="ph-bold ph-gear"></i></span></div>
			<%
				}
			%>
		</div>
	</div>
	<div class="innerW">
		<nav class="main-nav">
			<ul class="gnb">
				<%
					for(int i=0; i<mlist.size(); i++){
						HashMap mresult = (HashMap)mlist.get(i);
						String lvl = mresult.get("LVL")==null?"":mresult.get("LVL").toString();
						String css = "";
						if(MENU_MNG_NO.equals(mresult.get("MENU_MNG_NO").toString())){
							css = "class='action'";
						}
						if(lvl.equals("1")){
				%>
					<li  <%=css %> id="<%=mresult.get("MENU_MNG_NO") %>" vo="<%=mresult.get("URL_INFO_CN") %>" vo1="<%=mresult.get("MENU_SE_NM") %>">
						<a href="#" title="<%=mresult.get("MENU_TTL") %>"><span><i class="<%=mresult.get("MENU_IMG_NM") %>"></i></span><%=mresult.get("MENU_TTL") %></a>
					</li>
				<%
						}
					}
				%>
			</ul>
		</nav>
		<div class="sitemapW">
			<div class="sm_closeW"><a href="#none"><i class="ph-bold ph-x"></i></a></div>
			<%
				for(int i=0; i<mlist.size(); i++){
					HashMap mresult = (HashMap)mlist.get(i);
					String lvl = mresult.get("LVL")==null?"":mresult.get("LVL").toString();
					String RMENU_MNG_NO = mresult.get("MENU_MNG_NO")==null?"":mresult.get("MENU_MNG_NO").toString();
					if(lvl.equals("1")){
			%>
			<div class="sitemapC">
				<ul>
			<%
						for(int k=0; k<mlist.size(); k++){
							HashMap sresult = (HashMap)mlist.get(k);
							String TOPMENUID = sresult.get("TOPMENUID")==null?"":sresult.get("TOPMENUID").toString();
							String slvl = sresult.get("LVL")==null?"":sresult.get("LVL").toString();
							if(RMENU_MNG_NO.equals(TOPMENUID) && !slvl.equals("1")){
			%>
					<li  id="<%=mresult.get("MENU_MNG_NO") %>" vo="<%=mresult.get("URL_INFO_CN") %>" vo1="<%=mresult.get("MENU_SE_NM") %>" vo2="<%=sresult.get("MENU_MNG_NO") %>" vo3="<%=sresult.get("URL_INFO_CN") %>">
						<a href="#" title="<%=sresult.get("MENU_TTL") %>"><span><i class="<%=sresult.get("MENU_IMG_NM") %>"></i></span><%=sresult.get("MENU_TTL") %></a>
					</li>
			<%
							}
						}
			%>
				</ul>
			</div>
			<%
					}
				}
			%>
		</div>
	
	</div>
</header>
