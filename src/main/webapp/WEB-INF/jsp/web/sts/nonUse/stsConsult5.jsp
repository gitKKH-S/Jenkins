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
	
	function pageOpen(consultid){
		var MENU_MNG_NO = '';
		var url = '<%=CONTEXTPATH%>/web/consult/consultViewPop.do?consultid='+consultid;
		var wth = "1200";
		var hht = "850"; 
		var pnm = "consultpop";
		popOpen(pnm,url,wth,hht);
	}
	
	function bindData() {
	/* 
		$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
		$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { txtStartDate:txtStartDate,txtEndDate:txtEndDate} );
		$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
	 */
	}
	$(function () {
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		function fillOption(grid){
			var column = grid.getColumn({dataIndx:"TITLE"});
			column.filter.options = grid.getData({dataIndx:["TITLE"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"OFFICE"});
			column.filter.options = grid.getData({dataIndx:["OFFICE"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"INOUTCON"});
			column.filter.options = grid.getData({dataIndx:["INOUTCON"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"CSTTYPECD"});
			column.filter.options = grid.getData({dataIndx:["CSTTYPECD"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"STATCD"});
			column.filter.options = grid.getData({dataIndx:["STATCD"]});
			column.filter.cache = null;
			grid.refreshHeader();
		}
		
		var dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData:{ txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val()},
			url: "${pageContext.request.contextPath}/web/statistics/getConsult5.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return { data: data };
			}
		};
		
		var groupModel = {
			on:true,
			merge:[true],
			collapsed:[false],
			grandSummary:[true],
			title:[
				"{0} ({1})",
				"{0} - {1}"
			]
		};
		
		var colModel = [
			{title:"자문ID", dataType:"string", dataIndx:"CONSULTID", editable:false, hidden:true},
			{title:"자문번호",                 dataType:"string", dataIndx:"CONSULTNO",        width:80, editable:false},
			{title:"자문유형",               dataIndx:"INOUTCON",       width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"INOUTCON", labelIndx:"INOUTCON", condition:"equal", listeners:["change"]}
			},
			{title:"자문명",                 dataIndx:"TITLE",        width:80, editable:false,
				filter: { type: 'textbox', condition: 'contain', listeners: ['keyup'] }
			},
			{title:"자문구분",               dataIndx:"CSTTYPECD",      width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"CSTTYPECD", labelIndx:"CSTTYPECD", condition:"equal", listeners:["change"]}
			},
			{title:"의뢰자",               dataIndx:"WRITER",      width:80, editable:false},
			{title:"의뢰부서",               dataIndx:"WRITERDEPTNM",      width:80, editable:false},
			{title:"담당자",               dataIndx:"CHRGEMPNM",       width:80, editable:false},
			{title:"법무법인",        dataIndx:"OFFICE",        width:80, editable:false,
				filter: { type: 'textbox', condition: 'contain', listeners: ['keyup'] }
			},
			{title:"자문요청일",         dataIndx:"REQDT",       width:80, editable:false},
			{title:"자문접수일",             dataIndx:"CHRGREGDT",         width:80, editable:false},
			{title:"의견회신일",               dataIndx:"SENDDT",      width:80, editable:false},
			{title:"진행상태",               dataIndx:"STATCD",       width:80, editable:false,				
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"STATCD", labelIndx:"STATCD", condition:"equal", listeners:["change"]}
			}
		];
		
		var obj = {
			height: 700,
			scrollModel: {autoFit: true},
			title: "자문관리 대장",
			resizable: true,
			colModel:colModel,
			dataModel:dataModel,
			groupModel:groupModel,
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
							saveAs(blob, "자문관리대장."+ format );
						}
					},
					{
						type:"select",
						cls:"columnSelector",
						attr:"multiple='multiple'", style:"height:60px",
						options:function(ui){
							var CM = this.getColModel(),
								opts = [];
							for(var i=0; i<CM.length; i++){
								var obj = {}, column = CM[i];
								obj[column.dataIndx] = column.title;
								opts.push(obj);
							}
							return opts;
						},
						listener:function(evt){
							var arr = $(evt.target).val(), CM = this.getColModel();
							for(var i=0; i<CM.length; i++){
								var column = CM[i], dataIndx = column.dataIndx;
								
								column.hidden = ($.inArray(dataIndx, arr) == -1);
							}
							this.option("colModel", this.option("colModel"));
							this.refresh();
						}
					}
					
				]
			},
			filterModel:{on:true, header:true, type:"local"},
			load:function(evt, ui){
				fillOption(grid);
			},
			create:function(evt, ui){
				var CM = this.getColModel(), opts = [];
				for(var i=0; i<CM.length; i++){
					var column = CM[i];
					if(column.hidden !== true){
						opts.push(column.dataIndx);
					}
				}
				$(".columnSelector").val(opts);
				
				$(".columnSelector").pqSelect({
					checkbox:true,
					multiplePlaceholder:"select visible columns",
					maxDisplay:100,
					width:"auto"
				});
			},
			resizable: false,
			virtualX: true,
			virtualY: true,
			hwrap: false,
			wrap: false
		};
		
		$("#btnSubmit").click(function() {
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(),searchGbn:searchGbn } );
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
					<input type="text" id="txtEndDate" maxlength="12" style="width:150px" readonly/>
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
