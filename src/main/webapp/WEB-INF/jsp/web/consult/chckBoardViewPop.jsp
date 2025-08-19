<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>


<style>

</style>

<script type="text/javascript">
$(document).ready(function(){

});

</script>
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">검토의견 글쓰기</strong>
		</div>
		<div class="subBtnC right" id="test">
		 	<a href="#none" class="sBtn type1" onclick="javascript:opinionSave();">저장</a>
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
				<th>작성자</th>
				<td>
					<div style="float: left;">
						
					</div>
				</td>
				
				<th>의견작성일</th>
				<td>
	
				</td>
			</tr>
			<tr>
				<th>주요의견</th>
				<td colspan="5">
					<textarea id="chckconts" name="chckconts" rows="8" cols=""></textarea>
				</td>
			</tr>
		</table>
	</div>
	
</div>