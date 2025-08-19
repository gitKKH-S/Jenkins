Ext.QuickTips.init();

Ext.onReady(function(){
	//DATA Holder
	var data1dan;
	var data2dan;
	var data3dan;
	var data4dan;

	var buttonHolder;		//하단 버튼
	var grid1dan;			//1단 선택
	var sch1dan;			//1단 서치폼
	var sm1dan;
	var grid2dan;			//2단 선택
	var sch2dan;			//2단 서치폼
	var sm2dan;
	var grid3dan;			//3단 선택
	var sch3dan;			//3단 서치폼
	var sm3dan;
	var grid4dan;			//3단 선택
	var sch4dan;			//3단 서치폼
	var sm4dan;
    var ds1dan; 			//데이터소스
    var ds2dan;
	var ds3dan;
	var ds4dan;
	var pageSize = 10; 		//한번에 표시할 검색결과 숫자

	var xg = Ext.grid;		//shortCut
//////////////////////////////////////////
//	1,2,3차 검색 메시지 설정 & button설정
//////////////////////////////////////////
	var msg1dan= new Ext.Panel({
		renderTo:'grid1res',
		frame:true,	width:300, height:290,
		items:[
			{html:'<br/><br/><br/><br/><p class="adviceMsg">4단검색을 적용하실 규정를 검색해서 선택해주세요.</p>'}
		]
	});
	var msg2dan= new Ext.Panel({
		frame:true,	width:300, height:290,
		items:[
			{html:'<br/><br/><br/><br/><p class="adviceMsg">4단보기의 2단이 될 규정를 검색</p>'}
		]
	});
	var msg3dan= new Ext.Panel({
		frame:true,	width:300, height:290,
		items:[
			{html:'<br/><br/><br/><br/><p class="adviceMsg">4단보기의 3단이 될 규정를 검색</p>'}
		]
	});
	
	var msg4dan= new Ext.Panel({
		frame:true,	width:300, height:290,
		items:[
			{html:'<br/><br/><br/><br/><p class="adviceMsg">4단보기의 4단이 될 규정를 검색</p>'}
		]
	});

	var saveButt = new Ext.Button({
		id:'but_save',
		text:' 저 장 ',iconCls:'icon_save',disabled:true,width:100,
		handler:function(){
			var job='';
			if(!data1dan){
				Ext.MessageBox.alert('알림','1단이 되는 데이터를 선택해주세요.');
				return false;
			}else if(!data2dan){
				Ext.MessageBox.alert('알림','2단이 되는 데이터를 선택해주세요.');
				return false;
			}

			if(data1dan && data2dan && data3dan && data4dan){
				var dan1 = data1dan.get("bookId")+','+data1dan.get("oBookId");
				var dan2 ='';
				for (var i=0; i<data2dan.length;i++){
					var tmpOrd = data2dan[i].get("ord");
					if(tmpOrd==''){
						Ext.MessageBox.alert('알림','정렬순서를 선택해주세요.');
						return false;
					}
				    dan2+=data2dan[i].get("oBookId")+','+data2dan[i].get("ord")+'/';
				}
				var dan3 ='';
				for (var i=0; i<data3dan.length;i++){
					var tmpOrd = data3dan[i].get("ord");
					if(tmpOrd==''){
						Ext.MessageBox.alert('알림','정렬순서를 선택해주세요.');
						return false;
					}
				    dan3+=data3dan[i].get("oBookId")+','+data3dan[i].get("ord")+'/';
				}
				var dan4 ='';
				for (var i=0; i<data4dan.length;i++){
					var tmpOrd = data4dan[i].get("ord");
					if(tmpOrd==''){
						Ext.MessageBox.alert('알림','정렬순서를 선택해주세요.');
						return false;
					}
				    dan4+=data4dan[i].get("oBookId")+','+data4dan[i].get("ord")+'/';
				}
				job = 'insertData';
			}else if(data1dan && data2dan && data3dan && !data4dan){
				var dan1 = data1dan.get("bookId")+','+data1dan.get("oBookId");
				var dan2 ='';
				for (var i=0; i<data2dan.length;i++){
					var tmpOrd = data2dan[i].get("ord");
					if(tmpOrd==''){
						Ext.MessageBox.alert('알림','정렬순서를 선택해주세요.');
						return false;
					}
				    dan2+=data2dan[i].get("oBookId")+','+data2dan[i].get("ord")+'/';
				}
				var dan3 ='';
				for (var i=0; i<data3dan.length;i++){
					var tmpOrd = data3dan[i].get("ord");
					if(tmpOrd==''){
						Ext.MessageBox.alert('알림','정렬순서를 선택해주세요.');
						return false;
					}
				    dan3+=data3dan[i].get("oBookId")+','+data3dan[i].get("ord")+'/';
				}
				job = 'insertData3';
			}else if(data1dan && data2dan && !data3dan && !data4dan){
				var dan1 = data1dan.get("bookId")+','+data1dan.get("oBookId");
				var dan2 ='';
				for (var i=0; i<data2dan.length;i++){
					var tmpOrd = data2dan[i].get("ord");
					if(tmpOrd==''){
						Ext.MessageBox.alert('알림','정렬순서를 선택해주세요.');
						return false;
					}
				    dan2+=data2dan[i].get("oBookId")+','+data2dan[i].get("ord")+'/';
				}
				job = 'insertData2';
			};
			Ext.MessageBox.wait('데이터를 저장중입니다...','Wait',{interval:100, text:'서버로 데이터 전송중 ...'});
			Ext.Ajax.request({
				url: CONTEXTPATH + '/bylaw/dan/Column_proc.do',
				params: {
					job:job,
					dan1:dan1, dan2:dan2, dan3:dan3, dan4:dan4
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
		autoHeight:true,width:1200,

		items:[
			{xtype: 'tbfill'},
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
			url: CONTEXTPATH + '/bylaw/dan/Column_proc.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'id'
		}, ['id', 'bookId', 'oBookId', 'title','is3dan'])
	});
	ds2dan = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/dan/Column_proc.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result',
			idProperty:'bookId'
		}, ['bookId', 'oBookId', 'title','ord'])
	});
	ds3dan = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/dan/Column_proc.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result',
			idProperty:'bookId'
		}, ['bookId', 'oBookId', 'title','ord'])
	});
	
	ds4dan = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/dan/Column_proc.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result',
			idProperty:'bookId'
		}, ['bookId', 'oBookId', 'title','ord'])
	});
	
	var dsOrd = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/dan/Column_proc.do'
		}),
		reader: new Ext.data.JsonReader({
		root:'result'},['ord'])
	});
	var ordCombo1 = new Ext.form.ComboBox({
		typeAhead: false, triggerAction: 'all', lazyRender:true,
		store: dsOrd, valueField: 'ord', displayField: 'ord',
		listeners: {
			beforerender: function(){
				var ordNum = ds2dan.getCount();
				dsOrd.on('beforeload', function(){
					dsOrd.baseParams = {
						job: 'getOrd',
						ordNum: ordNum
					}
				});
			}
		}
	});
	var dsOrd1 = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/dan/Column_proc.do'
		}),
		reader: new Ext.data.JsonReader({
		root:'result'},['ord'])
	});
	var ordCombo2 = new Ext.form.ComboBox({
		typeAhead: false, triggerAction: 'all', lazyRender:true,
		store: dsOrd1, valueField: 'ord', displayField: 'ord',
		listeners: {
			beforerender: function(){
				var ordNum = ds3dan.getCount();
				dsOrd1.on('beforeload', function(){
					dsOrd1.baseParams = {
						job: 'getOrd',
						ordNum: ordNum
					}
				});
			}
		}
	});
	var dsOrd2 = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/dan/Column_proc.do'
		}),
		reader: new Ext.data.JsonReader({
		root:'result'},['ord'])
	});
	var ordCombo3 = new Ext.form.ComboBox({
		typeAhead: false, triggerAction: 'all', lazyRender:true,
		store: dsOrd2, valueField: 'ord', displayField: 'ord',
		listeners: {
			beforerender: function(){
				var ordNum = ds4dan.getCount();
				dsOrd2.on('beforeload', function(){
					dsOrd2.baseParams = {
						job: 'getOrd',
						ordNum: ordNum
					}
				});
			}
		}
	});
	Ext.util.Format.comboRenderer = function(combo){
	    return function(value){
	        var record = combo.findRecord(combo.valueField, value);
	        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
	    }
	}
	//selectionModel for 1dan
	//selModel.getSelected ->선택된 1개
	//selModel.getSelections -> 선택된 레코드들
	//선택된 레코드값 가져오기 : recordObj.get('fieldName');
	var sm1dan = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true,
		listeners:{
			beforerowselect:function(sm, rowIndex, keepExisting, data){
				data1dan = data;

				var is3dan = data1dan.get('is3dan');
				if(is3dan=='Y'){
					Ext.MessageBox.alert('4단보기','기존 4단보기 데이터가 있습니다. <br>새로 작성하시려면 기존 데이터를 삭제해주세요.');

					return false;

					//TODO : 기본 3단 보기가 있을경우 update처리
					//확인을 누르면 업데이트 화면으로 이동??


				}
			},
			rowselect:function( sm, rowIndex, data ){

				sch2dan.render('grid2sch');
				msg2dan.render('grid2res');
				var query = Ext.getCmp('query_1dan').getValue();
				if(query)
					Ext.getCmp('query_2dan').setValue(query);

			},
			rowdeselect:function( sm, rowIndex, data ){
				data1dan = '';
			}
		}
	});
	//selectionModel for 2dan
	var sm2dan = new Ext.grid.CheckboxSelectionModel({
		checkOnly:true,
		listeners: {
			beforerowselect:function(sm, rowIndex, keepExisting, data){
				var dan1Data =  sm1dan.getSelected();
				var dan2DataObook = data.get('oBookId');
				if(dan1Data){
					if(dan2DataObook==dan1Data.get('oBookId')){
						Ext.MessageBox.alert('선택에러','1단에서 선택한 규정은 선택하실 수 없습니다.');
						return false;
					}
				}else{
					Ext.MessageBox.alert('선택에러','1단이 되는 규정을 먼저 선택해주세요.');
					return false;
				}
			},
			rowselect: function(sm, rowIndex, data){
				data2dan = sm.getSelections();
				sch3dan.render('grid3sch');
				msg3dan.render('grid3res');
				var query = Ext.getCmp('query_2dan').getValue();
				if (query)
					Ext.getCmp('query_3dan').setValue(query);
				saveButt.setDisabled(false);
			},
			rowdeselect: function(sm, rowIndex, data){
				if (data2dan.length == 0) {
					data2dan = '';
				}
			}
		}
	});
	//selectionModel for 3dan
	var sm3dan = new Ext.grid.CheckboxSelectionModel({
		checkOnly:true,
		listeners:{
			beforerowselect:function(sm, rowIndex, keepExisting, data){
				var selectedObookId = new Array();
				
				var dan1Data =  sm1dan.getSelected();
				var dan2Data = sm2dan.getSelections();
				
				selectedObookId.push(dan1Data.get('oBookId'));
				for(var i=0 ; i<dan2Data.length;i++){
					selectedObookId.push(dan2Data[i].get('oBookId'));
				}
				var dan3DataObook = data.get('oBookId');
				if(dan1Data){
					if(dan2Data){
						for(var i = 0; i<selectedObookId.length;i++){
							if(dan3DataObook == selectedObookId[i]){
								Ext.MessageBox.alert('선택에러','이전에 선택한 규정은 중복 선택하실수 없습니다.');
								return false;
							}
						}
						
					}else{
						Ext.MessageBox.alert('선택에러','2단이 되는 규정을 먼저 선택해주세요.');
						return false;
					}
				}else{
					Ext.MessageBox.alert('선택에러','1단이 되는 규정을 먼저 선택해주세요.');
					return false;
				}
			},
			rowselect: function(sm, rowIndex, data){
				data3dan = sm.getSelections();
				sch4dan.render('grid4sch');
				msg4dan.render('grid4res');
				var query = Ext.getCmp('query_3dan').getValue();
				if (query)
					Ext.getCmp('query_4dan').setValue(query);
				saveButt.setDisabled(false);
			},
			rowdeselect: function(sm, rowIndex, data){
				if (data3dan.length == 0) {
					data3dan = '';
				}
			}
		}
	});
	//selectionModel for 4dan
	var sm4dan = new Ext.grid.CheckboxSelectionModel({
		checkOnly:true,
		listeners:{
			beforerowselect:function(sm, rowIndex, keepExisting, data){
				var selectedObookId = new Array();
				var dan1Data =  sm1dan.getSelected();
				var dan2Data = sm2dan.getSelections();
				var dan3Data = sm3dan.getSelections();
				
				selectedObookId.push(dan1Data.get('oBookId'));
				for(var i=0 ; i<dan2Data.length;i++){
					selectedObookId.push(dan2Data[i].get('oBookId'));
				}
				for(var i=0 ; i<dan3Data.length;i++){
					selectedObookId.push(dan3Data[i].get('oBookId'));
				}
				var dan4DataObook = data.get('oBookId');
				if(dan1Data){
					if(dan2Data){
						for(var i = 0; i<selectedObookId.length;i++){
							if(dan4DataObook == selectedObookId[i]){
								Ext.MessageBox.alert('선택에러','이전에 선택한 규정은 중복 선택하실수 없습니다.');
								return false;
							}
						}
						if(dan3Data){
							for(var i = 0; i<selectedObookId.length;i++){
								if(dan4DataObook == selectedObookId[i]){
									Ext.MessageBox.alert('선택에러','이전에 선택한 규정은 중복 선택하실수 없습니다.');
									return false;
								}
							}
						}else{
							Ext.MessageBox.alert('선택에러','2단이 되는 규정을 먼저 선택해주세요.');
							return false;
						}
					}else{
						Ext.MessageBox.alert('선택에러','2단이 되는 규정을 먼저 선택해주세요.');
						return false;
					}
				}else{
					Ext.MessageBox.alert('선택에러','1단이 되는 규정을 먼저 선택해주세요.');
					return false;
				}
			},
			rowselect: function(sm, rowIndex, data){
				data4dan = sm.getSelections();
				saveButt.setDisabled(false);
			},
			rowdeselect: function(sm, rowIndex, data){
				if (data4dan.length == 0) {
					data4dan = '';
				}
			}
		}
	});
//////////////////////////////////////////
//	서치폼 설정
//////////////////////////////////////////
	//1단 서치
	sch1dan = new Ext.Panel({
		renderTo:'grid1sch', width:300, frame:true,
		title:'1단이 되는 규정', layout:'column',anchor:'0',
		items:[{
			columnWidth:.7,
			baseCls:'x-plain',
			items:[{xtype:'textfield',fieldLabel:'검색', id:'query_1dan',name:'query_1dan',width:'200px', allowBlank:true,
			enableKeyEvents:true,
			listeners:{
				keydown:function(el, e){
					if(e.getKey() == 13){
						ds1dan.on('beforeload', function(){
						ds1dan.baseParams = {
							query:Ext.get('query_1dan').getValue(),
							job:'1dan'
						}
					});
					msg1dan.hide();
					grid1dan.render('grid1res');
					ds1dan.load({
						params:{
							start:0, limit:pageSize
						}
					});
					}
				}
			}}]
			},{
			columnWidth:.3,
			baseCls:'x-plain',
			items:[{xtype:'button',text:'검색',width:'90%',
				handler:function(){
					ds1dan.on('beforeload', function(){
						ds1dan.baseParams = {
							query:Ext.get('query_1dan').getValue(),
							job:'1dan'
						}
					});
					msg1dan.hide();
					grid1dan.render('grid1res');
					ds1dan.load({
						params:{
							start:0, limit:pageSize
						}
					});
				}
			}]
		}]
	});
	//2단 서치
	sch2dan = new Ext.Panel({
		width:300, frame:true, title:'2단이 되는 규정', layout:'column',anchor:'0',
		items:[{
			columnWidth:.7,
			baseCls:'x-plain',
			items:[{xtype:'textfield',fieldLabel:'검색', id:'query_2dan',name:'query_2dan',width:'200px', allowBlank:true,
			enableKeyEvents:true,
			listeners: {
				keydown: function(el, e){
					if (e.getKey() == 13) {
						ds2dan.on('beforeload', function(){
							if(!data1dan){
								Ext.MessageBox.alert('선택에러','1단이 되는 규정을 먼저 선택해주세요.');
								return false;
							}

							var oBookIds = sm1dan.getSelected().get('oBookId');
							ds2dan.baseParams = {
								query:Ext.get('query_2dan').getValue(),
								job:'2dan',
								oBookIds:oBookIds
							}
						});
						msg2dan.hide();
						grid2dan.render('grid2res');
						ds2dan.load();
					}
				}
			}
			}]
			},{
			columnWidth:.3,
			baseCls:'x-plain',
			items:[{xtype:'button',text:'검색',width:'90%',
				handler:function(){
					ds2dan.on('beforeload', function(){
						if(!data1dan){
							Ext.MessageBox.alert('선택에러','1단이 되는 규정을 먼저 선택해주세요.');
							return false;
						}

						var oBookIds = sm1dan.getSelected().get('oBookId');
						ds2dan.baseParams = {
							query:Ext.get('query_2dan').getValue(),
							job:'2dan',
							oBookIds:oBookIds
						}
					});
					msg2dan.hide();
					grid2dan.render('grid2res');
					ds2dan.load();
				}
			}]
		}]
	});
	//3단 서치
	sch3dan = new Ext.Panel({
		width:300, frame:true, title:'3단이 되는 규정', layout:'column',anchor:'0',
		items:[{
			columnWidth:.7,
			baseCls:'x-plain',
			items:[{xtype:'textfield',fieldLabel:'검색', id:'query_3dan',name:'query_3dan',width:'200px', allowBlank:true,
			enableKeyEvents:true,
			listeners: {
				keydown: function(el, e){
					if (e.getKey() == 13) {
						ds3dan.on('beforeload', function(){
							var oBookIds ;
							var dan1ObookId= sm1dan.getSelected();
							var dan2ObookIds = sm2dan.getSelections();
							oBookIds = dan1ObookId.get('oBookId')+',';
							for(var i = 0 ; i<dan2ObookIds.length;i++){
								oBookIds+=dan2ObookIds[i].get('oBookId')+',';
							}
							ds3dan.baseParams = {
								query:Ext.get('query_3dan').getValue(),
								job:'3dan',
								oBookIds:oBookIds
							}
						});
						msg3dan.hide();
						grid3dan.render('grid3res');
						ds3dan.load();
					}
				}
			}
			}]
			},{
			columnWidth:.3,
			baseCls:'x-plain',
			items:[{xtype:'button',text:'검색',width:'90%',
				handler:function(){
					ds3dan.on('beforeload', function(){
						var oBookIds ;
						var dan1ObookId= sm1dan.getSelected();
						var dan2ObookIds = sm2dan.getSelections();
						oBookIds = dan1ObookId.get('oBookId')+',';
						for(var i = 0 ; i<dan2ObookIds.length;i++){
							oBookIds+=dan2ObookIds[i].get('oBookId')+',';
						}
						ds3dan.baseParams = {
							query:Ext.get('query_3dan').getValue(),
							job:'3dan',
							oBookIds:oBookIds
						}
					});
					msg3dan.hide();
					grid3dan.render('grid3res');
					ds3dan.load();
				}
			}]
		}]
	});
	//4단 서치
	sch4dan = new Ext.Panel({
		width:300, frame:true, title:'4단이 되는 규정', layout:'column',anchor:'0',
		items:[{
			columnWidth:.7,
			baseCls:'x-plain',
			items:[{xtype:'textfield',fieldLabel:'검색', id:'query_4dan',name:'query_4dan',width:'200px', allowBlank:true,
			enableKeyEvents:true,
			listeners: {
				keydown: function(el, e){
					if (e.getKey() == 13) {
						ds4dan.on('beforeload', function(){
							var oBookIds ;
							var dan1ObookId= sm1dan.getSelected();
							var dan2ObookIds = sm2dan.getSelections();
							var dan3ObookIds = sm3dan.getSelections();
							oBookIds = dan1ObookId.get('oBookId')+',';
							for(var i = 0 ; i<dan2ObookIds.length;i++){
								oBookIds+=dan2ObookIds[i].get('oBookId')+',';
							}
							for(var i = 0 ; i<dan3ObookIds.length;i++){
								oBookIds+=dan3ObookIds[i].get('oBookId')+',';
							}
							ds4dan.baseParams = {
								query:Ext.get('query_4dan').getValue(),
								job:'4dan',
								oBookIds:oBookIds
							}
						});
						msg4dan.hide();
						grid4dan.render('grid4res');
						ds4dan.load();
					}
				}
			}
			}]
			},{
			columnWidth:.3,
			baseCls:'x-plain',
			items:[{xtype:'button',text:'검색',width:'90%',
				handler:function(){
					ds4dan.on('beforeload', function(){
						var oBookIds ;
						var dan1ObookId= sm1dan.getSelected();
						var dan2ObookIds = sm2dan.getSelections();
						var dan3ObookIds = sm3dan.getSelections();
						oBookIds = dan1ObookId.get('oBookId')+',';
						for(var i = 0 ; i<dan2ObookIds.length;i++){
							oBookIds+=dan2ObookIds[i].get('oBookId')+',';
						}
						for(var i = 0 ; i<dan3ObookIds.length;i++){
							oBookIds+=dan3ObookIds[i].get('oBookId')+',';
						}
						ds4dan.baseParams = {
							query:Ext.get('query_4dan').getValue(),
							job:'4dan',
							oBookIds:oBookIds
						}
					});
					msg4dan.hide();
					grid4dan.render('grid4res');
					ds4dan.load();
				}
			}]
		}]
	});
//////////////////////////////////////////
//	그리드 설정
//////////////////////////////////////////
	//1단검색 그리드
	grid1dan = new xg.GridPanel({
//		renderTo:'grid1res',
		store:ds1dan,
		cm:new xg.ColumnModel({
			columns:[
				sm1dan,
//				new Ext.grid.RowNumberer(),		//줄번호 먹이기
				{header:"규정명", width:140,dataIndex:'title'},
				{header:"4단여부", width:55, dataIndex:'is3dan'}
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
		bbar:new Ext.PagingToolbar({
			pageSize:pageSize, store: ds1dan,
			displayInfo:false, displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
		width:300,height:290,
        title: '1단이되는 규정 검색결과',
        iconCls: 'icon_reguSch'
	});
	var ordDD = 0;
	//2단검색 그리드
	grid2dan = new xg.EditorGridPanel({
		clicksToEdit: 1,
		store:ds2dan,
		cm:new xg.ColumnModel({
			columns:[
				sm2dan,
				{header:"규정명", width:195,dataIndex:'title'},
				{header:"순서", width:80,dataIndex:'ord', editor:ordCombo1,
					renderer:Ext.util.Format.comboRenderer(ordCombo1)
					}
			]
		}),
		sm:sm2dan,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
		width:300,height:290,
        title: '2단이되는 규정 검색결과',
        iconCls: 'icon_reguSch'
	});
	//3단검색 그리드
	grid3dan = new xg.EditorGridPanel({
		clicksToEdit: 1,
		store:ds3dan,
		cm:new xg.ColumnModel({
			columns:[
				sm3dan,
				{header:"규정명", width:195,dataIndex:'title'},
				{header:"순서", width:80,dataIndex:'ord', editor:ordCombo2,
					renderer:Ext.util.Format.comboRenderer(ordCombo2)
					}
			]
		}),
		sm:sm3dan,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
		width:300,height:290,
        title: '3단이되는 규정 검색결과',
        iconCls: 'icon_reguSch'
	});
	//4단검색 그리드
	grid4dan = new xg.EditorGridPanel({
		clicksToEdit: 1,
		store:ds4dan,
		cm:new xg.ColumnModel({
			columns:[
				sm4dan,
				{header:"규정명", width:195,dataIndex:'title'},
				{header:"순서", width:80,dataIndex:'ord', editor:ordCombo3,
					renderer:Ext.util.Format.comboRenderer(ordCombo3)
					}
			]
		}),
		sm:sm4dan,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
		width:300,height:290,
        title: '4단이되는 규정 검색결과',
        iconCls: 'icon_reguSch'
	});
});
