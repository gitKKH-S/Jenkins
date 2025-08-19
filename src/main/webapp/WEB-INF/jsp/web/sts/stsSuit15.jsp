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
		
		
		function fillOption(grid) {
			var column = grid.getColumn({dataIndx:"LWS_UP_TYPE_NM"});
			column.filter.options = grid.getData({dataIndx:["LWS_UP_TYPE_NM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"LWS_LWR_TYPE_NM"});
			column.filter.options = grid.getData({dataIndx:["LWS_LWR_TYPE_NM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"INST_NM"});
			column.filter.options = grid.getData({dataIndx:["INST_NM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"CT_NM"});
			column.filter.options = grid.getData({dataIndx:["CT_NM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"JDGM_UP_TYPE_NM"});
			column.filter.options = grid.getData({dataIndx:["JDGM_UP_TYPE_NM"]});
			column.filter.cache = null;
			grid.refreshHeader();
		}
		
		var colModel = [
			{title:"관리번호",      dataType:"string", dataIndx:"LWS_NO",            editable:false},
			{title:"사건명",        dataType:"string", dataIndx:"LWS_INCDNT_NM",     editable:false},
			{
				title:"상위사건유형", dataType:"string", dataIndx:"LWS_UP_TYPE_NM", editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"LWS_UP_TYPE_NM", labelIndx:"LWS_UP_TYPE_NM", condition:"equal", listeners:["change"]}
			},
			{
				title:"하위사건유형", dataType:"string", dataIndx:"LWS_LWR_TYPE_NM", editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"LWS_LWR_TYPE_NM", labelIndx:"LWS_LWR_TYPE_NM", condition:"equal", listeners:["change"]}
			},
			{title:"접수일",        dataType:"string", dataIndx:"FLGLW_YMD",         editable:false},
			{title:"사건구분",      dataType:"string", dataIndx:"INCDNT_SE_NM",      editable:false},
			{
				title:"심급", dataType:"string", dataIndx:"INST_NM", editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"INST_NM", labelIndx:"INST_NM", condition:"equal", listeners:["change"]}
			},
			{title:"사건번호",      dataType:"string", dataIndx:"INCDNT_NO",         editable:false},
			{
				title:"관할법원", dataType:"string", dataIndx:"CT_NM", editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"CT_NM", labelIndx:"CT_NM", condition:"equal", listeners:["change"]}
			},
			{title:"소가",          dataType:"string", dataIndx:"LWS_EQVL",          editable:false},
			{title:"소송상대방",    dataType:"string", dataIndx:"LWS_CNCPR_NM",      editable:false},
			{title:"대리인",        dataType:"string", dataIndx:"LWYR_NM",           editable:false},
			{
				title:"판결결과", dataType:"string", dataIndx:"JDGM_UP_TYPE_NM", editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"JDGM_UP_TYPE_NM", labelIndx:"JDGM_UP_TYPE_NM", condition:"equal", listeners:["change"]}
			},
			{title:"판결선고일",    dataType:"string", dataIndx:"JDGM_ADJ_YMD",      editable:false},
			{title:"판결송달일",    dataType:"string", dataIndx:"RLNG_TMTL_YMD",     editable:false},
			{title:"판결확정일",    dataType:"string", dataIndx:"JDGM_CFMTN_YMD",    editable:false},
			{title:"판결금액",      dataType:"string", dataIndx:"JDGM_AMT",          editable:false}
		];
		
		var dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData: {txtStartDate:$("#txtStartDate").val(), txtEndDate:$("#txtEndDate").val(), searchGbn:searchGbn},
			url: "${pageContext.request.contextPath}/web/statistics/getSuit15.do",
			getData: function (dataJSON) {
				var data = dataJSON;
				return {data:data};
			}
		};
		
		var groupModel = {
			on:true,
			merge:[true],
			dataIndx:["LWS_NO", "LWS_INCDNT_NM", "LWS_UP_TYPE_NM", "LWS_LWR_TYPE_NM", "FLGLW_YMD"],
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
			title: "소송대장",
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
							saveAs(blob, "소송대장."+ format );
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
