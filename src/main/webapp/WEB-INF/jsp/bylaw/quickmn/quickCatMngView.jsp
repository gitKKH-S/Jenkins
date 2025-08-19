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
	var obookId;
	var catGbn;

	var buttonHolder;		//하단 버튼
	var grid1dan;			//1단 선택
	var sch1dan;			//1단 서치폼
	var sm1dan;
    var ds1dan; 			//데이터소스

	var xg = Ext.grid;		//shortCut
//////////////////////////////////////////
//	1,2,3차 검색 메시지 설정 & button설정
//////////////////////////////////////////
	var msg1dan= new Ext.Panel({
		renderTo:'grid1res',
		frame:true,	width:300, height:363,
		items:[
			{html:'<br/><br/><br/><br/><p class="adviceMsg">규정을 검색해서<br/><br/> 해당규정과 카테고리를 선택후<br/><br/> 저장해주세요.</p>'}
		]
	});
	
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
					catGbn = data.get('codeid');
					if (obookId){
						saveButt.setDisabled(false);
					}
				}
		}
	});	

	var saveButt = new Ext.Button({
		id:'but_save',
		text:' 저 장 ',iconCls:'icon_save',disabled:true,width:100,
		handler:function(){

			Ext.MessageBox.wait('데이터를 저장중입니다...','Wait',{interval:100, text:'서버로 데이터 전송중 ...'});
			Ext.Ajax.request({
				url: CONTEXTPATH + '/jsp/bylaw/quickCatMng/proc/proc.jsp',
				params: {
					job: 		'insertQuickCat',
					obookId: 	obookId, 
					gbn:		catGbn
				},
				success: function(res, opts){
					Ext.MessageBox.alert('데이터입력 성공','데이터가 입력 되었습니다.');
				},
				failure: function(res, opts){
					Ext.MessageBox.alert('데이터입력 실패','서버와의 연결상태가 좋지 않습니다.');
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
//	서치폼 설정
//////////////////////////////////////////
	//규정검색창 패널
	sch1dan = new Ext.Panel({
		renderTo:'grid1sch', width:300, frame:true,
		layout:'column',anchor:'0',
		items:[{
					columnWidth:.7,
					baseCls:'x-plain',
					items:[
					       {
					    	   xtype:'textfield',fieldLabel:'검색', id:'query_1dan',name:'query_1dan',width:'200px', allowBlank:true,
								enableKeyEvents:true,
								listeners:{
											keydown:function(el, e){
												if(e.getKey() == 13){
													msg1dan.hide();
													grid1dan.render('grid1res');
													ds1dan.load({
														params:{
															schTxt:Ext.get('query_1dan').getValue(),
															job:'selectLawList'
														}
													});
												}
			
											}
								}
							}
					       ]
				},{
					columnWidth:.3,
					baseCls:'x-plain',
					items:[{xtype:'button',text:'검색',width:'90%',
						handler:function(){
									msg1dan.hide();
									grid1dan.render('grid1res');
									ds1dan.load({
										params:{
											schTxt:Ext.get('query_1dan').getValue(),
											job:'selectLawList'
										}
									});
						}
					}]
				}
			]
	});
//////////////////////////////////////////
//	그리드 설정
//////////////////////////////////////////
	//dataStore
	ds1dan = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/jsp/bylaw/quickCatMng/proc/proc.jsp'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'oBookId'
		}, ['obookId', 'title','bookCd'])
	});
	//selectionModel for 1dan
	//selModel.getSelected ->선택된 1개
	//selModel.getSelections -> 선택된 레코드들
	//선택된 레코드값 가져오기 : recordObj.get('fieldName');
	//그리드 셀렉트 모델
	var sm1dan = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true,
		listeners:{		
			rowselect: function(sm, rowIndex, data){
				obookId = sm.getSelected().data.obookId;
				if(catGbn){
					saveButt.setDisabled(false);
				}
			},
			rowdeselect: function(sm, rowIndex, data){
				obookId = '';
				saveButt.setDisabled(true);
			}
		}
	});
	
	//규정검색 그리드
	grid1dan = new xg.GridPanel({
		store:ds1dan,
		cm:new xg.ColumnModel({
			columns:[
				sm1dan,
				{header:"규정명", width:240,dataIndex:'title'},
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
		width:300,height:363,
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