<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	HashMap info = request.getAttribute("info")==null?new HashMap():(HashMap)request.getAttribute("info");
	List result = info.get("clist")==null?new ArrayList():(List)info.get("clist");
	int tot = info.get("total")==null?0:Integer.parseInt(info.get("total").toString());

	int pageSize = param.get("pageSize")==null?15:Integer.parseInt(param.get("pageSize").toString());
	int pageno = param.get("pageno")==null?1:Integer.parseInt(param.get("pageno").toString());
	String schMenu = param.get("schMenu")==null?"":param.get("schMenu").toString();
	String schtxt = param.get("schtxt")==null?"":param.get("schtxt").toString();
	
%>
<script src="${resourceUrl}/js/mten.pagenav.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/commission.css" />
<script>
	function goView(commissionId){
		parent.reloadWewonGrid('selectCommiteeList',commissionId);
		location.href="commissionView.do?commissionid="+commissionId;
	}
	function goWrite(){
		location.href="commissionWrite.do";
	}
	function mouseover(obj){
		var tmp = obj.src.split('.');
		obj.src = tmp[0]+"b."+tmp[1];
	}
	function mouseout(obj){
		var tmp = obj.src.split('b.');
		obj.src = tmp[0]+"."+tmp[1];
	}			
	parent.reloadWewonGrid('selectWewonList','');
	
	function goSch(){
		if(document.all.schTxt.value==''){
			alert("검색어를 입력하시기 바랍니다.");
			return;
		}else{
			var frm = document.goList;
			frm.action = "commissionList.do";
			frm.submit();
		}
	}
</script>	
<form name="goList" method="post" style="background-color:#fff;height:100%;">
	<!-- List Search Bar -->
	<div class="listsearch">
	    <table cellpadding="0" cellspacing="0">
	        <tr>
	            <th class="search_title" style="width:20%">[규정심의위원회] 검색</th>
	            <th style="width:30px;">구분</th>
	                <td style="width:70px;">
	                    <select name="schMenu" class="sch_subj">
							<option value="제목" <%if(schMenu.equals("제목")){out.println("selected");}%>>제목</option>
						</select>
	                </td>
	            <th style="width:50px;">검색어</th>
	            <td>
	                <input name="schtxt" type="text" value="<%=schtxt %>" maxlength="30" style="border:1px solid #8f98a7; width:200px;"/> 
	            	<img src="${resourceUrl}/images/commitee/k_search.gif" style="cursor:pointer;" onmouseover="mouseover(this);" onmouseout="mouseout(this);" onclick="goSch();"/>
	            </td>
	        </tr>
	    </table>
	</div>
	
	<div class="button_register" style="width:98%"> 
		<div class="buttonShape" onclick="goWrite();">등록</div>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0"  class="basic" style="width:98%">
		<thead class="thead">
		    <tr class="thead_bg">
		    	<th style="text-align:left; width:10px;">
		    		<img src="${resourceUrl}/images/commitee/list_bar_left.gif" width="4" height="35">
		    	</th>
		    	<th style="text-align:center;">번호</th> 
		    	<th style="text-align:center;">심의방법</th> 
		    	<th style="text-align:center;">심의명</th>
		    	<th style="text-align:center;">회차</th>
		    	<th style="text-align:center;">시작일자</th>
		    	<th style="text-align:center;">종료일자</th>
		    	<th style="text-align:right;width:10px;">
		    		<img src="${resourceUrl}/images/commitee/list_bar_right.gif" width="4" height="35">
		    	</th>
		    </tr>
		</thead>
		
		<tbody>  
		  
			  <% for(int i=0; i<result.size(); i++){
				 HashMap resultMap = (HashMap)result.get(i); 
			  %>
			  
			    <tr <%if (i%2==1){out.print("class=\"tbody_list_bg02\"");} %> onclick="goView(<%=resultMap.get("COMMISSIONID")%>);">
			    	<td></td>
			    	<td style="text-align:center;"><%=i+pageSize*(pageno-1)+1%></td>
			    	<td style="text-align:center;"><%=resultMap.get("METHODS") %> </td>
			    	<td style="text-align:center;"><%=resultMap.get("TITLE") %></td>
			    	<td style="text-align:center;"><%=resultMap.get("CHA") %>차</td>
			    	<td style="text-align:center;"><%=resultMap.get("STARTTIME") %></td>
			    	<td style="text-align:center;"><%=resultMap.get("ENDTIME")==null?"":resultMap.get("ENDTIME") %></td>
			    	<td> </td>
			    </tr>
			  <%} %>
			  
			  <%if (result.size()==0){ %>
			    <tr>
			    	<td colspan="8">조회 결과가 없습니다.</td>
			    </tr>			  	
			  <%} %>
		
		</tbody>
	</table>
		

	<div class="paging" style="margin-top:10px;">
	    <script type="text/javascript">
			document.write( pageNav( "gotoPage", <%=pageno%>, <%=pageSize%>, <%=tot%> ) );
		</script>
	</div>	
	<input name="pageno" type="hidden" value="<%=pageno %>"/>
	<input name="schMenu" type="hidden" value="<%=schMenu %>"/>
	<input name="schtxt" type="hidden" value="<%=schtxt %>"/>
</form>