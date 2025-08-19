 $(document).ready(function() {
	 	getCurrentDate();
 		$.datepicker.regional['ko'] = { //기본 datePicker 셋팅
	  		dateFormat:'yy-mm-dd',
	  	    prevText: '이전 달',
	  	    nextText: '다음 달',
	  	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	  	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	  	    dayNames: ['일','월','화','수','목','금','토'],
	  	    dayNamesShort: ['일','월','화','수','목','금','토'],
	  	    dayNamesMin: ['일','월','화','수','목','금','토'],
	  	    showMonthAfterYear: true,
	  	    yearSuffix: '년',
	      	changeMonth: true,
	      	changeYear: true
 		};
 		$.datepicker.setDefaults($.datepicker.regional['ko']);
 		
 		//월별 검색시 사용되는 datePicker 셋팅 시작
	    var datepicker_default_month = {
	        buttonText: "달력",
	        currentText: "이번달",
	        changeMonth: true,
	        changeYear: true,
	        showButtonPanel: true,
	        yearRange: 'c-99:c+99',
	        showOtherMonths: true,
	        selectOtherMonths: true
	    }
	 
	    datepicker_default_month.closeText = "선택";
	    datepicker_default_month.dateFormat = "yy-mm";
	    datepicker_default_month.onClose = function (dateText, inst) {
	        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
	        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
	        $(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
	        $(this).datepicker('setDate', new Date(year, month, 1));
	    }
	 
	    datepicker_default_month.beforeShow = function () {
	    	$(".ui-datepicker-calendar").css("display","none");
	        var selectDate = $("#txtStartDate").val().split("-");
	        var year = Number(selectDate[0]);
	        var month = Number(selectDate[1]) - 1;
	        $(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
	    }
 		//월별 검색시 사용되는 datePicker 셋팅 끝
	    
	    //년도별 검색시 사용되는 datePicker 셋팅 시작
	    var datepicker_default_year = {
	        buttonText: "달력",
	        currentText: "올해",
	        changeYear: true,
	        showButtonPanel: true,
	        yearRange: 'c-22:c+99',
	    }
	 
	    datepicker_default_year.closeText = "선택";
	    datepicker_default_year.dateFormat = "yy";
	    datepicker_default_year.onClose = function (dateText, inst) {
	    	var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
	        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
	        $(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
	        $(this).datepicker('setDate', new Date(year, month, 1));
	    }
	 
	    datepicker_default_year.beforeShow = function () {
	    	var selectDate = $("#txtStartDate").val().split("-");
	        var year = Number(selectDate[0]);
	        var month = Number(selectDate[1]) - 1;
	        $(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
	    }
	    //년도별 검색시 사용되는 datePicker 셋팅 끝
	    
	    $("#txtStartDate").datepicker(); //페이지 처음 올라올때 엘리먼트에 datePicker 붙임
	    $("#txtEndDate").datepicker();
	    
	    document.getElementById('calendar_month').disabled = true; //페이지 처음 올라올때 jsp페이지에 선언되어 있는 스타일 시트를 사용안하기위해
		document.getElementById('calendar_year').disabled = true;
		
	    txtStartDate = $("#txtStartDate").val();
        txtEndDate =  $("#txtEndDate").val();
		
        bindData();
        
        $(".searchGbn").click(function(event){//라디오 버튼 클릭시
        	var radioValue = $(':radio[name="searchGbn"]:checked').val();
        	$("#txtStartDate").val("");//해당 엘리먼트의 값을 초기화
        	$("#txtEndDate").val("");
        	$("#txtStartDate").datepicker("destroy");//해당 엘리먼트의 적용되어있던 datePicker 해제
        	$("#txtEndDate").datepicker("destroy");
        	//조건에 따라 일별 월별 년도별 datePicker를 해당 엘리먼트에 붙임
        	if(radioValue == 'd'){
        		$("#txtStartDate").datepicker();
        		$("#txtEndDate").datepicker();
        		document.getElementById('calendar_month').disabled = true;
        		document.getElementById('calendar_year').disabled = true;
        	}else if(radioValue == 'm'){
        		$("#txtStartDate").datepicker(datepicker_default_month);
        		$("#txtEndDate").datepicker(datepicker_default_month);
        		document.getElementById('calendar_month').disabled = false;
        		document.getElementById('calendar_year').disabled = true;
        	}else if(radioValue == 'y'){
        		$("#txtStartDate").datepicker(datepicker_default_year);
        		$("#txtEndDate").datepicker(datepicker_default_year);
        		document.getElementById('calendar_month').disabled = true;
        		document.getElementById('calendar_year').disabled = false;
        	}
        });
        
        $("#btnSubmit").click(function(event) {
            selectedChartType = $("#selChartType").val();
            txtStartDate = $("#txtStartDate").val();
            txtEndDate =  $("#txtEndDate").val();
            searchGbn =  $(':radio[name="searchGbn"]:checked').val();
            searchGbn2 =  $(':radio[name="searchGbn2"]:checked').val();
            searchGbn3 =  $('#searchGbn3').val();
            bindData();
        });

        $("#selAge, #selChartType, #selGame").change(function(event) {
            selectedChartType = $("#selChartType").val();
            txtStartDate = $("#txtStartDate").val();
            txtEndDate =  $("#txtEndDate").val();
            searchGbn =  $(':radio[name="searchGbn"]:checked').val();
            bindData();
        });
        
    });
 /*
	function getCurrentDate(){
		var today = new Date();
		var lastMonthDay = new Date(today.getFullYear(),today.getMonth(),today.getDate()-6);
		var startDate = "";
		var endDate = "";
		var radioValue = $(':radio[name="searchGbn"]:checked').val();
		console.log(radioValue);
		if(radioValue == 'd'){
			startDate = today.getFullYear()+'-'+((today.getMonth()+1)<10 ? '0'+(today.getMonth()+1) : (today.getMonth()+1))+'-'+(today.getDate()<10 ? '0'+today.getDate() : today.getDate());
			endDate = lastMonthDay.getFullYear()+'-'+((lastMonthDay.getMonth()+1)<10 ? '0'+(lastMonthDay.getMonth()+1) : (lastMonthDay.getMonth()+1))+'-'+(lastMonthDay.getDate()<10 ? '0'+lastMonthDay.getDate() : lastMonthDay.getDate());
			
			$("#txtStartDate").datepicker();
			$("#txtEndDate").datepicker();
			document.getElementById('calendar_month').disabled = true;
			document.getElementById('calendar_year').disabled = true;
		}else if(radioValue == 'm'){
			startDate = today.getFullYear()+'-'+((today.getMonth()+1)<10 ? '0'+(today.getMonth()+1) : (today.getMonth()+1));
			endDate = lastMonthDay.getFullYear()+'-'+((lastMonthDay.getMonth()+1)<10 ? '0'+(lastMonthDay.getMonth()+1) : (lastMonthDay.getMonth()+1));
			
			$("#txtStartDate").datepicker(datepicker_default_month);
			$("#txtEndDate").datepicker(datepicker_default_month);
			document.getElementById('calendar_month').disabled = false;
			document.getElementById('calendar_year').disabled = true;
		}else if(radioValue == 'y'){
			startDate = today.getFullYear();
			endDate = lastMonthDay.getFullYear();
			
			$("#txtStartDate").datepicker(datepicker_default_year);
			$("#txtEndDate").datepicker(datepicker_default_year);
			document.getElementById('calendar_month').disabled = true;
			document.getElementById('calendar_year').disabled = false;
		}
		document.getElementById("txtStartDate").value = endDate;
		document.getElementById("txtEndDate").value = startDate;
	}*/
 
 function getCurrentDate(){
		var today = new Date();
		var startDate = today.getFullYear()+'-'+((today.getMonth()+1)<10 ? '0'+(today.getMonth()+1) : (today.getMonth()+1))+'-'+(today.getDate()<10 ? '0'+today.getDate() : today.getDate());
		
		var lastMonthDay = new Date(today.getFullYear(),today.getMonth(),today.getDate()-6);
		var endDate = lastMonthDay.getFullYear()+'-'+((lastMonthDay.getMonth()+1)<10 ? '0'+(lastMonthDay.getMonth()+1) : (lastMonthDay.getMonth()+1))+'-'+(lastMonthDay.getDate()<10 ? '0'+lastMonthDay.getDate() : lastMonthDay.getDate());
		document.getElementById("txtStartDate").value = endDate;
		document.getElementById("txtEndDate").value = startDate;
}