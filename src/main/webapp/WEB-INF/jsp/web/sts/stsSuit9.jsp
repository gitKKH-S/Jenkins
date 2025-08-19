<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	List cdList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList) request.getAttribute("codeList");
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

<link id="calendar_month" href="${resourceUrl}/css/calendar_month.css" rel="stylesheet" />
<link id="calendar_year" href="${resourceUrl}/css/calendar_year.css" rel="stylesheet" />
<script src="${resourceUrl}/js/mten.statistics.js"></script>
<script type="text/javascript">
	var txtStartDate;
	var txtEndDate;
	var searchGbn;
	
	$(window).resize(function() {
		var box3 = $('.innerB');
		var subCCW = box3.width();
	});
	
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
	
	$(function () {
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		var colModel = [
			{title:"구분",         dataType:"string", dataIndx:"YEARS",           editable:false},
			{title:"징수 결정액",  dataType:"string", dataIndx:"BND_AMT",         editable:false},
			{title:"회수액",       dataType:"string", dataIndx:"GIVE_RTRVL_AMT",  editable:false},
			{title:"회수율",       dataType:"string", dataIndx:"RETURN_RT",       editable:false},
			{title:"미회수액",     dataType:"string", dataIndx:"BND_BLNC",        editable:false},
			{title:"미회수율",     dataType:"string", dataIndx:"NRETURN_RT",      editable:false}
		];
		
		var dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData: {txtStartDate:$("#txtStartDate").val(), txtEndDate:$("#txtEndDate").val(), searchGbn:searchGbn},
			url: "${pageContext.request.contextPath}/web/statistics/getSuit8.do",
			getData: function (dataJSON) {
				var data = dataJSON;
				return {data:data};
			}
		};
		
		var obj = {
			height: 500,
			colModel:colModel,
			dataModel:dataModel,
			scrollModel: {autoFit: true},
			title: "소송비용 회수현황",
			resizable: false,
			toolbar: {
				items:[
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
							saveAs(blob, "소송비용 회수현황."+ format );
						}
				}]
			},
			resizable: false,
			virtualX: true,
			virtualY: true,
			hwrap: false,
			wrap: false
		};
		
		$("#btnSubmit").click(function() {
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", {txtStartDate:$("#txtStartDate").val(), txtEndDate:$("#txtEndDate").val(), searchGbn:searchGbn} );
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
				<col style="width:20%;">
				<col style="width:*;">
				<col style="width:15%;">
			</colgroup>
			<tr>
				<th>검색구분</th>
				<td>
					<input type="radio" name="searchGbn" class="searchGbn" value="d" checked="checked" /><label>  일별  </label>
					<input type="radio" name="searchGbn" class="searchGbn" value="m" /><label>  월별  </label>
					<input type="radio" name="searchGbn" class="searchGbn" value="y" /><label>  년도별    </label>
				</td>
				<td>
					<input type="text" id="txtStartDate" maxlength="12" style="width:150px" readonly />
					~
					<input type="text" id="txtEndDate"   maxlength="12" style="width:150px" readonly/>
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
