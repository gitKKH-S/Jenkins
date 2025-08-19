<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@	page import="java.util.*"%>
<%
	HashMap agreeInfo = request.getAttribute("agreeInfo")==null?new HashMap():(HashMap)request.getAttribute("agreeInfo");
	List oagreeflist = request.getAttribute("oagreeflist")==null?new ArrayList():(ArrayList)request.getAttribute("oagreeflist");
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">송무팀 검토 의견</strong>
		</div>
		<div class="subBtnC right" id="test">
		 	<a href="#none" class="sBtn type1" onclick="javascript:window.close();">닫기</a>
		</div>
	</div>	
	<div class="innerB" >
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width:19%;">
				<col style="width:28%;">
				<col style="width:25%;">
				<col style="width:28%;">
			</colgroup>
			<tr>
				<th>송무팀의견 작성자</th>
				<td>
					<div style="float: left;">
						<%=agreeInfo.get("OPINIONWRITERID") %>
					</div>
				</td>
				
				<th>의견작성일</th>
				<td>
					<%=agreeInfo.get("OPINIONDT") %>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="5">
								<ul class="fileList">
			<%				
						if(oagreeflist != null & oagreeflist.size()>0){
							for(int i=0; i<oagreeflist.size();i++){
								HashMap agreeFile = (HashMap)oagreeflist.get(i);
			%>
								<li>
									<a href="#" onclick="downFile('<%=agreeFile.get("VIEWFILENM") %>','<%=agreeFile.get("SERVERFILENM")%>','AGREE')"><%=agreeFile.get("VIEWFILENM")%></a>
								</li>
			<%				
							}
						}
			%>
						</ul>
				</td>
			</tr>
			<tr>
				<th>검토의견</th>
				<td colspan="5">
					<textarea id="opinion" name="opinion" rows="15" readonly cols=""><%=agreeInfo.get("OPINION")==null?"":agreeInfo.get("OPINION") %></textarea>
				</td>
			</tr>
		</table>
	</div>
	
</div>