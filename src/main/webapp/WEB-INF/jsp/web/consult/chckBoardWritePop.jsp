<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%
	HashMap chck = request.getAttribute("chck")==null?new HashMap():(HashMap)request.getAttribute("chck");
	List fconsultlist = request.getAttribute("filelist")==null?new ArrayList():(ArrayList)request.getAttribute("filelist");
	List consultLawyerList = request.getAttribute("consultLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("consultLawyerList");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	
	String LAWFIRMID = "";
	String LAWYERID  = "";
	String LAWYERNM  = "";
	String OFFICE    = "";
	
	if("X".equals(GRPCD)) {
		for(int i=0; i<consultLawyerList.size(); i++) {
			HashMap lawMap = (HashMap)consultLawyerList.get(i);
			String RVW_TKCG_EMP_NO = lawMap.get("RVW_TKCG_EMP_NO").toString();
			if (USERNO.equals(RVW_TKCG_EMP_NO)) {
				LAWFIRMID = lawMap.get("LAWFIRMID").toString();
				LAWYERID  = lawMap.get("LAWYERID").toString();
				LAWYERNM  = lawMap.get("LAWYERNM").toString();
				OFFICE    = lawMap.get("OFFICE").toString();
			}
		}
	}
	
	String consultid = request.getParameter("consultid")==null?"":request.getParameter("consultid");
	String chckid = request.getParameter("chckid")==null?"":request.getParameter("chckid");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
$(document).ready(function(){
	$("#savebtn").click(function(){
		if(confirm("등록 하시겠습니까?")){
			var frm = document.wform;
			$.ajax({
                type:"POST",
                url : "${pageContext.request.contextPath}/web/consult/chckSave.do",
                data : $('#wform').serializeArray(),
                dataType: "json",
                async: false,
                success : function(result){
                    if(result.data.msg =='ok'){
                    	for (var i = 0; i < fileList.length; i++) 
    		            {
    		            	var formData = new FormData();
    		            	formData.append('file'+i, fileList[i]);
    		            	formData.append('gbnid',result.data.chckid);
    		            	
    		            	var other_data = $('#wform').serializeArray();
                            $.each(other_data,function(key,input){
                            	if(input.name != 'chckid'){
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
<%
						if("X".equals(GRPCD)){
%>
						opener.goList();
<%
						}else{
%>
                		opener.gotoview();
<%
						}
%>
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

</script>
<form name="wform" id="wform" method="post" action="${pageContext.request.contextPath}/web/consult/chckSave.do">
<input type="hidden" name="consultid" id="consultid" value="<%=consultid%>"/>
<input type="hidden" name="chckid" id="chckid" value="<%=chckid%>"/>
<input type="hidden" name="filegbn"  value="consultans">
<input type="hidden" id="LAWFIRMID" name="LAWFIRMID" value="<%=LAWFIRMID%>" />
<input type="hidden" id="LAWYERID"  name="LAWYERID"  value="<%=LAWYERID%>" />
<input type="hidden" id="LAWYERNM"  name="LAWYERNM"  value="<%=LAWYERNM%>" />
<input type="hidden" id="OFFICE"    name="OFFICE"    value="<%=OFFICE%>" />
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">검토의견 글쓰기</strong>
		</div>
		<div class="subBtnC right" id="test">
			<%
			if((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1) && consultLawyerList.size()>0){
			%>
				<select id="setlawyer">
					<option>답변 법인을 선택하기 바랍니다.</option>
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
				<col style="width:15%;">
				<col style="width:80%;">	
			</colgroup>
			<tr>
				<th>작성자</th>
				<td>
					<div style="float: left;">
						<%=USERNAME %>
					</div>
				</td>
			</tr>
			<tr>
				<th>주요의견</th>
				<td>
					<textarea id="chckconts" name="chckconts" rows="10" cols=""><%=chck.get("CHCKCONTS")==null?"":chck.get("CHCKCONTS") %></textarea>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
					<div style='color:red;'>※(필수) 파일첨부시 직인 찍힌 원본(PDF 파일)과 사본(HWP 파일)를 같이 등록하시기 바랍니다. </div>
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
							<div class="filename" style='width:80%'>
								<%=result.get("VIEWFILENM") %> (<%=result.get("VIEW_SZ").toString()%>)
							</div>
							<div class="abort">
								<input type="checkbox" name="delfile[]" value="<%=result.get("FILEID") %>"/>　삭제
							</div>
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