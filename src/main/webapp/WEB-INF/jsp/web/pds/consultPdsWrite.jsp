<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.LocalDate"%>
<%
	HashMap pdsBon = request.getAttribute("pdsBon")==null?new HashMap():(HashMap)request.getAttribute("pdsBon");
	System.out.println(pdsBon);
	HashMap bon = pdsBon.get("bon")==null?new HashMap():(HashMap)pdsBon.get("bon");
	List flist = pdsBon.get("flist")==null?new ArrayList():(ArrayList)pdsBon.get("flist");
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	
	String DBTOPBBSID = bon.get("UP_PST_MNG_NO")==null?"":bon.get("UP_PST_MNG_NO").toString();
	String UP_PST_MNG_NO = request.getParameter("UP_PST_MNG_NO")==null?"":request.getParameter("UP_PST_MNG_NO");
	String REYN = request.getParameter("REYN")==null?"":request.getParameter("REYN");
	
	String PST_MNG_NO = bon.get("PST_MNG_NO")==null?"":bon.get("PST_MNG_NO").toString();
	if(REYN.equals("Y")){
		PST_MNG_NO = "";
	}
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String WRTR_EMP_NM = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String WRTR_EMP_NO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String WRT_DEPT_NM = se.get("DEPTNAME")==null?"":se.get("DEPTNAME").toString();
	String WRT_DEPT_NO = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	
	// 의뢰서 작성시 등록일 위한 날짜 구하기
    LocalDate today = LocalDate.now();
    // 원하는 포맷 지정
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	//  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년MM월dd일");
    String WRT_YMD = today.format(formatter);
    
	if(bon!=null && bon.size()>0){
		WRT_YMD = bon.get("WRT_YMD")==null?"":bon.get("WRT_YMD").toString();
		WRTR_EMP_NO = bon.get("WRTR_EMP_NO")==null?"":bon.get("WRTR_EMP_NO").toString();
		WRTR_EMP_NM = bon.get("WRTR_EMP_NM")==null?"":bon.get("WRTR_EMP_NM").toString();
		WRT_DEPT_NO = bon.get("WRT_DEPT_NO")==null?"":bon.get("WRT_DEPT_NO").toString();
		WRT_DEPT_NM = bon.get("WRT_DEPT_NM")==null?"":bon.get("WRT_DEPT_NM").toString();
	}
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	$(document).ready(function(){
		var oEditors = [];
		// 추가 글꼴 목록
		//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
// 		nhn.husky.EZCreator.createInIFrame({
// 			oAppRef: oEditors,
// 			elPlaceHolder: "ir1",
// 			sSkinURI: "${resourceUrl}/smarteditor/SmartEditor2Skin.html",	
// 			htParams : {
// 				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
// 				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
// 				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
// 				//bSkipXssFilter : true,		// client-side xss filter 무시 여부 (true:사용하지 않음 / 그외:사용)
// 				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
// 				fOnBeforeUnload : function(){
// 					//alert("완료!");
// 				}
// 			}, //boolean
// 			fOnAppLoad : function(){
// 				//var sHTML = result.content;
// 				//oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
// 			},
// 			fCreator: "createSEditor2"
// 		});
		
		$(".sBtn").click(function(){
			if(confirm("등록 하시겠습니까?")){
				var frm = document.wform;
// 				if(frm.PST_NTC_YN.checked){
// 					frm.PST_NTC_YN.value = "Y";
// 				}else{
// 					frm.PST_NTC_YN.value = "N";
// 				}
// 				if( $("#PST_MNG_NO").val()=='' && $("#REYN").val()!='Y'){
// 					$("#PST_TTL").val("["+$("#titlegbn").val()+"] "+$("#PST_TTL").val());
// 				}
// 				if( $("#REYN").val()=='Y' ){
// 					$("#PST_TTL").val("   [답변] "+$("#PST_TTL").val());
// 				}
// 				frm.PST_CN.value = oEditors.getById["ir1"].getIR();
				if($("#PST_TTL").val()==''){
					alert('회의건명을 입력하세요.');
					return;
				}
				$("#PST_MNG_NO").val('<%=PST_MNG_NO%>');
				$("#WRTR_EMP_NO").val('<%=WRTR_EMP_NO%>');
				$("#WRTR_EMP_NM").val('<%=WRTR_EMP_NM%>');
				$("#WRT_DEPT_NO").val('<%=WRT_DEPT_NO%>');
				$("#WRT_DEPT_NM").val('<%=WRT_DEPT_NM%>');
				$.ajax({
                    type:"POST",
                    url : "${pageContext.request.contextPath}/web/pds/pdsSave.do",
                    data : $('#wform').serializeArray(),
                    dataType: "json",
                    async: false,
                    success : function(result){
                        if(result.data.msg =='ok'){
                        	for (var i = 0; i < fileList.length; i++) 
        		            {
        		            	var formData = new FormData();
        		            	formData.append('file'+i, fileList[i]);
        		            	formData.append('PST_MNG_NO',result.data.PST_MNG_NO);
        		            	
        		            	var other_data = $('#wform').serializeArray();
	                            $.each(other_data,function(key,input){
	                            	if(input.name != 'PST_MNG_NO'){
	                            		formData.append(input.name,input.value);
	                            	}
	                            });
        		            	var status = statusList[i];
        		            	
        		            	var uploadURL = "${pageContext.request.contextPath}/web/pds/fileUpload.do"; //Upload URL
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
                    		frm.PST_MNG_NO.value = result.data.PST_MNG_NO;
                    		frm.action = "${pageContext.request.contextPath}/web/pds/pdsView.do";
                    		frm.submit();
                        }else{
                            alert(result.data.msg);
                        }
                    }
                })
			}
		});
	});
</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong></font>
	<div class="subBtnW side">
		<div class="subBtnC right">
			<a href="#" id="sBtn" class="sBtn type1">저장</a>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList">
			<div class="tableW">
				<form name="wform" id="wform" method="post" action="${pageContext.request.contextPath}/web/pds/pdsSave.do">
<!-- 					<input type="hidden" name="PST_CN" id="PST_CN"/> -->
					<input type="hidden" name="BBS_SE" id="BBS_SE" value="PDS"/>
					<input type="hidden" name="UP_PST_MNG_NO" id="UP_PST_MNG_NO" value="<%=UP_PST_MNG_NO%>"/>
					<input type="hidden" name="PST_MNG_NO" id="PST_MNG_NO" value="<%=PST_MNG_NO%>"/>
					<input type="hidden" name="REYN" id="REYN" value="<%=REYN%>"/>
					<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>">
					<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO"/>
					<input type="hidden" name="WRTR_EMP_NM" id="WRTR_EMP_NM"/>
					<input type="hidden" name="WRT_DEPT_NO" id="WRT_DEPT_NO"/>
					<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM"/>
					<table class="infoTable write">
						<colgroup>
							<col style="width:10%;">
							<col style="width:*;">
							<col style="width:10%;">
							<col style="width:*;">
							<col style="width:10%;">
							<col style="width:*;">
						</colgroup>
						<tr>
							<th>관리번호</th>
							<td>
								<input type="text" id="DOC_MNG_NO" name="DOC_MNG_NO" style="width:100%;" value="<%=bon.get("DOC_MNG_NO")==null?"":bon.get("DOC_MNG_NO")%>"/>
							</td>
							<th>등록자</th>
							<td>
								<input type="text" value="<%=WRTR_EMP_NM%>" style="width: 100%;" readonly="readonly" />
							</td>
							<th>등록일</th>
							<td>
								<input type="text" value="<%=WRT_YMD%>" style="width: 100%;" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<th>회의건명<sup><font color=red>*</font></sup></th>
							<td  colspan="5">
								<input type="text" id="PST_TTL" name="PST_TTL" value="<%=bon.get("PST_TTL")==null?"":bon.get("PST_TTL")%>" style="width:100%">
							</td>
						</tr>
<%-- 						<tr <%if(GRPCD.indexOf("Y")==-1)out.println("style='display:none;'"); %>> --%>
<!-- 							<th>상단 고정</th> -->
<!-- 							<td  colspan="5"> -->
<%-- 								<% --%>
<!-- // 									String PST_NTC_YN = bon.get("PST_NTC_YN")==null?"":bon.get("PST_NTC_YN").toString(); -->
<%-- 								%> --%>
<%-- 								<input type="checkbox" id="PST_NTC_YN" name="PST_NTC_YN" <%if(PST_NTC_YN.equals("Y"))out.println("checked"); %>> --%>
<!-- 							</td> -->
<!-- 						</tr> -->
						<tr>
							<th>회의개요</th>
							<td colspan="5"><textarea id="RMRK_CN" name="RMRK_CN" rows="8" cols="" style="width:100%;"><%=bon.get("RMRK_CN")==null?"":bon.get("RMRK_CN").toString().replaceAll("\n","<br/>")%></textarea></td>
						</tr>
						<tr>
							<th>회의안건</th>
							<td colspan="5"><textarea id="PST_CN" name="PST_CN" rows="8" cols="" style="width:100%;"><%=bon.get("PST_CN")==null?"":bon.get("PST_CN").toString().replaceAll("\n","<br/>")%></textarea></td>
						</tr>
						<tr>
							<th>처리상태</th>
							<td colspan="5">
								<input type="text" id="PRCS_STTS_SE_NM" name="PRCS_STTS_SE_NM" style="width:100%;" value="<%=bon.get("PRCS_STTS_SE_NM")==null?"":bon.get("PRCS_STTS_SE_NM").toString()%>"/>
							</td>
						</tr>
						<tr>
							<th>변호사 지정</th>
							<td colspan="5">
								<input type="text" id="TKCG_EMP_NM" name="TKCG_EMP_NM" style="width:100%;" value="<%=bon.get("TKCG_EMP_NM")==null?"":bon.get("TKCG_EMP_NM").toString()%>"/>
							</td>
						</tr>
						<tr>
							<th>파일첨부</th>
							<td colspan="5">
								<div id="fileUpload" class="dragAndDropDiv" <%if(flist.size()>0){ %>style="width:50%"<%} %>>
									<input type="file" multiple style="display:none" id="filesel"/>
								    <label for="filesel"><strong>업로드할 파일을 선택 하세요.</strong></label>
								    <label for="filesel">(드래그앤드롭으로 파일 첨부가 가능합니다)</label>
								</div>
								<div class="hkk2" style="width:49%;">
									<%
										for(int i=0; i<flist.size(); i++){
											HashMap result = (HashMap)flist.get(i);
									%>
									<div class="statusbar odd">
										<div class="filename" style='width:80%'><%=result.get("PHYS_FILE_NM") %></div><div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILE_MNG_NO") %>"/>　삭제</div>
									</div>
									<%
										}
									%>
								</div>
								<div class="hkk" style="width:49%;"></div>
							</td>
						</tr>
					</table>
				</form>
			</div>				
		</div>
	</div>
</div>
