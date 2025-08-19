Ext.QuickTips.init();

var dsUrlInfo;

Ext.onReady(function(){
	var frm_crRootMenu;
	var frm_crMenu;
	var frm_win;
	//컨텍스트 메뉴 필요하면 여기에
	var rootContext = new Ext.menu.Menu({
		id:'rootContextMenu',
		items:[
			{id:'root_addRootFol', cls:'icon_addRootFol', text:'최상위 분류 추가',
			handler:function(){
				frm_win = new Ext.Window({
					closable:true, width:520, autoHeight:true, plain:true, modal:true,
					items: [
						frm_crRootMenu = new Ext.FormPanel({
							url:CONTEXTPATH+'/bylaw/menu/createRootMenu.do',
							labelWidth:90, width:500, autoHeight:true, monitorValid:true,frame:true, 
							items: {
								xtype: 'fieldset', title: '최상위 분류 생성',
								items: [
									{xtype:'textfield',width:300, fieldLabel: '메뉴명', name:'MENU_TTL', id:'crMenuTitle', allowBlank:false},
									{xtype:'textfield',width:300, fieldLabel: '메뉴코드', name:'MENU_SE_NM', id:'crMenuCd', allowBlank:false},
									{xtype:'textfield',width:300, fieldLabel: '호출주소', name:'URL_INFO_CN', id:'crUrlInfo', allowBlank:false},
									{xtype: 'radiogroup', fieldLabel: '사용여부', id: 'crUseYn' ,
										itemCls: 'x-radio-group-alt', columns: 1, value:'Y',
										items: [
									        {boxLabel: '사용', inputValue:'Y', name:'USE_YN'},
									        {boxLabel: '사용안함', inputValue:'N', name:'USE_YN'}
										]
									},
									{xtype: 'radiogroup', fieldLabel: '메뉴접근권한', id: 'RLS_SCP_NM' ,
										itemCls: 'x-radio-group-alt', columns: 1, value:'P',
										items: [
										    //{boxLabel: '공통', inputValue:'C', name:'RLS_SCP_NM'},
									        {boxLabel: '사용자', inputValue:'P', name:'RLS_SCP_NM'},
									        {boxLabel: '관리자', inputValue:'Y', name:'RLS_SCP_NM'}
										]
									},
									{xtype:'hidden', name:'MENU_RLS_YN', id:'crOpenYn', value:'Y'},
									{xtype:'hidden', name:'MDFCN_PSBLTY_YN', id:'MDFCN_PSBLTY_YN', value:'N'},
									{xtype:'hidden', name:'UP_MENU_YN', id:'UP_MENU_YN', value:'Y'},
								]
							},
							buttons: [
								{ 
								text: '저 장', formBind: true, handler: function(){
									frm_crRootMenu.getForm().submit({
										method: 'POST',
										params: {
											menuparid:'0',
											gbn:'FOLDER'
										},
										waitTitle: '처리중 ...',
										waitMsg: '자료를 저장중입니다....',
										success: function(form, action){
											Ext.Msg.alert('Status', '항목이 정상적으로 생성되었습니다.', function(btn, text){
							  					if (btn == 'ok'){
						                        	var result = action.result;
													treeMM.root.reload();
													frm_win.close();
						                   		}
								        	});
										},
										failure: function(form, action){
						
										}
									});
								}
							}
						]		//buttons 끝
					})			//frm_crRootMenu 끝
				]});			//frm_win 끝
				frm_win.show(Ext.getBody());
			}}
		]
	});
	
	var docContext = new Ext.menu.Menu({
		id:'docContextmenu',
		items:[
			{id:'doc_deleteMenu', cls:'icon_deleteMenu', text:'메뉴삭제',
			handler:function(){
				var node = treeMM.getSelectionModel().getSelectedNode();
				var parNode = node.parentNode;
				var path = parNode.getPath();
				var menuId = node.id;
				if(parNode.id==0){
					//TODO
					//정말 지울껀지 confirm 상자
				}
				Ext.Ajax.request({
					url: CONTEXTPATH+'/bylaw/menu/deleteMenu.do',
					params: {
						job: "deleteMenu",
						menuid: menuId
					},
					success: function(res, opts){
						var result = Ext.decode(res.responseText);
						Ext.MessageBox.alert('결과','정삭적으로 삭제 되었습니다.'); 
						treeMM.root.reload();
						treeMM.expandPath(path);
					},
					failure: function(res,opts){
						Ext.MessageBox.alert('서버에러','서버와의 통신이 원활하지 않습니다.');  
						return false;
					}
				});	
			}}		
		]
	});
	
	var folContext = new Ext.menu.Menu({
		id:'folContextMenu',
		items:[
			{id:'fol_createMenu', cls:'icon_createMenu', text:'새 항목 추가',
			handler:function(){
				var node = treeMM.getSelectionModel().getSelectedNode();
				var pMenuName = node.attributes.MENU_TTL;
				var menuParId = node.id;
				var MENU_SE_NM = node.attributes.MENU_SE_NM;
				frm_win = new Ext.Window({
					closable:true, width:520, autoHeight:true, plain:true, modal: true,
					items:[
						frm_crMenu = new Ext.FormPanel({
							url:CONTEXTPATH+'/bylaw/menu/createRootMenu.do',
							labelWidth:90, width:500, autoHeight:true, monitorValid:true,frame:true, 
							items: {
								xtype: 'fieldset', title: '새 항목 생성',
								items: [
									{xtype:'textfield', width:300, fieldLabel:'상위그룹명', name:'pMenuTitle', id:'crPMenuTitle', readOnly:true, value:pMenuName},
									{xtype:'textfield',width:300, fieldLabel: '메뉴명', name:'MENU_TTL', id:'crMenuTitle', allowBlank:false},
									{xtype:'combo', width:150, fieldLabel:'URL 정보',name:'urlCombo',forceSelection:true, id:'crUrlCombo',
										triggerAction: 'all', lazyRender:true,
										store:dsUrlInfo, displayField:'MENU_TTL', valueField:'URL_INFO_CN', editable:false,
										listeners:{
											beforerender:function(){
												dsUrlInfo.on('beforeload', function(){
													dsUrlInfo.baseParams = {
														job:'getUrl'
													}
												});
											},
											select:function(combo, record, index){
												Ext.getCmp('crUrlInfo').setValue(record.get('URL_INFO_CN'));
												Ext.getCmp('crMenuCd').setValue(record.get('MENU_SE_NM'));
											}
										}
									},
									{xtype: 'radiogroup', fieldLabel: '폴더여부', id: 'crGbn' ,
										itemCls: 'x-radio-group-alt', columns: 2, value:'DOC',
										items: [
									        {boxLabel: '폴더', inputValue:'FOLDER', name:'FLDR_SE'},
									        {boxLabel: '메뉴', inputValue:'DOC', name:'FLDR_SE'}
										]
									},
									{xtype: 'radiogroup', fieldLabel: '공개여부', id: 'crOpenYn' ,
										itemCls: 'x-radio-group-alt', columns: 2, value:'Y',
										items: [
									        {boxLabel: '공개', inputValue:'Y', name:'MENU_RLS_YN'},
									        {boxLabel: '공개안함', inputValue:'N', name:'MENU_RLS_YN'}
										]
									},									
									{xtype: 'radiogroup', fieldLabel: '사용여부', id: 'crUseYn' ,
										itemCls: 'x-radio-group-alt', columns: 2, value:'Y',
										items: [
									        {boxLabel: '사용', inputValue:'Y', name:'USE_YN'},
									        {boxLabel: '사용안함', inputValue:'N', name:'USE_YN'}
										]
									},
									{xtype: 'radiogroup', fieldLabel: '메뉴접근권한', id: 'RLS_SCP_NM' ,
										itemCls: 'x-radio-group-alt', columns: 2, value:'P',
										items: [
										    //{boxLabel: '공통', inputValue:'C', name:'RLS_SCP_NM'},
									        {boxLabel: '사용자', inputValue:'P', name:'RLS_SCP_NM'},
									        {boxLabel: '관리자', inputValue:'Y', name:'RLS_SCP_NM'}
										]
									},
									{xtype:'hidden', name:'menuid', id:'crMenuId'},
									//{xtype:'hidden', name:'gbn', id:'crGbn'},
									{xtype:'hidden', name:'URL_INFO_CN',id:'crUrlInfo'},
									{xtype:'hidden', name:'MENU_SE_NM', id:'crMenuCd'}	,
									{xtype:'hidden', name:'MENU_RLS_YN', id:'crOpenYn', value:'Y'},
									{xtype:'hidden', name:'MDFCN_PSBLTY_YN', id:'MDFCN_PSBLTY_YN', value:'N'}
								]
							},
							buttons: [
								{ 
								text: '저 장', formBind: true, handler: function(){
									var path = node.getPath();
									frm_crMenu.getForm().submit({
										method: 'POST',
										params: {
											job:'createMenu',
											UP_MENU_MNG_NO:menuParId,
											UP_MENU_YN:'N'
										},
										waitTitle: '처리중 ...',
										waitMsg: '자료를 저장중입니다....',
										success: function(form, action){
											Ext.Msg.alert('Status', '항목이 정상적으로 생성되었습니다.', function(btn, text){
							  					if (btn == 'ok'){
						                        	var result = action.result;
													treeMM.root.reload();
													frm_win.close();
													treeMM.expandPath(path+'/'+result.data.menuid);
					                       		}
								        	});
										},
										failure: function(form, action){
					
										}
									});
								}
							}
						]
					})				
				]});	
				frm_win.show(Ext.getBody());								
			}},
			{id:'fol_modMenu', cls:'icon_modStruc', text:'폴더정보수정',
			handler:function(){
				var node = treeMM.getSelectionModel().getSelectedNode();
				var parNode = node.parentNode;
				var MENU_TTL = node.attributes.MENU_TTL;
				var pMenuName = parNode.attributes.title;
				var MDFCN_PSBLTY_YN = node.attributes.MDFCN_PSBLTY_YN;
				var UP_MENU_YN = node.attributes.UP_MENU_YN;
				var RLS_SCP_NM = node.attributes.RLS_SCP_NM;
				var MENU_SE_NM = node.attributes.MENU_SE;
				var path = node.getPath();
				var menuId = node.id;
				var MENU_RLS_YN = node.attributes.MENU_RLS_YN;
				var USE_YN = node.attributes.USE_YN;
				var frm_modSubMenu;
				frm_win = new Ext.Window({
					closable:true, width:520, autoHeight:true, plain:true, modal: true,
					items:[
						frm_modSubMenu = new Ext.FormPanel({
							url:CONTEXTPATH+'/bylaw/menu/modSubFolder.do',
							labelWidth:90, width:500, autoHeight:true, monitorValid:true,frame:true, 
							items: {
								xtype: 'fieldset', title: '폴더정보 수정',
								items: [
									{xtype:'textfield', width:300, fieldLabel:'상위그룹명', name:'pMenuTitle', id:'modPMenuTitle', readOnly:true, value:pMenuName},
									{xtype:'textfield',width:300, fieldLabel: '메뉴명', name:'MENU_TTL', id:'modMenuFolder', allowBlank:false, value:MENU_TTL},
									{xtype: 'radiogroup', fieldLabel: '공개여부', id: 'crOpenYn' ,
										itemCls: 'x-radio-group-alt', columns: 1, value:[MENU_RLS_YN],
										items: [
									        {boxLabel: '공개', inputValue:'Y', name:'MENU_RLS_YN'},
									        {boxLabel: '공개안함', inputValue:'N', name:'MENU_RLS_YN'}
										]
									},
									{xtype: 'radiogroup', fieldLabel: '사용여부', id: 'modFolUseYn' ,
										itemCls: 'x-radio-group-alt', columns: 1, value:[USE_YN],
										items: [
									        {boxLabel: '사용', inputValue:'Y', name:'USE_YN'},
									        {boxLabel: '사용안함', inputValue:'N', name:'USE_YN'}
										]
									},
									{xtype: 'radiogroup', fieldLabel: '메뉴접근권한', id: 'creroletype' ,
										itemCls: 'x-radio-group-alt', columns: 1, value:[RLS_SCP_NM],
										items: [
										    {boxLabel: '공통', inputValue:'C', name:'RLS_SCP_NM'},
									        {boxLabel: '사용자', inputValue:'P', name:'RLS_SCP_NM'},
									        {boxLabel: '관리자', inputValue:'Y', name:'RLS_SCP_NM'}
										]
									},
									{xtype:'hidden', name:'MDFCN_PSBLTY_YN', id:'MDFCN_PSBLTY_YN', value:MDFCN_PSBLTY_YN},
									{xtype:'hidden', name:'UP_MENU_YN', id:'UP_MENU_YN', value:UP_MENU_YN}
								]
							},
							buttons: [
								{ 
								text: '저 장', formBind: true, handler: function(){
									var path = node.getPath();
									frm_modSubMenu.getForm().submit({
										method: 'POST',
										params: {
											job:'modSubFolder',
											MENU_MNG_NO:menuId
										},
										waitTitle: '처리중 ...',
										waitMsg: '자료를 저장중입니다....',
										success: function(form, action){
											Ext.Msg.alert('Status', '항목이 정상적으로 생성되었습니다.', function(btn, text){
							  					if (btn == 'ok'){
						                        	var result = action.result;
													treeMM.root.reload();
													frm_win.close();
													treeMM.expandPath(path);
					                       		}
								        	});
										},
										failure: function(form, action){
					
										}
									});
								}
							}
						]
					})				
				]});
				frm_win.show(Ext.getBody());	
				Ext.getCmp('modPMenuTitle').setDisabled();
			}
			},
			{id:'fol_deleteMenu', cls:'icon_deleteFol', text:'폴더삭제',
			handler:function(){
				var node = treeMM.getSelectionModel().getSelectedNode();
				var parNode = node.parentNode;
				var path = parNode.getPath();
				var menuId = node.id;
				Ext.Ajax.request({
					url: CONTEXTPATH+'/bylaw/menu/deleteMenu.do',
					params: {
						menuid : menuId
					},
					success: function(res, opts){
						var result = Ext.util.JSON.decode(res.responseText);
						Ext.MessageBox.alert(result.msgT,result.msg); 
						if(result.result=="OK"){
							treeMM.root.reload();
							treeMM.expandPath(path);						
						}
					},
					failure: function(res,opts){
						Ext.MessageBox.alert('서버에러','서버와의 통신이 원활하지 않습니다.');  
						return false;
					}
				});					
			}}
		]
	});
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
			nodeType: 'async', text:'메뉴관리',title:'메뉴관리', draggable:false, id: '0', cls:'menuRoot',
			listeners:{
				contextmenu:function(node,e){
					node.select();
					rootContext.showAt(e.getXY());
				}
			}
		},
		listeners: {
			click: function(node, e){
				node.select();
				var nodeKind = node.attributes.cls;
				setMenuInfo(node);
				Ext.getCmp('frmButSubmit').setDisabled(false);
			},
			beforenodedrop : function(e){
				var point = e.point;
				var node = e.dropNode;
				var pNode = node.parentNode;
				var targetNode = e.target;
				var menuId = node.id;
				var pNodeId = '';
				if(point=='below' || point=='above'){
					pNodeId = targetNode.parentNode.id;
				}else if(point=='append'){
					pNodeId = targetNode.id;
				}
				if(pNode.id == 0){
					Ext.MessageBox.alert('에러','최상위 분류는 이동하실 수 없습니다.');
					return false;
				}else if(pNodeId==0){
					Ext.MessageBox.alert('에러','일반폴더/메뉴는 최상위 분류로 이동할 수 없습니다.');
					return false;
				}				
			},
			// e.point : above - target의 위로 이동 / below - target의 아래로 이동 / append - 다른 폴더로 이동
			nodedrop: function(e){
				var node = e.dropNode;
				var pNode = node.parentNode;
				var menuId = node.id;
				var menuParId = pNode.id;
				var ord = pNode.indexOf(node);
				var oldOrd = node.attributes.MENU_SORT_SEQ;
				var point = e.point;
				var path = pNode.getPath();
				var MENU_SE_NM = node.attributes.MENU_SE_NM;
				var idx = node.attributes.IDX;
				Ext.Ajax.request({
					url: CONTEXTPATH+'/bylaw/menu/moveNode.do',
					params: {
						menuid: menuId,
						menuparid : menuParId,
						ord : ord+1
					},
					success: function(res, opts){
						var result = Ext.util.JSON.decode(res.responseText);
						if(result.cnt>0){
							Ext.MessageBox.alert('결과','메뉴가 성공적으로 이동되었습니다..'); 
							treeMM.root.reload();
							treeMM.expandPath(path);
						}else{
							Ext.MessageBox.alert('에러','메뉴 이동중 에러가 발생하였습니다.');  
						}
					},
					failure: function(res,opts){
						Ext.MessageBox.alert('서버에러','서버와의 통신이 원활하지 않습니다.');  
						return false;
					}
				});					
			},
			contextmenu: function(node, e){
				node.select();
				var nodeKind = node.attributes.cls;
				var menuId = node.id;
				//메뉴관리 최상위 분류가 추가되면 아래 menuId 구분 조건에 추가 필요
				if(nodeKind == 'folder' &&(menuId==10000000 || menuId==10000001 || menuId==10000002 || menuId==10000003 || menuId ==10000181 )){
					node.select();
					folContext.items.get('fol_createMenu').show();
					folContext.items.get('fol_modMenu').hide();
					folContext.items.get('fol_deleteMenu').show();					
					folContext.showAt(e.getXY());
				}else if(nodeKind == 'folder'){
					node.select();
					folContext.items.get('fol_createMenu').show();
					folContext.items.get('fol_modMenu').show();
					folContext.items.get('fol_deleteMenu').show();					
					folContext.showAt(e.getXY());					
				}else if(nodeKind == 'doc' || nodeKind == 'menuLeafDis'){
					node.select();
					docContext.showAt(e.getXY());
				}
			},
			expandnode:function(node){
//				if (node.attributes.cls == 'dept') {
//					node.getUI().addClass('deptOpen');
//				}					
			},
			collapsenode:function(node){
//				if(node.attributes.cls=='dept'){
//					node.getUI().removeClass('deptOpen');
//				}				
			}
		}
	});
	
	treeMM.getRootNode().expand();
	function setMenuInfo(node){
		var nodeInfo = node.attributes;
		if(nodeInfo.cls =='folder'){
			return false;
		}
		Ext.getCmp('modMenuTitle').setValue(nodeInfo.MENU_TTL);
		var URL_INFO_CN = nodeInfo.MENU_TTL;
		
		Ext.getCmp('modUrlCombo').setValue(nodeInfo.MENU_TTL);			
		Ext.getCmp('modUrlInfo').setValue(nodeInfo.URL_INFO_CN);
		Ext.getCmp('modUseYn').setValue(nodeInfo.USE_YN);
		Ext.getCmp('modOpenYn').setValue(nodeInfo.MENU_RLS_YN);
		Ext.getCmp('modMenuId').setValue(node.id);
		Ext.getCmp('modGbn').setValue(nodeInfo.GBN);
	}
});
