/*!
 * Ext JS Library 3.3.1
 * Copyright(c) 2006-2010 Sencha Inc.
 * licensing@sencha.com
 * http://www.sencha.com/license
 */
var map = new JMap();
var Tree = Ext.tree;
var resultNode;
var TreeTest = function(){
    // shorthand
    
    return {
        init : function(){
        	var loader =new Ext.tree.TreeLoader({
        		dataUrl: CONTEXTPATH + '/bylaw/cdmake/getCdnodes.do',
        		baseParams:{
        			catid : paracatid,
        			startdt : $("#startdt").val()
        		}
        	});
        	
            // yui-ext tree
            var tree = new Tree.TreePanel({
                animate:true, 
                autoScroll:true,
                //loader: new Tree.TreeLoader({dataUrl:'get-nodes.jsp?node='+paracatid}),
                loader : loader,
                enableDD:true,
                containerScroll: true,
                border: false,
                width: 280,
                height: 550,
                dropConfig: {appendOnly:true},
                listeners: {
        			click: function(node, e){
        				
        			},
        			dblclick: function(node, e){
        				var treeNode = tree2.getRootNode();
        				treeNode.appendChild(node);
        				treeNode.expandChildNodes(true);
        			},
        			beforenodedrop: function(e){ 
        				
        			},
        			nodedrop: function(e){
        				var node = e.dropNode;
        				var nodeInfo = node.attributes;
        				var bookid = nodeInfo.bookId2;
        		        var sss = nodeInfo.cls;
        				/*if(sss != 'folder'){
        					map.remove(bookid);
        				}else{
        					var catid = nodeInfo.catId;
        					Ext.Ajax.request({
        					     url:'Json.jsp',
        					     params:{
        							catid:catid
        					     },
        					     success:function(res,opts){
        					      result=Ext.util.JSON.decode(res.responseText);
        					      for(i=0; i<result.length; i++){
        					    	  map.remove(result[i].bookid);
        					      }
        					     },
        					     failure:function(){
        					      alert('DB에러 발생');
        					     }
        					    });
        				}*/
        			},
        			contextmenu: function(node, e){
        				
        			},
        			expandnode:function(node){
        				
        			},
        			collapsenode:function(node){
        				
        			}
        		}
                
            });
            
            // add a tree sorter in folder mode
            new Tree.TreeSorter(tree, { 
                folderSort: true, 
                dir: "desc", 
                sortType: function(node) { 
                    // sort by a custom, typed attribute: 
                    return parseInt(node.ord, 10); 
                } 
            });
            // set the root node
            var root = new Tree.AsyncTreeNode({
                text: '현행기준문서',
                cls: "folder",
                draggable:true, // disable root node dragging
                id:paracatid
            });
            tree.setRootNode(root);
            
            // render the tree
            tree.render('tree');
            
            root.expand(false, /*no anim*/ false);
            
            //-------------------------------------------------------------
            
            // ExtJS tree            
            var tree2 = new Tree.TreePanel({
                animate:true,
                autoScroll:true,
                //rootVisible: false,
                loader: new Ext.tree.TreeLoader({
                    dataUrl: CONTEXTPATH + '/bylaw/cdmake/getCdnodes.do',
                    baseParams: {path:'extjs'} // custom http params
                }),
                containerScroll: true,
                border: false,
                width: 280,
                height: 550,
                enableDD:true,
                dropConfig: {appendOnly:true},
                contextMenu: new Ext.menu.Menu({        
                	items: [{id: 'delete-node', text: '삭제' ,cls:'icon_del'}],        
                		listeners: {            
                			itemclick: function(item) {                
                				switch (item.id) {                    
                					case 'delete-node':                        
                				var n = item.parentMenu.contextNode;
                				if (n.parentNode) {
                					var node = tree2.getSelectionModel().getSelectedNode();
                    				var nodeInfo = node.attributes;
                    				var bookid = nodeInfo.bookId2;
                    				var sss = nodeInfo.cls;
                    				/*if(sss != 'folder'){
                    					map.remove(bookid);
                    				}else{
                    					var catid = nodeInfo.catId;
                    					Ext.Ajax.request({
                    					     url:CONTEXTPATH + '/bylaw/cdmake/getDelJson.do',
                    					     params:{
                    							catid:catid
                    					     },
                    					     success:function(res,opts){
                    					      result=Ext.util.JSON.decode(res.responseText);
                    					      for(i=0; i<result.length; i++){
                    					    	  map.remove(result[i].bookid);
                    					      }
                    					     },
                    					     failure:function(){
                    					      alert('DB에러 발생');
                    					     }
                    					    });
                    				}*/
                					n.remove();                        
                				}                        
                				break;                
                			}            
                		}        
                	}    
                }),
                listeners: {
        			click: function(node, e){
        				
        			},
        			dblclick: function(node, e){
        				var treeNode = tree.getRootNode();
        				treeNode.appendChild(node);
        			},
        			beforenodedrop: function(e){ 
        				
        			},
        			nodedrop: function(e){
        				var node = e.dropNode;
        				var nodeInfo = node.attributes;
        				node.parentNode.expandChildNodes(true);
        				/**
        				var bookid = nodeInfo.bookId2;
        				var sss = nodeInfo.cls;
        				if(sss != 'folder'){
        					map.put(bookid, "bookid");
        				}else{
        					var catid = nodeInfo.catId;
        					Ext.Ajax.request({
        					     url:'Json.jsp',
        					     params:{
        							catid:catid
        					     },
        					     success:function(res,opts){
        					      result=Ext.util.JSON.decode(res.responseText);
        					      for(i=0; i<result.length; i++){
        					    	  map.put(result[i].bookid,"bookid");
        					      }
        					     },
        					     failure:function(){
        					      alert('DB에러 발생');
        					     }
        					    });
        					
        				}
        				**/
        			},contextmenu: function(node, e) {
        				node.select();            
        				var c = node.getOwnerTree().contextMenu;            
        				c.contextNode = node;            
        				c.showAt(e.getXY());        
        			}
        		}
            });
            
            // add a tree sorter in folder mode
            new Tree.TreeSorter(tree2, {folderSort:true});
            
            // add the root node
            var root2 = new Tree.AsyncTreeNode({
                text: '선택된 기준', 
                draggable:false, 
                id:'-1'
            });
            tree2.setRootNode(root2);
            tree2.render('tree2');
            root2.expand(false, /*no anim*/ false);
            resultNode = root2;
        }
    }
}();

Ext.EventManager.onDocumentReady(TreeTest.init, TreeTest, true);

var result='';
function getFiles(node){
	var nodeInfo;
	var bookid;
	var sss;
	if(node.parentNode){
		nodeInfo = node.attributes;
		bookid = nodeInfo.BOOKID+nodeInfo.NOFORMYN;
		sss = nodeInfo.cls;
	    if(sss != 'folder'){
	    	var path = '';
	    	var tmp = node;
	    	var i=0;
	    	while(tmp.parentNode.getDepth() > 0){
	    		if (i==0){
	    			path = tmp.parentNode.text;
	    		}else{
	    			path = tmp.parentNode.text + ';' + path;
	    		}
	    		tmp = tmp.parentNode;
	    		i++;
	    	}
	    	if (result==''){
	    		result = bookid+';'+path;
	    	}else{
	    		result = result + '@@' + (bookid+';'+path); // 10002325N;가나다;123;234@@bookidN;가나다;123;234@@bookidN;가나다;123;234
	    	}
	    }
	}
    var childenode = node.firstChild;

    while (childenode != null){
    	getFiles(childenode);
    	childenode = childenode.nextSibling;
    }	
}

function goSelect(){
	alert();

}
function goWrite(){
	result=''
	var info = resultNode.attributes;	
	getFiles(resultNode);
	if(result==''){	//if(map.keys()==''){
		alert('선택된 규정이 없습니다.');
		return;
	}
	//Main.sBookids = result; //Main.sBookids = map.keys();
	//Main.fileStart();
	Ext.Ajax.request({
	     url:CONTEXTPATH+'/bylaw/cdmake/setAllDown.do',
	     params:{
			pdata : result
	     },
	     success:function(res,opts){
	    	 results=Ext.util.JSON.decode(res.responseText);
	    	 var obj = new HashMap();
	    	 obj.put("exeform","downlaw");
	    	 obj.put("bookid",results.id);
	    	 obj.put("sabun",userid);
	    	 chkSetUp(makeXML(obj));
	     },
	     failure:function(){
	      alert('DB에러 발생');
	     }
	    });
	
	
}
