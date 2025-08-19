<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>

<%
	Map<String,String> param = request.getAttribute("param")==null?new HashMap():(Map)request.getAttribute("param");
	String addParam1 = param.get("addParam1")==null?"":param.get("addParam1");
	String addParam2 = param.get("addParam2")==null?"":param.get("addParam2");
%>
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
<script type="text/javascript">
	var txtStartDate;
	var txtEndDate;
	var searchGbn;
	var searchGbn2;
	var searchGbn3;
	var addParam1 = '<%=addParam1%>';
	var addParam2 = '<%=addParam2%>';
	
	$(window).resize(function() {
		var box3 = $('.innerB');
		var subCCW = box3.width();
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
		$.extend($.paramquery.pqGrid.defaults, $.paramquery.pqGrid.regional['ko']);
		$.extend($.paramquery.pqPager.defaults, $.paramquery.pqPager.regional['ko']);
		
		var colModel = [
			{title:"관리번호",     dataType:"string", dataIndx:"CNSTN_DOC_NO",       editable:false},
			{title:"자문접수일자", dataType:"string", dataIndx:"CNSTN_RCPT_YMD",     editable:false},
			{title:"자문제목",     dataType:"string", dataIndx:"CNSTN_TTL",          editable:false},
			{title:"의뢰부서",     dataType:"string", dataIndx:"CNSTN_RQST_DEPT_NM", editable:false},
			{title:"담당변호사",   dataType:"string", dataIndx:"CNSTN_TKCG_EMP_NM",  editable:false},
			{title:"처리상태",     dataType:"string", dataIndx:"PRGRS_STTS_SE_NM",   editable:false},
			{title:"의뢰방법",     dataType:"string", dataIndx:"INOUTHAN",           editable:false},
			{title:"외부자문사유", dataType:"string", dataIndx:"OTSD_RQST_RSN",      editable:false},
			{title:"지급연월",     dataType:"string", dataIndx:"GIVE_YM",            editable:false},
			{title:"법률고문",     dataType:"string", dataIndx:"RVW_TKCG_EMP_NM",    editable:false},
			{title:"자문회신일자", dataType:"string", dataIndx:"CNSTN_RPLY_YMD",     editable:false},
			{title:"자문구분", dataType:"string", dataIndx:"CNSTN_SE_NM",     editable:false},
			
		];
		
		var dataModel = {
			location: "remote",
			dataType: "json",
			method: "POST",
		    postData: {
		    	searchGbn2: addParam1,
		    	searchGbn3: addParam2
		    },
			url: "${pageContext.request.contextPath}/web/statistics/getConsult2.do",
			getData: function (dataJSON) {
				var data = dataJSON;
				return {data:data};
			}
		};
		
		var groupModel = {
			on:true,
			merge:[true],
			dataIndx:[],
			collapsed:[false],
			grandSummary:[true],
			title:[
				"{0} ({1})",
				"{0} - {1}"
			]
		};
		
		var obj = {
			width: "100%",
			//autoFit: true,
			height: 500,
			colModel:colModel,
			dataModel:dataModel,
			groupModel:groupModel,
			//scrollModel: {autoFit: false},
			scrollModel: {autoFit: true},
			title: "자문대장",
			resizable: false,
			toolbar: {
				items:[
					{
						type:"button",
						label:"그룹핑변경",
						listener:function(evt){
							this.groupOption({
								on:!grid.option("groupModel.on")
							})
						}
					},
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
							saveAs(blob, "자문대장."+ format );
						}
					}
				]
			},
			virtualX: true,
			virtualY: true,
			hwrap: false,
			wrap: false
		};
		
		$("#btnSubmit").click(function() {
			$( "#grid_jsonp" ).pqGrid("option","dataModel.location","remote");
			$( "#grid_jsonp" ).pqGrid("option","dataModel.postData", {txtStartDate:$("#txtStartDate").val(), txtEndDate:$("#txtEndDate").val(), searchGbn:searchGbn, searchGbn2: searchGbn2, searchGbn3: searchGbn3} );
			$( "#grid_jsonp" ).pqGrid( "refreshDataAndView" );
		});
		
		var grid = pq.grid("#grid_jsonp", obj);
	});
	
</script>

<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<table class="infoTable write" style="width:100%;">
			<colgroup>
				<col style="width:10%;">
				<col style="width:20%;">
				<col style="width:*;">
				<col style="width:10%;">
				<col style="width:20%;">
				<col style="width:10%;">
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
					<input type="text" id="txtEndDate"   maxlength="12" style="width:150px" readonly/>
				</td>
				<th>의뢰방법</th>
				<td>
					<input type="radio" name="searchGbn2" class="searchGbn2" value="" <%if("".equals(addParam1)) out.println("checked"); %>/><label>  전체  </label>
					<input type="radio" name="searchGbn2" class="searchGbn2" value="I" <%if("I".equals(addParam1)) out.println("checked"); %>/><label>  내부  </label>
					<input type="radio" name="searchGbn2" class="searchGbn2" value="O" <%if("O".equals(addParam1)) out.println("checked"); %>/><label>  외부    </label>
				</td>
				<td>
					<select name="searchGbn3" id="searchGbn3" onchange=";">
						<option value="" <%if("".equals(addParam2)) out.println("selected");%>>전체</option>
						<option value="일반" <%if("일반".equals(addParam2)) out.println("selected");%>>일반</option>
						<option value="국제" <%if("국제".equals(addParam2)) out.println("selected");%>>국제</option>
					</select>
				</td>
				<td>
					<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
				</td>
			</tr>
		</table>
	</div>
	<div class="innerB">
		<div id="grid_jsonp"></div>
	</div>
</div>
