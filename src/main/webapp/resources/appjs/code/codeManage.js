
var codeExp='';
Ext.onReady(function(){
    //버튼너비, 세퍼레이터 추가
	
	//grid 하단 버튼
	var botToolbar = new Ext.Toolbar({
        renderTo: 'gridButton',
        items: [
			{xtype: 'tbfill'},'-',
			new Ext.Button({
				text:'새 항목 작성', iconCls:'newCode',
				handler:function(){
var dsCodeExp = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({
		url: CONTEXTPATH + '/bylaw/code/getCodeCombo.do'
	}),
	reader: new Ext.data.JsonReader({
		root: 'result', idProperty: 'id'
	}, ['id', 'CD_LCLSF_KORN_NM', 'CD_LCLSF_ENG_NM'])
});
var dsOrd = new Ext.data.Store({
	proxy:new Ext.data.HttpProxy({
		url:CONTEXTPATH+'/bylaw/code/getOrd.do'
	}),
	reader:new Ext.data.JsonReader({
		root:'result'},['ordVal', 'SORT_SEQ']
	)
});
var rowData = gridCodeMan.getSelectionModel().getSelected();
var treeData = treeMM.getSelectionModel().getSelectedNode();
var codeName = 'BOOKCD';
if(rowData){
	codeName = rowData.get('CD_LCLSF_KORN_NM');
}else if(treeData){
	codeName = treeData.attributes.CODENAME;
}
var ord;
var frm_creCode = new Ext.FormPanel({
	url:CONTEXTPATH+'/bylaw/code/createCode.do',
	labelWidth:80, width:382, autoHeight:true, monitorValid:true,frame:true,
	items: {
		xtype: 'fieldset', title: '코드정보 생성',
		items: [
			{xtype:'combo',width:210, fieldLabel:'코드분류', name:'Codeexp', allowBlank:false, value:codeExp,
				triggerAction:'all', lazyRender:true,store:dsCodeExp, displayField:'codeExp',valueField:'codeExp',
				listeners:{
					beforerender:function(){
						dsCodeExp.on('beforeload', function(){
							dsCodeExp.baseParams = {
								job:'getCodeCombo'
							}
						});
					},
					//select : ( Ext.form.ComboBox combo, Ext.data.Record record, Number index )
					select:function(combo, record, index){
						var cName = Ext.getCmp('creCodeName');
						cName.setValue(record.get('codeName'));
					}
				}
			},
			{xtype:'textfield',width:230, fieldLabel: '코드명', name:'Code', allowBlank:false},
			{xtype: 'radiogroup', fieldLabel: '사용여부', itemCls: 'x-radio-group-alt', columns: 1,
				items: [
			        {boxLabel: '사용', name: 'Useyn', inputValue:'Y', checked:true},
			        {boxLabel: '사용안함', name: 'Useyn', inputValue:'N'}
				]
			},
			{xtype:'combo', id:'m_ord', width:50, fieldLabel:'정렬순서',name:'ord2',
				typeAhead: false, triggerAction: 'all', lazyRender:true,
				store:dsOrd,displayField:'ord',valueField:'ordVal',emptyText:'Select a state...',
				listeners:{
					beforerender:function(){
						dsOrd.on('beforeload', function(){
							dsOrd.baseParams = {
								job:'getOrd', codeName:codeName, stat:'CRE'
							}
						});
					},
					select:function(combo, record, index){
						ord = combo.value;
					}
				}
			},
			{xtype:'hidden',id:'creCodeName', name:'Codename'}
		]
	},
	buttons: [
		{
		text: '등록', formBind: true, handler: function(){
			var codeName2 = codeName;
			var ord_cur = smCode;
			frm_creCode.getForm().submit({
				method: 'POST',
				params: {
					job:'createCode',
					codeName2:codeName2,
					ord:ord
				},
				waitTitle: 'Connecting',
				waitMsg: '자료를 저장중입니다....',
				success: function(form, action){
					Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
	  					if (btn == 'ok'){
                        	var result = Ext.util.JSON.decode(action.response.responseText);
							var codeName = result.data.codeName;
						dsCode.on('beforeload', function(){
							dsCode.baseParams = {
								job: 'getList',
								codename: codeName
							}
						});
						dsCode.load({
							params:{
								start:0, limit:pageSize
							}
						});
	                        frm_window.close();
                   		}
		        	});
				},
				failure: function(form, action){
					Ext.Msg.alert('error', '서버와의 통신에 문제가 있습니다.잠시후에 다시 시도해주세요.');
				}
			});
		}
		}
	]
});
var frm_crePLCode = new Ext.FormPanel({
	url:CONTEXTPATH+'/bylaw/code/createCode.do',
	labelWidth:80, width:382, autoHeight:true, monitorValid:true,frame:true,
	items: {
		xtype: 'fieldset', title: '코드정보 생성',
		items: [
			{xtype:'textfield', id:'tfCrCodeExp', width:230, fieldLabel:'코드분류', name:'Codeexp', allowBlank:false , value:codeExp, readOnly:true},
			{xtype:'datefield',width:230, fieldLabel: '업데이트일', name:'Code',format:'Y.m.d', allowBlank:false},
			{xtype: 'radiogroup', fieldLabel: '사용여부', itemCls: 'x-radio-group-alt', columns: 1,
				items: [
			        {boxLabel: '사용', name: 'Useyn', inputValue:'Y', checked:true},
			        {boxLabel: '사용안함', name: 'Useyn', inputValue:'N'}
				]
			},
			{xtype:'combo', id:'m_ord', width:50, fieldLabel:'정렬순서',name:'ord',
				typeAhead: false, triggerAction: 'all', lazyRender:true,
				store:dsOrd,displayField:'ord',valueField:'ordVal',
				listeners:{
					beforerender:function(){
						dsOrd.on('beforeload', function(){
							dsOrd.baseParams = {
								job:'getOrd', codeName:codeName, stat:'CRE'
							}
						});
					},
					select:function(combo, record, index){
						ord = combo.value;
					}
				}
			},
			{xtype:'hidden',id:'creCodeName', name:'Codename'}
		]
	},
	buttons: [
		{
		text: '등록', formBind: true, handler: function(){
			var codeName2 = codeName;
			var ord_cur = smCode;
			frm_crePLCode.getForm().submit({
				method: 'POST',
				params: {
					job:'createCode',
					codeName2:codeName2,
					ord:ord
				},
				waitTitle: 'Connecting',
				waitMsg: '자료를 저장중입니다....',
				success: function(form, action){
					Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
	  					if (btn == 'ok'){
                        	var result = Ext.util.JSON.decode(action.response.responseText);
							var codeName = result.data.codeName;
						dsCode.on('beforeload', function(){
							dsCode.baseParams = {
								job: 'getList',
								codename: codeName
							}
						});
						dsCode.load({
							params:{
								start:0, limit:pageSize
							}
						});
	                        frm_window.close();
                   		}
		        	});
				},
				failure: function(form, action){
					Ext.Msg.alert('error', '서버와의 통신에 문제가 있습니다.잠시후에 다시 시도해주세요.');
				}
			});
		}
		}
	]
});
var frm_window;
if(codeName=='JOB'){
	frm_window = new Ext.Window({
		closable:true, width:400, autoHeight:true,
		items: [frm_crePLCode], plain:true, modal:true
	});

}else{
	if (codeName=='LAW'){
		frm_window = new Ext.Window({
			title:'작성불가',
			closable:true, width:250, height:50,
			plain:true, modal:true,
			html:"<a>법령정보는 여기서 작성할 수 없습니다.</a>"
		});
	}else{
		frm_window = new Ext.Window({
			closable:true, width:400, autoHeight:true,
			items: [frm_creCode], plain:true, modal:true
		});
	}
}
frm_window.show(Ext.getBody());

				}
		})]
	});

    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [new Ext.BoxComponent({ // raw
            region: 'north',
            el: 'topMenuHolder',
            height: 75
        }), {
            region: 'west', contentEl: 'codeTree', id: 'c_tree', title: "코드 목록",
            split: true, width: 240, minSize: 175, maxSize: 400, collapsible: true,
            margins: '0 0 0 5', layout: 'accordion', layoutConfig: { animate: true },
            iconCls: 'manageCode', autoScroll: true
        }, new Ext.BoxComponent({
			id:'c_section',region: 'center', el: 'gridHolder',
			width:900
        }), new Ext.BoxComponent({
            id:'bot_info', region: 'south', el: 'infoArea', height: 20
		})
		]
    });
});
