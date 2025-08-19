var progressGrid; 	//검색결과 그리드
var dsSchResult;	//검색결과 데이터스토어
var svGrid2; 	//검색결과 그리드
var svResult2;	//검색결과 데이터스토어
var pageSize=15;
var step;
var rowContext;
// var win_docInfo;
// var tab_docInfo;

var botToolbar;		//그리드 버튼
var docTitle;		//문서 타이틀
var viewport;
var buttonfunction;
var cw=1000;
var ch=668;
var sw=screen.availWidth;
var sh=screen.availHeight;
var px=(sw-cw)/2;
var py=(sh-ch)/2;
var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=no,resizable=no,status=no,toolbar=no";
function goWin(BASTATEID,gbn){
	window.open("./proc/hwpEdit.jsp?BASTATEID="+BASTATEID+"&gbn="+gbn, BASTATEID, property);
}
///////////////////////////////////////////
//	TODO : 해당 리스트에 따라 버튼 다르게 표시
///////////////////////////////////////////
Ext.onReady(function(){

	var xg = Ext.grid;	//shortCut
	var smProgGrid; 	//체크박스 셀렉션 모델
	var chkedData;		//체크된 데이터

	//그리드 컨텍스트 메뉴
	botToolbar = new Ext.Toolbar({
		items:[
			{xtype: 'tbfill'},'-'
		]
	});
	var botPan = new Ext.Panel({
		renderTo:'gridBut',
		items:[botToolbar]
	})
	
	dsSchResult = new Ext.data.Store ({
		id:'p_ds',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/setting/settingIbanlist.do'
		}),
		remotSort: true,
		reader: new Ext.data.JsonReader({
			root: 'result',  idProperty: 'BASTATEID'
		}, ['BASTATEID','STATEID','STATECD', 'BACD', 'NEXTCD','REFSTATEID','DOCCD1','DOCCD2','DOCCD3','DOCCD4','APPROVEYN','MAILYN','SANCTIONYN','APPLYYN'])
	});
	
	svResult2 = new Ext.data.Store ({
		id:'p_ds2',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/jsp/bylaw/setting/proc/settingProc.jsp'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result',  idProperty: 'SETTINGID'
		}, ['SETTINGID','USERGBN', 'DOCTYPE', 'DOCCD','PRINT','SAVE','SECURITYYN'])
	});
	
	var nextcds = new Ext.data.Store ({
		id:'p_ds3',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/setting/getNextCombo.do'
		}),
		baseParams : {
				
		},
		reader:new Ext.data.JsonReader({root:'result'},['STATEID','STATECD'])
	});
	nextcds.load();
	smProgGrid = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false,
		listeners:{
			selectionchange:function(){
				chkedData = smProgGrid.getSelected();
				//선택된 데이터로 필요 로직 처리
			},
			//rowselect : ( SelectionModel this, Number rowIndex, Ext.data.Record r )
			rowselect:function(){

			}
		}
	});
	var height = window.innerHeight;
	progressGrid = new xg.EditorGridPanel({
		id:'p_grid',
		renderTo:'grid',
		store:dsSchResult,
		height:height-220,
		//width:document.body.clientWidth-220,
		cm:new xg.ColumnModel({
			columns:[
				{header:"현재단계", dataIndex:'STATECD', sortable: true},
				{header:"생성버튼명", dataIndex:'BACD'
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
			            			var selModel=progressGrid.getSelectionModel();
          							var rowData = selModel.getSelected();
          							var BASTATEID = rowData.get('BASTATEID'); 
          							Ext.Ajax.request({
          								url: CONTEXTPATH + '/bylaw/setting/settingIbanUpdate3.do',
          								params: {
          									BASTATEID: BASTATEID,
          									BACD: newValue
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
				{header:"다음진행단계",dataIndex:'NEXTCD', sortable: false,
					editor   : {xtype:'combo', 
                        		store: nextcds,
								displayField:'STATECD',
								valueField: 'STATECD',
								mode: 'local',
								typeAhead: false,
								triggerAction: 'all',
								lazyRender: true,
								emptyText: 'Select action',
                              listeners:{
          						beforerender:function(){
          							nextcds.on('beforeload', function(){
          								nextcds.baseParams = {
          									
          								}
          							});
          						},
          						select:function(cb, data, idx){
          							var selModel=progressGrid.getSelectionModel();
          							var rowData = selModel.getSelected();
          							var BASTATEID = rowData.get('BASTATEID'); 
          							var REFSTATEID = data.get('STATEID');
          							Ext.Ajax.request({
          								url: CONTEXTPATH + '/bylaw/setting/settingIbanUpdate2.do',
          								params: {
          									BASTATEID: BASTATEID,
          									REFSTATEID: REFSTATEID
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
				},
				{header:"자치법규", dataIndex:'DOCCD1',width:40, sortable: true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='DOCCD1'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
				},
				{header:"종법", dataIndex:'DOCCD2',width:40, sortable: true,hidden:true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='DOCCD2'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
				},
				{header:"종령", dataIndex:'DOCCD3',width:40, sortable: true,hidden:true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='DOCCD3'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
				},
				{header:"규정", dataIndex:'DOCCD4',width:40, sortable: true,hidden:true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='DOCCD4'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
				},
				{header:"전자결재여부", dataIndex:'SANCTIONYN',width:40,hidden:true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				    	var ret = "<input type='checkbox' id='SANCTIONYN'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				        return ret;
				    }
					
				},
				{header:"전자결재내용", dataIndex:'SANCTIONYN',width:40,hidden:true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value,cell,record,rowindex,columnindex,store) {
				    	var selModel=progressGrid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						
						//console.log(rowData.get('BASTATEID'));
				    	//console.log(store);
						
						
				    	//alert(.get('BASTATEID'));
						
						var BASTATEID = rowData.get('BASTATEID'); 
				    	var ret = "";
				    	if(value=='Y'){
				    		ret = ret + "<button style='padding-top:3px;' onclick=\"goWin('"+BASTATEID+"','S');\" id='scontent'>내용편집</button>";
				    	}
				        return ret;
				    }
					
				},
				/**
				{header:"승인권자 지정여부", dataIndex:'APPROVEYN',width:20,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='APPROVEYN'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
					
				},
				**/
				{header:"메일내용", dataIndex:'MAILYN',width:40,hidden:true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value,cell,record,rowindex,columnindex,store) {
				    	var selModel=progressGrid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						
						//console.log(rowData.get('BASTATEID'));
				    	//console.log(store);
						
						
				    	//alert(.get('BASTATEID'));
						
						var BASTATEID = rowData.get('BASTATEID'); 
				    	var ret = "";
				    	if(value=='Y'){
				    		ret = ret + "<button style='padding-top:3px;' onclick=\"goWin('"+BASTATEID+"','M');\" id='mcontent'>내용편집</button>";
				    	}
				        return ret;
				    }
					
				}
			]
		}),
		sm:smProgGrid,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
        title: '입안프로세스 SETTING',
        iconCls: 'icon-grid',
		listeners: {
			rowcontextmenu:function(grid, idx, e){
				var selModel=grid.getSelectionModel();
				selModel.selectRow(idx);
				var rowData = selModel.getSelected();

			},
			contextmenu:function(e){
				e.preventDefault();
			},
			cellcontextmenu:function(grid, idx, cIdx, e){
				e.preventDefault();
			},
			cellclick: function(iView, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
		       
		    },
			rowclick: function (grid, idx, e){
				var obj1 = Ext.select('input[id=DOCCD1]').elements;
				var obj11 = Ext.select('input[id=DOCCD2]').elements;
				var obj12 = Ext.select('input[id=DOCCD3]').elements;
				var obj13 = Ext.select('input[id=DOCCD4]').elements;
				//var obj2 = Ext.select('input[id=APPLYYN]').elements;
				//var obj3 = Ext.select('input[id=SANCTIONYN]').elements;
				//var obj4 = Ext.select('input[id=APPROVEYN]').elements;
				//var obj5 = Ext.select('input[id=MAILYN]').elements;
				
				//var obj6 = Ext.select('button[id=scontent]').elements;
				//var obj7 = Ext.select('button[id=mcontent]').elements;
			
				var models = grid.getStore().getRange();
				
				if(obj1[idx].checked){
					models[idx].set("DOCCD1", "Y");
				}else{
					models[idx].set("DOCCD1", "N");
				}
				if(obj11[idx].checked){
					models[idx].set("DOCCD2", "Y");
				}else{
					models[idx].set("DOCCD2", "N");
				}
				if(obj12[idx].checked){
					models[idx].set("DOCCD3", "Y");
				}else{
					models[idx].set("DOCCD3", "N");
				}
				if(obj13[idx].checked){
					models[idx].set("DOCCD4", "Y");
				}else{
					models[idx].set("DOCCD4", "N");
				}
//				if(obj2[idx].checked){
//					models[idx].set("APPLYYN", "Y");
//				}else{
//					models[idx].set("APPLYYN", "N");
//				}
//				if(obj3[idx].checked){
//					models[idx].set("SANCTIONYN", "Y");
//					//obj6[idx].onclick=function(){
//					//	
//					//};
//				}else{
//					models[idx].set("SANCTIONYN", "N");
//				}
				//if(obj4[idx].checked){
				//	models[idx].set("APPROVEYN", "Y");
				//}else{
				//	models[idx].set("APPROVEYN", "N");
				//}
//				if(obj5[idx].checked){
//					models[idx].set("MAILYN", "Y");
//					//obj7[idx].onclick = function(){
//					//	window.open("./proc/hwpEdit.jsp?BASTATEID="+BASTATEID+"&gbn=M", BASTATEID, property);
//					//};
//				}else{
//					models[idx].set("MAILYN", "N");
//				}
//				
				
				var selModel= grid.getSelectionModel();
				var userData = selModel.getSelected();
				
				selModel.selectRow(idx);
				var DOCCD1 = userData.get('DOCCD1');
				var DOCCD2 = userData.get('DOCCD2');
				var DOCCD3 = userData.get('DOCCD3');
				var DOCCD4 = userData.get('DOCCD4');
				//var APPLYYN = userData.get('APPLYYN');
				//var SANCTIONYN = userData.get('SANCTIONYN');
				//var APPROVEYN = userData.get('APPROVEYN');
				//var MAILYN = userData.get('MAILYN');
				var BASTATEID = userData.get('BASTATEID');
				Ext.Ajax.request({
					url: CONTEXTPATH + '/bylaw/setting/settingIbanUpdate.do',
					params: {
						BASTATEID: BASTATEID,
						DOCCD1 : DOCCD1,
						DOCCD2 : DOCCD2,
						DOCCD3 : DOCCD3,
						DOCCD4 : DOCCD4,
						//APPLYYN : APPLYYN,
						//SANCTIONYN : SANCTIONYN,
						//APPROVEYN : APPROVEYN,
						//MAILYN : MAILYN,
						job:'settingIbanUpdate'
					},
					success: function(res, opts){
						
					},
					failure: function(res, opts){
						
					}
				});
			}
		}
	});

	svGrid2 = new xg.GridPanel({
		id:'p_grid2',
		renderTo:'grid2',
		store:svResult2,
		autoWidth:true,autoHeight:true,
		cm:new xg.ColumnModel({
			columns:[
				{header:"USER구분", dataIndex:'USERGBN'},
				{header:"원본/PDF", dataIndex:'DOCTYPE'},
				{header:"문서구분", dataIndex:'DOCCD'},
				{header:"출력", dataIndex:'PRINT',
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='PRINT'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
				},
				{header:"저장", dataIndex:'SAVE',
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='SAVE'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
				},
				{header:"보안적용", dataIndex:'SECURITYYN',
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value) {
				        return "<input type='checkbox' id='SECURITYYN'" + (value=='Y' ? "checked='checked'" : "") + " / >";
				    }
				}
			]
		}),
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
        title: '저장/인쇄 SETTING',
        iconCls: 'icon-grid',
		listeners: {
			rowcontextmenu:function(grid, idx, e){
			
			},
			contextmenu:function(e){
				e.preventDefault();
			},
			cellcontextmenu:function(grid, idx, cIdx, e){
				e.preventDefault();
			},
			rowclick: function (grid, idx, e){
				var obj1 = Ext.select('input[id=PRINT]').elements;
				var obj2 = Ext.select('input[id=SAVE]').elements;
				var obj3 = Ext.select('input[id=SECURITYYN]').elements;
				var models = grid.getStore().getRange();
				
				if(obj1[idx].checked){
					models[idx].set("PRINT", "Y");
				}else{
					models[idx].set("PRINT", "N");
				}
				if(obj2[idx].checked){
					models[idx].set("SAVE", "Y");
				}else{
					models[idx].set("SAVE", "N");
				}
				if(obj3[idx].checked){
					models[idx].set("SECURITYYN", "Y");
				}else{
					models[idx].set("SECURITYYN", "N");
				}
				var selModel= grid.getSelectionModel();
				selModel.selectRow(idx);
				var userData = selModel.getSelected();
				var PRINT = userData.get('PRINT');
				var SAVE = userData.get('SAVE');
				var SECURITYYN = userData.get('SECURITYYN');
				var SETTINGID = userData.get('SETTINGID');
				Ext.Ajax.request({
					url: CONTEXTPATH + '/jsp/bylaw/setting/proc/settingProc.jsp',
					params: {
						SETTINGID: SETTINGID,
						PRINT : PRINT,
						SAVE : SAVE,
						SECURITYYN : SECURITYYN,
						job:'settingUpdate'
					},
					success: function(res, opts){
						
					},
					failure: function(res, opts){
						
					}
				});
			}
		}
	});
	
    viewport = new Ext.Viewport({
        layout: 'border',
        items: [
			new Ext.BoxComponent({ // raw
            region: 'north',
            el: 'topMenuHolder',
            height: 75
        }), /*{
            region: 'west', contentEl: 'progState', id: 'p_docNum', title: "설정 목록",
            split: true, width: 240, minSize: 175, maxSize: 400, collapsible: true,
            margins: '0 0 0 0', layout: 'accordion', layoutConfig: { animate: true },
            iconCls: 'byprogress', autoScroll: true
        },*/{
        	region: 'center',
        	id:'center',
        	items:[
                   new Ext.BoxComponent({
                	   regin:"north",
                       id: 'p_roc',
                       layout: 'fit',
                       html: '',
                       height: 40, 
                       autoScroll: true
                   })
                   ,
                   new Ext.BoxComponent({
                	   id: 'p_section',regin:"center", el:'gridHolder'
                   })

                   ]
        },
		new Ext.BoxComponent({
			region:'south',
			el:'botMenuHolder',
			height:10
		})
		]
    });
    
    buttonfunction = function(){
    	Ext.Ajax.request({
    		url: CONTEXTPATH + '/bylaw/setting/getProcessListButton.do',
			params: {
				
			},
			success: function(res, opts){
				Ext.get('p_roc').update(res.responseText);
			},
			failure: function(res, opts){
				
			}
		});
    }
    
	/*Ext.getCmp('p_docNum').getUpdater().update({ 
		url:'progLeft.jsp'
	});*/
	svGrid2.hide();
	dsSchResult.on('beforeload', function(){
		dsSchResult.baseParams = {
			
		}
	});
	dsSchResult.load({
		params:{
			start:0, limit:pageSize
		}
	});
	buttonfunction();
});


function addItem() { 
	  var anagPanel = new Ext.BoxComponent ({
   	   regin:"north",
       layout: 'fit',
       id:'p_roc',
       html: '',
       height: 40, 
       autoScroll: true
   })

	  // the above code removes all existing panel and child items/containers
	  // just remove the whole if block if you don't want to remove any existing child containers
	  if(Ext.getCmp('center').items != undefined){
	     Ext.getCmp('center').items.each(function(item){
	          //  Ext.getCmp('center').remove(item, true);
	        });
	  }    

	  // following code is adding an extra panel
		  if(Ext.get('p_roc')==null){
			 Ext.getCmp('center').add(anagPanel);
		     Ext.getCmp('center').doLayout();     
		     anagPanel.update("<img src='"+CONTEXTPATH+"/images/progress/pro1_07.gif'/>");
		  }
	   }
function getByStateList(stateCd){
	if(stateCd=='step1'){
		addItem();
		//Ext.get('p_roc').show();
		step=stateCd;
		//progressGrid.setTitle('');
		svGrid2.hide();
		buttonfunction();
		progressGrid.show();
		dsSchResult.on('beforeload', function(){
			dsSchResult.baseParams = {
				job:'settingIbanlist'
			}
		});
		dsSchResult.load({
			params:{
				start:0, limit:pageSize
			}
		});
	}else if(stateCd=='step2'){
		if(Ext.get('p_roc')!=null){
			Ext.get('p_roc').remove();
		}
		step=stateCd;
		//progressGrid.setTitle('');
		progressGrid.hide();
		svGrid2.show();
		svResult2.on('beforeload', function(){
			svResult2.baseParams = {
				job:'settinglist'
			}
		});
		svResult2.load({
			params:{
				start:0, limit:pageSize
			}
		});
	}
}
function reStore(key){
	Ext.Ajax.request({
		url: CONTEXTPATH + '/bylaw/setting/getProcessListButton.do',
		params: {
			key: key
		},
		success: function(res, opts){
			Ext.get('p_roc').update(res.responseText);
		},
		failure: function(res, opts){
			
		}
	});
	
	dsSchResult.on('beforeload', function(){
		dsSchResult.baseParams = {
			key:key
		}
	});
	dsSchResult.load({
		params:{
			start:0, limit:pageSize
		}
	});
}		
window.onresize = function(event) { 
	
};