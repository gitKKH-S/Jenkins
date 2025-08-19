<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap pdsBon = request.getAttribute("pdsBon")==null?new HashMap():(HashMap)request.getAttribute("pdsBon");
	HashMap bon = pdsBon.get("bon")==null?new HashMap():(HashMap)pdsBon.get("bon");
	List flist = pdsBon.get("flist")==null?new ArrayList():(ArrayList)pdsBon.get("flist");
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	String WRTR_EMP_NO = bon.get("WRTR_EMP_NO")==null?"":bon.get("WRTR_EMP_NO").toString();
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();	
%>
<script type="text/javascript">
	$(document).ready(function(){
		$("#uBtn").click(function(){
			var frm = document.wform;
			frm.action="${pageContext.request.contextPath}/web/pds/pdsWrite.do";
			frm.submit();
		});
		
		$("#rBtn").click(function(){
			$("#UP_PST_MNG_NO").val($("#PST_MNG_NO").val());
			$("#REYN").val("Y");
			var frm = document.wform;
			frm.action="${pageContext.request.contextPath}/web/pds/pdsWrite.do";
			frm.submit();
		});
		
		$("#dBtn").click(function(){
			var frm = document.wform;
			frm.action="${pageContext.request.contextPath}/web/pds/pdsDel.do";
			frm.submit();
		});
		$("#lBtn").click(function(){
			var frm = document.wform;
			frm.action="${pageContext.request.contextPath}/web/pds/pdsList.do";
			frm.submit();
		});
	});
	function downpage(PHYS_FILE_NM,SRVR_FILE_NM,folder){
		form=document.ViewForm;
		form.Pcfilename.value=PHYS_FILE_NM;
		form.Serverfile.value=SRVR_FILE_NM;
		form.folder.value=folder;
		form.action="${pageContext.request.contextPath}/Download.do";
		form.submit();
	}
	</script>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong><strong id="tnotic" style="color:red;float:right;display:none;">* 등록된 계약서는 임시 양식이므로 부서 상황에 맞게 편집하여 사용하시기 바랍니다.</strong>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT"></strong>
		</div>
		<div class="subBtnC right">
		<%
			if(USERNO.equals(WRTR_EMP_NO) || GRPCD.indexOf("Y")>-1){
		%>
			<a href="#" id="uBtn" class="sBtn type1">수정</a>
			<a href="#" id="dBtn" class="sBtn type1">삭제</a>
		<%
			}
		%>
		<%
			if(MENU_MNG_NO.equals("10119023")){
		%>
			<a href="#" id="rBtn" class="sBtn type1">답변</a>
		<%
			}
		%>
			<a href="#" id="lBtn" class="sBtn type1">목록</a>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList">
			<div class="tableW">
				<form name="wform" method="post" enctype="post">
					<input type="hidden" name="BBS_SE" id="BBS_SE" value="PDS"/>
					<input type="hidden" name="REYN" id="REYN" value=""/>
					<input type="hidden" name="UP_PST_MNG_NO" id="UP_PST_MNG_NO" value=""/>
					<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>">
					<input type="hidden" name="PST_MNG_NO" id="PST_MNG_NO"  value="<%=bon.get("PST_MNG_NO")%>">
					<table class="infoTable write">
						<colgroup>
							<col style="width:10%;">
							<col style="width:*;">
						</colgroup>
						<tr>
							<th>제목</th>
							<td>
								<%=bon.get("PST_TTL")%>
							</td>
						</tr>
						
						<%	
							boolean extchk = false;
							for(int i=0; i<flist.size(); i++){
								HashMap result = (HashMap)flist.get(i);
								String ext = result.get("FILE_EXTN_NM")==null?"":result.get("FILE_EXTN_NM").toString();
								ext = ext.replaceAll("\\.", "");
								ext = ext.toLowerCase();
								if("mp4,avi,mkv,mpg,flv,asf,mov".indexOf(ext)>-1){
									extchk = true;
								}
							}
							if(extchk){
						%>
						<tr>
							<th>동영상</th>
							<td>
								<ul>
								<%
									for(int i=0; i<flist.size(); i++){
										HashMap result = (HashMap)flist.get(i);
										String ext = result.get("FILE_EXTN_NM")==null?"":result.get("FILE_EXTN_NM").toString();
										ext = ext.replaceAll("\\.", "");
										ext = ext.toLowerCase();
										if("mp4,avi,mkv,mpg,flv,asf,mov".indexOf(ext)>-1){
								%>
									<video src='${pageContext.request.contextPath}/dataFile/bbs/<%=result.get("SRVR_FILE_NM") %>' controls autoplay>
										현재 접속중인 브라우져에서는 동영상 플레이어가 동작 하지 않습니다.
									</video><br/><br/>
								<%
										}
									}
								%>
								</ul>
							</td>
						</tr>
						<%
							}
						%>
						<tr>
							<th>내용</th>
							<td>
								<div style="width:100%;height:400px;overflow:auto; ">
								<%=bon.get("PST_CN")==null?"":bon.get("PST_CN").toString().replaceAll("\n","<br/>")%>
								</div>
							</td>
						</tr>
						<tr>
							<th>첨부 파일</th>
							<td>
								<ul>
								<%
									for(int i=0; i<flist.size(); i++){
										HashMap result = (HashMap)flist.get(i);
								%>
									<li class="filename" onclick="downpage('<%=result.get("PHYS_FILE_NM") %>','<%=result.get("SRVR_FILE_NM") %>','PDS')" style="cursor:pointer;"><%=result.get("PHYS_FILE_NM") %></li>
								<%
									}
								%>
								</ul>
							</td>
						</tr>
					</table>
				</form>
			</div>				
		</div>
	</div>
</div>
