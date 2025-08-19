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
<style>
	.leftCol:hover{cursor:pointer; text-decoration:underline;}
</style>
<script type="text/javascript">
	$(window).resize(function() {
		var box3 = $('.innerB');
		var subCCW = box3.width();
		$( "#grid_jsonp1" ).pqGrid('option', 'width', subCCW-550).pqGrid('refresh');
	});
	
	$(function () {
		var box3 = $('.innerB');
		var subCCW = box3.width();
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		var obj = {
			height: 600,
			width : 500,
			scrollModel: {autoFit: true},
			title: "소송 운영 현황",
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
							saveAs(blob, "소송 운영 현황."+ format );
						}
				}]
			}
		};
		
		obj.colModel = [
			{title:"구분",     dataType:"integer", dataIndx:"GYEAR", cls:"leftCol", editable:false, width:80},
			{title:"민사",     dataType:"integer", dataIndx:"A1",    cls:"leftCol", editable:false, width:80},
			{title:"행정",     dataType:"integer", dataIndx:"A2",    cls:"leftCol", editable:false, width:80},
			{title:"형사",     dataType:"integer", dataIndx:"A3",    cls:"leftCol", editable:false, width:80},
			{title:"신청",     dataType:"integer", dataIndx:"A4",    cls:"leftCol", editable:false, width:80},
			{title:"집행",     dataType:"integer", dataIndx:"A5",    cls:"leftCol", editable:false, width:80},
			{title:"기타",     dataType:"integer", dataIndx:"A6",    cls:"leftCol", editable:false, width:80}
		];
		
		obj.dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			/* url: "${pageContext.request.contextPath}/web/statistics/getBylaw5.do", */
			url: "${pageContext.request.contextPath}/web/statistics/getSuit6.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return {data:data};
			}
		};
		
		obj.cellClick=function(evt,ui){
			if (ui.rowData) {
				var rowIndx = ui.rowIndx,
				colIndx = ui.colIndx,
				dataIndx = ui.dataIndx,
				cellData = ui.rowData[dataIndx];
				console.log(colIndx);
				console.log(ui.rowData['GYEAR']);
				var suittype;
				//7
				if(colIndx == 0 || colIndx == 1){
					suittype = "민사";
				}else if(colIndx == 2){
					suittype = "행정";
					
				}else if(colIndx == 3){
					suittype = "형사";
					
				}else if(colIndx == 4){
					suittype = "신청";
					
				}else if(colIndx == 5){
					suittype = "집행";
					
				}else{
					suittype = "기타";
					
				}
				$( "#grid_jsonp1" ).pqGrid("option","dataModel.location","remote");
				/* $( "#grid_jsonp1" ).pqGrid("option","dataModel.postData", { year: ui.rowData['YEAR'], bookcd:bookcd } ); */
				$( "#grid_jsonp1" ).pqGrid(
					"option",
					"dataModel.postData",
					{
						year:ui.rowData['GYEAR'],
						suittype:suittype
					}
				);
				$( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
			}
		};
		
		$("#grid_jsonp").pqGrid(obj);
		var colModel1= [
			// 연도, 소송유형(suittype), 소송명
			{ title:"연도",     dataType:"string", align:'center', dataIndx: "GYEAR",    editable:false, width:50 },
			{ title:"소송구분", dataType:"string", align:'center', dataIndx: "SUITGBN",  editable:false, width:50 },
			{ title:"소송유형", dataType:"string", align:'center', dataIndx: "SUITTYPE", editable:false, width:50 },
			{ title:"소송명",   dataType:"string", align:'center', dataIndx: "SUITNM",   editable:false, width:50 },
			{ title:"종결여부", dataType:"string", align:'center', dataIndx: "ENDYN",    editable:false, width:50 }
		];
		var dataModel1 = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getSuit6.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return {data:data};
			}
		};
		
		$("#grid_jsonp1").pqGrid({
			height: 600,
			width : subCCW-550,
			scrollModel: {autoFit: true},
			dataModel: dataModel1,
			colModel: colModel1,
			title: "소송 운영 상세 현황",
			resizable: true,
			toolbar: {
				items: [
					{
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
							saveAs(blob, "소송 운영 상세 현황."+ format );
						}
					}
				]
			}
		});
		
		$("#btnSubmit").click(function() {
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { schText: $("#schText").val(),txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val() } );
			$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
		});
	});
</script>

<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<div class="tableOverW">
			<div class="alignL" style="float:left;">
				<div id="grid_jsonp"></div>
			</div>
			<div class="alignR" style="float:left;padding-left:20px">
				<div id="grid_jsonp1"></div>
			</div>
		</div>
	</div>
</div>
