var updateList;
var gridUpdate;
var pageno = 1;
var pageSize = 15;
var updateid;
var jogrid1;
var jogrid2;
var jostore1;
var jostore2;
var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
Ext.onReady(function(){
	Ext.QuickTips.init();
//TODO//////////////////////////////////	
	//버튼너비, 세퍼레이터 추가
	//PADMIN 파트 담당자  LTEAM 법무팀
	
/////////////문서정보
	var frm_docInfo = new Ext.FormPanel({
		labelWidth:90,frame:true,/* width:420, autoHeight:true,*/
		height:443,
		items: {
			xtype: 'fieldset', title: '문서정보',iconCls:'icon_docInfo',
			items: [
				{xtype:'textfield',width:150, fieldLabel: '규정명', name:'title', id:'frm_docInfo_title',readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '규정번호', name:'bookcode', id:'frm_docInfo_bookcode', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '규정구분', name:'bookcd', id:'frm_docInfo_bookcd', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '심의회차', name:'booksubcd', id:'frm_docInfo_booksubcd', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '제개정구분', name:'revcd', id:'frm_docInfo_revcd', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '개정차수', name:'revcha', id:'frm_docInfo_revcha', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '개정일', name:'promuldt', id:'frm_docInfo_promuldt', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '시행일', name:'startdt', id:'frm_docInfo_startdt', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '부서명', name:'deptname', id:'frm_docInfo_deptname', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '담당자', name:'username', id:'frm_docInfo_username', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '관련부서', name:'deptcd', id:'frm_docInfo_deptcd', readOnly:true,style:{marginBottom:'1px'}},
				{xtype:'textfield',width:150, fieldLabel: '관련직무', name:'jikmu', id:'frm_docInfo_jikmu', readOnly:true,style:{marginBottom:'1px'}}
			]
		}		
	});
	var rmInsertMM = new Ext.FormPanel({
        labelWidth:60,width:395, url:'proc.jsp', frame:true, defaultType:'textarea', monitorValid:true, autoHeight:true,
        items:[{
        	fieldLabel:'제·개정이유', width:295, height:209, name: 'revreason',id:'frm_docInfo_revreason',  readOnly:true//,value:result[15].Revreason
            },{
        	fieldLabel:'주요 제·개정 내용', width:295, height:209, name: 'mainpith',id:'frm_docInfo_mainpith',  readOnly:true//,value:result[16].Mainpith
        }]
    });
	////////////updatelog grid
	
    var xg = Ext.grid;		//shortCut
    var win2;
    
	updateList = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH+'/bylaw/adm/getDocInfoView.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'updateid'
		}, ['updateid', 'bookid','updatecha','updatereason','updateupdt','writer','writerid'])
	});
	
	gridUpdate = new xg.GridPanel({
		store:updateList,
		cm:new xg.ColumnModel({
			columns:[
				//new Ext.grid.RowNumberer(),		//줄번호 먹이기
				{header:"수정차수", width:60,dataIndex:'updatecha'},
				{header:"수정날짜", width:100, dataIndex:'updateupdt',format : 'Y-m-d'},
				{header:"작성자", width:80, dataIndex:'writer'}
			]
		}),
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		bbar:new Ext.PagingToolbar({
			pageSize:pageSize, 
			store: updateList,
			displayInfo:true, 
			displayMsg:'전체 {2} 결과 {0} - {1}',
			emptyMsg:"검색결과가 없습니다."
		}),
		viewConfig:{
			forceFit:true
		},
		width:330,height:374,
        iconCls: 'icon-grid',
		listeners:{
			rowclick:function(grid, idx, e){
				var selModel= grid.getSelectionModel();
				var histData = selModel.getSelected();
				var updateReason = new Ext.FormPanel({
			        labelWidth:60,width:385,autoHeight:true,
			        frame:true,
			        defaultType:'textarea',
			        monitorValid:true,
			        items:
			        	[
			        	{xtype: 'textfield', fieldLabel:'수정차수', name: 'updatecha', allowBlank:true,readOnly:true,value:histData.get('updatecha')},
			            {fieldLabel:'수정이유', width:295, height:238, name: 'updatereason', readOnly:true,value:histData.get('updatereason').replace(/<br>/gi,'\n')}
			        	],
			        buttons:[{
			        	text:'닫기', formBind: true,
						handler:function(){
			        		win2.close();
						}
					}]
			    });
				var win2 = new Ext.Window({
					title: '내용수정 정보', closable:true, width:400, height:350,
					items: [updateReason], plain:true, modal:true
				})
				win2.show();
				
			}
		}
	});
	
	var frm_updateInfo = new Ext.FormPanel({
		labelWidth:90, width:400, autoHeight:true, frame:true,monitorValid:true,
		items: {
			xtype: 'fieldset', title: '수정정보',iconCls:'icon_modDoc',
			items: [
			        gridUpdate
			]
		}		
	});
	
	var frm_progInfo = new Ext.Panel({
		id:'frm_progInfo',
		border:false,
		renderTo: Ext.getBody()
	});

	var frm_progInfo1 = new Ext.FormPanel({
		labelWidth:90, width:340, autoHeight:true, frame:true,monitorValid:true,
		items: {
			xtype: 'fieldset', title: '입안프로세스정보',iconCls:'byprogress',
			items: [
			        frm_progInfo
			]
		}
	});
	
	jostore1 = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH+'/bylaw/adm/getDocInfoView.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'link1', idProperty: 'BOOKID'
		}, ['BOOKID','TITLE','PROMULDT','BOOKCODE','BOOKCD','REVCHA','NOFORMYN'])
	});
	
	jostore2 = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH+'/bylaw/adm/getDocInfoView.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'link2', idProperty: 'BOOKID'
		}, ['BOOKID','TITLE','PROMULDT','BOOKCODE','BOOKCD','REVCHA','NOFORMYN'])
	});
	jogrid1 = new Ext.grid.GridPanel({
		title:'참조규정리스트',autoHeight:true,
		iconCls:'icon-grid',
		store:jostore1,
		cm:new xg.ColumnModel({
			columns:[
				{header:"문서구분",dataIndex:'BOOKCD'},
				{header:"문서번호",dataIndex:'BOOKCODE',hidden:true},
				{header:"규정명", dataIndex:'TITLE'},
				{header:"개정일", dataIndex:'PROMULDT',format : 'Y-m-d'},
				{header:"차수",  dataIndex:'REVCHA'}
			]
		}),
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		viewConfig:{
			forceFit:true
		},
		listeners:{
			rowclick:function(grid, idx, e){
				var selModel= grid.getSelectionModel();
				var histData = selModel.getSelected();
				var jsonData = histData.json;
				window.open("/web/regulation/regulationViewPop.do?bookid="+jsonData.BOOKID+"&noformyn="+jsonData.NOFORMYN,"");
			}
		}
	});
	
	jogrid2 = new xg.GridPanel({
		title:'인용규정리스트',autoHeight:true,
		iconCls:'icon-grid',
		store:jostore2,
		cm:new xg.ColumnModel({
			columns:[
				{header:"문서구분",dataIndex:'BOOKCD'},
				{header:"문서번호",dataIndex:'BOOKCODE',hidden:true},
				{header:"규정명", dataIndex:'TITLE'},
				{header:"개정일", dataIndex:'PROMULDT',format : 'Y-m-d'},
				{header:"차수",  dataIndex:'REVCHA'}
			]
		}),
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		viewConfig:{
			forceFit:true
		},
		listeners:{
			rowclick:function(grid, idx, e){
				var selModel= grid.getSelectionModel();
				var histData = selModel.getSelected();
				//window.open(CONTEXTPATH + "/jsp/bylaw/regulation/popup/bylawPop.jsp?Bookid="+histData.get('bookid'),"");
				var jsonData = histData.json;
				window.open("/web/regulation/regulationViewPop.do?bookid="+jsonData.BOOKID+"&noformyn="+jsonData.NOFORMYN,"");
			}
		}
	});
	
	
	//메뉴 클릭시 호출되는 함수들
    function test(){
    	var curNode = tree.getActiveNode();
    	alert(curNode.catId);
    }
	

	function makeLink(){
		var bookId = '';
		//링크생성
		Ext.Ajax.request({  
            url: 'proc.jsp', method : 'post',
            params: {Bookid: bookId,  state:  "link1", gbn:'TOTALDOC'}
		});
	}
	var center = new Ext.TabPanel({
		id:'center',
		region:'center',
		deferredRender:false,
		activeTab:0,
		enableTabScroll:true,
		items:[this.FirstPanel = new Ext.Panel( {
		    contentEl:'center2',
		    id:'center2',autoScroll:true,
		    title: '현행/연혁'
		}),this.SecondPanel  = new Ext.Panel( {
		    contentEl:'center1',
		    id:'center1',autoScroll:true,
		    title: '신구조문대비표'
		}),this.ThirdPanel  = new Ext.Panel( {
		    contentEl:'center3',
		    id:'center3',autoScroll:true,
		    title: '과거조문동시보기'
		})]
	})

	var viewport = new Ext.Viewport({
    	    id:'viewport',
            layout:'border',
            items:[
                new Ext.BoxComponent({ // raw
                    region:'north',
                    el: 'topMenuHolder',
                    height:75
                }),
				{
                    region:'south',
                    contentEl: 'south',
                    split:true,
                    height: 100,
                    minSize: 100,
                    maxSize: 200,
                    collapsible: true,
                    autoScroll:true,
                    title:'규정관리시스템 사용팁',
                    margins:'0 0 0 0',
                    iconCls:'icon_tip',
                    html: '<div style="padding:5px 20px;">'
                    		+'<div>&#8226;&nbsp; 제정신청 : 해당 카테고리 폴더에서 우클릭후  제정신청 선택.</div>'
                    		+'<div>&#8226;&nbsp; 개정/폐지 신청 : 해당  규정목록에서 우클릭후  개정신청이나 폐지신청 선택.</div>'
                    		+'</div>'	
                },
                 {
                    region:'east',
                    id:'east-panel',
                    title: '책갈피 및 첨부파일',
                    collapsible: true,
                    split:true,
                    width: 225,
                    minSize: 175,
                    maxSize: 400,
                    layout:'fit',
                    margins:'0 5 0 0',
                    iconCls:'icon_bookmark',
                    items:
                        new Ext.TabPanel({
                            border:false,
                            activeTab:0,
                            deferredRender:false,
                            tabPosition:'bottom',
                            id:'hkk',
                            autoScroll:true,
                            items:[{
                            	contentEl: 'east',
                            	id:'east1',
								padding: '3 2 2 3',
                                //html:'<p>A TabPanel component can be a region.</p>',
                                title: '조문목차',
                                autoScroll:true,
                                iconCls:'icon_contentTable'
                            },
                            {
								
                            	contentEl: 'easttab',
                            	id : 'easttab1',
                                //html:'<p>A TabPanel component can be a region.</p>',
                                title: '첨부파일 목록',
                                autoScroll:true,
                                iconCls:'icon_attachFile'
                            	
                            }]
                        })
                 },{
                    region:'west',
                    id:'west-panel',
                    title:'문서관리메뉴',
                    split:true,
                    width: 350,
                    minSize: 200,
                    maxSize: 400,
                    collapsible: true,
                    margins:'0 0 0 5',
                    layout:'accordion',
                    iconCls:'bylaw',
                    layoutConfig:{
                        animate:true
                    },
                    items: [{
                        contentEl: 'west',
                        title:'카테고리 관리',
                        border:false,
                        iconCls:'icon_cat',
                        autoScroll:true
                    },{
                    	contentEl: 'westbottom',
                        title:'문서연혁관리',
                       // html:'<p>Some settings in here.</p>',
                        border:false,
                        iconCls:'icon_docHist',
                        autoScroll:true
                    },{
						id:'schRes',
                    	contentEl: 'westSearch',
                        title:'규정 검색',
                        border:false,
                        iconCls:'byprogress',
                        //html:'제목 <input type="text" name="schTxt"/><span onClick="goSch(schTxt.value)" style="cursor:hand">검색</span>',
                        autoScroll:true
                    }]
                },new Ext.TabPanel({
            	    id:'center',
                    region:'center',
                    deferredRender:false,
                    border:true,
                    activeTab:0,
                    margins:'0 0 0 0',
                    autoScroll:true,
                    items:[this.FirstPanel0 = new Ext.Panel( {
                        contentEl:'center0',
                        id:'center00',
                        items:[
                               new Ext.Panel({ id:'main-panel',
                            	   baseCls:'x-plain',
                                   renderTo: Ext.getBody(),
                                   layout:'table',
                                   layoutConfig: {columns:2,align:'top'},
                                   align:'top',
                                   defaults: {frame:false},
                                    items:[{
                                    	padding:'4px',
                                    	border : false,
                                        items:[frm_docInfo]
	                                    ,width:340
                                    },{
                                    	padding:'4px',
                                   	    items:[rmInsertMM],
                                   	    border : false
                                    },{
                                    	padding:'4px',
                                    	width:340,
                                    	cellCls:'verticalAlignTop',
                                        items:[frm_progInfo1],
                                        border:false
                                    },{
                                    	padding:'4px',
                                    	cellCls:'verticalAlignTop',
                                        items:[frm_updateInfo],
                                        border:false
                                    }
                                    
                                    ]
                                })
                               ],
                        autoScroll:true,
                        title: '문서정보',
                        iconCls:'icon_docInfo'
                    }),this.FirstPanel = new Ext.Panel( {
                        contentEl:'center2',
                        id:'center22',
                        autoScroll:true,
                        title: '현행/연혁',
                      	iconCls:'icon_hyunhang'
                    }),this.SecondPanel  = new Ext.Panel( {
                        contentEl:'center1',
                        id:'center11',
                        autoScroll:true,
                        title: '신구조문대비표',
                        iconCls:'icon_singu'
                    }),this.ThirdPanel  = new Ext.Panel( {
                        contentEl:'center3',
                        id:'center33',
                        autoScroll:true,
                        title: '과거조문동시보기',
                        iconCls:'icon_pastjomun'
                    }),this.fourthPanel  = new Ext.Panel( {
                        contentEl:'center4',
                        id:'center44',
                        autoScroll:true,
                        title: '관련첨부문서',
                        iconCls:'icon_refdoc'
                    }),this.fivePanel  = new Ext.Panel( {
                        contentEl:'center5',
                        id:'center55',
                        autoScroll:true,
                        title: '참조/인용 규정 리스트',
                        iconCls:'icon_linkedit',
                        items:[jogrid1,jogrid2]
                    })]
                })
                
             ]
        });
   
	 // activate - 탭이 활성화 될때 일어나는(fire)되는 이벤트
	    this.FirstPanel0.on('activate', function(panel) {
	    	acaction();
	    }, this);
	    this.FirstPanel.on('activate', function(panel) {
	    	acaction();
	    }, this);
	    this.SecondPanel.on('activate', function(panel) {
	    	acaction();
	    }, this);
	    this.ThirdPanel.on('activate', function(panel) {
	    	acaction();
	    }, this);
	    this.fourthPanel.on('activate', function(panel) {
	    	acaction();
	    }, this);
	    this.fivePanel.on('activate', function(panel) {
	    	acaction();
	    }, this);
	    
	    function acaction(){
	    	var ac_item = Ext.getCmp('west-panel').layout.activeItem;
	    	var ac_index = Ext.getCmp('west-panel').items.indexOf(ac_item);
	    	if(ac_index==0){
	    		var node = tree.getSelectionModel().getSelectedNode();
	    	}else if(ac_index==1){
	    		//var node = tree.getSelectionModel().getSelectedNode();
	    	}else if(ac_index==2){
	    		var node = tree.getSelectionModel().getSelectedNode();
	    	}
	    	
	    }
	    /*
	    // deactivate - 탭이 비활성화될때 일어나는 이벤트
	    this.SecondPanel.on('deactivate', function(panel) { 
	     alert(panel.title + '이 비활성화 되었습니다.' + panel.getId());
	    }, this);
	
	    // beforedestory - 탭이 닫히기전에 일어나는 이벤트
	    this.ThirdPanel.on('beforedestroy', function(panel) { 
	     alert(panel.title + '이 닫혔습니다.');
	    }, this);

*/

       /****
        Ext.get("hideit").on('click', function() {
           var w = Ext.getCmp('west-panel');
           w.collapsed ? w.expand() : w.collapse(); 
        });
       *******/
    });
    function deleteDB2(){
    	  Ext.MessageBox.alert('success','성공');
    	  Ext.get("center2").getUpdater().update({
              url: 'bon.jsp',
              method : 'post',
              params: { 
                  task: "DELETING", 
                  ids:  "as"
                 }, 
              scripts: true
           });
}
    function Pop(width,height,url,Id,pstate){
		var poptit;
		var h=0;
		var icon_class;
		if (pstate=='I'){
			poptit='제정';
			h=555;
		}else if (pstate=='U'){
			poptit='문서정보 수정';
			icon_class = 'icon_modDocInfo';
			h=655;
		}else if (pstate=='RE'){
			poptit='개정';
			h=555;
		}else if (pstate=='CRE'){
			poptit='연속개정';
			h=655;
		}else if (pstate=='P'){
			poptit='폐지';
			h=555;
		}
			win = new Ext.Window({
	        title:"규정"+poptit,
    	    layout:'fit',
    	    width:400,
            height:h,
            closeAction:'hide',
            iframe:'true',
            modal:true,
            plain: true,
            iconCls:icon_class,
            buttons: [{
                text: '닫기',
                handler: function(){
                    win.hide();
                }
            }]

        });
		win.render(document.body);
	    win.body.update('<iframe src="'+url+Id+'&pstate='+pstate+'" width="100%" height="100%" marginheight="0" marginwidth="0" frameborder="no"></iframe>');
	    win.show();
	}
    
	//문서정보 가져오기
	function getDocInfo(bookId,noFormyn){
		var node = tree.getSelectionModel().getSelectedNode();
		if(!noFormyn){
			noFormyn = node.attributes.noFormYn;
		}
		var key;
		if(bookId){
			key=bookId;
		}else{
			key=node.attributes.bookId;
		}
		var statehistoryid = '';
		if(node){
			statehistoryid = node.attributes.statehistoryid;
		}
		var rowData = histPanel.getSelectionModel().getSelected();
		if(rowData){
			statehistoryid = rowData.get('STATEHISTORYID');
		}
		var rowData2 = schPanel.getSelectionModel().getSelected();
		if(rowData2){
			statehistoryid = rowData2.get('STATEHISTORYID');
		}
		if(noFormyn=='Y'){
			bonValue='noxml';
		}else{
			bonValue='xml';
		}
		getDocInfoView(key,noFormyn,statehistoryid);
	}
	
	function getDocInfoView(key,noform,statehistoryid){//문서정보 FormPanel데이터
		Ext.Ajax.request({
		     url:CONTEXTPATH+'/bylaw/adm/getDocInfoView.do',
		     params:{
		    	 bookid:key,
		    	 statehistoryid:statehistoryid,
		    	 noform:noform,
		    	 start:0,
				 limit:pageSize
		     },
		     success:function(res,opts){
				result=res.responseText;
				var obj = Ext.util.JSON.decode(result);
				Ext.getCmp('frm_docInfo_title').setValue(obj.data.dinfo.Title=='null'?'':obj.data.dinfo.Title);
				Ext.getCmp('frm_docInfo_bookcode').setValue(obj.data.dinfo.Bookcode=='null'?'':obj.data.dinfo.Bookcode);
				Ext.getCmp('frm_docInfo_bookcd').setValue(obj.data.dinfo.Bookcd=='null'?'':obj.data.dinfo.Bookcd);
				Ext.getCmp('frm_docInfo_booksubcd').setValue(obj.data.dinfo.Booksubcd=='null'?'':obj.data.dinfo.Booksubcd);
				Ext.getCmp('frm_docInfo_revcd').setValue(obj.data.dinfo.Revcd=='null'?'':obj.data.dinfo.Revcd);
				Ext.getCmp('frm_docInfo_revcha').setValue(obj.data.dinfo.Revcha=='null'?'':obj.data.dinfo.Revcha);
				Ext.getCmp('frm_docInfo_promuldt').setValue(obj.data.dinfo.Promuldt=='null'?'':obj.data.dinfo.Promuldt);
				Ext.getCmp('frm_docInfo_startdt').setValue(obj.data.dinfo.Startdt=='null'?'':obj.data.dinfo.Startdt);
				Ext.getCmp('frm_docInfo_deptname').setValue(obj.data.dinfo.Deptname=='null'?'':obj.data.dinfo.Deptname);
				Ext.getCmp('frm_docInfo_username').setValue(obj.data.dinfo.Username=='null'?'':obj.data.dinfo.Username);
				Ext.getCmp('frm_docInfo_deptcd').setValue(obj.data.dinfo.Deptcd=='null'?'':obj.data.dinfo.Deptcd);
				Ext.getCmp('frm_docInfo_revreason').setValue(obj.data.dinfo.revreason=='null'?'':obj.data.dinfo.revreason);
				Ext.getCmp('frm_docInfo_mainpith').setValue(obj.data.dinfo.mainpith=='null'?'':obj.data.dinfo.mainpith);
				
				//수정정보
			    var uinfo = obj.data.uinfo;
			    updateList.loadData(uinfo);
			    
			    //입안프로세스정보
			    var msg = Ext.get('frm_progInfo');
				msg.update(obj.data.pinfo);
			    
				var link1 = obj.data;
				jostore1.loadData(link1);
			    
			    var link2 = obj.data;
			    jostore2.loadData(link2);
				
			    myMask.show();
			
			    if(noform=='N'){	//정형문서 본문
			    	Ext.Ajax.request({
					     url:CONTEXTPATH+'/bylaw/adm/getDocBon.do',
					     params:{
					    	 Bookid : key,
					    	 type : 'main'
					     },
					     success:function(res,opts){
							result=res.responseText;
							var obj = Ext.util.JSON.decode(result);
							var view = Ext.getCmp('center22');
							view.update(obj.data.bon);
							
							Ext.get('east1').update(obj.data.jolist);
							
							Ext.get('center11').update(obj.data.oldnew);
							
							Ext.get('center33').update(obj.data.together);
							
							Ext.get('easttab1').update(obj.data.flist);
							
							histStore.loadData(obj.data);
							
							Ext.getCmp('center').activate('center22');
							myMask.hide();
							
					     },
					     failure:function(){
							alert('실패');
							myMask.hide();
					     }
					});
			    }else {	//비정형문서 본문
			    	$.ajax({
	                    url : CONTEXTPATH+'/bylaw/adm/noFormView.do',
	                    dataType : "json",
	                    type : "post",  // post 또는 get
	                    data : { BOOKID : key},   // 호출할 url 에 있는 페이지로 넘길 파라메터
	                    success : function(result){
	                    	
	                    	//Ext.get('center22').update(result);
	                        //$("#innerbody").html();
	                        
	                        //var view = Ext.getCmp('center22');
							//Ext.get('center2').update('<iframe src="'+CONTEXTPATH+'/bylaw/adm/gohwp.do" width="100%" height="100%" frameborder="no"></iframe>');
							
							/*var msg = Ext.get("center22");
							msg.getUpdater().update({
								url: CONTEXTPATH+'/bylaw/adm/gohwp.do',
					            method : 'post',
					            scripts:true,
					            params: {
					    			
					              }
					    	});*/
	                    	Ext.get('easttab1').update(result.data.flist);
							histStore.loadData(result.data);
							var fname = result.fileName;
							if(!fname){
								alert("파일정보가 없습니다.");
								myMask.hide();
							}else{
								if(fname.toUpperCase().indexOf("HWP")>-1 || fname.toUpperCase().indexOf("DOC")>-1){
									$.ajax({
			    	                    url : CONTEXTPATH+'/bylaw/adm/goHwp.do',
			    	                    dataType : "html",
			    	                    type : "post",  // post 또는 get
			    	                    data : { fileName : fname},   // 호출할 url 에 있는 페이지로 넘길 파라메터
			    	                    success : function(result){
			    							var view = Ext.getCmp('center22');
			    							view.update('<div id="innerbody"></div>');
			    							$("#innerbody").html(result);
			    							$("#HwpCtrl").css("height",$("#innerbody").parent().css("height"))
			    	                    }
			    	                });
								}else if(fname.toUpperCase().indexOf("PDF")>-1){
									var view = Ext.getCmp('center22');
	    							view.update('<div id="innerbody"></div>');
	    							$("#innerbody").css("height",$("#innerbody").parent().css("height"))
	    							var options = {
										    height : $("#innerbody").parent().css("height"),
											page : '2',
											pdfOpenParams : {
												view : 'FitV',
												pagemode : 'thumbs'
											}
										};
	    							PDFObject.embed( CONTEXTPATH+"/dataFile/law/attach/"+fname, "#innerbody");
								}else{
									var view = Ext.getCmp('center22');
	    							view.update('<div id="innerbody">미리보기를 지원하지 않는 파일 형식 입니다.</div>');
								}
							}
							
	                    	
							Ext.get('east1').update('비정형문서에는 지원되지 않습니다!!');
							Ext.get('center11').update('비정형문서에는 지원되지 않습니다!!');
							Ext.get('center33').update('비정형문서에는 지원되지 않습니다!!');
							myMask.hide();
	                    }
	                });
			    }
			    Ext.get('center44').update('<iframe src='+CONTEXTPATH+'/bylaw/adm/fileUpload.do?Bookid=' + key + '&noFormYn='+noform + '&statehistoryid='+statehistoryid+' width=100% height=100% frameborder=no></iframe>');
				var hpx = $("#center44").parent().css("height").replace('px','');
				hpx = hpx -20;
			    $("#center44").css("height",hpx+'px');
				
				
				// var jsonData = Ext.encode(Ext.pluck(obj.data, 'pinfo'));

				
				//getlinkInfo(key);
			    
			    
			    
			    
			    
			    /*			    
			    var proxy = new Ext.data.MemoryProxy(myData);
alert(proxy);
			    updateList = new Ext.data.GroupingStore({               
			        proxy: proxy
			    });

			    updateList.load();*/
			    //updateList.setProxy({type: "memory", enablePaging: true, data:myData});

			    //updateList.load();
			    
			    /*updateList = new Ext.data.Store({
					proxy: new Ext.data.MemoryProxy(myData), 
					reader: new Ext.data.JsonReader({
						root: 'result', totalProperty: 'total', idProperty: 'updateid'
					}, ['updateid', 'bookid','updatecha','updatereason','updateupdt','writer','writerid'])
				});
			    
			    updateList.on('beforeload',function(){
					updateList.baseParams={
						bookid: key,
						job: 'updateLog',
						start:0,
						limit:pageSize
					}
				});
			    updateList.load();//Data(myData);
*/				
				
				
		     },
		     failure:function(){
				alert('실패');
		     }
		});
	}
  
	function viewProg(key,statecd){//입안프로세스 정보에서 본문내용 보여주기
		var state = statecd;
		var win_docInfo = new Ext.Window({
			title:'입안프로세스관리',
			height:600,  width:916, iconCls:'docView',
			resizable:true,
			items:[
				new Ext.TabPanel({
				id: 'tab_view1', deferredRender: false, activeTab: 0,
		        margins: '0 5 0 0',
		        renderTo: Ext.getBody(),
		        monitorResize:true,
		        height:525,
		        defaults: {autoScroll:true,autoWidth: true},
		        items: [{id: 't_view1', title: state,autoScroll:true,autoWidth:true,iconCls:'icon_hyunhang'},
		                {id: 't_view2', title: '신구조문대비표',iconCls:'icon_singu'}]
				})
			],
			plain: true, buttons: [
				{ text: '닫기', handler: function(){ win_docInfo.hide(); }
			}]
		});
		bonValue='xml';
		//getAttachFileView(key,'tab_view1');//fileView
		
		var view = Ext.getCmp('t_view1');
		
		
		myMask.show();
		
		Ext.Ajax.request({
		     url:CONTEXTPATH+'/bylaw/adm/getDocBon.do',
		     params:{
		    	 statehistoryid:key,
		    	 type : 'sub'
		     },
		     success:function(res,opts){
				result=res.responseText;
				var obj = Ext.util.JSON.decode(result);
				var view = Ext.getCmp('t_view1');
				view.update(obj.data.bon);
				
				view = Ext.getCmp('t_view2');
				view.update(obj.data.oldnew);
				
				var fInfo = obj.data.finfo;
				for(var i=0; i<fInfo.length; i++) {
				    var fileid = fInfo[i].FILEID;
				    var pcfilename = fInfo[i].PCFILENAME;
				    var serverfile = fInfo[i].SERVERFILE;
				    var filetype = fInfo[i].FILETYPE;
				    var filecd = fInfo[i].FILECD;
				    var statehistoryid = fInfo[i].STATEHISTORYID;
				    var pdffile = fInfo[i].PDFFILE;
				    var convertyn = fInfo[i].CONVERTYN;
				    Ext.getCmp('tab_view1').add(
						new Ext.Panel ({
					       layout: 'fit',
					       id:'progTab_'+i,
					       title:filecd,
					       html: ''
					   })
					); 
				  	Ext.getCmp('tab_view1').doLayout();
				    Ext.get('progTab_'+i).update('<iframe src="'+CONTEXTPATH+'/bylaw/adm/gohwp.do?fileUrl='+serverfile+'" width="100%" height="490" frameborder="no"></iframe>');
				    
				}  
				Ext.getCmp('tab_view1').activate('t_view1');
				
				myMask.hide();
				
		     },
		     failure:function(){
				alert('실패');
		     }
		});
		win_docInfo.show();
	}
	
	function fileView(fileName){
		if(fileName.toUpperCase().indexOf("HWP")>-1 || fileName.toUpperCase().indexOf("DOC")>-1){
			$.ajax({
	            url : CONTEXTPATH+'/bylaw/adm/goHwp.do',
	            dataType : "html",
	            type : "post",  // post 또는 get
	            data : { fileName : fileName},   // 호출할 url 에 있는 페이지로 넘길 파라메터
	            success : function(result){
					var view = Ext.getCmp('center22');
					view.update('<div id="innerbody"></div>');
					$("#innerbody").html(result);
					$("#HwpCtrl").css("height",$("#innerbody").parent().css("height"))
	            }
	        });
		}else if(fileName.toUpperCase().indexOf("PDF")>-1){
			var view = Ext.getCmp('center22');
			view.update('<div id="innerbody"></div>');
			$("#innerbody").css("height",$("#innerbody").parent().css("height"))
			var options = {
				    height : $("#innerbody").parent().css("height"),
					page : '2',
					pdfOpenParams : {
						view : 'FitV',
						pagemode : 'thumbs'
					}
				};
			PDFObject.embed(CONTEXTPATH+"/dataFile/law/attach/"+fileName, "#innerbody");
		}else{
			var view = Ext.getCmp('center22');
			view.update('<div id="innerbody">미리보기를 지원하지 않는 파일 형식 입니다.</div>');
		}
	}
	
	function memoView(contid,bookid){
		Ext.Ajax.request({
		     url:CONTEXTPATH + '/bylaw/adm/getMemo.do',
		     params:{
		    	 bookid:bookid,
		    	 contid:contid,
		    	 gbn:'J'
		     },
		     success:function(res,opts){
		      result=Ext.util.JSON.decode(res.responseText);
		      var rmInsert = new Ext.FormPanel({
			        labelWidth:60,width:385, url:CONTEXTPATH + '/bylaw/adm/setMemo.do', frame:true, defaultType:'textarea', monitorValid:true, autoHeight:true,
			        items:[{
			        	fieldLabel:'메모작성', width:295, height:220, name: 'cont', allowBlank:false ,value:result.CONT
			        }],
			        buttons:[{
			                text:'등록', formBind: true,
			                handler:function(){
			        		rmInsert.getForm().submit({
		                        method:'POST',
		                        params: {
		                        	bookid: bookid,
		                        	contid: contid,
		                        	gbn:'J',
		                        	memoid:result.MEMOID
					              },
		                        waitTitle:'Connecting',
		                        waitMsg:'자료를 저장중입니다....',

		                        success:function(){
			                        Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
							   			if (btn == 'ok'){
					                        win2.close();
					                        getDocInfo(bookid,'N');
			                        	}
						        	});
		                        },
		                        failure:function(form, action){
		                            if(action.failureType == 'server'){
		                                obj = Ext.util.JSON.decode(action.response.responseText);
		                                Ext.Msg.alert('Login Failed!', obj.errors.reason);
		                            }else{
		                                Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText);
		                            }
		                            rmInsert.getForm().reset();
		                        }
		                    });
						}
			    	}]
			    });
				var win2 = new Ext.Window({
					  title: '메모 등록', closable:true, width:400, height:300,
					  items: [rmInsert], plain:true, modal:true
					 })
				win2.show('div');

		     },
		     failure:function(){
		      alert('DB에러 발생');
		     }
		});
	}
	
	function move1(state_cd,asd,Deptname_key){
		form=document.revi;
		if(form.sel.value==''){
			Ext.MessageBox.alert('알림','현재 규정의 연혁은 서비스 되지 않습니다.');
			form.sel.options[0].selected = true;
			return;
		}else{
			var bookid = form.sel.value.substring(0,form.sel.value.length-1);
			var noform=form.sel.value.substring(form.sel.value.length-1,form.sel.value.length);
			if(noform=='Y'){
				bonValue='noxml';
			}else{
				bonValue='xml';
			}
			getDocInfo(bookid,noform);
		}
	}