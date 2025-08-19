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
<script src="${resourceUrl}/js/mten.statistics.js"></script>
<style>
	.leftCol:hover{cursor:pointer; text-decoration:underline;}
</style>
<script type="text/javascript">
	var txtStartDate;
	var txtEndDate;
	var searchGbn;
	
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
		/* 
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { txtStartDate:txtStartDate,txtEndDate:txtEndDate} );
			$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
		 */
	}
	
	$(window).resize(function() {
		var box3 = $('.innerB');
		var subCCW = box3.width();
		$( "#grid_jsonp1" ).pqGrid('option', 'width', subCCW-550).pqGrid('refresh');
	});
	
	function pageOpen(consultid){
		var MENU_MNG_NO = '';
		var url = '<%=CONTEXTPATH%>/web/consult/consultViewPop.do?consultid='+consultid;
		var wth = "1200";
		var hht = "850"; 
		var pnm = "consultpop";
		popOpen(pnm,url,wth,hht);
	}
	
	$(function () {
		var box3 = $('.innerB');
		var subCCW = box3.width();
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		var obj = {
			height: 500,
			width : 400,
			scrollModel: {autoFit: true},
			title: "법무법인별 자문 현황",
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
							saveAs(blob, "법무법인별 자문 현황."+ format );
						}
				}]
			}
		};
		
		obj.colModel = [
			{title:"법무법인", dataType:"string",  dataIndx:"OFFICE", cls:"leftCol", editable:false, width:320},
			{title:"건수",     dataType:"integer", dataIndx:"CNT",    cls:"leftCol", editable:false, width:80},
		];
		
		obj.dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData:{ txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(),gbn:$(':radio[name="gridGbn"]:checked').val()},
			url: "${pageContext.request.contextPath}/web/statistics/getConsult3.do",
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
				/* $( "#grid_jsonp1" ).pqGrid("option","dataModel.postData", { year: ui.rowData['YEAR'], bookcd:bookcd } ); */
				$( "#grid_jsonp1" ).pqGrid(
					"option",
					"dataModel.postData",
					{
						lawfirmid : ui.rowData['LAWFIRMID'],
						txtStartDate:$("#txtStartDate").val(),
						txtEndDate:$("#txtEndDate").val(),
						searchGbn:searchGbn,
						gbn:$(':radio[name="gridGbn"]:checked').val()
					}
				);
				$( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
			}
		};
		
		$("#grid_jsonp").pqGrid(obj);
		var colModel1= [
			// 연도, 소송유형(suittype), 소송명
			{title:"자문ID",      dataType:"string", dataIndx:"CONSULTID", editable:false, hidden:true},
			{ title:"연도",       dataType:"string", align:'center', dataIndx: "GYEAR",        editable:false, width:5 },
			{ title:"의뢰일자",   dataType:"string", align:'center', dataIndx: "REQDT",        editable:false, width:50 },
			{ title:"자문명",     dataType:"string", align:'center', dataIndx: "TITLE",        editable:false, width:200 },
			{ title:"의뢰자",     dataType:"string", align:'center', dataIndx: "WRITER",       editable:false, width:20 },
			{ title:"의뢰부서",   dataType:"string", align:'center', dataIndx: "WRITERDEPTNM", editable:false, width:50 },
			{ title:"담당자",     dataType:"string", align:'center', dataIndx: "CHRGEMPNM",    editable:false, width:20 },
			{ title:"진행상태",   dataType:"string", align:'center', dataIndx: "CONTFLG",      editable:false, width:20 },
			{ title:"답변등록일", dataType:"string", align:'center', dataIndx: "WRITEDATE",    editable:false, width:50 }
		];
		var dataModel1 = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getConsult3.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return {data:data};
			}
		};
		
		$("#grid_jsonp1").pqGrid({
			height: 500,
			width : subCCW-450,
			scrollModel: {autoFit: true},
			dataModel: dataModel1,
			colModel: colModel1,
			title: "법무법인별 자문 현황",
			resizable: true,
			hwrap: false,
			wrap: false,
			cellClick:function(evt, ui){
				if(ui.rowData){
					var dataIndx = ui.dataIndx;
					if(dataIndx == "TITLE"){
						pageOpen(ui.rowData['CONSULTID']);
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
							saveAs(blob, "법무법인별 자문 현황."+ format );
						}
					}
				]
			}
		});
		
		$("#btnSubmit").click(function() {
			txtStartDate = $("#txtStartDate").val();
			txtEndDate = $("#txtEndDate").val();
			
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { schText: $("#schText").val(),txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(),searchGbn:searchGbn,gbn:$(':radio[name="gridGbn"]:checked').val()} );
			$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
		});
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
					<input type="text" id="txtEndDate" maxlength="12" style="width:150px" readonly/>
				</td>
				<td>
					<input type="hidden" id="gbn" value="" />
					<input type="radio" name="gridGbn" class="gridGbn" value="A" checked="checked"/><label>  의뢰일자  </label>
					<input type="radio" name="gridGbn" class="gridGbn" value="B"                  /><label>  답변등록일자  </label>
				</td>
				<td>
					<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
				</td>
			</tr>
		</table>
	</div>
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
