<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/appjs/3danmn/icon.css" />
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
<script>
Ext.QuickTips.init();

Ext.onReady(function(){
	//DATA Holder
	var quickCatId;
	var gbn;

	var buttonHolder;		//하단 버튼
	var grid1dan;			//1단 선택
	var sch1dan;			//1단 서치폼
	var sm1dan;
    var ds1dan; 			//데이터소스

	var xg = Ext.grid;		//shortCut
//////////////////////////////////////////
//	전체 패널 및 버튼
//////////////////////////////////////////
	var gridStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/jsp/bylaw/quickCatMng/proc/proc.jsp?job=selectBoxQuickCat'
		}),
		reader:new Ext.data.JsonReader({root:'result'},['codeid','code']),
		autoLoad:true
	});
	
	var catCombo = new Ext.form.ComboBox({
    	width:	180
        ,name:'catCombo'
        ,id:'catCombo'
        ,emptyText:'카테고리 선택'
        ,store:gridStore
       ,mode:'local'  ,editable:false ,forceSelection:true ,valueField:'codeid'
       ,displayField:'code' ,triggerAction:'all' ,selectOnFocus:true //,value:gbn
       ,listeners:{
				select:function(cb, data, idx){
					gbn = data.get('codeid');
					ds1dan.load({
						params:{
							gbn:data.get('codeid'),
							job:'selectQuickCatList'
						}
					});
				}
		}
	});
	var saveButt = new Ext.Button({
		id:'but_save',
		text:' 삭 제 ',iconCls:'icon_save',disabled:true,width:100,
		handler:function(){
			Ext.MessageBox.wait('데이터를 삭제중입니다...','Wait',{interval:100, text:'서버에서 데이터 삭제중 ...'});
			Ext.Ajax.request({
				url: CONTEXTPATH + '/jsp/bylaw/quickCatMng/proc/proc.jsp',
				params: {
					job:'deleteQuickCat',
					quickCatId:quickCatId 
				},
				success: function(res, opts){
					Ext.MessageBox.alert('성공','데이터가 삭제 되었습니다.');
					ds1dan.load({
						params:{
							gbn:gbn,
							job:'selectQuickCatList'
						}
					});
				},
				failure: function(res, opts){
					Ext.MessageBox.alert('실패','서버와의 연결상태가 좋지 않습니다.');
				}
			});
		}
	});
	buttonHolder = new Ext.Toolbar({
		renderTo:'buttonHolder',
		autoHeight:true,width:300,

		items:[
			{xtype: 'tbfill'},
			catCombo,
			saveButt,
			{xtype: 'tbspacer'}
		]
	});
//////////////////////////////////////////
//	공통모듈 설정 - 데이터소스, 셀렉트모델
//////////////////////////////////////////
	//dataStore
	ds1dan = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/jsp/bylaw/quickCatMng/proc/proc.jsp'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'quickCatId'
		}, ['quickCatId', 'title','bookCd'])
	});

	//selectionModel for 1dan
	//selModel.getSelected ->선택된 1개
	//selModel.getSelections -> 선택된 레코드들
	//선택된 레코드값 가져오기 : recordObj.get('fieldName');
	var sm1dan = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true,
		listeners:{
			rowselect:function( sm, rowIndex, data ){
				quickCatId = sm.getSelected().data.quickCatId;
				saveButt.setDisabled(false);
				
			},
			rowdeselect:function( sm, rowIndex, data ){
				saveButt.setDisabled(true);
			}
		}
	});

//////////////////////////////////////////
//	그리드 설정
//////////////////////////////////////////
	//규정 그리드
	grid1dan = new xg.GridPanel({
		renderTo:'grid1res',
		store:ds1dan,
		cm:new xg.ColumnModel({
			columns:[
				sm1dan,
//				new Ext.grid.RowNumberer(),		//줄번호 먹이기
				{header:"규정명", width:140,dataIndex:'title'},
				{header:"종류", width:55, dataIndex:'bookCd'}
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
		width:300,height:399,
        iconCls: 'icon-grid'
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