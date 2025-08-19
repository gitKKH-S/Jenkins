<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	HashMap info = request.getAttribute("info")==null?new HashMap():(HashMap)request.getAttribute("info");
	
	List ruleList = info.get("ruleList")==null?new ArrayList():(List)info.get("ruleList");
	HashMap resultMap = info.get("resultMap")==null?new HashMap():(HashMap)info.get("resultMap");
	
	List fList1 = info.get("fList1")==null?new ArrayList():(List)info.get("fList1");
	String opGbn = param.get("opgbn")==null?"":param.get("opgbn").toString();
	String opinionId = param.get("opinionid")==null?"":param.get("opinionid").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
%>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/commission.css" />
<script>
	function goWrite(){
		location.href="opinionWrite.do?opinionid=<%=opinionId%>&opgbn=<%=opGbn%>";
	}
	function downpage(Pcfilename,Serverfile,folder){
		form=document.forms[0];
		form.Pcfilename.value=Pcfilename;
		form.Serverfile.value=Serverfile;
		form.folder.value=folder;
		form.action="<%=CONTEXTPATH %>/Download";
		form.submit();
	}
</script>
<div class="button_register"> 
			<img src="${resourceUrl}/images/commitee/button_modify.png" width="57" height="20" alt="수정" style="cursor:pointer;" onclick="goWrite();">
		</div>
		
		<form name="frm" method="post" enctype="multipart/form-data">
		 	<input type="hidden" name="commissionid" value="<%=resultMap.get("COMMISSIONID")%>"/>
		 	<input type="hidden" name="opinionid" value="<%=opinionId%>"/>
		 	<input type="hidden" name="userNo" value="<%=USERNO%>"/>
		 	<input type="hidden" name="opgbn" value="<%=resultMap.get("OPGBN")%>"/>
		 	<input type="hidden" name="Serverfile"/>
			<input type="hidden" name="Pcfilename"/>
			<input type="hidden" name="folder"/>
			<table border="0" cellpadding="0" cellspacing="0"  class="approval">
				<colgroup>
					<col width="20%"/>
					<col width="30%"/>
					<col width="20%"/>
					<col width="30%"/>
				</colgroup>
			 	<tbody class="approval_list">  
			    	<tr>
			    		<th>위원명</th>
			    		<td><%=resultMap.get("USERNAME")%></td> 
			    		<th>등록일시</th>
			    		<td><%=resultMap.get("INDT")%></td> 
			    	</tr> 
		    		<%for(int i=0;i<ruleList.size();i++){
			    		HashMap reMap = (HashMap)ruleList.get(i);
			    		String yORn = ""+reMap.get("YORN");
			    		System.out.println();
			    	%>
			    	<tr>
			    		<td colspan="<%if(opGbn.equals("W")){out.println("3");}else{out.println("4");}%>">
			    			<%=reMap.get("TITLE")%>
			    			<input name="bookIdArray" type="hidden" value="<%=reMap.get("BOOKID")%>"/>
			    		</td>
			    		<%
			    			if(opGbn.equals("W")){
			    		%>
			    		<td>
			    				<%if ("Y".equals(yORn)) out.print("가결"); %>
			    				<%if ("U".equals(yORn)) out.print("수정가결"); %>
			    				<%if ("B".equals(yORn)) out.print("보류"); %>
			    				<%if ("N".equals(yORn)) out.print("부결"); %>
			    		</td>
			    		<%
			    			}
			    		%>
			    	</tr>
			    	<%} %>			    	
			    	<tr>
			    		<td colspan="4" style="padding:10px;">
			    			<%=resultMap.get("OPINION")==null?"":resultMap.get("OPINION")%>
			    		</td>
			    	</tr>
			    	<%
		    			if(opGbn.equals("G")){
		    		%>
			    	<tr>
			    		<th>첨부파일</th>
			    		<td colspan="3">
			    			<%
				    			if(resultMap.get("SERVERFILENAME")!=null){
				    		%>
				    			<a href="javascript:downpage('<%=resultMap.get("PCFILENAME") %>','<%=resultMap.get("SERVERFILENAME") %>','opinion');">
									<img src="<%=CONTEXTPATH %>/jsp/lkms3/images/file/COMPOUND.GIF" align="middle" alt="<%=resultMap.get("PCFILENAME") %>" style='cursor:hand' />
									<%=resultMap.get("PCFILENAME") %>
								</a>
				    		<%
				    			}
				    		%>
			    		</td>
			    	</tr>
			    	<%
		    			}
			    	%>
			  	</tbody>
			</table>
		</form>		