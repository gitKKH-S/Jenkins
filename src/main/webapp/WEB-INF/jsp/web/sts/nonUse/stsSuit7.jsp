<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<link id="calendar_month" href="${resourceUrl}/css/calendar_month.css" rel="stylesheet" />
<link id="calendar_year" href="${resourceUrl}/css/calendar_year.css" rel="stylesheet" />
<script src="${resourceUrl}/js/mten.statistics.js"></script>
<script src="${resourceUrl}/Highcharts-7.2.0/code/highcharts.js"></script>
<script src="${resourceUrl}/Highcharts-7.2.0/code/modules/exporting.js"></script>
<script src="${resourceUrl}/Highcharts-7.2.0/code/modules/export-data.js"></script>

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
<body>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<table class="infoTable write" style="width:100%">
			<colgroup>
				<!-- <col style="width:10%;"> -->
				<!-- <col style="width:*;"> -->
				<col style="width:10%;">
				<col style="width:*;">
				<col style="width:*;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<!-- 
				<th>차트종류</th>
				<td>
					<select id="selChartType" class="subSearchType">
		                <option id="opChartType00" value="column">막대차트</option>
		                <option id="opChartType01" value="line">라인차트</option>
		                <option id="opChartType02" value="pie">파이차트</option>
		            </select>
				</td>
				 -->
				<th>검색구분</th>
				<td>
					<input type="radio" name="searchGbn" class="searchGbn" value="d" checked="checked" /><label>  일별  </label>
			        <input type="radio" name="searchGbn" class="searchGbn" value="m" /><label>  월별  </label>
			        <input type="radio" name="searchGbn" class="searchGbn" value="y" /><label>  년도별    </label>
			     </td>
			     <td>
					<input type="text" id="txtStartDate" maxlength="12" style="width:85px" readonly />
			        ~
			        <input type="text" id="txtEndDate" maxlength="12" style="width:85px" readonly/>
				</td>
				<td>
					<input type="radio" name="chrtGbn" class="chrtGbn1" value="1" checked="checked"/><label>  소송유형별  </label>
					<input type="radio" name="chrtGbn" class="chrtGbn2" value="2"                  /><label>  법무법인별  </label>
				</td>
				<td>
					<input type="radio" name="stsGbn" class="stsGbn1" value="1" checked="checked" onchange="stsStyleSet(this.value)"/><label>  차트  </label>
					<input type="radio" name="stsGbn" class="stsGbn2" value="2" onchange="stsStyleSet(this.value)"/><label>  목록  </label>
				</td>
				<td>
					<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
					<a href="#" id="btnSubmit2" style="display:none;" class="sBtn type1">검색</a>
				</td>
			</tr>
		</table>
	</div>
	<!-- 
	<div class="subBtnW center">
		<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
	</div>
	 -->
	<div class="innerB" id="charts">
		<div id="myModal" class="modal">
			<!-- Modal content -->
			<div class="modal-content">
				<span class="close">
					<b style="font-size:28px; float:right;">&times;</b>
				</span>
				<table style="width:560px;" id="modalTable">
					<colgroup>
						<col style="width:30%;">
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
						<col style="width:*;">
					</colgroup>
				</table>
			</div>
		</div>
		<div id="dvChart"></div>
	</div>
	<div class="innerB" id="grids" style="display:none;">
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
</body>
<style>
	.close{
		width:560px;
		margin-bottom:10px;
	}
	.modal {
		display: none; /* Hidden by default */
		position: fixed; /* Stay in place */
		z-index: 1; /* Sit on top */
		left: 0;
		top: 0;
		width: 100%; /* Full width */
		height: 100%; /* Full height */
		overflow: auto; /* Enable scroll if needed */
		background-color: rgb(0,0,0); /* Fallback color */
		background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
	}
	.modal-content {
		background-color: #fefefe;
		margin: 15% auto; /* 15% from the top and centered */
		padding: 20px;
		border: 1px solid #888;
		width: 600px; /* Could be more or less, depending on screen size */
	}
	.close {
		color: #aaa;
		float: right;
		font-size: 28px;
		font-weight: bold;
	}
	
	.close:hover,
	.close:focus {
		color: black;
		text-decoration: none;
		cursor: pointer;
	}
	.detail td{
		font-size: 13px;
		padding:5px;
	}
</style>
<script type="text/javascript">
	var txtStartDate;
	var txtEndDate;
	var searchGbn;
	var chrtGbn;
	var stsGbn;
	
	$(window).resize(function() {
		var box3 = $('#grids');
		var subCCW = box3.width();
		$( "#grid_jsonp1" ).pqGrid('option', 'width', subCCW-520).pqGrid('refresh');
	});
	
	function stsStyleSet(gbn){
		// 1:차트 2:목록
		if(gbn == "1") {
			$("#charts").css("display", "");
			$("#grids").css("display", "none");
			$("#btnSubmit").css("display", "");
			$("#btnSubmit2").css("display", "none");
			
			$("#btnSubmit").trigger("click");
		} else {
			$("#charts").css("display", "none");
			$("#grids").css("display", "");
			$("#btnSubmit").css("display", "none");
			$("#btnSubmit2").css("display", "");
			
			$("#btnSubmit2").trigger("click");
			
			var box3 = $('.innerB');
			var subCCW = box3.width();
			$( "#grid_jsonp1" ).pqGrid('option', 'width', subCCW-520).pqGrid('refresh');
		}
	}
	
	function getChecked_value(){
		var obj = document.getElementsByName('searchGbn');
		var txt = ['일별','월별','년도별'];
		for( i=0; i<obj.length; i++) {
			if(obj[i].checked) {
				return txt[i];
			}
		}
	}
	
	function suitview(suitid, caseid){
		var MENU_MNG_NO = '';
		var url = '<%=CONTEXTPATH%>/web/suit/caseViewPop.do?suitid='+suitid+'&caseid='+caseid+'&MENU_MNG_NO='+MENU_MNG_NO+'&title=main';
		var wth = "1200";
		var hht = "850"; 
		var pnm = "suitpop";
		popOpen(pnm,url,wth,hht);
	}
	
	var c1 = [];
	var c2 = [];
	function bindData() {
		var val = $(':radio[name="chrtGbn"]:checked').val();
		chrtGbn = val;
	    var jsonPath = "${pageContext.request.contextPath}/web/statistics/getSuit7.do";
	    $.ajaxSetup({ cache: false });
	    $.getJSON(jsonPath,{staticgbn:'s',txtStartDate:txtStartDate,txtEndDate:txtEndDate,searchGbn:searchGbn,chrtGbn:val, stsGbn:"1"}, function(data) {
	    	calcData(data);
	        drawChart("column");
	    }).error(function(jqXHR, textStatus, errorThrown) {
	        alert("error occured!\nStatus : " + textStatus + "\nError : " + errorThrown);
	    });
	}
	
	function calcData(data) {
		c1 = [];
		c2 = [];
		c3 = [];
		c4 = [];
		c5 = [];
		var filteredList = [];
		filteredList.push({name:c2});
		$.each(data, function(i, item) {
			c1[i] = item.C1;
			c2[i] = parseInt(item.C2, 10);
			c3[i] = parseInt(item.C3, 10);
			c4[i] = parseInt(item.C4, 10);
			c5[i] = parseInt(item.C5, 10);
		});
	}
	
	function drawChart(type) {
		var textsub = getChecked_value() + ' 소송 승패소 현황';
		var tooltip;
		 
		if(chrtGbn == "2"){
			
		}
	    var options = {
	        chart: {
	            renderTo: 'dvChart',
	            type: type
	        },
	        title: {
	            text: '소송 승패소 현황'
	        },
	        subtitle: {
	            text: textsub
	        },
	        xAxis: {
	            categories: [],
	            type: 'datetime'
	        },
	        yAxis: {
	            min: 0,
	            title: {
	                text: '건수'
	            }
	        },
	        tooltip: {
	        	headerFormat: '<span style="font-size:13px;">[{point.key}]</span><table style="width:150px;">',
	            pointFormat: '<tr><td style="color:{series.color};padding:0;font-size:13px;text-align:right;">{series.name}: </td>'+
				'<td style="padding:0;font-size:13px;text-align:right;"><b>{point.y}건</b></td></tr>',
	            footerFormat: '</table>',
	            shared: true,
	            enabled: true,
	            useHTML: true
	        },
	        plotOptions: {
	            column: {
	                pointPadding: 0.2,
	                borderWidth: 0
	            },
	            series: {
	                cursor: 'pointer',
	                point: {
	                    events: {
	                        click: function () {
	                            //alert('Category: ' + this.category + ', value: ' + this.y);
	                            // this.category : 법인명
	                            if(chrtGbn == "2"){
		                            /* console.log(this); */
	                            	getDetailInfo(this.category);
	                            }
	                        }
	                    }
	                }
	            }
	        },
	        series: [
	        	{name: 'c2'},
	        	{name: 'c3'},
	        	{name: 'c4'},
	        	{name: 'c5'}
	        ]
	    }
	    
	    options.xAxis.categories = c1;
	    //options.xAxis.tickInterval = parseInt(c1.length / 3);
	    options.xAxis.tickInterval = 1;
	    
	    if (type == "pie") {
	        options.series[0].name = "승소";
	        options.series[0].data = c2;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[1].name = "일부승소";
	        options.series[1].data = c3;
	        options.series[1].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[2].name = "패소";
	        options.series[2].data = c4;
	        options.series[2].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[3].name = "일부패소";
	        options.series[3].data = c5;
	        options.series[3].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	    }
	    else {
	        options.series[0].name = "승소";
	        options.series[0].data = c2;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[1].name = "일부승소";
	        options.series[1].data = c3;
	        options.series[1].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[2].name = "패소";
	        options.series[2].data = c4;
	        options.series[2].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[3].name = "일부패소";
	        options.series[3].data = c5;
	        options.series[3].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	    }
	    new Highcharts.Chart(options);
	}
	
	function getDetailInfo(name){
		$(".detail").remove();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/statistics/getSuit7Tooltip.do",
			data:{txtStartDate:txtStartDate, txtEndDate:txtEndDate, searchGbn:searchGbn, lawfirmnm:name},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				$(".close").append("<b style=\"font-size:28px; float:left;\">"+name+"</b>");
				$.each(result, function(index, val){
					console.log(val);
					html += "<tr class=\"detail\">";
					html += "<td>"+val.SERVICE+"</td>";
					//html += "<td class=\"data\"> 승소:"+val.C2+"건 / 일부승소:"+val.C3+"건 / 패소:"+val.C4+"건 / 일부패소:"+val.C5+"건</td>";
					html += "<td> 승소:"+val.C2+"건</td><td>일부승소:"+val.C3+"건</td><td>패소:"+val.C4+"건</td><td>일부패소:"+val.C5+"건</td>";
					html += "</tr>";
				});
				$("#modalTable").append(html);
				
				//modalTable
				
				modal();
			}
		});
	}
	
	function modal() {
		var modal = document.getElementById("myModal");
		var span = document.getElementsByClassName("close")[0];
		modal.style.display = "block";
		span.onclick = function() {
			modal.style.display = "none";
		}
	}
	
	$(function () {
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		var box3 = $('#grids');
		var subCCW = box3.width();
		
		var dataModel_left = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData:{
				txtStartDate:$("#txtStartDate").val(),
				txtEndDate:$("#txtEndDate").val(),
				dategbn:$(':radio[name="suitDateGbn"]:checked').val(),
				searchGbn:searchGbn,
				chrtGbn:$(':radio[name="chrtGbn"]:checked').val(),
				stsGbn:"2"
			},
			url: "${pageContext.request.contextPath}/web/statistics/getSuit14.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return { data: data };
			}
		};
		
		var colModel_left = [
			{title:"구분",         dataType:"string",   dataIndx:"RESULTGBN", cls:"leftCol", editable:false, hidden:true},
			{title:"구분",         dataType:"string",   dataIndx:"RESULTNM", cls:"leftCol", editable:false, width:150},
			{title:"건수",         dataType:"integer",  dataIndx:"CNT",      cls:"leftCol", editable:false, width:80}
		];
		
		$("#grid_jsonp").pqGrid({
			height: 550,
			width : 400,
			scrollModel: {autoFit: true},
			title: "소송 승패소 현황",
			resizable: false,
			dataModel: dataModel_left,
			colModel: colModel_left,
			cellClick : function(evt,ui){
				if(ui.rowData){
					
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
							txtStartDate:$("#txtStartDate").val(),
							txtEndDate:$("#txtEndDate").val(),
							dategbn:$(':radio[name="suitDateGbn"]:checked').val(),
							searchGbn:searchGbn,
							chrtGbn:$(':radio[name="chrtGbn"]:checked').val(),
							stsGbn:"2",
							resultnm:ui.rowData['RESULTGBN']
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
		///////////////////////////////////////////////////////////////////////////////////////
		var dataModel_right = {
			location: "remote",
			dataType: "json",
			method: "POST",
			url: "${pageContext.request.contextPath}/web/statistics/getSuit14.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return { data: data };
			}
		};
		
		var colModel_right = [
			{title:"소송ID", dataType:"string", dataIndx:"SUITID", editable:false, hidden:true},
			{title:"심급ID", dataType:"string", dataIndx:"CASEID", editable:false, hidden:true},
			{ title:"소송구분", dataType:"string", align:'center', dataIndx: "SUITGBN",  editable:false, width:50 },
			{ title:"소송유형", dataType:"string", align:'center', dataIndx: "SUITTYPE", editable:false, width:50 },
			{ title:"소송유형상세", dataType:"string", align:'center', dataIndx: "SERVICE",  editable:false, width:10},
			{ title:"소송명",   dataType:"string", align:'center', dataIndx: "SUITNM",   editable:false, width:50 },
			{ title:"사건번호", dataType:"string", align:'center', dataIndx: "CASENUM",  editable:false, width:50 }
		];
		
		$("#grid_jsonp1").pqGrid({
			height: 550,
			width : subCCW-520,
			scrollModel: {autoFit: true},
			title: "소송 승패소 현황 상세",
			resizable: false,
			dataModel: dataModel_right,
			colModel: colModel_right,
			cellClick : function(evt,ui){
				if(ui.rowData){
					var dataIndx = ui.dataIndx;
					
					if(dataIndx == "SUITNM"){
						suitview(ui.rowData['SUITID'], ui.rowData['CASEID']);
					}
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
		
		$("#btnSubmit2").click(function() {
			var val2 = $(':radio[name="chrtGbn"]:checked').val();
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(),searchGbn:searchGbn,chrtGbn:val2,stsGbn:"2" } );
			$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
		});
		
	});
</script>