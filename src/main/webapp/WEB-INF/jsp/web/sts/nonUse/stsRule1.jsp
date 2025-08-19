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
		$(function () {
			var box3 = $('.innerB');
			var subCCW = box3.width();
			$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
			$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);

	        var colModel= [
	            { title: "현행", dataType: "integer", dataIndx: "CNT1" , cls:"leftCol", editable: false, width: 80 },
	            { title: "폐지", dataType: "integer", dataIndx: "CNT2" , cls:"leftCol", editable: false, width: 80 },
	            { title: "연혁", dataType: "integer", dataIndx: "CNT3" , cls:"leftCol", editable: false, width: 80 }
	        ];
	        var dataModel = {
	            location: "remote",
	            dataType: "json",
	            method: "GET",
	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw1.do",
	            getData: function (dataJSON) {
	                var data1 = dataJSON.data1;
	                return {  data: data1 };
	            }
	        };

	        $("#grid_jsonp").pqGrid({
	            height: 100,
	            width : 300,
	            scrollModel: {autoFit: true},
	            dataModel: dataModel,
	            colModel: colModel,                                                            
	            title: "자치법규 운영 현황",
	            resizable: false
	        });
	        
	        var obj = {
    	            height: 500,
    	            width : 300,
    	            scrollModel: {autoFit: true},
    	            title: "상세입안단계",
    	            resizable: false
    	        };
	        
	        obj.colModel = [
	       	            { title: "프로세스현황",  dataIndx: "STATECD" ,editable: false, width: 180 },
	       	            { title: "건수", dataType: "integer", dataIndx: "CNT" ,editable: false, width: 80 }
	       	        ];
   	        obj.dataModel = {
   	            location: "remote",
   	            dataType: "json",
   	            method: "GET",
   	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw1.do",
   	            getData: function (dataJSON) {
   	                var data2 = dataJSON.data2;
   	                return {  data: data2 };
    	            }
    	        };
		   	    obj.rowClick=function(evt,ui){
		   	    	if (ui.rowData) {
		   	    		var rowIndx = ui.rowIndx,
	                     colIndx = ui.colIndx,
	                     dataIndx = ui.dataIndx,
	                     cellData = ui.rowData[dataIndx];
		   	    		//alert(ui.rowData['STATEID']);
		   	    		
		   	    	 	//$("#grid_jsonp3").pqGrid( "option" , "dataModel",{data:dataModel3.data} );//
		   	  			//$("#grid_jsonp3").pqGrid("refreshDataAndView");
		   	    	 	
		   	  		  $( "#grid_jsonp3" ).pqGrid("option","dataModel.location","remote");
			   	      $( "#grid_jsonp3" ).pqGrid("option","dataModel.postData", { statecd: ui.rowData['STATECD'] } );
			   	      $( "#grid_jsonp3" ).pqGrid( "refreshDataAndView" );
		   	    	}
		         }; 
		         obj.toolbar= {
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
		                        saveAs(blob, "상세입안단계."+ format );
		                    }
		                }]
		         }
    	        $("#grid_jsonp2").pqGrid(obj);
    	        
    	        var colModel3= [
    		     	            { title: "상세입안단계", dataIndx: "STATECD" ,editable: false, width: 180 },
    		     	            { title: "자치법규명",  dataIndx: "TITLE" ,editable: false, width: 360 },
    		     	           	{ title: "개정차수", dataType: "integer", dataIndx: "REVCHA", align:'center' ,editable: false, width: 80 },
    		     	          	{ title: "제정·개정구분",  dataIndx: "REVCD" , align:'center',editable: false, width: 200 }
    		     	        ];
    	        var dataModel3 = {
    		            location: "remote",
    		            dataType: "json",
    		            method: "GET",
    		            url: "${pageContext.request.contextPath}/web/statistics/getBylaw1.do",
    		            getData: function (dataJSON) {
    		                var data3 = dataJSON.data3;
    		                return {  data: data3 };
    		            }
    		       	};
    		
    	        $("#grid_jsonp3").pqGrid({
    		            height: 500,
    		            width : subCCW-350,
    		            scrollModel: {autoFit: true},
    		            dataModel: dataModel3,
    		            colModel: colModel3,                                                            
    		            title: "자치법규목록",
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
    		                        saveAs(blob, "제정·개정현황."+ format );
    		                    }
    		                }]
    		            }
    		        });
	    });
		
		</script>
		
		
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<div id="grid_jsonp"></div>
		<hr class="margin20">
		<div class="tableOverW">
			<div class="alignL" style="float:left;">
				<div id="grid_jsonp2"></div>
			</div>
			<div class="alignR" style="float:left;padding-left:20px">
				<div id="grid_jsonp3"></div>
			</div>
		</div>
	</div>
</div>
