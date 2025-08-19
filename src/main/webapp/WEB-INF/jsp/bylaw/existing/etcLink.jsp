<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mten.bylaw.*" %>
<%@ page import="com.mten.bylaw.bylaw.service.*" %>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>

<%
	String docid = ServletRequestUtils.getStringParameter(request, "docid", "");
	String active = ServletRequestUtils.getStringParameter(request, "active", "");

	BylawService bylawService = BylawServiceHelper.getBylawService(application);
	
	
	List bList = bylawService.selectDocList();
	HashMap para = new HashMap();
	para.put("linkgbn", "RULE");
	para.put("docid", docid);
	List elList = bylawService.etcLinkSelect2(para);
%>

<link href="${resourceUrl}/select2-4.0.1/dist/css/select2.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/jquery.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/dist/js/select2.full.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/prettify.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/placeholders.jquery.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/dist/js/i18n/es.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/dist/js/select2.js"></script> 
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.form.js"></script>
<script> 
$(document).ready(function() { 
	$("#ehkk").select2(); 
	$("#ehkk2").select2(); 
}); 
function getJoMun(obj){
	$('#ehkk2').empty();
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/bylaw/adm/getJoMunList.do",
		data : {
			bookid : obj.value,
			docgbn : 'RULE'
		},
		dataType: "json",
		async: false,
		success : function(data) {
			var option = "<option value=\"\">:::관련조문선택:::</option>";
			$('#ehkk2').append(option);
			for(var i=0; i<data.length; i++){
				if(data[i].subjono==0){
					option = "<option value='"+ data[i].contid+","+data[i].jono+","+data[i].subjono+","+data[i].title+"'>제"+data[i].jono +"조 ("+ data[i].title + ")</option>";	
				}else{
					option = "<option value='"+ data[i].contid+","+data[i].jono+","+data[i].subjono+","+data[i].title+"'>제"+data[i].jono +"조의"+data[i].subjono+" ("+ data[i].title + ")</option>";
				}
		        $('#ehkk2').append(option);
			}
		}
	});
}
function getJoMun2(obj){
	if(obj.value!=''){
		var vls = obj.value.split(',');
        $("#bookid").val($("#ehkk").val());
        $("#contid").val(vls[0]);
        $("#jono").val(vls[1]);
        $("#josubno").val(vls[2]);
        $("#title").val(vls[3]);
    }
}
function goSave(){
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/bylaw/adm/ectLinkInsert.do",
		data : {
			linkgbn : $("#linkgbn").val(),
			docid : $("#docid").val(),
			bookid : $("#bookid").val(),
			contid : $("#contid").val(),
			jono : $("#jono").val(),
			josubno : $("#josubno").val(),
			title : $("#title").val(),
			active : $("#active").val()			
		},
		dataType: "json",
		async: false,
		success : function(data) {
			location.href="${pageContext.request.contextPath}/bylaw/adm/etcLink.do?docid=<%=docid%>"
		}
	});
}
function goDelete(key,key1){
	var frm = document.fView;
	$("#linkid").val(key);
	$("#bookid").val(key1);
	frm.action = "${pageContext.request.contextPath}/bylaw/adm/ectLinkDeleteB.do";
	frm.submit();
}
</script> 
</head>
<form name="fView" method="post">
	<input type="hidden" name="linkgbn" id="linkgbn" value="RULE"/>
	<input type="hidden" name="docid" id="docid" value="<%=docid%>"/>
	<input type="hidden" name="bookid" id="bookid"/>
	<input type="hidden" name="contid" id="contid"/>
	<input type="hidden" name="jono" id="jono"/>
	<input type="hidden" name="josubno" id="josubno"/>
	<input type="hidden" name="title" id="title"/>
	<input type="hidden" name="linkid" id="linkid"/>
	<input type="hidden" name="active" id="active" value="Y"/>			
</form>	
	
	<div class="subCC" style="overflow:auto;overflow-x:no;">
		<div class="tableW">
		<table class="infoTable">
			<colgroup>
				<col style="width:20%;">
				<col style="width:80%;">
			</colgroup>
			<tr style="height:40px">
				<th>관련규정설정</th>
				<td>
					<select name="docList"  id="ehkk" style="width:205px" onchange="getJoMun(this);">
						<option value="">:::관련규정선택:::</option>
						<%
							for(int i=0; i<bList.size(); i++){
								HashMap re = (HashMap)bList.get(i);
						%>
						<option value="<%=re.get("BOOKID")%>"><%=re.get("TITLE")%></option>
						<%
							}
						%>
					</select>
					
					<select name="joList"  id="ehkk2" style="width:205px" onchange="getJoMun2(this);">
						<option value="">:::관련조문선택:::</option>
					</select>
				</td>
			</tr>
			<tr style="height:220px">
				<th>관련규정</th>
				<td>
					<ul>
					<%
					for(int i=0; i<elList.size(); i++){
						HashMap re = (HashMap)elList.get(i);
						String booktitle = re.get("BOOKTITLE").toString();
						String jono = re.get("JONO").toString();
						String josubno = re.get("JOSUBNO").toString();
						String title = "("+re.get("TITLE").toString()+")";
						String mtitle = "";
						String lurl = "";
						if(josubno.equals("0")){
							mtitle = booktitle + " / " + jono + "조"+title+"";
							lurl = "/web/regulation/regulationViewPop.do?noformyn=N&bookid="+re.get("BOOKID")+"#bon"+re.get("JONO");
						}else{
							mtitle = booktitle + " / " + jono + "조의 "+josubno+title;
							lurl = "/web/regulation/regulationViewPop.do?noformyn=N&bookid="+re.get("BOOKID")+"#bon"+re.get("JONO")+"bu"+josubno;
						}
					%>
						<li><a href = "${pageContext.request.contextPath}<%=lurl %>" target="_blank"><%=mtitle %></a>
							&nbsp;&nbsp;<span style="color:red;cursor:pointer" onclick="goDelete('<%= re.get("LINKID")%>','<%= re.get("BOOKID")%>');">[링크삭제]</span>
						</li>
					<%
					}
					%>
					</ul>
				</td>
			</tr>
		</table>
		</div>
		<hr class="margin10">
		<div class="tableOverW">
			<div class="alignR">	
				<a href="#" id="mten_button" class="btnStyle2 midBlue" onclick="goSave()">규정연동저장</a>
			</div>
		</div>
	</div>
