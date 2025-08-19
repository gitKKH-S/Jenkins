<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@	page import="java.util.*"%>
<%
	HashMap agreeInfo = request.getAttribute("agreeInfo")==null?new HashMap():(HashMap)request.getAttribute("agreeInfo");
	List faresultlist = request.getAttribute("faresultlist")==null?new ArrayList():(ArrayList)request.getAttribute("faresultlist");
	String ngbn = request.getParameter("ngbn")==null?"":request.getParameter("ngbn");
	System.out.println("DDDDD"+ngbn);
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script>
	function resultSave(){
		if(confirm("등록 하시겠습니까?")){
			var frm = document.wform;
			$.ajax({
                type:"POST",
                url : "${pageContext.request.contextPath}/web/agree/resultSave.do",
                data : $('#wform').serializeArray(),
                dataType: "json",
                async: false,
                success : function(result){
                    if(result.data.msg =='ok'){
                    	for (var i = 0; i < fileList.length; i++) 
    		            {
    		            	var formData = new FormData();
    		            	formData.append('file'+i, fileList[i]);
    		            	formData.append('gbnid',result.data.agreeid);
    		            	
    		            	var other_data = $('#wform').serializeArray();
                            $.each(other_data,function(key,input){
                            	if(input.name != 'agreeid'){
                            		formData.append(input.name,input.value);
                            	}
                            });
    		            	var status = statusList[i];
    		            	
    		            	var uploadURL = "${pageContext.request.contextPath}/web/agree/fileUpload.do"; //Upload URL
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
                    	alert('협약결과가 등록 되었습니다.');
                    	opener.agreeView();
        				window.close();
                    }else{
                        alert(result.data.msg);
                    }
                }
            })
		}
		
	}
</script>
<form name="wform" id="wform" method="post" action="${pageContext.request.contextPath}/web/agree/agreeSave.do">
<input type="hidden" name="agreeid" id="agreeid" value="<%=agreeInfo.get("AGREEID")==null?"":agreeInfo.get("AGREEID")%>"/>
<input type="hidden" name="filegbn"  value="result">
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">협약체결 결과</strong>
		</div>
		<div class="subBtnC right" id="test">
		 	<a href="#none" class="sBtn type1" onclick="javascript:resultSave();">저장</a>
		</div>
	</div>	
	<div class="innerB" >
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width:15%;">
				<col style="width:80%;">
			</colgroup>
			<tr>
				<th>협약기관</th>
				<td><input type="text" name="organ" style="width:100%" value="<%=agreeInfo.get("ORGAN") %>"/></td>
			</tr>
			<tr>
				<th>체결일</th>
				<td><input type="text" class="datepick" name="agreedt" value="<%=agreeInfo.get("AGREEDT")==null?"":agreeInfo.get("AGREEDT") %>"/></td>
			</tr>
			<tr>
				<th>추진사항</th>
				<td>
					<textarea id="chujin" name="chujin" rows="5" cols=""><%=agreeInfo.get("CHUJIN")==null?"":agreeInfo.get("CHUJIN") %></textarea>
				</td>
			</tr>
			<tr>
				<th>평가결과</th>
				<td>
					<textarea id="result" name="result" rows="5" cols=""><%=agreeInfo.get("RESULT")==null?"":agreeInfo.get("RESULT") %></textarea>
				</td>
			</tr>
			<tr>
				<th>개선방안</th>
				<td>
					<textarea id="prehyup" name="prehyup" rows="5" cols=""><%=agreeInfo.get("PREHYUP")==null?"":agreeInfo.get("PREHYUP") %></textarea>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
					<div id="fileUpload" class="dragAndDropDiv" <%if(faresultlist.size()>0){ %>style="width:50%"<%} %>>
					<input type="file" multiple style="display:none" id="filesel"/>
				    <label for="filesel"><strong>업로드할 파일을 선택 하세요.</strong></label>
				    <label for="filesel">(드래그앤드롭으로 파일 첨부가 가능합니다)</label>
				</div>
				<div class="hkk"></div>
				<div class="hkk2" style="width:49%;">
					<%
						for(int i=0; i<faresultlist.size(); i++){
							HashMap result = (HashMap)faresultlist.get(i);
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