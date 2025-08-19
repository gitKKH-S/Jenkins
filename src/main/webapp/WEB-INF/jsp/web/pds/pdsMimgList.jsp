<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mten.util.*" %>
<%
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	List mlist = request.getAttribute("mlist")==null?new ArrayList():(ArrayList)request.getAttribute("mlist");
	int listSize = mlist.size();
%>
<script type="text/javascript">
	function del(PST_MNG_NO) {
		$.ajax({
            type:"POST",
            url : "${pageContext.request.contextPath}/web/pds/pdsDelajax.do",
            data : {
            	PST_MNG_NO : PST_MNG_NO
            },
            dataType: "json",
            async: false,
            success : function(result){
           		location.href = '${pageContext.request.contextPath}/web/pds/pdsMimgList.do?MENU_MNG_NO=<%=MENU_MNG_NO%>&Menucd=MAIN';		
            }
        })	
	}
	$(document).ready(function(){
		$("#sBtn").click(function(){
			var frm = document.wform;
			frm.submit();
		});
	});
</script>
<form name="wform" method="post" action="${pageContext.request.contextPath}/web/pds/pdsMimgWrite.do">
	<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>">
</form>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong><font style="color:red;font-size:10pt;">&nbsp;&nbsp;&nbsp;(※ 이미지 사이즈는 1565×400 기준입니다.)</font>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT"></strong>
		</div>
		<div class="subBtnC right">
			<a href="#" id="sBtn" class="sBtn type1">등록</a>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList">
			<div class="tableW">
				<table class="infoTable">
					<colgroup>
						<col style="width: 33%;">
						<col style="width: 33%;">
						<col style="width: 33%;">
					</colgroup>
					
					<% 
						for ( int i=0; i<listSize; i=i+3 ) { 
							HashMap result = (HashMap)mlist.get(i);
					%>
					<tr>
						<td style="text-align:center;">
							<img src='<%=CONTEXTPATH+"/dataFile/mimg/"+result.get("SRVR_FILE_NM")%>' width="90%;" />
						</td>
						<td style="text-align:center;">
							<% 
								if ( i+1 < listSize ) { 
									result = (HashMap)mlist.get(i+1);
							%>
							<img src='<%=CONTEXTPATH+"/dataFile/mimg/"+result.get("SRVR_FILE_NM")%>' width="90%;" />
							<% } %>
						</td>
						<td style="text-align:center;">
							<% 
								if ( i+2 < listSize ) { 
									result = (HashMap)mlist.get(i+2);	
							%>
							<img src='<%=CONTEXTPATH+"/dataFile/mimg/"+result.get("SRVR_FILE_NM")%>' width="90%;" />
							<% } %>
						</td>
					</tr>
					<tr>
						<td style="text-align:center;">
							<% 
								if ( i < listSize ) { 
									result = (HashMap)mlist.get(i);
							%>
							<%=result.get("PST_CN")==null?"":result.get("PST_CN") %>
							<%
								}
							%>
						</td>
						<td style="text-align:center;">
							<% 
								if ( i+1 < listSize ) { 
									result = (HashMap)mlist.get(i+1);
							%>
							<%=result.get("PST_CN")==null?"":result.get("PST_CN") %>
							<% } %>
						</td>
						<td style="text-align:center;">
							<% 
								if ( i+2 < listSize ) { 
									result = (HashMap)mlist.get(i+2);	
							%>
							<%=result.get("PST_CN")==null?"":result.get("PST_CN") %>
							<% } %>
						</td>
					</tr>
					<tr>
						<td style="text-align:center;">
						<!--  
							<a href="#" class="sBtn type3" onclick="goView('<%=CONTEXTPATH+"/dataFile/mimg/"+result.get("SRVR_FILE_NM")%>');">보기</a>
						-->
							<%
								if ( i < listSize ) { 
									result = (HashMap)mlist.get(i);
							%>
							<!--  
								<a href="#" class="sBtn type3" onclick="goView('<%=CONTEXTPATH+"/dataFile/mimg/"+result.get("SRVR_FILE_NM")%>');">보기</a>
							-->
							<a href="#" class="sBtn type4" onclick="del('<%=result.get("PST_MNG_NO")%>');">삭제</a>
							<% } %>
						</td>
						<td style="text-align:center;">
							<%
								if ( i+1 < listSize ) { 
									result = (HashMap)mlist.get(i+1);
							%>
							<!--  
								<a href="#" class="sBtn type3" onclick="goView('<%=CONTEXTPATH+"/dataFile/mimg/"+result.get("SRVR_FILE_NM")%>');">보기</a>
							-->
							<a href="#" class="sBtn type4" onclick="del('<%=result.get("PST_MNG_NO")%>');">삭제</a>
							<% } %>
						</td>
						<td style="text-align:center;">
							<%
								if ( i+2 < listSize ) { 
									result = (HashMap)mlist.get(i+2);	
							%>
							<!--  
								<a href="#" class="sBtn type3" onclick="goView('<%=CONTEXTPATH+"/dataFile/mimg/"+result.get("SRVR_FILE_NM")%>');">보기</a>
							-->
							<a href="#" class="sBtn type4" onclick="del('<%=result.get("PST_MNG_NO")%>');">삭제</a>
							<% } %>
						</td>
					</tr>
					<% } %>
				</table>
			</div>
		</div>
	</div>
</div>