<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%
	String consultid = request.getParameter("consultid")==null?"":request.getParameter("consultid");
	String consultantid = request.getParameter("consultantid")==null?"":request.getParameter("consultantid");
	String lawfirmid = request.getParameter("lawfirmid")==null?"":request.getParameter("lawfirmid");
	String chckid = request.getParameter("chckid")==null?"":request.getParameter("chckid");
	
	HashMap Consultant = request.getAttribute("getConsultant")==null?new HashMap():(HashMap)request.getAttribute("getConsultant");
	HashMap LawyerAccountInfo = request.getAttribute("getLawyerAccountInfo")==null?new HashMap():(HashMap)request.getAttribute("getLawyerAccountInfo");
	List consultLawyerList = request.getAttribute("consultLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("consultLawyerList");
	List fconsultlist = request.getAttribute("filelist")==null?new ArrayList():(ArrayList)request.getAttribute("filelist");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	
	String consultantcost =""; 
	String bankname ="";
	String account ="";
	String accountowner ="";
	if(Consultant!=null && Consultant.size()>0){
		consultantcost = Consultant.get("CONSULTANTCOST")==null?"":Consultant.get("CONSULTANTCOST").toString(); 
		bankname = Consultant.get("BANKNAME")==null?"":Consultant.get("BANKNAME").toString();
		account = Consultant.get("ACCOUNT")==null?"":Consultant.get("ACCOUNT").toString();
		accountowner = Consultant.get("ACCOUNTOWNER")==null?"":Consultant.get("ACCOUNTOWNER").toString();
		
		DecimalFormat df = new DecimalFormat("#,##0");
		consultantcost = consultantcost.equals("") ? "":df.format(Double.parseDouble(consultantcost));
	}else if(LawyerAccountInfo!=null && LawyerAccountInfo.size()>0){
		bankname = LawyerAccountInfo.get("BANKNAME")==null?"":LawyerAccountInfo.get("BANKNAME").toString();
		account = LawyerAccountInfo.get("ACCOUNT")==null?"":LawyerAccountInfo.get("ACCOUNT").toString();
		accountowner = LawyerAccountInfo.get("ACCOUNTOWNER")==null?"":LawyerAccountInfo.get("ACCOUNTOWNER").toString();
	}
%>

<style>

</style>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
$(document).ready(function(){
	$("#savebtn").click(function(){
		if(confirm("등록 하시겠습니까?")){
			var frm = document.wform;
			var cost = frm.consultantcost.value;
			cost = removeComma(cost);
			
			var chkCost = /^[0-9]*$/;
			if (!(chkCost.test(cost))) {
				alert('자문료는 숫자만 입력할 수 있습니다.');
				frm.consultantcost.value = "";
				frm.consultantcost.focus();
				return false;
			}
			frm.consultantcost.value = cost;
			$.ajax({
                type:"POST",
                url : "${pageContext.request.contextPath}/web/consult/outerconsultantcost4Ajax.do",
                data : $('#wform').serializeArray(),
                dataType: "json",
                async: false,
                success : function(result){
                    if(result.data.msg =='ok'){
                    	for (var i = 0; i < fileList.length; i++) 
    		            {
    		            	var formData = new FormData();
    		            	formData.append('file'+i, fileList[i]);
    		            	formData.append('gbnid',result.data.consultantid);
    		            	
    		            	var other_data = $('#wform').serializeArray();
                            $.each(other_data,function(key,input){
                            	if(input.name != 'consultantid'){
                            		formData.append(input.name,input.value);
                            	}
                            });
    		            	var status = statusList[i];
    		            	
    		            	var uploadURL = "${pageContext.request.contextPath}/web/consult/fileUploadconsult.do"; //Upload URL
    			            var extraData ={}; //Extra Data.
    			            var jqXHR=$.ajax({
    			                    xhr: function() {
    			                    var xhrobj = $.ajaxSettings.xhr();
    			                    if (xhrobj.upload) {
    			                            xhrobj.upload.addEventListener('progress', function(event) {
    			                                var percent = 0;
    			                                var position = event.loaded || event.position;
    			                                var total = event.total;
    			                                if (event.lengthComputable) {
    			                                    percent = Math.ceil(position / total * 100);
    			                                }
    			                                status.setProgress(percent);
    			                            }, false);
    			                        }
    			                    return xhrobj;
    			                },
    			                url: uploadURL,
    			                type: "POST",
    			                contentType:false,
    			                processData: false,
    			                cache: false,
    			                data: formData,
    			                async: false,
    			                success: function(data){
    			                	status.setProgress(100);
    			                    //$("#status1").append("File upload Done<br>");           
    			                }
    			            }); 
    			            status.setAbort(jqXHR);
    		            }
                    	alert("저장되었습니다.");
                		opener.gotoview();
                		window.close();
                    }else{
                        alert(result.data.msg);
                    }
                }
            })
		}
	});
	
	$("#setlawyer").change(function(){
		$("#LAWFIRMID").val($(this).val());
		$("#LAWYERID").val($("#setlawyer option:selected").attr("vo1"));
		$("#LAWYERNM").val($("#setlawyer option:selected").attr("vo2"));
		$("#OFFICE").val($("#setlawyer option:selected").text());

	})
});
// 자문료 액수 3자리마다 콤마 처리
function costComma(consultantcost) {
	var costv = consultantcost.value;
	
	costv = removeComma(costv);
	
	costv = insertComma(costv);
	
	consultantcost.value = costv;
}
function removeComma(remove) { // 콤마 및 숫자가 아닌 입력 제거
	var rgxNum = /[^0-9]/g;
	remove = remove.replace(rgxNum, '');
	
	return remove;
}
function insertComma(insert) {
	var rgxComma = /([0-9]+)([0-9]{3})/;
	while (rgxComma.test(insert)) {
		insert = insert.replace(rgxComma, '$1'+','+'$2');
	}
	
	return insert;
}
</script>
<form name="wform" id="wform" method="post" action="${pageContext.request.contextPath}/web/consult/outerconsultantcost4Ajax.do">
<input type="hidden" name="consultid" id="consultid" value="<%=consultid%>"/>
<input type="hidden" name="consultantid" id="consultantid" value="<%=consultantid%>"/>
<input type="hidden" name="chckid" id="chckid" value="<%=chckid%>"/>
<input type="hidden" name="lawfirmid" id="lawfirmid" value="<%=lawfirmid%>"/>
<input type="hidden" id="lawyerid" name="lawyerid" value="<%=lawfirmid%>"/>
<input type="hidden" name="filegbn"  value="lwcost">
<input type="hidden" id="LAWFIRMID" name="LAWFIRMID">
<input type="hidden" id="LAWYERID" name="LAWYERID">
<input type="hidden" id="LAWYERNM" name="LAWYERNM">
<input type="hidden" id="OFFICE" name="OFFICE">
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">자문료 청구</strong>
		</div>
		<div class="subBtnC right" id="test">
			<%
			if(GRPCD.indexOf("Y")>-1){
			%>
				<select id="setlawyer">
					<%
					for(int i=0; i<consultLawyerList.size(); i++){
						HashMap re = (HashMap)consultLawyerList.get(i);
					%>
					<option value="<%=re.get("LAWFIRMID") %>" vo1="<%=re.get("LAWYERID") %>" vo2="<%=re.get("LAWYERNM") %>"><%=re.get("OFFICE") %></option>
					<%
					}
					%>
				</select>
			<%	
			}
			%>
		 	<a href="#none" class="sBtn type1" id="savebtn">저장</a>
		</div>
	</div>	
	<div class="innerB" >
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width:20%;">
				<col style="width:70%;">		
			</colgroup>
			<tr>
				<th>자문료</th>
				<td><input id="consultantcost" name="consultantcost" type="text" value="<%=consultantcost%>" onkeyup="costComma(this)" onchange="costComma(this)" /></td>
			</tr>
			<tr>
				<th>은행</th>
				<td><input id="bankname" name="bankname" type="text"  value="<%=bankname%>"/></td>
			</tr>
			<tr>
				<th>계좌번호</th>
				<td><input id="account" name="account" type="text"  value="<%=account%>"/></td>
			</tr>
			<tr>
				<th>예금주</th>
				<td><input id="accountowner" name="accountowner" type="text"  value="<%=accountowner%>"/></td>
			</tr>
			<tr>
				<th>첨부파일<br/>(청구서<br/>사업자등록증<br/>통장사본<br/>세금계산서)</th>
				<td>
					<div id="fileUpload" class="dragAndDropDiv" <%if(fconsultlist.size()>0){ %>style="width:50%"<%} %>>
						<input type="file" multiple style="display:none" id="filesel"/>
						<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						<label for="filesel">(드래그 앤 드롭으로 파일 첨부가 가능합니다.)</label>
					</div>
					<div id="fileList">
						<input type="hidden" />
					</div>
					<div id="hkk" class="hkk"></div>
					<div class="hkk2" style="width:49%;">
						<%
							for(int i=0; i<fconsultlist.size(); i++){
								HashMap result = (HashMap)fconsultlist.get(i);
						%>
						<div class="statusbar odd">
							<div class="filename" style='width:80%'><%=result.get("VIEWFILENM") %></div><div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILEID") %>"/>　삭제</div>
						</div>
						<%
							}
						%>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
</form>