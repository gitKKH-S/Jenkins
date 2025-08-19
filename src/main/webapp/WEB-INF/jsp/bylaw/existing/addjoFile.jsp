<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>

<%
	String docid = ServletRequestUtils.getStringParameter(request, "Bookid", "");
	String statehistoryid = ServletRequestUtils.getStringParameter(request, "statehistoryid", "");
	String noFormYn = ServletRequestUtils.getStringParameter(request, "noFormYn", "");
	
	Map<String, StringBuffer> selectboxs = request.getAttribute("selectboxs")==null?new HashMap():(Map)request.getAttribute("selectboxs");
	StringBuffer CONTGBN = selectboxs.get("CONTGBN");
%>

<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/jquery.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/select2-4.0.1/docs/vendor/js/placeholders.jquery.min.js"></script>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.form.js"></script>
<script src="${resourceUrl}/js/mten.fileupload2.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script> 
$(document).ready(function() { 
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/bylaw/adm/getJoMunList.do",
		data : {
			bookid : '<%=docid%>',
			docgbn : 'RULE'
		},
		dataType: "json",
		async: false,
		success : function(data) {
			var option = "";
			$('#ehkk2').append(option);
			for(var i=0; i<data.length; i++){
				if(data[i].subjono==0){
					option = "<option style='margin: 10px;' value='"+ data[i].contid+","+data[i].jono+","+data[i].subjono+","+data[i].title+"'>제"+data[i].jono +"조 ("+ data[i].title + ")</option>";	
				}else{
					option = "<option style='margin: 10px;' value='"+ data[i].contid+","+data[i].jono+","+data[i].subjono+","+data[i].title+"'>제"+data[i].jono +"조의"+data[i].subjono+" ("+ data[i].title + ")</option>";
				}
		        $('#ehkk2').append(option);
			}
		}
	});
	
	$("#fsave").click(function(){
		if(confirm("등록 하시겠습니까?")){
			$("#PDFFILE").val($("#CONTGBN").val());
			for (var i = 0; i < fileList.length; i++) 
            {
            	var formData = new FormData();
            	formData.append('file'+i, fileList[i]);
            	
            	var other_data = $('#fView').serializeArray();
                $.each(other_data,function(key,input){
               		formData.append(input.name,input.value);
                });
            	var status = statusList[i];
            	
            	var uploadURL = "${pageContext.request.contextPath}/bylaw/adm/ContfileUpload.do"; //Upload URL
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
           	var hkk = $(".hkk").empty();
           	//getJoMun2(document.all.joList);
           	location.href = "${pageContext.request.contextPath}/bylaw/adm/addjoFile.do?Bookid=<%=docid%>&noFormYn=<%=noFormYn%>&statehistoryid=<%=statehistoryid%>";
		}
	});
}); 
function getJoMun2(obj){
	if(obj.value!=''){
		var vls = obj.value.split(',');
        $("#CONTID").val(vls[0]);

        $.ajax({
    		type : "POST",
    		url : "${pageContext.request.contextPath}/bylaw/adm/selectContFile.do",
    		data : {
    			bookid : '<%=docid%>',
    			statehistoryid : '<%=statehistoryid%>',
    			contid : $("#CONTID").val(),
    			revcd : 'CONT'
    		},
    		dataType: "json",
    		async: false,
    		success : function(data) {
    			var hkk = $(".hkk2").empty();
    			for(i=0; i<data.length; i++){
    				$("<div class='statusbar odd'><div class='filename' style='width:375px'>["+data[i].PDFFILE+"]"+data[i].PCFILENAME+"　　</div><div class='abort' onclick=\"del('"+data[i].FILEID+"\')\">삭제</div></div>").appendTo(hkk);
    			}
    		}
    	});
    }
}
function del(key){
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/bylaw/adm/ContFileDelete.do",
		data : {
			fileid : key
		},
		dataType: "json",
		async: false,
		success : function(data) {
			getJoMun2(document.all.joList);
		}
	});
	
}
</script> 
</head>
<form name="fView" id="fView" method="post">
	<input type="hidden" name="linkgbn" id="linkgbn" value="RULE"/>
	<input type="hidden" name="docid" id="docid" value="<%=docid%>"/>
	<input type="hidden" name="bookid" id="bookid" value="<%=docid%>"/>
	<input type="hidden" name="Bookid" id="Bookid" value="<%=docid%>"/>
	<input type="hidden" name="BOOKID" id="BOOKID" value="<%=docid%>"/>
	<input type="hidden" name="noFormYn" id="noFormYn" value="<%=noFormYn%>"/>
	<input type="hidden" name="statehistoryid" id="statehistoryid" value="<%=statehistoryid%>"/>
	<input type="hidden" name="STATEHISTORYID" id="STATEHISTORYID" value="<%=statehistoryid%>"/>
	<input type="hidden" name="PDFFILE" id="PDFFILE"/>
	<input type="hidden" name="CONTID" id="CONTID"/>
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
			<tr>
				<th>
					<select name="joList"  id="ehkk2" style="width:305px" size="32" onchange="getJoMun2(this);">
					</select>
				</th>
				<td valign="top">
					첨부문서 구분 : 
					<select id="CONTGBN">
						<%=CONTGBN %>
					</select>
					<div id="fileUpload" style="width:97%" class="dragAndDropDiv" >
						<input type="file" multiple style="display:none" id="filesel"/>
					    <label for="filesel"><strong>업로드할 파일을 선택 하세요.</strong></label>
					</div>
					<div class="hkk2" style="background-color:#fff">
						
					</div>
					<div class="hkk" style="background-color:#fff"></div>
				</td>
			</tr>
		</table>
		<div style="margin-left:700px;"><button id="fsave">저장</button></div>
		</div>
	</div>
