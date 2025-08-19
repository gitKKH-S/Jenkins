var viewport;
///////////////////////////////////////////
//	TODO : 해당 리스트에 따라 버튼 다르게 표시
///////////////////////////////////////////
var gridPanel1;
var gridPanel2;
var gridStore1;
var gridStore2;
var smProgGrid1;
var smProgGrid2;
var pageSize = 35;
Ext.onReady(function(){
	gridStore1 = new Ext.data.Store ({
		id:'p_ds',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/web/law/getData.do'
		}),
		remoteSort:true,
		pageSize : pageSize,
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'LAWSID'
		}, ['LAWSID','LAWID','LAWNAME', 'PROMULDT', 'REVCD','PLAWSID'])
	});
	

	gridStore2 = new Ext.data.Store ({
		id:'p_ds2',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/web/law/getMenuData.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'MAPPINGID'
		}, ['LAWSID','MAPPINGID','LAWID','LAWNAME', 'PROMULDT', 'REVCD','PLAWSID',{name:'ORD',type:'int',mapping:'ORD'}])
	});
	smProgGrid1 = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false,
		listeners:{
			selectionchange:function(){
				
				//var records = []; 
				//gridStore1.each(function(r){   
			    //    records.push(r.copy()); 
				//}); 
				//gridStore2.recordType = gridStore1.recordType; 
				//gridStore2.add(records);
			},
			//rowselect : ( SelectionModel this, Number rowIndex, Ext.data.Record r )
			rowselect:function(sModel, rIndex, data){
				var treeNode = treeMM.getSelectionModel().getSelectedNode();
				if(treeNode==null){
					alert("트리에서 메뉴를 먼저 선택하시기 바랍니다.");
					return;
				}else{
					var records = gridPanel1.selModel.getSelections();
					if(records[rIndex]){
						var plawsid = records[rIndex].data['LAWID'];
					}else{
						var plawsid = records[0].data['LAWID'];
						gridPanel1.getStore().remove(records);
					}
					
					//gridPanel1.getStore().remove(records);
					gridPanel2.getStore().add(records);
					gridPanel2.getView().refresh();
					Ext.Ajax.request({
						url:CONTEXTPATH + '/web/law/getDataMN.do',
						params:{
							menuid:treeNode.id,
							datacd:'I',
							plawsid : plawsid,
							gbn : Ext.getCmp('lawgbn').getValue().getGroupValue()
						},
						success : function(res, opts) {
							
						},
						failure : function() {
									alert('DB에러 발생');
						}
					});
				}
			}
		}
	});
	gridPanel1 = new Ext.grid.GridPanel({
		id:'p_grid1',
		renderTo:'grid1',
		store:gridStore1,
		width : Ext.getBody().getViewSize().width/2-115,
		height : Ext.getBody().getViewSize().height-89,
		cm:new Ext.grid.ColumnModel({
			columns:[
				smProgGrid1,
				{header:"법령명",  dataIndex:'LAWNAME',width:400},
				{header:"제/개정", dataIndex:'REVCD',width:130},
				{header:"공포일", dataIndex:'PROMULDT',width:130}
			]
		}),
		sm:smProgGrid1,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		layout: 'fit',
		tbar:[
			{xtype: 'radiogroup', fieldLabel: '구분', id:'lawgbn',width:140,
				 columns: 2, value:['LAW'],
				items: [
			        {boxLabel: '법령', inputValue:'LAW', name:'lawgbn'}
			        ,{boxLabel: '행정규칙', inputValue:'BYLAW', name:'lawgbn'}
				],
				listeners: {
	                change: function(radiogroup, radio){
	                	gridStore1.load({
	                		params:{
	                			start:0, limit:pageSize,
	                			lawgbn:radio.inputValue,
	                			schtxt : Ext.getCmp('schText').getValue(),
	                			stitle : 'Y'
	                		}
	                	});     
	                }
	            }

			},'->',
  			{xtype:'textfield',width:180,fieldLabel:'search',name:'schText',id:'schText', emptyText:'검색어를 입력하시기 바랍니다....',enableKeyEvents:true,
  				listeners:{
  				keydown :function(el, e){
  					if(e.getKey() == 13) {
  						var schTxt = Ext.getCmp('schText').getValue();
  						gridStore1.load({
  							params:{
  								start:0, limit:pageSize,
  								lawgbn:Ext.getCmp('lawgbn').getValue().getGroupValue(),
  								Schtxt : schTxt,
  								stitle : 'Y'
  							}
  						});
  					}
  				}
  			}},
  			new Ext.Button ({
  				id:'butSch', text:'<b>검색</b>',iconCls:'byprogress',
  				listeners:{
  					click:function(btn, eObj){
  						var schTxt = Ext.getCmp('schText').getValue();
  						gridStore1.load({
  							params:{
  								start:0, limit:pageSize,
  								lawgbn:Ext.getCmp('lawgbn').getValue().getGroupValue(),
  								Schtxt : schTxt,
  								stitle : 'Y'
  							}
  						});
  					}
  				}
  			}),'-'
  		],
		bbar:new Ext.PagingToolbar({
			pageSize:pageSize, store: gridStore1,
			displayInfo:true, displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
		listeners: {
			rowcontextmenu:function(grid, idx, e){
				
			},
			contextmenu:function(e){
				e.preventDefault();
			},
			//cellcontextmenu : ( Grid this, Number rowIndex, Number cellIndex, Ext.EventObject e )
			cellcontextmenu:function(grid, idx, cIdx, e){
				e.preventDefault();
			},
			rowclick: function (grid, idx, e){
				
			}
		}
	});

	smProgGrid2 = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false,
		listeners:{
			selectionchange:function(){
				chkedData = smProgGrid2.getSelected();
			},
			//rowselect : ( SelectionModel this, Number rowIndex, Ext.data.Record r )
			rowselect:function(sModel, rIndex, data){
				var treeNode = treeMM.getSelectionModel().getSelectedNode();
				if(treeNode==null){
					alert("트리에서 메뉴를 먼저 선택하시기 바랍니다.");
					return;
				}else{
					var treeNode = treeMM.getSelectionModel().getSelectedNode();
					if(treeNode==null){
						alert("트리에서 메뉴를 먼저 선택하시기 바랍니다.");
						return;
					}else{
						/**/
					}
				}
			}
		}
	});
	
	//그리드 컨텍스트 메뉴
	var rowContext = new Ext.menu.Menu({
		id:'rowContextMenu',
		items:[
			{id:'row_viewDocInfo', cls:'icon_viewDocInfo', text:'삭제',
			handler:function(){
				var treeNode = treeMM.getSelectionModel().getSelectedNode();
				if(treeNode==null){
					alert("트리에서 메뉴를 먼저 선택하시기 바랍니다.");
					return;
				}else{
					var records = gridPanel2.selModel.getSelections();
					var records2 = gridPanel2.selModel.getSelections();
					var plawsid = records2[0].data['PLAWSID'];
					gridPanel2.getStore().remove(records);
					gridPanel2.getView().refresh();
					Ext.Ajax.request({
						url:CONTEXTPATH + '/web/law/getDataMN.do',
						params:{
							menuid:treeNode.id,
							datacd:'D',
							plawsid : plawsid,
							gbn : Ext.getCmp('lawgbn').getValue().getGroupValue()
						},
						success : function(res, opts) {
							
						},
						failure : function() {
							alert('DB에러 발생');
						}
					});
				}
				
			}}
		]
	});//그리드 컨텍스트 메뉴 끝
	
	gridPanel2 = new Ext.grid.EditorGridPanel({
		id:'p_grid2',
		renderTo:'grid2',
		store:gridStore2,
		width : Ext.getBody().getViewSize().width/2-115,
		height : Ext.getBody().getViewSize().height-89,
		cm:new Ext.grid.ColumnModel({
			columns:[
				smProgGrid2,
				{header:"법령명",  dataIndex:'LAWNAME',width:320},
				{header:"제/개정", dataIndex:'REVCD',width:130},
				{header:"공포일", dataIndex:'PROMULDT',width:130},
				{header:"정렬순서",  dataIndex:'ORD',width:80, sortable:true
					,editor: {
			            xtype: 'textfield',
			            allowBlank: false,
			            listeners: {
			            	specialkey: function(field, e) {
			                    if (e.getKey() == e.ENTER) {
			                    	//alert(field.value);
			                    }
			            	},
			            	change : function(field, newValue,o ,e) {
			            		var otext = field.value;
			            		var ntext = newValue;
			            		if(otext!=ntext){
			            			var selModel=gridPanel2.getSelectionModel();
          							var rowData = selModel.getSelected();
          							var mappingid = rowData.get('MAPPINGID'); 
          							Ext.Ajax.request({
          								url:CONTEXTPATH + '/web/law/getDataMN.do',
          								params: {
          									datacd: 'U',
          									ord: ntext,
          									mappingid:mappingid
          								},
          								success: function(res, opts){
          									alert("수정완료 되었습니다.");
          								},
          								failure: function(res, opts){
          									
          								}
          							});
			            		}
			            	}
			            }

			        }
				},
			]
		}),
		sm:smProgGrid2,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		layout: 'fit',
		bbar:new Ext.PagingToolbar({
			pagesize:pageSize, store: gridStore2,
			displayInfo:true, displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
        title: '검색결과',
        iconCls: 'icon_reguSch',
		listeners: {
			rowcontextmenu:function(grid, idx, e){
				rowContext.showAt(e.getXY());
			},
			contextmenu:function(e){
				e.preventDefault();
			},
			//cellcontextmenu : ( Grid this, Number rowIndex, Number cellIndex, Ext.EventObject e )
			cellcontextmenu:function(grid, idx, cIdx, e){
				e.preventDefault();
			},
			rowclick: function (grid, idx, e){
				
			}
		}
	});
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [
			new Ext.BoxComponent({ // raw
            region: 'north',
            el: 'topMenuHolder',
            height: 75
        }), {
            region: 'west', contentEl: 'menuList', id: 'p_docNum', title: "법령/행정규칙 메뉴",
            split: true, width: 240, minSize: 175, maxSize: 400, collapsible: true,
            margins: '0 0 0 0', layout: 'accordion', layoutConfig: { animate: true },
            iconCls: 'byprogress', autoScroll: true
        },{
        	region: 'center',
        	id:'center',
        	layout:'anchor',
        	items:[{
                anchor:'100%',
                baseCls:'x-plain',
                layout:'hbox',
                layoutConfig: {
                    padding: 0
                },
                defaults:{
                    margins:'0 0 0 0',
                    pressed: false,
                    toggleGroup:'btns',
                    allowDepress: false
                },
                items: [
						{
							autoHeight: true,
						    flex : 1,
						    items: [
						            	gridPanel1
						            ]
						},
						{
							autoHeight: true,
						    flex : 1,
						    items: [
						            	gridPanel2
						            ]
						}

                ]
        	}]
        },
		new Ext.BoxComponent({
			region:'south',
			el:'botMenuHolder',
			height:10
		})
		]
    });
    
    gridStore1.on('beforeload', function(){
    	gridStore1.baseParams = {
    		pagesize : pageSize,
			lawgbn:Ext.getCmp('lawgbn').getValue().getGroupValue(),
			schtxt : Ext.getCmp('schText').getValue()
		};
	});
    gridStore1.load({
		params:{
			start:0, limit:pageSize
		}
	});
	
    gridStore2.on('beforeload', function(){
    	gridStore2.baseParams = {
    			
		};
	});
    gridStore2.load({
		params:{
			start:0, limit:pageSize
		}
	});
});
Ext.EventManager.onWindowResize(function(w, h){
	gridPanel1.setWidth(Ext.getBody().getViewSize().width/2-115);
	gridPanel2.setWidth(Ext.getBody().getViewSize().width/2-115);
	gridPanel1.setHeight(Ext.getBody().getViewSize().height-89);
	gridPanel2.setHeight(Ext.getBody().getViewSize().height-89);
});