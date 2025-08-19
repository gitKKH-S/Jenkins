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
	
	function suitview(suitid, caseid){
		var MENU_MNG_NO = '';
		var url = '<%=CONTEXTPATH%>/web/suit/caseViewPop.do?suitid='+suitid+'&caseid='+caseid+'&MENU_MNG_NO='+MENU_MNG_NO+'&title=main';
		var wth = "1200";
		var hht = "850"; 
		var pnm = "suitpop";
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
			var column = grid.getColumn({dataIndx:"SUITNM"});
			column.filter.options = grid.getData({dataIndx:["SUITNM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"CASECD"});
			column.filter.options = grid.getData({dataIndx:["CASECD"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"SUITGBN"});
			column.filter.options = grid.getData({dataIndx:["SUITGBN"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"SERVICE"});
			column.filter.options = grid.getData({dataIndx:["SERVICE"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"SUITTYPE"});
			column.filter.options = grid.getData({dataIndx:["SUITTYPE"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"ENDYN"});
			column.filter.options = grid.getData({dataIndx:["ENDYN"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"PROGRESS"});
			column.filter.options = grid.getData({dataIndx:["PROGRESS"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"MAKECASEDT"});
			column.filter.options = grid.getData({dataIndx:["MAKECASEDT"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"CASENUM"});
			column.filter.options = grid.getData({dataIndx:["CASENUM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"SUITAMT"});
			column.filter.options = grid.getData({dataIndx:["SUITAMT"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"WONGO"});
			column.filter.options = grid.getData({dataIndx:["WONGO"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"PIGO"});
			column.filter.options = grid.getData({dataIndx:["PIGO"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"CASERESULT"});
			column.filter.options = grid.getData({dataIndx:["CASERESULT"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"JDGMTGBN"});
			column.filter.options = grid.getData({dataIndx:["JDGMTGBN"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"JDGMTGBN"});
			column.filter.options = grid.getData({dataIndx:["JDGMTGBN"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"DEPTNM"});
			column.filter.options = grid.getData({dataIndx:["DEPTNM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"EMPNM"});
			column.filter.options = grid.getData({dataIndx:["EMPNM"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"WONGOLAWYER"});
			column.filter.options = grid.getData({dataIndx:["WONGOLAWYER"]});
			column.filter.cache = null;
			grid.refreshHeader();
			
			var column = grid.getColumn({dataIndx:"PIGOLAWYER"});
			column.filter.options = grid.getData({dataIndx:["PIGOLAWYER"]});
			column.filter.cache = null;
			grid.refreshHeader();
		}
		
		var dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData:{ txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(), dategbn:$(':radio[name="suitDateGbn"]:checked').val()},
			url: "${pageContext.request.contextPath}/web/statistics/getSuit10.do",
			getData: function (dataJSON) {
				var data = dataJSON.data;
				return { data: data };
			}
		};
		
		var groupModel = {
			on:true,
			merge:[true],
			dataIndx:["SUITID"],
			collapsed:[false],
			grandSummary:[true],
			title:[
				"{0} ({1})",
				"{0} - {1}"
			]
		};
		
		var colModel = [
			{title:"소송ID", dataType:"string", dataIndx:"SUITID", editable:false},
			{title:"심급ID", dataType:"string", dataIndx:"CASEID", editable:false, hidden:true},
			{title:"소송명",                 dataIndx:"SUITNM",        width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"SUITNM", labelIndx:"SUITNM", condition:"equal", listeners:["change"]}
			},
			{title:"심급",                   dataIndx:"CASECD",        width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"CASECD", labelIndx:"CASECD", condition:"equal", listeners:["change"]}
			},
			{title:"소송유형",               dataIndx:"SUITTYPE",      width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"SUITTYPE", labelIndx:"SUITTYPE", condition:"equal", listeners:["change"]}
			},
			{title:"유형상세",               dataIndx:"SERVICE",       width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"SERVICE", labelIndx:"SERVICE", condition:"equal", listeners:["change"]}
			},
			{title:"진행상태",               dataIndx:"PROGRESS",      width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"PROGRESS", labelIndx:"PROGRESS", condition:"equal", listeners:["change"]}
			},
			{title:"제/피소일",              dataIndx:"MAKECASEDT",    width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"MAKECASEDT", labelIndx:"MAKECASEDT", condition:"equal", listeners:["change"]}
			},
			{title:"사건번호",               dataIndx:"CASENUM",       width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"CASENUM", labelIndx:"CASENUM", condition:"equal", listeners:["change"]}
			},
			{title:"소송가액",               dataIndx:"SUITAMT",       width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"SUITAMT", labelIndx:"SUITAMT", condition:"equal", listeners:["change"]}
			},
			{title:"원고",                   dataIndx:"WONGO",         width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"WONGO", labelIndx:"WONGO", condition:"equal", listeners:["change"]}
			},
			{title:"피고",                   dataIndx:"PIGO",          width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"PIGO", labelIndx:"PIGO", condition:"equal", listeners:["change"]}
			},
			{title:"승/패소",                dataIndx:"CASERESULT",    width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"CASERESULT", labelIndx:"CASERESULT", condition:"equal", listeners:["change"]}
			},
			{title:"판결분류",               dataIndx:"JDGMTGBN",      width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"JDGMTGBN", labelIndx:"JDGMTGBN", condition:"equal", listeners:["change"]}
			},
			{title:"수행부서",               dataIndx:"DEPTNM",        width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"DEPTNM", labelIndx:"DEPTNM", condition:"equal", listeners:["change"]}
			},
			{title:"소송수행자",             dataIndx:"EMPNM",         width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"EMPNM", labelIndx:"EMPNM", condition:"equal", listeners:["change"]}
			},
			{title:"원고 대리인",            dataIndx:"WONGOLAWYER",   width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"WONGOLAWYER", labelIndx:"WONGOLAWYER", condition:"equal", listeners:["change"]}
			},
			{title:"피고 대리인",            dataIndx:"PIGOLAWYER",    width:80, editable:false,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"PIGOLAWYER", labelIndx:"PIGOLAWYER", condition:"equal", listeners:["change"]}
			},
			
			/* 기본 컬럼 */
			{title:"수행팀",                 dataIndx:"TEAMNM",        width:80, editable:false, hidden:true},
			{title:"소송구분",               dataIndx:"SUITGBN",       width:80, editable:false, hidden:true,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"SUITGBN", labelIndx:"SUITGBN", condition:"equal", listeners:["change"]}
			},
			{title:"판결선고일",             dataIndx:"JDGMTDT",       width:80, editable:false, hidden:true},
			{title:"종결여부",               dataIndx:"ENDYN",         width:80, editable:false, hidden:true,
				filter:{type:"select", prepend:{"":"전체"}, valueIndx:"ENDYN", labelIndx:"ENDYN", condition:"equal", listeners:["change"]}
			},
			{title:"사건개요",               dataIndx:"SUITCONT",      width:80, editable:false, hidden:true},
			{title:"쟁점사항",               dataIndx:"ISSUECONT",     width:80, editable:false, hidden:true},
			{title:"소송비고",               dataIndx:"SUITBIGO",      width:80, editable:false, hidden:true},
			{title:"병합여부",               dataIndx:"MERGEYN",       width:80, editable:false, hidden:true},
			{title:"심급제목",               dataIndx:"CASENM",        width:80, editable:false, hidden:true},
			{title:"관할법원",               dataIndx:"COURTNM",       width:80, editable:false, hidden:true},
			{title:"재판부",                 dataIndx:"CASEJUDGE",     width:80, editable:false, hidden:true},
			{title:"원고 보조참가",          dataIndx:"WONSUB",        width:80, editable:false, hidden:true},
			
			{title:"원고 소가",              dataIndx:"WONGOAMT",      width:80, editable:false, hidden:true},
			{title:"피고 보조참가",          dataIndx:"PISUB",         width:80, editable:false, hidden:true},
			
			{title:"피고 소가",              dataIndx:"PIGOAMT",       width:80, editable:false, hidden:true},
			{title:"판결송달일",             dataIndx:"DELIVERYDT",    width:80, editable:false, hidden:true},
			{title:"판결금액",               dataIndx:"JDGMTAMT",      width:80, editable:false, hidden:true},
			{title:"판결내용",               dataIndx:"JDGMTCONT",     width:80, editable:false, hidden:true},
			{title:"소송비용 확정신청 여부", dataIndx:"FINALAMTREQYN", width:80, editable:false, hidden:true},
			{title:"금액",                   dataIndx:"FINALAMT",      width:80, editable:false, hidden:true},
			{title:"소송비용 회수여부",      dataIndx:"RECOVERYYN",    width:80, editable:false, hidden:true},
			{title:"판결확정일",             dataIndx:"FINALDT",       width:80, editable:false, hidden:true},
			{title:"심급비고",               dataIndx:"CASEBIGO",      width:80, editable:false, hidden:true},
			{title:"보험사 수행여부",        dataIndx:"INSUYN",        width:80, editable:false, hidden:true},
			{title:"소송위임변호사",         dataIndx:"LAWFIRM",       width:80, editable:false, hidden:true}
		];
		
		var obj = {
			height: 700,
			scrollModel: {autoFit: true},
			title: "소송 대장(소송명 클릭 시 상세정보를 볼 수 있습니다.)",
			resizable: true,
			colModel:colModel,
			dataModel:dataModel,
			groupModel:groupModel,
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
			resizable: false,
			virtualX: true,
			virtualY: true,
			hwrap: false,
			wrap: false
		};
		
		$("#btnSubmit").click(function() {
			var val = $(':radio[name="suitDateGbn"]:checked').val();
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(),searchGbn:searchGbn,dategbn:val } );
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
					<input type="radio" name="suitDateGbn" class="suitDateGbn" value="1" checked="checked"/><label>  제/피소일  </label>
					<input type="radio" name="suitDateGbn" class="suitDateGbn" value="2"/><label>  판결확정일  </label>
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
