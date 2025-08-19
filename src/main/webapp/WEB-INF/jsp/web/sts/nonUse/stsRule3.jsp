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
<style>
	.leftCol:hover{cursor:pointer; text-decoration:underline;}
</style>
	<script type="text/javascript">
		$(window).resize(function() {
			var box3 = $('.innerB');
			var subCCW = box3.width();
			$( "#grid_jsonp1" ).pqGrid('option', 'width', subCCW-520)
                    .pqGrid('refresh');
		})
		$(function () {
			var box3 = $('.innerB');
			var subCCW = box3.width();
			
			$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
			$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);

			var obj = {
    	            height: 600,
    	            width : 480,
    	            scrollModel: {autoFit: true},
    	            title: "부서별 자치법규 운영 현황",
    	            resizable: false,
    	            toolbar: {
    	                items: [{
    	                    type: 'select',
    	                    label: 'Format: ',                
    	                    attr: 'id="export_format"',
    	                    options: [{ xlsx: 'Excel', csv: 'Csv', htm: 'Html', json: 'Json'}]
    	                },{
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
    	                        saveAs(blob, "부서별 자치법규 운영현황."+ format );
    	                    }
    	                }]
    	            }
    	        };
	        
	        obj.colModel = [
	       	            { title: "부서",     dataType: "string", dataIndx: "DEPT_NAME", cls:"leftCol", editable: false, width: 180 },
	       	         	{ title: "조례",     dataType: "integer", dataIndx: "A1" ,      cls:"leftCol", editable: false, width: 80 },
	       	         	{ title: "규정",     dataType: "integer", dataIndx: "A2" ,      cls:"leftCol", editable: false, width: 80 },
	       	      		{ title: "규칙",     dataType: "integer", dataIndx: "A3" ,      cls:"leftCol", editable: false, width: 80 },
	       	   			{ title: "시행세칙", dataType: "integer", dataIndx: "A4" ,      cls:"leftCol", editable: false, width: 80 },
	       	   			{ title: "예규",     dataType: "integer", dataIndx: "A5" ,      cls:"leftCol", editable: false, width: 80 },
	       	   			{ title: "의회훈령", dataType: "integer", dataIndx: "A6" ,      cls:"leftCol", editable: false, width: 80 },
	       	   			{ title: "훈령",     dataType: "integer", dataIndx: "A7" ,      cls:"leftCol", editable: false, width: 80 },
	       	 			{ title: "소계",     dataType: "integer", dataIndx: "TOTAL" ,   cls:"leftCol", editable: false, width: 80 }
	       	        ];
			
   	        obj.dataModel = {
   	            location: "remote",
   	            dataType: "json",
   	            method: "post",
   	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw6.do",
   	            getData: function (dataJSON) {
   	                var data = dataJSON.data;
   	                return {  data: data };
    	            }
    	        };
		   	obj.cellClick=function(evt,ui){
	   	    	if (ui.rowData) {
	   	    		var rowIndx = ui.rowIndx,
                     colIndx = ui.colIndx,
                     dataIndx = ui.dataIndx,
                     cellData = ui.rowData[dataIndx];
	   	    		
	   	    	 var bookcd;
	   	    	 if(colIndx == 0 || colIndx == 8){
	   	    		bookcd = "";
	   	    	  }else if(colIndx == 1){
	   	    		bookcd = "조례";
	   	    	  }else if(colIndx == 2){
	   	    		bookcd = "규정";
	   	    	  }else if(colIndx == 3){
	   	    		bookcd = "규칙";
	   	    	  }else if(colIndx == 4){
	   	    		bookcd = "시행세칙";
	   	    	  }else if(colIndx == 5){
	   	    		bookcd = "예규";
	   	    	  }else if(colIndx == 6){
	   	    		bookcd = "의회훈령";
	   	    	  }else if(colIndx == 7){
	   	    		bookcd = "훈령";
	   	    	  }
	   	    	 
	   	  		  $( "#grid_jsonp1" ).pqGrid("option","dataModel.location","remote");
		   	      $( "#grid_jsonp1" ).pqGrid("option","dataModel.postData", { dept: ui.rowData['DEPT'] , bookcd : bookcd} );
		   	      $( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
	   	    	}
	         }; 
   	        $("#grid_jsonp").pqGrid(obj);
	        var colModel1= [
  	            { title: "자치법규운영부서", dataType: "string",align:'center', dataIndx: "DEPT_NAME" ,editable: false, width: 80 },
  	            { title: "자치법규형태", dataType: "string",align:'center', dataIndx: "BOOKCD" ,editable: false, width: 80 },
  	            { title: "자치법규명", dataType: "string", dataIndx: "TITLE" ,editable: false, width: 180 },
  	            { title: "최근개정차수", dataType: "string",align:'center', dataIndx: "REVCHA" ,editable: false, width: 80 },
  	          	{ title: "최근개정시행일", dataType: "string",align:'center', dataIndx: "STARTDT" ,editable: false, width: 80 }
  	        ];
  	        var dataModel1 = {
  	            location: "remote",
  	            dataType: "json",
  	            method: "post",
  	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw6.do",
  	            getData: function (dataJSON) {
  	                var data = dataJSON.data;
  	                return {  data: data };
  	            }
  	        };

  	        $("#grid_jsonp1").pqGrid({
  	            height: 600,
  	          	width : subCCW-520,
  	            scrollModel: {autoFit: true},
  	            dataModel: dataModel1,
  	            colModel: colModel1,                                                            
  	            title: "부서별 자치법규 상세 운영 현황",
  	            resizable: true,
  	          	toolbar: {
	                items: [{
	                    type: 'select',
	                    label: 'Format: ',                
	                    attr: 'id="export_format"',
	                    options: [{ xlsx: 'Excel', csv: 'Csv', htm: 'Html', json: 'Json'}]
	                },{
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
	                        saveAs(blob, "부서별자치법규상세운영현황."+ format );
	                    }
	                }]
	            }
  	        });
	        	        
	        $("#btnSubmit").click(function() {
	        	$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
				$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", { schText: $("#schText").val(),txtStartDate:$("#txtStartDate").val(),txtEndDate:$("#txtEndDate").val() } );
				$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
	    	});
	    });
		</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
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
