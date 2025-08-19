<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
<script type="text/javascript">
	$(function () {
		var year = new Date().getFullYear();
		var box3 = $('.innerB');
		var subCCW = box3.width();
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
	
		var colModel= [
			{title:year-9+"년 이전", dataType:"string", dataIndx:"YEAR0", editable:false},
			{title:year-8+"년",      dataType:"string", dataIndx:"YEAR1", editable:false},
			{title:year-7+"년",      dataType:"string", dataIndx:"YEAR2", editable:false},
			{title:year-6+"년",      dataType:"string", dataIndx:"YEAR3", editable:false},
			{title:year-5+"년",      dataType:"string", dataIndx:"YEAR4", editable:false},
			{title:year-4+"년",      dataType:"string", dataIndx:"YEAR5", editable:false},
			{title:year-3+"년",      dataType:"string", dataIndx:"YEAR6", editable:false},
			{title:year-2+"년",      dataType:"string", dataIndx:"YEAR7", editable:false},
			{title:year-1+"년",      dataType:"string", dataIndx:"YEAR8", editable:false},
			{title:year-0+"년",      dataType:"string", dataIndx:"YEAR9", editable:false}
		];
		
		var dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getSuit6.do",
			getData: function (dataJSON) {
				var data1 = dataJSON.data1;
				return {  data: data1 };
			}
		};
		
		$("#grid_jsonp").pqGrid({
			height:100,
			scrollModel: {autoFit: true},
			dataModel: dataModel,
			colModel: colModel,
			title: "연도별 지정현황",
			resizable: false
		});
		
		var obj = {
			height:200,
			scrollModel: {autoFit: true},
			title: "특별착수금 현황",
			resizable: false
		};
		
		obj.colModel = [
			{title: "미지급",   dataType:"string", dataIndx:"NOT_GIVE", editable:false},
			{title: "10백만원", dataType:"string", dataIndx:"GBN1",     editable:false},
			{title: "15백만원", dataType:"string", dataIndx:"GBN2",     editable:false},
			{title: "20백만원", dataType:"string", dataIndx:"GBN3",     editable:false},
			{title: "25백만원", dataType:"string", dataIndx:"GBN4",     editable:false},
			{title: "30백만원", dataType:"string", dataIndx:"GBN5",     editable:false}
		];
		
		obj.dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getSuit6.do",
			getData: function (dataJSON) {
				var data2 = dataJSON.data2;
				return { data: data2 };
			}
		};
		
		/* 
		obj.toolbar= {
			items: [{
				type: 'select',
				label: 'Format: ',
				attr: 'id="export_format"',
				options: [{ xlsx: 'Excel', csv: 'Csv', htm: 'Html', json: 'Json'}]
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
					saveAs(blob, "특별착수금 현황."+ format );
				}
			}]
		}
		*/
		
		$("#grid_jsonp2").pqGrid(obj);
		
		var colModel3= [
			{title:"수행건수", dataType:"string", dataIndx:"TOTAL" ,   editable:false},
			{title:"소계",     dataType:"string", dataIndx:"END_CNT" , editable:false},
			{title:"승소",     dataType:"string", dataIndx:"WIN_CNT" , editable:false},
			{title:"패소",     dataType:"string", dataIndx:"LOS_CNT",  editable:false},
			{title:"기타",     dataType:"string", dataIndx:"ETC_CNT" , editable:false},
			{title:"진행",     dataType:"string", dataIndx:"RUN_CNT" , editable:false}
		];
		
		var dataModel3 = {
			location: "remote",
			dataType: "json",
			method: "GET",
			url: "${pageContext.request.contextPath}/web/statistics/getSuit6.do",
			getData: function (dataJSON) {
				var data3 = dataJSON.data3;
				return {  data: data3 };
			}
		};
		
		$("#grid_jsonp3").pqGrid({
			height:200,
			scrollModel: {autoFit: true},
			dataModel: dataModel3,
			colModel: colModel3,
			title: "진행상황",
			resizable: true
			/*
			, toolbar: {
				items: [{
					type: 'select',
					label: 'Format: ',
					attr: 'id="export_format"',
					options: [{ xlsx: 'Excel', csv: 'Csv', htm: 'Html', json: 'Json'}]
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
						saveAs(blob, "진행상황."+ format );
					}
				}]
			}
			*/
		});
	});
</script>

<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<div id="grid_jsonp"></div>
		<hr class="margin20">
		<div id="grid_jsonp2"></div>
		<hr class="margin20">
		<div id="grid_jsonp3"></div>
	</div>
</div>