<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>


<%!
	private String trim(Object value) {
		return trim((String) value);
	}

	private String trimAndDot(Object value) {
		return trimAndDot((String) value);
	}

	private String trim(String value) {
		if (value == null || value.equals("null") || value.equals("NULL")) {
			return "";
		}
		return value.trim();
	}
%>
<%
request.setCharacterEncoding("utf-8");
String pQuery_tmp = trim(request.getParameter("pQuery_tmp"));

%>
<input type="hidden" id="pQuery_tmp" value="<%=pQuery_tmp %>"/>
<script type="text/javascript" src="${resourceUrl}/search/js/param.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/common.js"></script>
<script type="text/javascript" src="${resourceUrl}/search/js/search.js"></script>
<div class="subCA" id="search_result">

	<div class="subTabW set7">
		<hr class="margin30">
		<ul>
			<li><a href="javascript:sendPost('./search.do')" class="active">전체</a></li>
			<li><a href="javascript:sendPost('./suitSearch.do')">소송</a></li>
			<li><a href="javascript:sendPost('./consultSearch.do')">자문</a></li>
			<li><a href="javascript:sendPost('./agreeSearch.do')">협약</a></li>
			<li><a href="javascript:sendPost('./lawSearch.do')">법률정보</a></li>
			<li><a href="javascript:sendPost('./pdsSearch.do')">자료실</a></li>
		</ul>
	</div>
	
	<hr class="margin30">
	
	<!-- 전체 카테고리 선택시 검색결과  -->
	<div id="searchResults">
		<div class="ts_lt2"  style="text-align: center;">
			<div style="margin: 20px 0 20px 0;">
				<i data-feather="alert-circle" class="alert_icon"></i>
				<p style=" font-size: 20px; font-weight: 600; margin-bottom: 20px;"><span style=" color: #f62812; background-color: #fdf9be;"  id="noResultsKeyword"></span> 검색결과가 없습니다.</p>
				<p style="line-height: 180%;">단어의 철자가 정확한지 확인해 보세요.</p>
				<p style="line-height: 180%;">두 단어 이상의 검색어인 경우, 띄어쓰기를 확인해 보세요.</p>
				<p style="line-height: 180%;">검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해 보세요.</p>
			</div>
		</div>
	</div>
		
	</div>
