Ext.QuickTips.init();
var histStore;
var histPanel;
Ext.onReady(function(){
///////////////////////////////////////////
//	연혁 contextMenuan
///////////////////////////////////////////
	var ctxHist = new Ext.menu.Menu({
		id: 'histContextMenu',
		items: [{id:'hdocInfo', text: '문서관리',
					menu:{id:'hsubdocInfo',
					items:[
						{id:'hdocInfoch', cls:'icon_modDocInfo', text:'문서정보수정',handler:docRepair},
						{id:'hdocInfore', cls:'icon_modDoc',text:'수정',handler:docRepaircont},
						{id:'hdocInfocre', cls:'icon_revCont',text:'연속개정',handler:CRevsion},
						{id:'hmakeLink', cls:'icon_link',text:'링크생성',handler:makeLink.createDelegate(this,['DOC'])},
						{id: 'doc_Topcont2', cls:'icon_doc3', text: '개정이유',handler: revReason.createDelegate(this)	}
					]
				}},
				{id: 'doc_addFile', cls: 'icon_hwp', text:'관련첨부문서 관리',
					handler:function(){
					var rowData = histPanel.getSelectionModel().getSelected();
					var Bookid = rowData.get('BOOKID');
					var Revcha = rowData.get('REVCHA');
					var noFormYn = rowData.get('NOFORMYN');
					var lawTitle = rowData.get('TITLE');
					var Pstate =''; 

					var Pstate = 'FILE';

					if(noFormYn=='Y'){
						alert('비정형문서는 지원하지 않습니다.');
					}else{ 
						win = new Ext.Window({
					        title:lawTitle+"관련첨부문서 관리",
				    	    layout:'fit',
				    	    width:200,
				            height:200,
				            closeAction:'hide',
				            iframe:'true',
				            modal:true,
				            plain: true,
				                        buttons: [{
				                text: '닫기',
				                handler: function(){
				                    win.hide();
				                }
				            }]

				        });
						win.render(document.body);
					    win.body.update('<iframe src="'+CONTEXTPATH+"/jsp/bylaw/dllreq/EgcProc.jsp?Bookid="+Bookid+"&Revcha="+Revcha+"&Statecd="+stateCd+'" width="100%" height="100%" marginheight="0" marginwidth="0" frameborder="no"></iframe>');
					    //win.show();
					}
				}},
				{id:'doc_modHDocCont',cls:'icon_modDoc', text: '연혁내용수정',
					handler: function(){
						var rowData = histPanel.getSelectionModel().getSelected();
						var Bookid = rowData.get('BOOKID');
						var Revcha = rowData.get('REVCHA');
						var noFormyn = rowData.get('NOFORMYN');
						var lawTitle = rowData.get('TITLE');
						var Obookid = rowData.get('OBOOKID');
						var stateCd = rowData.get('STATECD');
						var stateid = rowData.get('STATEID');
						var statehistoryid = rowData.get('STATEHISTORYID');
						win = new Ext.Window({
					        title:lawTitle+"연혁내용수정",
				    	    layout:'fit',
				    	    width:200,
				            height:200,
				            closeAction:'hide',
				            iframe:'true',
				            modal:true,
				            plain: true,
				                        buttons: [{
				                text: '닫기',
				                handler: function(){
				                    win.hide();
				                }
				            }]

				        });
						win.render(document.body);
						win.body.update('<iframe src="'+CONTEXTPATH+"/bylaw/adm/EgcProc.do?statehistoryid="+statehistoryid+"&BOOKID="+Bookid+"&Obookid="+Obookid+"&Title="+lawTitle+"&Revcha="+Revcha+"&Statecd="+stateid+"&PSTATE=YURE"+"&pstateCd="+stateCd+'" width="100%" height="100%" marginheight="0" marginwidth="0" frameborder="no"></iframe>');
					    win.show();
					}
				},
				{id: 'hdoc_addFile', cls: 'icon_file', text: '관련첨부문서 관리',
					handler: function(){
						var rowData = histPanel.getSelectionModel().getSelected();
						var catId = rowData.get('CATID');
						var Bookid = rowData.get('BOOKID');
						var noFormYn = rowData.get('NOFORMYN');
						var statehistoryid = rowData.get('STATEHISTORYID');
						win = new Ext.Window({
							title: "제개정문 / 신구조문 파일등록", layout: 'fit', width:790, height:400,
							closeAction: 'hide',iframe:true, modal: true, plain: true,
							buttons: [{
								text: '닫기',
								handler: function(){
									var msg = Ext.get('easttab');
									msg.getUpdater().update({
										url: 'bon.jsp',
										method: 'post',
										params: {
											Bookid: Bookid,
											Pstate: 'flist'
										}
									});
									win.close();
								}
							}]
						});
						win.render(Ext.getBody());
						win.show();
						win.body.update('<iframe src='+CONTEXTPATH+'/jsp/bylaw/existing/fileUpload.jsp?Bookid=' + Bookid + '&noFormYn='+noFormYn+'&statehistoryid='+statehistoryid +' width=100% height=100% frameborder=no></iframe>');
					}
				},
				{id: 'add_history', text:'연혁규정등록',cls:'icon_rev', handler:DocRev.createDelegate(this,['Y'])}
			]
		});

///////////////////////////////////////////
//	연혁 grid 시작
///////////////////////////////////////////
	var xg = Ext.grid;
	histStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			//url:CONTEXTPATH+'/jsp/bylaw/existing/history.jsp'
		}),
		reader:new Ext.data.JsonReader({
			root:'history',
			idProperty:'BOOKID'
			},['BOOKID','OBOOKID','BOOKCODE','REVCHA','REVCD','STATECD','PROMULDT','QTIP','NOFORMYN','CATID','STARTDT','ENDDT','PROMULDT','USEYN','BOOKCD','STATEID','STATEHISTORYID','TITLE']
		)
	});
	
	Ext.ToolTip.prototype.onTargetOver =
    	Ext.ToolTip.prototype.onTargetOver.createInterceptor(function(e) {
    		this.baseTarget = e.getTarget();
    });
    Ext.ToolTip.prototype.onMouseMove =
    	Ext.ToolTip.prototype.onMouseMove.createInterceptor(function(e) {
    		if (!e.within(this.baseTarget)) {
    			this.onTargetOver(e);
    			return false;
    		}
    });
    var histGridView = new Ext.grid.GridView({
        getRowClass : function (row, index) {
            var cls = '';
            var data = row.data;

            if(data.useYn=='N'){
				cls = 'old-row';
			}

            return cls;
        }
    });
	histPanel = new xg.GridPanel({
		renderTo:'westbottom',
		autoHight:true,
		width:'100%',
		store:histStore,
		sm:smHist,
		autoHeight:true,
		sortable:true,
		view:histGridView,
		cm:new xg.ColumnModel({
			columns:[
				{header:"차수", width:40, dataIndex:'REVCHA',sortable: true},
				{header:"작업", width:40, dataIndex:'REVCD',sortable: true},
				{header:"상태", width:40, dataIndex:'STATECD',sortable: true},
				{header:"문서번호", width:60, dataIndex:'BOOKCODE',sortable: true,hidden:true},
				{header:"규정명", dataIndex:'TITLE',sortable: true},
				{header:"개정일", width:80, dataIndex:'PROMULDT',sortable: true}
			]
		}),
		iconCls: 'icon-grid',
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:false
		},
		onRender: function() {
        	Ext.grid.GridPanel.prototype.onRender.apply(this, arguments);
        	this.addEvents("beforetooltipshow");
	        this.tooltip = new Ext.ToolTip({
	        	renderTo: Ext.getBody(),
	        	target: this.view.mainBody,
	        	listeners: {
	        		beforeshow: function(grid) {
	        			var view = this.getView();
			            var row = view.findRowIndex(grid.baseTarget);
						var histData = histStore.getAt(row);
						var histText='제'+histData.get('REVCHA')+'차 '+histData.get('REVCD')+', '+histData.get('TITLE')+'('+histData.get('STATECD')+') , 개정일:'+histData.get('PROMULDT');
			            this.fireEvent("beforetooltipshow", this, histText);
	        		},
	        		scope: this
	        	}
	        });
        },
		listeners:{
			rowcontextmenu:function(grid, idx, e){
				var selModel=grid.getSelectionModel();
				selModel.selectRow(idx);
				var histData = selModel.getSelected();

				var rowData = histPanel.getSelectionModel().getSelected();
				var stateCd = rowData.get('STATECD');
				var revCha = rowData.get('REVCHA');
				var noFormyn = rowData.get('NOFORMYN');
				var useYn = histData.get('USEYN');
				if(useYn=='N'){
					Ext.MessageBox.alert('알림','현재 규정의 연혁은 서비스 되지 않습니다.');
				}else{
					if (Grpcd == 'PADMIN' && stateCd != '입안') {
						//hdocInfoch hdocInfore hdocInfocre hmp hdoc_addFile
						//ctxHist.items.get("doc3Dan").hide();
						var hsMenu = Ext.getCmp("hsubdocInfo");
						if (noFormyn == 'Y') {
							hsMenu.items.get('hdocInfoch').hide();
							hsMenu.items.get('hdocInfore').hide();
							hsMenu.items.get('hdocInfocre').hide();
							ctxHist.items.get('doc_addFile').hide();
							ctxHist.items.get('hdoc_addFile').hide();
							hsMenu.items.get('hmakeLink').hide();
							Ext.getCmp('center').activate('center11');
						}
						else {
							hsMenu.items.get('hdocInfoch').hide();
							hsMenu.items.get('hdocInfore').hide();
							hsMenu.items.get('hdocInfocre').hide();
							hsMenu.items.get('hmp').hide();
							ctxHist.items.get('hdoc_addFile').hide();
							hsMenu.items.get("hmakeLink").show();
							Ext.getCmp('center').activate('center22');
						}
						ctxHist.showAt(e.getXY());
					}else{
						//if(revCha!=0){
						//	ctxHist.items.get("doc3Dan").hide();
						//}else{
						//	ctxHist.items.get("doc3Dan").show();
						//}

						var hsMenu = Ext.getCmp("hsubdocInfo");
						if(noFormyn=='Y'){
							//hsMenu.items.get('hdocInfoch').hide();
							hsMenu.items.get('hdocInfocre').hide();
							hsMenu.items.get('hdocInfore').hide();
							hsMenu.items.get('hmakeLink').hide();
							ctxHist.items.get('doc_addFile').hide();
							ctxHist.items.get('hdoc_addFile').show();
							Ext.getCmp('center').activate('center11');
						}else{
							//hsMenu.items.get('hdocInfoch').hide();
							hsMenu.items.get("hdocInfocre").hide();
							hsMenu.items.get("hdocInfore").hide();
							hsMenu.items.get("hmakeLink").show();
							ctxHist.items.get('doc_addFile').hide();
							ctxHist.items.get('hdoc_addFile').hide();
							Ext.getCmp('center').activate('center22');
						}
						
						var bookcd = rowData.get('bookcd');
						if (Grpcd2=='S'||Grpcd.indexOf('H')>-1){
							if(Grpcd2=='S'){
								ctxHist.showAt(e.getXY());
							}
						}
						
					}
				}

			},
			contextmenu:function(e){
				e.preventDefault();
			},
			//cellcontextmenu : ( Grid this, Number rowIndex, Number cellIndex, Ext.EventObject e )
			cellcontextmenu:function(grid, idx, cIdx, e){
				e.preventDefault();
			},
			//rowclick : ( Grid this, Number rowIndex, Ext.EventObject e )
			rowclick:function(grid, idx, e){
				var selModel= grid.getSelectionModel();
				var histData = selModel.getSelected();
				var useYn = histData.get('useyn');
				if(useYn=='N'){
					Ext.MessageBox.alert('알림','현재 규정의 연혁은 서비스 되지 않습니다.');
				}else{
					getDocInfo(histData.get('BOOKID'),histData.get('NOFORMYN'));//문서정보
				}
			},
			render: function(g){
				g.on("beforetooltipshow", function(grid, histText){
					grid.tooltip.body.update(histText);
				});
			}
		}

	});
	
	var smHist= new xg.RowSelectionModel({
		singleSelect:true
	});
//	new Ext.ToolTip(histPanel);
	//링크생성
	function makeLink(gbn){
		var rowData = histPanel.getSelectionModel().getSelected();
		var bookId = rowData.get('BOOKID');
		var noFormyn = rowData.get('NOFORMYN');
		//링크생성
		Ext.MessageBox.wait('자료를 저장중입니다. ...','Wait',{interval:20, text:'go go go~!'});
		Ext.Ajax.request({
            url: 'EgcProc.jsp', method : 'post',timeout:3000000000,
            params: {Bookid: bookId,  state:  "link1", gbn:gbn},
            success: function(response){
            	  Ext.MessageBox.hide();
            	  getDocInfohistory(bookId,noFormyn);
            },
            failure: function(response){
              var result=response.responseText;
              Ext.MessageBox.alert('error','could not connect to the database. retry later');
			}
		});
	}
	//개정이유및 주요골자
	function revReason(){
		var rowData = histPanel.getSelectionModel().getSelected();
		var bookId = rowData.get('BOOKID');

		Ext.Ajax.request({
		     url:'Json.jsp',
		     params:{
			Bookid:bookId
		     },
		     success:function(res,opts){
		      result=Ext.util.JSON.decode(res.responseText);
		      var rmInsert = new Ext.FormPanel({
			        labelWidth:80, url:'proc.jsp', frame:true, defaultType:'textarea', monitorValid:true,
			        items:[{
			        	fieldLabel:'개정이유', width:275, height:100, name: 'Revreason', allowBlank:false ,value:result[15].Revreason
			            },{
		            	fieldLabel:'주요골자', width:275, height:100, name: 'Mainpith', allowBlank:false,value:result[16].Mainpith
			            }],
			        buttons:[{
			                text:'등록', formBind: true,
			                handler:function(){
			        		rmInsert.getForm().submit({
		                        method:'POST',
		                        params: {
					    			Bookid: bookId, state:'rm'
					              },
		                        waitTitle:'Connecting',
		                        waitMsg:'자료를 저장중입니다....',

		                        success:function(){
			                        Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
							   			if (btn == 'ok'){
					                       // getDocView('south','bon.jsp',bookId,'mp');//개정이유및주요골자
					                        win2.close();
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
					  title: '개정이유및 주요골자 등록', closable:true, width:400, height:300,
					  items: [rmInsert], plain:true
					 })
				win2.show('div');

		     },
		     failure:function(){
		      alert('DB에러 발생');
		     }
		    });
	}
	function hwpcreat(){
		var rowData = histPanel.getSelectionModel().getSelected();
		var Obookid = rowData.get('OBOOKID');
		var Revcha =rowData.get('REVCHA');
		var Bookid = rowData.get('BOOKID');
		var Revcd = rowData.get('REVCD');
		if(Revcd=='제정'||Revcd=='전부개정'||Revcd=='폐지'){
			window.open('createHwp.jsp?Bookid='+Bookid+'&Pstate=NOW','','');
		}else{
			window.open('revHwp.jsp?Obookid='+Obookid+'&Revcha='+Revcha+'&Bookid='+Bookid,'','');
		}
	}
	//문서정보수정
	function docRepair(){
		var rowData = histPanel.getSelectionModel().getSelected();
		var bookId = rowData.get('BOOKID');
		var noFormyn = rowData.get('NOFORMYN');
		var statehistoryid = rowData.get('STATEHISTORYID');
		var Pstate = 'U';
		if(noFormyn=='Y'){
			noFormDocY(Pstate);
		}else{
			Pop('657','500','bylawEnactment.do?statehistoryid='+statehistoryid+'&Bookid=',bookId,Pstate);
		}
	}

	function noFormDocY(pstate){
		var rowData = histPanel.getSelectionModel().getSelected();
		var catId = rowData.get('CATID');
		var Bookid = rowData.get('BOOKID');
		var Pcatid = "";//node.attributes.pCatId;

		var result;
		if(pstate!='I'){
			Ext.Ajax.request({
		     url:'Json.jsp',
		     params:{
			Bookid:Bookid
		     },
		     success:function(res,opts){
		      result=Ext.util.JSON.decode(res.responseText);
		      if(pstate=='U'){
					formCreat(result,pstate,catId,Bookid,Pcatid);
			    }else if(pstate=='RE'){
					formCreat(result,pstate,catId,Bookid,Pcatid);
			    }
		     },
		     failure:function(){
		      alert('DB에러 발생');
		     }
		    });
		}
	}

	//수정
	function docRepaircont(){
		var rowData = histPanel.getSelectionModel().getSelected();
		var Obookid = rowData.get('OBOOKID');
		var Bookid = rowData.get('BOOKID');
		var lawTitle = rowData.get('TITLE');
		var Revcha = rowData.get('REVCHA');
		//location.href=CONTEXTPATH+"/jsp/bylaw/repair/repairLayout.jsp?Bookid="+Bookid+"&Obookid="+Obookid+"&docTitle="+lawTitle+"&Revcha="+Revcha+"&pstateCd="+stateCd;
		win = new Ext.Window({
				        title:lawTitle+" 내용수정",
			    	    layout:'fit',
			    	    width:200,
			            height:200,
			            closeAction:'hide',
			            iframe:'true',
			            modal:true,
			            plain: true,
			                        buttons: [{
			                text: '닫기',
			                handler: function(){
			                    win.hide();
			                }
			            }]

			        });
					win.render(document.body);
				    win.body.update('<iframe src="'+CONTEXTPATH+"/bylaw/adm/EgcProc.do?BOOKID="+Bookid+"&Obookid="+Obookid+"&Title="+lawTitle+"&Revcha="+Revcha+"&PSTATE=YURE"+"&pstateCd="+stateCd+'" width="100%" height="100%" marginheight="0" marginwidth="0" frameborder="no"></iframe>');
				    win.show();
	}
	//연속개정
	function CRevsion(){
		var rowData = histPanel.getSelectionModel().getSelected();
		var Obookid = rowData.get('OBOOKID');
		var Bookid = rowData.get('BOOKID');
		var lawTitle = rowData.get('TITLE');
		var Revcha = rowData.get('REVCHA');
		var noFormyn = rowData.get('NOFORMYN');
		var Startdt = rowData.get('STARTDT');
		var Enddt = rowData.get('ENDDT');
		var Promuldt = rowData.get('PROMULDT');
		if(noFormyn=='Y'){
			alert('비정형문서는 지원하지 않습니다.');
			//noFormDoc(t,Pstate);
		}else{
			//location.href = CONTEXTPATH+"/jsp/bylaw/revision/revisionLayout.jsp?Bookid="+Bookid+"&Obookid="+Obookid+"&docTitle="+lawTitle+"&Revcha="+Revcha+"&Promuldt="+Promuldt+"&Enddt="+Enddt+"&Startdt="+Startdt+"&Pstate=CRE"+"&pstateCd="+stateCd;
			win = new Ext.Window({
				        title:lawTitle+" 연속개정",
			    	    layout:'fit',
			    	    width:200,
			            height:200,
			            closeAction:'hide',
			            iframe:'true',
			            modal:true,
			            plain: true,
			                        buttons: [{
			                text: '닫기',
			                handler: function(){
			                    win.hide();
			                }
			            }]

			        });
					win.render(document.body);
				    win.body.update('<iframe src="'+CONTEXTPATH+"/jsp/bylaw/existing/EgcProc.jsp?Bookid="+Bookid+"&Obookid="+Obookid+"&Title="+lawTitle+"&Revcha="+Revcha+"&pstate=URE"+"&pstateCd="+stateCd+'" width="100%" height="100%" marginheight="0" marginwidth="0" frameborder="no"></iframe>');
				    win.show();
		}
	}
	function DocRev(noFormyntmp){
		var rowData = histPanel.getSelectionModel().getSelected();
		var Obookid = rowData.get('OBOOKID');
		var Bookid = rowData.get('BOOKID');
		var lawTitle = rowData.get('TITLE');
		var noFormYn = rowData.get('NOFORMYN');
		var Revcha = rowData.get('REVCHA');
		var catId = rowData.get('CATID');
		var pstate = 'OLDADD';
		var Pcatid = rowData.get('PCATID');
		var stateCd = '연혁';
	
		var result;
		
		Ext.Ajax.request({
			url : CONTEXTPATH + '/bylaw/adm/getDocInfo.do',
			params : {
				Bookid : Bookid
			},
			success : function(res, opts) {
				result = Ext.util.JSON.decode(res.responseText);
				formCreat(result.data, pstate, catId, Bookid, Pcatid);
			},
			failure : function() {
				alert('DB에러 발생');
			}
		});
	}	
});