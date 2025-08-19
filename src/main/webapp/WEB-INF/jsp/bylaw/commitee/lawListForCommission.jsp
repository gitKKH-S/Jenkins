<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	List result = request.getAttribute("info")==null?new ArrayList():(List)request.getAttribute("info");
	
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	String lawList = param.get("lawList")==null?"":param.get("lawList").toString();
%>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/commission.css" />
<script>
	function goView(commissionid){
		location.href="commissionView.do?commissionid="+commissionid;
	}		
	function sendToParent(){
		var frm = document.frm;
		var lawInfo;
		chkBox = frm.lawChk;
		if (chkBox.length){				
			for(var i=0; i<chkBox.length;i++){
				if (chkBox[i].checked){
					if (lawInfo){
						lawInfo += '@@'+chkBox[i].value;
					}else{
						lawInfo =	chkBox[i].value;
					}
				}
			}
		}else{
			lawInfo =	chkBox.value;
		}
		parent.content.getBookIds(lawInfo);
		parent.hideLawWin();
	}
	function checkAll(){
		var frm = document.frm;
		chkBox = frm.lawChk;
		if (chkBox.length){
			for(var i=0; i<chkBox.length;i++){
				if (frm.allChk.checked){
					chkBox[i].checked = true;
				}else{
					chkBox[i].checked = false;
				}
			}
		}else{
			if (frm.allChk.checked){
				chkBox.checked = true;
			}else{
				chkBox.checked = false;
			}
		}
	}
</script>	
	</head>
	
	<body style="margin:10px;height:95%;">
	
		<div class="button_register"> 
			<img src="${resourceUrl}/images/commitee/button_register.png" width="57" height="20" alt="등록" style="cursor:pointer;" onclick="sendToParent();">
		</div>
		
		
		<form name="frm" method="post"> 
			<table border="0" cellpadding="0" cellspacing="0"  class="basic">
			  <thead class="thead">
			    <tr class="thead_bg">
			    	<th style="text-align:left; width:10px;">
			    		<img src="${resourceUrl}/images/commitee/list_bar_left.gif" width="4" height="35">
			    	</th>
			    	<th style="text-align:center;">번호</th> 
			    	<th style="text-align:center;">규정명</th>
			    	<th style="text-align:center;">개정차수</th>
			    	<th style="text-align:center;">제/개정</th>
			    	<th style="text-align:center;"><input type="checkbox" name="allChk" onclick="checkAll();"/></th>
			    	<th style="text-align:right;width:10px;">
			    		<img src="${resourceUrl}/images/commitee/list_bar_right.gif" width="4" height="35">
			    	</th>
			    </tr>
			  </thead>
			
			  <tbody>  
			  
				  <% for(int i=0; i<result.size(); i++){
					 HashMap resultMap = (HashMap)result.get(i); 
				  %>
				  
				    <tr <%if (i%2==1){out.print("class=\"tbody_list_bg02\"");} %> ">
				    	<td></td>
				    	<td style="text-align:center;"><%=i+1%></td>
				    	<td style="text-align:center;"><%=resultMap.get("TITLE") %></td>
				    	<td style="text-align:center;"><%=resultMap.get("REVCHA") %></td>
				    	<td style="text-align:center;"><%=resultMap.get("REVCD") %></td>
				    	<th style="text-align:center;"><input type="checkbox" name="lawChk" id="<%=resultMap.get("BOOKID")%>" value="<%=resultMap.get("BOOKID")+"#"+resultMap.get("TITLE")+"#"+resultMap.get("REVCHA")+"#"+resultMap.get("REVCD") %>"/></th>
				    	<td> </td>
				    </tr>
				  <%} %>
				  
				  <%if (result.size()==0){ %>
				    <tr>
				    	<td colspan="7">조회 결과가 없습니다.</td>
				    </tr>			  	
				  <%} %>
			
			  </tbody>
			</table>
		</form>		
</body>
<script>
	var lawList = '<%=lawList%>';
	if (lawList){
		var list = lawList.split('@@');
		for (var i=0; i<list.length; i++){
			document.getElementById(list[i]).checked=true;
		}
	}
</script>
</html>