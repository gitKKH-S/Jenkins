function getRuleKey(key){
	//if(key == '전체관리자'){
	//    key = 'Y';
	//}else if(key == '자치법규총괄권한'){
	//    key = 'H';
	//}else if(key == '자문관리권한'){
	//    key = 'J';
	//}else if(key == '소송관리권한'){
	//    key = 'C';
	//}else if(key == '협약관리권한'){
	//    key = 'A';
	//}else if(key == '자문접수담당자'){
	//    key = 'K';
	//}else{
	//	key = '';
	//}
	
	if(key == '전체관리자'){
		key = 'Y';
	} else if (key == '소송관리권한'){
		key = 'C';
	} else if (key == '소송접수권한'){
		key = 'L';
	} else if (key == '자문관리권한'){
		key = 'J';
	} else if (key == '자문접수권한'){ 
		key = 'M';
	} else if (key == '협약관리권한'){
		key = 'A';
	} else if (key == '협약접수권한'){
		key = 'N';
	} else if (key == '인지대/송달료권한'){
		key = 'B';
	} else if (key == '소송비용권한'){
		key = 'D';
	} else if (key == '소송비용회수권한'){
		key = 'E';
	} else if (key == '자문료권한'){
		key = 'F';
	} else if (key == '과장권한'){
		key = 'G';
	} else if (key == '법률고문담당권한'){
		key = 'I';
	} else if (key == '자문팀장권한'){
		key = 'Q';
	} else if (key == '협약팀장권한'){
		key = 'R';
	} else {
		key = '';
	}
	
	return key;
}
var isManagercom;
Ext.onReady(function(){
	var dsDept = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/user/getDeptName.do'
		}),
		reader:new Ext.data.JsonReader({root:'result'},['DEPT_NM','DEPT_NO'])
	});
	
	// Generic fields array to use in both store defs.
	var fields = [
		{name: 'EMP_NM',   mapping : 'EMP_NM'},
		{name: 'EMP_NO',   mapping : 'EMP_NO'},
		{name: 'e_mailCR', mapping : 'e_mailCR'},
		{name: 'DEPT_NM',  mapping : 'DEPT_NM'},
		{name: 'DEPT_NO',  mapping : 'DEPT_NO'},
		{name: 'teamname', mapping : 'teamname'}
	];
	
	var gridStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/user/userList.do'
		}),
		reader:new Ext.data.JsonReader({root:'records'},['EMP_NM','EMP_NO','e_mailCR','DEPT_NM','teamname','DEPT_NO'])
	});
	
	// Column Model shortcut array
	var cols = [
		{header:"부서명", width:230, sortable:true, dataIndex:'DEPT_NM'},
		{header:"성 명",  width:50,  sortable:true, dataIndex:'EMP_NM', id:'name'},
		{header:"사번",   width:70,  sortable:true, dataIndex:'EMP_NO' }
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
		region           : 'west',
		title            : '직원 목록',
		iconCls          : 'icon_perlist',
		selModel         : new Ext.grid.RowSelectionModel({singleSelect : true}),
		tbar:[
			{
				xtype:'textfield', width:180, fieldLabel:'search', name:'schText', id:'schText',
				emptyText:'부서명이나 이름을 입력해주세요...', enableKeyEvents:true,
				listeners:{
					keydown :function(el, e){
						if(e.getKey() == 13) {
							var schTxt = Ext.getCmp('schText').getValue();
							gridStore.on('beforeload', function(){
								gridStore.baseParams = {
									job: 'userList',
									schTxt : schTxt
									//Deptcd : Ext.getCmp('deptNameCOM').getValue()
								}
							});
							gridStore.load({
								params:{
								
								}
							});
						}
					}
				}
			},'->',
			new Ext.Button ({
				id:'butSch', text:'<b>검색</b>', iconCls:'byprogress',
				listeners:{
					click:function(btn, eObj){
						var schTxt = Ext.getCmp('schText').getValue();
						gridStore.on('beforeload', function(){
							gridStore.baseParams = {
								job: 'userList',
								schTxt : schTxt
								//Deptcd : Ext.getCmp('deptNameCOM').getValue()
							}
						});
						gridStore.load({
							params:{
							
							}
						});
					}
				}
			})
		],
		listeners:{
			render:function(cmp){
				
			}
		}
	});
	
	// Declare the text fields.  This could have been done inline, is easier to read
	// for folks learning :)
	
	var userName = new Ext.form.TextField({
		fieldLabel : '성 명 ',
		name:'EMP_NM', width:250, allowBlank:false, id:'EMP_NM'
	});
	
	var sabun = new Ext.form.TextField({
		fieldLabel : '아이디 ',
		name:'EMP_NO', width:250, allowBlank:false, id:'EMP_NO'
	});
	
	var pwd = new Ext.form.TextField({
		fieldLabel : '패스워드 ',
		name:'pwd', width:250, allowBlank:false, id:'pwdCR'
	});
	
	var Email = new Ext.form.TextField({
		fieldLabel : 'e-mail ',
		name:'e_mail', width:250, allowBlank:false, id:'e_mailCR'
	});
	
	// Setup the form panel
	var formPanel = new Ext.form.FormPanel({
		url:CONTEXTPATH+'/bylaw/user/createUser.do',
		region       : 'center',
		title        : '사용자 등록 화면',
		bodyStyle    : 'padding: 10px; background-color: #DFE8F6',
		iconCls      : 'icon_creuser',
		labelWidth   : 90,
		width        : 700,
		autoHeight   : true,
		monitorValid : true,
		frame        : true,
		items:{
			xtype:'fieldset', id:'fieldsetid', title:'새 사용자 등록',
			items:[
				userName,
				sabun,
				{
					xtype:'combo', width:250, fieldLabel:'소속부서', name:'DEPT_NM', id:'DEPT_NM',
					typeAhead:true, triggerAction:'all', lazyRender:true, editable:false,
					store:dsDept, displayField:'DEPT_NM', valueField:'DEPT_NO',
					listeners:{
						beforerender:function(){
							dsDept.on('beforeload', function(){
								dsDept.baseParams = {
									job:'getDeptName'
								}
							});
						},
						select:function(cb, data, idx){
							Ext.getCmp('DEPT_NO').setValue(data.get('DEPT_NO'));
							Ext.getCmp('DEPT_NM').setValue(data.get('DEPT_NM').split('&nbsp;').join(''));
						}
					}
				},
				//Email,
				{xtype:'hidden', name:'DEPT_NO',  id:'DEPT_NO'},
				{xtype:'hidden', name:'position', id:'teamname'}
			]
		},
		buttons: [
			{
				text:'등 록', formBind:false, iconCls:'icon_save',
				handler: function(){
					var node = treeMM.getSelectionModel().getSelectedNode();
					var path;
					if(node){
						path = node.parentNode.getPath();
					}
					
					if(Ext.getCmp('EMP_NM').getValue() == ''){
						alert("이름을 입력하세요.");
						return;
					}
					
					if(Ext.getCmp('EMP_NO').getValue() == ''){
						alert("사번을 입력하세요.");
						return;
					}
					
					if(Ext.getCmp('DEPT_NO').getValue() == ''){
						alert("부서선택은 필수 입니다.");
						return;
					}
					
					formPanel.getForm().submit({
						method: 'POST',
						waitTitle: '처리중 ...',
						waitMsg: '자료를 저장중입니다....',
						success: function(form, action){
							Ext.Msg.alert('Status', '정보가 정상적으로 등록되었습니다.', function(btn, text){
								if (btn == 'ok'){
									var result = action.result;
									treeMM.root.reload();
									treeMM.expandPath('/ROLE/'+result.data.MNGR_AUTHRT_CD+'/'+result.data.MNGR_MNG_NO);
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
	
	isManagercom = function(){
		var itemsInGroup = [];
		$.ajax({
			type: 'POST',
			url: CONTEXTPATH+'/bylaw/user/getNodes.do',
			data : {
				node : 'ROLE'
			},
			async: false,
			success: function(data) {
				var jdata = JSON.parse(data);
				for(i=0; i<jdata.length; i++){
					var val = getRuleKey(jdata[i].CD_NM);
					itemsInGroup.push( {
						boxLabel: jdata[i].CD_NM,
						name: 'MNGR_AUTHRT_NM',
						inputValue: val,
						id : jdata[i].CD_MNG_NO
					});
				}
			}
		});
		
		var grp = new Ext.form.RadioGroup({
			fieldLabel: '사용자등급',
			columns: 2,
			id:'is_managerCR',
			name:'is_managerCR',
			itemCls: 'x-radio-group-alt', columns: 2, value:['Y'],
			items:itemsInGroup
		});
		
		var grp2 = new Ext.form.RadioGroup({
			fieldLabel: '사용자등급',
			columns: 2,
			id:'is_managerCR2',
			name:'is_managerCR2',
			itemCls: 'x-radio-group-alt', columns: 2, value:['Y'],
			items:itemsInGroup
		
		});
		
		Ext.getCmp('fieldsetid').add(grp);
		Ext.getCmp('fieldsetid2').add(grp2);
		formPanel.doLayout();
	}
	
	//Simple 'border layout' panel to house both grids
	var displayPanel = new Ext.Panel({
		width    : 870,
		//height   : 440,
		height   : 515,
		layout   : 'border',
		renderTo : 'panel',
		items    : [
			grid,
			formPanel
		]
	});

	// used to add records to the destination stores
	var blankRecord =  Ext.data.Record.create(fields);
	
	/****
	* Setup Drop Targets
	***/
	
	// This will make sure we only drop to the view container
	var formPanelDropTargetEl =  formPanel.body.dom;
	
	var formPanelDropTarget = new Ext.dd.DropTarget(formPanelDropTargetEl, {
		ddGroup     : 'gridDDGroup',
		notifyEnter : function(ddSource, e, data) {
			//Add some flare to invite drop.
			formPanel.body.stopFx();
			formPanel.body.highlight();
		},
		notifyDrop  : function(ddSource, e, data){
			// Reference the record (single selection) for readability
			var selectedRecord = ddSource.dragData.selections[0];
			// Load the record into the form
			formPanel.getForm().loadRecord(selectedRecord);
			// Delete record from the grid.  not really required.
			//ddSource.grid.store.remove(selectedRecord);
			return(true);
		}
	});
	
	var frm_modInfo = new Ext.FormPanel({
		url:CONTEXTPATH+'/bylaw/user/updateUser.do',
		labelWidth:90, width:500, autoHeight:true, monitorValid:true,frame:true,
		items: {
			xtype: 'fieldset',id:'fieldsetid2', title: '사용자 정보 수정',
			items: [
				{xtype:'textfield', width:300, fieldLabel:'성 명', name:'MNGR_EMP_NM', id:'MNGR_EMP_NM', allowBlank:false},
				{xtype:'textfield', width:300, fieldLabel:'사 번', name:'EMP_NO',      id:'EMP_NOMOD',   allowBlank:false},
				{
					xtype:'combo', width:250, fieldLabel:'소속부서', name:'DEPT_NM', id:'deptNameMOD',
					typeAhead: true, triggerAction: 'all', lazyRender:true, editable:false,
					store:dsDept, displayField:'DEPT_NM', valueField:'DEPT_NO',
					listeners:{
						//renderer:function(value,meta,record){
						//	value = gridStore.getAt(value-1).data['name'];
						//	alert(value);
						//	return '';
						//},
						beforerender:function(){
							dsDept.on('beforeload', function(){
								dsDept.baseParams = {
									job:'getDeptName'
								}
							});
						},
						select:function(cb, data, idx){
							Ext.getCmp('codeIdMOD').setValue(data.get('DEPT_NO'));
						}
					}
				},
				//{xtype:'textfield',width:300, fieldLabel: 'e-mail', name:'e_mail', id:'e_mail', allowBlank:false},
				{xtype:'hidden', name:'MNGR_MNG_NO', id:'MNGR_MNG_NO'},
				{xtype:'hidden', name:'DEPT_NO',     id:'codeIdMOD'},
				{xtype:'hidden', name:'position',    id:'teamnameMOD'}
			]
		},
		buttons: [
			{
				text: '저 장', formBind: true, iconCls:'icon_save',
				handler: function(){
					frm_modInfo.getForm().submit({
						method: 'POST',
						params: {
							job:'updateUser'
						},
						waitTitle: '처리중 ...',
						waitMsg: '자료를 저장중입니다....',
						success: function(form, action){
							Ext.Msg.alert('Status', '정보가 정상적으로 수정되었습니다.', function(btn, text){
								if (btn == 'ok'){
									var result = action.result;
									treeMM.root.reload();
									treeMM.expandPath('/ROLE/'+result.data.MNGR_AUTHRT_CD+'/'+result.data.MNGR_MNG_NO);
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
	
	isManagercom();
	var viewport = new Ext.Viewport({
		layout: 'border',
		items: [
			new Ext.BoxComponent({ // raw
				region: 'north',
				el: 'topMenuHolder',
				height: 75
			}),
			{
				region: 'west', contentEl: 'userList', id: 'u_list', title: "사용자 목록",
				split: true, width: 240, minSize: 175, maxSize: 400, collapsible: true,
				margins: '0 0 0 5', layout: 'accordion', layoutConfig: { animate: true },
				iconCls: 'manageUser', autoScroll: true
			},
			new Ext.TabPanel({
				id: 'u_section', region: 'center', deferredRender: false, activeTab: 0,
				margins: '0 5 0 0',
				items: [
					{id: 'u_info', contentEl: 'userInfo', title: '사용자 정보', html: '<p>규정관리메뉴 사용자를 관리하는 페이지입니다.</p>', autoScroll: true, iconCls : 'icon_infoUser'}, 
					{
						id: 'u_mod', contentEl: 'modUserInfo', title: '사용자 정보수정', autoScroll: true, padding:'10 0 0 10',
						items:[frm_modInfo], iconCls : 'icon_updateUser',
						listeners:{
							//activate(Panel p)
							activate:function(p){
							
							}
						}
					},
					{id:'u_create', contentEl:'createUser', title:'새 사용자 등록', autoScroll: true, padding:'10 0 0 10', iconCls: 'icon_createUser'}
				]
			}),
			new Ext.BoxComponent({
				id:'bot_info', region: 'south', el: 'infoArea', height: 20
			})
		]
	});
});
