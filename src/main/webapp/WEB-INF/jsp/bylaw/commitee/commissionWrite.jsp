<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	int pageSize = param.get("pageSize")==null?15:Integer.parseInt(param.get("pageSize").toString());
	int pageno = param.get("pageno")==null?1:Integer.parseInt(param.get("pageno").toString());
	String schMenu = param.get("schMenu")==null?"":param.get("schMenu").toString();
	String schtxt = param.get("schtxt")==null?"":param.get("schtxt").toString();
	String commissionid = param.get("commissionid")==null?"":param.get("commissionid").toString();
	String bookids = param.get("bookids")==null?"":param.get("bookids").toString();
	
	HashMap info = request.getAttribute("info")==null?new HashMap():(HashMap)request.getAttribute("info");
	
	HashMap commissionInfo = info.get("commissionInfo")==null?new HashMap():(HashMap)info.get("commissionInfo");
	List ruleList = info.get("ruleList")==null?new ArrayList():(List)info.get("ruleList");
	List fList1 = info.get("fList1")==null?new ArrayList():(List)info.get("fList1");
	List fList2 = info.get("fList2")==null?new ArrayList():(List)info.get("fList2");
	
	for (int i=0;i<ruleList.size();i++){
		HashMap m = (HashMap)ruleList.get(i);
		if(bookids.length()<1||i==0){
			bookids = ""+m.get("BOOKID");
		}else{
			bookids = bookids + "@@"+m.get("BOOKID");
		}
	}
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery-ui-1.9.2.custom.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery-ui-timepicker-addon.js"></script>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/smoothness/jquery-ui-1.9.2.custom.min.css" />
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/commission.css" />
<script>

	function goList(){
		var frm = document.list;
		frm.action="commissionList.do";
		frm.submit();
	}

	function save(){
		var frm = document.frm;
		for(i=0; i<frm.openyn.length; i++){
			if(frm.openyn[0].checked==true){
				frm.openyn.value="Y";
			}else{
				frm.openyn.value="N";
			}
		}
		if (frm.cha.value==null|frm.cha.value==''){
			alert("회차를 입력해주세요.");
			return;
		}else if (frm.title.value==null|frm.title.value==''){
			alert("심의명를 입력해주세요.");
			return;
		}else if  (frm.starttime.value==null|frm.starttime.value==''){
			alert("시작일시를 입력해주세요.");
			return;
		}
		frm.bookids.value = lawlist;
		frm.action="insertCommission.do";
		frm.submit();
	}
	
	var lawlist = '<%=bookids%>';
	function getBookIds(lawInfos){

		lawlist = '';
		
		var el = '<table border="0" cellpadding="0" cellspacing="0"  class="approval02">'
					+'<caption class="approval_caption" >'
						+'<img src="${resourceUrl}/images/commitee/approval_icon02.gif" width="70" height="28" title="안건" onclick="showPopup();"/>'
					+'</caption>'
				 	+'<thead class="thead">'
				    	+'<tr class="thead_bg">'
				    		+'<th style="text-align:left; width:10px;">'
				    			+'<img src="${resourceUrl}/images/commitee/list_bar_left.gif" width="4" height="35">'
				    		+'</th>'
				    		+'<th style="text-align:center;">번호</th>' 
				    		+'<th style="text-align:center;">규정명</th>'
				    		+'<th style="text-align:center;">개정차수</th>'
				    		+'<th style="text-align:center;">제/개정</th>'
				    		+'<th style="text-align:right;width:10px;">'
				    			+'<img src="${resourceUrl}/images/commitee/list_bar_right.gif" width="4" height="35">'
				    		+'</th>'
				    	+'</tr>'
				  	+'</thead>';
				
				  	+'<tbody>';  
				  	
		if (lawInfos){
			var lawInfo_array = lawInfos.split("@@");					  	
			for(var i=0; i<lawInfo_array.length; i++){
				var lawInfo = lawInfo_array[i];
				var lawDetail_array = lawInfo.split("#");

					var bookid = lawDetail_array[0];
					var title = lawDetail_array[1];
					var revcha = lawDetail_array[2];
					var revCd = lawDetail_array[3];
					
			    	el += '<tr><td></td><td>'+(i+1)+'</td><td>'+title
			    			+'</td><td>'+revcha
			    			+'</td><td>'+revCd
			    			+'</td><td></td></tr>';
			    	
			    	if (lawlist == ''){
			    		lawlist = bookid;
			    	}else{
			    		lawlist += '@@'+bookid;
			    	}

			}
		}else{
			el += '<tr><td colspan="6">등록해 주세요</td></tr>';
		}
		el += '</tbody></table>';
		var lawListTBODY = document.getElementById("lawListTBODY");
		lawListTBODY.innerHTML = el; 
	}
	
	function showPopup(){
		parent.showLawWin(lawlist);
	}
	
	parent.reloadWewonGrid('selectWewonList','');
	
	function downpage(Pcfilename,Serverfile,folder){
		form=document.forms[0];
		form.Pcfilename.value=Pcfilename;
		form.Serverfile.value=Serverfile;
		form.folder.value=folder;
		form.action="<%=CONTEXTPATH %>/Download";
		form.submit();
	}
</script> 
<form name="list" method="post">
	<input type="hidden" name="pageno" value="<%=pageno%>"/>
	<input type="hidden" name="schmenu" value="<%=schMenu%>"/>
	<input type="hidden" name="schtxt" value="<%=schtxt%>"/>
	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
	<div style="width:95%;margin:10px 20px;text-align:center;">
		<div class="button_register"> 
			<div class="buttonShape" onclick="goList();">목록</div>
			<div class="buttonShape" onclick="save();">저장</div>
		</div>
		
		<form name="frm" method="post" enctype="multipart/form-data">
		 	<input type="hidden" name="commissionid" value="<%=commissionid%>"/>
		 	<input type="hidden" name="bookids" value="<%=bookids%>"/>
		 	<input type="hidden" name="job" value="insertCommission"/>
			<table border="0" cellpadding="0" cellspacing="0"  class="approval">
				<colgroup>
					<col width="15%"/>
					<col width="35%"/>
					<col width="15%"/>
					<col width="35%"/>
				</colgroup>
			 	<tbody class="approval_list">  
			    	<tr>
			    		<th>심의방법</th> 
			    		<td>
							<select name="methods">
								<option value="공개심의" <%if(!"전자심의".equals(commissionInfo.get("METHOD"))){out.print("selected");} %>>공개심의</option>
								<option value="전자심의" <%if("전자심의".equals(commissionInfo.get("METHOD"))){out.print("selected");} %>>전자심의</option>
							</select>
						</td>
						<th>결정 의견 공개여부</th> 
			    		<td>
							<input type="radio" name="openyn" value="Y" <%if(commissionInfo.get("OPENYN")==null||"Y".equals(commissionInfo.get("OPENYN"))){out.print("checked");} %>> 공개
							<input type="radio" name="openyn" value="N" <%if("N".equals(commissionInfo.get("OPENYN"))){out.print("checked");} %>> 비공개
						</td>
			    	</tr> 
			    	<tr>
			    		<th>장소 </th> 
			    		<td>
			    			<input type="text" name="place" style="width:98%;" value="<%=commissionInfo.get("PLACE")==null?"":commissionInfo.get("PLACE")%>"/>
			    		</td>
			    		<th>회차 </th> 
			    		<td>
			    			<input type="text" name="cha" style="width:98%;" value="<%=commissionInfo.get("CHA")==null?"":commissionInfo.get("CHA")%>"/>
			    		</td>
			    	</tr>
			    	<tr>
			    		<th>심의명 </th> 
			    		<td colspan="3">
			    			<input type="text" name="title" style="width:98%;" value="<%=commissionInfo.get("TITLE")==null?"":commissionInfo.get("TITLE")%>"/>
			    		</td>
			    	</tr> 
			    	<tr>
			    		<th>시작일시 </th> 
			    		<td>
			    			<input id="starttime" type="text" name="starttime" style="width:98%;" value="<%=commissionInfo.get("STARTTIME")==null?"":commissionInfo.get("STARTTIME")%>"/>
			    		</td>
			    		<th>종료일시</th> 
			    		<td>
			    			<input id="endtime" type="text" name="endtime" style="width:98%;" value="<%=commissionInfo.get("ENDTIME")==null?"":commissionInfo.get("ENDTIME")%>"/>
			    		</td>
			    	</tr>
			    	<tr>
			    		<th>안건요약표 </th> 
			    		<td colspan="3">
							<div>
							<%
								int list_cnt=fList1.size();
								for(int j=0; j<list_cnt; j++){ 
									HashMap fbean = (HashMap)fList1.get(j);
							%>
								<input type="checkbox" name="delfile[]" width="70%" value="<%=fbean.get("FILEID") %>"/>
								<a href="javascript:downpage('<%=fbean.get("PCFILENAME") %>','<%=fbean.get("SERVERFILENAME") %>','SUMMARY');">
									<%=fbean.get("PCFILENAME") %>
								</a><br/>
							<% 
								}
							%>
							</div>	
							<div>		    		
			    				<input type="file" style="width:70%" name="attFile"/>
			    			</div>
			    		</td>
			    	</tr> 
			    	<tr>
			    		<th>보고안건 첨부파일 </th> 
			    		<td colspan="3">
							<div>
							<%
								int list_cnt2=fList2.size();
								for(int j=0; j<list_cnt2; j++){ 
									HashMap fbean = (HashMap)fList2.get(j);
							%>
								<input type="checkbox" name="delfile[]" value="<%=fbean.get("FILEID") %>"/>
								<a href="javascript:downpage('<%=fbean.get("PCFILENAME") %>','<%=fbean.get("SERVERFILENAME") %>','ETC');">
									<%=fbean.get("PCFILENAME") %>
								</a><br/>
							<% 
								}
							%>
							</div>	
							<div>		    		
			    				<input type="file" style="width:70%" name="attFile2"/>
			    			</div>
			    		</td>
			    	</tr>	
			    	<tr style="display:none">
			    		<th>공포일</th> 
			    		<td colspan="3">
							<input id="promuldt" type="text" name="promuldt" value="<%=commissionInfo.get("PROMULDT")==null?"":commissionInfo.get("PROMULDT")%>"/>
			    		</td>
			    	</tr> 			 		    	
			  	</tbody>
			</table>
			
		</form>		
		
		
		<div id="lawListTBODY">
			<table border="0" cellpadding="0" cellspacing="0"  class="approval02">
				<caption class="approval_caption" >
					<img src="${resourceUrl}/images/commitee/approval_icon02.gif" width="70" height="28" title="안건" onclick="showPopup();"/>
				</caption>
			 	<thead class="thead">
			    	<tr class="thead_bg">
			    		<th style="text-align:left; width:10px;">
			    			<img src="${resourceUrl}/images/commitee/list_bar_left.gif" width="4" height="35">
			    		</th>
				    	<th style="text-align:center;">번호</th> 
				    	<th style="text-align:center;">규정명</th>
				    	<th style="text-align:center;">개정차수</th>
				    	<th style="text-align:center;">제/개정</th>
			    		<th style="text-align:right;width:10px;">
			    			<img src="${resourceUrl}/images/commitee/list_bar_right.gif" width="4" height="35">
			    		</th>
			    	</tr>
			  	</thead>
			
			  	<tbody>  
				  <%
				  	if (ruleList != null){
					  	for(int i=0; i<ruleList.size(); i++){
						HashMap lawMap = (HashMap)ruleList.get(i); 
				  %>
				  
				    <tr <%if (i%2==1){out.print("class=\"tbody_list_bg02\"");} %> onclick="goView('<%=commissionInfo.get("BOOKID")%>');">
				    	<td></td>
				    	<td style="text-align:center;"><%=i+1%></td>
				    	<td style="text-align:center;"><%=lawMap.get("TITLE") %> </td>
				    	<td style="text-align:center;"><%=lawMap.get("REVCHA") %>차</td>
				    	<td style="text-align:center;"><%=lawMap.get("REVCD") %></td>
				    	<td> </td>
				    </tr>			  	
				  <%	} 
				  	}
				  	if (ruleList == null||ruleList.size()<1){
				  %>			  	
			    	<tr>
			    		<td colspan="6">등록된 안건이 없습니다.</td>
			    	</tr>
			     <%} %>
			  	</tbody>
			</table>
		</div>
	</div>
<script>
var config = {
	  dateFormat: 'yy-mm-dd',
	  timeFormat: 'hh:mm'
}
$('#starttime').datetimepicker(config);
$('#endtime').datetimepicker(config);
$('#promuldt').datetimepicker(config);
</script>