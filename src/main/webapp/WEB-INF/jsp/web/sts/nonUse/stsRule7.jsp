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
<link id="calendar_month" href="${resourceUrl}/css/calendar_month.css" rel="stylesheet" />
<link id="calendar_year" href="${resourceUrl}/css/calendar_year.css" rel="stylesheet" />
<script src="${resourceUrl}/js/mten.statistics.js"></script>
<style>
	.leftCol:hover{cursor:pointer; text-decoration:underline;}
</style>
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
		function bindData() {
			
		}
		function goDetail(obookid,title){
			var frm = document.stat;
			frm.obookid.value=obookid;
			frm.title.value=title;
			frm.action = "statisticsListState4.jsp";
			frm.submit();
		}
		function reLoad(){
			var frm = document.stat;
			for(i=0; i<frm.searchGbn.length; i++){
				if(frm.searchGbn[i].checked){
					frm.searchGbn.value=frm.searchGbn[i].value;
				}
			}
			for(i=0; i<frm.docType.length; i++){
				if(frm.docType[i].checked){
					frm.docType.value=frm.docType[i].value;
				}
			}
			frm.submit();
		}
		function viewHwp(){
			window.open("hwpAllPrint.jsp");
		}
		
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
    	            title: "자치법규리스트",
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
    	                        saveAs(blob, "자치법규리스트."+ format );
    	                    }
    	                }]
    	            }
    	        };
	        
	        obj.colModel = [
	       	            { title: "자치법규명", dataType: "string", dataIndx: "TITLE" , cls:"leftCol", editable: false, width: 180 }
	       	        ];
			
   	        obj.dataModel = {
   	            location: "remote",
   	            dataType: "json",
   	            method: "GET",
   	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw4.do",
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
	   	    		
	   	  		  $( "#grid_jsonp1" ).pqGrid("option","dataModel.location","remote");
		   	      $( "#grid_jsonp1" ).pqGrid("option","dataModel.postData", { obookid: ui.rowData['OBOOKID'] } );
		   	      $( "#grid_jsonp1" ).pqGrid( "refreshDataAndView" );
	   	    	}
	         }; 
   	        $("#grid_jsonp").pqGrid(obj);
	        
	        var colModel1= [
  	            { title: "공포일", dataType: "string", dataIndx: "PROMULDT" ,align:'center' ,editable: false, width: 80 },
  	            { title: "개정시행일", dataType: "string", dataIndx: "STARTDT" ,align:'center' ,editable: false, width: 80 },
  	            { title: "자치법규명", dataType: "string", dataIndx: "TITLE" ,editable: false, width: 180 },
  	            { title: "개정구분", dataType: "string", dataIndx: "REVCD" ,align:'center' ,editable: false, width: 80 }
  	        ];
  	        var dataModel1 = {
  	            location: "remote",
  	            dataType: "json",
  	            method: "GET",
  	            url: "${pageContext.request.contextPath}/web/statistics/getBylaw4.do",
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
  	            title: "자치법규별 개정이력",
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
	                        saveAs(blob, "자치법규별 개정이력."+ format );
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
		<table class="infoTable write" style="width:100%;display:none;">
			<colgroup>
				<col style="width:10%;">
				<col style="width:20%;">
				<col style="width:*;">
				<col style="width:15%;">
				<col style="width:10%;">
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
				<th><input type="text" name="schText" id="schText"  style="width:150px"/></th>
				<td>
					<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
				</td>
			</tr>
		</table>
	</div>
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
