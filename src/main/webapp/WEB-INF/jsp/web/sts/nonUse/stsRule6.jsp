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
			$( "#grid_jsonp1" ).pqGrid('option', 'width', subCCW-350)
                    .pqGrid('refresh');
		})
		$(function () {
			var box3 = $('.innerB');
			var subCCW = box3.width();
			$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
			$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);

			var obj = {
    	            height: 600,
    	            width : 300,
    	            scrollModel: {autoFit: true},
    	            title: "연도별 개정건수",
    	            resizable: false
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
	                        saveAs(blob, "연도별 개정건수."+ format );
	                    }
	                }]
	         }
	        obj.colModel = [
	       	            { title: "구분", dataType: "integer", dataIndx: "YYYY",  cls:"leftCol", editable: false, width: 180, align:'center'},
	       	            { title: "개정", dataType: "integer", dataIndx: "M1" ,   cls:"leftCol", editable: false, width: 80 },
	       	         	{ title: "신설", dataType: "integer", dataIndx: "M2" ,   cls:"leftCol", editable: false, width: 80 },
	       	      		{ title: "폐지", dataType: "integer", dataIndx: "M3" ,   cls:"leftCol", editable: false, width: 80 },
	       	   			{ title: "계",   dataType: "integer", dataIndx: "TOTAL", cls:"leftCol", editable: false, width: 80 },
	       	        ];
			
   	        obj.dataModel = {
   	            location: "remote",
   	            dataType: "json",
   	            method: "POST",
   	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw3.do",
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
	   	    		
	   	    		
	   	    	  var revcd;
	   	    	  if(colIndx == 0||colIndx == 4){
	   	    		  revcd = "A";
	   	    	  }else if(colIndx == 1){
	   	    		  revcd = "R";
	   	    	  }else if(colIndx == 2){
	   	    		  revcd = "N";
	   	    	  }else if(colIndx == 3){
	   	    		  revcd = "C";
	   	    	  }
	   	  		  $( "#grid_jsonp1" ).pqGrid("option","dataModel.location","remote");
		   	      $( "#grid_jsonp1" ).pqGrid("option","dataModel.postData", { year: ui.rowData['YYYY'],revcd:revcd } );
		   	      $( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
	   	    	}
	         }; 
   	        $("#grid_jsonp").pqGrid(obj);
	        
	        var colModel1= [
  	            { title: "공포일", dataType: "integer", dataIndx: "PROMULDT" ,align:'center',editable: false, width: "15%" },
  	            { title: "개정시행일", dataType: "integer", dataIndx: "STARTDT" ,align:'center',editable: false, width:"15%" },
  	            { title: "규정명", dataType: "string", dataIndx: "TITLE" ,editable: false},
  	            { title: "개정구분", dataType: "integer", dataIndx: "REVCD" ,align:'center',editable: false, width: "15%" }
  	        ];
  	        var dataModel1 = {
  	            location: "remote",
  	            dataType: "json",
  	            method: "GET",
  	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw3.do",
  	            getData: function (dataJSON) {
  	                var data = dataJSON.data;
  	                return {  data: data };
  	            }
  	        };

  	        $("#grid_jsonp1").pqGrid({
  	            height: 600,
  	          	width : subCCW-350,
  	            scrollModel: {autoFit: true},
  	            dataModel: dataModel1,
  	            colModel: colModel1,                                                            
  	            title: "연도별 개정 상세 현황",
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
	                        saveAs(blob, "연도별개정상세현황."+ format );
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
