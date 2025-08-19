<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
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
	List fList3 = info.get("fList3")==null?new ArrayList():(List)info.get("fList3");
	List fList4 = info.get("fList4")==null?new ArrayList():(List)info.get("fList4");
	
	List opinionList = info.get("opinionList")==null?new ArrayList():(List)info.get("opinionList");
	List gansa_opinionList = info.get("gansa_opinionList")==null?new ArrayList():(List)info.get("gansa_opinionList");
	List jang_opinionList = info.get("jang_opinionList")==null?new ArrayList():(List)info.get("jang_opinionList");
	List Njang_opinionList = info.get("Njang_opinionList")==null?new ArrayList():(List)info.get("Njang_opinionList");
	
	String statecd = "";
	for (int i=0;i<ruleList.size();i++){
		HashMap m = (HashMap)ruleList.get(i);
		if(bookids.length()<1||i==0){
			bookids = ""+m.get("BOOKID");
		}else{
			bookids = bookids + "@@"+m.get("BOOKID");
		}
		statecd = m.get("STATECD").toString();
	}
	
	String openYn = commissionInfo.get("OPENYN")==null?"":commissionInfo.get("OPENYN").toString();
	
	//위원장의견리스트
	String Ccont = "";
	String COPINIONID="";
	if(jang_opinionList.size()>0){
		Ccont = ((HashMap)jang_opinionList.get(0)).get("OPINION")==null?"":((HashMap)jang_opinionList.get(0)).get("OPINION").toString();
		COPINIONID = ((HashMap)jang_opinionList.get(0)).get("OPINIONID")==null?"":((HashMap)jang_opinionList.get(0)).get("OPINIONID").toString();
	}
	//노조조합장 의견
	String Ncont = "";
	String NOPINIONID="";
	if(Njang_opinionList.size()>0){
		Ncont = ((HashMap)Njang_opinionList.get(0)).get("OPINION")==null?"":((HashMap)Njang_opinionList.get(0)).get("OPINION").toString();
		NOPINIONID = ((HashMap)Njang_opinionList.get(0)).get("OPINIONID")==null?"":((HashMap)Njang_opinionList.get(0)).get("OPINIONID").toString();
	}
%>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/commission.css" />
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
 <script>

	function goList(){
		var frm = document.frm;
		frm.action="commissionList.do";
		frm.submit();
	}
	
	function goWrite(){
		var frm = document.frm;
		frm.action="commissionWrite.do";
		frm.submit();
	}
	
function showFileForm(commisstionid, filecd){
	parent.showFileForm(commisstionid, filecd);			
}
function goView(vgbn,bookid,statehistoryid){
	var obj = new HashMap();
 	obj.put("exeform","fileview");
 	obj.put("revmode","3");
 	obj.put("grade","");
 	obj.put("filecd",vgbn);
 	obj.put("sabun","0");
 	obj.put("statehistoryid",statehistoryid);
 	obj.put("bookid",bookid);
 	obj.put("before_statehistoryid","0");
	chkSetUp(makeXML(obj));
}
function writeOpinion(opinionId, commissionId,opGbn){
	parent.showOpinionWin(opinionId, commissionId,opGbn);
}	
function viewOpinion(opinionId,opGbn){
	parent.showOpinionViewWin(opinionId,opGbn);
}
function downpage(Pcfilename,Serverfile,folder){
	form=document.forms[0];
	form.Pcfilename.value=Pcfilename;
	form.Serverfile.value=Serverfile;
	form.folder.value=folder;
	form.action="<%=CONTEXTPATH %>/Download";
	form.submit();
}

function gian(key){
	var bookIds='<%=commissionid%>';
	
	makeGian(bookIds, key);
}
var eApproveWin;
function makeGian(bookIds, key){
	//alert(bookIds+'/'+key);
	eApproveWin = new Ext.Window({
		height:500,
		width:924,
		modal:true,
		title: '결재상신'
	});
	eApproveWin.render(Ext.getBody());
	eApproveWin.body.update('<iframe src="../eApprove/eApprove.jsp?bookId='+bookIds+'&stateCd='+key+'" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');	 
	eApproveWin.show();
}

function gianMag(key,commissionId){
	alert("결제 신청 되었습니다.");
	eApproveWin.close();
	if(key=='CMIN'){
		key = "CMRE";
		goButton2(key,commissionId);
	}
	
}	
function goButton2(key,commissionId){
	Ext.Ajax.request({
		url: './proc/gianProc.jsp',
		params: {
			commissionId:commissionId,
			statecd:key
		},
		success: function(res, opts){
			
		},
		failure: function(res, opts){
			Ext.MessageBox.alert('데이터입력 실패','서버와의 연결상태가 좋지 않습니다.');
		}
	}); 
}	
function simOpen(){
	cw=1000;
     ch=668;
	 sw=screen.availWidth;
	 sh=screen.availHeight;
	 px=(sw-cw)/2;
	 py=(sh-ch)/2;
	 property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=no,resizable=no,status=no,toolbar=no";
	 window.open("MakeHwp.jsp?commissionId=<%=commissionid%>", "Bookid", property);
}
</script>   
<form name="list" method="post">
	<input type="hidden" name="pageno" value="<%=pageno%>"/>
	<input type="hidden" name="schMenu" value="<%=schMenu%>"/>
	<input type="hidden" name="schtxt" value="<%=schtxt%>"/>
	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<form name="frm" method="post">
	<input type="hidden" name="commissionid" value="<%=commissionid%>"/>
</form>	
		<div style="width:98%;margin:10 20;text-align:center;">
		<!--div class="button_approval"--> 
		<div class="button_register"> 
			<div class="buttonShape" onclick="goList();">목록</div>
			<div class="buttonPoll">|</div>
			<div class="buttonShape" onclick="goWrite();">수정</div>
			<div class="buttonPoll">|</div>
			<div class="buttonShape" onclick="writeOpinion('','<%=commissionid%>', 'W');">의견등록</div>
		</div>
		
			<!-- 기본정보 -->
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
							<%=commissionInfo.get("METHODS")%>
						</td>
						<th>결정 의견 공개여부</th> 
			    		<td>
							<%
							if(openYn.equals("Y")){
								out.println("공개");
							}else if(openYn.equals("N")){
								out.println("비공개");
							}else{
								out.println("&nbsp;");
							}
							%>
						</td>
			    	</tr> 
			    	<tr>
			    		<th>장소 </th> 
			    		<td>
			    			<%=commissionInfo.get("PLACE")%>
			    		</td>
			    		<th>회차 </th> 
			    		<td>
			    			<%=commissionInfo.get("CHA")%>
			    		</td>
			    	</tr>
			    	<tr>
			    		<th>심의명 </th> 
			    		<td colspan="3">
			    			<%=commissionInfo.get("TITLE")%>
			    		</td>
			    	</tr> 
			    	<tr>
			    		<th>시작일시 </th> 
			    		<td>
			    			<%=commissionInfo.get("STARTTIME")%>
			    		</td>
			    		<th>종료일시</th> 
			    		<td>
			    			<%=commissionInfo.get("ENDTIME")==null?"":commissionInfo.get("ENDTIME")%>
			    		</td>
			    	</tr>
			    	<tr>
			    		<th>안건요약표 </th> 
			    		<td colspan="3">
			    			<div>&nbsp;
							<%
								int list_cnt=fList1.size();
								for(int j=0; j<list_cnt; j++){ 
									HashMap fbean = (HashMap)fList1.get(j);
							%>
								<a href="javascript:downpage('<%=fbean.get("PCFILENAME") %>','<%=fbean.get("SERVERFILENAME") %>','SUMMARY');">
									<%=fbean.get("PCFILENAME") %>
								</a><br/>
							<% 
								}
							%>
							</div>
			    		</td>
			    	</tr>
			    	<tr>
			    		<th>보고첨부파일 </th> 
			    		<td colspan="3">
			    			<div>&nbsp;
							<%
								int list_cnt2=fList2.size();
								for(int j=0; j<list_cnt2; j++){ 
									HashMap fbean = (HashMap)fList2.get(j);
							%>
								<a href="javascript:downpage('<%=fbean.get("PCFILENAME") %>','<%=fbean.get("SERVERFILENAME") %>','ETC');">
									<%=fbean.get("PCFILENAME") %>
								</a><br/>
							<% 
								}
							%>
							</div>
			    		</td>
			    	</tr>
					<tr>
			    		<th>의사록 </th> 
			    		<td colspan="3">
			    			<div>
							<%
								list_cnt=fList3.size();
								for(int j=0; j<list_cnt; j++){ 
									HashMap fbean = (HashMap)fList3.get(j);
							%>
								<a href="javascript:downpage('<%=fbean.get("PCFILENAME") %>','<%=fbean.get("SERVERFILENAME") %>','OPINION');">
									<%=fbean.get("PCFILENAME") %>
								</a>
							<% 
								}
								if (list_cnt==0){
							%>
								<img src="${resourceUrl}/images/commitee/button_register.png" width="57" height="20" alt="등록" style="cursor:pointer;" onclick="showFileForm('<%=commissionid%>','opinion');">
								<!-- img src="${resourceUrl}/images/commitee/minute.png" alt="등록" style="cursor:pointer;" onclick="simOpen();"> -->
							<%	}else{ %>
								<img src="${resourceUrl}/images/commitee/button_modify.png" width="57" height="20" alt="수정" style="cursor:pointer;" onclick="showFileForm('<%=commissionid%>','opinion');">
							<%	} %>
							</div>
			    		</td>
			    	</tr>
					<tr>
			    		<th>결과요약표/개정내용 </th> 
			    		<td colspan="3">
			    			<div>
							<%
								list_cnt=fList4.size();
								for(int j=0; j<list_cnt; j++){ 
									HashMap fbean = (HashMap)fList4.get(j);
							%>
								<a href="javascript:downpage('<%=fbean.get("PCFILENAME") %>','<%=fbean.get("SERVERFILENAME") %>','RESUMMARY');">
									<%=fbean.get("PCFILENAME") %>
								</a>
							<% 
								}
								if (list_cnt==0){
							%>
								<img src="${resourceUrl}/images/commitee/button_register.png" width="57" height="20" alt="등록" style="cursor:pointer;" onclick="showFileForm('<%=commissionid%>','resummary');">
							<%	}else{ %>
								<img src="${resourceUrl}/images/commitee/button_modify.png" width="57" height="20" alt="수정" style="cursor:pointer;" onclick="showFileForm('<%=commissionid%>','resummary');">
							<%	} %>
							</div>
			    		</td>
			    	</tr>
			    	<tr style="display:none">
			    		<th>공포일 </th> 
			    		<td colspan="3">
			    			<div>
								<%=commissionInfo.get("PROMULDT")==null?"&nbsp;":commissionInfo.get("PROMULDT")%>
							</div>
			    		</td>
			    	</tr>			
			    	<tr style="display:none">
			    		<th>위원장 의견 </th> 
			    		<td colspan="3">
			    			<div>
								<%=Ccont %>
							</div>
			    		</td>
			    	</tr>	
			    	<tr style="display:none">
			    		<th>노동조합지부장확인 </th> 
			    		<td colspan="3">
			    			<div>
								<%=Ncont %>
							</div>
			    		</td>
			    	</tr>				    			    				    	 			    	
			  	</tbody>
			</table>	
		
		
		<!-- 안건리스트 -->
		<table border="0" cellpadding="0" cellspacing="0"  class="approval02">
			<caption class="approval_caption" >
				<span style="font-size:14px;font-weight:bold;color:#7b9fd4">&#8226;&nbsp;안건</span>
			</caption>

		 	<thead class="thead">
		    	<tr class="thead_bg">
			    		<th style="text-align:left; width:10px;">
			    			<img src="${resourceUrl}/images/commitee/list_bar_left.gif" width="4" height="35">
			    		</th>
				    	<th style="text-align:center;">번호</th> 
				    	<th style="text-align:left;">규정명</th>
				    	<th style="text-align:center;">종류</th>
				    	<th style="text-align:center;">제/개정</th>
				    	<th style="width:60px;text-align:center;">전문</th>
				    	<th style="width:60px;text-align:center;">개정이유</th>
				    	<th style="width:60px;text-align:center;">개정문</th>
				    	<th style="width:60px;text-align:center;">신구조문</th>
				    	<!--th style="width:60px;text-align:center;">이력검토</th-->
			    		<th style="text-align:right;width:10px;">
			    			<img src="${resourceUrl}/images/commitee/list_bar_right.gif" width="4" height="35">
			    		</th>
		    	</tr>
		  	</thead>
		
		  	<tbody>  
				  <% for(int i=0; i<ruleList.size(); i++){
					 HashMap lawMap = (HashMap)ruleList.get(i); 
				  %>
				  
				    <tr <%if (i%2==1){out.print("class=\"tbody_list_bg02\"");} %> >
				    	<td>&nbsp;</td>
				    	<td style="text-align:center;"><%=i+1%></td>
				    	<td style="cursor:pointer;text-align:left;"><%=lawMap.get("TITLE") %></td>
				    	<td style="text-align:center;"><%=lawMap.get("BOOKCD") %></td>
				    	<td style="text-align:center;"><%=lawMap.get("REVCD") %></td>
				    	<td style="text-align:center;">
				    		<img src="${resourceUrl}/seoul/images/icon_hwp.png" style="cursor:pointer" onclick="goView('JUN','<%=lawMap.get("BOOKID")%>','<%=lawMap.get("STATEHISTORYID")%>');">　　
				    	</td>
				    	<td style="text-align:center;">
				    		<img src="${resourceUrl}/seoul/images/icon_hwp.png" style="cursor:pointer" onclick="goView('REA','<%=lawMap.get("BOOKID")%>','<%=lawMap.get("STATEHISTORYID")%>');">　　
				    	</td>
				    	<td style="text-align:center;">
				    		<img src="${resourceUrl}/seoul/images/icon_hwp.png" style="cursor:pointer" onclick="goView('GAE','<%=lawMap.get("BOOKID")%>','<%=lawMap.get("STATEHISTORYID")%>');">　　
				    	</td>
				    	<td style="text-align:center;">
				    		<img src="${resourceUrl}/seoul/images/icon_hwp.png" style="cursor:pointer" onclick="goView('SIN','<%=lawMap.get("BOOKID")%>','<%=lawMap.get("STATEHISTORYID")%>');">　　
				    	</td>
				    	<!--  td style="text-align:center;">
				    		<img src="${resourceUrl}/seoul/images/icon_hwp.png" style="cursor:pointer" onclick="goView('MUL','<%=lawMap.get("BOOKID")%>','<%=lawMap.get("STATEHISTORYID")%>');">　　
				    	</td-->
				    	<td>&nbsp;</td>
				    </tr>
				  <%} 
				  	if (ruleList.size()<1){
				  %>			  	
			    	<tr>
			    		<td colspan="7">등록된 안건이 없습니다.</td>
			    	</tr>
			     <%} %>
		  	</tbody>
		</table>
		
		<!-- 의견리스트 -->
		<table border="0" cellpadding="0" cellspacing="0"  class="approval02">
			<caption class="approval_caption" >
				<span style="font-size:14px;font-weight:bold;color:#7b9fd4">&#8226;&nbsp;의견</span>
			</caption>
			
		 	<thead class="thead">
		    	<tr class="thead_bg">
		    		<th style="text-align:left; width:10px;">
		    			<img src="${resourceUrl}/images/commitee/list_bar_left.gif" width="4" height="35">
		    		</th>
			    	<th style="text-align:center;">번호</th> 
			    	<th style="text-align:center;">의견</th>
			    	<th style="text-align:center;">위원명</th>
			    	<th style="text-align:center;">등록일시</th>
		    		<th style="text-align:right;width:10px;">
		    			<img src="${resourceUrl}/images/commitee/list_bar_right.gif" width="4" height="35">
		    		</th>
		    	</tr>
		  	</thead>
		
		  	<tbody>  
				  <% for(int i=0; i<opinionList.size(); i++){
					 HashMap opinionMap = (HashMap)opinionList.get(i); 
					 String opinion = opinionMap.get("OPINION")==null?"":opinionMap.get("OPINION").toString().replaceAll("\r\n"," ");
				  %>
				  
				    <tr <%if (i%2==1){out.print("class=\"tbody_list_bg02\"");} %>>
				    	<td>&nbsp;</td>
				    	<td style="text-align:center;"><%=i+1%></td>
				    	<td style="text-align:left;cursor:pointer;" onclick="viewOpinion('<%=opinionMap.get("OPINIONID") %>','W')"><%=opinion %></td>
				    	<td style="text-align:center;"><%=opinionMap.get("USERNAME") %></td>
				    	<td style="text-align:center;"><%=opinionMap.get("INDT") %></td>
				    	<td>&nbsp;</td>
				    </tr>
				  <%} 
				  	if (opinionList.size()<1){
				  %>			  	
			    	<tr>
			    		<td colspan="7">등록된 의견이 없습니다.</td>
			    	</tr>
			     <%} %>
		  	</tbody>
		</table>
		
		<!-- 간사의견 -->
		<table border="0" cellpadding="0" cellspacing="0"  class="approval02" style="display:none">
			<caption class="approval_caption" >
				<span style="font-size:14px;font-weight:bold;color:#7b9fd4">&#8226;&nbsp;간사 의견</span>
			</caption>
			
		 	<thead class="thead">
		    	<tr class="thead_bg">
		    		<th style="text-align:left; width:10px;">
		    			<img src="${resourceUrl}/images/commitee/list_bar_left.gif" width="4" height="35">
		    		</th>
			    	<th style="text-align:center;">번호</th> 
			    	<th style="text-align:center;">의견</th>
			    	<th style="text-align:center;">첨부파일</th>
			    	<th style="text-align:center;">위원명</th>
			    	<th style="text-align:center;">등록일시</th>
		    		<th style="text-align:right;width:10px;">
		    			<img src="${resourceUrl}/images/commitee/list_bar_right.gif" width="4" height="35">
		    		</th>
		    	</tr>
		  	</thead>
		
		  	<tbody>  
				  <% for(int i=0; i<gansa_opinionList.size(); i++){
					 HashMap opinionMap = (HashMap)gansa_opinionList.get(i); 
					 String opinion = opinionMap.get("OPINION")==null?"":opinionMap.get("OPINION").toString().replaceAll("\r\n"," ");
				  %>
				  
				    <tr <%if (i%2==1){out.print("class=\"tbody_list_bg02\"");} %>>
				    	<td>&nbsp;</td>
				    	<td><%=i+1%></td>
				    	<td style="text-align:left;cursor:pointer;" onclick="viewOpinion('<%=opinionMap.get("OPINIONID") %>','G')"><%=opinion %></td>
				    	<td>
				    		<%
				    			if(opinionMap.get("SERVERFILENAME")!=null){
				    		%>
				    			<a href="javascript:downpage('<%=opinionMap.get("PCFILENAME") %>','<%=opinionMap.get("SERVERFILENAME") %>','OPINION');">
									<img src="<%=CONTEXTPATH %>/jsp/lkms3/images/file/COMPOUND.GIF" align="middle" alt="<%=opinionMap.get("PCFILENAME") %>" style='cursor:hand' />
								</a>
				    		<%
				    			}
				    		%>
				    	</td>
				    	<td><%=opinionMap.get("USERNAME") %></td>
				    	<td><%=opinionMap.get("INDT") %></td>
				    	<td>&nbsp;</td>
				    </tr>
				  <%} 
				  	if (gansa_opinionList.size()<1){
				  %>			  	
			    	<tr>
			    		<td colspan="7">등록된 의견이 없습니다.</td>
			    	</tr>
			     <%} %>
		  	</tbody>
		</table>
		
		<div class="button_register"> 
		<br/><br/><br/>
			<%
				if(statecd.equals("CMST")){
			%>
			<div class="buttonShape" onclick="gian('<%=statecd%>');">위원회 안건 상정</div>
			<%
				}else if(statecd.equals("CMIN")){
			%>
			<div class="buttonShape" onclick="gian('<%=statecd%>');">공포상신</div>
			<%
				}
			%>
			<div class="buttonPoll">|</div>
			<div class="buttonShape" onclick="goList();">목록</div>
			<div class="buttonPoll">|</div>
			<div class="buttonShape" onclick="goWrite();">수정</div>
			<div class="buttonPoll">|</div>
			<div class="buttonShape" onclick="writeOpinion('','<%=commissionid%>', 'W');">의견등록</div>
			<div style="display:none" class="buttonPoll">|</div>
			<div style="display:none" class="buttonShape" onclick="writeOpinion('<%=COPINIONID %>','<%=commissionid%>', 'C');">위원장확인</div>
			<div style="display:none" class="buttonPoll">|</div>
			<div style="display:none" class="buttonShape" onclick="writeOpinion('','<%=commissionid%>', 'G');">간사확인</div>
			<div style="display:none" class="buttonPoll">|</div>
			<div style="display:none" class="buttonShape" onclick="writeOpinion('<%=NOPINIONID %>','<%=commissionid%>', 'N');">노동조합지부장확인</div>
		</div>
	</div>