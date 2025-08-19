Ext.onReady(function(){

	dsUrlInfo = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/menu/getUrlInfo.do'
		}),
		reader:new Ext.data.JsonReader({root:'result',idProperty: 'MENU_MNG_NO'},['MENU_MNG_NO','UP_MENU_MNG_NO','MENU_TTL','MENU_SE_NM','URL_INFO_CN'])
	});
	var frm_mod = new Ext.FormPanel({
		url:CONTEXTPATH+'/bylaw/menu/updateMenu.do',
		labelWidth:90, width:500, autoHeight:true, frame:true,
		items: {
			xtype: 'fieldset', title: '메뉴정보 수정',
			items: [
				{xtype:'textfield',width:300, fieldLabel: '메뉴명', name:'MENU_TTL', id:'modMenuTitle', allowBlank:false},
				{xtype:'combo', width:150, fieldLabel:'URL 정보',name:'urlCombo',forceSelection:true, id:'modUrlCombo',
					triggerAction: 'all', lazyRender:true,
					store:dsUrlInfo, displayField:'MENU_TTL', valueField:'URL_INFO_CN', editable:true,
					listeners:{
						beforerender:function(){
							dsUrlInfo.on('beforeload', function(){
								dsUrlInfo.baseParams = {
									job:'getUrl'
								}
							});
						},
						select:function(combo, record, index){
							Ext.getCmp('modUrlInfo').setValue(record.get('url'));
							Ext.getCmp('modMenuCd').setValue(record.get('MENU_SE_NM'));
						}
					}
				},
				{xtype: 'radiogroup', fieldLabel: '공개여부', id: 'modOpenYn' ,
					itemCls: 'x-radio-group-alt', columns: 1, values:['Y'],
					items: [
				        {boxLabel: '공개', inputValue:'Y', name:'MENU_RLS_YN'},
				        {boxLabel: '공개안함', inputValue:'N', name:'MENU_RLS_YN'}
					]
				},
				{xtype: 'radiogroup', fieldLabel: '사용여부', id: 'modUseYn' ,
					itemCls: 'x-radio-group-alt', columns: 1, values:['Y'],
					items: [
				        {boxLabel: '사용', inputValue:'Y', name:'USE_YN'},
				        {boxLabel: '사용안함', inputValue:'N', name:'USE_YN'}
					]
				},
				{xtype: 'radiogroup', fieldLabel: '메뉴접근권한', id: 'roletypeM' ,
					itemCls: 'x-radio-group-alt', columns: 1, value:'P',
					items: [
					    //{boxLabel: '공통', inputValue:'C', name:'RLS_SCP_NM'},
				        {boxLabel: '사용자', inputValue:'P', name:'RLS_SCP_NM'},
				        {boxLabel: '관리자', inputValue:'Y', name:'RLS_SCP_NM'}
					]
				},
				{xtype:'hidden', name:'MENU_MNG_NO', id:'modMenuId'},
				{xtype:'hidden', name:'gbn', id:'modGbn'},
				{xtype:'hidden', name:'MENU_SE_NM', id:'modMenuCd'},
				{xtype:'hidden', name:'URL_INFO_CN',id:'modUrlInfo'}

			]
		},
		buttons: [
			{
			text: '저 장',id:'frmButSubmit', formBind: true, iconCls:'icon_save', handler: function(){
				var node = treeMM.getSelectionModel().getSelectedNode();

				if(!node){
					Ext.MessageBox.alert('에러','수정하실 항목을 선택헤 주세요.');
					return false;
				}
				var path = node.getPath();
				frm_mod.getForm().submit({
					method: 'POST',
					params: {
						job:'updateMenu'
					},
					waitTitle: '처리중 ...',
					waitMsg: '자료를 저장중입니다....',
					success: function(form, action){
						Ext.Msg.alert('Status', '정보가 정상적으로 수정되었습니다.', function(btn, text){
		  					if (btn == 'ok'){
	                        	var result = action.result;
								treeMM.root.reload();
								treeMM.expandPath(path);
								Ext.getCmp('frmButSubmit').setDisabled(true);

                       		}
			        	});
					},
					failure: function(form, action){
						Ext.Mag.alert('정보','에러가 발생하였습니다. 다시 시도해주세요.');
					}
				});
			}
			}
		]
	});

    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [new Ext.BoxComponent({ // raw
            region: 'north',
            el: 'topMenuHolder',
            height: 75
        }), {
            region: 'west', contentEl: 'menuList', id: 'm_list', title: "메뉴 관리",
            split: true, width: 240, minSize: 175, maxSize: 400, collapsible: true,
            margins: '0 0 0 5', layout: 'accordion', layoutConfig: { animate: true },
            iconCls: 'manageMenu', autoScroll: true
        }, new Ext.TabPanel({
            id: 'm_section', region: 'center', deferredRender: false, activeTab: 0,
            margins: '0 5 0 0',
            items: [{
                id: 'm_mod', contentEl: 'modMenuInfo', title: '메뉴 정보수정', autoScroll: true,
				padding: '10 0 0 10', items:[frm_mod], iconCls : 'icon_curDocRev'
            }
		]
        }), new Ext.BoxComponent({
            id:'bot_info', region: 'south', el: 'infoArea', height: 20
		})
		]
    });
});
