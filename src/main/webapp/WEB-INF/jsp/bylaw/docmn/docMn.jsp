<%@ page language="java"  pageEncoding="UTF-8"%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script>
var gridStore1,treeMM;
Ext.onReady(function(){
	var Tree = Ext.tree;
	
	treeMM = new Tree.TreePanel({
		renderTo:'treeHolder',
		useArrows: true,
		height : Ext.getBody().getViewSize().height-200,
		animate : true,
		enableDD: true,
		containerScroll: true,
		border: false,
		dataUrl: CONTEXTPATH+'/bylaw/docmn/getMenuNode.do',
		
		root: {
			nodeType: 'async', text:'메뉴',title:'메뉴', draggable:false, id: '0', cls:'menuRoot',
			listeners:{
				contextmenu:function(node,e){
					node.select();
				}
			}
		},
		listeners: {
			click: function(node, e){
				node.select();
				gridStore1.on('beforeload', function(){
					gridStore1.baseParams = {
							MENU_MNG_NO : node.id
					};
				});
				gridStore1.load({
					params:{
						MENU_MNG_NO : node.id
					}
				});
				
			}
		}
	});
	
	//treeMM.getRootNode().expand();
	treeMM.expandAll();
	
	gridStore1 = new Ext.data.Store ({
		id:'p_ds',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/docmn/getMenuDocList.do'
		}),
		remoteSort:true,
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'FILE_MNG_NO'
		}, ['FILE_MNG_NO','MENU_MNG_NO','DOC_NM', 'DOC_EXPLN_CN', 'PHYS_FILE_NM','SRVR_FILE_NM'])
	});
	
	var smProgGrid1 = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false,
		listeners:{
			selectionchange:function(){
			},
			rowselect:function(sModel, rIndex, data){
				var treeNode = treeMM.getSelectionModel().getSelectedNode();
				if(treeNode==null){
					alert("트리에서 메뉴를 먼저 선택하시기 바랍니다.");
					return;
				}else{
					var records = gridPanel1.selModel.getSelections();
					
				}
			}
		}
	});
	var gridPanel1 = new Ext.grid.GridPanel({
		id:'p_grid1',
		renderTo:'grid1',
		store:gridStore1,
		width : Ext.getBody().getViewSize().width-245,
		height : Ext.getBody().getViewSize().height,
		cm:new Ext.grid.ColumnModel({
			columns:[
				smProgGrid1,
				{header:"양식명",  dataIndex:'DOC_NM',width:110},
				{header:"양식 설명", dataIndex:'DOC_EXPLN_CN',width:200},
				{header:"다운로드", sortable: true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value,cell,record,rowindex,columnindex,store) {
				    	var selModel=gridPanel1.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var ret = "";
						var PHYS_FILE_NM = rowData.get('PHYS_FILE_NM');
						var SRVR_FILE_NM = rowData.get('SRVR_FILE_NM');
						if(SRVR_FILE_NM != ''){
							ret = ret + "<span style='padding-top:3px;color:blue;cursor:pointer;' onclick=\"attachfileDownload('"+SRVR_FILE_NM+"','"+PHYS_FILE_NM+"');\" id='mcontent'>Download</span>";
						}else{
							ret;
						}
				        return ret;
				    }
				},
				{header:"편집", sortable: true,
					editor: {
				        xtype: 'checkbox',
				        inputValue: 'Y'
				    },
				    renderer: function(value,cell,record,rowindex,columnindex,store) {
				    	var selModel=gridPanel1.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var ret = "";
						var PHYS_FILE_NM = rowData.get('PHYS_FILE_NM');
						var SRVR_FILE_NM = rowData.get('SRVR_FILE_NM');
						if(SRVR_FILE_NM != ''){
							ret = ret + "<span style='padding-top:3px;color:blue;cursor:pointer;' onclick=\"edit('"+SRVR_FILE_NM+"','"+PHYS_FILE_NM+"');\" id='mcontent'>양식편집</span>";
						}else{
							ret;
						}
				        return ret;
				    }
				},
				{header:"파일명", dataIndex:'PHYS_FILE_NM'}
			]
		}),
		tbar:['->',
  			new Ext.Button ({
  				id:'butSch', text:'<b>양식등록</b>',iconCls:'byprogress',
  				listeners:{
  					click:function(btn, eObj){
  						insertPop();
  					}
  				}
  			}),
  			new Ext.Button ({
  				id:'butSch2', text:'<b>삭제</b>',iconCls:'byprogress',
  				listeners:{
  					click:function(btn, eObj){
  						var rowData = gridPanel1.getSelectionModel().getSelected();
  						var FILE_MNG_NO = rowData.get('FILE_MNG_NO');
  						Ext.Ajax.request({
  							url: CONTEXTPATH + '/bylaw/docmn/deleteDoctype.do',
  							params: {
  								FILE_MNG_NO: FILE_MNG_NO
  							},
  							success: function(res, opts){
  								gridStore1.reload();
  							},
  							failure: function(res, opts){
  								Ext.MessageBox.alert('데이터삭제 실패','서버와의 연결상태가 좋지 않습니다. 에러코드:' + response.status);
  							}
  						})
  					}
  				}
  			})
  		],
		sm:smProgGrid1,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		layout: 'fit',
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
	
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [
        	{
                region: 'west', contentEl: 'menuList', id: 'p_docNum', title: "문서 양식 관리",
                split: true, width: 240, minSize: 175, maxSize: 400, collapsible: true,
                margins: '0 0 0 0', layout: 'accordion', layoutConfig: { animate: true },
                iconCls: 'byprogress', autoScroll: true
            },new Ext.BoxComponent({
    			id:'c_section',region: 'center', el: 'gridHolder',
    			width:900
            })
		]
    });
});
Ext.EventManager.onWindowResize(function(w, h){
	
});
function insertPop(){
	var treeNode = treeMM.getSelectionModel().getSelectedNode();
	if(treeNode==null){
		alert("트리에서 메뉴를 먼저 선택하시기 바랍니다.");
		return;
	}
	var MENU_MNG_NO = treeNode.id;
	var rmInsert = new Ext.FormPanel({
	    labelWidth:80,
	    url : CONTEXTPATH + '/bylaw/docmn/insertDoctype.do',
	    enctype:'multipart/form-data',
	    frame:true,
	    width:385,
	    autoHeight:true,
	    defaultType:'textfield',
		monitorValid:true,
		fileUpload:true,
		items: {
			xtype: 'fieldset',
			title: '파일등록',
			items:[
				{
					type: 'hidden', id: 'FILE_MNG_NO', name: 'FILE_MNG_NO', allowBlank:false,width:230
				},
		        {
		    		xtype: 'textfield', fieldLabel:'양식명', id: 'DOC_NM', name: 'DOC_NM', allowBlank:false,width:248
		    	},
		    	{
		       		enctype:'multipart/form-data', allowBlank:false,
		            inputType :'file', id: 'docfilename', name :'docfilename', fieldLabel :'파일첨부',
		            blankText :'Please choose a file',
		            anchor :'95%', required :true, autoShow :true,
		            xtype :'textfield'
		    	},
		    	{
		    		xtype: 'textarea', fieldLabel:'문서설명', id: 'DOC_EXPLN_CN', name: 'DOC_EXPLN_CN',width:248
		    	}
	        ]
		},
		buttons:[
				new Ext.Button ({
					text: '등록',
					id: 'btn1',
					formBind: true,
					width:70,
					iconCls:'icon_save',
					handler:function(){
						rmInsert.getForm().submit({
							method:'POST',
							params: {
				    			MENU_MNG_NO : MENU_MNG_NO
				            },
							enctype:'multipart/form-data',
							fileUpload: true,
							waitTitle:'Connecting',
							waitMsg:'자료를 등록중입니다....',
				            success: function(form, action){
				            	/* var result = Ext.util.JSON.decode(action.response.responseText);
								var sfName = result.sfName;
								var obj = new HashMap();
							 	obj.put("write","2");
							 	obj.put("file",URLINFO + "/dataFile/doctype/" + sfName);
							 	obj.put("gianurl",URLINFO + "/dll/SaveDoc.do");
							 	obj.put("saveurl",URLINFO + "/dll/SaveDoc.do");
							 	obj.put("AutoReport","");
								chkSetUp(makeDocXML(obj)); */
								
								Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
				  					if (btn == 'ok'){
										win.close();
										gridStore1.reload();
				  					}
					        	});
							},
						});
					}
				})
		]
	});
	
	var win = new Ext.Window({
		title: '양식 등록',
		  closable:true,
		  width:400,
		  autoHeight:true,
		  items: [rmInsert],
		  plain:true, modal:true,iconCls:'icon_rev'
		 })
	win.show('div');
}
function attachfileDownload(SRVR_FILE_NM,PHYS_FILE_NM){
	form=document.ViewForm;
	form.PHYS_FILE_NM.value=PHYS_FILE_NM;
	form.SRVR_FILE_NM.value=SRVR_FILE_NM;
	form.folder.value='DOCTYPE';
	form.action="${pageContext.request.contextPath}/Download.do";
	form.submit();
}
function edit(SRVR_FILE_NM,PHYS_FILE_NM){
	var obj = new HashMap();
 	obj.put("write","2");
 	obj.put("file",URLINFO + "/dataFile/doctype/" + SRVR_FILE_NM);
 	obj.put("gianurl",URLINFO + "/dll/SaveDoc.do");
 	obj.put("saveurl",URLINFO + "/dll/SaveDoc.do");
 	obj.put("AutoReport","");
	chkSetUp(makeDocXML(obj));
	
}
</script>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<div id="menuList">
	<div id="treeHolder"></div>
</div>
<div id="gridHolder">
	<div id="grid1"></div>
</div>
