<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<link id="calendar_month" href="${resourceUrl}/css/calendar_month.css" rel="stylesheet" />
<link id="calendar_year" href="${resourceUrl}/css/calendar_year.css" rel="stylesheet" />
<script src="${resourceUrl}/js/mten.statistics.js"></script>
<script src="${resourceUrl}/Highcharts-7.2.0/code/highcharts.js"></script>
<script src="${resourceUrl}/Highcharts-7.2.0/code/modules/exporting.js"></script>
<script src="${resourceUrl}/Highcharts-7.2.0/code/modules/export-data.js"></script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<table class="infoTable write" style="width:100%">
			<colgroup>
				<col style="width:10%;">
				<col style="width:10%;">
				<col style="width:10%;">
				<col style="width:*;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>차트종류</th>
				<td>
					<select id="selChartType" class="subSearchType">
		                <option id="opChartType00" value="column">막대차트</option>
		                <option id="opChartType01" value="line">라인차트</option>
		                <option id="opChartType02" value="pie">파이차트</option>
		            </select>
				</td>
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
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
	</div>
	<div class="innerB">
		<div id="dvChart"></div>
	</div>
</div>
<script type="text/javascript">
	var txtStartDate;
	var txtEndDate;
	var searchGbn;
	
	var subtitle = [];
	
	function getChecked_value(){
		var obj = document.getElementsByName('searchGbn');
		var txt = ['일별','월별','년도별'];
		for( i=0; i<obj.length; i++) {
			if(obj[i].checked) {
				return txt[i];
			}
		}
	}
	var c1 = [];
	var c2 = [];
	var c3 = [];
	var c4 = [];
	var c5 = [];
	var c6 = [];
	function bindData() {
	
	    var jsonPath = "${pageContext.request.contextPath}/web/statistics/getConsult9.do";
	    $.ajaxSetup({ cache: false });
	
	    $.getJSON(jsonPath,{staticgbn:'s3',txtStartDate:txtStartDate,txtEndDate:txtEndDate,searchGbn:searchGbn}, function(data) {
	
	        calcData(data);
	
	        drawChart($("#selChartType").val());
	
	
	    }).error(function(jqXHR, textStatus, errorThrown) {
	        alert("error occured!\nStatus : " + textStatus + "\nError : " + errorThrown);
	    });
	}
	
	function calcData(data) {
	    
	    c1 = [];
	    c2 = [];

	    var filteredList = [];
	    filteredList.push({name:c2},{name:c3},{name:c4},{name:c5},{name:c6});
	    $.each(data, function(i, item) {
	    	c1[i] = item.C1;
	    	c2[i] = parseInt(item.C2, 10);
	    });

	}
	function drawChart(type) {
		subtitle = [$("#txtStartDate").val(), $("#txtEndDate").val()];
		var endDate = subtitle[0,1]==''?'': ' ~ ' + subtitle[0,1]
		var textsub = subtitle[0,0] + endDate +'  자문 요청 부서 랭킹';
	    var options = {
	        chart: {
	            renderTo: 'dvChart',
	            type: type
	        },
	        title: {
	        	text: '기간별 자문 요청 부서  랭킹'
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
	                text: '요청수'
	            }
	        },
	        tooltip: {
	        	headerFormat: '<span style="font-size:13px">[{point.key}]</span><table style="width:120px;">',
                pointFormat: '<tr><td style="color:{series.color};padding:0;font-size:13px">{series.name}: </td>' +
                    '<td style="padding:0;font-size:13px;text-align:right;"><b>{point.y}회</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
	            enabled: true,
	            useHTML: true
	        },
	        plotOptions: {
	            column: {
	                pointPadding: 0.2,
	                borderWidth: 0
	            }
	        },
	        series: [{name: 'c2'}]
	    }
	    
	    options.xAxis.categories = c1;
	    options.xAxis.tickInterval = 1;
	
	    if (type == "pie") {
	        options.series[0].name = "검색어";
	        options.series[0].data = c2;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	    }
	    else {
	        options.series[0].name = "검색어";
	        options.series[0].data = c2;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	    }
	
	    new Highcharts.Chart(options);
	}
</script>