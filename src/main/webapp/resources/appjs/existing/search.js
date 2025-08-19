Ext.QuickTips.init();
var schStore;
var schPanel;
Ext.onReady(function(){
///////////////////////////////////////////
//	연혁 contextMenu
///////////////////////////////////////////
	var ctxSch = new Ext.menu.Menu({
		id: 'schContextMenu',
		items: [{id:'schDocInfo', text: '문서관리',
					menu:{id:'subschDocInfo',
					items:[
						{id:'schDocInfoch',cls:'icon_modDocInfo',text:'문서정보수정',handler:docRepair},
						{id:'schDocInfore',cls:'icon_modDoc',text:'수정',handler:docRepaircont},
			        	{id:'schDoc_revDoc',cls:'icon_rev', text: '개정',
							handler: function(){
								var rowData = schPanel.getSelectionModel().getSelected();
								var Obookid = rowData.get('OBOOKID');
								var Bookid = rowData.get('BOOKID');
								var lawTitle = rowData.get('TITLE');
								var noFormyn = rowData.get('NOFORMYN');
								var Revcha = rowData.get('REVCHA');
								var catId = rowData.get('CATID');
								var Pcatid = rowData.get('PCATID');
								var Pstate = 'RE';
								var fStateCd = rowData.get('FSTATECD');
								if(fStateCd=='입안'||fStateCd=='심의조정'){
									alert('지금 '+lawTitle+'는(은) '+fStateCd +'중인 문서입니다.');
									return;
								}
								if(noFormyn=='Y'){
									noFormDoc(Pstate);
								}else{
									Pop('657','500','bylawEnactment.jsp?Pcatid='+Pcatid+'&Obookid='+Obookid+'&Bookid=',Bookid,Pstate);
								}

							}},
						{id:'schDocInfocre',text:'연속개정', cls:'icon_revCont', handler:CRevsion},
						{id:'schDelCancel', text: '삭제/개정취소',
							menu:{
							items:[
								{text:'삭제',cls:'icon_del', handler:deleteCansel.createDelegate(this,['DEL'])},
								{text:'개정취소(연혁을 현행으로 변환)', cls:'icon_canRev', handler:deleteCansel.createDelegate(this,['SEL'])}
							]
						}},
						{id:'schDocMakhwp',text:'한글문서 만들기',cls:'icon_hwp', handler: function(){
							var rowData = schPanel.getSelectionModel().getSelected();
							var Bookid = rowData.get('bookid');
							window.open('createHwp.jsp?Bookid='+Bookid,'','');
						}},
						{id:'schDocMakehwp2',text:'신구조문대조표 한글문서 만들기', cls:'icon_hwp',
							handler: function(){
							var rowData = schPanel.getSelectionModel().getSelected();
							var Bookid = rowData.get('bookid');
							var Revcd = rowData.get('revcd');
							if(Revcd=='제정'||Revcd=='전부개정'||Revcd=='폐지'){
								alert('제정,전부개정일때는 문서를 생성할수 없습니다.');
							}else{
								window.open('createHwpON.jsp?Bookid='+Bookid+'&Pstate=OLDNOW','','');
							}
						}},
						{id:'schDoc_crtDoc', cls:'icon_hwp', text: '개정문 생성', handler: hwpcreat},
						{id:'schMp',text:'개정이유 및 주요골자',cls:'icon_revRes',handler:revReason},
						{id:'schMakeLink',text:'링크생성',cls:'icon_link', handler:makeLink.createDelegate(this,['DOC'])},
			        	{id:'schDoc_disUse',cls:'icon_abol', text: '폐지',
							handler: function(){
								var rowData = schPanel.getSelectionModel().getSelected();
								var Bookid = rowData.get('BOOKID');
								var lawTitle = rowData.get('TITLE');
								var Pcatid = rowData.get('PCATID');
								var Ord = rowData.get('ORD');
								var noFormYn = rowData.get('NOFORMYN');
								var fStateCd = rowData.get('FSTATECD');
								if(!(fStateCd=='현행'||fStateCd=='폐지')){
									alert('지금 '+lawTitle+'는(은) '+fStateCd +'중인 문서입니다.');
									return;
								}
								var rmInsert = new Ext.FormPanel({
							        labelWidth:80, url:'proc.jsp', frame:true, defaultType:'textarea', monitorValid:true,
							        items:[{
							        	xtype: 'datefield', fieldLabel:'폐지일', name: 'Promuldt', allowBlank:false, format : 'Y-m-d'
							            },{
							            xtype: 'textfield', fieldLabel:'타법', name: 'Otherlaw', allowBlank:true
							            },{
								        fieldLabel:'개정이유', width:275, height:100, name: 'Revreason', allowBlank:false
							            },{
							            fieldLabel:'주요골자', width:275, height:100, name: 'Mainpith', allowBlank:false
							            }],
							        buttons:[{
							        	text:'등록', formBind: true,
										handler:function(){
							        		rmInsert.getForm().submit({
							                	method:'POST',
							                    params: {
									    			Bookid: Bookid, Pcatid: Pcatid, Ord:Ord, Title:lawTitle, state:'Closeing',noFormYn:noFormYn
										        	},
							                        waitTitle:'Connecting', waitMsg:'자료를 저장중입니다....',

						                        success:function(form, action){
							                    	Ext.Msg.alert('Status', '폐지을 성공했습니다!!', function(btn, text){
												   		if (btn == 'ok'){
												   			obj = Ext.util.JSON.decode(action.response.responseText);
									                        Bookid = obj.key.Bookid;
									                        location.href=CONTEXTPATH+"/jsp/bylaw/existing/mainLayout2.jsp?Statecd=폐지&Bookid="+Bookid+"&noFormYn="+noFormYn;
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
									title: lawTitle+'폐지', closable:true, width:400, height:350,
									items: [rmInsert], plain:true, modal:true
								})
								win2.show('div');
							}},
				        	{id:'schDoc_cancelDiduse',cls:'icon_canAbol', text: '폐지취소',handler: deleteCansel.createDelegate(this,['CLOSESEL'])	}
					]
				}},
				{id: 'schDoc_addFile', cls: 'icon_file', text: '제개정문/신구조문 파일등록',
					handler: function(){
						var rowData = schPanel.getSelectionModel().getSelected();
						var catId = rowData.get('CATID');
						var Bookid = rowData.get('BOOKID');
						win = new Ext.Window({
							title: "제개정문 / 신구조문 파일등록", layout: 'fit', width: 700, height: 350,
							closeAction: 'hide', iframe: 'true', modal: true, plain: true,
							buttons: [{
								text: '닫기',
								handler: function(){ win.hide(); }
							}]
						});
						win.render(document.body);
						win.body.update('<iframe src='+CONTEXTPATH+'/jsp/bylaw/existing/fileUpload.jsp?Bookid=' + Bookid + ' width=100% height=100% frameborder=no></iframe>');
						win.show();
					}
				}
			]
		});


///////////////////////////////////////////
//	연혁 grid 시작
///////////////////////////////////////////
var xg = Ext.grid;
	schStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/adm/schList.do'
		}),
		reader:new Ext.data.JsonReader({
			root:'data.slist',
			idproperty:'BOOKID'
			},['BOOKID','OBOOKID','REVCHA','REVCD','STATECD','PROMULDT','QTIP','NOFORMYN','CATID','STARTDT','ENDDT','PROMULDT','','PCATID','PATH','FSTATECD','STATEHISTORYID','TITLE']
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
	schPanel = new xg.GridPanel({
		renderTo:'westSearch',
		autoHight:true,
		width:400,
		store:schStore,
		sm:smHist,
		autoHeight:true,
		sortable:true,
		cm:new xg.ColumnModel({
			columns:[
			    {header:"규정명", width:155, dataIndex:'TITLE',sortable: true},
			    {header:"경로", width:120, dataIndex:'PATH',sortable: true},
				{header:"제개정", width:45, dataIndex:'REVCD',sortable: true},
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
						var histData = schStore.getAt(row);
						var histText='제'+histData.get('REVCHA')+'차 '+histData.get('REVCD')+', '+histData.get('TITLE')+'('+histData.get('STATECD')+') , 개정일:'+histData.get('PROMULDT');
			            this.fireEvent("beforetooltipshow", this, histText);
	        		},
	        		scope: this
	        	}
	        });
        },
		listeners:{
		//rowcontextmenu : ( Grid this, Number rowIndex, Ext.EventObject e )
			rowcontextmenu:function(grid, idx, e){
				var selModel=grid.getSelectionModel();
				selModel.selectRow(idx);
				var histData = selModel.getSelected();
				var noFormyn = histData.get('NOFORMYN');
				var sMenu = Ext.getCmp("subschDocInfo");
				if (Grpcd == 'LTEAM') {
					if(stateCd=='현행'){
						sMenu.items.get("schDoc_revDoc").show();
						sMenu.items.get("schDoc_disUse").show();
						sMenu.items.get('schDoc_cancelDiduse').hide();
					}else if(stateCd=='폐지'){
						sMenu.items.get('schDoc_revDoc').hide();
						sMenu.items.get('schDoc_disUse').hide();
						sMenu.items.get("schDoc_cancelDiduse").show();
					}


					if(noFormyn=='Y'){
						sMenu.items.get('schDocMakhwp').hide();
						sMenu.items.get('schDocInfocre').hide();
						sMenu.items.get('schDocInfore').hide();
						sMenu.items.get('schMakeLink').hide();
						sMenu.items.get('schDocMakehwp2').hide();
						Ext.getCmp('center').activate('center11');
					}else{
						sMenu.items.get("schDocMakhwp").show();
						sMenu.items.get("schDocInfocre").show();
						sMenu.items.get("schDocInfore").show();
						sMenu.items.get("schMakeLink").show();
						sMenu.items.get("schDocMakehwp2").show();
						Ext.getCmp('center').activate('center22');
					}
					ctxSch.showAt(e.getXY());
				}else if(Grpcd == 'PADMIN'){
				// schDocInfoch schDocInfore schDoc_revDoc schDocInfocre schDelCancel schMp schDoc_addFile
					if(stateCd=='현행'){
						sMenu.items.get("schDocInfoch").hide();
						sMenu.items.get("schDocInfore").hide();
						sMenu.items.get("schDoc_revDoc").hide();
						sMenu.items.get("schDocInfocre").hide();
						sMenu.items.get("schDelCancel").hide();
						sMenu.items.get("schMp").hide();
						ctxSch.items.get("schDoc_addFile").hide();
						sMenu.items.get('schDoc_cancelDiduse').hide();
					}else if(stateCd=='폐지'){
						sMenu.items.get("schDocInfoch").hide();
						sMenu.items.get("schDocInfore").hide();
						sMenu.items.get("schDoc_revDoc").hide();
						sMenu.items.get("schDocInfocre").hide();
						sMenu.items.get("schDelCancel").hide();
						sMenu.items.get("schMp").hide();
						ctxSch.items.get("schDoc_addFile").hide();
						sMenu.items.get('schDoc_disUse').hide();
						sMenu.items.get("schDoc_cancelDiduse").hide();
					}

					if(noFormyn=='Y'){
						sMenu.items.get("schDocInfoch").hide();
						sMenu.items.get("schDocInfore").hide();
						sMenu.items.get("schDoc_revDoc").hide();
						sMenu.items.get("schDocInfocre").hide();
						sMenu.items.get("schDelCancel").hide();
						sMenu.items.get("schMp").hide();
						ctxSch.items.get("schDoc_addFile").hide();
						sMenu.items.get('schDocMakhwp').hide();
						sMenu.items.get('schMakeLink').hide();
						sMenu.items.get('schDocMakehwp2').hide();
						Ext.getCmp('center').activate('center11');
					}else{
						sMenu.items.get("schDocInfoch").hide();
						sMenu.items.get("schDocInfore").hide();
						sMenu.items.get("schDoc_revDoc").hide();
						sMenu.items.get("schDocInfocre").hide();
						sMenu.items.get("schDelCancel").hide();
						sMenu.items.get("schMp").hide();
						ctxSch.items.get("schDoc_addFile").hide();
						sMenu.items.get("schDocMakhwp").show();
						sMenu.items.get("schMakeLink").show();
						sMenu.items.get("schDocMakehwp2").show();
						Ext.getCmp('center').activate('center22');
					}
					ctxSch.showAt(e.getXY());
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
				getDocInfo(histData.get('BOOKID'),histData.get('NOFORMYN'));
				getDocInfoView(histData.get('BOOKID'),histData.get('NOFORMYN'),histData.get('STATEHISTORYID'));//문서정보
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
//	new Ext.ToolTip(schPanel);
	//링크생성
	function makeLink(gbn){
		var rowData = schPanel.getSelectionModel().getSelected();
		var bookId = rowData.get('BOOKID');
		var noFormyn = rowData.get('NOFORMYN');
		//링크생성
		Ext.MessageBox.wait('자료를 저장중입니다. ...','Wait',{interval:20, text:'go go go~!'});
		Ext.Ajax.request({
            url: 'EgcProc.jsp', method : 'post',timeout:3000000000,
            params: {Bookid: bookId,  state:  "link1", gbn:gbn},
            success: function(response){
            	  Ext.MessageBox.hide();
            	  getDocInfo(bookId,noFormyn);
            },
            failure: function(response){
              var result=response.responseText;
              Ext.MessageBox.alert('error','could not connect to the database. retry later');
			}
		});
	}
	//개정이유및 주요골자
	function revReason(){
		var rowData = schPanel.getSelectionModel().getSelected();
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
					                     //   getDocView('south','bon.jsp',bookId,'mp');//개정이유및주요골자
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
	//문서정보수정
	function docRepair(){
		var rowData = schPanel.getSelectionModel().getSelected();
		var bookId = rowData.get('BOOKID');
		var noFormyn = rowData.get('NOFORMYN');
		var Pstate = 'U';
		if(noFormyn=='Y'){
			noFormDoc(Pstate);
		}else{
			Pop('657','500','bylawEnactment.jsp?Bookid=',bookId,Pstate);
		}
	}
	function noFormDoc(pstate){
		var rowData = schPanel.getSelectionModel().getSelected();
		var catId = rowData.get('catid');
		var Bookid = rowData.get('bookid');
		var Pcatid = rowData.get('pcatid');

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
		}else{
			formCreat(result,pstate,catId,Bookid,'');
		}
	}
	function formCreat(result,pstate,catId,Bookid,Pcatid){
		var Bookcode,Title,Bookcd,Revcd,Revcha,Promulno,Promuldt,Startdt,Enddt,Statecd,Ord,Otherlaw,Deptname,Legislator,Obookid;
		var formTitle = '비정형문서 등록';
		var Docid = catId;
		if(pstate!='I'){
	      Title = result[1].Title;
	      Revcd = result[3].Revcd;
	      Revcha = result[4].Revcha;
	      Promuldt = result[6].Promuldt;
	      Startdt = result[7].Startdt;
	      Enddt = result[8].Enddt;
	      Statecd = result[9].Statecd;
	      Otherlaw = result[11].Otherlaw;
	      Obookid = result[14].Obookid;
	      Docid = Pcatid;
	      if(pstate=='U'){
	      	formTitle = Title+'문서정보 수정';
	      }else if(pstate=='RE'){
	    	  formTitle = Title+'개정';
	    	  Revcha = Number(result[4].Revcha)+1;
	    	  Promuldt = '<%=MakeHan.get_data()%>';
		      Startdt = '<%=MakeHan.get_data()%>';
		      Enddt = '<%=MakeHan.get_data()%>';

	      }
		}
		var rmInsert = new Ext.FormPanel({
	        labelWidth:80,
	        url:'bylawProc.jsp',
	        enctype:'multipart/form-data',
	        frame:true,
	        width:385,
	        autoHeight:true,
	        defaultType:'textfield',
	    	monitorValid:true,
	    	fileUpload:true,
	    	items: {
	    		xtype:'fieldset',
	    		title:formTitle,
	        items:[{
            	xtype: 'textfield', fieldLabel:'규정명', name: 'Title', value:Title, allowBlank:false
            	},{
                xtype:'combo'
                    ,fieldLabel:'제개정구분'
                    ,name:'Revcd'
                    ,store:new Ext.data.SimpleStore({
                        id:0 ,fields:['file', 'locale']  ,data:[
                           ['제정', '제정'] ,['개정', '개정'] ,['전부개정', '전부개정'] ,['폐지', '폐지']
                       ]
                    })
                   ,mode:'local'  ,editable:false ,forceSelection:true ,valueField:'file'
                   ,displayField:'locale' ,triggerAction:'all' ,selectOnFocus:true ,value:Revcd
	            },{
		        xtype: 'textfield', fieldLabel:'개정차수', name: 'Revcha', allowBlank:false, value:Revcha
           		},{
	        	xtype: 'datefield', fieldLabel:'개정일', name: 'Promuldt', allowBlank:false, format : 'Y-m-d', value:Promuldt
	            },{
	        	xtype: 'datefield', fieldLabel:'시행일', name: 'Startdt', allowBlank:false, format : 'Y-m-d', value:Startdt
	            },{
	        	xtype: 'datefield', fieldLabel:'종료일', name: 'Enddt', allowBlank:false, format : 'Y-m-d', value:Enddt
	            },{
                xtype:'combo' ,fieldLabel:'현행/연혁' ,name:'Statecd' ,
                store:new Ext.data.SimpleStore({
	                id:0 ,fields:['file', 'locale']
	               ,data:[
	                   ['현행', '현행'] ,['연혁', '연혁']
	               ]
	            })
	           ,mode:'local' ,editable:false ,forceSelection:true ,valueField:'file'
	           ,displayField:'locale' ,triggerAction:'all' ,selectOnFocus:true ,value:Statecd
	            },{
            	xtype: 'textfield', fieldLabel:'타법', name: 'Otherlaw', allowBlank:false, value:Otherlaw
            	},{
           		enctype:'multipart/form-data', allowBlank :true,
                id :'file', inputType :'file', name :'bylawFile', fieldLabel :'제정문',
                blankText :'Please choose a file',
                anchor :'95%', required :true, autoShow :true,
                //readOnly:true,
                xtype :'textfield'
            	}
	            ]
		},
	        buttons:[{
	                text:'등록',
	                formBind: true,
	                handler:function(){
	        		rmInsert.getForm().submit({
	                        method:'POST',
	                        enctype:'multipart/form-data',
	                        fileUpload: true,
	                        params: {
	        					Bookid:Bookid,
	        					Pcatid: Docid,
	        					pstate:pstate,
	        					Obookid:Obookid,
				    			state:'noForm',
				    			Noformyn:'Y'
				              },
	                        waitTitle:'Connecting',
	                        waitMsg:'자료를 저장중입니다....',

	                        success:function(form, action){

	                        	Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
					   if (btn == 'ok'){
			                        obj = Ext.util.JSON.decode(action.response.responseText);
			                        Bookid = obj.key.Bookid;
			                        getDocInfo(Bookid,'Y');
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
			title: '비정형문서 등록',
			  closable:true,
			  width:400,
			  autoHeight:true,
			  items: [rmInsert],
			  plain:true, modal:true
			 })
		win2.show('div');
	}
	function hwpcreat(){
		var rowData = schPanel.getSelectionModel().getSelected();
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
	//수정
	function docRepaircont(){
		var rowData = schPanel.getSelectionModel().getSelected();
		var Obookid = rowData.get('obookid');
		var Bookid = rowData.get('bookid');
		var lawTitle = rowData.get('title');
		var Revcha = rowData.get('revcha');
		location.href=CONTEXTPATH+"/jsp/bylaw/repair/repairLayout.jsp?Bookid="+Bookid+"&Obookid="+Obookid+"&docTitle="+lawTitle+"&Revcha="+Revcha+"&pstateCd="+stateCd;
	}
	//연속개정
	function CRevsion(){
		var rowData = schPanel.getSelectionModel().getSelected();
		var Obookid = rowData.get('obookid');
		var Bookid = rowData.get('bookid');
		var lawTitle = rowData.get('title');
		var Revcha = rowData.get('revcha');
		var noFormyn = rowData.get('noformyn');
		var Startdt = rowData.get('startdt');
		var Enddt = rowData.get('enddt');
		var Promuldt = rowData.get('promuldt');
		if(noFormyn=='Y'){
			alert('비정형문서는 지원하지 않습니다.');
			//noFormDoc(t,Pstate);
		}else{
			location.href = CONTEXTPATH+"/jsp/bylaw/revision/revisionLayout.jsp?Bookid="+Bookid+"&Obookid="+Obookid+"&docTitle="+lawTitle+"&Revcha="+Revcha+"&Promuldt="+Promuldt+"&Enddt="+Enddt+"&Startdt="+Startdt+"&Pstate=CRE"+"&pstateCd="+stateCd;
		}
	}
	function deleteCansel(gbn){
		var rowData = schPanel.getSelectionModel().getSelected();
		var bookId = rowData.get('bookid');
		var Revcha = rowData.get('revcha');
		var Obookid = rowData.get('obookid');
		var noFormYn = rowData.get('noformyn');
		var lawTitle = rowData.get('title');
		var fStateCd = rowData.get('fstatecd');
		if(!(fStateCd=='현행'||fStateCd=='폐지')){
			alert('지금 '+lawTitle+'는(은) '+fStateCd +'중인 문서입니다.');
			return;
		}
		var msg;
		if(gbn=='SEL'){
			msg='개정취소를 성공했습니다!!!';
		}else if(gbn=='CLOSESEL'){
			msg='폐지취소를 성공했습니다!!!';
		}else{
			msg='문서 삭제를 성공했습니다!!!!';
		}
		Ext.MessageBox.wait('자료를 저장중입니다. ...','Wait',{interval:20, text:'go go go~!'});
		Ext.Ajax.request({
            url: 'proc.jsp', method : 'post',timeout:3000000000,
            params: {Bookid: bookId,Revcha:Revcha,Obookid:Obookid,gbn:gbn,state:'DEL'},
            success:function(res,opts){
            	  Ext.MessageBox.hide();
            	  Ext.Msg.alert('Status', msg, function(btn, text){
				   if (btn == 'ok'){
                        obj = Ext.util.JSON.decode(res.responseText);
                        Bookid = obj[0].Bookid;
                        if(Bookid){
                        	if(gbn=='SEL'){
                        		getDocInfo(Bookid,noFormYn);
                        		tree.root.reload();
                                schStore.load();
                    		}else if(gbn=='CLOSESEL'){
                    			location.href=CONTEXTPATH+"/jsp/bylaw/existing/mainLayout2.jsp?Statecd=현행&Bookid="+Bookid+"&noFormYn="+noFormYn;
                    		}
                        }else{
                        	Ext.get('center2').update('문서가 삭제되었습니다.!!');
                        	Ext.get('center1').update('문서가 삭제되었습니다.!!');
                        	Ext.get('center3').update('문서가 삭제되었습니다.!!');
                        	Ext.get('easttab').update('문서가 삭제되었습니다.!!');
                        	Ext.get('east').update('문서가 삭제되었습니다.!!');
                        	Ext.get('westbottom').update('문서가 삭제되었습니다.!!');
                        //	Ext.get('south').update('문서가 삭제되었습니다.!!');
                        	tree.root.reload();
                            schStore.load();
                        }

                   }
            	  });
            },
            failure: function(response){
              var result=response.responseText;
              Ext.MessageBox.alert('error','could not connect to the database. retry later');
			}
		});

	}
});