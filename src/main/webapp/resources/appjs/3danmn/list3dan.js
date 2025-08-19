Ext.QuickTips.init();

Ext.onReady(function(){
	//data store
	var dsList;
	//select model
	var smList;
	//search panel
	var schList;
	//column model
	var cmList;
	//data grid
	var gridList;
	//선택된 데이터
	var dataList;
	//하단 버튼
	var buttonHolder;

	//shortCut
	var xg = Ext.grid;

	var pageSize = 10;		//한번에 표시할 검색결과 숫자

//	var msgList= new Ext.Panel({
//		renderTo:'3danList',
//		frame:true,	width:900, height:290,
//		items:[
//			{html:'<br/><br/><br/><br/><p class="adviceMsg">상단 검색버튼을 클릭하시면 3단보기가 설정된 규정의 리스트를 볼 수 있습니다.</p>'}
//		]
//	});

	var deleteButt = new Ext.Button({
		id:'but_del',
		text:'선택삭제', iconCls:'icon_del',disabled:true,
		handler:function(){
			var job='del3danSet';
			var selected='';
			for(var i=0;i<dataList.length;i++){
				selected+=dataList[i].get('fstOBookId')+'/';
			}

			Ext.Ajax.request({
				url: CONTEXTPATH + '/bylaw/dan/Column_proc.do',
				params: {
					job:job,
					selected: selected
				},
				success: function(res, opts){
					Ext.MessageBox.alert('알림','데이터가 삭제되었습니다..');
					dsList.load({
						params:{
							start:0, limit:pageSize
						}
					});
				},
				failure: function(res, opts){
					Ext.MessageBox.alert('데이터입력 실패','서버와의 연결상태가 좋지 않습니다.');
				}
			});
		}
	});
	buttonHolder = new Ext.Toolbar({
		renderTo:'buttonHolder',
		autoHeight:true,width:1200,
		items:[
			{xtype: 'tbfill'},
			deleteButt,
			{xtype: 'tbspacer'}
		]
	});
//////////////////////////////////////////
//	데이터소스, 셀렉트모델
//////////////////////////////////////////
	dsList = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH + '/bylaw/dan/Column_proc.do'
		}),
		reader:new Ext.data.JsonReader({
			root:'result',totalProperty:'total', idProperty:'id'
		},['id', 'fstOBookId','dan1','dan2','dan3','dan4'])
	});

	smList = new Ext.grid.CheckboxSelectionModel({
		checkOnly:false,singleSelect:true,
		listeners:{
			beforerowselect:function(sm, rowIndex, keepExisting, data){

			},
			rowselect:function(sm, rowIndex, data){
				dataList = sm.getSelections();
				deleteButt.setDisabled(false);
				var oBookId = data.get('fstOBookId');
				if(data.get('dan4')){
					goDan(oBookId,'4');
				}else if(data.get('dan3')){
					goDan(oBookId,'3');
				}else{
					goDan(oBookId,'2');
				}
			},
			rowdeselect:function(sm, rowIndex, data){
				dataList = sm.getSelections();
				if(dataList.length == 0){
					dataList='';
					deleteButt.setDisabled(true);
				}
			}
		}
	});

//////////////////////////////////////////
//	서치폼 설정
//////////////////////////////////////////
	schList = new Ext.Panel({
		renderTo:'3danSch', width:1200, frame:true,
		title:'키워드로 검색', layout:'column', anchor:'0',
		items:[{
			columnWidth:.8,
			baseCls:'x-plain',
			items:[{xtype:'textfield', fieldLabel:'검색', id:'queryText', name:'queryText', width:'100%', allowBlank:true}]
		},{
			columnWidth:.2,
			baseCls:'x-plain',
			items:[{xtype:'button', text:'검 색', width:'100%',
				handler:function(){
					dsList.on('beforeload', function(){
						dsList.baseParams = {
							query:Ext.get('queryText').getValue(),
							job:'listSch'
						}
					});
					dsList.load({
						params:{
							start:0, limit:pageSize
						}
					})
				}
			}]
		}]
	});

//////////////////////////////////////////
//	그리드 설정
//////////////////////////////////////////
	cmList = new xg.ColumnModel({
		columns:[
			smList,
			new Ext.grid.RowNumberer({
				header:'No',width:40
			}),
			{header:'1단 규정',dataIndex:'dan1'},
			{header:'2단 규정',dataIndex:'dan2'},
			{header:'3단 규정',dataIndex:'dan3'},
			{header:'4단 규정',dataIndex:'dan4'}
		]
	});
	gridList = new xg.GridPanel({
		renderTo:'3danList',
		store:dsList,
		sm:smList,
		cm:cmList,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true, iconCls:'icon-grid',
		viewConfig:{
			forceFit:true
		},width:1200,height:290,title:'3단보기가 설정된 규정 리스트',
		bbar:new Ext.PagingToolbar({
			pageSize:pageSize, store:dsList,
			displayInfo:true, displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
		listeners:{
			render:function(cmp){
				dsList.on('beforeload', function(){
					dsList.baseParams = {
						query:Ext.get('queryText').getValue(),
						job:'listSch'
					}
				});
				dsList.load({
					params:{
						start:0, limit:pageSize
					}
				});
			}
		},
		iconCls : 'icon_reguSch'
	});

});
function goDan(oBookId,dan){
	var url=CONTEXTPATH+'/web/regulation/'+dan+'_popup.do';
	var property="width=1350,height=630,scrollbars=no,resizable=yes,status=no,toolbar=no";
	window.open(url+"?obookid="+oBookId,oBookId,property);
}
