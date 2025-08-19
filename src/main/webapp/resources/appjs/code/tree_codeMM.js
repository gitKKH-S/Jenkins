Ext.QuickTips.init();

//코드관리 트리 시작
	var dsCode;		//데이터스토어
	var pageSize = 15;
	var smCode;
	var gridCodeMan;
	function encodingParam(param){
		return param;
		//return encodeURIComponent(param);
	}

Ext.onReady(function(){

	//데이터소스

	//셀렉트모델

	//그리드


	var xg = Ext.grid;

//////////////////////////////////////////
//	공통모듈 설정 - 데이터소스, 셀렉트모델
//////////////////////////////////////////
	dsCode = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/code/getCodeList.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result',  totalProperty: 'total', idProperty: 'CD_MNG_NO'
		}, ['CD_MNG_NO', 'CD_LCLSF_ENG_NM', 'CD_LCLSF_KORN_NM', 'CD_NM', 'SORT_SEQ', 'ORDSORT', 'USE_YN'])
	});

	smCode = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true,
		listeners:{
			selectionchange:function(sm){
				//선택된 데이터로 필요 로직 처리
			},
			//rowselect : ( SelectionModel this, Number rowIndex, Ext.data.Record)
			rowselect:function(sm, rowIndex, record){

			},
			//rowdeselect : ( SelectionModel this, Number rowIndex, Record record )
			rowdeselect:function(sm, rowIndex, record){

			}
		}
	});

//////////////////////////////////////////
//	그리드
//////////////////////////////////////////
	//그리드 컨텍스트 메뉴
	var rowContext = new Ext.menu.Menu({
		id:'rowContextMenu',
		items:[
			{id:'row_modCode', cls:'modCode', text:'코드정보 수정',
			handler:function(){
				var rowData = gridCodeMan.getSelectionModel().getSelected();
				var CD_MNG_NO = rowData.get('CD_MNG_NO');
				var CD_LCLSF_ENG_NM = rowData.get('CD_LCLSF_ENG_NM');
				var CD_LCLSF_KORN_NM = rowData.get('CD_LCLSF_KORN_NM');
				var CD_NM = rowData.get('CD_NM');
				var SORT_SEQ = rowData.get('SORT_SEQ');
				var ord2;
				var USE_YN = rowData.get('USE_YN');

				var dsOrd = new Ext.data.Store({
					proxy:new Ext.data.HttpProxy({
						url:CONTEXTPATH+'/bylaw/code/getOrd.do'
					}),
					reader:new Ext.data.JsonReader({
						root:'result'},['ordVal', 'SORT_SEQ']
					)
				});
				var dsCodeExp = new Ext.data.Store({
					proxy: new Ext.data.HttpProxy({
						url: CONTEXTPATH + '/bylaw/code/getCodeCombo.do'
					}),
					reader: new Ext.data.JsonReader({
						root: 'result', idProperty: 'id'
					}, ['id', 'CD_LCLSF_ENG_NM', 'CD_LCLSF_KORN_NM'])
				});
				
				var frm_modLaw = new Ext.FormPanel({
					url:CONTEXTPATH+'/bylaw/code/updateCode.do',
					labelWidth:80, width:382, autoHeight:true, monitorValid:true,frame:true,
					items: {
						xtype: 'fieldset', title: '법령약어 수정',
						items: [

							{width:230, fieldLabel: '법령명', title:CD_NM, name:'CD_NM', allowBlank:false, value:CD_NM},
							{xtype:'textfield',width:230, fieldLabel: '약어', name:'USE_YN', allowBlank:false, value:USE_YN},

							{xtype: 'hidden', id:'m_codeName', value:CD_LCLSF_ENG_NM}

						]
					},
					buttons: [
						{
						text: '저장', formBind: true, handler: function(){
							frm_modLaw.getForm().submit({
								method: 'POST',
								params: {
									job:'updateCode',
									CD_MNG_NO:CD_MNG_NO,

									SORT_SEQ:SORT_SEQ,
									CD_LCLSF_ENG_NM2:CD_LCLSF_ENG_NM
								},
								waitTitle: 'Connecting',
								waitMsg: '자료를 저장중입니다....',
								success: function(form, action){
									Ext.Msg.alert('성공', '성공적으로 수정되었습니다!!', function(btn, text){
					  					if (btn == 'ok'){
				                        	var result = Ext.util.JSON.decode(action.response.responseText);
					                        frm_window.close();
											var CD_LCLSF_ENG_NM = result.data.CD_LCLSF_ENG_NM;
											dsCode.on('beforeload', function(){
												dsCode.baseParams = {
													job: 'getList',
													CD_LCLSF_ENG_NM: CD_LCLSF_ENG_NM
												}
											});
											dsCode.load({
												params:{
													start:0, limit:pageSize
												}
											});
                                   		}
						        	});
								},
								failure: function(form, action){
									Ext.MessageBox.alert('에러','서버와의 연결상태가 좋지 않습니다.');
								}
							});
						}
						}
					]
				});

			    var frm_modCode = new Ext.FormPanel({
					url:CONTEXTPATH+'/bylaw/code/updateCode.do',
					labelWidth:80, width:382, autoHeight:true, monitorValid:true,frame:true,
					items: {
						xtype: 'fieldset', title: '코드정보 수정',
						items: [
							{xtype:'combo',width:210, fieldLabel:'코드분류', name:'CD_LCLSF_KORN_NM', allowBlank:false, value:CD_LCLSF_KORN_NM,
								triggerAction:'all', lazyRender:true,store:dsCodeExp, displayField:'CD_LCLSF_KORN_NM',valueField:'CD_LCLSF_KORN_NM',
								listeners:{
									beforerender:function(){
										dsCodeExp.on('beforeload', function(){
											dsCodeExp.baseParams = {
												job:'getCodeCombo'
											}
										});
									},
									//select : ( Ext.form.ComboBox combo, Ext.data.Record record, Number index )
									select:function(combo, record, index){
										var cName = Ext.getCmp('m_codeName');
										cName.setValue(record.get('CD_LCLSF_ENG_NM'));
									}
								}
							},
							{xtype:'textfield',width:230, fieldLabel: '코드명', name:'CD_NM', allowBlank:false, value:CD_NM},
							{xtype: 'radiogroup', fieldLabel: '사용여부', itemCls: 'x-radio-group-alt', columns: 1,
								items: [
							        {boxLabel: '사용', name: 'USE_YN', inputValue:'Y', checked:true},
							        {boxLabel: '사용안함', name: 'USE_YN', inputValue:'N'}
								]
							},
							{xtype: 'hidden', id:'m_codeName', value:CD_LCLSF_ENG_NM}
							,
							{xtype:'combo', id:'m_ord2', width:50, fieldLabel:'정렬순서',name:'m_ord2',
								typeAhead: false, triggerAction: 'all', lazyRender:true,
				    			store:dsOrd,displayField:'SORT_SEQ',valueField:'ordVal',
					   		listeners:{
					    		beforerender:function(){
									dsOrd.on('beforeload', function(){
											dsOrd.baseParams = {
			    								job:'getOrd', CD_LCLSF_ENG_NM:CD_LCLSF_ENG_NM, stat:'MOD'
										}
			     						});
									},
									select:function(combo, record, index){
										ord2 = combo.value;
									}
								}
							}
						]
					},
					buttons: [
						{
						text: '저장', formBind: true, handler: function(){
							frm_modCode.getForm().submit({
								method: 'POST',
								params: {
									job:'updateCode',
									CD_MNG_NO:CD_MNG_NO,
									SORT_SEQ:SORT_SEQ,
									m_ord:ord2,
									CD_LCLSF_ENG_NM2:CD_LCLSF_ENG_NM
								},
								waitTitle: 'Connecting',
								waitMsg: '자료를 저장중입니다....',
								success: function(form, action){
									Ext.Msg.alert('성공', '성공적으로 수정되었습니다!!', function(btn, text){
					  					if (btn == 'ok'){
				                        	var result = Ext.util.JSON.decode(action.response.responseText);
					                        frm_window.close();
											var CD_LCLSF_ENG_NM = result.data.CD_LCLSF_ENG_NM;
											dsCode.on('beforeload', function(){
												dsCode.baseParams = {
													job: 'getList',
													CD_LCLSF_ENG_NM: CD_LCLSF_ENG_NM
												}
											});
											dsCode.load({
												params:{
													start:0, limit:pageSize
												}
											});
                                   		}
						        	});
								},
								failure: function(form, action){
									Ext.MessageBox.alert('에러','서버와의 연결상태가 좋지 않습니다.');
								}
							});
						}
						}
					]
				});

				var frm_modPLCode = new Ext.FormPanel({
					url:CONTEXTPATH+'/bylaw/code/updateCode.do',
									labelWidth:80, width:382, autoHeight:true, monitorValid:true,frame:true,
					items: {
						xtype: 'fieldset', title: '코드정보 수정',
						items: [
							{xtype:'textfield', id:'tfMoCodeExp', width:230, fieldLabel:'코드분류', name:'CD_LCLSF_KORN_NM', allowBlank:false , value:CD_LCLSF_KORN_NM, readOnly:true},
							{xtype:'datefield', id:'tfMoCode',  width:230, fieldLabel: '업데이트일', name:'CD_NM',format:'Y.m.d', allowBlank:false, value:CD_NM},
							{xtype: 'radiogroup', fieldLabel: '사용여부', itemCls: 'x-radio-group-alt', columns: 1,
								items: [
							        {boxLabel: '사용', name: 'USE_YN', inputValue:'Y', checked:true},
							        {boxLabel: '사용안함', name: 'USE_YN', inputValue:'N'}
								]
							},
							{xtype: 'hidden', id:'m_codeName', value:CD_LCLSF_ENG_NM},
							{xtype:'combo', id:'m_ord2', width:50, fieldLabel:'정렬순서',name:'m_ord2',
								typeAhead: false, triggerAction: 'all', lazyRender:true,
								store:dsOrd,displayField:'SORT_SEQ',valueField:'ordVal',
								listeners:{
									beforerender:function(){
										dsOrd.on('beforeload', function(){
											dsOrd.baseParams = {
												job:'getOrd', CD_LCLSF_ENG_NM:CD_LCLSF_ENG_NM, stat:'MOD'
											}
										});
									},
									select:function(combo, record, index){
										ord2 = combo.value;
									}
								}
							}
						]
					},
					buttons: [
						{
						text: '저장', formBind: true, handler: function(){
							frm_modPLCode.getForm().submit({
								method: 'POST',
								params: {
									job:'updateCode',
									CD_MNG_NO:CD_MNG_NO,
									SORT_SEQ:SORT_SEQ,
									m_ord: ord2,
									CD_LCLSF_ENG_NM2:CD_LCLSF_ENG_NM
								},
								waitTitle: 'Connecting',
								waitMsg: '자료를 저장중입니다....',
								success: function(form, action){
									Ext.Msg.alert('성공', '성공적으로 수정되었습니다!!', function(btn, text){
					  					if (btn == 'ok'){
				                        	var result = Ext.util.JSON.decode(action.response.responseText);
					                        frm_window.close();
											var CD_LCLSF_ENG_NM = result.data.CD_LCLSF_ENG_NM;
											dsCode.on('beforeload', function(){
												dsCode.baseParams = {
													job: 'getList',
													CD_LCLSF_ENG_NM: CD_LCLSF_ENG_NM
												}
											});
											dsCode.load({
												params:{
													start:0, limit:pageSize
												}
											});
                                   		}
						        	});
								},
								failure: function(form, action){
									Ext.MessageBox.alert('에러','서버와의 연결상태가 좋지 않습니다.');
								}
							});
						}
						}
					]
				});
				var frm_window;
				if(CD_LCLSF_ENG_NM=='JOB'){
					frm_window = new Ext.Window({
						closable:true, width:400, autoHeight:true,
						items: [frm_modPLCode], plain:true, modal:true
					});
				}else{
					if(CD_LCLSF_ENG_NM=='LAW'){
						frm_window = new Ext.Window({
							closable:true, width:400, autoHeight:true,
							items: [frm_modLaw], plain:true, modal:true
						});
					}else{
						frm_window = new Ext.Window({
							closable:true, width:400, autoHeight:true,
							items: [frm_modCode], plain:true, modal:true
						});
					}
				}

				frm_window.show(Ext.getBody());

			}},
			{id:'row_delCode', cls:'delCode', text:'코드정보 삭제',
			handler:function(){
				var rowData = gridCodeMan.getSelectionModel().getSelected();
				var CD_MNG_NO = rowData.get('CD_MNG_NO');
				var CD_LCLSF_ENG_NM = rowData.get('CD_LCLSF_ENG_NM');

				Ext.Msg.confirm('삭제확인','선택하신 코드데이터를 정말로 삭제하시겠습니까?',function(btn,text){
					if(btn=='yes'){
						Ext.Ajax.request({
						url: CONTEXTPATH + '/bylaw/code/deleteCode.do',
						params: {
							job: "deleteCode",
							CD_MNG_NO : CD_MNG_NO,
							CD_LCLSF_ENG_NM : CD_LCLSF_ENG_NM
						},
						success: function(res, opts){
							var result = Ext.decode(res.responseText);
							if(result.result==1){
								Ext.MessageBox.alert('삭제 성공','선택하신 코드가 삭제 되었습니다.');
								dsCode.on('beforeload', function(){
									dsCode.baseParams = {
										CD_LCLSF_ENG_NM: CD_LCLSF_ENG_NM
									}
								});
								dsCode.load({
									params:{
										start:0, limit:pageSize
									}
								});
							}else{
								if (CD_LCLSF_ENG_NM=='LAW'){
								Ext.MessageBox.alert('삭제 불가','법령정보는 삭제할 수 없습니다.');
								}else{
								Ext.MessageBox.alert('삭제 실패','오류로 인해 삭제에 실패 했습니다.');
								}
							}
						},
						failure: function(res, opts){
							Ext.MessageBox.alert('데이터삭제 실패','서버와의 연결상태가 좋지 않습니다. 에러코드:' + response.status);
						}
					});
					}else{
						//아니오 눌렀을때 처리, 번거로워 보여서 생략
					}

				});
			}}
		]
	});



	gridCodeMan = new xg.GridPanel({
		renderTo:'gridCodeMan',
		store:dsCode,
		cm:new xg.ColumnModel({
			columns:[
				smCode,
//				new Ext.grid.RowNumberer(),		//줄번호 먹이기
				{header:"순서",  width:20, dataIndex:'ORDSORT'},
				{header:"코드분류", width:40, dataIndex:'CD_LCLSF_KORN_NM'},
				{header:"코드명", dataIndex:'CD_NM'},
				{header:"사용여부",  width:60, dataIndex:'USE_YN'}
			]
		}),
		sm:smCode,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
		bbar:new Ext.PagingToolbar({
			pageSize:pageSize, store: dsCode,
			displayInfo:false, displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
		width:'100%',autoHeight:true,
        title: '리스트',
        iconCls: 'icon-grid',
				listeners: {
			rowcontextmenu:function(grid, idx, e){
				var selModel=grid.getSelectionModel();
				selModel.selectRow(idx);
				var rowData = selModel.getSelected();
				rowContext.showAt(e.getXY());
			},
			contextmenu:function(e){
				e.preventDefault();
			},
			//cellcontextmenu : ( Grid this, Number rowIndex, Number cellIndex, Ext.EventObject e )
			cellcontextmenu:function(grid, idx, cIdx, e){
				e.preventDefault();
			}
		}
	});




//////////////////////////////////////////
//	트리시작
//////////////////////////////////////////
	var Tree = Ext.tree;
	var tLoder = new Ext.tree.TreeLoader({
		dataUrl: CONTEXTPATH+'/bylaw/code/getNodes.do'
	})
	treeMM = new Tree.TreePanel({
		id:'treeMM', renderTo:'treeHolder', useArrows: false, autoScroll: true,
		animate : true, enableDD: true, containerScroll: true, border: false,
		loader : tLoder,
		root: {
			nodeType: 'async', text:'코드관리', draggable:false, id: '0', cls:'codeRoot'
		},
		tbar:[new Ext.Toolbar.TextItem("구분검색 "),
			{xtype:'textfield',width:110,fieldLabel:'search',name:'schText',id:'schText', emptyText:'검색어를 입력 바...',enableKeyEvents:true,
				listeners:{
					keydown :function(el, e){
						if(e.getKey() == 13) {
							var schTxt = Ext.getCmp('schText').getValue();
							treeMM.loader.baseParams.schTxt=schTxt;
							treeMM.root.reload();
						}
					}
			}},
			new Ext.Button ({
				id:'butSch', text:'<b>검색</b>',iconCls:'byprogress',
				listeners:{
					click:function(btn, eObj){
						var schTxt = Ext.getCmp('schText').getValue();
						treeMM.loader.baseParams.schTxt=schTxt;
						treeMM.root.reload();
					}
				}
			})
		],
		listeners: {
			click: function(node, e){
				var CD_LCLSF_ENG_NM = node.attributes.CD_LCLSF_ENG_NM;
				gridCodeMan.setTitle(node.attributes.text + '리스트');
				dsCode.on('beforeload', function(){
					dsCode.baseParams = {
						CD_LCLSF_ENG_NM: CD_LCLSF_ENG_NM
					}
				});
				dsCode.load({
					params:{
						start:0, limit:pageSize
					}
				});
				if ( CD_LCLSF_ENG_NM == 'LAW'){
					gridCodeMan.getColumnModel().setColumnHeader(3, "법령명");
					gridCodeMan.getColumnModel().setColumnHeader(4, "약어");
				}else{
					gridCodeMan.getColumnModel().setColumnHeader(3, "코드명");
					gridCodeMan.getColumnModel().setColumnHeader(4, "사용여부");
				}
			}
		}
	});

	treeMM.getRootNode().expand();
});

