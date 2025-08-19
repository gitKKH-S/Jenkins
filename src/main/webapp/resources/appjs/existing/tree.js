Ext.QuickTips.init();
Ext.onReady(function(){
	var docContextMenu;
	var folContextMenu;
	var rootContextMenu;
	var frm_addChild;
	var frm_window;
	var frm_addRoot;
	//루트폴더 컨텍스트 메뉴 정의
	rootContextMenu = new Ext.menu.Menu({
		id:'rootContextMenu',
		items:[
			{id:'root_addRootFol', cls:'icon_addFol', text:'루트폴더 추가',
			handler:function(){
					frm_addRoot = new Ext.FormPanel({
						url:CONTEXTPATH+'/bylaw/folder/addRoot.do',
						labelWidth:80, width:382, autoHeight:true, monitorValid:true,frame:true,
						items: {
							xtype: 'fieldset', title: '루트카테고리 추가',
							items: [
								{xtype:'textfield',width:230, fieldLabel: '카테고리명', name:'title', allowBlank:false},
								{xtype: 'radiogroup', fieldLabel: '사용여부', itemCls: 'x-radio-group-alt', columns: 1,
   									 items: [
								        {boxLabel: '사용', name: 'useyn', inputValue:'Y', checked:true},
								        {boxLabel: '사용안함', name: 'useyn', inputValue:'N'}
									]
								}
							]
						},
						buttons: [
							{
							text: '등록', formBind: true, handler: function(){
								frm_addRoot.getForm().submit({
									method: 'POST',
									params: {
										pcatid:'0',
										statecd : stateidM
									},
									waitTitle: 'Connecting',
									waitMsg: '자료를 저장중입니다....',
									success: function(form, action){
										Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
						  					if (btn == 'ok'){
					                        	var result = Ext.util.JSON.decode(action.response.responseText);
					                        	var catid = result.catid;
												tree.root.reload();
						                        frm_window.close();
	                                   		}
							        	});
									},
									failure: function(form, action){
									}
								});
							}
							}
						]
					});
					frm_window = new Ext.Window({
						closable:true, width:400, autoHeight:true,
						items: [frm_addRoot], plain:true, modal:true
					})
					frm_window.show(Ext.getBody());
			}},
			{id: 'root_excel', cls:'icon_excel', text: '엑셀다운로드',handler: makeExcel.createDelegate(this)	}
		]
	});
	
	var ordStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/folder/getNodeOrd.do'
		}),
		reader:new Ext.data.JsonReader({
			root:'result'},['ord']
		)
	});
	
	//폴더 컨텍스트 메뉴 정의
	folContextMenu = new Ext.menu.Menu({
		id: 'folderContextMenu',
		items: [
				{id:'fol_regDoc',cls:'icon_crtDoc', text:'제정신청',
				handler:function(){
					var node = tree.getSelectionModel().getSelectedNode();
					var catId = node.id;
					var pstate='I';
					Pop('657','500',CONTEXTPATH+'/bylaw/adm/bylawEnactment.do?Pcatid=',catId,pstate);
				}},
		        {id:'fol_regNonForm',cls:'icon_crtNFDoc', text:'비정형 문서 등록',
				handler: function(){
					var noForm = 'I';
					noFormDoc(noForm);
				}},
		        {id:'fol_addChild',cls:'icon_addFol', text:'하위폴더 생성',
				handler: function(){
					var node = tree.getSelectionModel().getSelectedNode();
					var path= node.getPath();
					//폴더생성시 필요한 파라메터들
					var pCatId = node.id;
					var ord;
					var title;
					var useyn;

					frm_addChild = new Ext.FormPanel({
						url:CONTEXTPATH+'/bylaw/folder/addChild.do',
						labelWidth:80, width:382, autoHeight:true, monitorValid:true,frame:true,
						items: {
							xtype: 'fieldset', title: '하위카테고리 추가',
							items: [
								{xtype:'textfield',width:230, fieldLabel: '카테고리명', name:'title', allowBlank:false, inputValue:title},
								{xtype: 'radiogroup', fieldLabel: '사용여부', itemCls: 'x-radio-group-alt', columns: 1,
   									 items: [
								        {boxLabel: '사용', name: 'useyn', inputValue:'Y', checked:true},
								        {boxLabel: '사용안함', name: 'useyn', inputValue:'N'}
									]
								},
								{xtype:'combo', width:50, fieldLabel:'정렬순서',name:'ord',
									typeAhead: true, triggerAction: 'all', lazyRender:true,
									store:ordStore,displayField:'ord',valueField:'ord',inputValue:ord,
									listeners:{
										beforerender:function(){
											ordStore.on('beforeload', function(){
												ordStore.baseParams = {
													statecd : stateidM, 
													pcatid:pCatId,
													gbn : 'new'
												}
											});
										}
									}
								}
							]
						},
						buttons: [
							{
							text: '등록', formBind: true, handler: function(){
								frm_addChild.getForm().submit({
									method: 'POST',
									params: {
										pcatid:pCatId
									},
									waitTitle: 'Connecting',
									waitMsg: '자료를 저장중입니다....',
									success: function(form, action){
										Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
						  					if (btn == 'ok'){
					                        	var result = Ext.util.JSON.decode(action.response.responseText);
					                        	catid = result.catid;
												tree.root.reload();
												tree.expandPath(path);
						                        frm_window.close();
	                                   		}
							        	});
									},
									failure: function(form, action){

									}
								});
							}
							}
						]
					});
					frm_window = new Ext.Window({
						closable:true, width:400, autoHeight:true,
						items: [frm_addChild], plain:true, modal:true
					})
					frm_window.show('div');
				}},
		        {id:'fol_editFol',cls:'icon_modFol', text:'폴더정보 수정',
				handler: function(){
					var node = tree.getSelectionModel().getSelectedNode();
					var path = node.getPath();
					//폴더생성시 필요한 파라메터들
					var ord = node.parentNode.indexOf(node);
					var catId = node.id;
					var pCatId = node.parentNode.id;
					var title = node.text;
					var useyn = node.attributes.useYn;
					var delYn = node.attributes.delYn;
					var oldord = node.attributes.ord;
					
					frm_addChild = new Ext.FormPanel({
						url:CONTEXTPATH+'/bylaw/folder/modFolder.do',
						labelWidth:80, width:382, autoHeight:true, monitorValid:true, frame:true,
						items: {
							xtype: 'fieldset', title: '카테고리정보 수정',
							items: [
								{xtype:'textfield',width:240, fieldLabel: '카테고리명', name:'title', allowBlank:false, value:title},
								{xtype: 'radiogroup',id:'rUseYnMod', fieldLabel: '사용여부', itemCls: 'x-radio-group-alt', columns: 1, value:useyn,
   									 items: [
								        {boxLabel: '사용', name: 'useyn', inputValue:'Y'},
								        {boxLabel: '사용안함', name: 'useyn', inputValue:'N'}
									]
								},
								{xtype:'combo', width:50, fieldLabel:'정렬순서',name:'ord',
									typeAhead: true, triggerAction: 'all', lazyRender:true,
									store:ordStore,displayField:'ord',valueField:'ord',value:ord,
									listeners:{
										beforerender:function(){
											ordStore.on('beforeload', function(){
												ordStore.baseParams = {
													statecd : stateidM, 
													pcatid:pCatId,
													gbn : 'mod'
												}
											});
										}
									}
								}
							]
						},
						buttons: [
							{
							text: '저장', formBind: true, handler: function(){
								frm_addChild.getForm().submit({
									method: 'POST',
									params: {
										catid:catId,
										oldord:oldord,
										pcatid:pCatId
									},
									waitTitle: 'Connecting',
									waitMsg: '자료를 저장중입니다....',
									success: function(form, action){
										Ext.Msg.alert('Status', '정보가 성공적으로 수정되었습니다.', function(btn, text){
						  					if (btn == 'ok'){
					                        	var result = Ext.util.JSON.decode(action.response.responseText);
												tree.root.reload(); tree.expandPath(path);
						                        frm_window.close();
	                                   		}
							        	});
									},
									failure: function(form, action){

									}
								});
							}
							}
						]
					});
					frm_window = new Ext.Window({
						closable:true, width:400, autoHeight:true,
						items: [frm_addChild], plain:true, modal:true
					})
					Ext.getCmp('rUseYnMod').setValue(useyn);
					frm_window.show('div');
				}},
		        {id:'fol_delFol',cls:'icon_delFol', text:'폴더 삭제',
				handler: function(){
//					Ext.MessageBox.wait('데이터를 삭제중입니다...','Wait',{interval:100, text:'데이터 삭제중 ...'});
					var node = tree.getSelectionModel().getSelectedNode();
					var path = node.parentNode.getPath();
					var ord = node.attributes.ord;
					Ext.Ajax.request({
						url: CONTEXTPATH + '/bylaw/folder/deleteFolder.do',
						params: {
							pcatid: node.parentNode.id,
							catid : node.id,
							ord : ord
						},
						success: function(res, opts){
							var result = Ext.util.JSON.decode(res.responseText);
							if(result.success==true){
								Ext.MessageBox.alert('폴더삭제 성공','폴더가 삭제 되었습니다.');
							}else{
								Ext.MessageBox.alert('폴더삭제 실패','하위폴더나 파일이 있을경우 삭제가 불가능합니다..');
							}
							tree.root.reload();
							tree.expandPath(path);
						},
						failure: function(res, opts){
							Ext.MessageBox.alert('데이터삭제 실패','서버와의 연결상태가 좋지 않습니다. 에러코드:' + response.status);
						}
					});
				}},
	        	{id: 'fol_role', cls:'icon_role', text: '폴더 권한 설정',handler: ruleFolder.createDelegate(this)	},
				{id: 'fol_excel', cls:'icon_excel', text: '엑셀다운로드',handler: makeExcel.createDelegate(this)	},
				{id: 'fol_cd', cls:'icon_cd', text: '일괄다운로드',
					handler:function(){
						var node = tree.getSelectionModel().getSelectedNode();
						var dan3Win = new Ext.Window({
							title:'CD제작', modal:true,
							height:650, width:650, iconCls:'icon_cdmk',
							resizable:false
						});
						dan3Win.render(Ext.getBody());
						dan3Win.body.update('<iframe src="'+CONTEXTPATH+'/bylaw/cdmake/mtree.do?catid='+node.id+'&gbn=N" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');
						dan3Win.show();
					}
				}
		        ]
	});
	//문서 컨텍스트 메뉴 정의
	docContextMenu = new Ext.menu.Menu({
		id: 'documentContextMenu',
		items: [
	        	{id:'doc_modDoc',cls:'icon_modDocInfo', text: '문서정보수정',
				handler:function(){
					var node = tree.getSelectionModel().getSelectedNode();
					var bookId = node.attributes.bookId;
					var lawTitle = node.attributes.title;
					var noFormyn = node.attributes.noFormYn;
					var fStateCd = node.attributes.fStateCd;
					var statehistoryid = node.attributes.statehistoryid;
					if(fStateCd!='현행'){
						alert('지금 '+lawTitle+'는(은) 개정중인 문서입니다.');
						return;
					}					
					var Pstate = 'U';
					if(noFormyn=='Y'){
						noFormDoc(Pstate);
					}else{
						Pop('657','500',CONTEXTPATH+'/bylaw/adm/bylawEnactment.do?statehistoryid='+statehistoryid+'&Bookid=',bookId,Pstate);
					}
				}},		
	        	{id:'doc_modDocCont',cls:'icon_modDoc', text: '내용수정',
					handler: function(){
						var node = tree.getSelectionModel().getSelectedNode();
						var Obookid = node.attributes.oBookId;
						var Bookid = node.attributes.bookId;
						var noFormyn = node.attributes.noFormYn;
						var lawTitle = node.attributes.title;
						var Revcha = node.attributes.revCha;
						var fStateCd = node.attributes.fStateCd;
						var stateid = node.attributes.stateid;
						var statehistoryid = node.attributes.statehistoryid;
						var updatecha = node.attributes.updatecha;
						
						if(!(fStateCd=='현행' || fStateCd == '폐지')){
							alert('지금 '+lawTitle+'는(은) 개정중인 문서입니다.');
							return;
						}
						
						var rmInsert = new Ext.FormPanel({
					        labelWidth:60,width:385,autoHeight:true, url:CONTEXTPATH+'/bylaw/adm/updatelog.do', frame:true, defaultType:'textarea', monitorValid:true,
					        items:[{
					            xtype: 'textfield', fieldLabel:'수정차수', name: 'updatecha', allowBlank:true,readOnly:true,value:Number(updatecha)+1
					            },{
						        fieldLabel:'수정이유', width:295, height:238, name: 'updatereason', allowBlank:false
					            }],
					        buttons:[{
					        	text:'등록', formBind: true, iconCls:'icon_save',
								handler:function(){
					        		rmInsert.getForm().submit({
					                	method:'POST',
					                    params: {
							    			bookid: Bookid
								        	},
					                        waitTitle:'Connecting', waitMsg:'자료를 저장중입니다....',

				                        success:function(form, action){
				                        	win2.hide();
				                        	win = new Ext.Window({
				        				        title:lawTitle+"내용수정",
				        			    	    layout:'fit',
				        			    	    width:200,
				        			            height:200,
				        			            closeAction:'hide',
				        			            iframe:'true',
				        			            modal:true,
				        			            plain: true,
	        			                        buttons: [{
				        			                text: '수정완료',
				        			                handler: function(){
				        			                    win.hide();
				        			                    getDocInfo(Bookid,noFormyn);
				        			                    var path = node.parentNode.getPath();
				        			                    tree.root.reload();
				        			                    tree.expandPath(path);
				        			                }
				        			            }]
				        			        });
				        					win.render(document.body);
				        					win.body.update('<iframe src="'+CONTEXTPATH+"/bylaw/adm/EgcProc.do?BOOKID="+Bookid+"&PSTATE=YURE"+'" width="100%" height="100%" marginheight="0" marginwidth="0" frameborder="no"></iframe>');
				        				    win.show();
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
							title: lawTitle+' 내용수정', closable:true, width:400, height:350,
							items: [rmInsert], plain:true, modal:true,iconCls:'icon_modDoc'
						})
						win2.show();
						
						
						
						
				}},
				{id:'doc_revDoc', text: '개정신청',  iconCls:'icon_doc1',
		        	menu:{
						items:[
							{text:'정형문서 개정',cls:'icon_regulrev', handler:DocRev.createDelegate(this,['N'])},
							{text:'비정형문서 개정',cls:'icon_noregulrev', handler:DocRev.createDelegate(this,['Y'])}
						]
					}
				},
				{id: 'doc_addJoFile1', cls: 'icon_refdoc', text:'조별관련문서 등록',
					handler:function(){
					var node = tree.getSelectionModel().getSelectedNode();
					var Bookid = node.attributes.bookId;
					var statehistoryid = node.attributes.statehistoryid;
					var Revcha = node.attributes.revCha;
					var noFormyn = node.attributes.noFormYn;
					var lawTitle = node.attributes.title;
					var Pstate =''; 

					var Pstate = 'FILE';

					win = new Ext.Window({
						id:'win_upload',
						title: "조별 관련 문서 등록", layout: 'fit', width:790, height:600,
						closeAction: 'hide',iframe:true, modal: true, plain: true,
						buttons: [{
							text: '닫기',
							handler: function(){ 
								makeLink('DOC');
								win.close(); 
							}
						}]
					});
					win.render(Ext.getBody());
					win.show();
					win.body.update('<iframe src='+CONTEXTPATH+'/bylaw/adm/addjoFile.do?Bookid=' + Bookid + '&noFormYn='+noFormyn + '&statehistoryid='+statehistoryid+' width=100% height=100% frameborder=no></iframe>');
				}},
				{id: 'doc_org', cls:'icon_cat', text: '규정체계도설정',
					handler:function(){
						var node = tree.getSelectionModel().getSelectedNode();
						var Obookid = node.attributes.oBookId;
						win = new Ext.Window({
							id:'win_upload',
							title: "규정체계도설정",iconCls:'icon_cat', layout: 'fit', width:1000, height:800,
							closeAction: 'hide',iframe:true, modal: true, plain: true,
							buttons: [{
								text: '닫기',
								handler: function(){ 
									win.close(); 
								}
							}]
						});
						win.render(Ext.getBody());
						win.show();
						win.body.update('<iframe src='+CONTEXTPATH+'/bylaw/adm/ruleTree.do?obookid=' + Obookid +' width=100% height=100% frameborder=no></iframe>');
					}	
				},
				{text:'폐지신청',id:'doc_disUse', cls:'icon_abol', handler:DocRev.createDelegate(this,['P'])},
				{id:'etcLink',cls:'icon_linkedit', text: '관련규정링크작업',
					handler:function(){
						
						var node = tree.getSelectionModel().getSelectedNode();
						var ruleDept = new Ext.Window({
							title:'관련규정링크작업', modal:true,
							height:400, width:800, iconCls:'dan3View',
							resizable:false,
							plain: true
						});
						ruleDept.render(Ext.getBody());
						ruleDept.body.update('<iframe src='+CONTEXTPATH+'/bylaw/adm/etcLink.do?docid='+node.attributes.bookId+' width="100%" height="100%" scroll="no" frameborder="no"></iframe>');
						ruleDept.show();					
						
				}},
				{id:'doc_dept',cls:'icon_refdept', text: '관련부서관리',
					handler:function(){
						
						var node = tree.getSelectionModel().getSelectedNode();
						var obookId = node.attributes.oBookId;						
						var ruleDept = new Ext.Window({
							title:'규정부서관리', modal:true,
							height:508, width:316, iconCls:'dan3View',
							resizable:false,
							plain: true
						});
						ruleDept.render(Ext.getBody());
						ruleDept.body.update('<iframe src="ruleDeptView.do?OBOOKID='+obookId+'" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');
						ruleDept.show();					
						
				}},
				{id: 'doc_Topcont', cls:'icon_doc3', text: '개정이유',handler: revReason.createDelegate(this)	},
				{id:'doc_jenmun', cls:'icon_jenmun', text:'전문요약', handler:jenmun.createDelegate(this)},
				{id: 'doc_Memo', cls:'icon_memo', text: '메모장',handler: memoForm.createDelegate(this)	},	
				{id: 'doc_addFile1', cls: 'icon_refdoc', text:'관련첨부문서 관리',
					handler:function(){
					var node = tree.getSelectionModel().getSelectedNode();
					var Bookid = node.attributes.bookId;
					var statehistoryid = node.attributes.statehistoryid;
					var Revcha = node.attributes.revCha;
					var noFormyn = node.attributes.noFormYn;
					var lawTitle = node.attributes.title;
					var Pstate =''; 

					var Pstate = 'FILE';

					win = new Ext.Window({
						id:'win_upload',
						title: "제개정문 / 신구조문 파일등록", layout: 'fit', width:870, height:600,
						closeAction: 'hide',iframe:true, modal: true, plain: true,
						buttons: [{
							text: '닫기',
							handler: function(){ 
								win.close(); 
							}
						}]
					});
					win.render(Ext.getBody());
					win.show();
					win.body.update('<iframe src='+CONTEXTPATH+'/bylaw/adm/fileUpload.do?Bookid=' + Bookid + '&noFormYn='+noFormyn + '&statehistoryid='+statehistoryid+' width=100% height=100% frameborder=no></iframe>');
				}},
				{id:'deleteCansel', text: '삭제/개정취소', iconCls:'icon_delrev', 
					menu:{
					items:[
					    {id:'deleteCansel1',text:'개정취소(연혁을 현행으로 변환)',cls:'icon_canRev', handler:deleteCansel.createDelegate(this,['SEL'])},
						{id:'deleteCansel2',text:'삭제(문서전체삭제)',cls:'icon_del', handler:deleteCansel.createDelegate(this,['DEL'])}
						
					]
				}},
	        	{id:'doc_makeLink', text: '링크생성', iconCls:'icon_linkedit',
					menu:{
					id:'mkLink',
					items:[
						{id:'nowDocLink',cls:'icon_link',text:'현재문서 현행 링크생성',handler:makeLink.createDelegate(this,['DOC'])},
						{id:'nowDocHistLink',cls:'icon_link',text:'현재문서 연혁포함 링크생성',handler:makeLink.createDelegate(this,['ALLDOC'])},
						{id:'allDocLink',cls:'icon_link',text:'전체문서 링크생성',handler:makeLink.createDelegate(this,['TOTALDOC'])}
					]
				}},
	        	{id:'doc_cancelDiduse',cls:'icon_canAbol', text: '폐지취소',handler: deleteCansel.createDelegate(this,['CLOSESEL'])	}
			]
		});

	var Tree = Ext.tree;
    tree = new Tree.TreePanel({
		renderTo:'treeHolder', useArrows: false, autoScroll: false, animate: true,
        enableDD: true, containerScroll: true, border: false,
        // TreeLoader를 자동생성
        //dataUrl: CONTEXTPATH+'/jsp/bylaw/existing/tree_proc/getNodes.jsp?stateCd='+encodeURIComponent(stateCd),
    	
		loader : new Ext.tree.TreeLoader({
			dataUrl: CONTEXTPATH+'/bylaw/folder/getNodes.do',
			baseParams:{
				stateCd : stateCd
			}
		}),
        root: {
            nodeType: 'async', text: stateCd+'자치법규', draggable: false, id: '0',
			listeners:{
    			click: function(node,e){	
					rootContextMenu.showAt(e.getXY());
    			},
				contextmenu:function(node,e){
					node.select();
					rootContextMenu.showAt(e.getXY());
				}
			}
        },
		listeners:{
			click: function (node,e){
				node.select();
				var nodeKind = node.attributes.cls;
				var bookId = node.attributes.bookId;
				var noFormyn = node.attributes.noFormYn;
				
				if(nodeKind=='folder'){
					if(bonValue=='xml'){
						Ext.getCmp('center').activate('center22');
					}else{
						Ext.getCmp('center').activate('center11');
					}
				}else if(nodeKind=='file'||nodeKind=='fileIng'){
					Ext.getCmp('center').activate('center22');
					if(noFormyn=='Y'){
						Ext.getCmp('hkk').activate(1);
					}else{
						Ext.getCmp('hkk').activate(0);
					}
					getDocInfo(bookId,noFormyn);
				}
			},
			beforenodedrop: function(e){ //DD시 노드 드랍전 실행, e.dropNode의 정보는 드랍전 원래의 정보
				//e.dropNode.select();
//				var node = e.dropNode;
//				var cls = node.attributes.cls;
//				if(cls=='folder' || cls=='oldFolder' || cls=='curFolder'){
//					Ext.MessageBox.confirm('폴더이동 확인','폴더 및 하위폴더, 파일 까지 이동됩니다. 이동하시겠습니까?');
//				}else if(cls=='file' || cls=='oldFile' || cls=='curFile'){
//					Ext.MessageBox.confirm('파일이동 확인','파일이 새로운 위치로 이동됩니다. 이동하시겠습니까?');
//				}
			},
			nodedrop: function(e){ //DD시 노드 드랍후 실행, e.dropNode의 정보는 드랍후 현재의 정보
//				Ext.MessageBox.wait('해당위치로 이동중입니다....','Wait',{interval:100, text:'데이터 이동중 ...'});
				var node = e.dropNode;
				var point = e.point;	//값 : 폴더로 병합: append , 현재위치보다 위로 : above, 현재위치보다 아래로 : below
				var pNode = node.parentNode;
				var cls = node.attributes.cls;
				var catId = node.id;
				var pCatId = pNode.id;
				var path = node.getPath();
				var useYn = node.attributes.useYn;
				var ord = pNode.indexOf(node);
				if(point != 'append'){
					try{
						var nextNode = pNode.item(ord+1);
						ord = nextNode.attributes.ord;
					}catch(e){
						var nextNode = pNode.item(ord);
						ord = nextNode.attributes.ord;
					}
				}
				
				var oldOrd = node.attributes.ord;
				
				var job='';
				var cNodes = pNode.childNodes;
				var catIds = new Array;
				for (var i=0; i<cNodes.length; i++){
					catIds.push(cNodes[i].id);
				}
				if(point=='append'){
					job='moveAppend';
				}else if(point!='append' && oldOrd-ord>0){
					job='moveAbove';
				}else{
					job='moveBelow';
				}
				//ord재정렬 조건 설정
				Ext.Ajax.request({
					url: CONTEXTPATH +'/bylaw/adm/moveNode.do',
					params: {
						job: job,
						catId: catId,
						pCatId: pCatId,
						catIds: catIds,
						ord: ord,
						useYn: useYn
					},
					success: function(res, opts){
//						var result = Ext.decode(res.responseText);
//						Ext.MessageBox.hide();
						tree.root.reload();
						tree.expandPath(path);

					},
					failure: function(){
						alert('DB에러 발생');
						return false;
					}
				});
			},
			contextmenu: function(node, e){
//folder: fol_regDoc fol_regNonForm fol_addChild fol_editFol fol_delFol
				node.select();
				//nodeKind : folder, doc, nuFolder, nuFile
				var nodeKind = node.attributes.cls;
				var bookId = node.attributes.bookId;
				var noFormyn = node.attributes.noFormYn;
				var fStateCd = node.attributes.fStateCd;
				var Dept = node.attributes.Dept;
				var deptCd = node.attributes.Deptcd;
				if (nodeKind == 'folder') {
					folContextMenu.items.get('fol_regDoc').show();
					folContextMenu.items.get('fol_regNonForm').show();
					folContextMenu.items.get('fol_addChild').hide();
					folContextMenu.items.get('fol_editFol').hide();
					folContextMenu.items.get('fol_delFol').hide();
					if (bonValue == 'xml') {
						Ext.getCmp('center').activate('center22');
					}
					else {
						Ext.getCmp('center').activate('center11');
					}
					if(Grpcd.indexOf('Y')>-1){
						folContextMenu.items.get('fol_regDoc').show();
						folContextMenu.items.get('fol_regNonForm').show();
						folContextMenu.items.get('fol_addChild').show();
						folContextMenu.items.get('fol_editFol').show();
						folContextMenu.items.get('fol_delFol').show();
					}
					
					if(Grpcd2=='S'){
						folContextMenu.items.get('fol_role').hide();//20210305숨기기
						folContextMenu.items.get('fol_excel').show();
						folContextMenu.items.get('fol_cd').show();
						folContextMenu.showAt(e.getXY());
					}else{
						Ext.Ajax.request({
							url: CONTEXTPATH + '/bylaw/adm/chkCatruleList.do',
							params: {
								catid : node.id,
								userid : suserid
							},
							success: function(res, opts){
								var result = Ext.util.JSON.decode(res.responseText);
								if(result.data==0){
									folContextMenu.items.get('fol_role').hide();
									folContextMenu.items.get('fol_excel').hide();
									folContextMenu.items.get('fol_cd').hide();
									folContextMenu.showAt(e.getXY());
								}else{
									folContextMenu.items.get('fol_role').hide();//20210305숨기기
									folContextMenu.items.get('fol_excel').show();
									folContextMenu.items.get('fol_cd').show();
									folContextMenu.showAt(e.getXY());
								}
							},
							failure: function(res, opts){
								
							}
						});
					}
					
				}else if(nodeKind=='nuFolder'){
					folContextMenu.items.get('fol_regDoc').hide();
					folContextMenu.items.get('fol_regNonForm').hide();
					folContextMenu.items.get('fol_addChild').show();
					folContextMenu.items.get('fol_editFol').show();
					folContextMenu.items.get('fol_delFol').show();
					if(bonValue=='xml'){
						Ext.getCmp('center').activate('center22');
					}else{
						Ext.getCmp('center').activate('center11');
					}
					if(Grpcd.indexOf('Y')==-1){
						folContextMenu.items.get('fol_regDoc').hide();
						folContextMenu.items.get('fol_regNonForm').hide();
						folContextMenu.items.get('fol_addChild').hide();
						folContextMenu.items.get('fol_editFol').hide();
						folContextMenu.items.get('fol_delFol').hide();
					}
					folContextMenu.showAt(e.getXY());
				}else if(nodeKind=='file'||nodeKind=='fileIng'){
					docContextMenu.items.get("doc_addJoFile1").hide();//20210305숨기기(조별관련문서등록)
					docContextMenu.items.get("doc_org").hide();//20210305숨기기(규정체계도)
					docContextMenu.items.get("etcLink").hide();//20210305숨기기(관련규정링크)
					docContextMenu.items.get('doc_dept').hide();//20210305숨기기(관련부서관리)
						if(stateCd=='현행'){
							docContextMenu.items.get('doc_makeLinkSub');
							docContextMenu.items.get("doc_disUse").show();
							docContextMenu.items.get('doc_cancelDiduse').hide();
						//	docContextMenu.items.get('doc_modHDocCont').show();		//연혁내용수정
						}else if(stateCd=='폐지'){
							docContextMenu.items.get("doc_revDoc").hide();
							docContextMenu.items.get('doc_disUse').hide();
							docContextMenu.items.get("doc_cancelDiduse").show();
						//	docContextMenu.items.get('doc_modHDocCont').show();		//연혁내용수정
	
						}else if(!(fStateCd=='현행'||fStateCd=='폐지')){
							docContextMenu.items.get('doc_revDoc').hide();
							docContextMenu.items.get('doc_disUse').hide();
						//	docContextMenu.items.get('doc_modHDocCont').show();		//연혁내용수정
	
						}
						if(noFormyn=='Y'){	//비정형 문서일때 메뉴 숨김
							docContextMenu.items.get('doc_modDocCont').hide();
							//docContextMenu.items.get('doc_addFile').show();
						//	docContextMenu.items.get('doc_modHDocCont').hide();		//연혁내용수정
							//docContextMenu.items.get('CRevsion').hide();
							//docContextMenu.items.get('doc_expONTWord').hide();
							//docContextMenu.items.get('doc_expWord').hide();
							//docContextMenu.items.get('doc_crtDoc').hide();
							//docContextMenu.items.get('doc_makeLink').hide();
						}else{	//비정형 문서가 아닐때..
							docContextMenu.items.get('doc_modDocCont').show();
							//docContextMenu.items.get('doc_addFile').show();
						//	docContextMenu.items.get('doc_modHDocCont').show();		//연혁내용수정
							//docContextMenu.items.get('CRevsion').show();
							//docContextMenu.items.get('doc_expONTWord').show();
							//docContextMenu.items.get('doc_expWord').show();
							//docContextMenu.items.get('doc_crtDoc').show();
							docContextMenu.items.get('doc_makeLink').show();
						}
						//메뉴 우클릭시 비정형 문서일경우 문서 view 바꿔준다.
						if(nodeKind=='folder'){
							if(bonValue=='xml'){
								Ext.getCmp('center').activate('center22');
							}else{
								Ext.getCmp('center').activate('center11');
							}
						}else if(nodeKind=='file'||nodeKind=='fileIng'){
							if(noFormyn=='Y'){
								if(bonValue=='xml'){
									Ext.getCmp('center').activate('center22');
								}else{
									Ext.getCmp('center').activate('center11');
								}
							}else{
								if(bonValue=='xml'){
									Ext.getCmp('center').activate('center22');
								}else{
									Ext.getCmp('center').activate('center11');
								}
							}
						}
						
						//if (Dept.indexOf(Orgname)!=-1 || Grpcd2=='S'){
						var bookcd = node.attributes.bookcd;
						if (Grpcd2=='S'||Grpcd.indexOf('H')>-1){
							if(Grpcd2!='S'){
								var bookcd = node.attributes.bookcd;
								
								Ext.getCmp('deleteCansel2').hide();
								//Ext.getCmp('doc_modDocCont').hide();
								if(Deptcd==deptCd || DEPTPATH.indexOf(deptCd)>-1){
									docContextMenu.showAt(e.getXY());
								}
								//docContextMenu.items.get('doc_modDoc').hide();
								//docContextMenu.items.get('doc_modDocCont').hide();
								//docContextMenu.items.get('doc_modHDocCont').hide();
								//docContextMenu.items.get('doc_makeLink').hide();
								
								//docContextMenu.items.get('doc_dept').hide();
							}
							if(Grpcd2=='S'){
								docContextMenu.showAt(e.getXY());
							}
						}
				}
			},
			expandnode: function(node){
				
			},
			collapsenode: function(node){

			}
		}
    });

    // render the tree
    tree.getRootNode().expand();
	function test(){
		alert('hi');
	}
	function makeLink(gbn){
		var node = tree.getSelectionModel().getSelectedNode();
		var bookId = node.attributes.bookId;
		var noFormyn = node.attributes.noFormYn;
		//링크생성
		Ext.MessageBox.wait('자료를 저장중입니다. ...','Wait',{interval:20, text:'go go go~!'});
		Ext.Ajax.request({
            url: CONTEXTPATH+'/bylaw/adm/makeLink.do', method : 'post',timeout:30000,
            params: {BOOKID: bookId,  state:  "link1", GBN:gbn},
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
	function memoForm(){
		var node = tree.getSelectionModel().getSelectedNode();
		var bookId = node.attributes.bookId;

		Ext.Ajax.request({
		     url : CONTEXTPATH + '/bylaw/adm/getMemo.do',
		     params:{
		    	 bookid:bookId,
		    	 gbn:'B'
		     },
		     success:function(res,opts){
		      result=Ext.util.JSON.decode(res.responseText);
		      var rmInsert = new Ext.FormPanel({
			        labelWidth:60,width:385, url:CONTEXTPATH + '/bylaw/adm/setMemo.do', frame:true, defaultType:'textarea', monitorValid:true, autoHeight:true,
			        items:[{
			        	fieldLabel:'메모작성', width:295, height:220, name: 'cont', allowBlank:false ,value:result.CONT
			        }],
			        buttons:[{
			                text:'등록', formBind: true,width:60,iconCls:'icon_save',
			                handler:function(){
			        		rmInsert.getForm().submit({
		                        method:'POST',
		                        params: {
		                        	bookid: bookId,
		                        	gbn:'B',
		                        	memoid:result.MEMOID
					              },
		                        waitTitle:'Connecting',
		                        waitMsg:'자료를 저장중입니다....',

		                        success:function(){
			                        Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
							   			if (btn == 'ok'){
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
					  title: '메모 등록', closable:true, width:400, height:300,
					  items: [rmInsert], plain:true, modal:true, iconCls:'icon_memo'
					 })
				win2.show('div');

		     },
		     failure:function(){
		      alert('DB에러 발생');
		     }
		});
	}
	function revReason(){
		var node = tree.getSelectionModel().getSelectedNode();
		var bookId = node.attributes.bookId;

		Ext.Ajax.request({
			url:CONTEXTPATH + '/bylaw/adm/getDocInfo.do',
			params:{
				Bookid:bookId
			},
			success:function(res,opts){
				result=Ext.util.JSON.decode(res.responseText);
				var rmInsert = new Ext.FormPanel({
					labelWidth:60,width:385, url:CONTEXTPATH + '/bylaw/adm/setRevreason.do', frame:true, defaultType:'textarea', monitorValid:true, autoHeight:true,
			        items:[{
			        	fieldLabel:'제·개정이유', width:295, height:220, name: 'revreason', allowBlank:true ,value:result.data.REVREASON
			            },{
		            	fieldLabel:'주요 제·개정 내용', width:295, height:220, name: 'mainpith', allowBlank:true,value:result.data.MAINPITH
			        }],
			        buttons:[{
			                text:'등록', formBind: true, iconCls:'icon_save',width:60,
			                handler:function(){
			        		rmInsert.getForm().submit({
		                        method:'POST',
		                        params: {
					    			bookid: bookId
					              },
		                        waitTitle:'Connecting',
		                        waitMsg:'자료를 저장중입니다....',

		                        success:function(){
			                        Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
							   			if (btn == 'ok'){
					                        //getDocView('south','bon.jsp',bookId,'mp');//개정이유및주요골자
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
					  title: '제·개정이유 및 주요내용', closable:true, width:400, height:530,
					  items: [rmInsert], plain:true, modal:true,iconCls:'icon_doc3'
					 })
				win2.show('div');

		     },
		     failure:function(){
		      alert('DB에러 발생');
		     }
		});
	}
	function jenmun(){
		var node = tree.getSelectionModel().getSelectedNode();
		var bookId = node.attributes.bookId;

		Ext.Ajax.request({
			url:CONTEXTPATH + '/bylaw/adm/getDocInfo.do',
		     params:{
			Bookid:bookId
		     },
		     success:function(res,opts){
		      result=Ext.util.JSON.decode(res.responseText);
		      var rmInsert = new Ext.FormPanel({
			        labelWidth:60,width:385, url:CONTEXTPATH + '/bylaw/adm/setJenmun.do', frame:true, defaultType:'textarea', monitorValid:true, autoHeight:true,
			        items:[{
			        	fieldLabel:'전문요약', width:295, height:220, name: 'jenmun', allowBlank:false ,value:result.data.JENMUN
			        }],
			        buttons:[{
			                text:'등록', formBind: true, iconCls:'icon_save',width:60,
			                handler:function(){
			        		rmInsert.getForm().submit({
		                        method:'POST',
		                        params: {
					    			bookid: bookId
					              },
		                        waitTitle:'Connecting',
		                        waitMsg:'자료를 저장중입니다....',

		                        success:function(){
			                        Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
							   			if (btn == 'ok'){
					                        //getDocView('south','bon.jsp',bookId,'mp');//개정이유및주요골자
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
					  title: '전문요약 등록', closable:true, width:400, height:300,
					  items: [rmInsert], plain:true, modal:true,iconCls:'icon_doc3'
					 })
				win2.show('div');

		     },
		     failure:function(){
		      alert('DB에러 발생');
		     }
		});
	}
	function hwpcreat(){
		var node = tree.getSelectionModel().getSelectedNode();
		var Obookid = node.attributes.oBookId;
		var Revcha = node.attributes.revCha;
		var Bookid = node.attributes.bookId;
		var Revcd = node.attributes.revCd;
		if(Revcd=='제정'||Revcd=='전부개정'||Revcd=='폐지'){
			window.open('createHwp.jsp?Bookid='+Bookid+'&Pstate=NOW','','');
		}else{
			window.open('revHwp.jsp?Obookid='+Obookid+'&Revcha='+Revcha+'&Bookid='+Bookid,'','');
		}
	}

	function DocRev(noFormyntmp){
		var node = tree.getSelectionModel().getSelectedNode();
		var Obookid = node.attributes.oBookId;
		var Bookid = node.attributes.bookId;
		var lawTitle = node.attributes.title;
		var noFormYn = node.attributes.noFormYn;
		var Revcha = node.attributes.revCha;
		var catId = node.attributes.catId;
		var Pcatid = node.attributes.pCatId;
		var statehistoryid = node.attributes.statehistoryid;
		var Pstate = 'RE';
		if(noFormyntmp=='P'){
			Pstate = 'P';
		}
		var fStateCd = node.attributes.fStateCd;
		if(!(fStateCd=='현행'||fStateCd=='폐지')){
			alert('지금 '+lawTitle+'는(은) 개정중인 문서입니다.');
			return;
		}
		if(noFormyntmp=='Y'){
			noFormDoc(Pstate);
		}else{
			if(Pstate=='P'&&noFormYn=='Y'){
				noFormDoc(Pstate);	//비정형문서폐지
			}else{
				Pop('657','500',CONTEXTPATH+'/bylaw/adm/bylawEnactment.do?statehistoryid='+statehistoryid+'&Pcatid='+Pcatid+'&Obookid='+Obookid+'&noFormYn='+noFormYn+'&Bookid=',Bookid,Pstate);
			}
			
		}

	}
	function deleteCansel(gbn){
		if(!confirm('문서를 삭제하게 됩니다. 계속 진행하시겠습니까?')){
			return;
		}
		var node = tree.getSelectionModel().getSelectedNode();
		var bookId = node.attributes.bookId;
		var Revcha = node.attributes.revCha;
		var Obookid = node.attributes.oBookId;
		var noFormYn = node.attributes.noFormYn;
		var lawTitle = node.attributes.title;
		var fStateCd = node.attributes.fStateCd;
		if(!(fStateCd=='현행'||fStateCd=='폐지')){
			alert('지금 '+lawTitle+'는(은) 개정중인 문서입니다.');
			return;
		}
		var path = node.parentNode.getPath();
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
            url: CONTEXTPATH+'/bylaw/adm/docDelete.do', method : 'post',timeout:3000000,
            params: {BOOKID: bookId,REVCHA:Revcha,OBOOKID:Obookid,GBN:gbn,state:'DEL'},
            success:function(res,opts){
            	  Ext.MessageBox.hide();
            	  Ext.Msg.alert('Status', msg, function(btn, text){
				   if (btn == 'ok'){
                        obj = Ext.util.JSON.decode(res.responseText);
                        bookId = obj.BOOKID;
                        if(bookId){
                        	if(gbn=='SEL'){
                        		getDocInfo(bookId,noFormYn);
                    		}else if(gbn=='CLOSESEL'){
                    			location.href=CONTEXTPATH+"/bylaw/adm/mainLayout2.do?Statecd=H&Bookid="+bookId+"&noFormYn="+noFormYn;
                    		}
                        }else{
                        	Ext.get('center2').update('문서가 삭제되었습니다.!!');
                        	Ext.get('center1').update('문서가 삭제되었습니다.!!');
                        	Ext.get('center3').update('문서가 삭제되었습니다.!!');
                        	Ext.get('easttab').update('문서가 삭제되었습니다.!!');
                        	Ext.get('east').update('문서가 삭제되었습니다.!!');
                        	Ext.get('westbottom').update('문서가 삭제되었습니다.!!');
                        //	Ext.get('south').update('문서가 삭제되었습니다.!!');
                        }
                        tree.root.reload();
						tree.expandPath(path);
                   }
            	  });
            },
            failure: function(response){
              var result=response.responseText;
              Ext.MessageBox.alert('error','could not connect to the database. retry later');
			}
		});

	}
	
	function makeExcel(){
		var node = tree.getSelectionModel().getSelectedNode();
		location.href = CONTEXTPATH + "/bylaw/adm/makeExcel.do?catid="+node.id;
	}
	
	function ruleFolder(){
		var node = tree.getSelectionModel().getSelectedNode();
		
		var dTree = Ext.tree;
		dTree = new Tree.TreePanel({
			renderTo:'treeHolder', useArrows: false, autoScroll: true, animate: true,width:400,height:663,
	        enableDD: true, containerScroll: true, border: false,
			loader : new Ext.tree.TreeLoader({
				dataUrl: CONTEXTPATH+'/bylaw/adm/getDept.do'
			}),
	        root: {
	            nodeType: 'async', text: '고양시청', draggable: false, id: 'H',
				listeners:{
	    			click: function(node,e){	
					
	    			},
					contextmenu:function(node,e){
						
					}
				}
	        },
			listeners:{
				click: function (node,e){
					gridStore.on('beforeload', function(){
						gridStore.baseParams = {
							deptcd : node.id
						}
					});
					gridStore.load({
						params:{
						
						}
					});
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
		dTree.getRootNode().expand();
		
		 var gridStore = new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({
					url:CONTEXTPATH+'/bylaw/user/userList.do'
				}),
				reader:new Ext.data.JsonReader({root:'records'},['userNameCR','userNoCR','e_mailCR','deptNameCR','teamname','codeIdCR'])
		});

		// Column Model shortcut array
		var cols = [
		    {header: "부서명", width: 230, sortable: true, dataIndex: 'deptNameCR'},
			{ id : 'name', header: "성 명", width: 50, sortable: true, dataIndex: 'userNameCR'},
			{header: "사번", width: 70, sortable: true, dataIndex: 'userNoCR'},
			{header:"", dataIndex:'',width:30,
				editor: {
			        xtype: 'checkbox',
			        inputValue: 'Y'
			    },
			    renderer: function(value) {
			        return "<input type='checkbox' id='RULEYN'" + (value=='Y' ? "checked='checked'" : "") + " / >";
			    }
				
			}
		];
		
		// declare the source Grid
		var grid = new Ext.grid.GridPanel({
			ddGroup          : 'gridDDGroup',
		    store            : gridStore,
		    columns          : cols,
			enableDragDrop   : true,
		    stripeRows       : true,
		    autoExpandColumn : 'name',
		    width            : 400,
		    height			 : 363,
			region           : 'west',
		    title            : '직원목록',
		    iconCls          : 'icon_doc3',
			selModel         : new Ext.grid.RowSelectionModel({singleSelect : true}),
			listeners:{
				render:function(cmp){
				},
				cellclick: function(iView, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
				      
			    },
			    rowclick: function (grid, idx, e){
					var obj1 = Ext.select('input[id=RULEYN]').elements;
					var selModel= grid.getSelectionModel();
					var userData = selModel.getSelected();
					if(obj1[idx].checked){
						Ext.Ajax.request({
							url: CONTEXTPATH + '/bylaw/adm/getCatruleInsert.do',
							params: {
								catid: node.id,
								userid : userData.get('userNoCR'),
								usernm : userData.get('userNameCR'),
								deptcd : userData.get('codeIdCR'),
								deptnm : userData.get('deptNameCR')
							},
							success: function(res, opts){
								var result = Ext.util.JSON.decode(res.responseText);
								if(result.data==0){
									alert("이미 등록된 사용자 입니다.");
								}else{
									gridStore2.on('beforeload', function(){
										gridStore2.baseParams = {
											catid: node.id
										}
									});
									gridStore2.load({
										params:{
											catid: node.id
										}
									});
								}
							},
							failure: function(res, opts){
								
							}
						});
					}
			    }
			}
		});
		
		var gridStore2 = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:CONTEXTPATH+'/bylaw/adm/getCatruleList.do'
			}),
			reader:new Ext.data.JsonReader({root:'data'},['CATRULEID','CATID','USERID','USERNM','DEPTCD','DEPTNM','UPDT','CRULEYN'])
		});
	
		// Column Model shortcut array
		var cols2 = [
		    {header: "부서명", width: 200, sortable: true, dataIndex: 'DEPTNM'},
			{ id : 'name', header: "성 명", width: 50, sortable: true, dataIndex: 'USERNM'},
			{header: "사번", width: 70, sortable: true, dataIndex: 'USERID'},
			{header:"삭제", dataIndex:'',width:50,
				editor: {
			        xtype: 'checkbox',
			        inputValue: 'Y'
			    },
			    renderer: function(value) {
			        return "<input type='checkbox' id='CRULEYN'" + (value=='Y' ? "checked='checked'" : "") + " / >";
			    }
				
			}
		];
		
		// declare the source Grid
		var grid2 = new Ext.grid.GridPanel({
			ddGroup          : 'gridDDGroup',
		    store            : gridStore2,
		    columns          : cols2,
			enableDragDrop   : true,
		    stripeRows       : true,
		    autoExpandColumn : 'name',
		    width            : 400,
		    height			 : 300,
			region           : 'west',
		    title            : '권한리스트',
		    iconCls          : 'icon_doc3',
			selModel         : new Ext.grid.RowSelectionModel({singleSelect : true}),
			listeners:{
				render:function(cmp){
				},
			    rowclick: function (grid, idx, e){
					var obj1 = Ext.select('input[id=CRULEYN]').elements;
					var selModel= grid.getSelectionModel();
					var userData = selModel.getSelected();
					
					if(obj1[idx].checked){
						Ext.Ajax.request({
							url: CONTEXTPATH + '/bylaw/adm/getCatruleDelete.do',
							params: {
								catruleid : userData.get('CATRULEID')
							},
							success: function(res, opts){
								var result = Ext.util.JSON.decode(res.responseText);
								if(result.data==0){
									
								}else{
									alert("삭제 되었습니다.");
									gridStore2.on('beforeload', function(){
										gridStore2.baseParams = {
											catid: node.id
										}
									});
									gridStore2.load({
										params:{
											catid: node.id
										}
									});
								}
							},
							failure: function(res, opts){
								
							}
						});
					}
			    }
			}
		});
		gridStore2.on('beforeload', function(){
			gridStore2.baseParams = {
				catid: node.id
			}
		});
		gridStore2.load({
			params:{
				catid: node.id
			}
		});
		var win2 = new Ext.Window({
			  title: '폴더 권한 생성', closable:true, width:820, height:700,
			  items: [
				  new Ext.Panel({ id:'main-panel',
                      baseCls:'x-plain',
                      layout:'hbox',
                      defaults: {frame:false},
                      items:[dTree,{
			                        items:[grid,grid2]
			                    }
                    	  ]
				  })
				  
			  ], plain:true, modal:true,iconCls:'icon_doc3'
			 })
		win2.show('div');
	}
	Ext.getCmp('center').activate('center22'); //페이지 첫 로딩시 현행/연혁화면 출력
});
