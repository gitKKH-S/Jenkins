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
	
	function suitview(suitid, caseid){
		var MENU_MNG_NO = '';
		var url = '<%=CONTEXTPATH%>/web/suit/caseViewPop.do?suitid='+suitid+'&caseid='+caseid+'&MENU_MNG_NO='+MENU_MNG_NO+'&title=main';
		var wth = "1200";
		var hht = "850"; 
		var pnm = "suitpop";
		popOpen(pnm,url,wth,hht);
	}
	
	$(function () {
		var subTitle = " (상세보기 할 항목을 더블클릭 하세요)";
		
		var box3 = $('.innerB');
		var subCCW = box3.width();
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		function fillOption(grid){
			var column = grid.getColumn({dataIndx:"SERVICE"});
			column.filter.options = grid.getData({dataIndx:["SERVICE"]});
			column.filter.cache = null;
			grid.refreshHeader();
		}
		
		var title = "";
		var dataModel1 = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getSuit3.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				$("#gbn").val(dataJSON.gbn);
				return {data:data};
			}
		};
		
		var val = $("#gbn").val();

		if(val == "6"){
			title = "연도별 소송 운영 현황";
		}else if(val == "3"){
			title = "연도별(법무법인별) 소송 운영 현황";
		}else if(val == "5"){
			title = "연도별(담당자별) 소송 운영 현황";
		}else{
			title = "유형별(법무법인별) 소송 운영 현황";
		}
		
		var colModel1 = [
			{title:"구분",     dataType:"integer", dataIndx:"GYEAR",       cls:"leftCol", editable:false, width:80},
			{title:"법인",     dataType:"string",  dataIndx:"LAWFIRMNAME", cls:"leftCol", editable:false, width:180},
			{title:"담당자",   dataType:"string",  dataIndx:"EMPNM",       cls:"leftCol", editable:false, width:180},
			{title:"행정소송", dataType:"integer", dataIndx:"A1",          cls:"leftCol", editable:false, width:80},
			{title:"행정심판", dataType:"integer", dataIndx:"A2",          cls:"leftCol", editable:false, width:80},
			{title:"민사소송", dataType:"integer", dataIndx:"A3",          cls:"leftCol", editable:false, width:80},
			{title:"기타",     dataType:"integer", dataIndx:"A4",          cls:"leftCol", editable:false, width:80},
			{title:"총 건수",  dataType:"integer", dataIndx:"TOTAL",       cls:"leftCol", editable:false, width:80}
		];
		$("#grid_jsonp").pqGrid({
			height: 600,
			width : 500,
			scrollModel: {autoFit: true},
			title: title+subTitle,
			resizable: false,
			dataModel: dataModel1,
			colModel: colModel1,
			cellClick : function(evt,ui){
				if (ui.rowData) {
					var rowIndx = ui.rowIndx,
					colIndx = ui.colIndx,
					dataIndx = ui.dataIndx,
					cellData = ui.rowData[dataIndx];
					var suittype;
					
					if(colIndx == 3){
						suittype = "행정소송";
					}else if(colIndx == 4){
						suittype = "행정심판";
					}else if(colIndx == 5){
						suittype = "민사소송";
					}else if(colIndx == 6){
						suittype = "9999";
					}else if(colIndx == 0 || colIndx == 1 || colIndx == 2 || colIndx == 7){
						suittype = "";
					}
					
					$( "#grid_jsonp1" ).pqGrid("option","dataModel.location","remote");
					$( "#grid_jsonp1" ).pqGrid("option","dataModel.postData",
						{
							year:ui.rowData['GYEAR'],
							lawfirm:ui.rowData['LAWFIRMNAME'],
							empnm:ui.rowData['EMPNM'],
							suittype:suittype,
							gbn:$(':radio[name="gridGbn"]:checked').val()
						}
					);
					$( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
				}
			},
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
							saveAs(blob, title + "." + format );
						}
				}]
			}
		});
		
		var colModel2=[
			{title:"소송ID", dataType:"string", dataIndx:"SUITID", editable:false, hidden:true},
			{title:"심급ID", dataType:"string", dataIndx:"CASEID", editable:false, hidden:true},
			{ title:"구분",         dataType:"string", align:'center', dataIndx: "GBN"  ,    editable:false, width:10 },
			{ title:"소송구분",     dataType:"string", align:'center', dataIndx: "SUITGBN",  editable:false, width:10 },
			{ title:"소송유형",     dataType:"string", align:'center', dataIndx: "SUITTYPE", editable:false, width:10 },
			{ title:"소송유형상세", dataType:"string", align:'center', dataIndx: "SERVICE",  editable:false, width:10,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"SERVICE", labelIndx:"SERVICE", condition:"equal", listeners:["change"]}
			},
			{ title:"심급",         dataType:"string", align:'center', dataIndx: "CASECD",   editable:false, width:10 },
			{ title:"소송명",       dataType:"string", align:'center', dataIndx: "SUITNM",   editable:false, width:60 },
			{ title:"종결여부",     dataType:"string", align:'center', dataIndx: "ENDYN",    editable:false, width:10 }
		];
		
		var dataModel2 = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getSuit3.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return {data:data};
			}
		};
		
		$("#grid_jsonp1").pqGrid({
			height: 600,
			width : subCCW-550,
			scrollModel: {autoFit: true},
			dataModel: dataModel2,
			colModel: colModel2,
			title: title + " - 상세 현황(소송명 클릭 시 상세정보를 볼 수 있습니다.)",
			resizable: true,
			cellClick:function(evt, ui){
				if(ui.rowData){
					var dataIndx = ui.dataIndx;
					
					if(dataIndx == "SUITNM"){
						suitview(ui.rowData['SUITID'], ui.rowData['CASEID']);
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
							saveAs(blob, title + " - 상세 현황." + format );
						}
					}
				]
			},
			filterModel:{on:true, header:true, type:"local"},
			load:function(evt, ui){
				fillOption(this);
			}
		});
		
		$(".gridGbn").click(function() {
			var val = $(':radio[name="gridGbn"]:checked').val();
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", {gbn:val});
			$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
		});
	});
</script>

<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<table class="infoTable write" style="width:100%">
			<colgroup>
				<col style="width:10%;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>조회 구분</th>
				<td>
					<input type="hidden" id="gbn" value="" />
					<input type="radio" name="gridGbn" class="gridGbn" value="6" checked="checked"/><label>  연도별  </label>
					<input type="radio" name="gridGbn" class="gridGbn" value="3"                  /><label>  연도별(법무법인)  </label>
					<input type="radio" name="gridGbn" class="gridGbn" value="5"                  /><label>  연도별(담당자)  </label>
					<input type="radio" name="gridGbn" class="gridGbn" value="4"                  /><label>  유형별(법무법인)  </label>
				</td>
			</tr>
		</table>
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
