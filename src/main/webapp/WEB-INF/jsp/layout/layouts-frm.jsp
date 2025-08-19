<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018-12-30
  Time: 오후 5:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
<title><%=SYSTITLE %></title>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/common.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/layout.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/sub.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/table.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/ext-all-debug.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/src/locale/ext-lang-ko.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/css/ext-all.css" />


<!-- jquery -->
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.css">

<link rel="stylesheet" type="text/css" href="${resourceUrl}/mnview/css/extgrid.css" />
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/fontawesome/css/all.min.css" />

<script>
	Ext.BLANK_IMAGE_URL = "${resourceUrl}/extjs/resources/images/default/s.gif";
</script>
<script src="${resourceUrl}/js/mten.static.js"></script>
<%-- 
<script src="${resourceUrl}/appjs/approve/approve.js"></script>
<script src="${resourceUrl}/appjs/approve/tree.js"></script>
 --%>
<script src="${resourceUrl}/js/CryptoJSv3.1.2/crypto-js.min.js"></script>
<script src="${resourceUrl}/js/mten.session.js" type="text/javascript"></script>

<script>
	Ext.override(Ext.grid.GridView, {
	    initTemplates : function(){
	        var ts = this.templates || {};
	        if(!ts.master){
	            ts.master = new Ext.Template(
	                '<div class="x-grid3" hidefocus="true">',
	                    '<div class="x-grid3-viewport">',
	                        '<div class="x-grid3-header"><div class="x-grid3-header-inner" style="{ostyle}"><div class="x-grid3-header-offset">{header}</div></div><div class="x-clear"></div></div>',
	                        '<div class="x-grid3-scroller"><div class="x-grid3-body" style="{bstyle}">{body}</div><a></a></div>',
	                    '</div>',
	                    '<div class="x-grid3-resize-marker">&nbsp;</div>',
	                    '<div class="x-grid3-resize-proxy">&nbsp;</div>',
	                '</div>'
	            );
	        }
	        if(!ts.header){
	            ts.header = new Ext.Template(
	                '<table border="0" cellspacing="0" cellpadding="0" style="{tstyle}">',
	                '<thead><tr class="x-grid3-hd-row">{cells}</tr></thead>',
	                '</table>'
	            );
	        }
	        if(!ts.hcell){
	            ts.hcell = new Ext.Template(
	                '<td class="x-grid3-hd x-grid3-cell x-grid3-td-{id} {css}" style="{style}"><div {tooltip} {attr} class="x-grid3-hd-inner x-grid3-hd-{id}" unselectable="on" style="{istyle}">', this.grid.enableHdMenu ? '<a class="x-grid3-hd-btn" href="#"></a>' : '',
	                '{value}<img class="x-grid3-sort-icon" src="', Ext.BLANK_IMAGE_URL, '" />',
	                '</div></td>'
	            );
	        }
	        if(!ts.body){
	            ts.body = new Ext.Template('{rows}');
	        }
	        if(!ts.row){
	            ts.row = new Ext.Template(
	                '<div class="x-grid3-row {alt}" style="{tstyle}"><table class="x-grid3-row-table" border="0" cellspacing="0" cellpadding="0" style="{tstyle}">',
	                '<tbody><tr>{cells}</tr>',
	                (this.enableRowBody ? '<tr class="x-grid3-row-body-tr" style="{bodyStyle}"><td colspan="{cols}" class="x-grid3-body-cell" tabIndex="0" hidefocus="on"><div class="x-grid3-row-body">{body}</div></td></tr>' : ''),
	                '</tbody></table></div>'
	            );
	        }
	        if(!ts.cell){
	            ts.cell = new Ext.Template(
	                '<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}" tabIndex="0" {cellAttr}>',
	                '<div class="x-grid3-cell-inner x-grid3-col-{id}" unselectable="on" {attr}>{value}</div>',
	                '</td>'
	            );
	        }
	        for(var k in ts){
	            var t = ts[k];
	            if(t && typeof t.compile == 'function' && !t.compiled){
	                t.disableFormats = true;
	                t.compile();
	            }
	        }
	        this.templates = ts;
	        this.colRe = new RegExp("x-grid3-td-([^\\s]+)", "");
	    }
	});
	
	$(document).ready(function(){
		var inHei = window.innerHeight-20;
		document.body.style.height = inHei;
		$(window).resize(function() {
			inHei = window.innerHeight-20;
			document.body.style.height = inHei;
		});
		

		$.ajaxSetup({
			error : function(xhr, status, error) {
				console.log("에러 발생", xhr.status, xhr.responseText);
				if (xhr.status === 403) {
					const msg = JSON.parse(xhr.responseText);
					if(msg.errorCode=='PRIVACY_DETECTED'){
						alert(msg.message);
						return;
					}
					
				}
			}
		});		
		

		try{
			$(".datepick").datepicker({ 
				showOn:"both", 
				buttonImage:"${pageContext.request.contextPath}/resources/seoul/images/btn_calendar.png",
				dateFormat:'yy-mm-dd',
				buttonImageOnly:false,
				changeMonth:true,
				changeYear:true,
				nextText:'다음 달',
				prevText:'이전 달',
				yearRange:'c-100:c+10',
				showMonthAfterYear:true, 
				dayNamesMin:['일','월','화','수','목','금','토'],
				monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
			});
			
			$(".ui-datepicker-trigger").css({"vertical-align":"middle","margin-left":"1px"});
			$(".ui-datepicker-trigger").mouseover(function(){
				$(this).css('cursor','pointer');
			});
			jQuery.datepicker.setDefaults(jQuery.datepicker.regional['ko']);
		}catch(e){console.log(e);}
		$.ajax({
			type:'POST',
			url:'${pageContext.request.contextPath}/web/getSubTitle.do',
			dataType: "json",
			data : {"MENU_MNG_NO": "<%=request.getParameter("MENU_MNG_NO")%>"},
			async: false,
			error: function(){
				alert("서브화면 제목가져오기 오류 발생하였습니다.");
			},
			success:function(data){
				if(data){
					$("#subTT").html(data.MENU_TTL);	
				}
				
			}
		});
	});
	
	var openWin
	function popOpen(pname,url,wth,hht){
		var cw=wth;
		var ch=hht;
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=no,status=no,toolbar=no,location=no";
		openWin = window.open(url, pname, property);
		window.openWin.focus();
	}
	function setSubTitle(stitle){
		$("#subTT").html(stitle);
	}
	function goRegulationView(bookid,noformyn){
		var pop = location.href;
		if(pop.indexOf('Pop')>-1){
			pop = "Pop";
		}else{
			pop = "";
		}
		var frm = document.regulationF;
		frm.bookid.value = bookid;
		frm.noformyn.value = noformyn;
		frm.action="${pageContext.request.contextPath}/web/regulation/regulationView"+pop+".do";			
		frm.submit();
	}
	
	function comma(str) {
		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	function uncomma(str) {
		str = String(str);
		return str.replace(/[^\d]+/g, '');
	}
	
	function numFormat(obj){
		obj.value = comma(uncomma(obj.value));
	}
	function setDatePicker(){
		$(".datepick").datepicker({ 
			showOn:"both", 
			buttonImage:"${pageContext.request.contextPath}/resources/seoul/images/btn_calendar.png",
			dateFormat:'yy-mm-dd',
			buttonImageOnly:false,
			changeMonth:true,
			changeYear:true,
			nextText:'다음 달',
			prevText:'이전 달',
			yearRange:'c-100:c+10',
			showMonthAfterYear:true, 
			dayNamesMin:['일','월','화','수','목','금','토'],
			monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		});
	}
</script>
<style>
.x-grid3-row-over {
    cursor:pointer;
}
table:not(.x-toolbar-right) {
    /* width: auto;
	table-layout: unset; */
	box-sizing: revert;
	-webkit-box-sizing: revert;
}
div:not(.panel){
	box-sizing: revert;
    -webkit-box-sizing: revert;
    vertical-align: middle;
}

div:not(.panel) input[type=text]  {
  color: #080808;
}
.popup {
  display: none; /* 처음엔 숨김 */
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: rgba(0,0,0,0.5); /* 반투명 배경 */
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.popup-content {
  background-color: white;
  padding: 20px;
  width: 50%;
  border-radius: 10px;
  position: relative;
}

.close {
  position: absolute;
  top: 10px; right: 15px;
  font-size: 24px;
  cursor: pointer;
}
.x-grid-panel .x-panel-body {
	min-height:300px;
}

#fileUpload {
    cursor: pointer;
}
</style>
</head>
<form name="regulationF">
	<input type="hidden" name="bookid">
	<input type="hidden" name="noformyn">
</form>
<tiles:insertAttribute name="content"/>
<!-- 
<div id="popupLayer" class="popup">
	<div class="popup-content">
		<span id="closePopup" class="close">&times;</span>
		<div id="panel" style="width:470px; height:400px;position:absolute;top:0;left:300px;z-index:999;display:none;">
			<div id="detptree" style="width:240px; height:400px;float:left;"></div>
			<div id="grid" style="width:230px; height:400px;float:left;"></div>
		</div>
		<div class="subpopsize">
			<h2 class="subTitle">결재</h2>
			<strong class="subST">결재</strong>
			<div class="tableW">
				<form id="gianfrm" method="post">
					<input type="hidden" id="ATRZ_SE_NM"           name="ATRZ_SE_NM"           value="" readonly/>
					<input type="hidden" id="ATRZ_TYPE_NM"         name="ATRZ_TYPE_NM"         value="" readonly/>
					<input type="hidden" id="ATRZ_DMND_PST_MNG_NO" name="ATRZ_DMND_PST_MNG_NO" value="" readonly/>
					<input type="hidden" id=ATRZ_MNG_NO            name="ATRZ_MNG_NO"          value="" readonly/>
					<input type="hidden" id="ATRZ_RJCT_RSN"        name="ATRZ_RJCT_RSN"        value="" readonly/>
					<input type="hidden" id="APRVR_NO"             name="APRVR_NO"             value="" readonly/>
					<input type="hidden" id="GSTATE"               name="GSTATE"               value="" readonly/>
					<input type="hidden" id="WRTR_EMP_NM"          name="WRTR_EMP_NM"          value="" readonly/>
					<input type="hidden" id="WRTR_EMP_NO"          name="WRTR_EMP_NO"          value="" readonly/>
					<table id="gianset" class="infoTable POP apptable" style="width:100%">
					<table id="gianset" class="infoTable write" style="width:100%">
						<colgroup>
							<col style="width:20%;">
							<col style="width:60%;">
							<col style="width:20%;">
						</colgroup>
						<tbody>
							<tr>
								<th>기안자</th>
								<td>
									<input type="text" id="startGian" name="startGian" value="" readonly/>
								</td>
								<td id="sgbn" class="last">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
			<hr class="margin20">
			<div id="sgian" style="text-align: right;display:none;">
				<input id="callBtn" type="button" onclick="javascript:setsigner();"   class="innerBtn" value="결재선불러오기"> 
				<input id="addBtn" type="button" onclick="javascript:addsigner();"    class="innerBtn" value="결재자추가">
			    <input id="saveBtn" type="button" onclick="javascript:saveApprove();" class="innerBtn" value="결재상신">
			    <input type="button" onclick="gianWclose();" class="innerBtn" value="취소">
			</div>
			<div id="gianFormBtn" style="text-align: right;display:none;">
				<input id="YBtn" type="button" onclick="javascript:YBtn();" class="innerBtn" value="승인"> 
				<input id="NBtn" type="button" onclick="javascript:NBtn();" class="innerBtn" value="반려">
			    <input id="CBtn" type="button" onclick="javascript:CBtn();" class="innerBtn" value="회수">
			</div>
			<div id="rform" style="text-align: right;display:none;">
				<textarea name="ATRZ_RJCT_RSN2" id="ATRZ_RJCT_RSN2" style="border: 2px solid #2196F3;width:100%;hight:20px;" placeholder="반려사유를 입력해주시기 바랍니다."></textarea>
				<input id="NBtn2" type="button" onclick="javascript:NBtn2();" class="innerBtn" value="저장">
				<input id="NBtn3" type="button" onclick="javascript:NBtn3();" class="innerBtn" value="취소">
			</div>
		</div>
	</div>
</div>
 -->
<!-- <script>
function setTree(){
	var tree = new Ext.tree.TreePanel({
		title:'부서정보',
		border: true,
        animate:false, 
        autoScroll:true,
        loader : new Ext.tree.TreeLoader({
   			dataUrl: CONTEXTPATH + '/web/getDeptNode.do',
			baseParams:{
			}
		}),
        enableDD:true,
        containerScroll: true,
        border: false,
        width: 240,
        height: 380, 
        rootVisible: false,
        listeners: {
			click: function(node, e){
				node.select();
				var schTxt = node.attributes.id;
				goSchUser(schTxt);
			},
			beforenodedrop: function(e){ 
				
			},
			contextmenu: function(node, e){
				
			},
			expandnode:function(node){
				
			},
			collapsenode:function(node){
				
			}
		}
        
    });
    
    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '',
        cls: "folder",
        id:'0'
    });
    tree.setRootNode(root);
    
    // render the tree
    tree.render('detptree');
    
    var path = '/0/6110000/6112650/6112656/6112662'; // 트리 노드의 경로
    tree.expandPath(path, 'id', function(success, lastNode) {
        if (success) {
            // 노드 선택 및 포커스 주기
        	tree.getSelectionModel().select(lastNode);
        	Ext.defer(function() {
                var nodeEl = tree.getNodeById(lastNode.id); // DOM element
                if (nodeEl) {
                    //Ext.fly(nodeEl).scrollIntoView(tree.body); // 스크롤 이동
                    //nodeEl.focus(); // 키보드 포커스 (필요 시)
                } else {
                    console.warn('노드 DOM 요소를 찾을 수 없습니다:', lastNode.id);
                }
            }, 200);
        } else {
            console.log('경로 확장 실패');
        }
    });	
    
    goSchUser(6112662);
}
function gianLayer(gbn,type,key) {
	$('#gianfrm')[0].reset();
	$('#ATRZ_SE_NM').val(gbn);
	$('#ATRZ_TYPE_NM').val(type);
	$('#ATRZ_DMND_PST_MNG_NO').val(key);
	$("#sgian").show();
	
	document.getElementById('popupLayer').style.display = 'flex';
	if($('#gianset tbody tr').length==1){
		addsigner();
		$("#startGian").val(susername);
	}else if($('#gianset tbody tr').length>1){
		$('#gianset tbody tr:not(:last)').remove();
	}
}
function gianStart(gbn,type,key) {
	$('#gianfrm')[0].reset();
	$('#ATRZ_SE_NM').val(gbn);
	$('#ATRZ_TYPE_NM').val(type);
	$('#ATRZ_DMND_PST_MNG_NO').val(key);
	$("#gianFormBtn").show();
	$("#YBtn").hide();
	$("#NBtn").hide();
	$("#CBtn").hide();
	
	document.getElementById('popupLayer').style.display = 'flex';
	$.ajax({
		type:'POST',
		url:'${pageContext.request.contextPath}/web/approve/setGianForm.do',
		dataType: "json",
		data : $("#gianfrm").serialize(),
		async: false,
		error: function(){
			alert("결재호출실패. 관리자에게 문의 바랍니다.");
		},
		success:function(data){
			var obj = data.data.result;
			$('#gianset tbody tr:not(:last)').remove();
			
			for(i=1; i<obj.length; i++){
				var gstate = '';
				if(obj[i].ATRZ_YN=='N'){
					gstate = '승인대기';
				}
				if(obj[i].ATRZ_YN=='Y'){
					gstate = '승인';
				}
				if(obj[i].ATRZ_YN=='R'){
					gstate = '반려';
				}
				
				$('#gianset tbody').prepend(
					'<tr>'+
					'<th>결재권자</th>'+
					'<td>'+
					'<input type="text" name="signer"   value="'+obj[i].APRVR_NM+'" style="margin-right:5px;" readonly/>'+
					'<input type="text" name="signerid" value="'+obj[i].APRVR_NO+'" readonly/>'+
					'</td>'+
					'<td class="last">'+gstate+'</td>'+
					'</tr>'
				);
			}	
			$("#startGian").val(obj[0].APRVR_NM);
			$("#sgbn").text("상신완료");
			$("#ATRZ_MNG_NO").val(obj[0].ATRZ_MNG_NO);
			console.log(obj[0].CAPRVR_NO);
			console.log(suserid);
			if(obj[0].CAPRVR_NO == suserid){
				$("#YBtn").show();
				$("#NBtn").show();
			}
			
			if(obj[0].ATRZ_DMND_EMP_NO == suserid){
				$("#CBtn").show();
			}
		}
	});
}
function addsigner(){
	$('#gianset tbody').prepend(
		'<tr>'+
		'<th>결재권자</th>'+
		'<td>'+
		'<input type="text"   name="signer"   style="margin-right:5px;" value="" readonly/>'+
		'<input type="hidden" name="signerid" value="" readonly/>'+
		'<input type="hidden" name="gdeptid"  value="" readonly/>'+
		'<input type="text"   name="gdept"    value="" readonly/>'+
		'</td>'+
		'<td class="last">'+
		'<input type="button" onclick="showSelectUser(this);" class="innerBtn" value="선택">'+
		'<input type="button" onclick="deleteSigner(this)" class="innerBtn" value="삭제"></td>'+
		'</tr>'
	);
}
function setsigner(){
	$.ajax({
		type:'POST',
		url:'${pageContext.request.contextPath}/web/approve/approveLineSend.do',
		dataType: "json",
		data : $("#gianfrm").serialize(),
		async: false,
		error: function(){
			alert("결재실패. 관리자에게 문의 바랍니다.");
		},
		success:function(data){
			var obj = data.data.result;
			if(obj.length==0){
				alert("최근에 사용한 결재 정보가 없습니다.");
			}else{
				$('#gianset tbody tr:not(:last)').remove();
				for(i=1; i<obj.length; i++){
					$('#gianset tbody').prepend(
						'<tr>'+
						'<th>결재권자</th>'+
						'<td>'+
						'<input type="text"   name="signer"   value="'+obj[i].APRVR_NM+'" style="margin-right:5px;" readonly/>'+
						'<input type="hidden" name="signerid" value="'+obj[i].APRVR_NO+'" readonly/>'+
						'<input type="hidden" name="gdeptid"  value="'+obj[i].DEPT_NO+'" readonly/>'+
						'<input type="text"   name="gdept"    value="'+obj[i].DEPT_NM+'" readonly/>'+
						'</td>'+
						'<td class="last">'+
						'<input type="button" onclick="showSelectUser(this);" class="innerBtn" value="선택">'+
						'<input type="button" onclick="deleteSigner(this)" class="innerBtn" value="삭제">'+
						'</td>'+
						'</tr>'
					);
				}
			}
		}
	});
}
document.getElementById('closePopup').addEventListener('click', function () {
	document.getElementById('popupLayer').style.display = 'none';
	$("#detptree").empty();
	$('#gianset tbody tr:not(:last)').remove();
	$("#sgian").hide();
});
function gianWclose(){
	$("#closePopup").trigger("click");
}
var selObj;
function showSelectUser(obj){
	selObj = obj;
	$("#panel").show();
	setTree();
}
function deleteSigner(obj){
	$(obj).closest('tr').remove();
}	
function saveApprove(){
	if($("input[name='signer']").val()==''){
		alert("결재권자를 지정하셔야 합니다.");
	}else{
		$.ajax({
			type:'POST',
			url:'${pageContext.request.contextPath}/web/approve/approveSave.do',
			dataType: "json",
			data : $("#gianfrm").serialize(),
			async: false,
			error: function(){
				alert("결재실패. 관리자에게 문의 바랍니다.");
			},
			success:function(data){
				console.log(data);
				location.reload();
			}
		});		
	}
}
function NBtn(){
	$("#rform").show();
	$("#YBtn").hide();
	$("#NBtn").hide();
}
function NBtn2(){
	if($("#ATRZ_RJCT_RSN2").val()==""){
		alert("반려사유를 입력하셔야 합니다.");
	}else{
		$("#GSTATE").val("N");
		$("#APRVR_NO").val(suserid);
		$("#ATRZ_RJCT_RSN").val($("#ATRZ_RJCT_RSN2").val());
		changeSave();	
	}
	
}
function NBtn3(){
	$("#rform").hide();
	$("#YBtn").show();
	$("#NBtn").show();	
}
function CBtn(){
	$("#GSTATE").val("R");
	changeSave();
}
function YBtn(){
	$("#GSTATE").val("Y");
	changeSave();
}
function changeSave(){
	$.ajax({
		type:'POST',
		url:'${pageContext.request.contextPath}/web/approve/chgState.do',
		dataType: "json",
		data : $("#gianfrm").serialize(),
		async: false,
		error: function(){
			alert("결재실패. 관리자에게 문의 바랍니다.");
		},
		success:function(data){
			location.reload();
		}
	});
}

var gianToggle = 0;
function showGianList(gbn,type,key,viewid) {
	$('#ATRZ_SE_NM').val(gbn);
	$('#ATRZ_TYPE_NM').val(type);
	$('#ATRZ_DMND_PST_MNG_NO').val(key);
	
	if (gianToggle != 0) {
		$("#"+viewid+" *").remove();
		$("#gianView").text("결재내역  ▼");
		gianToggle = 0;
	} else {
		gianToggle = 1;
		$("#gianView").text("결재내역  ▲");
		
		$.ajax({
			type:'POST',
			url:'${pageContext.request.contextPath}/web/approve/showGianList.do',
			dataType: "json",
			data : $("#gianfrm").serialize(),
			async: false,
			error: function(){
				alert("결재내역조회실패. 관리자에게 문의 바랍니다.");
			},
			success:function(data){
				var mdata = data.data.result1;
				var sdata = data.data.result2;
				var obj = "";
				obj = obj + '<div class="tableW">';
				
				for(i=0; i<mdata.length; i++){
					obj = obj + '<table class="infoTable write" style="margin-top:10px;">';
					obj = obj + '<colgroup>'
					obj = obj + '<col style="width:8%">'
					obj = obj + '<col style="width:*">'
					obj = obj + '<col style="width:8%">'
					obj = obj + '<col style="width:*">'
					obj = obj + '<col style="width:8%">'
					obj = obj + '<col style="width:*">'
					obj = obj + '<col style="width:8%">'
					obj = obj + '<col style="width:*">'
					obj = obj + '</colgroup>'
					obj = obj + '<tr>';
					obj = obj + '<th>결재요청인</th>';
					obj = obj + '<td>';
					obj = obj + mdata[i].ATRZ_DMND_EMP_NM + ' ('+mdata[i].ATRZ_DMND_DEPT_NM+')';
					obj = obj + '</td>';
					obj = obj + '<th>결재상태</th>';
					obj = obj + '<td>';
					obj = obj + mdata[i].ATRZ_STTS_NM;
					obj = obj + '</td>';
					obj = obj + '<th>결재요청일</th>';
					obj = obj + '<td>';
					obj = obj + mdata[i].ATRZ_DMND_DT;
					obj = obj + '</td>';
					obj = obj + '<th>최종결재일</th>';
					obj = obj + '<td>';
					obj = obj + mdata[i].ATRZ_CMPTN_DT;
					obj = obj + '</td>';
					if(mdata[i].ATRZ_STTS_NM=='반려'){
						obj = obj + '<th>반려사유</th>';
						obj = obj + '<td>';
						obj = obj + mdata[i].ATRZ_RJCT_RSN;
						obj = obj + '</td>';
					}
					obj = obj + '</tr>';
					obj = obj + '</table>';
					//obj = obj + '<div>*결재내역</div>';
					obj = obj + '<strong class="subST" style="margin:15px 0 15px 0;">결재내역</strong>';
					obj = obj + '<table class="infoTable write">';
					obj = obj + '<colgroup>'
					obj = obj + '<col style="width:5%">'
					obj = obj + '<col style="width:*">'
					obj = obj + '<col style="width:15%">'
					obj = obj + '<col style="width:25%">'
					obj = obj + '</colgroup>'
					obj = obj + '<tr>';
					obj = obj + '<th></th>';
					obj = obj + '<th>결재자</th>';
					obj = obj + '<th>결재상태</th>';
					obj = obj + '<th>결재일</th>';
					obj = obj + '</tr>';
					var h = 1;
					for(k=0; k<sdata.length; k++){
						if(mdata[i].ATRZ_MNG_NO==sdata[k].ATRZ_MNG_NO){
							obj = obj + '<tr>';
							obj = obj + '<td>';
							obj = obj + h;
							obj = obj + '</td>';
							obj = obj + '<td>';
							obj = obj + sdata[k].APRVR_NM + ' ('+sdata[k].APRVR_DEPT_NM+')';
							obj = obj + '</td>';
							obj = obj + '<td>';
							obj = obj + (sdata[k].ATRZ_YN=="Y"?sdata[k].ATRZ_SEQ==0?"상신":"승인":sdata[k].ATRZ_YN=="N"?"결재대기":sdata[k].ATRZ_YN=="R"?"회수":"반려");
							obj = obj + '</td>';
							obj = obj + '<td>';
							if(sdata[k].ATRZ_DT){
								obj = obj + sdata[k].ATRZ_DT;	
							}
							obj = obj + '</td>';
							obj = obj + '</tr>';
							h++;	
						}
					}
					obj = obj + '</table>';
				}
				obj = obj + '</div>';
				$("#"+viewid).append(obj);
			}
		});
	}
}
</script> -->
