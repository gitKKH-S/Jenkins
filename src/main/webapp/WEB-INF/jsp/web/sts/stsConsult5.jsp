<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	LocalDate today = LocalDate.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy");
	String sRegDate = today.format(formatter);
	int regDate = Integer.parseInt(sRegDate);
%>
<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/lib/jquery-ui.css" /><!-- 1.11.4 -->
<script src="${resourceUrl}/paramquery-3.3.2/lib/jquery.min.js"></script>    <!-- 1.8.3 -->
<script src="${resourceUrl}/paramquery-3.3.2/lib/jquery-ui.min.js"></script><!-- 1.11.4 -->
<!--ParamQuery Grid css files-->
<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/pqgrid.min.css" />    
<!--add pqgrid.ui.css for jQueryUI theme support-->
<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/pqgrid.ui.min.css" />
<!--ParamQuery Grid js files-->
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/pqgrid.min.js" ></script>   
<!--Include Touch Punch file to provide support for touch devices (optional)-->
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/touch-punch/touch-punch.min.js" ></script>   
<!--Include jsZip file to support xlsx and zip export (optional)-->
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/jsZip-2.5.0/jszip.min.js" ></script> 
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/localize/pq-localize-ko.js" ></script>
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/FileSaver.js-master/FileSaver.min.js" ></script>

<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/pqSelect/pqselect.min.css" />
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/pqSelect/pqselect.min.js" ></script>   

<script type="text/javascript">

	
	$(window).resize(function() {
		var box3 = $('.innerB');
		var subCCW = box3.width();
	});
	/* 
	function getChecked_value(){
		var obj = document.getElementsByName('searchGbn');
		var txt = ['일별','월간','년도별'];
		for( i=0; i<obj.length; i++) {
			if(obj[i].checked) {
				return txt[i];
			}
		}
	}
	
	function bindData() {
		
	}
	 */
	$(function () {
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		var colModel = [
			{title:"변호사",   dataType:"string", dataIndx:"CNSTN_TKCG_EMP_NM", editable:false},
			{title:"날짜",     dataType:"string", dataIndx:"CNSTN_CMPTN_YMD",   editable:false},
			{title:"자문수",   dataType:"string", dataIndx:"DOC_CNT",           editable:false},
			{title:"유선",     dataType:"string", dataIndx:"GBN1_CNT",          editable:false},
			{title:"방문",     dataType:"string", dataIndx:"GBN2_CNT",          editable:false},
			{title:"메일",     dataType:"string", dataIndx:"GBN3_CNT",          editable:false},
			{title:"메신저",   dataType:"string", dataIndx:"GBN4_CNT",          editable:false}
		];
		
		var dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData: {txtDate:$("#txtDate").val()},
			url: "${pageContext.request.contextPath}/web/statistics/getConsult5.do",
			getData: function (dataJSON) {
				var data = dataJSON;
				return {data:data};
			}
		};
		
		var groupModel = {
			on:true,
			merge:[true],
			dataIndx:["CNSTN_CMPTN_YMD"],
			collapsed:[false],
			grandSummary:[true],
			title:[
				"{0} ({1})",
				"{0} - {1}"
			]
		};
		
		var obj = {
			width: "100%",
			//autoFit: true,
			height: 500,
			colModel:colModel,
			dataModel:dataModel,
			groupModel:groupModel,
			//scrollModel: {autoFit: false},
			scrollModel: {autoFit: true},
			title: "구두자문 통계(연도별)",
			resizable: false,
			toolbar: {
				items:[
					{
						type:"button",
						label:"그룹핑변경",
						listener:function(evt){
							this.groupOption({
								on:!grid.option("groupModel.on")
							})
						}
					},
					{
						type: 'select',
						label: 'Format: ',
						attr: 'id="export_format"',
						options: [{xlsx:'Excel', csv:'Csv', htm:'Html', json:'Json'}]
					},
					{
						type: 'button',
						label: "Export",
						icon: 'ui-icon-arrowthickstop-1-s',
						listener: function () {
							var format = $("#export_format").val(),
								blob = this.exportData({
									format: format,
									render: true
								});
							if(typeof blob === "string"){
								blob = new Blob([blob]);
							}
							saveAs(blob, "구두자문 통계(연도별)."+ format );
						}
					}
				]
			},
			filterModel:{on:true, header:true, type:"local"},
			load:function(evt, ui){ },
			virtualX: true,
			virtualY: true,
			hwrap: false,
			wrap: false
		};
		
		$("#btnSubmit").click(function() {
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", {txtDate:$("#txtDate").val()} );
			$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
		});
		
		var grid = pq.grid("#grid_jsonp", obj);
	});
	
</script>

<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<table class="infoTable write" style="width:100%;">
			<colgroup>
				<col style="width:10%;">
				<col style="width:*;">
				<col style="width:15%;">
			</colgroup>
			<tr>
				<th>검색연도</th>
				<td>
					<select name="txtDate" id="txtDate">
						<%
							for(int i=1990; i<=regDate; i++) {
								if(i == regDate) {
						%>
						<option value="<%=i%>" selected><%=i%>년</option>
						<%
								} else {
						%>
						<option value="<%=i%>"><%=i%>년</option>
						<%
								}
							}
						%>
					</select>
				</td>
				<td>
					<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
				</td>
			</tr>
		</table>
	</div>
	<div class="innerB">
		<div id="grid_jsonp"></div>
	</div>
</div>
