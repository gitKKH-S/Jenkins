<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%
	HashMap mtenMap = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	String gbn = request.getAttribute("gbn")==null?"S":request.getAttribute("gbn").toString();
	
	String docGbn = request.getAttribute("docGbn")==null?"":request.getAttribute("docGbn").toString();
	String dateGbn = request.getAttribute("dateGbn")==null?"":request.getAttribute("dateGbn").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String admin = "N";
	if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1) {
		admin = "Y";
	} else if (GRPCD.indexOf("C")>-1 || GRPCD.indexOf("L")>-1 || GRPCD.indexOf("D")>-1) {
		admin = "S";
	}
%>
	<link rel="stylesheet" href="${resourceUrl}/fullcalendar/vendor/css/fullcalendar.min.css" />
	<link rel="stylesheet" href="${resourceUrl}/fullcalendar/vendor/css/bootstrap.min.css">
	<link rel="stylesheet" href='${resourceUrl}/fullcalendar/vendor/css/select2.min.css' />
	<link rel="stylesheet" href='${resourceUrl}/fullcalendar/vendor/css/bootstrap-datetimepicker.min.css' />
	<link rel="stylesheet" href="${resourceUrl}/fullcalendar/css/main.css">
	
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/common.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/layout.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/sub.css">
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/table.css">
	<style>
		.subCA {padding:0px; margin-top:38px;}
		.innerB {margin-bottom:5px;}
		.fc-sat{
			background: #71a9ff2e;
			color: blue;
		}
		
		.fc-sat a{
			color: blue;
		}
		
		.fc-sun{
			background: #fff0f0;
			color: red;
		}
		
		.fc-sun a{
			color: red;
		}
		.fc-day-header {
			background: #f3f6ff;
			font-size: 14px;
	    	font-weight: 900;
		}
		.fc button {
			font-size: 13px;
			background: #3F5FCE;
			color: white;
			font-family:'Malgun Gothic', 'Malgun Gothic', 'Dotum', 'Gulim', 'Arial', sans-serif;
		}
		
		#wrapper * {
			font-family:'Malgun Gothic', 'Malgun Gothic', 'Dotum', 'Gulim', 'Arial', sans-serif;
		}
		
		.fc-title {
			font-size: 0.8vw;
		}
		
		.fc-content {
			overflow: hidden;
			white-space:nowrap;
			text-overflow:ellipsis;
		}
		
		.fc-center {
			/* margin-left:29%; */
		}
		
		.fc-center h2 {
			font-size: 2vw;
		}
		
		.fc-day-header {
			background: #f3f6ff;
		}
		
		.fc-unthemed td.fc-today {
			background: #f0f3ff;
		}
		
		.fc-day:hover {
			background: #fff;
		}
		
		select {
			width: 47%;
		}
		
		#searchBtn {
			height: 30px; line-height:30px;
		}
		
		.container {
			max-width: 2000px;
		}
		
		.subCA {
			margin-top: 15px;
		}
	</style>
	<script>
		function goSearchSuit() {
			var docGubun = document.querySelector('input[name="calGbn"]:checked').value;
			var dateGubun = document.querySelector('input[name="calDateGbn"]:checked').value;
			
			document.getElementById("docGbn").value = docGubun;
			document.getElementById("dateGbn").value = dateGubun;
			
			reloadCalendar();
		}
	</script>
	<div class="cBon">
		<form id="frm" name="frm" method="post" action="">
			<input type="hidden" name="docGbn"  id="docGbn"  value="<%=docGbn%>" />
			<input type="hidden" name="dateGbn" id="dateGbn" value="<%=dateGbn%>" />
			
			<div class="container">
				<%
					if("Y".equals(admin) || "S".equals(admin)) {
				%>
				<div class="subCA">
					<div class="innerB">
						<div>
							<input type="radio" onchange="goSearchSuit()" name="calGbn" value=""     <%if(docGbn.equals("")) out.println("checked");%>    > 전체&nbsp;
							<input type="radio" onchange="goSearchSuit()" name="calGbn" value="sut" <%if("sut".equals(docGbn)) out.println("checked");%> > 소송&nbsp;
							(
							<input type="radio" onchange="goSearchSuit()" name="calGbn" value="bul"  <%if("bul".equals(docGbn)) out.println("checked");%> > 불변기일&nbsp;
							<input type="radio" onchange="goSearchSuit()" name="calGbn" value="doc"  <%if("doc".equals(docGbn)) out.println("checked");%> > 서면&nbsp;
							<input type="radio" onchange="goSearchSuit()" name="calGbn" value="date" <%if("date".equals(docGbn)) out.println("checked");%>> 기일
							)&nbsp;
							<%if("Y".equals(admin)) {%>
							<input type="radio" onchange="goSearchSuit()" name="calGbn" value="con" <%if("con".equals(docGbn)) out.println("checked");%> > 자문&nbsp;
							<input type="radio" onchange="goSearchSuit()" name="calGbn" value="agr" <%if("agr".equals(docGbn)) out.println("checked");%> > 협약&nbsp;
							<%}%>
						</div>
						<div>
							<input type="radio" onchange="goSearchSuit()" name="calDateGbn" value=""  <%if(dateGbn.equals("")) out.println("checked");%>> 전체&nbsp;
							<input type="radio" onchange="goSearchSuit()" name="calDateGbn" value="3" <%if("3".equals(dateGbn)) out.println("checked");%>> 3일&nbsp;
							<input type="radio" onchange="goSearchSuit()" name="calDateGbn" value="7" <%if("7".equals(dateGbn)) out.println("checked");%>> 7일
						</div>
					</div>
				</div>
				<%
					}
				%>
				<div id="wrapper">
					<div id="loading"></div>
					<div id="calendar"></div>
				</div>
			</div>
		</form>
	</div>
	<input type="hidden" id="gbn" name="gbn" value="<%=gbn%>" />
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/fullcalendar/vendor/js/jquery.min.js"></script>
<script src="${resourceUrl}/fullcalendar/vendor/js/bootstrap.min.js"></script>
<script src="${resourceUrl}/fullcalendar/vendor/js/moment.min.js"></script>
<script src="${resourceUrl}/fullcalendar/vendor/js/fullcalendar.min.js"></script>
<script src="${resourceUrl}/fullcalendar/vendor/js/ko.js"></script>
<script src="${resourceUrl}/fullcalendar/vendor/js/select2.min.js"></script>
<script src="${resourceUrl}/fullcalendar/vendor/js/bootstrap-datetimepicker.min.js"></script>
<script src="${resourceUrl}/fullcalendar/js/main.js"></script>
<script src="${resourceUrl}/fullcalendar/js/addEvent.js"></script>
<script src="${resourceUrl}/fullcalendar/js/editEvent.js"></script>
<script src="${resourceUrl}/fullcalendar/js/etcSetting.js"></script>
<script>
	var gbn = "<%=gbn%>";
	var admin = "<%=admin%>";
	$(document).ready(function(){
		var doc = "<%=docGbn%>";
		var date = "<%=dateGbn%>";
		
		
		
		var height = window.innerHeight;
		var width =  window.innerWidth;
		var box = $('.cBon');
		if (admin == 'Y') {
			box.css('height',height-140);
		} else {
			box.css('height',height-90);
		}
		
		box.css('width','100%');
		$(".container").css('width','85%');
		
		if (admin == 'Y') {
			$('#calendar').fullCalendar('option', 'height', height-100);
		} else {
			$('#calendar').fullCalendar('option', 'height', height-50);
		}
		
		$(window).resize(function() {
			var height = window.innerHeight;
			var width =  window.innerWidth;
			var box = $('.cBon');
			box.css('height',height-90);
			box.css('width','100%');
			$(".container").css('width','85%');
			$('#calendar').fullCalendar('option', 'height', height-50);
		});
	});
</script>