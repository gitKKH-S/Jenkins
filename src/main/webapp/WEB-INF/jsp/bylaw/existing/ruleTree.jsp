<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String OBOOKID = request.getParameter("obookid")==null?"":request.getParameter("obookid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
    <script>
    var pageSize = 50;
    Ext.onReady(function(){
    	Ext.QuickTips.init();
    	var folContextMenu = new Ext.menu.Menu({
    		id: 'folderContextMenu',
    		items: [
    				{id:'fol_regDoc',cls:'icon_delFol', text:'삭제',
    				handler:function(){
    					var node = tree.getSelectionModel().getSelectedNode();
    					Ext.Ajax.request({
								url: CONTEXTPATH +'/bylaw/adm/delRuleTree.do',
								params: {
									treeid	:	node.id
								},
								success: function(res, opts){
									var result = Ext.util.JSON.decode(res.responseText);
									if(result.faire){
										alert("하위 노드가 있을경우 삭제가 불가능합니다.");
									}else{
										tree.root.reload();
										tree.expandAll();	
									}
									
								},
								failure: function(){
									alert('DB에러 발생');
									return false;
								}
							});
    				}}
    				]
    	});
    	var Tree = Ext.tree;
    	tree = new Tree.TreePanel({
    		renderTo:'treeHolder', useArrows: false, autoScroll: true, animate: true,
            enableDD: true, containerScroll: true, border: false,
        	
    		loader : new Ext.tree.TreeLoader({
    			dataUrl: CONTEXTPATH+'/bylaw/adm/getRuleTree.do',
    			baseParams:{
    				mdocid : '<%=OBOOKID%>'
    			}
    		}),
            root: {
                nodeType: 'async', text: '규정체계도설정', draggable: false, id: '0',
    			listeners:{
        			click: function(node,e){	
    				
        			},
    				contextmenu:function(node,e){
    					node.select();
    				
    				}
    			}
            },
    		listeners:{
    			click: function (node,e){
    	
    			},
    			beforenodedrop: function(e){ //DD시 노드 드랍전 실행, e.dropNode의 정보는 드랍전 원래의 정보
  
    			},
    			nodedrop: function(e){ //DD시 노드 드랍후 실행, e.dropNode의 정보는 드랍후 현재의 정보
    				var node = e.dropNode;
    				var point = e.point;	//값 : 폴더로 병합: append , 현재위치보다 위로 : above, 현재위치보다 아래로 : below
    				var pNode = node.parentNode;
    				var ord = pNode.indexOf(node);
    				var ptreeid = pNode.id;
    				var treeid = node.id;
    				Ext.Ajax.request({
						url: CONTEXTPATH +'/bylaw/adm/updateRuleTree.do',
						params: {
							ptreeid	:	ptreeid,
							treeid	:	treeid,
							ord : ord
						},
						success: function(res, opts){
							var result = Ext.util.JSON.decode(res.responseText);
							tree.root.reload();
							tree.expandAll();	
						},
						failure: function(){
							alert('DB에러 발생');
							return false;
						}
					});
    			},
    			contextmenu: function(node, e){
    				node.select();
    				folContextMenu.showAt(e.getXY());
    			},
    			expandnode: function(node){
    				
    			},
    			collapsenode: function(node){

    			}
    		}
        });
        tree.getRootNode().expand();
        var gridStore1 = new Ext.data.Store ({
    		id:'p_ds',
    		proxy: new Ext.data.HttpProxy({
    			url: CONTEXTPATH + '/bylaw/adm/LawAllData.do'
    		}),
    		reader: new Ext.data.JsonReader({
    			root: 'result', totalProperty: 'total', idProperty: 'lawsid'
    		}, ['lawsid','lawname','lawgbn', 'promuldt', 'revcd','plawsid'])
    	});
        
        var gridPanel1 = new Ext.grid.GridPanel({
    		id:'p_grid1',
    		renderTo:'grid1',
    		store:gridStore1,
    		width : Ext.getBody().getViewSize().width-407,
    		height : Ext.getBody().getViewSize().height-89,
    		cm:new Ext.grid.ColumnModel({
    			columns:[
    				{header:"법령명",  dataIndex:'lawname',width:350},
    				{header:"제/개정", dataIndex:'revcd',width:100},
    				{header:"공포일", dataIndex:'promuldt',width:100}
    			]
    		}),
    		loadMask:{
    			msg:'로딩중입니다. 잠시만 기다려주세요...'
    		},
    		stripeRows:true,
    		layout: 'fit',
    		tbar:[
    			{xtype: 'radiogroup', fieldLabel: '구분', id:'lawgbn',width:210,
    				 columns: 3, value:['law'],
    				items: [
    			        {boxLabel: '법령', inputValue:'law', name:'lawgbn'}
    			        ,{boxLabel: '행정규칙', inputValue:'bylaw', name:'lawgbn'}
    			        ,{boxLabel: '규정', inputValue:'rule', name:'lawgbn'}
    				],
    				listeners: {
    	                change: function(radiogroup, radio){
    	                	gridStore1.load({
    	                		params:{
    	                			datacd:'law1',
    	                			lawgbn:radio.inputValue,
    	                			schTxt : Ext.getCmp('schText').getValue()
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
      								datacd:'law1',
      								lawgbn:Ext.getCmp('lawgbn').getValue().getGroupValue(),
      								schTxt : schTxt
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
      								datacd:'law1',
      								lawgbn:Ext.getCmp('lawgbn').getValue().getGroupValue(),
      								schTxt : schTxt
      							}
      						});
      					}
      				}
      			})
      		],
    		bbar:{
    			items:[
		    		new Ext.PagingToolbar({
		    			pageSize:pageSize, store: gridStore1,
		    			displayInfo:true, displayMsg:'전체 {2}의 결과중 {0} - {1}',
		    			emptyMsg:"검색된 결과가 없습니다."
		    		}),{xtype: 'tbfill'},
		    		new Ext.Toolbar({
		    			items:[
		    				{
				    	        text: '<b>규정체계 설정</b>',iconCls:'icon_file',
				    	        style: { border: 'solid 1px gray' },
				    	        listeners:{
			      					click:function(btn, eObj){
			      						var node = tree.getSelectionModel().getSelectedNode();
			      						if(!node){
			      							alert("좌측 트리 노드를 선택하시기 바랍니다.");
			      						}else{
			      							var selModel= gridPanel1.getSelectionModel();
			      							var histData = selModel.getSelected();
			      							var ptreeid = node.id;
			      							var title = histData.get('lawname');
			      							var docid = histData.get('lawsid');
			      							var linkgbn = Ext.getCmp('lawgbn').getValue().getGroupValue();
			      							var mdocid = '<%=OBOOKID%>';
			      							
			      							
			      							var docgbn = '';
			      							if(linkgbn == 'law'){
			      								var str = title.substring(title.length-1,title.length);
			      								if(str == '법' || str == '률'){
			      									docgbn = '법률';
			      								}else if(str == '령' || str == '영' || str == '건'){
			      									docgbn = '시행령';
			      								}else if(str == '정' || str == '영' || str == '범' || str == '제' || str == '칙'){
			      									docgbn = '시행규칙';
			      								}
			      							}else if(linkgbn == 'bylaw'){
			      								docgbn = histData.get('lawgbn');
			      							}else if(linkgbn == 'rule'){
			      								docgbn = '규정';
			      							}
			      							Ext.Ajax.request({
			      								url: CONTEXTPATH +'/bylaw/adm/saveRuleTree.do',
			      								params: {
			      									ptreeid	:	ptreeid,
			      									title	:	title,
			      									docid	:	docid,
			      									linkgbn	:	linkgbn,
			      									mdocid	:	mdocid,
			      									docgbn	:	docgbn
			      								},
			      								success: function(res, opts){
			      									tree.root.reload();
			      									tree.expandAll();
			      								},
			      								failure: function(){
			      									alert('DB에러 발생');
			      									return false;
			      								}
			      							});
			      							
			      						}
			      					}
			      				}
				    	    }
		    			]	
		    		})
		    		
    		]},
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
 		        	region: 'west',
 		        	contentEl: 'west',
 		        	title: '규정체계',
                    collapsible: true,
                    split:true,
                    width: 400,
                    minSize: 175,
                    maxSize: 400,
                    layout:'fit',
                    margins:'0 0 0 0',
                    iconCls:'icon_cat',
                    item:[
                    	Tree
                    ]
   		        },
   		        {
 		        	region: 'center',
 		        	items:[
 		        			gridPanel1
 		                   ]
   		        }
    		]
        });
    	
    	gridStore1.on('beforeload', function(){
        	gridStore1.baseParams = {
           		datacd:'law1',
       			lawgbn:Ext.getCmp('lawgbn').getValue().getGroupValue(),
       			schTxt : Ext.getCmp('schText').getValue()
        	};
        });
        gridStore1.load({
       		params:{
       			datacd:'law1',
       			start:0, limit:pageSize
       		}
       	});
    }); 
    </script>
</head>
<body>
<div id="west">
	<div id="treeHolder"></div>
</div>
<div id="grid1"></div>
</body>
</html>