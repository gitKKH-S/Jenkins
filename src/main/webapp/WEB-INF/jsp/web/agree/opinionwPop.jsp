<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@	page import="java.util.*"%>
<%
	HashMap agreeInfo = request.getAttribute("agreeInfo")==null?new HashMap():(HashMap)request.getAttribute("agreeInfo");
	List oagreeflist = request.getAttribute("oagreeflist")==null?new ArrayList():(ArrayList)request.getAttribute("oagreeflist");
%>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	.filesize{
		width:15%;
	}
	
	.progressBar{
		width:64px;
	}
</style>
<script>
	function opinionSave(){
		if(confirm("등록 하시겠습니까?")){
			var frm = document.wform;
			$.ajax({
                type:"POST",
                url : "${pageContext.request.contextPath}/web/agree/opinionSave.do",
                data : $('#wform').serializeArray(),
                dataType: "json",
                async: false,
                success : function(result){
                    if(result.data.msg =='ok'){
                    	for (var i = 0; i < fileList.length; i++) 
    		            {
    		            	var formData = new FormData();
    		            	formData.append('file'+i, fileList[i]);
    		            	formData.append('gbnid',$("#agreeid").val());
    		            	
    		            	var other_data = $('#wform').serializeArray();
                            $.each(other_data,function(key,input){
                            	formData.append(input.name,input.value);
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
                    	alert("저장되었습니다.");
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
<input type="hidden" name="filegbn"  value="oagree">
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">송무팀 검토 의견</strong>
		</div>
		<div class="subBtnC right" id="test">
		 	<a href="#none" class="sBtn type1" onclick="javascript:opinionSave();">저장</a>
		</div>
	</div>	
	<div class="innerB" >
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width:12%;">
				<col style="width:23%;">
				<col style="width:10%;">
				<col style="width:23%;">
				<col style="width:10%;">
				<col style="width:22%;">
			</colgroup>
			<tr>
				<th>의뢰부서</th>
				<td>
					<%=agreeInfo.get("DEPTNAME") %>
				</td>
				
				<th>의뢰인</th>
				<td>
					<div style="float: left;">
						<%=agreeInfo.get("WRITER") %>
					</div>
				</td>
				
				<th>연락처</th>
				<td>
					<%=agreeInfo.get("PHONE") %>
				</td>
			</tr>
			<tr>
				<th>검토의견</th>
				<td colspan="5">
					<textarea id="opinion" name="opinion" rows="10" cols=""><%=agreeInfo.get("OPINION")==null?"":agreeInfo.get("OPINION") %></textarea>
				</td>
			</tr>
			<tr>
				<th>파일첨부</th>
				<td colspan="5">
					<div id="fileUpload" class="dragAndDropDiv" <%if(oagreeflist.size()>0){ %>style="width:50%"<%} %>>
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
							for(int i=0; i<oagreeflist.size(); i++){
								HashMap result = (HashMap)oagreeflist.get(i);
						%>
						<div class="statusbar odd">
							<div class="filename" style='width:70%'><%=result.get("VIEWFILENM") %></div><div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILEID") %>"/>　삭제</div>
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