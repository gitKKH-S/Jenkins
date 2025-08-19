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
	var c7 = [];
	var c8 = [];
	function bindData() {
	
	    var jsonPath = "${pageContext.request.contextPath}/web/statistics/getMenuLogList.do";
	    $.ajaxSetup({ cache: false });
	
	    $.getJSON(jsonPath,{staticgbn:'s',txtStartDate:txtStartDate,txtEndDate:txtEndDate,searchGbn:searchGbn}, function(data) {
	
	        calcData(data);
	
	        drawChart($("#selChartType").val());
	
	
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
	    c6 = [];
	    c7 = [];
	    c8 = [];
	    
	    c9 = [];
	    c10 = [];
	    c11 = [];
	
	    var filteredList = [];
	    filteredList.push({name:c2});
	    $.each(data, function(i, item) {
	    	c1[i] = item.C1;
	    	c2[i] = parseInt(item.C2, 10);
	    	c3[i] = parseInt(item.C3, 10);
	    	c4[i] = parseInt(item.C4, 10);
	    	c5[i] = parseInt(item.C5, 10);
	    	c6[i] = parseInt(item.C6, 10);
	    	c7[i] = parseInt(item.C7, 10);
	    	c8[i] = parseInt(item.C8, 10);
	    	
	    	c9[i] = parseInt(item.C9, 10);
	    	c10[i] = parseInt(item.C10, 10);
	    	c11[i] = parseInt(item.C11, 10);
	    });
	}
	function drawChart(type) {
		var textsub = getChecked_value() + ' top메뉴 접속자수';
	    var options = {
	        chart: {
	            renderTo: 'dvChart',
	            type: type
	        },
	        title: {
	            text: '메뉴별 접속자정보'
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
	                text: '접속수'
	            }
	        },
	        tooltip: {
	            headerFormat: '<span style="font-size:13px">[{point.key}]</span><table style="width:160px;">',
	            pointFormat: '<tr><td style="color:{series.color};padding:0;font-size:13px">{series.name}: </td>' +
	                '<td style="padding:0;font-size:13px;text-align:right;"><b>{point.y}명</b></td></tr>',
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
	        series: [{name: 'c2'}, {name: 'c3'}, {name: 'c4'}, {name: 'c5'}, {name: 'c6'}, {name: 'c7'}, {name: 'c8'}, {name: 'c9'}, {name: 'c10'}, {name: 'c11'}]
	    }
	
	    options.xAxis.categories = c1;
	    options.xAxis.tickInterval = parseInt(c1.length / 3);
	    
	    if (type == "pie") {
	    	options.series[0].name = "소송·심판";
	        options.series[0].data = c2;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[1].name = "자문";
	        options.series[1].data = c3;
	        options.series[1].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[2].name = "협약";
	        options.series[2].data = c4;
	        options.series[2].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[3].name = "자치법규";
	        options.series[3].data = c5;
	        options.series[3].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[4].name = "법률정보";
	        options.series[4].data = c6;
	        options.series[4].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[5].name = "자료실";
	        options.series[5].data = c7;
	        options.series[5].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[6].name = "게시판";
	        options.series[6].data = c8;
	        options.series[6].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[7].name = "국가법령정보";
	        options.series[7].data = c9;
	        options.series[7].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[8].name = "법률도서관";
	        options.series[8].data = c10;
	        options.series[8].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[9].name = "전자소송";
	        options.series[9].data = c11;
	        options.series[9].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	    }
	    else {
	    	options.series[0].name = "소송·심판";
	        options.series[0].data = c2;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[1].name = "자문";
	        options.series[1].data = c3;
	        options.series[1].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[2].name = "협약";
	        options.series[2].data = c4;
	        options.series[2].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[3].name = "자치법규";
	        options.series[3].data = c5;
	        options.series[3].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[4].name = "법률정보";
	        options.series[4].data = c6;
	        options.series[4].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[5].name = "자료실";
	        options.series[5].data = c7;
	        options.series[5].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[6].name = "게시판";
	        options.series[6].data = c8;
	        options.series[6].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[7].name = "국가법령정보";
	        options.series[7].data = c9;
	        options.series[7].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[8].name = "법률도서관";
	        options.series[8].data = c10;
	        options.series[8].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        options.series[9].name = "전자소송";
	        options.series[9].data = c11;
	        options.series[9].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	    }
	
	    new Highcharts.Chart(options);
	}
</script>