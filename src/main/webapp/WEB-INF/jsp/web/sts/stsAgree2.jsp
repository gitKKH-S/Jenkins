<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!-- 
서울 01 ~ 09 대구 41 ~ 43 경기 10 ~ 20 울산	 44 ~ 45 인천 21 ~ 23 부산 46 ~ 49 강원 24 ~ 26 경남 50 ~ 53 충북 27 ~ 29 전북 54 ~ 56 세종 30 전남 57 ~ 60
충남 31 ~ 33 광주 61 ~ 62 대전 34 ~ 35 제주	 63          경북 36 ~ 40
 -->
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
	
	function agreeview(agreeid){
		var MENU_MNG_NO = '';
		var url = '<%=CONTEXTPATH%>/web/agree/agreeViewPop.do?agreeid='+agreeid;
		var wth = "1200";
		var hht = "850"; 
		var pnm = "suitpop";
		popOpen(pnm,url,wth,hht);
	}
	
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
			width : 400,
			scrollModel: {autoFit: true},
			title: "협약지역별현황",
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
							saveAs(blob, "협약지역별현황."+ format );
						}
				}]
			}
		};
		
		obj.colModel = [
			{title:"광역시도", dataType:"string",  dataIndx:"SINM",  cls:"leftCol", editable:false },
			{title:"시군구",   dataType:"string",  dataIndx:"SGGNM", cls:"leftCol", editable:false},
			{title:"협약건수", dataType:"integer", dataIndx:"CNT",   cls:"leftCol", editable:false, width:50}
		];
		
		obj.dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getstsAgree2.do",
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
				
				
				$( "#grid_jsonp1" ).pqGrid("option","dataModel.location","remote");
				$( "#grid_jsonp1" ).pqGrid(
					"option",
					"dataModel.postData",
					{
						sido1 : ui.rowData['SINM'],
						sido2 : ui.rowData['SGGNM']
					}
				);
				$( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
			}
		};
		
		$("#grid_jsonp").pqGrid(obj);
		var colModel1= [
			// 연도, 소송유형(suittype), 소송명
			{title:"협약ID", dataType:"string", dataIndx:"AGREEID", editable:false, hidden:true},
			{ title:"협약유형",     dataType:"string", align:'center', dataIndx: "AGREECD",        editable:false, width:50 },
			{ title:"협약명", dataType:"string", align:'center', dataIndx: "TITLE",          editable:false},
			{ title:"협약기관",   dataType:"string", align:'center', dataIndx: "ORGAN",     editable:false, width:50 },
			{ title:"의뢰부서", dataType:"string", align:'center', dataIndx: "DEPTNAME",           editable:false, width:50 },
			{ title:"소관위원회",   dataType:"string", align:'center', dataIndx: "COMMITTEE",     editable:false, width:50 }
		];
		var dataModel1 = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getstsAgree2.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return {data:data};
			}
		};
		
		$("#grid_jsonp1").pqGrid({
			height: 600,
			width : subCCW-500,
			scrollModel: {autoFit: true},
			dataModel: dataModel1,
			colModel: colModel1,
			title: "협약리스트",
			resizable: true,
			cellClick:function(evt, ui){
				if(ui.rowData){
					var dataIndx = ui.dataIndx;
					
					if(dataIndx == "TITLE"){
						agreeview(ui.rowData['AGREEID']);
					}
				}
			},
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
							saveAs(blob, "협약리스트."+ format );
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
