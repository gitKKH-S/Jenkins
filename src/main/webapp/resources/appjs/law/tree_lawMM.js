Ext.QuickTips.init();

var dsUrlInfo;
var treeMM;
Ext.onReady(function(){
	var frm_crRootMenu;
	var frm_crMenu;
	var frm_win;
	//트리시작
	var Tree = Ext.tree;
	
	treeMM = new Tree.TreePanel({
		renderTo:'treeHolder',
		useArrows: true,
		autoScroll: true,
		animate : true,
		enableDD: true,
		containerScroll: true,
		border: false,
		
		dataUrl: CONTEXTPATH+'/bylaw/menu/getNodes.do',
		
		root: {
			nodeType: 'async', text:'관심 법령 관리',title:'관심 법령 관리', draggable:false, id: '10000000', cls:'menuRoot',
			listeners:{
				contextmenu:function(node,e){
					node.select();
				}
			}
		},
		listeners: {
			click: function(node, e){
				node.select();
				var nodeKind = node.attributes.cls;
				var title = (node.parentNode).attributes.text;
				//setMenuInfo(node);
				//Ext.getCmp('frmButSubmit').setDisabled(false);
				var lawgbn = 'law';
				if(title.indexOf('법령')>-1){
					lawgbn = 'law';
				}else{
					lawgbn = 'bylaw';
				}
				gridStore2.on('beforeload', function(){
			    	gridStore2.baseParams = {
						datacd:'law2',
						menuid : node.id,
						lawgbn : lawgbn
					};
				});
			    gridStore2.load({
					params:{
						datacd:'law2',
						menuid : node.id
					}
				});
			},
			beforenodedrop : function(e){
				
			},
			// e.point : above - target의 위로 이동 / below - target의 아래로 이동 / append - 다른 폴더로 이동
			nodedrop: function(e){
				
			},
			contextmenu: function(node, e){
				
			},
			expandnode:function(node){
				
			},
			collapsenode:function(node){
			
			}
		}
	});
	
	//treeMM.getRootNode().expand();
	treeMM.expandAll();

});
