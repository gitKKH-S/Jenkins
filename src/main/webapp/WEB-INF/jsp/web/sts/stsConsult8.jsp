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
	.innerBtn {color:#009475; line-height:28px;}
	.leftCol:hover{cursor:pointer; text-decoration:underline;}
</style>
<script type="text/javascript">
	var txtStartDate;
	var txtEndDate;
	var searchGbn;
	
	$(window).resize(function() {
		var box3 = $('.innerB');
		var subCCW = box3.width();
		var height = window.innerHeight;
		$( "#grid_jsonp2" ).pqGrid('option', 'width', subCCW-300).pqGrid('refresh');
		$( "#grid_jsonp1" ).pqGrid('option', 'height', height-194).pqGrid('refresh');
		$( "#grid_jsonp2" ).pqGrid('option', 'height', height-194).pqGrid('refresh');
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
		var box3 = $('.innerB');
		var subCCW = box3.width();
		var height = window.innerHeight;
		
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		var subObj = {
			height: height-194,
			width : 260,
			scrollModel: {autoFit: true},
			title: "법인별 만족도 평균",
			resizable: false
		};
		
		subObj.colModel = [
			{ title: "법인명", dataType: "integer", dataIndx: "OFFICE" ,editable: false, width: 80 },
			{ title: "만족도 평균", dataType: "integer", dataIndx: "CNT" ,editable: false, width: 80 }
		];
		
		subObj.dataModel = {
			location: "remote",
			dataType: "json",
			method: "GET",
			postData:{ txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val()},
			url: "${pageContext.request.contextPath}/web/statistics/getConsult8.do",
			getData: function (dataJSON) {
				var data2 = dataJSON.data2;
				return {  data: data2 };
			}
		}
		
		var obj = {
			height: height-194,
			width:subCCW-300,
			scrollModel: {autoFit: true},
			title: "자문 만족도 현황",
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
							saveAs(blob, "소송 만족도 현황."+ format );
						}
				}]
			}
		};
		
		obj.colModel = [
			{title:"CONSULTID",   dataType:"string", dataIndx:"CONSULTID", hidden:true},
			{title:"자문명",      dataType:"string", dataIndx:"TITLE",     editable:false, width:80},
			{title:"자문구분",    dataType:"string", dataIndx:"CSTTYPECD", editable:false, width:80},
			{title:"법인명",      dataType:"string", dataIndx:"OFFICE",    editable:false, width:80},
			{title:"만족도 총점", dataType:"string", dataIndx:"LVL",       editable:false, width:35, align:'center',
				render:function(ui){
					var rowData = ui.rowData;
					if(rowData.LVL == ""){
						return "<a href=\"#none\" style=\"font-size:12px; height:20px; color:#009475; line-height:19px;\" class=\"innerBtn\" onclick=\"sendSms('"+rowData.CONSULTID+"', 'N');\">문자발송</a>";
					}
				}
			}
		];
		
		obj.dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
			postData:{ txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val()},
			url: "${pageContext.request.contextPath}/web/statistics/getConsult8.do",
			getData: function (dataJSON) {
				var data1 = dataJSON.data1;
				return {data:data1};
			}
		};
		
		$("#btnSubmit").click(function() {
			$( "#grid_jsonp1" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp1" ).pqGrid("option","dataModel.postData", { txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(),searchGbn:searchGbn } );
			$( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
			
			$( "#grid_jsonp2" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp2" ).pqGrid("option","dataModel.postData", { txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val(),searchGbn:searchGbn } );
			$( "#grid_jsonp2" ).pqGrid( "refreshDataAndView" );
		});
		
		var grid1 = pq.grid("#grid_jsonp1", subObj);
		var grid2 = pq.grid("#grid_jsonp2", obj);
	});
	
	function sendSms(consultid){
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/statistics/sendSms.do",
			data:{consultid:consultid, gbn:'CONSULT'},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
			}
		});
		
	}
	
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
		
		<div class="tableOverW">
			<div class="alignL" style="float:left;">
				<div id="grid_jsonp1"></div>
			</div>
			<div class="alignR" style="float:left;padding-left:20px">
				<div id="grid_jsonp2"></div>
			</div>
		</div>
	</div>
</div>
