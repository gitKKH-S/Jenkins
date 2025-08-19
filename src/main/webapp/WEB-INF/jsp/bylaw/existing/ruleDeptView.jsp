<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String obookId = request.getParameter("OBOOKID")==null?"":request.getParameter("OBOOKID");
%>	 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type=text/css>
/* style rows on mouseover */
.x-grid3-row-over .x-grid3-cell-inner {
	font-weight: bold;
}
*{
	font-family: "돋움", "굴림";
}
.adviceMsg {
	font-size:12px;
	font-weight:bold;
	color:#666;
	text-align:center;
}
</style>
<script type="text/javascript" language="javascript">
	//권한 검사를 위한 param
	var obookId = "<%=obookId%>";
</script>
<script>
Ext.QuickTips.init();

Ext.onReady(function(){
	//DATA Holder
	var grid1dan;			//1단 선택
	var sm1dan;
    var ds1dan; 			//데이터소스

	var xg = Ext.grid;		//shortCut
	
	//dataStore
	ds1dan = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/adm/ruleDeptData.do'
		}),
		reader: new Ext.data.JsonReader({root: 'result'}, ['OBOOKID', 'DEPTCD','DEPTNM']),
		listeners:{
			
			load : function (sm, rowIndex, data){
				var recs = [];
				for (var i=0; i<rowIndex.length; i++){
					if(rowIndex[i].get('OBOOKID')!=''){
						recs.push(i);
					}
					sm1dan.selectRows(recs);
				}
			}			
		}
	});
	//selectionModel for 1dan
	//selModel.getSelected ->선택된 1개
	//selModel.getSelections -> 선택된 레코드들
	//선택된 레코드값 가져오기 : recordObj.get('fieldName');
	//그리드 셀렉트 모델
	var sm1dan = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false
	});
	
	//부서 그리드
	grid1dan = new xg.GridPanel({
		renderTo:'grid1res',		
		store:ds1dan,
		cm:new xg.ColumnModel({
			columns:[
				sm1dan,
				{header:"부서명", width:180,dataIndex:'DEPTNM'}
			]
		}),
		sm:sm1dan,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
		width:300,height:470,
        iconCls: 'icon-grid',
		bbar:[
				'->',
				new Ext.Button ({
					id:'butSave', text:'<b>저장</b>',
					iconCls:'icon_save',
					listeners:{
						click:function(btn, eObj){
							
			                var sel = sm1dan.getSelections();
			                var deptCds = '';
			                
			                for (var i=0;i<sel.length; i++ ){
			                	deptCds += '@@'+sel[i].get('DEPTCD');
			                }
			                deptCds = deptCds.replace('@@','');
							//var id = sel.data.wewonInfoId;
							Ext.Ajax.request({
								url: CONTEXTPATH + '/bylaw/adm/ruleDeptInsert.do',
								params: {
									OBOOKID : obookId,
									DEPTCDS :deptCds 
								},
								success: function(res, opts){
									Ext.MessageBox.alert('성공','데이터가 저장되었습니다.');
									ds1dan.load({
										params:{
											OBOOKID : obookId
										}
									});
								},
								failure: function(res, opts){
									Ext.MessageBox.alert('실패','서버와의 연결상태가 좋지 않습니다.');
								}
							});

						}
					}
				})
					
			]
	});
	
	ds1dan.load({
		params:{
			OBOOKID : obookId
		}
	});
});


</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="300px" height="350px" valign="top" bgcolor="#efefef">
			<div id="grid1sch"></div>
			<div id="grid1res"></div>
		</td>
	</tr>
</table>
<div id="buttonHolder"></div>
</body>
</html>