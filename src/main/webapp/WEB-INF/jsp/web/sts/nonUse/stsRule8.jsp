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
	<script type="text/javascript">
		$(function () {
			$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
			$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);

			var obj = {
    	            height: 600,
    	            scrollModel: {autoFit: true},
    	            title: "자치법규관리 대장",
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
    	                        saveAs(blob, "자치법규관리대장."+ format );
    	                    }
    	                }]
    	            }
    	        };
	        obj.colModel = [
	       	            { title: "운용부서", dataType: "string",align:'center', dataIndx: "DEPTNAME" ,editable: false, width: 80 },
	       	            { title: "자치법규명", dataType: "string", dataIndx: "TITLE" ,editable: false, width: 360 },
		       	        { title: "자치법규구분", dataType: "string",align:'center', dataIndx: "BOOKCD" ,editable: false, width: 80 },
		       	      	{ title: "제정·개정", dataType: "string",align:'center', dataIndx: "REVCD" ,editable: false, width: 80 },
	       	         	//{ title: "문서번호", dataType: "string",align:'center', dataIndx: "BOOKCODE" ,editable: false, width: 80 },
	       	      		//{ title: "공포번호", dataType: "string",align:'center', dataIndx: "PROMULNO" ,editable: false, width: 80 },
	       	   			{ title: "공포일", dataType: "string",align:'center', dataIndx: "PROMULDT" ,editable: false, width: 80 },
	       	   			{ title: "시행일", dataType: "string",align:'center', dataIndx: "STARTDT" ,editable: false, width: 80 }
	       	        ];
			
   	        obj.dataModel = {
   	            location: "remote",
   	            dataType: "json",
   	            method: "GET",
   	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw7.do",
   	            getData: function (dataJSON) {
   	                var data = dataJSON.data;
   	                return {  data: data };
    	            }
    	        };
		   	obj.cellDblClick=function(evt,ui){
	         }; 
   	        $("#grid_jsonp").pqGrid(obj);
	    });
	</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<div id="grid_jsonp"></div>
	</div>
</div>
