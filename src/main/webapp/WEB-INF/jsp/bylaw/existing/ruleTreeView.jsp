<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String obookid = request.getParameter("obookid")==null?"":request.getParameter("obookid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
    <script>
    var pageSize = 50;
    Ext.onReady(function(){
    	Ext.QuickTips.init();
    	var Tree = Ext.tree;
    	tree = new Tree.TreePanel({
    		renderTo:'treeHolder', useArrows: false, autoScroll: true, animate: true,
            enableDD: false, containerScroll: true, border: false,
        	width:600,height:300,
    		loader : new Ext.tree.TreeLoader({
    			dataUrl: CONTEXTPATH+'/bylaw/adm/getRuleTree.do',
    			baseParams:{
    				mdocid : '<%=obookid%>'
    			}
    		}),
            root: {
                nodeType: 'async', text: '규정체계도', draggable: false, id: '0',
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
    				var docid = node.attributes.docid;	
    				var docgbn = node.attributes.docgbn;
    				var linkgbn = node.attributes.linkgbn;
    				var mdocid = node.attributes.mdocid;
    				
    				var url = "" ;
    				
    				var cw = 1500; //1000
    				var ch = 800;  //668
    				var sw = screen.availWidth;
    				var sh = screen.availHeight;
    				var px = (sw-cw)/2;
    				var py = (sh-ch)/2;
    				var property = "left=" + px + ", top=" + py + ", width=" + cw + ", height=" + ch + ", scrollbar=no, resizable=no, status=no, toolbar=no";
    				
    				if(linkgbn =='law'){
    					url = "<%= CONTEXTPATH %>/web/law/lawViewPagePop.do?LAWID="+docid+"&gbn=law";
    				}else if(linkgbn =='bylaw'){
    					url = "<%= CONTEXTPATH %>/web/law/bylawViewPagePop.do?BYLAWID="+docid+"&gbn=bylaw";
    				}else if(linkgbn =='rule'){
    					url = "<%= CONTEXTPATH %>/web/regulation/regulationViewPop.do?OBOOKID="+docid ;
    				}
    				window.open(url, docid, property);
    			},
    			beforenodedrop: function(e){ //DD시 노드 드랍전 실행, e.dropNode의 정보는 드랍전 원래의 정보
    				
    			},
    			nodedrop: function(e){ //DD시 노드 드랍후 실행, e.dropNode의 정보는 드랍후 현재의 정보
    			},
    			contextmenu: function(node, e){
    			},
    			expandnode: function(node){
    				
    			},
    			collapsenode: function(node){

    			}
    		}
        });
        //tree.getRootNode().expand();
        tree.expandAll();
        
        
    	var viewport = new Ext.Viewport({
    		layout: 'border',
            items: [
            	{
 		        	region: 'west',
 		        	contentEl: 'west',
 		        	title: '규정체계',
                    width: 600,
                    minSize: 600,
                    maxSize: 600,
                    layout:'fit',
                    margins:'0 0 0 0',
                    iconCls:'icon_cat',
                    item:[
                    	Tree
                    ]
   		        }
    		]
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