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
		            <div style="display:none;">
		            	<input type="radio" name="searchGbn" class="searchGbn" value="d" checked="checked" /><label>  일별  </label>
				        <input type="radio" name="searchGbn" class="searchGbn" value="m" /><label>  월별  </label>
				        <input type="radio" name="searchGbn" class="searchGbn" value="y" /><label>  년도별    </label>
				        <input type="text" id="txtStartDate" maxlength="12" style="width:150px" readonly />
				        ~
				        <input type="text" id="txtEndDate" maxlength="12" style="width:150px" readonly/>
		            </div>
				</td>
					
			</tr>
		</table>
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
	var datas = [];
	function bindData() {
	    var jsonPath = "${pageContext.request.contextPath}/web/statistics/stsRuleData9.do";
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
	    datas = [];
	    var datap = [];
	    var filteredList = [];
	    filteredList.push({name:c2});
	    $.each(data, function(i, item) {
	    	datap = [];
	    	c1[i] = item.C1;
	    	c2[i] = parseInt(item.C2, 10);
	    	datap[0] = String(item.C3);
	    	datap[1] = parseInt(item.C2, 10);
	    	datas[i] = datap;
	    });
	}
	function drawChart(type) {
	    var options = {
	        chart: {
	            renderTo: 'dvChart',
	            type: type
	        },
	        title: {
	            text: '부서별 관리 자치법규 조회'
	        },
	        subtitle: {
	            text: '관리자치법규 정보'
	        },
	        xAxis: {
	            categories: [],
	            type: 'datetime'
	        },
	        yAxis: {
	            min: 0,
	            title: {
	                text: '자치법규 수'
	            }
	        },
	        tooltip: {
	        	headerFormat: '<span style="font-size:10px">[{point.category}]</span><table style="width:150px;">',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    		 '<td style="padding:0"><b>{point.y}건</b></td></tr><tr onclick="goList(\'{point.name}\')" style=\'cursor:pointer\'><td>자치법규 확인하기</td></tr>',
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
	    //options.xAxis.tickInterval = parseInt(c1.length / 3);
	
	    if (type == "pie") {
	        options.series[0].name = "규정";
	        options.series[0].data = datas;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        
	    }
	    else {
	        options.series[0].name = "규정";
	        options.series[0].data = datas;
	        options.series[0].dataLabels = { enabled: true, format: '<b>{point.y}</b>' };
	        
	    }
	
	    new Highcharts.Chart(options);
	}
	
	function goList(key){
		alert(key);
		var a = document.getElementsByName("bookcd");
		var bookcd = 'S';
		for(i=0; i<a.length; i++){
			if(a[i].checked){
				bookcd = a[i].value;
			}
		}
		url='<%=CONTEXTPATH %>/jsp/lkms3/jsp/popup/quickDeptList.jsp';
		cw=1000;
	    ch=668;
		sw=screen.availWidth;
		sh=screen.availHeight;
		px=(sw-cw)/2;
		py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=no,status=no,toolbar=no";
		window.open(url+"?deptseq="+key+"&deptname="+deptname+"&bookcd="+bookcd+"&txtEndDate="+document.all.txtEndDate.value, "key", property);
	
	}
</script>