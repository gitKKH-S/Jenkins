<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	HashMap info = request.getAttribute("info")==null?new HashMap():(HashMap)request.getAttribute("info");
	
	List ruleList = info.get("ruleList")==null?new ArrayList():(List)info.get("ruleList");
	HashMap resultMap = info.get("resultMap")==null?new HashMap():(HashMap)info.get("resultMap");
	
	List fList1 = info.get("fList1")==null?new ArrayList():(List)info.get("fList1");
	String opGbn = param.get("opgbn")==null?"":param.get("opgbn").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
%>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/commission.css" />
		<script>
			function goView(commissionId){
				location.href="commissionView.do?commissionid="+commissionId;
			}		
			function save(){
				var opgbn = "<%=opGbn%>";
				var frm = document.frm;
				var bookids = "";
				var yorns = "";
				var cnt = <%=ruleList.size()%>;
				if (cnt >1){
				    for (var i=0; i<cnt; i++){
				    		if (frm.yornarray[i].value=='' && opgbn=='W'){
				    			alert('선택되지 않은 항목이 있습니다.');
				    			return;
				    		}
				    		if (bookids.length<1){
				    			bookids = frm.bookidarray[i].value;
				    			if(frm.yornarray){
				    				yorns = frm.yornarray[i].value;
				    			}
				    		}else{
				    			bookids += "@@"+frm.bookidarray[i].value;
				    			if(frm.yornarray){
				    				yorns += "@@"+frm.yornarray[i].value;
				    			}
				    		}
				    }
				    frm.bookids.value = bookids;
				    if(frm.yornarray){
				    	frm.yorn.value = yorns;
				    }
				}else{
				    frm.bookids.value = frm.bookidarray.value;
				    if(frm.yornarray){
				    	frm.yorn.value = frm.yornarray.value;
				    }
				}
				
				if(opgbn=="G"){
					frm.enctype="multipart/form-data";
				}
				frm.action="insertOpinion.do";
				frm.submit(); 
			}
			function downpage(Pcfilename,Serverfile,folder){
				form=document.forms[0];
				form.Pcfilename.value=Pcfilename;
				form.Serverfile.value=Serverfile;
				form.folder.value=folder;
				form.action="<%=CONTEXTPATH %>/Download";
				form.submit();
			}
			function goSel(gbn){
				var cnt = <%=ruleList.size()%>;
				if (cnt >1){
				    for (var i=0; i<cnt; i++){
			    		frm.yornarray[i].value=gbn;
				    }
				}else{
				    frm.yornarray.value = gbn;
				}
			}
		</script>	
		<div class="button_register"> 
			<!--img src="../images/button_register.png" width="57" height="20" alt="등록" style="cursor:pointer;" onclick="save();"-->
			<div class="buttonShape" onclick="save();">등록</div>
		</div>
		
		<form name="frm" method="post">
		 	<input type="hidden" name="commissionid" value="<%=param.get("commissionid")%>"/>
		 	<input type="hidden" name="opinionid" value="<%=param.get("opinionid")%>"/>
		 	<input type="hidden" name="userno" value="<%=resultMap.get("USERNO")==null?USERNO:resultMap.get("USERNO")%>"/>
		 	<input type="hidden" name="opgbn" value="<%=resultMap.get("OPGBN")==null?opGbn:resultMap.get("OPGBN")%>"/>
		 	<input type="hidden" name="bookids"/>
		 	<input type="hidden" name="yorn"/>
		 	<input type="hidden" name="job" value="insertOpinion"/>
		 	<input type="hidden" name="serverfile"/>
			<input type="hidden" name="pcfilename"/>
			<input type="hidden" name="folder"/>
			<table border="0" cellpadding="0" cellspacing="0"  class="approval">
				<colgroup>
					<%if(opGbn.equals("C")||opGbn.equals("G")||opGbn.equals("N")){ %>
		    		<col width="70%"/>
					<col width="15%"/>
					<col width="15%"/>
		    		<%}else{ %>
					<col width="75%"/>
					<col width="25%"/>
					<%} %>
				</colgroup>
			 	<tbody class="approval_list">  
			    	<tr>
			    		<th>규정명</th> 
			    		<th <%if(!opGbn.equals("W")){out.println("style='display:none'");} %>>안건결정(<span style="cursor:pointer" onclick="goSel('Y')">가</span>/<span style="cursor:pointer" onclick="goSel('N')">부</span>)</th>
			    		<%if(opGbn.equals("C")||opGbn.equals("G")||opGbn.equals("N")){ %>
			    		<th>가결</th>
			    		<th>수정가결</th>
			    		<th>보류</th>
			    		<th>부결</th>
			    		<%} %>
			    	</tr> 
			    	<%for(int i=0;i<ruleList.size();i++){
			    		HashMap reMap = (HashMap)ruleList.get(i);
			    		String yORn = ""+reMap.get("YORN");
			    		String ACTIONYN = ""+reMap.get("ACTIONYN");
			    	%>
			    	<tr>
			    		<td>
			    			<%=reMap.get("TITLE")%>
			    			<input name="bookidarray" type="hidden" value="<%=reMap.get("BOOKID")%>"/>
			    		</td>
			    		<td <%if(!opGbn.equals("W")){out.println("style='display:none'");} %>>
			    			<select name="yornarray">
			    				<option>선택하세요</option>
			    				<%
			    					if("Y".equals(ACTIONYN)){
			    				%>
			    				<option value="Y" <%if ("Y".equals(yORn)) out.print("selected"); %>>가결</option>
			    				<option value="N" <%if ("N".equals(yORn)) out.print("selected"); %>>부결</option>
			    				<%		
			    					}else{
	    						%>
			    				<option value="Y" <%if ("Y".equals(yORn)) out.print("selected"); %>>가결</option>
			    				<option value="U" <%if ("U".equals(yORn)) out.print("selected"); %>>수정가결</option>
			    				<option value="B" <%if ("B".equals(yORn)) out.print("selected"); %>>보류</option>
			    				<option value="N" <%if ("N".equals(yORn)) out.print("selected"); %>>부결</option>
			    				<%		
			    					}
			    				%>
			    				
			    			</select>
			    		</td>
			    		<%if(opGbn.equals("C")||opGbn.equals("G")||opGbn.equals("N")){ %>
			    		<td style="text-align:center"><%=reMap.get("BYY")%></td>
			    		<td style="text-align:center"><%=reMap.get("BUN")%></td>
			    		<td style="text-align:center"><%=reMap.get("BBN")%></td>
			    		<td style="text-align:center"><%=reMap.get("BNN")%></td>
			    		<%} %>
			    	</tr>
			    	<%} %>
			    	<tr>
			    		<th colspan="<%if(opGbn.equals("C")||opGbn.equals("G")||opGbn.equals("N")){out.println("6");}else{out.println("2");} %>">의견</th>
			    	</tr>
			    	<tr>
			    		<td colspan="<%if(opGbn.equals("C")||opGbn.equals("G")||opGbn.equals("N")){out.println("6");}else{out.println("2");} %>" style="padding:5px">
			    			<textarea name="opinion" style="height:70px;width:99%;"><%=resultMap.get("OPINION")==null?"":resultMap.get("OPINION") %></textarea>
			    		</td>
			    	</tr>
			    	<%
		    			if(opGbn.equals("G")){
		    		%>
			    	<tr>
			    		<th colspan="4">첨부파일</th>
			    	</tr>
			    	<tr>
			    		<td colspan="4" style="padding:5px">
			    			<%
								int list_cnt=fList1.size();
								for(int j=0; j<list_cnt; j++){ 
									HashMap fbean = (HashMap)fList1.get(j);
							%>
								<input type="checkbox" name="File_chk" value="<%=fbean.get("FILEID") %>"/>
								<a href="javascript:downpage('<%=fbean.get("PCFILENAME") %>','<%=fbean.get("SERVERFILENAME") %>','opinion');">
									<%=fbean.get("PCFILENAME") %>
								</a><br/>
							<% 
								}
							%>
			    			<input type="file" name="attFile" style="width:99%">
			    		</td>
			    	</tr>
			    	<%
		    			}
			    	%>
			  	</tbody>
			</table>
		</form>	